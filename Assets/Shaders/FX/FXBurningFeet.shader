Shader "Ballistic/FX/BurningFeet" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	[Gamma] _Exposure ("Exposure", Range(0, 20)) = 1.0
	_MainTex ("Fire Texture", 2D) = "white" {}
	_DisTex("Distort Texture", 2D) = "white" {}
	_Fill("Fill", float) = 1.0
}

Category {
	Tags {"RenderType"="Opaque"}
	Blend SrcAlpha One
	//Cull Off
	//Lighting Off
	ZWrite Off
	
	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _DisTex;
			fixed4 _TintColor;
			half _Exposure;
			half _Offset;
			float _Fill;
			
			struct appdata_t {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				v.vertex.xyz += v.normal * (sin(_Time.y * v.color.r * 5 + v.vertex.g) + 0.5*v.color.r) * 0.07;
				o.vertex = UnityObjectToClipPos(v.vertex);

				float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));

				o.texcoord.xy = (v.texcoord - frac(float2(_Time.x,_Time.y * 0.8)));
				o.texcoord.z = saturate(dot(normalize(viewDir), v.normal)) * v.color.a;
				o.texcoord.z *= o.texcoord.z * o.texcoord.z * o.texcoord.z * o.texcoord.z * o.texcoord.z;

				o.texcoord1 = (v.texcoord * 2 - frac(float2(_Time.x,_Time.y * 0.4)));


				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 distortex = tex2D(_DisTex, i.texcoord1).rg;
				fixed4 firetex = tex2D(_MainTex, i.texcoord.xy + distortex) * _TintColor;
				fixed4 col = firetex;
				col.a *= min(i.texcoord.z *_Exposure * firetex.r,5);
				return col;
			}
			ENDCG 
		}
	}	
}
}
