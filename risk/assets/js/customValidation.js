$(document).ready(function(){
  //Form validation. Checks all input fields for correctness.
  $('.form-signin').validate({
    rules: {
      firstName: {
        required: true
      },
      lastName: {
        required: true
      },
      username: {
        minlength: 3,
        required: true
      },
      password: {
        minlength: 6,
        required: true
      },
      confirmation: {
        minlength: 6,
        equalTo: "#password"
      }
    },
    success: function(element){
      element.text('OK').addClass('valid');
    }
  });
});
