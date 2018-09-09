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

function update_text_val(self) {
  document.getElementById('progress-text').innerHTML = self.value + '%';
  if(self.value == "100") {
    document.getElementById('submit-ticket').innerHTML = "Mark as DONE <i class='fas fa-check'></i>";
    document.getElementById('submit-ticket').classList.add("btn-success");
    document.getElementById('submit-ticket').classList.remove("btn-info");
  }
  else {
    document.getElementById('submit-ticket').innerHTML = "Update";
    document.getElementById('submit-ticket').classList.add("btn-info");
    document.getElementById('submit-ticket').classList.remove("btn-success");
  }
}

$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip();
});
