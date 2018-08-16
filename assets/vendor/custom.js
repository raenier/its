function reveal(id){
  var passfield = document.getElementById(id);
    if (passfield.type === "password") {
        passfield.type = "text";
    } else {
        passfield.type = "password";
    }
}

function match() {
  if (document.getElementById('user_password').value ==
    document.getElementById('user_password_confirm').value) {
    document.getElementById('errmessage').style.color = 'green';
    document.getElementById('errmessage').innerHTML = 'matching';
    document.getElementById('submit_user').removeAttribute('disabled');
  }
  else {
    document.getElementById('errmessage').style.color = 'red';
    document.getElementById('errmessage').innerHTML = 'not matching';
    document.getElementById('submit_user').disabled='disabled';
  }
}
