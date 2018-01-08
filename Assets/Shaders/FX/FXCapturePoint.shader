Shader "Ballistic/FX/CapturePoint"{
Properties {
	_MainTex ("Base (RGB)", 2D) = "grey" {}
	_BlueTex("Blue (RGB)", 2D) = "grey" {}
	_RedTex("Red (RGB)", 2D) = "grey" {}
	_Blue("Blue", Range(0.0, 1.0)) = 0.0
	_Red("Red", Range(0.0, 1.0)) = 0.0
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
			sampler2D _BlueTex;
			sampler2D _RedTex;
			float _Blue;
			float _Red;
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
				o.texcoord = v.texcoord -frac(float2(_Time.y, 0));
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord);
				fixed4 blue = tex2D(_BlueTex, i.texcoord);
				fixed4 red = tex2D(_RedTex, i.texcoord);

				fixed4 bluemix = lerp(tex, blue, _Blue);
				fixed4 redmix = lerp(bluemix, red, _Red) * 2.3;

				UNITY_APPLY_FOG_COLOR(i.fogCoord, redmix, fixed4(0.5,0.5,0.5,0.5));
				return redmix;
			}
		
      ENDCG
		}
}
}