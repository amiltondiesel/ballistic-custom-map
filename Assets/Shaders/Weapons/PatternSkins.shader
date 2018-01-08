Shader "Ballistic/Weapons/PatternSkins" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SkinColor ("SkinColor", Color) = (1,1,1,0)
		_SkinTex ("Skin (RGBA)", 2D) = "black" {}
		[NoScaleOffset] _MaskTex ("Mask (R)", 2D) = "white" {}
		_MaskMult("Mask Multiplier", Range(0.0, 1.0)) = 0.85
		[NoScaleOffset] _MetallicGlossMap("Metallic", 2D) = "white" {}
		[NoScaleOffset] _OcclusionMap("Occlusion", 2D) = "white" {}
		_OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
		[Space(20)]_DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
		_DetailNormalMapScale("Scale", Float) = 1.0
		[NoScaleOffset] _DetailNormalMap("Normal Map", 2D) = "bump" {}
		[Space(20)][KeywordEnum(OFF, ON)] EMISSIVE ("Emission",Float) = 0
		_EmissionColor("Color", Color) = (1,1,1)
		_EmissionMap("Emission Map", 2D) = "white" {}
	}
	
	// HIGH QUALITY
	
	SubShader {
		Tags{ "RenderType" = "Opaque" "PerformanceChecks" = "False" }
		LOD 300
		
		Stencil
		{
			Ref 8
			Comp always
			Pass replace
			ZFail replace
		}
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		
		#pragma shader_feature EMISSIVE_OFF EMISSIVE_ON

		sampler2D	_MainTex;
		sampler2D	_SkinTex;
		sampler2D	_MaskTex;
		sampler2D	_MetallicGlossMap;
		sampler2D	_OcclusionMap;
		sampler2D	_DetailAlbedoMap;
		sampler2D	_DetailNormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SkinTex;
			float2 uv_DetailAlbedoMap;
		};

		fixed _MaskMult;
		fixed4 _SkinColor;
		#if EMISSIVE_ON
		fixed4 _EmissionColor;
		sampler2D _EmissionMap;
		#endif
		half _OcclusionStrength;
		half _DetailNormalMapScale;

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 skin = tex2D(_SkinTex, IN.uv_SkinTex);
			fixed mask = tex2D(_MaskTex, IN.uv_MainTex).r;
			fixed3 d = tex2D(_DetailAlbedoMap, IN.uv_DetailAlbedoMap);
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			fixed occ = saturate(tex2D(_OcclusionMap, IN.uv_MainTex).r + (1-_OcclusionStrength));
			half maskmult = mask * _MaskMult;
			o.Albedo = lerp(lerp(c,_SkinColor.rgb,_SkinColor.a),skin,maskmult) * d * 2.2 * occ;
			o.Normal = UnpackScaleNormal(tex2D(_DetailNormalMap,IN.uv_DetailAlbedoMap), _DetailNormalMapScale);
			o.Metallic = m.r;
			o.Smoothness = lerp(m.a,m.a * skin.a,maskmult);
			o.Occlusion = occ;
			o.Alpha = 1;
			
			#if EMISSIVE_ON
			fixed3 e = tex2D(_EmissionMap, IN.uv_SkinTex);
			o.Emission = e * maskmult * _EmissionColor * 2;
			#endif
			
		}
		ENDCG
	}
	
	// MEDIUM QUALITY
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Stencil
		{
			Ref 8
			Comp always
			Pass replace
			ZFail replace
		}
		
		CGPROGRAM
		#pragma surface surf Standard
		#pragma shader_feature EMISSIVE_OFF EMISSIVE_ON
		#pragma target 3.0

		sampler2D	_MainTex;
		sampler2D	_SkinTex;
		sampler2D	_MaskTex;
		sampler2D	_MetallicGlossMap;
		sampler2D	_OcclusionMap;
		sampler2D	_DetailAlbedoMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SkinTex;
			float2 uv_DetailAlbedoMap;
		};

		#if EMISSIVE_ON
		fixed4 _EmissionColor;
		sampler2D _EmissionMap;
		#endif
		
		fixed _MaskMult;
		fixed4 _SkinColor;
		half _OcclusionStrength;

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 skin = tex2D(_SkinTex, IN.uv_SkinTex);
			fixed mask = tex2D(_MaskTex, IN.uv_MainTex).r;
			fixed3 d = tex2D(_DetailAlbedoMap, IN.uv_DetailAlbedoMap);
			fixed4 m = tex2D(_MetallicGlossMap, IN.uv_MainTex);
			fixed occ = saturate(tex2D(_OcclusionMap, IN.uv_MainTex).r + (1-_OcclusionStrength));
			half maskmult = mask * _MaskMult;
			o.Albedo = lerp(lerp(c,_SkinColor.rgb,_SkinColor.a),skin,maskmult) * d * 2.2 * occ;
			o.Metallic = m.r;
			o.Smoothness = lerp(m.a,m.a * skin.a,maskmult);
			o.Occlusion = occ;
			o.Alpha = 1;
			
			#if EMISSIVE_ON
			fixed3 e = tex2D(_EmissionMap, IN.uv_SkinTex);
			o.Emission = e * maskmult * _EmissionColor * 2;
			#endif
		}
		ENDCG
	}
	
	// LOW QUALITY
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 100
		
		Stencil
		{
			Ref 8
			Comp always
			Pass replace
			ZFail replace
		}
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D	_MainTex;
		sampler2D	_SkinTex;
		sampler2D	_MaskTex;
		sampler2D	_OcclusionMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SkinTex;
		};

		#if EMISSIVE_ON
		fixed4 _EmissionColor;
		sampler2D _EmissionMap;
		#endif
		
		fixed _MaskMult;
		fixed4 _SkinColor;
		half _OcclusionStrength;

		void surf (Input IN, inout SurfaceOutput o) {

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 skin = tex2D(_SkinTex, IN.uv_SkinTex);
			fixed mask = tex2D(_MaskTex, IN.uv_MainTex).r;
			fixed occ = saturate(tex2D(_OcclusionMap, IN.uv_MainTex).r + (1-_OcclusionStrength));
			half maskmult = mask * _MaskMult;
			o.Albedo = lerp(lerp(c,_SkinColor.rgb,_SkinColor.a),skin,maskmult) * occ;
			o.Alpha = 1;
			
			#if EMISSIVE_ON
			fixed3 e = tex2D(_EmissionMap, IN.uv_SkinTex);
			o.Emission = e * maskmult * _EmissionColor * 2;
			#endif
			
		}
		ENDCG
	}
	
	FallBack "Diffuse"
}
