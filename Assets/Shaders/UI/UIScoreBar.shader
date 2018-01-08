Shader "Ballistic/UI/ScoreBar"
{
    Properties {
	
		_Color("Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Main Texture", 2D) = "grey" {}
		_ScrollTex ("Scroll Texture", 2D) = "black" {}
		_Fill("Fill",  Range(0,1)) = 0
		[HideInInspector]_Alpha("Alpha",  Range(0,1)) = 1

	}
	SubShader{

			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			LOD 100
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Off

			Pass
			{

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

			fixed4 _Color;
		    sampler2D _MainTex;
			sampler2D _ScrollTex;
			float _Fill;
			float _Alpha;

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 texcoord : TEXCOORD0;
				float4 color    : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float4 color    : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = v.texcoord - fixed2(_Fill,0);
				o.texcoord.zw = (v.texcoord * fixed2(0.5, 1) - frac(float2(_Time.y, 0)));
				o.color = v.color;

				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord.xy);
				fixed scroll = tex2D(_ScrollTex, i.texcoord.zw).a;
				tex.rgb += scroll * _Color;
				tex.a += scroll * _Color.a * tex.a;
				tex.a *= i.color.a * _Alpha;
				
				return tex;
			}
		
      ENDCG
		}
    }
	
    Fallback "Unlit/Texture"
 }
