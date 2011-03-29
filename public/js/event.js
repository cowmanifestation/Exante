$(document).ready(function() {
    
    // Date picker
    $("#start_date").datepicker({dateFormat: 'yy-mm-dd'});
    $("#end_date").datepicker({dateFormat: 'yy-mm-dd'});
    
    // All day toggle
    $('#all_day').click(function(){
        $("#to-date-time").toggle();
    });
});