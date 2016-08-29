$(function() {
   $('.portfolio-entry').each(function() {
      var $this = $(this),
          href = $this.find('a').attr('href');
      $this.find('.portfolio-image').click(function() {
          window.location.href = href;
      })
   });
});
