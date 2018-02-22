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


    //Dot nav
    var pagescrollPosition = [];
    $('.page-scroll').each(function() {
        pagescrollPosition.push($(this).offset().top);
    });

    $('#dot-nav ul li a').click(function(){
        $('html, body').animate({
            scrollTop: $( $(this).attr('href') ).offset().top
    }, 500);
        return false;
    });

    $('#dot-nav ul li').click(function () {
        $('#dot-nav ul li').removeClass('active');
        $(this).addClass('active');
    });

    $(document).scroll(function(){
       var position = $(document).scrollTop(), index;
        for (var i=0; i<pagescrollPosition.length; i++) {
            if (position <= pagescrollPosition[i]) {
                index = i;
                break;
            }
        }
        $('#dot-nav ul li').removeClass('active');
        $('#dot-nav ul li:eq('+index+')').addClass('active');
    });

        $('#dot-nav ul li').click(function () {
        $('#dot-nav ul li').removeClass('active');
            $(this).addClass('active');
    });

    // Change title color when scrolled
    $(window).scroll(function() {
        var scroll = $(window).scrollTop();
        if(scroll > 250 && scroll < 2600){
            $('.learn-more-title').addClass('text-white');
        } else {
            $('.learn-more-title').removeClass('text-white');
        }

        if(scroll > 2200) {
            $('.collaborate-securely-parallax .img-fluid').addClass('img-parallax-none');
        } else {
            $('.collaborate-securely-parallax .img-fluid').removeClass('img-parallax-none');
        }

    });



// End
});
