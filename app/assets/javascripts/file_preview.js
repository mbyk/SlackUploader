

$(function(){
  $('#photo_select').change(function(e){
    var file = e.target.files[0];
    var reader = new FileReader();
 
    if(file.type.indexOf("image") < 0){
      alert("画像ファイルを指定してください。");
      return false;
    }
 
    reader.onload = (function(file){
      return function(e){
        $(".photo_preview_img").show();
        $("#photo_preview_img_data").attr("src", e.target.result);
      };
    })(file);
    reader.readAsDataURL(file);
 
  });

  $('#photo_preview_img_close').click(function() {
    $(".photo_preview_img").hide();
    $('#photo_select').val('');
  });
});