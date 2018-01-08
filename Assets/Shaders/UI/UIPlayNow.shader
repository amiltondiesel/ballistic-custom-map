Shader "Ballistic/UI/PlayNow"
{
    Properties {
	
		[PerRendererData] _MainTex ("Main Texture", 2D) = "white" {}
		_NoiseTex1 ("Noise 1", 2D) = "grey" {}
		_NoiseTex2 ("Noise 2", 2D) = "grey" {}
		_NoiseSpeed1 ("Noise Speed 1", Float) = 1.0
		_NoiseSpeed2 ("Noise Speed 2", Float) = 1.0
       
    }
    SubShader {
	
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		LOD 100
		Blend SrcAlpha One
		ZWrite Off
		
		Pass
		{
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
		    sampler2D _MainTex;
			sampler2D _NoiseTex1;
			sampler2D _NoiseTex2;
			float _NoiseSpeed1;
			float _NoiseSpeed2;
			float4 _NoiseTex1_ST;
			float4 _NoiseTex2_ST;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.texcoord1.xy = TRANSFORM_TEX(v.texcoord1,_NoiseTex1) + frac(half2(_Time.y * _NoiseSpeed1,0));
				o.texcoord1.zw = TRANSFORM_TEX(v.texcoord1,_NoiseTex2) + frac(half2(_Time.y * _NoiseSpeed2,0));
				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed alpha = tex2D(_MainTex, i.texcoord).a;
				fixed noise1 = tex2D(_NoiseTex1, i.texcoord1.xy).a;
				fixed noise2 = tex2D(_NoiseTex2, i.texcoord1.zw).a;
				fixed4 col = (noise1 + noise2) * alpha * i.color;
				
				return col;
			}
      ENDCG
		}
    }
 }
