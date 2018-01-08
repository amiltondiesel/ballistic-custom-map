Shader "Ballistic/Environment/Atmosphere" 
{
	Properties 
	{
		_FalloffColor ("Falloff Color", Color) = (0,0,0,0)
		_BRDFTex ("NdotL NdotH (RGBA)", 2D) = "white" {}
	}
    SubShader {
	
	Tags
	
		{ "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	
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
		  
			fixed4 _FalloffColor;
			sampler2D _BRDFTex;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float3 viewDir = normalize(ObjSpaceViewDir (v.vertex));
				fixed NdotL = dot (v.normal, viewDir);
				
				o.texcoord = fixed2(NdotL, NdotL);
				
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_BRDFTex, i.texcoord) * _FalloffColor;
				return col;
			}
		
      ENDCG
		}
    }
	
    Fallback "Unlit/Texture"
 }
