Shader "Ballistic/UI/TextureBrightColor"
{
    Properties {
		_Color("Color", Color) = (0,0,0,0)
		_MainTex ("Main Texture", 2D) = "grey" {}
		_Brightness("Brightness", float) = 0
		_Alpha("Alpha", float) = 0
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
			float _Brightness;
			float _Alpha;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord);
				tex.rgb *= _Brightness * _Color.rgb;
				tex.a *= _Alpha * _Color.a;
				
				return tex;
			}
		
      ENDCG
		}
    }
	
    Fallback "Unlit/Texture"
 }
