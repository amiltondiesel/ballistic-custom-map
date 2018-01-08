// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Ballistic/FX/AimDistort"
{
Properties {
	_Color	("Color", Color) = (0.5,0.5,0.5,0.5)
	_BumpAmt 	("Distortion", float) = 10
	_MainTex 	("Tint Color (RGB)", 2D) = "white" {}
	_BumpMap 	("Normalmap", 2D) = "bump" {}
}

	Category
	{

		Tags
		{
			"Queue" = "Transparent-1"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		
		}

		// MEDIUM QUALITY
			
		SubShader
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Blend SrcAlpha OneMinusSrcAlpha
			LOD 200
			
			GrabPass {							
				Tags {"LightMode" = "Always"}
			}
			
			Pass
			{
			
				Name "BASE"
				Tags { 
						"LightMode" = "Always"
					}
				
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			float _BumpAmt;
			float4 _MainTex_ST;
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _BumpMap;
			sampler2D _MainTex;
			fixed4 _Color;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				float4 uvgrab : TEXCOORD0;
				float2 uvmain : TEXCOORD2;
			};


			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				o.uvgrab.z = 1;
				o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
				return o;
			}


			half4 frag( v2f i ) : COLOR
			{
				half4 tint = tex2D( _MainTex, i.uvmain);
				half2 bump = UnpackNormal(tex2D( _BumpMap, i.uvmain)).rg;
				float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize;
				
				i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
				
				half4 red = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab) + half4(0.005,0.001,0,0));
				half4 green = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				half4 blue = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab) + half4(-0.004,0.002,0,0));

				half4 col = half4(red.r,0,0,1);
				col += half4(0,green.g,0,1);
				col += half4(0,0,blue.b,1);
				
				col *= tint * 2;
				
				col.a = tint.a * _Color.a;
				
				
				return col;
			}
		ENDCG
			}
		}
		
		// MEDIUM QUALITY
		
		    SubShader {
	
			Tags 
			{
				"Queue" = "Transparent-1"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
			}
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Blend DstColor SrcColor
			LOD 100
			
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
		  
			sampler2D _MainTex;
			sampler2D _Trim;
			fixed4 _Color;
			
			struct appdata_t
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				return o;
			}
		  
		  
		  half4 frag (v2f IN) : COLOR
			{;
				fixed4 col = tex2D(_MainTex, IN.texcoord) * IN.color * _Color;
				fixed4 res = lerp(fixed4(0.5,0.5,0.5,0),col,_Color.a * col.a);
				return res;
			}
		
      ENDCG
		}
    }
	}
}
