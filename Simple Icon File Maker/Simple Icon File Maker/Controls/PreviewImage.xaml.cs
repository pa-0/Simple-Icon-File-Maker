using ImageMagick;
using Microsoft.Graphics.Canvas.UI.Xaml;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Microsoft.UI.Xaml.Media.Imaging;
using Simple_Icon_File_Maker.Helpers;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using Windows.Storage;
using Windows.Storage.Pickers;
using Windows.Storage.Streams;
using WinRT.Interop;

// To learn more about WinUI, the WinUI project structure,
// and more about our project templates, see: http://aka.ms/winui-project-info.

namespace Simple_Icon_File_Maker.Controls;

public sealed partial class PreviewImage : UserControl
{
    readonly StorageFile _imageFile;
    readonly int _sideLength = 0;

    public PreviewImage(StorageFile imageFile, int sideLength)
    {
        InitializeComponent();
        _imageFile = imageFile;
        _sideLength = sideLength;
        ToolTipService.SetToolTip(this, $"{sideLength} x {sideLength}");
    }

    public bool ZoomPreview
    {
        get
        {
            if (CanvasViewBox.ZoomFactor == 1)
                return false;
            return true;
        }
        set
        {
            if (value)
                CanvasViewBox.ZoomToFactor(20);
            else
                CanvasViewBox.ZoomToFactor(1);
        }
    }

    private async void MenuFlyoutItem_Click(object sender, RoutedEventArgs e)
    {
        FileSavePicker savePicker = new()
        {
            SuggestedStartLocation = PickerLocationId.PicturesLibrary,
        };
        string extension = Path.GetExtension(_imageFile.Path);
        savePicker.FileTypeChoices.Add("Image", new List<string>() { extension });
        savePicker.SuggestedFileName = Path.GetFileNameWithoutExtension(_imageFile.Path);
        savePicker.DefaultFileExtension = extension;

        Window saveWindow = new();
        IntPtr windowHandleSave = WindowNative.GetWindowHandle(saveWindow);
        InitializeWithWindow.Initialize(savePicker, windowHandleSave);

        StorageFile file = await savePicker.PickSaveFileAsync();

        if (file is null)
            return;

        try
        {
            StorageFolder folder = await file.GetParentAsync();
            if (folder is null)
                return;

            MagickImage magickImage = new(_imageFile.Path);
            await magickImage.WriteAsync(file.Path);
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Failed to save out single image: {ex.Message}");
        }
    }

    private void UserControl_Loaded(object sender, RoutedEventArgs e)
    {
        ImageCanvas.Width = _sideLength;
        ImageCanvas.Height = _sideLength;
        ImageCanvas.Invalidate();
    }

    private void ImageCanvas_Draw(CanvasControl sender, CanvasDrawEventArgs args)
    {
        CanvasHelpers.Draw(_imageFile.Path, _sideLength, args.DrawingSession);
    }
}
