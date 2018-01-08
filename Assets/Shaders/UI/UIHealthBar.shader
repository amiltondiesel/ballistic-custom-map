Shader "Ballistic/UI/HealthBar"
{
	Properties
	{
		_Fill("Fill", Range(0,1)) = 1.0
		[Space(20)]_Multiply("Multiply", Float) = 1.0
		_OffsetLeft("Offset Left", Range(0,0.1)) = 0.0
		_OffsetRight("Offset Right", Range(1,1.2)) = 1.0
		_BaseTex("Base Texture", 2D) = "white" {}
		_ColorTex("Color Texture", 2D) = "white" {}
		_ScrollColor("Scroll Color", Color) = (0.5,0.5,0.5,0.5)
		_ScrollTex("Scroll Texture", 2D) = "black" {}
	}

		SubShader
	{
		Tags
	{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
	}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		struct appdata_t {
			float4 vertex : POSITION;
			half4 color : COLOR;
			float4 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			fixed4 color : COLOR;
			float4 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
		};

			float _Fill;
			float _Multiply;
			float _OffsetLeft;
			float _OffsetRight;
			float _Alpha;
			fixed4 _ScrollColor;
			sampler2D _BaseTex;
			sampler2D _ColorTex;
			sampler2D _ScrollTex;

		v2f vert(appdata_t v)
		{
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f, o);
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.color = v.color;
			o.texcoord.xy = v.texcoord;
			o.texcoord.zw = (v.texcoord - float2(((1 - _Fill) * _OffsetRight) - _OffsetLeft, 0)) * float2(_Multiply, 1);
			o.texcoord1 = (v.texcoord * fixed2(0.5, 1) - frac(float2(_Time.y * 0.6, 0)));
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed alpha = tex2D(_BaseTex, i.texcoord.xy).a * i.color.a;
			fixed4 color = tex2D(_ColorTex, i.texcoord.zw);

			fixed3 scroll = tex2D(_ScrollTex, i.texcoord1).a * _ScrollColor.rgb;

			fixed4 res = fixed4(color.rgb + scroll,alpha + color.a);

			return res;
		}
			ENDCG
		}
		}
}
