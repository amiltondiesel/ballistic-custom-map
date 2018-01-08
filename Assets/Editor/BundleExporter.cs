using Aquiris.Ballistic.Utils;
using System.IO;
using UnityEditor;
using UnityEngine;

public class CreateAssetBundles
{
    [MenuItem("Help/Build[MapBundle]")]
    static void BuildAllAssetBundles()
    {
        string projectFolder = Application.dataPath.Substring(0, Application.dataPath.Length - 6);
        string assetBundleDirectory = "MapBundle/";
        if(!Directory.Exists(projectFolder + assetBundleDirectory))
        {
            Directory.CreateDirectory(projectFolder + assetBundleDirectory);
        }

        GameMapConfig config = new GameMapConfig();

        string configpath = projectFolder + "Assets/Editor/Configuration/";
        string fileSrc = configpath + "mapsettings.mapsettings";
        string texture_128 = configpath + "mapimage_128.jpg";
        string texture_512 = configpath + "mapimage_512.jpg";
        string texture_high = configpath + "mapimage_high.jpg";

        if (File.Exists(fileSrc) && File.Exists(texture_128) && File.Exists(texture_512) && File.Exists(texture_high))
        {
            string data = File.ReadAllText(fileSrc);
            config = ConversionUtil.ReadUnityJson<GameMapConfig>(data);
            if(config == null)
            {
                Debug.LogError("Error! mapsettings file is danified. please check your { and ,");
                return;
            }

            if(string.IsNullOrEmpty(config.MapName))
            {
                Debug.LogError("Error! mapsettings file MapName is danified.");
                return;
            }

            byte[] t128 = File.ReadAllBytes(texture_128); Texture2D tx128 = new Texture2D(0, 0); tx128.LoadImage(t128);

            if (tx128.width != 128 || tx128.height != 64) { Debug.LogError("Error!" + texture_128 + " must be 128x64 pixels"); return; }

            byte[] t512 = File.ReadAllBytes(texture_512); Texture2D tx512 = new Texture2D(0, 0); tx512.LoadImage(t512);

            if (tx512.width != 512 || tx512.height != 256) { Debug.LogError("Error!" + texture_512 + " must be 512x256 pixels"); return; }

            byte[] tHigh = File.ReadAllBytes(texture_high); Texture2D txHigh = new Texture2D(0, 0); txHigh.LoadImage(tHigh);

            if (txHigh.width != 2048 || txHigh.height != 1024) { Debug.LogError("Error!" + texture_high + " must be 2048x1024 pixels"); return; }
        }
        else
        {
            Debug.LogError("Error! missing files at Configuration/ folder. Check if mapsettings.mapsettings, mapimage_128.jpg, mapimage_512.jpg, mapimage_high.jpg is missing on this folder.");
            return;
        }

        string fileDst = projectFolder + assetBundleDirectory + config.MapName + ".mapsettings";
        string tx_128_dst = projectFolder + assetBundleDirectory + config.MapName + "_128.jpg";
        string tx_512_dst = projectFolder + assetBundleDirectory + config.MapName + "_512.jpg";
        string tx_high_dst = projectFolder + assetBundleDirectory + config.MapName + "_high.jpg";

        File.Copy(fileSrc, fileDst, true);
        File.Copy(texture_128, tx_128_dst, true);
        File.Copy(texture_512, tx_512_dst, true);
        File.Copy(texture_high, tx_high_dst, true);

        if(!Directory.Exists(assetBundleDirectory+"Win/"))
        {
            Directory.CreateDirectory(assetBundleDirectory + "Win/");
        }
        BuildPipeline.BuildAssetBundles(assetBundleDirectory + "Win/", BuildAssetBundleOptions.DeterministicAssetBundle, BuildTarget.StandaloneWindows);
        if (!Directory.Exists(assetBundleDirectory + "OSX/"))
        {
            Directory.CreateDirectory(assetBundleDirectory + "OSX/");
        }
        BuildPipeline.BuildAssetBundles(assetBundleDirectory + "OSX/", BuildAssetBundleOptions.DeterministicAssetBundle, BuildTarget.StandaloneOSXUniversal);
        if (!Directory.Exists(assetBundleDirectory + "Linux/"))
        {
            Directory.CreateDirectory(assetBundleDirectory + "Linux/");
        }
        BuildPipeline.BuildAssetBundles(assetBundleDirectory + "Linux/", BuildAssetBundleOptions.DeterministicAssetBundle, BuildTarget.StandaloneLinuxUniversal);
    }
}