

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
    $("#photo_preview_img_data").attr("src", "");
    $(".photo_preview_img").hide();
    $('#photo_select').val('');
    $("#hidden_drop_photo").attr("value", "");
  });

  var uploadForm = $('#upload_form');
  var photoSelect = $('#photo_select');

  uploadForm.on('dragover', function(e) {
    e.stopPropagation();
    e.preventDefault();
    uploadForm.addClass('dragover');
  });

  uploadForm.on('dragleave', function(e) {
    e.stopPropagation();
    e.preventDefault();
    uploadForm.removeClass('dragover');
  });

  uploadForm.on('drop', function(e) {
    e.stopPropagation();
    e.preventDefault();
    uploadForm.removeClass('dragenter')
    photoSelect.val('');

    var files = e.originalEvent.dataTransfer.files;

    var file = files[0];
    var reader = new FileReader();

    reader.onload = (function(file){
      return function(e){
        $("#photo_preview_img_data").attr("src", "");
        $(".photo_preview_img").hide();
        $('#photo_select').val('');
        $("#hidden_drop_photo").attr("value", "");

        $(".photo_preview_img").show();
        $("#photo_preview_img_data").attr("src", e.target.result); 
        $("#hidden_drop_photo").attr("value", e.target.result);
      };
    })(file);
    reader.readAsDataURL(file);
  });

  $(document)
  .ajaxStart(function() {
		window.topApp.requesting = true;
  })
  .ajaxStop(function() {
  });

  // アップロードのジョブステータスをポーリング
  function check_job_status(job_id) {
    if (job_id && job_id !== '') {
      $.ajax({ 
        url: 'jobs/status',
        type: 'GET', 
        data: { 
          job_id: job_id
        },
        dataType: 'json',
        success: function(data) {
          if (data['result'] == 'success') {
						 window.topApp.requesting = false;
          } else if (data['result'] == 'error') {
						 window.topApp.requesting = false;
          } else if (data['result'] == 'progress') {
              setTimeout(function() {
                check_job_status(job_id);
              }, 1000);
          } else {
						window.topApp.requesting = false;
          }
        }

      })
    }

  }

  var job_id = window.job_id;
  check_job_status(job_id);
});
