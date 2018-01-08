Shader "Ballistic/UI/ShotgunCrosshair"
{
	Properties
	{
		_Color("Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Main Texture", 2D) = "grey" {}
		_Precision("Precision", Range(0,1)) = 1.0
		[Space(20)]_Multiply("Multiply", Float) = 1.0
		_Alpha("Alpha",  Range(0,1)) = 1
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
			float2 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};

			float _Precision;
			float _Multiply;
			float _OffsetLeft;
			float _OffsetRight;
			float _Alpha;
			fixed4 _Color;
			sampler2D _MainTex;

		v2f vert(appdata_t v)
		{
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f, o);
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.color = v.color;
			o.color.a *= _Alpha;
			o.texcoord = (v.texcoord - float2(0,_Precision)) * _Multiply;

			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = i.color * _Color;
			col.a *= tex2D(_MainTex, i.texcoord).a;

			return col;
		}
			ENDCG
		}
		}
}
