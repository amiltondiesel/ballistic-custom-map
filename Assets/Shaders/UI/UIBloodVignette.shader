Shader "Ballistic/UI/BloodVignette" 
{
    Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex("Noise (RGB)", 2D) = "white" {}
		_Multiplier ("Multiplier", float) = 0.5
		_Cutoff ("Cutoff", float) = 1
		_Alpha("Alpha",  Range(0,1)) = 1
    }
	
	
    SubShader 
	{
		Tags
		{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		Lighting Off
		ZWrite Off
	
		Pass
		{
			CGPROGRAM 

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			float4 _MainTex_ST;
			float _Multiplier;
			float _Cutoff;
			float _Alpha;
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			
			struct v2f 
			{ 
				float4 pos : SV_POSITION; 
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;               
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoord1 = (v.texcoord1 - frac(float2(_Time.y * 0.3,_Time.y * 0.6)));
				o.color = v.color;
				o.color.a *= _Alpha;
				return o;
			}

			float4 frag (v2f i) : COLOR
			{
				float4 col = tex2D(_MainTex, i.texcoord);
				float4 noise = tex2D(_NoiseTex, i.texcoord1);
				col *= noise * 2;
				col.a *= i.color.a * _Multiplier;
				col.a += _Cutoff;
				col.a = saturate(col.a);
				return col;
			}
			
			ENDCG
		}

    }
} 