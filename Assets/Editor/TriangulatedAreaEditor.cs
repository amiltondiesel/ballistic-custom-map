using Aquiris.Ballistic.Game.Maps;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(CaptureZone)), CanEditMultipleObjects]
public class TriangulatedAreaEditor : Editor
{
    protected virtual void OnSceneGUI()
    {
        CaptureZone tri = (CaptureZone)target;

        EditorGUI.BeginChangeCheck();

        Vector3[] pos = tri.Points;
        Handles.matrix = tri.transform.localToWorldMatrix;

        for (int i = 0; i < tri.Points.Length; i++)
        {
            pos[i] = Handles.PositionHandle(pos[i], Quaternion.identity);
            pos[i].y = 0;
        }

        if (EditorGUI.EndChangeCheck())
        {
            Undo.RecordObject(tri, "Change Points");
            tri.Points = pos;
            if (tri.enabled)
            {
                tri.OnEnable();
            }
        }
    }
}
