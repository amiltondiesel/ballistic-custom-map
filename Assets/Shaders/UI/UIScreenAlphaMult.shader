Shader "Ballistic/UI/ScreenAlphaMult" {
	Properties
		{
			[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
			[Gamma] _Exposure ("Exposure", Range(0, 20)) = 1.0
			_AlphaTex ("Alpha Texture", 2D) = "white" {}
			_Color("Tint", Color) = (1,1,1,1)
			_XScale("X Scale", Float) = 1
			_StencilComp("Stencil Comparison", Float) = 8
			_Stencil("Stencil ID", Float) = 0
			_StencilOp("Stencil Operation", Float) = 0
			_StencilWriteMask("Stencil Write Mask", Float) = 255
			_StencilReadMask("Stencil Read Mask", Float) = 255

			_ColorMask("Color Mask", Float) = 15

			[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
		}

		SubShader
		{
			Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask[_ColorMask]

		Pass
		{
			CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "UnityUI.cginc"
		#pragma shader_feature __ UNITY_UI_ALPHACLIP

		struct appdata_t
		{
			float4 vertex   : POSITION;
			float4 color    : COLOR;
			float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
		};

		struct v2f
		{
			float4 vertex   : SV_POSITION;
			fixed4 color : COLOR;
			half2 texcoord  : TEXCOORD0;
			half2 srcoord  : TEXCOORD1;
			float4 worldPosition : TEXCOORD2;
		};

		fixed4 _Color;
		half _Exposure;
		half _XScale;
		fixed4 _TextureSampleAdd;
		float4 _ClipRect;

		v2f vert(appdata_t IN)
		{
			v2f OUT;
			OUT.worldPosition = IN.vertex;
			OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

			OUT.texcoord = IN.texcoord;

			// SCREEN COORDINATES ---

			float4 scrpos = ComputeScreenPos(OUT.vertex);
			OUT.srcoord = (scrpos.xy / scrpos.w);
			OUT.srcoord.x -= 0.5;
			OUT.srcoord.x /= _XScale;
			OUT.srcoord.x += 0.5;

			// --- SCREEN COORDINATES

			#ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw - 1.0)*float2(-1,1);
			#endif

			OUT.color = IN.color * _Color;
			return OUT;
		}

		sampler2D _MainTex;
		sampler2D _AlphaTex;

		fixed4 frag(v2f IN) : SV_Target
		{
			half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
			color.rgb *= _Exposure;
			
			fixed alpha = tex2D(_AlphaTex, IN.srcoord).a;

			color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect) * alpha;

			#ifdef UNITY_UI_ALPHACLIP
				clip(color.a - 0.001);
			#endif

			return color;
		}
		ENDCG
		}
	}
}