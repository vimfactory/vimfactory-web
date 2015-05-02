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

  $(".vimrc-contents").map(function(){

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

  $.ajax({
    type: "POST",
    url: "/api/vimrc",
    contentType: "application/json",
    dataType: "json",
    data: JSON.stringify({"connection_id": connection_id, "vimrc_contents": results}),
    success: function(data) {
      vim_reload();
      vimrc_reload(connection_id);
    },
    error: function(data) {
    },
  });

});

function vim_reload(){
  $("#terminal-inner").append("<div class=\"vim-reloading\"></div>");
  $("#terminal-inner .tab-content").hide();
  tty.socket.emit('data', terminal_id, "\x1b\x1b:wq\r");
  setTimeout(function(){
    //start vim
    tty.socket.emit('data', terminal_id, "vim\r")
    setTimeout(function(){
      $("#terminal-inner .tab-content").show();
      $(".vim-reloading").hide();
    },500)
  },500);
}

function vimrc_reload(connection_id){
  $.ajax({
    type: "POST",
    url: "/api/preview",
    contentType: "application/json",
    dataType: "json",
    data: JSON.stringify({"connection_id": connection_id}),
    success: function(data) {
      vimrc_html = data.vimrc.replace(/(\n|\r)/g, "<br />");
      $("#vimrc-preview p").html(vimrc_html);
    },
    error: function(data) {
      alert("Fail to reload vimrc: "+data.message);
    },
  });
}

function start_loading(){
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
    } });
}

function stop_loading(){
  $.unblockUI();
}
