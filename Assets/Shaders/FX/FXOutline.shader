Shader "Ballistic/FX/Outline"
{
    Properties {
		_Color ("Main Color", Color) = (0.9,0,0,1)
		_Thickness ("Outline Thickness", Range(0,1)) = 0.1
		//_CompensationStrength ("CompensationStrength", Range(0,1)) = 0.8
		[Gamma] _Exposure ("Exposure", Range(1,20)) = 2.5
		_FadeTex ("Fade", 2D) = "grey" {}
    }
	
    SubShader {
	 
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite On
		ZTest Always

			Pass
		{

		ColorMask 0

			Stencil
		{
			Ref 8
			Comp always
			Pass replace
			ZFail replace
		}

		}

		Pass
		{

		Stencil
		{
			Ref 8
			Comp notequal
			Pass replace
			Fail replace
		}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
			fixed4 _Color;
			sampler2D _FadeTex;
			half _Thickness;
			half _CompensationStrength;
			half _Exposure;

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : POSITION;
				float2 scrPos : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				
				//v.vertex.xyz += v.normal * _Thickness * 0.1;
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				float3 norm = normalize(mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				float2 offset = TransformViewToProjection(norm.xy);
				
				//offset.x = lerp(offset.x, offset.x / UNITY_MATRIX_P[0][0], _CompensationStrength);
				//offset.y = lerp(offset.y, offset.y / UNITY_MATRIX_P[1][1], _CompensationStrength);
				//offset = lerp(offset * 0.1, offset * 0.9, saturate(o.vertex.z * 0.1));
				
				o.vertex.xy += offset * _Thickness * 0.1;
				
				float4 scoord = ComputeScreenPos(o.vertex);
				o.scrPos = (scoord.xy / scoord.w);

				return o;
			}
		  
		  half4 frag (v2f i) : COLOR
			{
				fixed4 col = _Color;
				col.rgb *= _Exposure;
				col.a *= tex2D(_FadeTex, i.scrPos).a;
				return col;
			}
		
      ENDCG
		}

    }
	
	Fallback Off
 }
