Shader "Ballistic/Vegetation/LeafsEmissiveDisplacement" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_Emission ("Emission", Color) = (0,0,0,1)
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
	_WindShakeVelocity ("Shake Velocity", float) = 6
	_WindShakeForce ("Shake Force", float) = 0.18
	_WindDirection ("Wind Direction", Vector) = (0,1,1,0)
}

	// MEDIUM QUALITY

	SubShader {

	Tags {"RenderType"="TransparentCutout"}
	LOD 200
	
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff vertex:VertShader
				
			sampler2D _MainTex;
			fixed4 _Color;
			fixed4 _Emission;
			float _WindShakeVelocity;
			float _WindShakeForce;
			float4 _WindDirection;

			struct Input 
			{
				float2 uv_MainTex;
			};

				void VertShader (inout appdata_full v) 
				{
					half3 dir = normalize(_WindDirection);
					
					half atten = v.color.g;
					
					half sin0 = sin(_Time.x * _WindShakeVelocity*5 * atten);
					half sin1 = sin((_Time.x+3.567) * _WindShakeVelocity * atten);
					half sin2 = sin((_Time.x+11.567) * _WindShakeVelocity);
					
					half3 shkVel = (sin0 * sin1 * dir * v.color.r) + (sin2 * dir * v.color.b * 0.7);
					v.vertex.xyz += shkVel * _WindShakeForce;
				}

				void surf (Input IN, inout SurfaceOutput o)
				{
					fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
				
					o.Albedo = tex * 3 * _Color;
					o.Emission = tex * _Emission;
					o.Alpha = tex.a;
				}
		ENDCG
	}
	
	// LOW QUALITY
	
	SubShader {

		Tags {"RenderType"="TransparentCutout"}
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
