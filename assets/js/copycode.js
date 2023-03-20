(function(document) {
  document.querySelectorAll('pre.highlight').forEach(function(codeBlock) {
    let button = document.createElement('button');
    button.className = 'copy';
    button.type = 'button';
    button.ariaLabel = button.title = 'Copy code to clipboard';
    button.innerHTML = '<i class="fa-regular fa-copy"></i>';

    codeBlock.append(button);
    button.addEventListener('click', function() {
      const code = codeBlock.querySelector('code').innerText.trim();
      window.navigator.clipboard.writeText(code);

      button.innerHTML = '<i class="fa-regular fa-clipboard"></i>';
      const fourSeconds = 4000;

      setTimeout(function () {
        button.innerHTML = '<i class="fa-regular fa-copy"></i>';
      }, fourSeconds);
    });
  });
})(document);
