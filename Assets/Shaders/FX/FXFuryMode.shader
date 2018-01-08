Shader "Ballistic/FX/FuryMode" {
    Properties {
	_RimTex ("Rim Texture", 2D) = "black" {}
	_PatternTex ("Pattern Texture", 2D) = "black" {}
    _BumpMap ("Bumpmap", 2D) = "bump" {}
    _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
    _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader {
	
      Tags { "RenderType" = "Transparent" }
	  Blend One One
	  ZWrite Off
	  
	Pass
	{
      	CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"
		
		sampler2D _RimTex;
		sampler2D _PatternTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;
		
		struct appdata_t {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};
	 
		struct v2f
		{
			float4 vertex : SV_POSITION;
			float2 texcoord : TEXCOORD0;
			float2 rim : TEXCOORD1;
			float2 patterncoord : TEXCOORD2;
		};
	  
		v2f vert (appdata_t v)
		{
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f,o);
			o.vertex = UnityObjectToClipPos(v.vertex);
							
			float3 viewDir = normalize(ObjSpaceViewDir (v.vertex));
			fixed NdotL = dot (v.normal, viewDir);
			o.rim = fixed2(NdotL, NdotL);
			
			float4 scrpos = ComputeScreenPos(o.vertex);
			float2 srcoord = (scrpos.xy / scrpos.w) * 2;

			half time = _Time.y * 0.2;

			o.patterncoord = (srcoord * half2(2,1.05)) - frac(half2(0, time));
			
			o.texcoord = v.texcoord;
					
			return o;
		}
	  
		half4 frag (v2f i) : COLOR
		{
			fixed2 bump = UnpackNormal(tex2D (_BumpMap, i.texcoord)).rg;
			fixed4 pattern = tex2D(_PatternTex, i.patterncoord).a;
			fixed4 col = (tex2D(_RimTex, (i.rim + bump) + frac(float2(_Time.y * 1.5,0))) * _RimColor * pattern * 2) - 0.01;
		  
			return col;
		}
		
		ENDCG
		
	}
    }
    Fallback "Diffuse"
  }
