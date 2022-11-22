//= require tramway/application
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require ckeditor/init
//= require clipboard
//= require_tree .

$(document).ready(function() {
  let clipboard = new Clipboard('.clipboard-btn');
  $(function () {
    $('[data-toggle="popover"]').popover()
  })
})
