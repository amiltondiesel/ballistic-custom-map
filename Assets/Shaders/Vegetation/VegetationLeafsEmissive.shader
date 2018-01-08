Shader "Ballistic/Vegetation/LeafsEmissive" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_Emission ("Emission", Color) = (0,0,0,1)
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}

}
SubShader {

	Tags{ "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
	LOD 100
	
	
CGPROGRAM
#pragma surface surf Lambert alphatest:_Cutoff
		
	sampler2D _MainTex;
	fixed4 _Emission;
	fixed4 _Color;
	
	struct Input 
	{
		float2 uv_MainTex;
	};


		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
		
			o.Albedo = tex * 3 * _Color;
			o.Emission = tex * _Emission;
			o.Alpha = tex.a;
		}
ENDCG
}

} 
