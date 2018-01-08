Shader "Ballistic/UI/GrabMaskApply"{

Properties {
	[HideInInspector] _MainTex ("Mask (A)", 2D) = "white" {}
}

		Category
		{

		Tags
		
		{ "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		Lighting Off
		ZWrite Off
		

		SubShader
		{
			GrabPass {"_GrabPassUI"}
			
			Pass
			{
	
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _GrabPassUI;
			fixed4 _Color;

			
			struct v2f {
				float4 vertex : POSITION;
				float4 scrPos : TEXCOORD0;
				float4 texcoord : TEXCOORD1;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = v.texcoord;

				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0f;
				#else
				float scale = 1.0f;
				#endif
				o.scrPos.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.scrPos.zw = o.vertex.zw;
				
				o.color = v.color;
				return o;
			}


			half4 frag( v2f i ) : COLOR
			{	
				fixed4 tex = tex2D(_MainTex, i.texcoord.xy).a;
				float2 wcoord = (i.scrPos.xy/i.scrPos.w);
				
				half4 col = tex2D(_GrabPassUI,wcoord);
				col.a *= tex.a * i.color.a;
				col.a = saturate(col.a + i.color.r);
				
				return col;
			}
		ENDCG
			}
		}
	}
	Fallback Off
}
