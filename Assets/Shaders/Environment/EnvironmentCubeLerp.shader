Shader "Ballistic/Environment/DiffuseCubeLerp" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_BlurryColor ("Blurry Color", Color) = (1,1,1,0.5)
	_ReflexColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {} 
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
	_Cube2 ("Blurry Cubemap", Cube) = "_Skybox" {}
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
CGPROGRAM
#pragma surface surf Lambert

sampler2D _MainTex;
samplerCUBE _Cube;
samplerCUBE _Cube2;

fixed4 _Color;
fixed4 _BlurryColor;
fixed4 _ReflexColor;

struct Input {
	float2 uv_MainTex;
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex *  2 * _Color;
	
	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
	fixed4 blurcol = texCUBE (_Cube2, IN.worldRefl);
	o.Emission = tex.g * lerp(reflcol.rgb * _ReflexColor,blurcol * _BlurryColor.rgb,tex.a);
	o.Alpha = tex.a;
}
ENDCG
}
	
FallBack "Reflective/VertexLit"
} 
