using ImageMagick;
using Microsoft.Graphics.Canvas;
using Microsoft.UI.Xaml.Media.Imaging;
using Windows.Foundation;
using Windows.UI;

namespace Simple_Icon_File_Maker.Helpers;

public class CanvasHelpers
{
    public static void Draw(string imagePath, int sideLength, CanvasDrawingSession drawingSession)
    {
        MagickImage image = new(imagePath);
        IPixelCollection<ushort> pixels = image.GetPixels();

        drawingSession.FillRectangle(0,0,sideLength, sideLength, Color.FromArgb(0,0,0,0));

        for (int y = 0; y < sideLength; y++)
        {
            for (int x = 0; x < sideLength; x++)
            {
                Rect pixelRect = new(x, y, 1, 1);
                IPixel<ushort>? pixel = pixels[x, y];

                if (pixel is null)
                    continue;

                var magickColor = pixel.ToColor();
                if (magickColor is null)
                    continue;

                Color pixelColor = Color.FromArgb((byte)magickColor.A, (byte)magickColor.R, (byte)magickColor.G, (byte)magickColor.B);

                drawingSession.FillRectangle(pixelRect, pixelColor);
            }
        }
    }
}
