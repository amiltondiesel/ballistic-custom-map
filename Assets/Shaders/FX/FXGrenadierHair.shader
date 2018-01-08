Shader "Ballistic/FX/GrenadierHair" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_AlphaTex ("Alpha (R)", 2D) = "white" {}
		_BumpTex("Normal Map", 2D) = "bump" {}
		_MetallicGlossMap("Metallic", 2D) = "white" {}
		_OcclusionMap("Occlusion", 2D) = "white" {}
		_OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
		_NormalMapScale("Normal Scale", Float) = 1.0
	}
	
	// HIGH QUALITY
	
	SubShader {
	
		Tags { "RenderType"="Opaque" }
		LOD 300
		ZWrite Off
		
		// RENDER BACK FACES
		
		Cull Front
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		

		sampler2D	_MainTex;
		sampler2D	_AlphaTex;
		sampler2D	_BumpTex;
		sampler2D	_MetallicGlossMap;
		sampler2D	_OcclusionMap;
		half _OcclusionStrength;
		half _NormalMapScale;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed alpha = tex2D(_AlphaTex, IN.uv_MainTex).r;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			fixed occ = saturate(tex2D(_OcclusionMap, IN.uv_MainTex).r + (1-_OcclusionStrength));
			o.Albedo = c;
			o.Alpha = alpha;
			o.Normal = UnpackScaleNormal(tex2D(_BumpTex,IN.uv_MainTex), _NormalMapScale);
			o.Metallic = m.r;
			o.Smoothness = m.a;
			o.Occlusion = occ;
			
		}
		ENDCG
		
		// RENDER FRONT FACES
		
		Cull Back

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		

		sampler2D	_MainTex;
		sampler2D	_AlphaTex;
		sampler2D	_BumpTex;
		sampler2D	_MetallicGlossMap;
		sampler2D	_OcclusionMap;
		half _OcclusionStrength;
		half _NormalMapScale;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed alpha = tex2D(_AlphaTex, IN.uv_MainTex).r;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			fixed occ = saturate(tex2D(_OcclusionMap, IN.uv_MainTex).r + (1-_OcclusionStrength));
			o.Albedo = c;
			o.Alpha = alpha;
			o.Normal = UnpackScaleNormal(tex2D(_BumpTex,IN.uv_MainTex), _NormalMapScale);
			o.Metallic = m.r;
			o.Smoothness = m.a;
			o.Occlusion = occ;
			
		}
		ENDCG
	}
	
		// MEDIUM QUALITY
	
	SubShader {
	
		Tags { "RenderType"="Opaque" }
		LOD 200
		ZWrite Off
		
		// RENDER BACK FACES
		
		Cull Front
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade


		sampler2D	_MainTex;
		sampler2D	_AlphaTex;
		sampler2D	_BumpTex;
		sampler2D	_MetallicGlossMap;
		sampler2D	_OcclusionMap;
		half _NormalMapScale;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed alpha = tex2D(_AlphaTex, IN.uv_MainTex).r;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			fixed occ = tex2D(_OcclusionMap, IN.uv_MainTex).r;
			o.Albedo = c;
			o.Alpha = alpha;
			o.Normal = UnpackScaleNormal(tex2D(_BumpTex,IN.uv_MainTex), _NormalMapScale);
			o.Metallic = m.r;
			o.Smoothness = m.a;
			o.Occlusion = occ;
			
		}
		ENDCG
		
		// RENDER FRONT FACES
		
		Cull Back

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade


		sampler2D	_MainTex;
		sampler2D	_AlphaTex;
		sampler2D	_BumpTex;
		sampler2D	_MetallicGlossMap;
		sampler2D	_OcclusionMap;
		half _OcclusionStrength;
		half _NormalMapScale;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed alpha = tex2D(_AlphaTex, IN.uv_MainTex).r;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			fixed occ = tex2D(_OcclusionMap, IN.uv_MainTex).r;
			o.Albedo = c;
			o.Alpha = alpha;
			o.Normal = UnpackScaleNormal(tex2D(_BumpTex,IN.uv_MainTex), _NormalMapScale);
			o.Metallic = m.r;
			o.Smoothness = m.a;
			o.Occlusion = occ;
			
		}
		ENDCG
	}
	
	// LOW QUALITY
	
	SubShader {
	
		Tags { "RenderType"="Opaque" }
		LOD 100
		ZWrite Off
		
		// RENDER BACK FACES
		
		Cull Front
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade


		sampler2D	_MainTex;
		sampler2D	_AlphaTex;
		sampler2D	_BumpTex;
		sampler2D	_MetallicGlossMap;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed alpha = tex2D(_AlphaTex, IN.uv_MainTex).r;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			o.Albedo = c;
			o.Alpha = alpha;
			o.Metallic = m.r;
			o.Smoothness = m.a;
			
		}
		ENDCG
		
		// RENDER FRONT FACES
		
		Cull Back

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade


		sampler2D	_MainTex;
		sampler2D	_AlphaTex;
		sampler2D	_BumpTex;
		sampler2D	_MetallicGlossMap;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed alpha = tex2D(_AlphaTex, IN.uv_MainTex).r;
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			o.Albedo = c;
			o.Alpha = alpha;
			o.Metallic = m.r;
			o.Smoothness = m.a;
			
		}
		ENDCG
	}

}
