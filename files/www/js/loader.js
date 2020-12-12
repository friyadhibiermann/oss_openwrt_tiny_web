$(function () { 
  // Toggle loading container when ajax call
  var loadingContainer = $('#loading-container', this.el);
  loadingContainer.ajaxStart(function () {
    loadingContainer.show();
  });
  loadingContainer.ajaxStop(function () {
    loadingContainer.hide();
  });
  // Ajax call
  $.getJSON('https://api.github.com/users/maxparm', function (response) {
    $('#content-container').html('Response ajax call: ' + response.name);
  });
});
