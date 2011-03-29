$(document).ready(function() {

	// Date picker
	$("#start_date").datepicker({ dateFormat: 'yy-mm-dd' });
	$("#end_date").datepicker({ dateFormat: 'yy-mm-dd' });

 // All day toggle
 $('#all_day').click(function() {
  // Don't show time
  $("label[for='start_time']").toggle();
  $('#start_time').toggle();

  $("label[for='end_time']").toggle();
  $('#end_time').toggle();
 });
});
