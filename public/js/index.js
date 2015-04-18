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
      //vim reload
      $("#console").append("<div class=\"vim-reloading\"></div>");
      $("#console > .window").hide();
      tty.socket.emit('data', terminal_id, "\x1b\x1b:wq\r");
      setTimeout(function(){
        //start vim
        tty.socket.emit('data', terminal_id, "vim\r")
        setTimeout(function(){
          $("#console > .window").show();
          $(".vim-reloading").hide();
        },500)
      },500);
    },
    error: function(data) {
    },
  });

});
