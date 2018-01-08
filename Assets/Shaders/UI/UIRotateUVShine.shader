Shader "Ballistic/UI/RotateUVShine"
{
    Properties {
	
		[HideInInspector]_MainTex ("Main Texture", 2D) = "grey" {}
		_ShineColor ("Shine Color", Color) = (0.5,0.5,0.5,0.5)
		_ShineTex ("Shine", 2D) = "black" {}
		_RotationSpeed ("Rotation Speed", Float) = 0.0
       
    }
    SubShader {
	
		Tags 
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Lighting Off
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
		  
		    sampler2D _MainTex;
			sampler2D _ShineTex;
			fixed4 _ShineColor;
			half _RotationSpeed;
			fixed4 _Color;

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
				fixed4 shn = tex2D(_ShineTex, i.texcoord.zw).a * _ShineColor;
				col += fixed4(shn.r,shn.g,shn.b,0);
				col.a *= tex2D(_MainTex, i.texcoord.xy).a;

				return col;
			}
		
      ENDCG
		}
    }
 }
