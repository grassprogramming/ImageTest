using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
namespace DragPicture
{
    public enum ImageEffect
    {
        GrayScale = 0,      // 黑白  
        Film = 1,      // 底片  
        Relief = 2,      // 浮雕  
        Soften = 3,      // 柔化  
        Sharpen = 4,      // 锐化  
        Canvas = 5,      // 油画  
    }
    public class ImageEffectManager
    {
        private Bitmap newBitmap = null;
        private Bitmap oldBitmap = null;
        #region Properties

        public Bitmap ConvertedBitmap
        {
            get { return this.newBitmap; }
        }
        public Bitmap OriginalBitmap
        {
            set
            {
                DisposeBitmap();
                this.oldBitmap = value;
            }
        }
        public Size PixelSize
        {
            get
            {
                if (this.oldBitmap != null)
                {
                    GraphicsUnit unit = GraphicsUnit.Pixel;
                    RectangleF bounds = this.oldBitmap.GetBounds(ref unit);
                    return new Size(
                        (int)bounds.Width, (int)bounds.Height);
                }
                return new Size(0, 0);
            }
        }
        #endregion
        #region Methods

        public ImageEffectManager()
        {
        }
        public void DisposeBitmap()
        {
            if (this.newBitmap != null)
            {
                this.newBitmap.Dispose();
                this.newBitmap = null;
            }
        }
        public void ChangeEffect(ImageEffect effect)
        {
            if (null == this.oldBitmap)
            {
                return;
            }
            Size size = PixelSize;
            int width = size.Width;
            int height = size.Height;
            this.DisposeBitmap();
            this.newBitmap = new Bitmap(width, height);
            switch (effect)
            {
                case ImageEffect.GrayScale:
                    MakeGrayScale(width, height);
                    break;
                case ImageEffect.Film:
                    MakeFilmEffect(width, height);
                    break;
                case ImageEffect.Relief:
                    MakeReliefEffect(width, height);
                    break;
                case ImageEffect.Soften:
                    MakeSoftenEffect(width, height);
                    break;
                case ImageEffect.Sharpen:
                    MakeSharpenEffect(width, height);
                    break;
            }
        }
        private void MakeGrayScale(int width, int height)
        {
            Color c;
            for (int x = 0; x < width; x++)
            {
                for (int y = 0; y < height; y++)
                {
                    c = this.oldBitmap.GetPixel(x, y);
                    ///////////////////////////////////////////////////////  
                    //  
                    // Average  
                    // int value = (c.R + c.G + c.B) / 3;  
                    //  
                    ///////////////////////////////////////////////////////  
                    // Weighted average  
                    int value = (int)(0.7 * c.R) +
                        (int)(0.2 * c.G) + (int)(0.1 * c.B);
                    this.newBitmap.SetPixel(x, y,
                        Color.FromArgb(c.A, value, value, value));
                }
            }
        }
        private void MakeFilmEffect(int width, int height)
        {
            Color c;
            for (int x = 0; x < width; x++)
            {
                for (int y = 0; y < height; y++)
                {
                    c = this.oldBitmap.GetPixel(x, y);
                    this.newBitmap.SetPixel(x, y,
                        Color.FromArgb(c.A, 255 - c.R,
                            255 - c.G, 255 - c.B));
                }
            }
        }
        private void MakeReliefEffect(int width, int height)
        {
            Color c1;
            Color c2;
            int r, g, b = 0;
            for (int x = 0; x < width - 1; x++)
            {
                for (int y = 0; y < height - 1; y++)
                {
                    c1 = this.oldBitmap.GetPixel(x, y);
                    c2 = this.oldBitmap.GetPixel(x + 1, y + 1);
                    r = Math.Abs(c1.R - c2.R + 128);
                    g = Math.Abs(c1.G - c2.G + 128);
                    b = Math.Abs(c1.B - c2.B + 128);
                    r = (r > 255) ? 255 : ((r < 0) ? 0 : r);
                    g = (g > 255) ? 255 : ((g < 0) ? 0 : g);
                    b = (b > 255) ? 255 : ((b < 0) ? 0 : b);
                    this.newBitmap.SetPixel(x, y,
                        Color.FromArgb(c1.A, r, g, b));
                }
            }
        }
        private void MakeSoftenEffect(int width, int height)
        {
            // The template of Gauss  
            int[] Gauss = { 1, 2, 1, 2, 4, 2, 1, 2, 1 };
            Color pixel;
            for (int x = 1; x < width - 1; x++)
            {
                for (int y = 1; y < height - 1; y++)
                {
                    int r = 0, g = 0, b = 0;
                    int Index = 0;
                    for (int col = -1; col <= 1; col++)
                    {
                        for (int row = -1; row <= 1; row++)
                        {
                            pixel =
                                this.oldBitmap.GetPixel(x + row, y + col);
                            r += pixel.R * Gauss[Index];
                            g += pixel.G * Gauss[Index];
                            b += pixel.B * Gauss[Index];
                            Index++;
                        }
                    }
                    r /= 16;
                    g /= 16;
                    b /= 16;
                    //处理颜色值溢出  
                    r = r > 255 ? 255 : r;
                    r = r < 0 ? 0 : r;
                    g = g > 255 ? 255 : g;
                    g = g < 0 ? 0 : g;
                    b = b > 255 ? 255 : b;
                    b = b < 0 ? 0 : b;
                    this.newBitmap.SetPixel(x - 1, y - 1,
                        Color.FromArgb(r, g, b));
                }
            }
        }
        private void MakeSharpenEffect(int width, int height)
        {
            Color pixel;
            //拉普拉斯模板  
            int[] Laplacian = { -1, -1, -1, -1, 9, -1, -1, -1, -1 };
            for (int x = 1; x < width - 1; x++)
            {
                for (int y = 1; y < height - 1; y++)
                {
                    int r = 0, g = 0, b = 0;
                    int Index = 0;
                    for (int col = -1; col <= 1; col++)
                    {
                        for (int row = -1; row <= 1; row++)
                        {
                            pixel = this.oldBitmap.GetPixel(x + row, y + col);
                            r += pixel.R * Laplacian[Index];
                            g += pixel.G * Laplacian[Index];
                            b += pixel.B * Laplacian[Index];
                            Index++;
                        }
                    }
                    //处理颜色值溢出  
                    r = r > 255 ? 255 : r;
                    r = r < 0 ? 0 : r;
                    g = g > 255 ? 255 : g;
                    g = g < 0 ? 0 : g;
                    b = b > 255 ? 255 : b;
                    b = b < 0 ? 0 : b;
                    this.newBitmap.SetPixel(x - 1, y - 1,
                        Color.FromArgb(r, g, b));
                }
            }
        }
        private void MakeCanvasEffect(int width, int height)
        {
        }
        #endregion
    }
}