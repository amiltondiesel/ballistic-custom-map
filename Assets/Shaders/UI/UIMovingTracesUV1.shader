Shader "Ballistic/UI/MovingTracesUV1"
{
    Properties {
		[HideInInspector]_MainTex ("Main Texture", 2D) = "grey" {}
		_MaskTex1 ("Mask Texture 1", 2D) = "grey" {}
		_MaskTex2 ("Mask Texture 2", 2D) = "grey" {}
		[HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
		[HideInInspector]_Stencil ("Stencil ID", Float) = 0
		[HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
		[HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
		[HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255
    }
	
    SubShader {
	
		Tags
	
		{ "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	
		Blend SrcAlpha OneMinusSrcAlpha
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
			sampler2D _MaskTex1;
			sampler2D _MaskTex2;
			fixed4 _Color; 
			float4 _MainTex_ST;

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
				o.texcoord = TRANSFORM_TEX( v.texcoord, _MainTex);
				o.texcoord1.xy = v.texcoord1 + frac(float2(1,0) * _Time.x * 10);
				o.texcoord1.zw = (v.texcoord1 * fixed2(0.6,1)) - frac(float2(1,0) * _Time.x * 7);
				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 col = i.color;
				fixed4 msk1 = tex2D(_MaskTex1, i.texcoord1.xy).a;
				fixed4 msk2 = tex2D(_MaskTex2, i.texcoord1.zw).a; 
				col.a = tex2D(_MainTex, i.texcoord).a * msk1 * msk2 * i.color.a;
				
				return col;
			}
		
      ENDCG
		}
    }
	
    Fallback "Unlit/Texture"
 }
