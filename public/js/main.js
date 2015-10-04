// Generated by CoffeeScript 1.10.0
(function() {
  var $, cols, openTs, quit, rows,
    slice = [].slice;

  cols = rows = null;

  quit = false;

  openTs = (new Date()).getTime();

  $ = document.querySelectorAll.bind(document);

  jQuery("#open").click(function() {
    var ctl, id, lastData, observe_terminal, observer, queue, send, t_queue, term, terminal_content, treat, ws, wsUrl;
    jQuery("#welcome").addClass("hide");
    jQuery("body").css("background-image", "url('')");
    jQuery("#main").removeClass("hide");
    send = function(data) {
      return ws.send('S' + data);
    };
    ctl = function() {
      var args, params, type;
      type = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      params = args.join(',');
      if (type === 'Resize') {
        return ws.send('R' + params);
      }
    };
    if (location.protocol === 'https:') {
      wsUrl = 'wss://';
    } else {
      wsUrl = 'ws://';
    }
    id = document.getElementById('connection_id').value;
    start_loading();
    terminal_content = null;
    observe_terminal = function() {
      if (terminal_content !== jQuery('#terminal .line').text()) {
        if (terminal_content !== null) {
          stop_loading();
          clearInterval(observer);
        }
        return terminal_content = jQuery('#terminal .line').text();
      }
    };
    observer = setInterval(observe_terminal, 1000);
    wsUrl += document.location.host + '/ws' + location.pathname + '?id=' + id;
    ws = new WebSocket(wsUrl);
    ws.addEventListener('open', function() {
      console.log("WebSocket open", arguments);
      ws.send('R' + term.cols + ',' + term.rows);
      return openTs = (new Date()).getTime();
    });
    ws.addEventListener('error', function() {
      return console.log("WebSocket error", arguments);
    });
    lastData = '';
    t_queue = null;
    queue = '';
    ws.addEventListener('message', function(e) {
      if (t_queue) {
        clearTimeout(t_queue);
      }
      queue += e.data;
      if (term.stop) {
        queue = queue.slice(-10 * 1024);
      }
      if (queue.length > term.buffSize) {
        return treat();
      } else {
        return t_queue = setTimeout(treat, 1);
      }
    });
    treat = function() {
      term.write(queue);
      if (term.stop) {
        term.stop = false;
        term.body.classList.remove('stopped');
      }
      return queue = '';
    };
    ws.addEventListener('close', function() {
      console.log("WebSocket closed", arguments);
      setTimeout(function() {
        term.write('Closed');
        term.skipNextKey = true;
        return term.body.classList.add('dead');
      }, 1);
      quit = true;
      if ((new Date()).getTime() - openTs > 60 * 1000) {
        return open('', '_self').close();
      }
    });
    term = new Terminal(document.body, send, ctl);
    addEventListener('beforeunload', function() {
      if (!quit) {
        return 'This will exit the terminal session';
      }
    });
    term.ws = ws;
    window.butterfly = term;
    window.bench = function(n) {
      var rnd;
      if (n == null) {
        n = 100000000;
      }
      rnd = '';
      while (rnd.length < n) {
        rnd += Math.random().toString(36).substring(2);
      }
      console.time('bench');
      console.profile('bench');
      term.write(rnd);
      console.profileEnd();
      return console.timeEnd('bench');
    };
    return window.cbench = function(n) {
      var rnd;
      if (n == null) {
        n = 100000000;
      }
      rnd = '';
      while (rnd.length < n) {
        rnd += "\x1b[" + (30 + parseInt(Math.random() * 20)) + "m";
        rnd += Math.random().toString(36).substring(2);
      }
      console.time('cbench');
      console.profile('cbench');
      term.write(rnd);
      console.profileEnd();
      return console.timeEnd('cbench');
    };
  });

}).call(this);