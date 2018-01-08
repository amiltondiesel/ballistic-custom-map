Shader "Ballistic/FX/SmokeTrail"
{
    Properties {
	_Color ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
    _MainTex ("Texture", 2D) = "white" {}
    _Overlay1 ("Overlay1", 2D) = "gray" {}
	_Overlay2 ("Overlay2", 2D) = "gray" {}
    }
	
    SubShader {
	
		Tags 
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
			
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off

			Blend SrcAlpha OneMinusSrcAlpha
	  
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
			fixed4 _Color;
			sampler2D _MainTex;
			sampler2D _Overlay1;
			sampler2D _Overlay2;
			float _Speed;
			
			struct appdata_t
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct v2f
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = _Color;
				o.color.a = v.color.a * clamp(v.texcoord.y * (v.texcoord.x - _Time.y), 0, 1);
				o.texcoord.x = v.color.r;
				o.texcoord.y = v.color.g;
				o.texcoord1 = v.texcoord1;
				
				return o;
			}
		  
		  
		  half4 frag (v2f IN) : COLOR
			{
				fixed4 col = tex2D (_Overlay1, IN.texcoord1*0.1 - fixed2(_Time.x * 0.4,_Time.x * 0.6)) * IN.color;
				col.a *= tex2D(_MainTex, IN.texcoord).a * 2;
				col.a *= tex2D (_Overlay2, (IN.texcoord1 * fixed2(0.5,1)) + fixed2(_Time.x * 10,0)).a;
				col.a *= tex2D (_Overlay2, (IN.texcoord1 * fixed2(0.2,1)) - fixed2(_Time.x * 5 ,0)).a;

				
				return col;
			}
		
      ENDCG
		}
    }
	
    Fallback "Diffuse"
 }
