if (window.location.hash == '#_=_') {
    window.location.hash = ''; // for older browsers, leaves a # behind
    history.pushState('', document.title, window.location.pathname);
    e.preventDefault();
}