using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

public class TextureImportSettings : BaseImportSettings
{
    [Header("Compression")]
    public TextureImporterType TextureType = TextureImporterType.Default;
    public TextureImporterShape TextureShape = TextureImporterShape.Texture2D;
    public TextureImporterCompression Compression = TextureImporterCompression.Compressed;
    public int CompressionQuality = 50;
    public bool UseCrunchCompression = false;
    public int MaxSize = 2048;

    [Header("MipMaps")]
    public TextureImporterNPOTScale NpotScale = TextureImporterNPOTScale.ToNearest;
    public bool GenerateMipMaps = false;
    public bool BorderMipmap = false;
    public TextureImporterMipFilter MipMapFiltering = TextureImporterMipFilter.BoxFilter;
    public bool FadeoutMipMaps = false;
    public int AnisoLevel = -1;

    [Header("Configs")]
    public TextureImporterAlphaSource AlphaSource = TextureImporterAlphaSource.FromInput;
    public bool AlphaIsTransparent = true;
    public FilterMode FilterMode = FilterMode.Point;
    public TextureWrapMode WrapMode = TextureWrapMode.Clamp;
    public bool sRGBTexture = true;

    [Header("Normal")]
    public bool CreateFromGrayscale = false;
    public float Bumpiness = 0.25f;
    public TextureImporterNormalFilter Filtering = TextureImporterNormalFilter.Standard;


    [Header("Sprite")]
    public SpriteImportMode SpriteMode = SpriteImportMode.None;
    public string PackingTag = string.Empty;
    public float PixelsPerUnit = 100;
    public Vector2 SpritePivot = new Vector2(0.5f, 0.5f);
    public SpriteMetaData[] Spritesheet = new SpriteMetaData[0];

    [Header("Platform - Standalone")]
    public bool StandaloneUsePlatformConfiguration = false;
    public TextureImporterFormat StandaloneTextureFormat = TextureImporterFormat.Automatic;

    [Header("Read/Write")]
    public bool IsReadable = false;

}
