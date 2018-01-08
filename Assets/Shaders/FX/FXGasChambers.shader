Shader "Ballistic/FX/GasChambers" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (0.4,0.4,0.4,0.5)
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
	_Gradient ("Gradient (RGB)", 2D) = "black" {}
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
	_Offset ("Offset", float) = 0
	
}
SubShader {
	LOD 200
	Tags { "RenderType"="Opaque" }
	
CGPROGRAM
#pragma surface surf Lambert

sampler2D _MainTex;
sampler2D _Gradient;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;
float _Offset;

struct Input {
	float2 uv_MainTex;
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 gradient = tex2D(_Gradient, IN.uv_MainTex + float2(0,_Offset));
	fixed4 c = tex * _Color;
	o.Albedo = c.rgb;
	
	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
	reflcol *= tex.a;
	o.Emission = reflcol.rgb * _ReflectColor.rgb + gradient; 
	o.Alpha = reflcol.a * _ReflectColor.a;
}
ENDCG
}
	
FallBack "Reflective/VertexLit"
} 
