Shader "Ballistic/UI/ProgressionCard"
{
    Properties {
		_Color("Color",Color) = (1,1,1,0)
		_MainTex ("Main Texture", 2D) = "grey" {}
		_AlphaTex("Alpha Texture", 2D) = "white" {}
		_BorderTex("Border Texture", 2D) = "white" {}
		_Scale("Scale", float) = 1
		[HideinInspector]_Factor("Factor", float) = 0.32
		_Speed("Speed", float) = 0.5
		_Alpha("Alpha", Range(0,5)) = 0
		_Subtraction("Subtraction", Range(2,0)) = 0
	}
		SubShader{

		Tags

			{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off
			Lighting Off
			ZWrite Off

			Pass
			{

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

				fixed4 _Color;
				sampler2D _MainTex;
				sampler2D _AlphaTex;
				sampler2D _BorderTex;
				float _Subtraction;
				float _Scale;
				float _Factor;
				float _Alpha;
				float _Speed;

				struct appdata_t {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					float2 texcoord1 : TEXCOORD1;
				};

				struct v2f {
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					float2 texcoord1 : TEXCOORD1;
					float2 texcoord2 : TEXCOORD2;
				};

				v2f vert (appdata_t v)
				{
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f, o);
					o.vertex = UnityObjectToClipPos(v.vertex);
					float uvscale = 1 - _Scale;
					o.texcoord = v.texcoord + float2(uvscale * _Factor * v.color.r,0) - float2(uvscale * _Factor * v.color.g,0);
					o.texcoord1 = (v.texcoord1 - frac(float2(_Time.y * _Speed,0))) * float2(_Scale,2) * 8;
					o.texcoord2 = v.texcoord1;
					return o;
				}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord) * fixed4(_Color.r,_Color.g,_Color.b,1) * fixed4(2,2,2,1);
				fixed alpha = tex2D(_AlphaTex, i.texcoord1).a;
				fixed border = tex2D(_BorderTex, i.texcoord2).a;
				tex.a *= saturate((alpha * border * _Alpha * 20) - _Subtraction) * _Color.a;
				
				return tex;
			}
		
      ENDCG
		}
    }
 }
