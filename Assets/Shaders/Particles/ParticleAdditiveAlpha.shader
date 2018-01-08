Shader "Ballistic/Particles/AdditiveAlpha" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_Offset ("Offset", Range(0,2)) = 0
	[Gamma] _Exposure ("Exposure", Range(0, 20)) = 1.0
	_MainTex ("Particle Texture", 2D) = "white" {}
}

SubShader{

	Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		ZWrite Off
		Blend SrcAlpha One

		Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 2.0

		#include "UnityCG.cginc"

		struct appdata_t {
			float4 vertex : POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f {
			float4 vertex : SV_POSITION;
			fixed4 color : COLOR;
			half2 texcoord : TEXCOORD0;
		};

		fixed4 _TintColor;
		float _Exposure;
		sampler2D _MainTex;
		float4 _MainTex_ST;

		v2f vert(appdata_t v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
			o.color = v.color;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = _TintColor * _Exposure * i.color * tex2D(_MainTex, i.texcoord);
			col.a *= tex2D(_MainTex, i.texcoord).r * i.color.r;
			return col;
		}
			ENDCG
		}
	}

}