Shader "Ballistic/FX/CamouflageScope" {

Properties {
	_BaseColor	("Base Color", Color) = (0.5,0.5,0.5,0.5)
	_FxColor	("FX Color", Color) = (0.5,0.5,0.5,0.5)
	_FxAmount ("FX Amount", float) = 1
	_RimAmount ("Rim Amount", float) = 1
	_Distortion ("Distortion", float) = 1
	_ScrSpeed ("Scroll Speed", float) = 15
	_Alpha ("Alpha", range(0,1)) = 1
	_FxTex 		("Fx Texture", 2D) = "black" {}
	_BumpMap 	("Normalmap", 2D) = "bump" {}
}

		SubShader
		{
			Tags {
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
			}
			
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest Always
			
			GrabPass {
				"_GrabWraith"
			}
			
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

				float _Distortion;
				float _FxAmount;
				float _RimAmount;
				float _ScrSpeed;
				float _Alpha;
				float4 _BumpMap_ST;
				float4 _FxTex_ST;
				sampler2D _GrabWraith;
				float4 _GrabWraith_TexelSize;
				sampler2D _BumpMap;
				sampler2D _FxTex;
				fixed4 _BaseColor;
				fixed4 _FxColor;

				struct appdata_t
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					fixed4 color : COLOR;
					float2 texcoord: TEXCOORD0;
				};

				struct v2f {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					float4 uvgrab : TEXCOORD1;
				};

				v2f vert (appdata_t v)
				{
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f, o);
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord,_BumpMap);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord,_FxTex);
					o.uvgrab = ComputeGrabScreenPos(o.vertex);

					o.color = v.color;
					
					return o;
				}


				half4 frag( v2f i ) : COLOR
				{
					half2 bump = UnpackNormal(tex2D( _BumpMap, i.texcoord.xy)).rg;
					float2 offset = (bump  * _Distortion * 0.2);
					
					i.uvgrab.xy += offset * 0.2;
					
					fixed4 grab = saturate(tex2Dproj(_GrabWraith, UNITY_PROJ_COORD(i.uvgrab)));
					fixed4 fxtex = tex2D(_FxTex,i.texcoord.zw + (offset * 0.5) + frac(_Time.x * _ScrSpeed));
					
					fixed4 albedo = lerp(grab,_BaseColor,_BaseColor.a);
					
					fixed4 albedomix = albedo + (fxtex * _FxColor * _FxAmount);
					fixed4 effects = lerp(albedomix,albedomix * i.color,saturate(_RimAmount * 2));
					effects.a = _Alpha * i.color.a;
					
					return effects;
				}
		ENDCG
		}
	}
}