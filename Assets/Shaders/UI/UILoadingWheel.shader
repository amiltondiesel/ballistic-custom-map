Shader "Ballistic/UI/LoadingWheel"
{
    Properties {
	
		[PerRendererData][HideInInspector]_MainTex ("Main Texture", 2D) = "grey" {}
		_MaskTex ("Mask", 2D) = "grey" {}
		_RotationSpeed ("Rotation Speed", Float) = 0.0
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15
       
    }
    SubShader {
	
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
		
		Lighting Off
		ZWrite Off
		Cull Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityUI.cginc"
		  
		    sampler2D _MainTex;
			sampler2D _MaskTex;
			fixed4 _TextureSampleAdd;
			half _RotationSpeed;
			fixed4 _Color;
			bool _UseClipRect;
			bool _UseAlphaClip;
			float4 _ClipRect;

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
				float4 worldPosition : TEXCOORD1;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.worldPosition = v.vertex;
				o.vertex = UnityObjectToClipPos(o.worldPosition);
		
				#ifdef UNITY_HALF_TEXEL_OFFSET
				o.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
				#endif
				
				o.texcoord.xy = v.texcoord;
				o.texcoord.zw = v.texcoord.xy - 0.5;
				float s = sin (_Time.x * _RotationSpeed);
				float c = cos (_Time.x * _RotationSpeed);
				float2x2 rotationMatrix = float2x2( c, -s, s, c);
				rotationMatrix *=0.5;
				rotationMatrix +=0.5;
				rotationMatrix = rotationMatrix * 2-1;
				o.texcoord.zw = mul ( o.texcoord.zw, rotationMatrix );
				o.texcoord.zw += 0.5;

				o.color = v.color;
				return o;
			}
		  
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 col = i.color;
				col.a *= tex2D(_MaskTex, i.texcoord.zw).a * tex2D(_MainTex, i.texcoord.xy).a;
				
				if (_UseClipRect)
					col *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
				
				if (_UseAlphaClip)
					clip (col.a - 0.001);

				return col;
			}
		
      ENDCG
		}
    }
 }
