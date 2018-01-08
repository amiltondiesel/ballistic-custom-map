Shader "Ballistic/Environment/BumpedAdditive" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrGloss (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	ZWrite Off
	Blend One One
	
CGPROGRAM

#pragma surface surf Lambert
#pragma target 3.0

sampler2D _MainTex;
sampler2D _BumpMap;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float3 worldRefl;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex * _Color;
	o.Albedo = c.rgb;
	
	o.Gloss = tex.a;
	
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	
	float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	fixed4 reflcol = texCUBE (_Cube, worldRefl);
	reflcol *= tex.a;
	o.Emission = c.rgb + reflcol.rgb * _ReflectColor.rgb;
	o.Alpha = reflcol.a * _ReflectColor.a;
}
ENDCG
}

FallBack "Transparent/Bumped Diffuse"
}
