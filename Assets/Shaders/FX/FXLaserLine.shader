// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Ballistic/FX/LaserLine"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		[Gamma] _Multiplier ("Multiplier",float) = 3.0
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Cull Off ZWrite Off
		Blend One One

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _MaskTex;
			half _Multiplier;
			float4 _MainTex_ST;
			float4 _MaskTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				
				float3 wcoord = mul(unity_ObjectToWorld, v.vertex).xyz; 
				o.texcoord1.xy = (wcoord.xz * float2(_MaskTex_ST.x,_MaskTex_ST.y) * 0.2) + frac(_Time.x * 2);
				o.texcoord1.zw = (wcoord.xz * float2(_MaskTex_ST.x,_MaskTex_ST.y) * 0.03) - frac(_Time.x);
				
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord);
				fixed4 mask1 = tex2D(_MaskTex, i.texcoord1.xy);
				fixed4 mask2 = tex2D(_MaskTex, i.texcoord1.zw);
				
				fixed4 col = tex * mask1 * mask2 * i.color * _Multiplier;

				return col;
			}
			ENDCG
		}
	}
}
