$(document).ready(function() {

    $('[data-toggle="popover"]').popover({
        container: 'body',
        html: true,
        placement: 'right',
        trigger: 'hover',
        title: function() {
            return $(this).parent().find('.popover-title').html();
        },
        content: function() {
            return $(this).parent().find('.popover-content').html();
        }
    });

    //Footer
    var $window = $(window),
    $footer = $('.footer');

    function resize() {
        if ($window.width() < 576) {
            return $footer.removeClass('justify-content-center');
        }
        else {
            return $footer.addClass('justify-content-center');
        }
    }

    $window
        .resize(resize)
        .trigger('resize');


    //Homepage img animation
    $(window).scroll(function(){
        if($(window).scrollTop() >= 400){
          $('.crunch-interface').addClass('animated fadeInUp');
          $('.crunch-interface').removeClass('hidden');
        }
    });

});
