Shader "Ballistic/UI/ColorShine"
{
    Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,0.5)
		_Brightness("Brightness", float) = 0
		_Alpha("Alpha", Range(0.0, 1.0)) = 1.0
		_ShineColor ("Shine Color", Color) = (0.5,0.5,0.5,0.5)
		_ShineSpeed("Shine Speed", float) = 1
		_ShineAlpha("Shine Alpha", Range(0.0, 1.0)) = 1.0
		_MainTex ("Main Texture", 2D) = "grey" {}
    }
    SubShader {
	
	Tags
	
		{ "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	
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
		  
		    sampler2D _MainTex;
			fixed4 _Color;
			fixed _Alpha;
			fixed _Brightness;
			fixed4 _ShineColor;
			float  _ShineSpeed;
			fixed _ShineAlpha;
			float4 _MainTex_ST;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord + frac(float2(0,1) * _Time.y * _ShineSpeed);
				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord).a;
				fixed4 col = (_Color + fixed4(_Brightness,_Brightness,_Brightness,0)) * fixed4(1,1,1,_Alpha);
				
				fixed4 res = col + (tex * _ShineColor * _ShineAlpha);
				res.a *= i.color.a;
				
				return res;
			}
		
      ENDCG
		}
    }
 }
