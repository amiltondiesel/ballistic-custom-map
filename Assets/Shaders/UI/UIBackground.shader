Shader "Ballistic/UI/Background"
{
    Properties {
	
		[HideInInspector]_MainTex ("Main Texture", 2D) = "grey" {}
		_NoiseTex ("Noise", 2D) = "grey" {}
		_MaskTex ("Mask", 2D) = "white" {}
		//_VignetteTex ("Vignette", 2D) = "grey" {}
        _NoiseScale ("Noise Scale", Float) = 10.0
		_NoiseSpeed ("Noise Speed", Float) = 10.0
		_MaskScale ("Mask Scale", Float) = 10.0
       
    }
    SubShader {
	
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
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
			sampler2D _MaskTex;
			//sampler2D _VignetteTex;
			float _NoiseScale;
			float _NoiseSpeed;
			half _MaskScale;
			fixed4 _Color;

			struct v2f
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				//float4 scrcoord : TEXCOORD1;
				float2 maskcoord : TEXCOORD2;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = v.texcoord;
				o.maskcoord = v.texcoord * half2(_MaskScale,1) + half2(v.color.a * (1 - _MaskScale),0);
				o.texcoord.zw = (v.texcoord * _NoiseScale) + (frac(float2(0.85,0.9) * _Time.y * _NoiseSpeed));
				//o.scrcoord.xy = (float2(o.vertex.x, o.vertex.y) + o.vertex.w) * 0.5;
				//o.scrcoord.zw = o.vertex.zw;
				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				//float2 screenuv = i.scrcoord.xy / i.scrcoord.w;
			
				fixed4 col = tex2D(_MainTex, i.texcoord.xy);
				fixed4 noi = tex2D(_NoiseTex, i.texcoord.zw).a;
				fixed4 msk = tex2D(_MaskTex, i.maskcoord);
				//fixed4 vig = tex2D(_VignetteTex, screenuv).a;
				fixed4 res = (col * noi * 2 * i.color);// * lerp(vig,fixed4(1,1,0.97,1),sin(_Time.y));
				res.a = msk.a;
				
				return res;
			}
		
      ENDCG
		}
    }
	
    Fallback "Unlit/Texture"
 }
