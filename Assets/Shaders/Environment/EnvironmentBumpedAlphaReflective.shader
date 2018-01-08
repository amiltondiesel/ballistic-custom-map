Shader "Ballistic/Environment/BumpedAlphaReflective" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

	//HIGH QUALITY

SubShader {

	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 300
	
		CGPROGRAM
		#pragma surface surf Lambert alpha:blend
		#pragma exclude_renderers d3d11_9x

		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _Cube;

		fixed4 _Color;
		fixed4 _ReflectColor;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c = tex * _Color;
			o.Albedo = c.rgb;
			
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			
			float3 worldRefl = WorldReflectionVector (IN, o.Normal);
			fixed4 reflcol = texCUBE (_Cube, worldRefl);
			reflcol *= tex.a;
			o.Emission = reflcol.rgb * _ReflectColor.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	//MEDIUM QUALITY
	
SubShader {
	LOD 200
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
			
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
			fixed4 c = tex * _Color;
			o.Albedo = c.rgb;
			
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
			reflcol *= tex.a;
			o.Emission = reflcol.rgb * _ReflectColor.rgb;
			o.Alpha = reflcol.a * _ReflectColor.a;
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	//LOW QUALITY
	
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100

		CGPROGRAM
		#pragma surface surf Lambert alpha:blend

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
		}

}
