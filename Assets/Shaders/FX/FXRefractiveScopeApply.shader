Shader "Ballistic/FX/RefractiveScopeApply" {

Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "" {}
}

	// MEDIUM QUALITY	

SubShader {
	
		Tags { "Queue"="Background"}
		LOD 200
		
		GrabPass{ "_GrabMaskScope"
		Tags{ "Queue" = "Background" "LightMode" = "Always"}
		}

		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		sampler2D _GrabMaskScope;
		fixed4 _Color;
		half _Shininess;
		samplerCUBE _Cube;

		struct Input
		{
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf(Input IN, inout SurfaceOutput o) {

			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 grab = tex2D(_GrabMaskScope,IN.uv_MainTex);

			fixed4 reflcol = texCUBE(_Cube, IN.worldRefl);

			o.Gloss = 1;
			o.Specular = _Shininess;

			o.Albedo = grab * tex * _Color * reflcol.rgb * 2;
			o.Emission = o.Albedo * 0.7;

		}
		ENDCG
	}

		// LOW QUALITY	

SubShader {
	
		Tags { "Queue"="Background"}
		LOD 100
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed4 _Color;
		samplerCUBE _Cube;

		struct Input 
		{	
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);

			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
			
			o.Albedo = tex * _Color * reflcol.rgb * 0.5;
			o.Emission = o.Albedo * 0.7;
			
		}
		ENDCG  
	}

}

