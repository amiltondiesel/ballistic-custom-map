Shader "Ballistic/FX/FPSdoMask"{

Properties {
	_Color	("Color", Color) = (0.5,0.5,0.5,0.5)
}

	Category
	{

		Tags
		{
			"Queue" = "Overlay"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		
		}

			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			ZTest Always
			Blend SrcAlpha OneMinusSrcAlpha


		SubShader
		{

			Pass
			{
				Name "BASE"
				Tags { 
						"LightMode" = "Always"
					}
				
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"


			sampler2D _GrabMask;
			fixed4 _Color;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				float4 scrPos : TEXCOORD0;
			};


			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0f;
				#else
				float scale = 1.0f;
				#endif
				o.scrPos.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.scrPos.zw = o.vertex.zw;
				return o;
			}


			half4 frag( v2f i ) : COLOR
			{
				float2 screenUV = i.scrPos.xy / i.scrPos.w;
				
				fixed4 col = tex2D(_GrabMask,screenUV);
				
				col.a = _Color.a;
				
				return col;
			}
		ENDCG
			}
		}
	}
	Fallback Off
}
