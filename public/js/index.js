//vimrc設定ボタンを押した際の動作
$("#setting-btn").click(function(event){
  /*
   * json形式
  {
    "container_id": "xxxxxxxxx",
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
  var id = $("#terminal-body .terminal div:first").text().substr(5,12);
   
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
      return; 
    }

    //値がある形式
    val = $(this).val();
    results[key] = val;

  });
  
  console.log(JSON.stringify({"id": id, "vimrc_contents": results}))
  
  $.ajax({
    type: "POST",
    url: "/api/vimrc",
    contentType: "application/json",
    dataType: "json",
    data: JSON.stringify({"id": id, "vimrc_contents": results}),
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

$(window).load(function() {
      //実行する内容
      //$('#open').trigger("click");
});

