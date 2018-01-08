Shader "Hidden/BlitAlphaDiscart"
{
	Properties
	{
		_MainTex ("Main", 2D) = "black" {}
		_StageRT ("Stage", 2D) = "black" {}
		_AlphaRT ("Alpha", 2D) = "black" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed absolute(fixed4 c)
			{
				if(c.r + c.g + c.b > 0)
				{
					return 1;
				}
				else
				{
					return c.r + c.g + c.b;
				}
			}

			sampler2D _MainTex;
			sampler2D _StageRT;
			sampler2D _AlphaRT;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 stg = tex2D(_StageRT, i.uv);
				fixed4 alp = tex2D(_AlphaRT, i.uv);
				fixed4 main = tex2D(_MainTex, i.uv);
				return lerp(stg,alp,1-step(alp,0)) + main;
			}
			ENDCG
		}
	}
}
