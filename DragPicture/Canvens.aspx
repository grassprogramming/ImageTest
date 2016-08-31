<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Canvens.aspx.cs" Inherits="DragPicture.Canvens" %>


<!DOCTYPE html>
<html>
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>canvas图像处理</title>
      <script>
          var canvas1;
          var canvas2;
          var context1;
          var context2;
          var image;
          window.onload = function () {
              canvas1 = document.getElementById('canvas1');
              canvas2 = document.getElementById('canvas2');
              context1 = canvas1.getContext('2d');
              context2 = canvas2.getContext('2d');
              image = new Image();
              image.src = "test.jpg";
              image.onload = function () {
                  context1.drawImage(image, 0, 0);//绘制原始图像，（0,0）表示图像的左上角位与canvas画布的位置
              }
          }
         
          // 计算卷积矩阵的函数
          function ConvolutionMatrix(input, matrix, divisor, offset) {
              // 创建一个输出的 imageData 对象
              var output = document.createElement("canvas")
                                   .getContext('2d').createImageData(input);
              var w = input.width, h = input.height;
              var iD = input.data, oD = output.data;
              var m = matrix;
              // 对除了边缘的点之外的内部点的 RGB 进行操作，透明度在最后都设为 255
              for (var y = 1; y < h - 1; y += 1) {
                  for (var x = 1; x < w - 1; x += 1) {
                      for (var c = 0; c < 3; c += 1) {
                          var i = (y * w + x) * 4 + c;
                          oD[i] = offset
                              + (m[0] * iD[i - w * 4 - 4] + m[1] * iD[i - w * 4] + m[2] * iD[i - w * 4 + 4]
                              + m[3] * iD[i - 4] + m[4] * iD[i] + m[5] * iD[i + 4]
                              + m[6] * iD[i + w * 4 - 4] + m[7] * iD[i + w * 4] + m[8] * iD[i + w * 4 + 4])
                              / divisor;
                          oD[(y * w + x) * 4 + 3] = 255; // 设置透明度
                      }
                  }
              }
              return output;
          }
          function draw() {
              var imagedata = context1.getImageData(0, 0, image.width, image.height);
              //var imagedata1 = context2.createImageData(image.width, image.height);
              //for (var j = 0; j < image.height; j += 1)
              //    for (var i = 0; i < image.width; i += 1) {
              //        k = 4 * (image.width * j + i);
              //        imagedata1.data[k + 0] = 255 - imagedata.data[k + 0];
              //        imagedata1.data[k + 1] = 255 - imagedata.data[k + 1];
              //        imagedata1.data[k + 2] = 255 - imagedata.data[k + 2];
              //        imagedata1.data[k + 3] = 255;
              //    }
              //context2.putImageData(imagedata1, 0, 0);
              var martix = [-2, -1, 0, -1, 1, 1, 0, 1, 2]
              var imagedata2 = ConvolutionMatrix(imagedata, martix, 1, 0);
              context2.putImageData(imagedata2, 0, 0);
          }

        

         
         
          //复古效果（sepia）则是将红、绿、蓝三个像素，分别取这三个值的某种加权平均值，使得图像有一种古旧的效果。
          function speia() {
              var imagedata = context1.getImageData(0, 0, image.width, image.height);
              var d = imagedata.data;
              for (var i = 0; i < d.length; i += 4) {
                  var r = d[i];
                  var g = d[i + 1];
                  var b = d[i + 2];
                  d[i] = (r * 0.393) + (g * 0.769) + (b * 0.189); // red
                  d[i + 1] = (r * 0.349) + (g * 0.686) + (b * 0.168); // green
                  d[i + 2] = (r * 0.272) + (g * 0.534) + (b * 0.131); // blue
              }
              context2.putImageData(imagedata, 0, 0);
          }
              


          function save() {
              xhr = new XMLHttpRequest();
              xhr.open('POST', "SaveImage.ashx", true);
              xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
              //删除字符串前的提示信息 "data:image/png;base64," 
              var data = canvas2.toDataURL();
              var b64 = data.substring(22);
              var formData = new FormData();
              formData.append('image', b64);
              xhr.send(formData);
          }

          //function saveImageInfo() {
          //    var mycanvas = document.getElementById("canvas2");
          //    var image = mycanvas.toDataURL("image/jpg");
          //    var w = window.open('about:blank', 'image from canvas');
          //    w.document.write("<img src='" + image + "' alt='from canvas'/>");
          //}


          //function convertCanvasToImage(canvas) {
          //    var image = new Image();
          //    image.src = canvas.toDataURL("image/jpg");
          //    return image;
          //}
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <h1>canvas</h1>
    <canvas id="canvas1" width="200" height="150">是时候更换浏览器了<a href="http://firefox.com.cn/download/">点击下载firefox</a></canvas>
  
    <br />
     <input onclick="speia()" title="浮雕效果"/>
    <br />
    <br />
    <button onclick="save()">图像的保存</button>
    <br />
    <canvas id="canvas2" width="200" height="150"></canvas>
   </form>
</body>
</html>