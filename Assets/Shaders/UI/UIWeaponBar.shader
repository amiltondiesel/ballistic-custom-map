Shader "Ballistic/UI/WeaponBar"
{
	Properties
	{
		[HideInInspector]_MainTex("Main Texture", 2D) = "grey" {}
		_Fill("Fill", Range(0,1)) = 1.0
		[Space(20)]_Multiply("Multiply", Float) = 1.0
		_OffsetLeft("Offset Left", Range(0,0.1)) = 0.0
		_OffsetRight("Offset Right", Range(1,1.2)) = 1.0
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
			float2 texcoord1 : TEXCOORD1;
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
			sampler2D _MainTex;
			sampler2D _ColorTex;
			sampler2D _ScrollTex;

		v2f vert(appdata_t v)
		{
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f, o);
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.color = v.color;
			o.texcoord.xy = v.texcoord;
			o.texcoord1 = (v.texcoord1 - float2((_Fill * _OffsetRight) - _OffsetLeft, 0)) * float2(_Multiply, 1);
			v.texcoord *= -1;
			o.texcoord.zw = (v.texcoord * fixed2(0.5, 1) - frac(float2(_Time.y * 0.6, 0)));
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed alpha = tex2D(_MainTex, i.texcoord.xy).a;
			fixed4 color = tex2D(_ColorTex, i.texcoord1);

			fixed3 scroll = tex2D(_ScrollTex, i.texcoord.zw).a * _ScrollColor.rgb;

			fixed4 res = fixed4(color.rgb + scroll,alpha + color.a) * i.color;

			return res;
		}
			ENDCG
		}
		}
}
