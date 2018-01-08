Shader "Ballistic/UI/SquareMask"
{
    Properties {
		_Color ("Tint Color", Color) = (1,1,1,1)
		_TexLerp ("Texture Lerp", Range(0, 1)) = 0.0
		_MainTex ("Main Texture", 2D) = "grey" {}
		_MainTex2 ("Main Texture2", 2D) = "grey" {}
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
		  
		    sampler2D _MainTex;
			sampler2D _MainTex2;
			fixed4 _Color;
			float _TexLerp;
			float4 _MainTex_ST;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord =  TRANSFORM_TEX( v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 col = _Color * 2;
				fixed alpha1 = tex2D(_MainTex, i.texcoord).a;
				fixed alpha2 = tex2D(_MainTex2, i.texcoord).a;
				col.a = lerp(alpha1,alpha2,_TexLerp) * _Color.a * i.color.a;
				
				return col;
			}
		
      ENDCG
		}
    }
 }
