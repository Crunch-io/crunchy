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

    // Smooth Scrolling
    $('a[href*="#"]')

      .not('[href="#"]')
      .not('[href="#0"]')
      .click(function(event) {

        if (
          location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
          &&
          location.hostname == this.hostname
        ) {

          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');

          if (target.length) {

            event.preventDefault();
            $('html, body').animate({
              scrollTop: target.offset().top
            }, 1000, function() {
              var $target = $(target);
              $target.focus();
              if ($target.is(":focus")) {
                return false;
              } else {
                $target.attr('tabindex','-1');
                $target.focus();
              };
            });
          }
        }
      });

      //Dots
      var pagescrollPosition = [];

      $('.page-scroll').each(function() {
          pagescrollPosition.push($(this).offset().top);
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


    // Wow animations
    wow = new WOW({
     boxClass:     'wow',
     animateClass: 'animated',
     offset:       0,
     mobile:       false,
     live:         true
   })
   wow.init();

// End
});
