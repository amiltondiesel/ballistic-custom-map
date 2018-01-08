Shader "Ballistic/Vegetation/SpikesVertexColor" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_Emission ("Emission", Color) = (0,0,0,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
}

SubShader {

	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	Cull Off

CGPROGRAM
#pragma surface surf Lambert alpha:blend

sampler2D _MainTex;
fixed4 _Color;
fixed4 _Emission;

struct Input {
	float2 uv_MainTex;
	fixed4 color : COLOR;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb * IN.color.rgb;
	o.Emission = c.rgb * _Emission;
	o.Alpha = c.a;
}
ENDCG
}

Fallback "Transparent/VertexLit"
}
