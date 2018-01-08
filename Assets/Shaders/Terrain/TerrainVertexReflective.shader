Shader "Ballistic/Terrain/VertexReflective"
{
	Properties 
	{
		_Splat0 ("Layer 0 (R)", 2D) = "white" {}
		_Splat1 ("Layer 1 (G)", 2D) = "white" {}
		_Splat2 ("Layer 2 (B)", 2D) = "white" {}
		_Splat3 ("Layer 3 (A)", 2D) = "white" {}
		_BaseMap ("BaseMap (RGB)", 2D) = "white" {}
		_Offset ("Offset",float) = 0.1
	}
	
	Category 
	{
		// Fragment program, 4 splats per pass
		SubShader 
		{
			Tags 
			{
				"SplatCount" = "4"
				"Queue" = "Geometry-100"
				"RenderType" = "Opaque"
			}
			Pass 
			{
				Tags { "LightMode" = "Always" }
				CGPROGRAM
				#pragma vertex simplevert
				#pragma fragment simplefrag
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma shader_feature LIGHTMAP_ON LIGHTMAP_OFF
				#define TEXTURECOUNT 4	
	
				#include "UnityCG.cginc"
		
				struct appdata_lightmap 
				{
				    float4 vertex : POSITION;
				    float3 normal : NORMAL;
					fixed4 color : COLOR;
				    float2 texcoord : TEXCOORD0;
				    float2 texcoord1 : TEXCOORD1;
				};
				
				struct v2f_vertex {
					float4 pos : SV_POSITION;
					float4 uv[4] : TEXCOORD0;
					float4 color : COLOR;
				};
				
				uniform sampler2D _Control;
				uniform float4 _Control_ST;
				
				uniform sampler2D _BaseMap;
				uniform float4 _BaseMap_ST;
				
				uniform float _Offset;
				
				#ifdef LIGHTMAP_ON
				// uniform float4 unity_LightmapST;
				// uniform sampler2D unity_Lightmap;
				#endif
				
				uniform sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
				uniform float4 _Splat0_ST,_Splat1_ST,_Splat2_ST,_Splat3_ST;
				
				v2f_vertex simplevert (appdata_lightmap v) 
				{
					v2f_vertex o;
					UNITY_INITIALIZE_OUTPUT(v2f_vertex,o);
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv[0].xy = TRANSFORM_TEX(v.texcoord.xy, _Control);
					
					#ifdef LIGHTMAP_ON	
					o.uv[0].zw = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#else
					o.uv[0].zw = half2(0,0);
					#endif
					
					o.uv[1].xy = TRANSFORM_TEX (v.texcoord.xy, _Splat0);
					o.uv[1].zw = TRANSFORM_TEX (v.texcoord.xy, _Splat1);
					o.uv[2].xy = TRANSFORM_TEX (v.texcoord.xy, _Splat2);
					o.uv[2].zw = TRANSFORM_TEX (v.texcoord.xy, _Splat3);
					o.uv[3].xy = TRANSFORM_TEX (v.texcoord.xy, _BaseMap);
					o.color = v.color;
					return o;
				}
				
				float4 simplefrag (v2f_vertex i) : COLOR 
				{
					half4 m = i.color; 
					half4 c = tex2D(_BaseMap, i.uv[3].xy);
					float a = c.a; c.a = 1;
					
					half4 s0 = tex2D(_Splat0, i.uv[1].xy);
					float a0 = s0.a; s0.a = saturate((i.color.x * a0*7)-_Offset); 
					half4 s1 = tex2D(_Splat1, i.uv[1].zw);
					float a1 = s1.a;s1.a = saturate((i.color.y * a1*7)-_Offset);  
					half4 s2 = tex2D(_Splat2, i.uv[2].xy);
					float a2 = s2.a;s2.a = saturate((i.color.z * a2*7)-_Offset);  
					half4 s3 = tex2D(_Splat3, i.uv[2].zw);
					float a3 = s3.a;s3.a = saturate((i.color.w * a3*7)-_Offset); 
					
					c = c + (s0.a * (s0-c));
					c = c + (s1.a * (s1-c));
					c = c + (s2.a * (s2-c));
					c = c + (s3.a * (s3-c));
										
					#ifdef LIGHTMAP_ON
					c.rgb *= DecodeLightmap( UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv[0].zw) + 0.01 );
					#endif
					
					return c; 
				}
				
				ENDCG
			}
	 	}
	}
	
	Fallback Off
}