//vimrc設定ボタンを押した際の動作
$("#setting-btn").click(function(event){
  /*
   * json形式
  {
    "filepath": "/path/to/.vimrc",
    "vimrc_contents": {
      "number": true,     // set number
      "ruler": false,     // set noruler
      "history": 100,     // set history=100
      "encoding": "utf-8" // set encoding=utf-8
    }
  }
  */

  var results = {};
   
  $(".vimrc-contents").map(function(){
  
    var key = $(this).attr('name');
    var val; 

    //チェックボックスなら
    if($(this).attr('type')=='checkbox'){

      if($(this).prop('checked')){
        val = true;
      }else{
        val = false;
      }
    
    //それ以外(input type=text)
    }else{
      val = $(this).val();
    }

    results[key] = val;

  });
  
  //console.log(JSON.stringify({"filepath": "/tmp/hoge.txt", "contents": results}))
  
   
  $.ajax({
    type: "POST",
    url: "http://192.168.33.100:9292/api/vimrc",
    contentType: "application/json",
    dataType: "json",
    data: JSON.stringify({"filepath": "/tmp/hoge.txt", "contents": results}),
    success: function(data) {
      console.log("succe");
      console.log(data);
    },
    error: function(data) {
      console.log("err");
      console.log(data);
    },
  });
  
  
});

