Shader "Ballistic/Terrain/OilReflective" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
	_BlendTex1 ("Blend1 (R) RefStrength (A)", 2D) = "white" {}
	_BlendTex2 ("Blend2 (G) RefStrength (A)", 2D) = "white" {}
	_BlendTex3 ("Blend3 (B) RefStrength (A)", 2D) = "white" {}
	_BlendTex4 ("Blend4 (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_MaskTex ("Mask (RGBA)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
}

	// HIGH QUALITY

SubShader {
	LOD 300
	Tags { "RenderType"="Opaque" }
	
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _BlendTex1;
		sampler2D _BlendTex2;
		sampler2D _BlendTex3;
		sampler2D _BlendTex4;
		sampler2D _MaskTex;
		samplerCUBE _Cube;

		fixed4 _Color;
		fixed4 _ReflectColor;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex*15);
			fixed4 blend1 = tex2D(_BlendTex1, IN.uv_MainTex*30);
			fixed4 blend2 = tex2D(_BlendTex2, IN.uv_MainTex*30);
			fixed4 blend3 = tex2D(_BlendTex3, IN.uv_MainTex*30);
			fixed4 blend4 = tex2D(_BlendTex4, IN.uv_MainTex*30);
			fixed4 mask = tex2D(_MaskTex, IN.uv_MainTex);
			fixed4 c = lerp(tex,blend1,mask.r);
			c = lerp(c,blend2,mask.g);
			c = lerp(c,blend3,mask.b);
			o.Albedo = c.rgb * _Color;
			
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex*15));
			
			float3 worldRefl = WorldReflectionVector (IN, o.Normal);
			fixed4 reflcol = texCUBE (_Cube, worldRefl) * lerp(_ReflectColor * c.a,blend4*4,mask.a);
			//reflcol *= c.a;
			o.Emission = reflcol.rgb;
			o.Alpha = reflcol.a * _ReflectColor.a;
		}
		ENDCG
	}
	
	// MEDIUM QUALITY
	
	SubShader {
	LOD 200
	Tags { "RenderType"="Opaque" }
	
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BlendTex1;
		sampler2D _BlendTex2;
		sampler2D _BlendTex3;
		sampler2D _BlendTex4;
		sampler2D _MaskTex;
		samplerCUBE _Cube;

		fixed4 _Color;
		fixed4 _ReflectColor;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex*15);
			fixed4 blend1 = tex2D(_BlendTex1, IN.uv_MainTex*30);
			fixed4 blend2 = tex2D(_BlendTex2, IN.uv_MainTex*30);
			fixed4 blend3 = tex2D(_BlendTex3, IN.uv_MainTex*30);
			fixed4 blend4 = tex2D(_BlendTex4, IN.uv_MainTex*30);
			fixed4 mask = tex2D(_MaskTex, IN.uv_MainTex);
			fixed4 c = lerp(tex,blend1,mask.r);
			c = lerp(c,blend2,mask.g);
			c = lerp(c,blend3,mask.b);
			o.Albedo = c.rgb * _Color;

			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl) * lerp(_ReflectColor * c.a,blend4*4,mask.a);
			o.Emission = reflcol.rgb;
			o.Alpha = reflcol.a * _ReflectColor.a;
		}
		ENDCG
	}
	
	// LOW QUALITY
	
	SubShader {
	LOD 100
	Tags { "RenderType"="Opaque" }
	
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BlendTex1;
		sampler2D _BlendTex2;
		sampler2D _BlendTex3;
		sampler2D _MaskTex;
		samplerCUBE _Cube;

		fixed4 _Color;
		fixed4 _ReflectColor;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex*15);
			fixed4 blend1 = tex2D(_BlendTex1, IN.uv_MainTex*30);
			fixed4 blend2 = tex2D(_BlendTex2, IN.uv_MainTex*30);
			fixed4 blend3 = tex2D(_BlendTex3, IN.uv_MainTex*30);
			fixed4 mask = tex2D(_MaskTex, IN.uv_MainTex);
			fixed4 c = lerp(tex,blend1,mask.r);
			c = lerp(c,blend2,mask.g);
			c = lerp(c,blend3,mask.b);
			o.Albedo = c.rgb * _Color;
			
			float3 worldRefl = WorldReflectionVector (IN, o.Normal);
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl) * _ReflectColor;
			reflcol *= c.a;
			o.Emission = reflcol.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}

} 
