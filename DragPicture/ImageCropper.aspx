<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImageCropper.aspx.cs" Inherits="DragPicture.ImageCropper" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="Scripts/jquery.min.js"></script>
    <script src="Scripts/cropper.js"></script>
    <link href="CSS/cropper.css" rel="stylesheet"/>
    <style>
        img {
                max-width: 100%; /* This rule is very important, please do not ignore this! */
            }
    </style>
    <script>
        jQuery(function ($) {
            
            $('#image').cropper({
                //保持与原图相同比例的裁剪
                //aspectRatio: 16 / 9,
                //是否允许移除当前的裁剪框
                dragCrop: true,
                strict: true,
                viewMode: 1,
                preview: '.preview',
                crop: function (e) {
                    // Output the result data for cropping image.
                    console.log(e.x);
                    console.log(e.y);
                    console.log(e.width);
                    console.log(e.height);
                    console.log(e.rotate);
                    console.log(e.scaleX);
                    console.log(e.scaleY);
                }
                     
            });
           
        });

        function save() {
            xhr = new XMLHttpRequest();
            xhr.open('POST', "SaveImage.ashx", true);
            xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
            //删除字符串前的提示信息 "data:image/png;base64," 
            var data = $('#image').cropper("getCroppedCanvas").toDataURL();
            var b64 = data.substring(22);
            var formData = new FormData();
            formData.append('image', b64);
            xhr.send(formData);
        }

       
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div style="width:800px;height:400px">
             <img id="image" src="Chrysanthemum.jpg">
        </div>
    </div>
        <div style="width:150px;height:75px;overflow:hidden "class="preview" >
            <img>
        </div></br>
        <div>
            <button onclick="save()">保存</button>
        </div>
      
    </form>
</body>
</html>
