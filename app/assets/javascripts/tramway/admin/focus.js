$(document).ready(function() {
  const url = new URL(window.location.href);
  const focusElementSelector = url.searchParams.get('focus');
  if (!$(focusElementSelector).offset() == undefined) {
    $(window).scrollTop($(focusElementSelector).offset().top);
  }
});
