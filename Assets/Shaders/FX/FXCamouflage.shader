Shader "Ballistic/FX/Camouflage" {

Properties {
	_BaseColor	("Base Color", Color) = (0.5,0.5,0.5,0.5)
	_FxColor	("FX Color", Color) = (0.5,0.5,0.5,0.5)
	_FxAmount ("FX Amount", float) = 1
	_RimAmount ("Rim Amount", float) = 1
	_Distortion ("Distortion", float) = 1
	_ZDepth ("Distortion Depth", float) = 0.8
	_ScrSpeed ("Scroll Speed", float) = 15
	[Space (10)]_RimTex 	("Rim Texture", 2D) = "white" {}
	_FxTex 		("Fx Texture", 2D) = "black" {}
	_BumpMap 	("Normalmap", 2D) = "bump" {}
}

		SubShader
		{
			Tags {
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
			}
				
			GrabPass {
			
				"_GrabWraith"
			}
			
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

				float _Distortion;
				float _ZDepth;
				float _FxAmount;
				float _RimAmount;
				float _ScrSpeed;
				float4 _BumpMap_ST;
				float4 _FxTex_ST;
				sampler2D _GrabWraith;
				float4 _GrabWraith_TexelSize;
				sampler2D _BumpMap;
				sampler2D _RimTex;
				sampler2D _FxTex;
				fixed4 _BaseColor;
				fixed4 _FxColor;

				struct appdata_t
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float2 texcoord: TEXCOORD0;
				};

				struct v2f {
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
					float4 uvgrab : TEXCOORD1;
					float3 vnormal : TEXCOORD2;
					float2 rim : TEXCOORD3;
				};

				v2f vert (appdata_t v)
				{
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f, o);
					o.vertex = UnityObjectToClipPos(v.vertex);

					o.texcoord.xy = TRANSFORM_TEX(v.texcoord,_BumpMap);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord,_FxTex);
					
					float3 objectNormal = normalize(mul((float3x3)UNITY_MATRIX_MVP, v.normal));
					o.vnormal = objectNormal;
					
					float3 viewDir = normalize(ObjSpaceViewDir (v.vertex));
					fixed NdotL = dot (v.normal, viewDir);
					o.rim = fixed2(NdotL, NdotL);
					
					o.uvgrab = ComputeGrabScreenPos(o.vertex);
					
					float depth;
					COMPUTE_EYEDEPTH(depth);
					
					o.uvgrab.z = (depth + 0.2f) * _ZDepth;
					
					return o;
				}


				half4 frag( v2f i ) : COLOR
				{
					half2 bump = UnpackNormal(tex2D( _BumpMap, i.texcoord.xy)).rg;
					
					i.uvgrab.xy += (bump + i.vnormal.xy) * _Distortion * 0.01 * i.uvgrab.z;
					
					fixed4 grab = saturate(tex2Dproj(_GrabWraith, UNITY_PROJ_COORD(i.uvgrab)));
					fixed4 tint = tex2D(_RimTex, i.rim + bump);
					fixed4 fxtex = tex2D(_FxTex,i.texcoord.zw + (bump * 0.1) + frac(_Time.x * _ScrSpeed));
					
					fixed4 albedo = lerp(grab,_BaseColor,_BaseColor.a);
					
					fixed4 effects = lerp(albedo + (fxtex * _FxColor * _FxAmount),tint,tint.a * _RimAmount);
					
					return effects;
				}
		ENDCG
		}
	}
}