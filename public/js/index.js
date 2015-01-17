//vimrc設定ボタンを押した際の動作
$("#btn-vimrc-setting").click(function(event){
  
  var results = [];
   
  $(".vimrc-contents:checked").map(function(){
  
    results.push($(this).attr('name'));

  });
  
  console.log(results);
  
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

