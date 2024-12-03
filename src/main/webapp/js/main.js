(function ($) {
    "use strict";
    
    // Spinner
    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 1);
    };
    spinner();
    
    // Back to top button
    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            $('.back-to-top').fadeIn('slow');
        } else {
            $('.back-to-top').fadeOut('slow');
        }
    });
    
    $('.back-to-top').click(function () {
        $('html, body').animate({scrollTop: 0}, 1500, 'easeInOutExpo');
        return false;
    });
    
    // Sidebar Toggler
    $('.sidebar-toggler').click(function () {
        $('.sidebar, .content').toggleClass("open");
        return false;
    });
    
    // Progress Bar
    $(window).scroll(function() {
        $('.pg-bar').each(function() {
            var elementOffset = $(this).offset().top; // Posición del elemento
            var windowScroll = $(window).scrollTop() + $(window).height(); // Posición actual del scroll

            // Si el elemento está visible en la ventana
            if (elementOffset < windowScroll * 0.9) {
                $('.progress .progress-bar').each(function() {
                    $(this).css("width", $(this).attr("aria-valuenow") + '%');
                });
            }
        });
    });
    
    // Calender
    /*$('#calender').datetimepicker({
        inline: true,
        format: 'L'
    });
    
    // Testimonials carousel
    $(".testimonial-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1000,
        items: 1,
        dots: true,
        loop: true,
        nav: false
    });*/
    
})(jQuery);
