Shader "Ballistic/UI/UV1GenericBar"
{
	Properties
	{
		[HideInInspector]_MainTex("Main Texture", 2D) = "grey" {}
		_AlphaTex("Alpha Texture", 2D) = "white" {}
		_Fill("Fill", Range(0,1)) = 1.0
		[Space(20)]_Multiply("Multiply", Float) = 1.0
		_OffsetLeft("Offset Left", Range(0,0.1)) = 0.0
		_OffsetRight("Offset Right", Range(1,1.2)) = 1.0
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
		#include "UnityUI.cginc"

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
			float4 worldPosition : TEXCOORD1;
		};

			float _Fill;
			float _Multiply;
			float _OffsetLeft;
			float _OffsetRight;
			sampler2D _MainTex;
			sampler2D _AlphaTex;
			bool _UseClipRect;
			float4 _ClipRect;

		v2f vert(appdata_t v)
		{
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f, o);
			o.worldPosition = v.vertex;
			o.vertex = UnityObjectToClipPos(o.worldPosition);
			o.color = v.color;
			o.texcoord.xy = v.texcoord;
			o.texcoord.zw = (v.texcoord1 - float2((_Fill * _OffsetRight) - _OffsetLeft, 0)) * float2(_Multiply, 1);
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 tex = i.color;
			tex.a *= tex2D(_MainTex, i.texcoord.xy).a * tex2D(_AlphaTex, i.texcoord.zw).a;

			if (_UseClipRect)
			tex.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);

			return tex;
		}
			ENDCG
		}
		}
}
