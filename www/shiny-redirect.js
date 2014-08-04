$( document ).ready(function() {
// Handler for .ready() called.
  var link = document.getElementById('url').value;
    if (link.length >1) {
      window.open(link, "_self")
    }
});    
