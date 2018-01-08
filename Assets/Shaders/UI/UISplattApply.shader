Shader "Ballistic/UI/SplattApply"
{
    Properties {
		[HideInInspector]_MainTex ("Main Texture", 2D) = "grey" {}
		_SplattTex ("Splatter (RGB)", 2D) = "white" {}
		[HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
		[HideInInspector]_Stencil ("Stencil ID", Float) = 0
		[HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
		[HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
		[HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255
    }
	
    SubShader {
	
		Tags
	
		{ "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	
		Blend Zero OneMinusSrcColor
		Cull Off
		Lighting Off
		ZWrite Off
		
		Stencil {
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
		
		Pass
		{
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
		    sampler2D _MainTex;
			sampler2D _SplattTex;
			fixed4 _Color;
			float4 _MainTex_ST;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float4 scrPos : TEXCOORD1;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX( v.texcoord, _MainTex);
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0f;
				#else
				float scale = 1.0f;
				#endif
				o.scrPos.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
				o.scrPos.zw = o.vertex.zw;
				
				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{	
				float2 wcoord = (i.scrPos.xy/i.scrPos.w);
				
				fixed4 mask = tex2D(_MainTex, i.texcoord);
				fixed4 splat = tex2D(_SplattTex, (wcoord * fixed2(3,2)) + frac(float2(1,-0.2) * _Time.y * 0.6));
				fixed4 scroll = tex2D(_SplattTex, (wcoord * fixed2(4,2.7)) - frac(float2(1,0.2) * _Time.y * 0.3)).a;
				fixed4 res = min(pow((splat * scroll * i.color * mask) * 4, 5),1) * i.color.a;
				
				return res;
			}
		
      ENDCG
		}
    }
	
    Fallback "Unlit/Texture"
 }
