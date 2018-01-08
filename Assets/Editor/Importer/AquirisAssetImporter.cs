using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

public class AquirisAssetImporter : AssetPostprocessor {
    #if UNITY_EDITOR

    [MenuItem("Assets/Create/Texture Import Settings")]
    public static void CreateTextureImportSettings() {
        var asset = ScriptableObject.CreateInstance<TextureImportSettings>();
        string path = AssetDatabase.GetAssetPath(Selection.activeObject);

        if (string.IsNullOrEmpty(path)) {
            Debug.LogError("CreateTextureImportSettings: Path is null or empty");
            return;
        }

        if (!string.IsNullOrEmpty(Path.GetExtension(path))) {
            path = Path.GetDirectoryName(path);
        }

        string assetPathAndName = Path.Combine(path, "TextureImportSettings.asset");

        if (File.Exists(assetPathAndName)) {
            Debug.LogError(string.Format("CreateTextureImportSettings: The asset was already found at {0}. There can be only one.", path));
            return;
        }

        Debug.Log("Creating texture importer settings asset: " + assetPathAndName);

        AssetDatabase.CreateAsset(asset, assetPathAndName);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        EditorUtility.FocusProjectWindow();
        Selection.activeObject = asset;
    }

    public void OnPreprocessTexture()
    {
        var importer = assetImporter as TextureImporter;
        string dirPath = assetPath.Substring(0, assetPath.LastIndexOf("/"));

        string settingsPath = string.Format("{0}/TextureImportSettings.asset", dirPath);
        var settings = AssetDatabase.LoadAssetAtPath<TextureImportSettings>(settingsPath);

        if (importer != null && settings != null)
        {
            //string str = string.Format("{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}, {14}, {15}, {16}, {17}, {18}, {19}, {20}, {21}, {22}, {23}, {24}, {25}, {26}, {27}, {28}, {29}, {30}", importer.anisoLevel, importer.borderMipmap, importer.compressionQuality, importer.convertToNormalmap, importer.fadeout, importer.filterMode, importer.generateCubemap, importer.generateMipsInLinearSpace, importer.grayscaleToAlpha, importer.heightmapScale, importer.isReadable, importer.lightmap, importer.linearTexture, importer.maxTextureSize, importer.mipMapBias, importer.mipmapEnabled, importer.mipmapFadeDistanceEnd, importer.mipmapFadeDistanceStart, importer.mipmapFilter, importer.normalmap, importer.normalmapFilter, importer.npotScale, importer.spriteBorder, importer.spriteImportMode, importer.spritePackingTag, importer.spritePivot, importer.spritePixelsPerUnit, importer.spritesheet, importer.textureFormat, importer.textureType, importer.wrapMode);
            //Debug.Log(str);

            Debug.Log("Importing asset '" + assetPath + "' using settings '" + settingsPath + "'");

            importer.textureType = settings.TextureType;
            importer.textureShape = settings.TextureShape;
            importer.textureCompression = settings.Compression;
            importer.compressionQuality = settings.CompressionQuality;
            importer.crunchedCompression = settings.UseCrunchCompression;
            importer.maxTextureSize = settings.MaxSize;

            importer.npotScale = settings.NpotScale;
            importer.mipmapEnabled = settings.GenerateMipMaps;
            importer.borderMipmap = settings.BorderMipmap;
            importer.mipmapFilter = settings.MipMapFiltering;
            importer.fadeout = settings.FadeoutMipMaps;
            importer.anisoLevel = settings.AnisoLevel;

            importer.alphaSource = settings.AlphaSource;
            importer.alphaIsTransparency = settings.AlphaIsTransparent;
            importer.filterMode = settings.FilterMode;
            importer.wrapMode = settings.WrapMode;
            importer.sRGBTexture = settings.sRGBTexture;

            importer.convertToNormalmap = settings.CreateFromGrayscale;
            importer.normalmapFilter = settings.Filtering;
            importer.heightmapScale = settings.Bumpiness;

            importer.spriteImportMode = settings.SpriteMode;
            importer.spritePackingTag = settings.PackingTag;
            importer.spritePivot = settings.SpritePivot;
            importer.spritePixelsPerUnit = settings.PixelsPerUnit;

            importer.isReadable = settings.IsReadable;
            if(settings.StandaloneUsePlatformConfiguration)
            {
                var platformPc = new TextureImporterPlatformSettings
                {
                    overridden = true,
                    name = "Standalone",
                    maxTextureSize = settings.MaxSize,
                    format = settings.StandaloneTextureFormat
                };
                importer.SetPlatformTextureSettings(platformPc);
            }
        }
    }
    #endif
}
