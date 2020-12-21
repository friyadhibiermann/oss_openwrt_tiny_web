$(document).ready(function(){
  $('form#home').hide();
  $("form#loginForm").submit(function() { // loginForm is submitted
    var username = $('#username').attr('value'); // get username
    var password = $('#password').attr('value'); // get password
    if (username && password) { // values are not empty
      $.ajax({
        type: "POST",
        url: "/cgi-bin/oss", // URL of the Perl script
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        // send username and password as parameters to the Perl script
        data: "auth=" + "json" + "&username=" + username + "&password=" + password,
        // script call was *not* successful
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          $('div#loginResult').text("responseText: " + XMLHttpRequest.responseText
            + ", textStatus: " + textStatus
            + ", errorThrown: " + errorThrown);
          $('div#loginResult').addClass("error");
        }, // error
        // script call was successful
        // data contains the JSON values returned by the Perl script
        success: function(data){
          if (data.error) { // script returned error
            $('div#loginResult').text("data.error: " + data.error);
            $('div#loginResult').addClass("error");
          } // if
          else if ( data.username == username ) { // login was successful
            $('form#loginForm').hide();
            $('div#loginResult').text("data.success: " + data.success
              + ", data.username: " + data.username);
            if ( data.success == 1 ) {
                //window.location.assign("/cgi-bin/oss?gui=yes")

                window.location.href = '/cgi-bin/oss?gui=yes';
            }
            $('body').html(data);
            //if ( data.success == 1 ) {
            //}
          } //else
        }// success
      });
    } // if
    else {
      $('div#loginResult').text("enter username and password");
      $('div#loginResult').addClass("error");
    } // else
    $('div#loginResult').fadeIn();
    return false;
  });
});
