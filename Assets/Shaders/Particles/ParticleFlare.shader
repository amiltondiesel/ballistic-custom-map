Shader "Ballistic/Particles/Flare" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {

	Tags {"Queue"="Overlay" "IgnoreProjector"="True" "RenderType"="Opaque"}
	Blend SrcAlpha One
	Cull Off
	Lighting Off
	ZWrite Off
	//ZTest Always

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

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color: COLOR;
				UNITY_FOG_COORDS(3)
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX( v.texcoord, _MainTex);
				o.color = v.color;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.texcoord).a * i.color;
				col.rgb *= 2;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
		
      ENDCG
		}
}
}