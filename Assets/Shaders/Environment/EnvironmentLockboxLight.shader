Shader "Ballistic/Environment/LockboxLight" 
{
	Properties 
	{
		_LightColor ("Light Color", Color) = (0,0,0,0)
		[Gamma] _Exposure("Exposure", Range(0, 20)) = 1.0
		[Gamma] _FlatLight("Flat Light", Range(0, 20)) = 1.0
		_MainTex("Main Texture", 2D) = "white" {}
		_BRDFTex ("NdotL NdotH (RGBA)", 2D) = "white" {}
	}
    SubShader {
	
	Tags
	
		{ "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

		Lighting Off
		
		Pass
		{
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
			fixed4 _LightColor;
			sampler2D _MainTex;
			sampler2D _BRDFTex;
			float4 _MainTex_ST;
			float _Exposure;
			float _FlatLight;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float3 viewDir = normalize(ObjSpaceViewDir (v.vertex));
				fixed NdotL = dot (v.normal, viewDir);
				
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

				o.texcoord1 = fixed2(NdotL, NdotL);

				o.color = v.color;
				
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord) * _LightColor * _Exposure;
				fixed4 fresnel = tex2D(_BRDFTex, i.texcoord1);

				fixed4 col = (tex + (_LightColor * _FlatLight) * i.color) + fresnel;
				return col;
			}
		
      ENDCG
		}
    }
	
    Fallback "Unlit/Texture"
 }
