Shader "Ballistic/Environment/SurfaceOpaque" {

Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	[KeywordEnum(HIGH, MEDIUM, LOW)] QUALITY ("Maxium Quality",Float) = 0
	[KeywordEnum(OFF, 1X, 2X,)] VERTEX_COLOR ("Vertex Color",Float) = 0
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	[Space(30)][KeywordEnum(OFF, TEXTURE, VERTEX_COLOR)] EMISSIVE ("Emissive",Float) = 0
	_EmissionColor ("Emission", Color) = (1,1,1,1)
	[Gamma] _Exposure ("Exposure", Range(0, 20)) = 1.0
	_Illum ("Illumin (A)", 2D) = "white" {}
}

	//HIGH QUALITY

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300
	
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma exclude_renderers d3d11_9x
		#pragma shader_feature QUALITY_HIGH QUALITY_MEDIUM QUALITY_LOW
		#pragma shader_feature VERTEX_COLOR_OFF VERTEX_COLOR_1X VERTEX_COLOR_2X
		#pragma shader_feature EMISSIVE_OFF EMISSIVE_TEXTURE EMISSIVE_VERTEX_COLOR

		#if QUALITY_HIGH
		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _Cube;
		fixed4 _Color;
		fixed4 _ReflectColor;
		#if EMISSIVE_TEXTURE
		fixed4 _EmissionColor;
		half _Exposure;
		sampler2D _Illum;
		#endif
		#if EMISSIVE_VERTEX_COLOR
		fixed4 _EmissionColor;
		half _Exposure;
		#endif
		#endif
		
		#if QUALITY_MEDIUM
		sampler2D _MainTex;
		samplerCUBE _Cube;
		fixed4 _Color;
		fixed4 _ReflectColor;
		#if EMISSIVE_TEXTURE
		fixed4 _EmissionColor;
		half _Exposure;
		sampler2D _Illum;
		#endif
		#if EMISSIVE_VERTEX_COLOR
		fixed4 _EmissionColor;
		half _Exposure;
		#endif
		#endif
		
		#if QUALITY_LOW
		sampler2D _MainTex;
		fixed4 _Color;
		fixed4 _ReflectColor;
		#if EMISSIVE_TEXTURE
		fixed4 _EmissionColor;
		half _Exposure;
		sampler2D _Illum;
		#endif
		#if EMISSIVE_VERTEX_COLOR
		fixed4 _EmissionColor;
		half _Exposure;
		#endif
		#endif
		

		struct Input {
		
			#if QUALITY_HIGH
			float2 uv_MainTex;
			float3 worldRefl;
			#if VERTEX_COLOR_OFF
			#if EMISSIVE_VERTEX_COLOR
			fixed4 color : COLOR;
			#endif
			#else
			fixed4 color : COLOR;
			#endif
			INTERNAL_DATA
			#endif
			
			#if QUALITY_MEDIUM
			float2 uv_MainTex;
			float3 worldRefl;
			#if VERTEX_COLOR_OFF
			#if EMISSIVE_VERTEX_COLOR
			fixed4 color : COLOR;
			#endif
			#else
			fixed4 color : COLOR;
			#endif
			#endif
			
			#if QUALITY_LOW
			float2 uv_MainTex;
			#if VERTEX_COLOR_OFF
			#if EMISSIVE_VERTEX_COLOR
			fixed4 color : COLOR;
			#endif
			#else
			fixed4 color : COLOR;
			#endif
			#endif
			
		};

		void surf (Input IN, inout SurfaceOutput o) {
		
			// ALBEDO
		
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c = tex * _Color;
			
			#if VERTEX_COLOR_OFF
			o.Albedo = c.rgb;
			#endif
			
			#if VERTEX_COLOR_1X
			o.Albedo = lerp(c.rgb,c.rgb * IN.color,tex.a);
			#endif
			
			#if VERTEX_COLOR_2X
			o.Albedo = lerp(c.rgb,c.rgb * IN.color * 2,tex.a);
			#endif
			
			// REFLECTION
			
			#if QUALITY_HIGH
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			float3 worldRefl = WorldReflectionVector (IN, o.Normal);
			fixed4 reflcol = texCUBE (_Cube, worldRefl);
			reflcol *= tex.a;
			#if VERTEX_COLOR_OFF
			reflcol.rgb *= _ReflectColor.rgb;
			#else
			reflcol.rgb *= lerp(_ReflectColor.rgb,IN.color.rgb,_ReflectColor.a);
			#endif
			#endif
			
			#if QUALITY_MEDIUM
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
			reflcol *= tex.a;
			#if VERTEX_COLOR_OFF
			reflcol.rgb *= _ReflectColor.rgb;
			#else
			reflcol.rgb *= lerp(_ReflectColor.rgb,IN.color.rgb,_ReflectColor.a);
			#endif
			#endif
			
			#if QUALITY_LOW
			fixed4 reflcol = 0;
			#endif
			
			// EMISSION
			
			#if EMISSIVE_OFF
			o.Emission = reflcol.rgb;
			#endif
			
			#if EMISSIVE_TEXTURE
			o.Emission = reflcol.rgb + (c.rgb * _EmissionColor * tex2D(_Illum, IN.uv_MainTex) * _Exposure);
			#endif
			
			#if EMISSIVE_VERTEX_COLOR
			o.Emission = reflcol.rgb + (c.rgb * _EmissionColor * IN.color * _Exposure);
			#endif
		
		}
		ENDCG
	}
	
	//MEDIUM QUALITY
	
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 200
	
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma exclude_renderers d3d11_9x
		#pragma shader_feature QUALITY_HIGH QUALITY_MEDIUM QUALITY_LOW
		#pragma shader_feature VERTEX_COLOR_OFF VERTEX_COLOR_1X VERTEX_COLOR_2X
		#pragma shader_feature EMISSIVE_OFF EMISSIVE_TEXTURE EMISSIVE_VERTEX_COLOR

		#if QUALITY_HIGH
		sampler2D _MainTex;
		samplerCUBE _Cube;
		fixed4 _Color;
		fixed4 _ReflectColor;
		#if EMISSIVE_TEXTURE
		fixed4 _EmissionColor;
		half _Exposure;
		sampler2D _Illum;
		#endif
		#if EMISSIVE_VERTEX_COLOR
		fixed4 _EmissionColor;
		half _Exposure;
		#endif
		#endif
		
		#if QUALITY_MEDIUM
		sampler2D _MainTex;
		samplerCUBE _Cube;
		fixed4 _Color;
		fixed4 _ReflectColor;
		#if EMISSIVE_TEXTURE
		fixed4 _EmissionColor;
		half _Exposure;
		sampler2D _Illum;
		#endif
		#if EMISSIVE_VERTEX_COLOR
		fixed4 _EmissionColor;
		half _Exposure;
		#endif
		#endif
		
		#if QUALITY_LOW
		sampler2D _MainTex;
		fixed4 _Color;
		fixed4 _ReflectColor;
		#if EMISSIVE_TEXTURE
		fixed4 _EmissionColor;
		half _Exposure;
		sampler2D _Illum;
		#endif
		#if EMISSIVE_VERTEX_COLOR
		fixed4 _EmissionColor;
		half _Exposure;
		#endif
		#endif
		

		struct Input {
		
			#if QUALITY_HIGH
			float2 uv_MainTex;
			float3 worldRefl;
			#if VERTEX_COLOR_OFF
			#if EMISSIVE_VERTEX_COLOR
			fixed4 color : COLOR;
			#endif
			#else
			fixed4 color : COLOR;
			#endif
			#endif
			
			#if QUALITY_MEDIUM
			float2 uv_MainTex;
			float3 worldRefl;
			#if VERTEX_COLOR_OFF
			#if EMISSIVE_VERTEX_COLOR
			fixed4 color : COLOR;
			#endif
			#else
			fixed4 color : COLOR;
			#endif
			#endif
			
			#if QUALITY_LOW
			float2 uv_MainTex;
			#if VERTEX_COLOR_OFF
			#if EMISSIVE_VERTEX_COLOR
			fixed4 color : COLOR;
			#endif
			#else
			fixed4 color : COLOR;
			#endif
			#endif
			
		};

		void surf (Input IN, inout SurfaceOutput o) {
		
			// ALBEDO
		
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c = tex * _Color;
			
			#if VERTEX_COLOR_OFF
			o.Albedo = c.rgb;
			#endif
			
			#if VERTEX_COLOR_1X
			o.Albedo = lerp(c.rgb,c.rgb * IN.color,tex.a);
			#endif
			
			#if VERTEX_COLOR_2X
			o.Albedo = lerp(c.rgb,c.rgb * IN.color * 2,tex.a);
			#endif
			
			// REFLECTION
			
			#if QUALITY_HIGH
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
			reflcol *= tex.a;
			#if VERTEX_COLOR_OFF
			reflcol.rgb *= _ReflectColor.rgb;
			#else
			reflcol.rgb *= lerp(_ReflectColor.rgb,IN.color.rgb,_ReflectColor.a);
			#endif
			#endif
			
			#if QUALITY_MEDIUM
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
			reflcol *= tex.a;
			#if VERTEX_COLOR_OFF
			reflcol.rgb *= _ReflectColor.rgb;
			#else
			reflcol.rgb *= lerp(_ReflectColor.rgb,IN.color.rgb,_ReflectColor.a);
			#endif
			#endif
			
			#if QUALITY_LOW
			fixed4 reflcol = 0;
			#endif
			
			// EMISSION
			
			#if EMISSIVE_OFF
			o.Emission = reflcol.rgb * _ReflectColor.rgb;
			#endif
			
			#if EMISSIVE_TEXTURE
			o.Emission = (reflcol.rgb * _ReflectColor.rgb) + (c.rgb * _EmissionColor * tex2D(_Illum, IN.uv_MainTex) * _Exposure);
			#endif
			
			#if EMISSIVE_VERTEX_COLOR
			o.Emission = (reflcol.rgb * _ReflectColor.rgb) + (c.rgb * _EmissionColor * IN.color * _Exposure);
			#endif
		
		}
		ENDCG
	}
	
	//LOW QUALITY
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGPROGRAM
		#pragma surface surf Lambert
		#pragma exclude_renderers d3d11_9x
		#pragma shader_feature VERTEX_COLOR_OFF VERTEX_COLOR_1X VERTEX_COLOR_2X
		#pragma shader_feature EMISSIVE_OFF EMISSIVE_TEXTURE EMISSIVE_VERTEX_COLOR
	
		sampler2D _MainTex;
		fixed4 _Color;
		fixed4 _ReflectColor; 
		#if EMISSIVE_TEXTURE
		fixed4 _EmissionColor;
		half _Exposure;
		sampler2D _Illum;
		#endif
		#if EMISSIVE_VERTEX_COLOR
		fixed4 _EmissionColor;
		half _Exposure;
		#endif
		

		struct Input {
		
			float2 uv_MainTex;
			#if VERTEX_COLOR_OFF
			#if EMISSIVE_VERTEX_COLOR
			fixed4 color : COLOR;
			#endif
			#else
			fixed4 color : COLOR;
			#endif
			
		};

		void surf (Input IN, inout SurfaceOutput o) {
		
			// ALBEDO
		
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c = tex * _Color;
			
			#if VERTEX_COLOR_OFF
			o.Albedo = c.rgb;
			#endif
			
			#if VERTEX_COLOR_1X
			o.Albedo = lerp(c.rgb,c.rgb * IN.color,tex.a);
			#endif
			
			#if VERTEX_COLOR_2X
			o.Albedo = lerp(c.rgb,c.rgb * IN.color * 2,tex.a);
			#endif
			
			// EMISSION
			
			#if EMISSIVE_OFF
			o.Emission = 0;
			#endif
			
			#if EMISSIVE_TEXTURE
			o.Emission = c.rgb * _EmissionColor * tex2D(_Illum, IN.uv_MainTex) * _Exposure;
			#endif
			
			#if EMISSIVE_VERTEX_COLOR
			o.Emission = c.rgb * _EmissionColor * IN.color * _Exposure;
			#endif
		
		}
		ENDCG
		}

}
