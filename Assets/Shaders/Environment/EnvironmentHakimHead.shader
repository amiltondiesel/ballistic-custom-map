Shader "Ballistic/Environment/HakimHead" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrGloss (A)", 2D) = "white" {}
	_RampTex ("Ramp Tex", 2D) = "black" {}
	_Cube ("Reflection Cubemap", Cube) = "" {}
}

SubShader {

	Tags { "RenderType"="Opaque" }
	
CGPROGRAM
#pragma surface surf Lambert

sampler2D _MainTex;
sampler2D _RampTex;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;

struct Input {
	float2 uv_MainTex;
	float2 uv_RampTex;
	fixed4 color : COLOR;
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex + frac(_Time.x * 5));
	fixed4 ramp = tex2D(_RampTex, IN.uv_RampTex - frac(_Time.x * 10)).a;
	o.Albedo = ((tex * IN.color.rgb * _Color) + (ramp * _ReflectColor.rgb)) * IN.color.a;

	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
	reflcol *= tex.a;
	o.Emission = o.Albedo + (reflcol.rgb * _ReflectColor.rgb * IN.color.a * 2);
}
ENDCG
}

FallBack "Reflective/Diffuse"
}