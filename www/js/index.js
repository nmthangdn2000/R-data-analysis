
let tab2 = 0
let tab3 = 0
let tab4 = 0

$(document).ready(function(){
  loading(3500);
  const tab_li = $('.sidebar-menu > li')
  console.log(tab_li)
  Array.from(tab_li).forEach((element, index) => {
    $(element).on('click', () => {
      if(index == 1 && tab2 == 0){
         $(".divLoader").css("display", 'block');
         loading(4000);
         tab2 = 1;
      }
      else if(index == 2 && tab3 == 0){
         $(".divLoader").css("display", 'block');
         loading(4000);
         tab3 = 1;
      }
      else if(index == 3 && tab4 == 0){
         $(".divLoader").css("display", 'block');
         loading(2000);
         tab4 = 1;
      }
      else return;
    })
  })
  
})

function loading(time) {
  setTimeout(function() {
     $(".divLoader").fadeOut("slow");
  }, time);
}