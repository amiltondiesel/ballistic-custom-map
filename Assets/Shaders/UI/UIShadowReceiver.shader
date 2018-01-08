Shader "Ballistic/UI/ShadowReceiver" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	[HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.0
}
SubShader {
	Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 100
	Blend SrcAlpha OneMinusSrcAlpha

CGPROGRAM
#pragma surface surf ShadowOnly alphatest:Cutout
fixed4 _Color;

half4 LightingShadowOnly (SurfaceOutput s, fixed3 lightDir, fixed atten)
{
    fixed4 c;
    c.rgb = (1- atten) * s.Albedo;
    c.a = (1 - atten) * _Color.a;
    return c;
}

struct Input {
	float2 nothing;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = _Color;
	o.Albedo = c.rgb;
	o.Alpha = 1;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
