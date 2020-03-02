$(document).on('click', '.edit-profile', function(){
	$('#updateProfile').modal('show');
});

$(document).on('click', '.reset-password', function(){
	$('#updatePasswordForm')[0].reset();
	$('#updatePassword').modal('show');
});