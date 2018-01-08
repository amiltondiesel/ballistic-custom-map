using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
    public class ScriptTools : EditorWindow
    {
        private static List<Object> _componentGameObjectList = new List<Object>();
        private static List<string> _monoscripts = new List<string>();

        [MenuItem("Aquiris/Tools/Open SceneScriptTools Window")]
        public static void ShowWindow()
        {
            EditorWindow.GetWindow(typeof(ScriptTools));
        }

        public void OnGUI()
        {
            if (GUILayout.Button("Select Objects with [Missing Script] Components Scene"))
            {
                FindAll();
            }
            if(GUILayout.Button("Select All dependent scripts of Scene"))
            {
                SelectAllScripts();
            }
        }

        private static int Find(Transform g)
        {
            Component[] components = g.GetComponents<Component>();
            for (int i = 0; i < components.Length; i++)
            {
                if (components[i] == null)
                {
                    _componentGameObjectList.Add(g.gameObject);
                    string s = g.name;
                    Transform t = g.transform;
                    while (t.parent != null)
                    {
                        s = t.parent.name + "/" + s;
                        t = t.parent;
                    }
                    Debug.Log(s + " has an empty script attached in position: " + i, g);
                    break;
                }
            }
            return components.Length;
        }

        private static void FindAll()
        {
            Transform[] go = GameObject.FindObjectsOfType<Transform>();
            int components_count = 0;
            _componentGameObjectList.Clear();
            foreach (Transform g in go)
            {
                components_count += Find(g);
            }
            
            Debug.Log(string.Format("Searched {0} GameObjects, {1} components, found {2} missing", go.Length, components_count, _componentGameObjectList.Count));

            Selection.objects = _componentGameObjectList.ToArray();
        }

        private static void SelectAllScripts()
        {
            Transform[] go = GameObject.FindObjectsOfType<Transform>();

            _monoscripts.Clear();
            _componentGameObjectList.Clear();
            foreach (Transform g in go)
            {
                SelectScripts(g);
            }
            foreach(string m in _monoscripts)
            {
                _componentGameObjectList.Add(AssetDatabase.LoadMainAssetAtPath(m));
            }

            Selection.objects = _componentGameObjectList.ToArray();
        }

        private static void SelectScripts(Transform g)
        {
            Component[] components = g.GetComponents<Component>();
            for (int i = 0; i < components.Length; i++)
            {
                if (components[i] is MonoBehaviour)
                {
                    MonoScript ms = MonoScript.FromMonoBehaviour(components[i] as MonoBehaviour);
                    string path = AssetDatabase.GetAssetPath(ms);
                    if (path.StartsWith("Assets"))
                    {
                        _monoscripts.Add(path);
                    }
                }
            }
        }
    }
}