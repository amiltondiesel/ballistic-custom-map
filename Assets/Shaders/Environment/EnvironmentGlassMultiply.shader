Shader "Ballistic/Environment/GlassMultiply" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	[Gamma] _Exposure ("Exposure", Range(0, 20)) = 1.0
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	[KeywordEnum(OFF, ON)] DETAIL ("Detail",Float) = 0
	_DetailTex ("Detail (RGBA)", 2D) = "grey" {}
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
}
SubShader {

	Tags {"RenderType"="Transparent"}
	LOD 100
	Blend DstColor SrcColor
	Zwrite Off


CGPROGRAM
#pragma surface surf Lambert
#pragma shader_feature DETAIL_OFF DETAIL_ON

sampler2D _MainTex;
#if DETAIL_ON
sampler2D _DetailTex;
#endif
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;
half _Shininess;
half _Exposure;

struct Input {
	float2 uv_MainTex;
	#if DETAIL_ON
	float2 uv2_DetailTex;
	#endif
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	#if DETAIL_ON
	fixed4 det = tex2D(_DetailTex, IN.uv2_DetailTex);
	#endif
	fixed4 c = tex * _Color;
	#if DETAIL_ON
	c *= det * 2;
	#endif
	o.Albedo = 0;
	
	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
	reflcol *= c.a;
	o.Emission = c.rgb + (reflcol.rgb * _ReflectColor.rgb * _Exposure);
	o.Alpha = _Color.a + o.Emission;
}
ENDCG
}

FallBack "Transparent/VertexLit"
}
