Shader "Ballistic/FX/HealthStation" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_Exposure("Exposure", Range(0, 20)) = 1.0
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
		_MetallicGlossMap("Metallic", 2D) = "white" {}
		_EmissionMap("Emission", 2D) = "white" {}
		_OcclusionMap("Occlusion", 2D) = "white" {}
		[KeywordEnum(OFF, ON)] HIGHLIGHT("Highlight",Float) = 0
		_HighlightMap ("Hightlight", 2D) = "white" {}
	}

		//HIGH QUALITY

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0
		#pragma shader_feature HIGHLIGHT_OFF HIGHLIGHT_ON

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _MetallicGlossMap;
		sampler2D _EmissionMap;
		sampler2D _OcclusionMap;
		sampler2D _HighlightMap;

		struct Input {
			float2 uv_MainTex;

		#if HIGHLIGHT_ON
			float3 worldPos;
		#endif

		};

		fixed4 _Color;
		float _Exposure;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			o.Metallic = m.r;
			o.Smoothness = m.a;

			#if HIGHLIGHT_OFF
			o.Emission = tex2D(_EmissionMap, IN.uv_MainTex) * _Exposure * 10;
			#endif

			#if HIGHLIGHT_ON
			fixed3 emission = tex2D(_EmissionMap, IN.uv_MainTex);
			fixed3 highlight = tex2D(_HighlightMap, (IN.worldPos.xy * 0.7) - frac(_Time.y * 0.55));
			o.Emission = (emission * _Exposure * 10) + highlight;
			#endif

			o.Occlusion = tex2D(_OcclusionMap, IN.uv_MainTex);
			o.Alpha = c.a;
		}
		ENDCG
	}

		//MEDIUM QUALITY

		SubShader{
			Tags{ "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
#pragma surface surf Standard fullforwardshadows
#pragma shader_feature HIGHLIGHT_OFF HIGHLIGHT_ON

			sampler2D _MainTex;
			sampler2D _BumpMap;
			sampler2D _MetallicGlossMap;
			sampler2D _EmissionMap;
			sampler2D _OcclusionMap;
			sampler2D _HighlightMap;

		struct Input {
			float2 uv_MainTex;

		#if HIGHLIGHT_ON
			float3 worldPos;
		#endif

		};

		fixed4 _Color;
		float _Exposure;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			o.Metallic = m.r;
			o.Smoothness = m.a;

#if HIGHLIGHT_OFF
			o.Emission = tex2D(_EmissionMap, IN.uv_MainTex) * _Exposure * 10;
#endif

#if HIGHLIGHT_ON
			fixed3 emission = tex2D(_EmissionMap, IN.uv_MainTex);
			fixed3 highlight = tex2D(_HighlightMap, (IN.worldPos.xy * 0.7) - frac(_Time.y * 0.55));
			o.Emission = (emission * _Exposure * 10) + highlight;
#endif

			o.Occlusion = tex2D(_OcclusionMap, IN.uv_MainTex);
			o.Alpha = c.a;
		}
		ENDCG
		}

			//LOW QUALITY

			SubShader{
			Tags{ "RenderType" = "Opaque" }
			LOD 100

			CGPROGRAM
#pragma surface surf Lambert 
#pragma shader_feature HIGHLIGHT_OFF HIGHLIGHT_ON

		sampler2D _MainTex;
		sampler2D _EmissionMap;
		sampler2D _HighlightMap;

		struct Input {
			float2 uv_MainTex;

#if HIGHLIGHT_ON
			float3 worldPos;
#endif

		};

		fixed4 _Color;
		float _Exposure;

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb * 0.3;

#if HIGHLIGHT_OFF
			o.Emission = tex2D(_EmissionMap, IN.uv_MainTex);
#endif

#if HIGHLIGHT_ON
			fixed3 emission = tex2D(_EmissionMap, IN.uv_MainTex);
			fixed3 highlight = tex2D(_HighlightMap, (IN.worldPos.xy * 0.7) - frac(_Time.y * 0.55));
			o.Emission = emission + highlight;
#endif
			o.Alpha = c.a;
		}
		ENDCG
		}


	FallBack "Diffuse"
}
