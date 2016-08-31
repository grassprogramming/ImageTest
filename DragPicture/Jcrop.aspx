<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Jcrop.aspx.cs" Inherits="DragPicture.Jcrop" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="CSS/jquery.Jcrop.css"/>
    <style>
        #preview-pane {
            display: block;
            position: absolute;
            z-index: 2000;
            top: 10px;
            right: -280px;
            padding: 6px;
            border: 1px rgba(0,0,0,.4) solid;
            background-color: white;
        }
        #preview-pane .preview-container {
            width: 250px;
            height: 170px;
            overflow: hidden;
        }
    </style>
    <script src="Scripts/jquery.min.js"></script>
    <script src="Scripts/jquery.Jcrop.js"></script>
    <script type="text/javascript">
        var img;
        jQuery(function ($) {
            img = document.getElementById("test");
            // Create variables (in this scope) to hold the API and image size
            var jcrop_api,
                boundx,
                boundy,
                
                // Grab some information about the preview pane
                $preview = $('#preview-pane'),
                $pcnt = $('#preview-pane .preview-container'),
                $pimg = $('#preview-pane .preview-container img'),

                xsize = $pcnt.width(),
                ysize = $pcnt.height();

            console.log('init', [xsize, ysize]);
            $('#target').Jcrop({
                onChange: updatePreview,
                onSelect: updatePreview,
                aspectRatio: xsize / ysize
            }, function () {
                // Use the API to get the real image size
                var bounds = this.getBounds();
                boundx = bounds[0];
                boundy = bounds[1];
                // Store the API in the jcrop_api variable
                jcrop_api = this;

                // Move the preview into the jcrop container for css positioning
                $preview.appendTo(jcrop_api.ui.holder);
            });

            function updatePreview(c) {
                if (parseInt(c.w) > 0) {
                    var rx = xsize / c.w;
                    var ry = ysize / c.h;

                    $pimg.css({
                        width: Math.round(rx * boundx) + 'px',
                        height: Math.round(ry * boundy) + 'px',
                        marginLeft: '-' + Math.round(rx * c.x) + 'px',
                        marginTop: '-' + Math.round(ry * c.y) + 'px'
                    });
                }
            };

        });

        function getBase64Image(img) {
            var canvas = document.createElement("canvas");
            canvas.width = img.width;
            canvas.height = img.height;

            var ctx = canvas.getContext("2d");
            ctx.drawImage(img, 0, 0, img.width, img.height);

            var dataURL = canvas.toDataURL("image/png");
            return dataURL

            // return dataURL.replace("data:image/png;base64,", "");
        }

        function save() {
            xhr = new XMLHttpRequest();
            xhr.open('POST', "SaveImage.ashx", true);
            xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
            //删除字符串前的提示信息 "data:image/png;base64," 
            var data = getBase64Image(img);
            var b64 = data.substring(22);
            var formData = new FormData();
            formData.append('image', b64);
            xhr.send(formData);
        }

</script>
</head>
<body>

    <div>
        <img id="target" src="test.jpg" />
    </div>

    <div id="preview-pane">
    <div class="preview-container">
      <img src="test.jpg" class="jcrop-preview" alt="Preview" id="test"/>
    </div>
    <button onclick="save()">保存</button>
  </div>

</body>
</html>
