Shader "Ballistic/FX/DecalMultiply"{
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {

	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque"}
	Blend DstColor SrcColor
	Cull Off
	Lighting Off
	ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
		  
		    sampler2D _MainTex;
			fixed4 _Color;
			float4 _MainTex_ST;

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord: TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(3)
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX( v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.texcoord) * 2.3;
				UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(0.5,0.5,0.5,0.5));
				return col;
			}
		
      ENDCG
		}
}
}