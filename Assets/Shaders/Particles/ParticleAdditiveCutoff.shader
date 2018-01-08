Shader "Ballistic/Particles/AdditiveCutoff" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_Multiply ("Multiply", Float) = 0
	_Subtract ("Subtract", Float) = -0.5
	_Offset("Offset", Range(0,2)) = 0
	_MainTex ("Particle Texture", 2D) = "grey" {}
	_OverTex("Overlay Texture", 2D) = "grey" {}
}

Category {
	Tags { "Queue"="Transparent1" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off
	Lighting Off
	ZWrite Off
	
	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _OverTex;
			fixed4 _TintColor;
			half _Multiply;
			half _Subtract;
			half _Exposure;
			half _Offset;
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex.z -= _Offset / o.vertex.z;
				o.color = v.color * _TintColor;

				o.texcoord = v.texcoord;

				o.texcoord1 = (v.texcoord + frac(half2(_Time.x * 1.5, 0))) * half2(6,2);
				//float4 scrpos = ComputeScreenPos(o.vertex);
				//float2 srcoord = (scrpos.xy / scrpos.w);

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = i.color;
				fixed tex1 = tex2D(_MainTex, i.texcoord).a;
				fixed tex2 = tex2D(_OverTex, i.texcoord1).a;
				col.a = saturate((tex1 * tex2 * i.color.a * _Multiply) + _Subtract);
				return col;
			}
			ENDCG 
		}
	}	
}
}
