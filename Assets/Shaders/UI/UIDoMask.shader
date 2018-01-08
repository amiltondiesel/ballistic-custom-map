Shader "Ballistic/UI/DoMask"{

Properties {
	_Color	("Color", Color) = (0.5,0.5,0.5,0.5)
}

	Category
	{

		Tags
		{
			"Queue" = "Background"
		}

		Blend SrcAlpha OneMinusSrcAlpha

			Cull Off
			Lighting Off
			ZWrite Off


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


			sampler2D _UIGrabMask;
			fixed4 _Color;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				float2 scrPos : TEXCOORD0;
			};


			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float4 computePos = ComputeScreenPos(o.vertex);
				o.scrPos = computePos.xy / computePos.w;
				return o;
			}


			half4 frag( v2f i ) : COLOR
			{
				fixed4 col = tex2D(_UIGrabMask,i.scrPos);
				
				col.a = _Color.a;
				
				return col;
			}
		ENDCG
			}
		}
	}
	Fallback Off
}
