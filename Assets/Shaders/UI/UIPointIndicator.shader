Shader "Ballistic/UI/PointIndicator"
{
	Properties
	{
		[HideInInspector]_MainTex("Main Texture", 2D) = "grey" {}
		_AlphaTex("Alpha Texture", 2D) = "grey" {}
		_Fill("Fill", Range(0,1)) = 1.0
		[Space(20)]_Multiply("Multiply", Float) = 1.0
		_OffsetDown("Offset Left", Range(0,0.1)) = 0.0
		_OffsetTop("Offset Right", Range(1,1.2)) = 1.0
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
		};

			float _Fill;
			float _Multiply;
			float _OffsetDown;
			float _OffsetTop;
			float _Alpha;
			sampler2D _MainTex;
			sampler2D _AlphaTex;

		v2f vert(appdata_t v)
		{
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f, o);
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.color = v.color;
			o.texcoord.xy = (v.texcoord - float2(0,(_Fill * _OffsetTop) - _OffsetDown)) * float2(1, _Multiply);
			o.texcoord.zw = v.texcoord;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed alpha = tex2D(_AlphaTex, i.texcoord.zw).a;
			fixed4 color = tex2D(_MainTex, i.texcoord.xy) * i.color;
			color.a *= alpha;

			return color;
		}
			ENDCG
		}
		}
}
