<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="DragPicture.Main" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style>
    #dropBox {
      margin: 15px;
      width: 250px;
      height: 250px;
      border: 5px dashed gray;
      border-radius: 8px;
      background: lightyellow;
      background-size: 100%;
      background-repeat: no-repeat;
      text-align: center;
    }
      
    #dropBox div {
      margin: 75px 45px;
      color: orange;
      font-size: 25px;
      font-family: Verdana, Arial, sans-serif;
    }
 
    input {
      margin: 15px;
    }

  </style>
 
  <script src="Scripts/jquery-3.1.0.min.js"></script>
  <script>
      var dropBox;
      var imginfo;
      var img;
      var imgwidth;
      var imgheight;
      var save;
      var file;
      var xhr;

      window.onload = function () {
          dropBox = document.getElementById("dropBox");
          imginfo = document.getElementById("imginfo");
          img = document.getElementById("thumbnail");
          save = document.getElementById("save");
          dropBox.ondragenter = ignoreDrag;
          dropBox.ondragover = ignoreDrag;
          dropBox.ondrop = drop;

          save.onclick = function () {
             
              modeifyimage("GrayScale");
          }

          function modeifyimage(type) {
              xhr = new XMLHttpRequest();
              xhr.open('POST', "SaveImage.ashx", true);
              //xhr.responseType = 'blob';
              xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
              //xhr.onreadystatechange = processResponse;
  
              xhr.onloadend = function () {
                  alert(this.responseText);
                  //var blog = this.response;
                  //var reader = new FileReader();
                  //告诉它在准备好数据之后做什么
                  //reader.onload = function (e) {
                  //    img.src = e.target.result;
                  //    imgwidth = e.target.naturalWidth;
                  //    imgheight = e.target.naturalHeight;
                  //    img.style.width = imgwidth;
                  //    img.style.height = imgheight;
                  //};
                  //读取图片
                  //reader.readAsDataURL(blog);
              }

              // prepare FormData 
              var formData = new FormData();
              formData.append('myfile', file);
              formData.append('type', type);
              xhr.send(formData);
          }
      }

      //   function processResponse() {
      //    if (xhr.readyState = "4") {
      //        var blog = this.response;
      //        var reader = new FileReader();
      //        //告诉它在准备好数据之后做什么
      //        reader.onload = function (e) {
      //            img.src = e.target.result;
      //            imgwidth = e.target.naturalWidth;
      //            imgheight = e.target.naturalHeight;
      //            img.style.width = imgwidth;
      //            img.style.height = imgheight;
      //        };
      //        //读取图片
      //        reader.readAsDataURL(blog);
      //    }
      //}

      function ignoreDrag(e) {
          //因为我们在处理拖放，所以应该确保没有其他元素会取得这个事件
          e.stopPropagation();
          e.preventDefault();
      }

      function drop(e) {
          //取消事件传播及默认行为
          e.stopPropagation();
          e.preventDefault();

          //取得拖进来的文件
          var data = e.dataTransfer;
          var files = data.files;
          //将其传给真正的处理文件的函数
          processFiles(files);
      }

      function processFiles(files) {
          file = files[0];
          //创建FileReader
          var reader = new FileReader();
          //告诉它在准备好数据之后做什么
          reader.onload = function (e) {
              //使用图像URL来绘制dropBox的背景
              dropBox.style.backgroundImage = "url('" + e.target.result + "')";
              //使用src填充img标签
              img.src = e.target.result;
              //得到图片的原始尺寸并给img赋值
              imgwidth = e.target.naturalWidth;
              imgheight = e.target.naturalHeight;
              img.style.width = imgwidth;
              img.style.height = imgheight;
              imginfo.innerHTML = file.name + file.size + file.type;
          };
          //读取图片
          reader.readAsDataURL(file);
      }

  </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
       <div id="dropBox">
        <div>将图片拖放到此处...</div>
         <button id="save">保存</button>
        </div>
        <div id ="imginfo"></div>
        <img id="thumbnail">
    </div>
    </form>
</body>
</html>
