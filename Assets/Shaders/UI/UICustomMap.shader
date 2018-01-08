Shader "Ballistic/UI/CustomMap"
{
    Properties {
		[Gamma] _Exposure ("Exposure", Range(0, 20)) = 1.0
		[PerRendererData] _MainTex ("Main Texture", 2D) = "grey" {}
		_AlphaTex ("Alpha Texture", 2D) = "grey" {}
		_AlphaTex2 ("Alpha Texture", 2D) = "grey" {}
		_ScaleX ("Scale X", float) = 1
		_ScaleY ("Scale Y", float) = 1
		_OffsetX ("Scale X", float) = 0
		_OffsetY ("Scale Y", float) = 0
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
			sampler2D _AlphaTex;
			sampler2D _AlphaTex2;
			half _Exposure;
			half _ScaleX;
			half _ScaleY;
			half _OffsetX;
			half _OffsetY;

			struct v2f
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord.xy = v.texcoord;
				o.texcoord.zw = v.texcoord - half2(1,0) + half2(v.color.a * 2,0);
				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 tex = tex2D(_MainTex, i.texcoord.xy * fixed2(_ScaleX,_ScaleY) - fixed2(_OffsetX,_OffsetY));
				tex.rgb *= i.color * _Exposure;
				fixed alpha = tex2D(_AlphaTex, i.texcoord.xy).a;
				fixed alpha2 = tex2D(_AlphaTex2, i.texcoord.zw).a;
				tex.a *= alpha * alpha2;
				
				return tex;
			}
		
      ENDCG
		}
    }
 }
