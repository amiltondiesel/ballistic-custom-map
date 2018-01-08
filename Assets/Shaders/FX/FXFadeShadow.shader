Shader "Ballistic/FX/FadeShadow" 
{
	Properties 
	{
		_BurnColor ("Burn Color", Color) = (0.2,0.2,0.2,0) 
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_BurnExp ("Burn Exponent", float) = 10
		_Emission ("Emission", float) = 10
		_Team ("Team", float) = 1.0
		_MainTex ("Base (RGB) RefStrGloss (A)", 2D) = "white" {}
		_Alpha ("Alpha Gradient", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}
	SubShader 
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		Cull Off
		
		CGPROGRAM
		#pragma surface surf Lambert nolightmap alphatest:_Cutoff

		sampler2D _Alpha;
		fixed4 _BurnColor;
		fixed _Emission;
		fixed _BurnExp;
		fixed _Team;
		
		sampler2D _MainTex;
		sampler2D _BumpMap;
		
		
		struct Input 
		{
			float2 uv_MainTex;
		};
		
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed greyscale = dot(tex.rgb, float3(0.3, 0.59, 0.11)) * _Emission;
			fixed4 alpha = tex2D(_Alpha, IN.uv_MainTex).a;
			fixed4 burn = pow(alpha,_BurnExp) - 2;
			fixed4 range = clamp(burn,0,3) * _BurnColor;
			o.Albedo = greyscale + range;
			o.Emission = range;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			o.Alpha = alpha;
		}
		
		ENDCG
	}
}