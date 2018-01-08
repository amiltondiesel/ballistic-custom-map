Shader "Ballistic/Environment/GlassShatteredBroken" {
Properties {
	_BumpAmt  ("Distortion", range (0,64)) = 10
	_ZDepth ("Distortion Depth", float) = 0.8
	_TintAmt ("Tint Amount", Range(0,1)) = 0.1
	_MainTex ("Tint Color (RGB)", 2D) = "white" {}
	_AlphaTex ("Alpha Texture (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
}
Category {
	
	Tags {
			"Queue"="Transparent"
			"RenderType"="Opaque"
		}
	Blend SrcAlpha OneMinusSrcAlpha
	ZWrite Off
	
	SubShader {

		GrabPass {"_LevelGrab"}
	
		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			float _BumpAmt;
			half _TintAmt;
			float4 _BumpMap_ST;
			float4 _MainTex_ST;
			float _ZDepth;
			
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord: TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				float4 uvgrab : TEXCOORD0;
				float2 uvbump : TEXCOORD1;
				float2 uvmain : TEXCOORD2;
				UNITY_FOG_COORDS(3)
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvbump = TRANSFORM_TEX( v.texcoord, _BumpMap );
				o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
				
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				
				float depth;
				COMPUTE_EYEDEPTH(depth);
					
				o.uvgrab.z = (depth + 0.2f) * _ZDepth;
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			sampler2D _LevelGrab;
			float4 _LevelGrab_TexelSize;
			sampler2D _BumpMap;
			sampler2D _MainTex;
			sampler2D _AlphaTex;

			half4 frag (v2f i) : SV_Target
			{
				half2 bump = UnpackNormal(tex2D( _BumpMap, i.uvbump)).rg;
				
				i.uvgrab.xy += bump * _BumpAmt * 0.01 * i.uvgrab.z;
				
				half4 col = tex2Dproj (_LevelGrab, UNITY_PROJ_COORD(i.uvgrab));
				half4 tint = tex2D(_MainTex, i.uvmain);
				fixed alpha = tex2D(_AlphaTex, i.uvmain).a;
				col *= tint * 2;
				col.a = alpha;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}

}

}
