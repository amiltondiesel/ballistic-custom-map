Shader "Ballistic/UI/BloodSplatter" 
{
    Properties 
	{
        _MainTex ("Base (RGB)", 2D) = "white" {}        
		//_Multiplier ("Multiplier", float) = 0.5
		//_Pow ("Pow", float) = 1
    }
	
	
    SubShader 
	{
	
		Tags { "RenderType"="Opaque" }
		Blend DstColor SrcColor
		Cull Off 
		Lighting Off 
		ZWrite Off
		ZTest Always
	
		Pass
		{
			CGPROGRAM 

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Multiplier;
			float _Pow;
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			struct v2f 
			{ 
				float4 pos : SV_POSITION; 
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;               
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}

			float4 frag (v2f i) : COLOR
			{
				float4 c = tex2D(_MainTex, i.texcoord);
				float4 gray = float4(0.5,0.5,0.5,1);
				c.a = pow(c.a + i.color.r,6) - 1;
				c.a = clamp(c.a,0,i.color.a);
				c.rgb = gray + (c.rgb - gray) * c.a;
				return c;
			}
			
			ENDCG
		}

    }
} 