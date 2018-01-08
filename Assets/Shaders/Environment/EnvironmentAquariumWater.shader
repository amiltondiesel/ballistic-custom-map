Shader "Ballistic/Environment/AquariumWater" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_BumpAmt  ("Distortion", range (0,128)) = 10
	_MainTex ("Tint Color (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

Category {

	Tags { "Queue"="Transparent"}

	SubShader {

		GrabPass {							
			Name "BASE"
			Tags { "LightMode" = "Always" }
 		}
 		
		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"

		struct appdata_t {
			float4 vertex : POSITION;
			float2 texcoord: TEXCOORD0;
		};

		struct v2f {
			float4 vertex : POSITION;
			float4 uvgrab : TEXCOORD0;
			float2 uvbump : TEXCOORD1;
			float2 uvmain : TEXCOORD2;
		};

		fixed4 _Color;
		float _BumpAmt;
		float4 _BumpMap_ST;
		float4 _MainTex_ST;

		v2f vert (appdata_t v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uvgrab = ComputeGrabScreenPos(o.vertex);
			o.uvbump = TRANSFORM_TEX( v.texcoord, _BumpMap );
			o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
			return o;
		}

		sampler2D _GrabTexture;
		sampler2D _BumpMap;
		sampler2D _MainTex;

		half4 frag( v2f i ) : COLOR
		{

			half4 tint = tex2D( _MainTex, i.uvmain - frac(float2(0,1) * half2(0,_Time.y * 0.1) ));
			half2 bump = UnpackNormal(tex2D( _BumpMap, i.uvbump - frac(float2(0,1) * half2(0,_Time.y * 0.2) ))).rg;

			i.uvgrab.xy += bump * _BumpAmt * 0.01;
			
			half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));	
			return lerp(_Color,col * tint * 2,_Color.a);
		}
		ENDCG
				}
			}

			// ------------------------------------------------------------------
			// Fallback for older cards and Unity non-Pro
			
			SubShader {
				Blend DstColor Zero
				Pass {
					Name "BASE"
					SetTexture [_MainTex] {	combine texture }
				}
			}
	}

}
