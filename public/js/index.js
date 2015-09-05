// Generated by CoffeeScript 1.10.0
(function() {
  var create_vimrc_conetns_json, post_vimrc, update_vimrc;

  $("#setting-btn").click(function() {
    var connection_id, vimrc_contents;
    connection_id = $('#connection_id').val();
    vimrc_contents = create_vimrc_conetns_json();
    return $.when(start_loading(), post_vimrc(connection_id, vimrc_contents)).done(function() {
      return stop_loading();
    });
  });

  create_vimrc_conetns_json = function() {

    /* 
    json形式
    {
      "connection_id": "xxxxxxxxx",
      "vimrc_contents": {
        "colorcheme": "molokai", // colorcheme molokai
        "number": true,          // set number
        "ruler": false,          // when value is false, skip
        "history": 100,          // set history=100
        "encoding": "utf-8"      // set encoding=utf-8
      }
    }
     */
    var results;
    results = {};
    $(".vimrc-contents:not(.genre-fixed)").map(function() {
      var key, val;
      key = $(this).attr('name');
      val;
      if (key === "colorscheme") {
        if ($(this).prop('checked')) {
          val = $(this).val();
          results[key] = val;
        }
        return;
      }
      if ($(this).attr('type') === 'checkbox') {
        if ($(this).prop('checked')) {
          val = true;
        } else {
          val = false;
        }
        results[key] = val;
        return;
      }
      val = $(this).val();
      return results[key] = val;
    });
    return results;
  };

  post_vimrc = function(id, vimrc_contents) {
    var defer;
    console.log("start post_vimrc");
    defer = $.Deferred();
    $.ajax({
      type: "POST",
      url: "/api/vimrc",
      contentType: "application/json",
      dataType: "json",
      data: JSON.stringify({
        "connection_id": id,
        "vimrc_contents": vimrc_contents
      }),
      success: function(data) {
        return $.when(window.butterfly.reload_vim(), update_vimrc(id)).done(function() {
          console.log("done post_vimrc");
          return defer.resolve();
        });
      }
    });
    return defer.promise();
  };

  update_vimrc = function(connection_id) {
    var defer;
    defer = $.Deferred();
    $.ajax({
      type: "GET",
      url: "/api/vimrc/" + connection_id,
      dataType: "json",
      success: function(data) {
        var vimrc_html;
        vimrc_html = data.vimrc.replace(/(\n|\r)/g, "<br />");
        $("#vimrc-preview p").html(vimrc_html);
        return defer.resolve();
      },
      error: function(data) {
        return alert("Fail to reload vimrc: " + data.message);
      }
    });
    return defer.promise();
  };

  this.start_loading = function() {
    console.log("start loading");
    $("#terminal").css("visibility", "hidden");
    return $.blockUI({
      message: '<h1 class="loading-message">now loading...</h1>',
      css: {
        border: 'none',
        padding: '15px',
        backgroundColor: 'transparent',
        '-webkit-border-radius': '10px',
        '-moz-border-radius': '10px',
        opacity: 1,
        color: '#fff'
      }
    });
  };

  this.stop_loading = function() {
    console.log("stop loading");
    $("#terminal").css("visibility", "visible");
    return $.unblockUI();
  };

  $('.programing-lang').change(function() {
    var cmd, ext;
    ext = $(this).val();
    cmd = "export vimfactory_ext=" + ext;
    start_loading();
    window.butterfly.reload_vim(cmd);
    return setTimeout(function() {
      return stop_loading();
    }, 2000);
  });

}).call(this);
