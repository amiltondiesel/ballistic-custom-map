Shader "Ballistic/FX/GlowingEyes" {
Properties {
	_Color ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	[Gamma] _Exposure("Exposure", Range(0, 20)) = 1.0
	_MainTex ("Particle Texture", 2D) = "white" {}
	_WindShakeVelocity("Shake Velocity", float) = 6
	_WindShakeForce("Shake Force", float) = 0.18
	_WindDirection("Wind Direction", Vector) = (0,1,1,0)
}

SubShader{

	Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "DisableBatching" = "True"}

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off

		Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 2.0

		#include "UnityCG.cginc"

		struct appdata_t {
			float4 vertex : POSITION;
			fixed4 color : COLOR;
			fixed3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f {
			float4 vertex : SV_POSITION;
			fixed4 color : COLOR;
			half2 texcoord : TEXCOORD0;
		};

		fixed4 _Color;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		float _WindShakeVelocity;
		float _WindShakeForce;
		float4 _WindDirection;
		float _Exposure;

		v2f vert(appdata_t v)
		{
			v2f o;

			half3 dir = normalize(_WindDirection);

			half atten = v.color.r;

			half sin0 = sin((_Time.x - v.color.r*0.08) * _WindShakeVelocity * 5)  * v.color.r;
			half sin1 = sin((_Time.x - v.color.g*0.09) * _WindShakeVelocity * 2)  * v.color.g;

			v.vertex.xyz += (sin0 * dir * _WindShakeForce) + (sin1 * abs(v.normal) * _WindShakeForce);

			o.vertex = UnityObjectToClipPos(v.vertex);
			o.texcoord = v.texcoord - frac(float2(_Time.y,0));
			o.color = v.color;

			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = _Color;
			col.a *= tex2D(_MainTex, i.texcoord).r * i.color.a;
			return col * _Exposure;
		}
			ENDCG
		}
	}

}