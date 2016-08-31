using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;

namespace DragPicture
{
    /// <summary>
    /// SaveImage 的摘要说明
    /// </summary>
    public class SaveImage : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string msg = string.Empty;
            HttpFileCollection files = context.Request.Files;
            try
            {
                string dir = context.Server.MapPath("~/" + "image");
                if (!Directory.Exists(dir))//文件夹不存在      
                {
                    Directory.CreateDirectory(dir);//创建文件夹      
                }
                FileStream fs = File.Create(dir + "/" + "test" + ".png"); 
                byte[] bytes = Convert.FromBase64String(context.Request["image"]);
                fs.Write(bytes, 0, bytes.Length);
                fs.Close(); 
                //if (files.Count > 0)
                //{
                //    for (int i = 0; i < files.Count; i++)
                //    {
                //        string path = System.IO.Path.Combine(dir, System.IO.Path.GetFileName(files[i].FileName));
                //        files[i].SaveAs(path);
                //        Bitmap pass = BytesToBitmap(StreamToBytes(files[i].InputStream));
                //        Bitmap back = ImageModify(pass, type);
                //        back.Save(path, System.Drawing.Imaging.ImageFormat.Jpeg);
                       
                //    }
                //}
                msg = "true";
            }
            catch (Exception ex)
            {
                msg = "false";
                
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write("hello world");
        }


        public Bitmap ImageModify(Bitmap bitmap,string type)
        {
            ImageEffectManager im = new ImageEffectManager();
            im.DisposeBitmap();
            im.OriginalBitmap = bitmap;
            switch (type)
            {
                case "GrayScale":
                    im.ChangeEffect(ImageEffect.GrayScale);
                    break;
            }

            return im.ConvertedBitmap;
        }



        public byte[] StreamToBytes(Stream stream)
        {
            byte[] bytes = new byte[stream.Length];
            stream.Read(bytes, 0, bytes.Length);

            // 设置当前流的位置为流的开始  
            stream.Seek(0, SeekOrigin.Begin);
            return bytes;
        }

        public static Bitmap BytesToBitmap(byte[] Bytes)
        {
            MemoryStream stream = null;
            try
            {
                stream = new MemoryStream(Bytes);
                return new Bitmap((Image)new Bitmap(stream));
            }
            catch (ArgumentNullException ex)
            {
                throw ex;
            }
            catch (ArgumentException ex)
            {
                throw ex;
            }
            finally
            {
                stream.Close();
            }
        }   

        public static byte[] BitmapToBytes(Bitmap Bitmap)  
        {  
            MemoryStream ms = null;  
            try  
            {  
                ms = new MemoryStream();  
                Bitmap.Save(ms, Bitmap.RawFormat);  
                byte[] byteImage = new Byte[ms.Length];  
                byteImage = ms.ToArray();  
                return byteImage;  
            }  
            catch (ArgumentNullException ex)  
            {  
                throw ex;  
            }  
            finally  
            {  
                ms.Close();  
            }  
        }

        public void StreamToFile(Stream stream, string fileName)
        {
            // 把 Stream 转换成 byte[]  
            byte[] bytes = new byte[stream.Length];
            stream.Read(bytes, 0, bytes.Length);
            // 设置当前流的位置为流的开始  
            stream.Seek(0, SeekOrigin.Begin);

            // 把 byte[] 写入文件  
            FileStream fs = new FileStream(fileName, FileMode.Create);
            BinaryWriter bw = new BinaryWriter(fs);
            bw.Write(bytes);
            bw.Close();
            fs.Close();
        }

        public Stream BytesToStream(byte[] bytes)
        {
            Stream stream = new MemoryStream(bytes);
            return stream;
        }  
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}