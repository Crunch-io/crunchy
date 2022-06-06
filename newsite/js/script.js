$(window).scroll(function() {
    if ($(this).scrollTop() > 250){
        $('.navbar').addClass("borderClass");
    }
    else{
        $('.navbar').removeClass("borderClass");
    }
});

function filterSelection(c) {
  var x, i;
  x = document.getElementsByClassName("resources-filter");
  if (c == "all-filter") c = "";
  for (i = 0; i < x.length; i++) {
    filterRemoveClass(x[i], "show-filter");
    if (x[i].className.indexOf(c) > -1) filterAddClass(x[i], "show-filter");
  }
}

// Show filtered elements
function filterAddClass(element, name) {
  var i, arr1, arr2;
  arr1 = element.className.split(" ");
  arr2 = name.split(" ");
  for (i = 0; i < arr2.length; i++) {
    if (arr1.indexOf(arr2[i]) == -1) {
      element.className += " " + arr2[i];
    }
  }
}

// Hide elements that are not selected
function filterRemoveClass(element, name) {
  var i, arr1, arr2;
  arr1 = element.className.split(" ");
  arr2 = name.split(" ");
  for (i = 0; i < arr2.length; i++) {
    while (arr1.indexOf(arr2[i]) > -1) {
      arr1.splice(arr1.indexOf(arr2[i]), 1);
    }
  }
  element.className = arr1.join(" ");
}

$(document).ready(function() {

    // Resources filter
    filterSelection("all-filter")

    var btnContainer = document.getElementById("resources-filter-container");
    if (btnContainer) {
        var btns = btnContainer.getElementsByClassName("btn-filter");
        for (var i = 0; i < btns.length; i++) {
          btns[i].addEventListener("click", function(){
            var current = document.getElementsByClassName("active-filter");
            current[0].className = current[0].className.replace(" active-filter", "");
            this.className += " active-filter";
          });
        }
    }

    //Popover
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

    // Gets the video src from the data-src on each button
    var $videoSrc;
    $('.video-btn').click(function() {
        $videoSrc = $(this).data( "src" );
    });

    $('#myModal').on('shown.bs.modal', function (e) {
        $("#video").attr('src',$videoSrc + "?autoplay=1&amp;modestbranding=1&amp;showinfo=0" );
    })

    $('#myModal').on('hide.bs.modal', function (e) {
        $("#video").attr('src',$videoSrc);
    })

    // Hidden elements of accordion that ar active
    var accordionTargets;
    $("#accordion-container button").on("click",function(e){
      accordionTargets = $(this).data("target");
      $(accordionTargets).on('show.bs.collapse', function (e) {
        jQuery(".hide.collapse.show").collapse('hide');
      })
    });

// End
});
