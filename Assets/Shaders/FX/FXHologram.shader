Shader "Ballistic/FX/Hologram" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	[Gamma] _Exposure ("Exposure", Range(0, 20)) = 1.0
	_MainTex ("Fade Texture", 2D) = "white" {}
	_PatternTex("Pattern Texture", 2D) = "white" {}
}

Category {
	Tags { "Queue"="Transparent1" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha One
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
			sampler2D _PatternTex;
			fixed4 _TintColor;
			half _Exposure;
			half _Offset;
			
			struct appdata_t {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
				half rim = saturate(dot(normalize(viewDir), v.normal));
				o.color = v.color * _TintColor * _Exposure * rim * rim;

				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);

				float4 scrpos = ComputeScreenPos(o.vertex);
				float2 srcoord = (scrpos.xy / scrpos.w) * 2;

				half time = _Time.y * 0.2;

				o.texcoord1.xy = (srcoord * half2(9,4.5)) - frac(half2(time, time));
				o.texcoord1.zw = (srcoord * half2(20, 10)) + frac(half2(time, time));

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed fade = tex2D(_MainTex, i.texcoord).a;
				fixed4 pattern1 = tex2D(_PatternTex, i.texcoord1.xy);
				fixed4 pattern2 = tex2D(_PatternTex, i.texcoord1.zw);
				fixed4 col = i.color * fade * pattern1 * pattern2;
				return col;
			}
			ENDCG 
		}
	}	
}
}
