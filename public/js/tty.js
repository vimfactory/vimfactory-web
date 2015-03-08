 /**
  * tty.js
  * Copyright (c) 2012-2013, Christopher Jeffrey (MIT License)
  */

;(function() {

/**
 * Elements
 */

var document = this.document
  , window = this
  , root
  , body
  , open;


/**
 * Helpers
 */

var EventEmitter = Terminal.EventEmitter
  , inherits = Terminal.inherits
  , on = Terminal.on
  , off = Terminal.off
  , cancel = Terminal.cancel;

/**
 * tty
 */

var tty = new EventEmitter;

/**
 * Shared
 */

tty.socket;
tty.windows;
tty.terms;
tty.elements;

/**
 * Open
 */

tty.open = function() {
  if (document.location.pathname) {
    var parts = document.location.pathname.split('/')
      , base = parts.slice(0, parts.length - 1).join('/') + '/'
      , resource = base.substring(1) + 'socket.io';

    tty.socket = io.connect(null, { resource: resource });
  } else {
    tty.socket = io.connect();
  }

  tty.windows = [];
  tty.terms = {};

  tty.elements = {
    root: document.documentElement,
    body: document.getElementById('terminal-body'),
    open: document.getElementById('open'),
  };

  root = tty.elements.root;
  body = tty.elements.body;
  open = tty.elements.open;

  if (open) {
    on(open, 'click', function() {
      //mosuke add
      $("#welcome").addClass("hide");
      $("body").css( "background-image", "url('')" );
      $("#main-content").removeClass("hide");

      // tty.socket.emit('tmp_id', $("#tmp_id").val());
      tty.socket.emit('tmp_id', $("#connection_id").val());

      new Window;
    });
  }

  /* mosuke
  if (lights) {
    on(lights, 'click', function() {
      tty.toggleLights();
    });
  }
  */

  tty.socket.on('connect', function() {
    tty.reset();
    tty.emit('connect');
  });

  tty.socket.on('data', function(id, data) {
    if (!tty.terms[id]) return;
    tty.terms[id].write(data);
    
    //mosuke add
    terminal_id = id;
  });

  tty.socket.on('kill', function(id) {
    if (!tty.terms[id]) return;
    tty.terms[id]._destroy();
  });

  // XXX Clean this up.
  tty.socket.on('sync', function(terms) {

    tty.reset();

    var emit = tty.socket.emit;
    tty.socket.emit = function() {};

    Object.keys(terms).forEach(function(key) {
      var data = terms[key]
        , win = new Window
          tab = win.tabs[0];

      delete tty.terms[tab.id];
      tab.pty = data.pty;
      tab.id = data.id;
      tty.terms[data.id] = tab;
      win.resize(data.cols, data.rows);
      tab.setProcessName(data.process);
      tty.emit('open tab', tab);
      tab.emit('open');
    });
    
    tty.socket.emit = emit;
  });

  // We would need to poll the os on the serverside
  // anyway. there's really no clean way to do this.
  // This is just easier to do on the
  // clientside, rather than poll on the
  // server, and *then* send it to the client.
  setInterval(function() {
    var i = tty.windows.length;
    while (i--) {
      if (!tty.windows[i].focused) continue;
      tty.windows[i].focused.pollProcessName();
    }
  }, 2 * 1000);

  // Keep windows maximized.
  on(window, 'resize', function() {
    var i = tty.windows.length
      , win;

    while (i--) {
      win = tty.windows[i];
      if (win.minimize) {
        win.minimize();
        win.maximize();
      }
    }
  });
  

  tty.emit('load');
  tty.emit('open');
  
};

/**
 * Reset
 */

tty.reset = function() {
  var i = tty.windows.length;
  while (i--) {
    tty.windows[i].destroy();
  }

  tty.windows = [];
  tty.terms = {};

  tty.emit('reset');
};

/**
 * Lights
 */
/* mosuke
tty.toggleLights = function() {
  root.className = !root.className
    ? 'dark'
    : '';
};
*/

/**
 * Window
 */

function Window(socket) {
  var self = this;

  EventEmitter.call(this);

  var el
    , grip
    , bar
    //, button
    , title;

  el = document.createElement('div');
  el.className = 'window';

  grip = document.createElement('div');
  grip.className = 'grip';

  bar = document.createElement('div');
  bar.className = 'bar';
  
  /*
  button = document.createElement('div');
  button.innerHTML = '~';
  button.title = 'new/close';
  button.className = 'tab';
  */

  title = document.createElement('div');
  title.className = 'title';
  title.innerHTML = '';

  this.socket = socket || tty.socket;
  this.element = el;
  this.grip = grip;
  this.bar = bar;
  //this.button = button;
  this.title = title;

  this.tabs = [];
  this.focused = null;

  this.cols = Terminal.geometry[0];
  this.rows = Terminal.geometry[1];

  el.appendChild(grip);
  el.appendChild(bar);
  //bar.appendChild(button);
  bar.appendChild(title);
  body.appendChild(el);

  tty.windows.push(this);

  this.createTab();
  this.focus();
  this.bind();

  this.tabs[0].once('open', function() {
    tty.emit('open window', self);
    self.emit('open');
  });
  
  //mosuke
  //self.maximize();
}

inherits(Window, EventEmitter);

Window.prototype.bind = function() {
  var self = this
    , el = this.element
    , bar = this.bar
    , grip = this.grip
    //, button = this.button
    , last = 0;
  
  /*
  on(button, 'click', function(ev) {
    if (ev.ctrlKey || ev.altKey || ev.metaKey || ev.shiftKey) {
      self.destroy();
    } else {
      self.createTab();
    }
    return cancel(ev);
  });
  */
  
  /* mosuke resize forbit
  on(grip, 'mousedown', function(ev) {
    self.focus();
    self.resizing(ev);
    return cancel(ev);
  });
  */

  on(el, 'mousedown', function(ev) {
    if (ev.target !== el && ev.target !== bar) return;

    self.focus();

    cancel(ev);

    if (new Date - last < 600) {
      return self.maximize();
    }
    last = new Date;
    
    //mosuke drag forbid
    //self.drag(ev);

    return cancel(ev);
  });
};

Window.prototype.focus = function() {
  // Restack
  var parent = this.element.parentNode;
  if (parent) {
    parent.removeChild(this.element);
    parent.appendChild(this.element);
  }

  // Focus Foreground Tab
  this.focused.focus();

  tty.emit('focus window', this);
  this.emit('focus');
};

Window.prototype.destroy = function() {
  if (this.destroyed) return;
  this.destroyed = true;

  if (this.minimize) this.minimize();

  splice(tty.windows, this);
  if (tty.windows.length) tty.windows[0].focus();

  this.element.parentNode.removeChild(this.element);

  this.each(function(term) {
    term.destroy();
  });

  tty.emit('close window', this);
  this.emit('close');
};

Window.prototype.createTab = function() {
  return new Tab(this, this.socket);
};

Window.prototype.focusTab = function(next) {
  var tabs = this.tabs
    , i = indexOf(tabs, this.focused)
    , l = tabs.length;

  if (!next) {
    if (tabs[--i]) return tabs[i].focus();
    if (tabs[--l]) return tabs[l].focus();
  } else {
    if (tabs[++i]) return tabs[i].focus();
    if (tabs[0]) return tabs[0].focus();
  }

  return this.focused && this.focused.focus();
};

Window.prototype.nextTab = function() {
  return this.focusTab(true);
};

Window.prototype.previousTab = function() {
  return this.focusTab(false);
};

/**
 * Tab
 */

function Tab(win, socket) {
  var self = this;

  y = Math.ceil(($(window).height()-13-10)/20);
  x = Math.ceil(($(window).width()*0.65)/12);
  var cols = x
    , rows = y;

  Terminal.call(this, {
    cols: cols,
    rows: rows
  });
  
  this.id = '';
  this.socket = socket || tty.socket;
  this.window = win;
  this.element = null;
  this.process = '';
  this.open();
  this.hookKeys();

  win.tabs.push(this);

  this.socket.emit('create', cols, rows, function(err, data) {
    if (err) return self._destroy();
    self.pty = data.pty;
    self.id = data.id;
    tty.terms[self.id] = self;
    self.setProcessName(data.process);
    tty.emit('open tab', self);
    self.emit('open');
  });
};

inherits(Tab, Terminal);

// We could just hook in `tab.on('data', ...)`
// in the constructor, but this is faster.
Tab.prototype.handler = function(data) {
  this.socket.emit('data', this.id, data);
};

Tab.prototype._focus = Tab.prototype.focus;

Tab.prototype.focus = function() {
  if (Terminal.focus === this) return;

  var win = this.window;

  // maybe move to Tab.prototype.switch
  if (win.focused !== this) {
    if (win.focused) {
      if (win.focused.element.parentNode) {
        win.focused.element.parentNode.removeChild(win.focused.element);
      }
    }

    win.element.appendChild(this.element);
    win.focused = this;

    win.title.innerHTML = this.process;
  }

  this.handleTitle(this.title);

  this._focus();

  win.focus();

  tty.emit('focus tab', this);
  this.emit('focus');
};

Tab.prototype.hookKeys = function() {
  var self = this;

  // Alt-[jk] to quickly swap between windows.
  this.on('key', function(key, ev) {
    if (Terminal.focusKeys === false) {
      return;
    }

    var offset
      , i;

    if (key === '\x1bj') {
      offset = -1;
    } else if (key === '\x1bk') {
      offset = +1;
    } else {
      return;
    }

    i = indexOf(tty.windows, this.window) + offset;

    this._ignoreNext();

    if (tty.windows[i]) return tty.windows[i].highlight();

    if (offset > 0) {
      if (tty.windows[0]) return tty.windows[0].highlight();
    } else {
      i = tty.windows.length - 1;
      if (tty.windows[i]) return tty.windows[i].highlight();
    }

    return this.window.highlight();
  });

  this.on('request paste', function(key) {
    this.socket.emit('request paste', function(err, text) {
      if (err) return;
      self.send(text);
    });
  });

  this.on('request create', function() {
    this.window.createTab();
  });

  this.on('request term', function(key) {
    if (this.window.tabs[key]) {
      this.window.tabs[key].focus();
    }
  });

  this.on('request term next', function(key) {
    this.window.nextTab();
  });

  this.on('request term previous', function(key) {
    this.window.previousTab();
  });
};

Tab.prototype._ignoreNext = function() {
  // Don't send the next key.
  var handler = this.handler;
  this.handler = function() {
    this.handler = handler;
  };
  var showCursor = this.showCursor;
  this.showCursor = function() {
    this.showCursor = showCursor;
  };
};

/**
 * Program-specific Features
 */

Tab.scrollable = {
  irssi: true,
  man: true,
  less: true,
  htop: true,
  top: true,
  w3m: true,
  lynx: true,
  mocp: true
};

Tab.prototype._bindMouse = Tab.prototype.bindMouse;

Tab.prototype.bindMouse = function() {
  if (!Terminal.programFeatures) return this._bindMouse();

  var self = this;

  var wheelEvent = 'onmousewheel' in window
    ? 'mousewheel'
    : 'DOMMouseScroll';

  on(self.element, wheelEvent, function(ev) {
    if (self.mouseEvents) return;
    if (!Tab.scrollable[self.process]) return;

    if ((ev.type === 'mousewheel' && ev.wheelDeltaY > 0)
        || (ev.type === 'DOMMouseScroll' && ev.detail < 0)) {
      // page up
      self.keyDown({keyCode: 33});
    } else {
      // page down
      self.keyDown({keyCode: 34});
    }

    return cancel(ev);
  });

  return this._bindMouse();
};

Tab.prototype.pollProcessName = function(func) {
  var self = this;
  this.socket.emit('process', this.id, function(err, name) {
    if (err) return func && func(err);
    self.setProcessName(name);
    return func && func(null, name);
  });
};

Tab.prototype.setProcessName = function(name) {
  name = sanitize(name);

  if (this.process !== name) {
    this.emit('process', name);
  }

  this.process = name;

  if (this.window.focused === this) {
    // if (this.title) {
    //   name += ' (' + this.title + ')';
    // }
    //this.window.title.innerHTML = name;
  }
};

/**
 * Helpers
 */

function indexOf(obj, el) {
  var i = obj.length;
  while (i--) {
    if (obj[i] === el) return i;
  }
  return -1;
}

function splice(obj, el) {
  var i = indexOf(obj, el);
  if (~i) obj.splice(i, 1);
}

function sanitize(text) {
  if (!text) return '';
  return (text + '').replace(/[&<>]/g, '')
}

/**
 * Load
 */

function load() {
  if (load.done) return;
  load.done = true;

  off(document, 'load', load);
  off(document, 'DOMContentLoaded', load);
  tty.open();
  
}

on(document, 'load', load);
on(document, 'DOMContentLoaded', load);
setTimeout(load, 200);

/**
 * Expose
 */
tty.Window = Window;
tty.Tab = Tab;
tty.Terminal = Terminal;

this.tty = tty;

}).call(function() {
  return this || (typeof window !== 'undefined' ? window : global);
}());
