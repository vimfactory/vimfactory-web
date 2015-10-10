# vimrc設定ボタンを押した際の動作
$("#setting-btn").click ->
  connection_id = $('#connection_id').val()
  vimrc_contents = create_vimrc_conetns_json()

  $.when(
    start_loading(),
    post_vimrc(connection_id, vimrc_contents)
  ).done ->
    stop_loading()

create_vimrc_conetns_json = ->
  ###
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
  ###

  results = {}

  $(".vimrc-contents:not(.genre-fixed)").map ->
    key = $(this).attr('name')
    val

    #colorscheme
    if key=="colorscheme"
      if $(this).prop('checked')
        val = $(this).val()
        results[key] = val
      return

    #checkbox(true or false) type
    if $(this).attr('type') == 'checkbox'
      if $(this).prop('checked')
        val = true
      else
        val = false
      results[key] = val
      return

    #selectbox
    else if $(this).attr('type') == 'select'
      results[key] = $(this).val()
      return

  return results

post_vimrc = (id, vimrc_contents) ->
  defer = $.Deferred()
  $.ajax
    type: "POST",
    url: "/api/vimrc",
    contentType: "application/json",
    dataType: "json",
    data: JSON.stringify({"connection_id": id, "vimrc_contents": vimrc_contents}),
    success: (data) ->
      $.when(
        window.butterfly.reload_vim(),
        update_vimrc(id)
      ).done ->
        defer.resolve()

  return defer.promise();

update_vimrc = (connection_id) ->
  defer = $.Deferred()
  $.ajax
    type: "GET",
    url: "/api/vimrc/"+connection_id,
    dataType: "json",
    success: (data) ->
      vimrc_html = data.vimrc.replace(/(\n|\r)/g, "<br />")
      $("#vimrc-preview").html(vimrc_html)
      defer.resolve()
    error: (data) ->
      alert("Fail to reload vimrc: "+data.message)
  return defer.promise();


@start_loading = ->
  $("#terminal").css("visibility","hidden")
  $.blockUI
    message: '<h1 class="loading-message">now loading...</h1>',
    css:
      border: 'none',
      padding: '15px',
      backgroundColor: 'transparent',
      '-webkit-border-radius': '10px',
      '-moz-border-radius': '10px',
      opacity: 1,
      color: '#fff'


@stop_loading = ->
  $("#terminal").css("visibility","visible")
  $.unblockUI()


$('.programing-lang').change ->
  ext = $(this).val()
  cmd = "export vimfactory_ext="+ext
  start_loading()
  window.butterfly.reload_vim(cmd)
  setTimeout ->
    stop_loading()
  ,2000
