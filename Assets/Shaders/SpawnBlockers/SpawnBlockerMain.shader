// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Ballistic/SpawnBlockers/SpawnBlockerMain"
{
    Properties {
		_MainTex ("Main Texture", 2D) = "grey" {}
		_MainTex2 ("Main Texture", 2D) = "grey" {}
		_Gradient ("Gradient", 2D) = "grey" {}
		_Tile ("Tile", 2D) = "grey" {}
		_Fade ("Fade", 2D) = "grey" {}
		_Scroll ("Scroll", 2D) = "grey" {}
		_Mask ("Mask", 2D) = "gray" {}
		_ScanColor ("Scan Color", Color) = (1,1,1,1)
		_ScanMask ("Scan Mask", 2D) = "black" {}
		_Scanlines ("Scanlines", 2D) = "black" {}
		_ScanTile ("ScanTile", float) = 10
    }
	
    SubShader {
		
				Tags 
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
		}
		
		Pass
		{
			Lighting Off
			ZWrite Off
			Blend DstColor SrcColor
	  
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
		    sampler2D _MainTex;
			sampler2D _Gradient;
			sampler2D _Tile;
			sampler2D _Fade;
			sampler2D _Scroll;
			sampler2D _Mask;
			sampler2D _Scanlines;
			sampler2D _ScanMask;
			fixed4 _ScanColor;
			float _ScanTile;

			struct v2f
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 scrPos : TEXCOORD2;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.scrPos = ComputeScreenPos(o.vertex);
				return o;
			}
		  
		  
		  half4 frag (v2f IN) : COLOR
			{
				fixed4 col = tex2D(_MainTex, IN.texcoord + fixed2(0.5,-0.5));
				
				float2 wcoord = (IN.scrPos.xy/IN.scrPos.w);
				
				fixed4 smask = tex2D(_ScanMask, IN.texcoord1 * fixed2(1,0.5)).a;
				fixed4 scan = tex2D(_Scanlines, wcoord * _ScanTile + _Time.y * 0.15).a;
				
				fixed4 tile = tex2D(_Tile, IN.texcoord * 16).a;
				fixed4 mask = tex2D(_Mask, IN.texcoord).a;
				fixed4 scroll = tex2D(_Scroll, IN.texcoord - fixed2(mask.a*1*_Time.x,mask.a*6*_Time.x));
				fixed4 mosaic = lerp(col,col*scroll*4,mask*tile*2);
				fixed4 grey = fixed4(0.5,0.5,0.5,0.5);
				fixed4 scanlines = mosaic * lerp(fixed4(0.5,0.5,0.5,0.5),smask*scan*_ScanColor*2,smask) * 2;
				fixed4 gradient = lerp(scanlines,grey,tex2D(_Gradient, IN.texcoord - 2).a);
				fixed4 fade = lerp(gradient,grey,tex2D(_Fade, IN.texcoord)*2);
				
				return fade;
			}
		
      ENDCG
		}
		
		
		
		Pass
		{
			Lighting Off
			ZWrite Off
			Blend One One
	  
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
		    sampler2D _MainTex2;
			sampler2D _Fade;
			fixed4 _Color;
			float4 _MainTex2_ST;
			float4 _Fade_ST;
			
			struct v2f
			{
				float4 vertex : POSITION;
				float2 uvmain : TEXCOORD0;
				float2 uvfade : TEXCOORD1;
			};

			v2f vert (appdata_full v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex2);
				o.uvfade = TRANSFORM_TEX( v.texcoord, _Fade);
				return o;
			}
		  
		  
		  half4 frag (v2f IN) : COLOR
			{
				fixed4 col = tex2D(_MainTex2, IN.uvmain);
				fixed4 fade = lerp(col,0,tex2D(_Fade, IN.uvfade)*2);
				
				return fade;
			}
		
      ENDCG
		}
		
    }
	
    Fallback "Diffuse"
 }
