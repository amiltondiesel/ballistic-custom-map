Shader "Ballistic/UI/LogoRim" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {} 
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
}
SubShader {

		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
CGPROGRAM
#pragma surface surf Lambert alpha:blend

sampler2D _MainTex;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;

struct Input {
	float2 uv_MainTex;
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = lerp(tex,_Color,_Color.a);
	o.Albedo = 0;
	o.Alpha = tex.a;
	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
	o.Emission = lerp(_Color + (reflcol.rgb * _ReflectColor.rgb * 2),tex,_Color.a);
}
ENDCG
}

}