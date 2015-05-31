//vimrc設定ボタンを押した際の動作
$("#setting-btn").click(function(event){
  /*
   * json形式
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
  var results = {};
  var connection_id = $('#connection_id').val();

  $(".vimrc-contents:not(.genre-fixed)").map(function(){

    var key = $(this).attr('name');
    var val;

    //colorscheme
    if(key=="colorscheme"){
      if($(this).prop('checked')){
        val = $(this).val();
        results[key] = val;
      }
      return;
    }

    //checkbox(true or false) type
    if($(this).attr('type')=='checkbox'){

      if($(this).prop('checked')){
        val = true;
      }else{
        val = false;
      }
      results[key] = val;
      return;
    }

    //値がある形式
    val = $(this).val();
    results[key] = val;

  });
  
  $.when(
    start_loading(),
    post_vimrc(connection_id, results)
  ).done(function(){
    stop_loading();
  });

});

function post_vimrc(id, vimrc_contents){
  var defer = $.Deferred();
  $.ajax({
    type: "POST",
    url: "/api/vimrc",
    contentType: "application/json",
    dataType: "json",
    data: JSON.stringify({"connection_id": id, "vimrc_contents": vimrc_contents}),
    success: function(data) {
      $.when(
        vim_reload(),
        vimrc_reload(id)
      ).done(function(){
        defer.resolve();
      });
    },
  });

  return defer.promise();
}

function vim_reload(){
  var defer = $.Deferred();
  tty.socket.emit('data', terminal_id, "\x1b\x1b:wq\r");
  setTimeout(function(){
    //start vim
    tty.socket.emit('data', terminal_id, "vim\r");
    setTimeout(function(){
      defer.resolve();
    },500);
  },500);

  return defer.promise();
}

function vimrc_reload(connection_id){
  var defer = $.Deferred();
  $.ajax({
    type: "GET",
    url: "/api/vimrc/"+connection_id,
    dataType: "json",
    success: function(data) {
      vimrc_html = data.vimrc.replace(/(\n|\r)/g, "<br />");
      $("#vimrc-preview p").html(vimrc_html);
      defer.resolve();
    },
    error: function(data) {
      alert("Fail to reload vimrc: "+data.message);
    },
  });

  return defer.promise();
}

function start_loading(){
  $("#console").css("visibility","hidden");
  $.blockUI({ 
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
}

function stop_loading(){
  $("#console").css("visibility","visible");
  $.unblockUI();
}

$('.programing-lang').change(function() {
  var ext = $(this).val();
  start_loading();
  tty.socket.emit('data', terminal_id, "\x1b\x1b:wq\r");
  setTimeout(function(){
    tty.socket.emit('data', terminal_id, "export vimfactory_ext="+ext+"&&vim\r");
    setTimeout(function(){
      stop_loading();
    },500);
  },1000);
});
