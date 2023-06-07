export const draggable = (el) => {
  let mouseDown = false;
  let startX, scrollLeft;
  
  let startDragging = function (e) {
    mouseDown = true;
    startX = e.pageX - el.offsetLeft;
    scrollLeft = el.scrollLeft;
  };
  let stopDragging = function (event) {
    mouseDown = false;
  };
  
  el.addEventListener('mousemove', (e) => {
    e.preventDefault();
    if(!mouseDown) { return; }
    const x = e.pageX - el.offsetLeft;
    const scroll = x - startX;
    el.scrollLeft = scrollLeft - scroll;
  });
  
  // Add the event listeners
  el.addEventListener('mousedown', startDragging, false);
  el.addEventListener('mouseup', stopDragging, false);
  el.addEventListener('mouseleave', stopDragging, false);
}
