Shader "Ballistic/Environment/GlassAlpha" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_RefMask ("Reflection Mask (RGB)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
}
SubShader {

	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	Lighting Off
	//ZWrite Off
	//Blend SrcAlpha OneMinusSrcAlpha

CGPROGRAM
#pragma surface surf Lambert alpha:blend

sampler2D _MainTex;
sampler2D _RefMask;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;

struct Input {
	float2 uv_MainTex;
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	fixed3 mask = tex2D(_RefMask, IN.uv_MainTex).rgb;
	o.Albedo = tex.rgb;
	
	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
	//reflcol *= tex.a;
	fixed3 emis = reflcol.rgb * _ReflectColor.rgb * mask;
	o.Emission = emis;
	o.Alpha = saturate(tex.a + emis);
}
ENDCG
}
FallBack "Transparent/VertexLit"
}
