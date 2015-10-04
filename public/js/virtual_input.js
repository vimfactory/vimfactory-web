// Generated by CoffeeScript 1.10.0
(function() {
  var alt, ctrl, first, virtualInput;

  if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
    ctrl = false;
    alt = false;
    first = true;
    virtualInput = document.createElement('input');
    virtualInput.type = 'password';
    virtualInput.style.position = 'fixed';
    virtualInput.style.top = 0;
    virtualInput.style.left = 0;
    virtualInput.style.border = 'none';
    virtualInput.style.outline = 'none';
    virtualInput.style.opacity = 0;
    virtualInput.value = '0';
    document.body.appendChild(virtualInput);
    virtualInput.addEventListener('blur', function() {
      return setTimeout(((function(_this) {
        return function() {
          return _this.focus();
        };
      })(this)), 10);
    });
    addEventListener('click', function() {
      return virtualInput.focus();
    });
    addEventListener('touchstart', function(e) {
      if (e.touches.length === 2) {
        return ctrl = true;
      } else if (e.touches.length === 3) {
        ctrl = false;
        return alt = true;
      } else if (e.touches.length === 4) {
        ctrl = true;
        return alt = true;
      }
    });
    virtualInput.addEventListener('keydown', function(e) {
      butterfly.keyDown(e);
      return true;
    });
    virtualInput.addEventListener('input', function(e) {
      var len;
      len = this.value.length;
      if (len === 0) {
        e.keyCode = 8;
        butterfly.keyDown(e);
        this.value = '0';
        return true;
      }
      e.keyCode = this.value.charAt(1).charCodeAt(0);
      if ((ctrl || alt) && !first) {
        e.keyCode = this.value.charAt(1).charCodeAt(0);
        e.ctrlKey = ctrl;
        e.altKey = alt;
        if (e.keyCode >= 97 && e.keyCode <= 122) {
          e.keyCode -= 32;
        }
        butterfly.keyDown(e);
        this.value = '0';
        ctrl = alt = false;
        return true;
      }
      butterfly.keyPress(e);
      first = false;
      this.value = '0';
      return true;
    });
  }

}).call(this);