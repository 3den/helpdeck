function ajaxMessage(msg, type){
    $("#ajax_message").clearQueue();
    $("#ajax_message").html('<p class="'+ type +' rounded box_shadow">'+ msg +'</p>');
    $("#ajax_message").delay(1000).show('drop', {
        direction: "up"
    }, "slow", function (){
        ajax_loading(false);
        $("#ajax_message").delay(5000).hide("drop", {
            direction: "up"
        }, "slow");
    });
}
function add_tinymce_to(el){
    $(el).tinymce({
        script_url: '/tiny_mce/tiny_mce.js',
        theme: "advanced",
        convert_urls: false,
        custom_undo_redo_keyboard_shortcuts : true,

        theme_advanced_buttons1:  "bold,italic,underline,strikethrough," +
        "separator,undo,redo," +
        "separator,bullist,numlist",
        //"separator,link,unlink",
        theme_advanced_buttons2: "",
        theme_advanced_buttons3: "",

        theme_advanced_toolbar_location: "top"
    });
}
function ajax_loading(state){
    if(state){
        $("form input").attr("disabled", "disabled");
        $("body").addClass("ajax_loading");
        $("#ajax_loading").show("drop",{
            direction: "up"
        })
    }else{
        $("form input").removeAttr("disabled");
        $("body").removeClass("ajax_loading");
        $("#ajax_loading").hide("drop",{
            direction: "up"
        })
    }    
}

$(function(){
    $(".search input[type=text]").live('keyup', function(){
        $(".search input[type=text]").val($(this).val());
    });

    // Ajax loading
    $("form[data-remote=true]").live('submit', function(){
        ajax_loading(true);
        return true;
    });

    // Auto hide notices
    $(".messages p").delay(7000).hide('drop', {
        direction: "up"
    }, "slow");
});