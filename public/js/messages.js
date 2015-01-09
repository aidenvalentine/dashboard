// Add listener for redraw menu when windows resized
window.onresize = MessagesMenuWidth;
$(document).ready(function() {
	// Add class for correctly view of messages page
	$('#content').addClass('full-content');
	// Run script for change menu width
	MessagesMenuWidth();
	$('#content').on('click','[id^=msg-]', function(e){
		e.preventDefault();
		$('[id^=msg-]').removeClass('active');
		$(this).addClass('active');
		$('.one-list-message').slideUp('fast');
		$('.'+$(this).attr('id')+'-item').slideDown('fast');
	});
	$('html').animate({scrollTop: 0},'slow');
});