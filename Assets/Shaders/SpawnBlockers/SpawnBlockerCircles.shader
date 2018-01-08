Shader "Ballistic/SpawnBlockers/SpawnBlockerCircles"
{
    Properties {
	
		_MainTex ("Main Texture", 2D) = "grey" {}
		_FadeTex ("Fade", 2D) = "grey" {}
        _RotationSpeed ("Rotation Speed", Float) = 0.0
       
    }
    SubShader {
	
		Tags 
		{
			"Queue" = "Transparent1"
			"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
		}
		
		Lighting Off
		ZWrite Off
		Cull Off
		Blend One One
       
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
 
        sampler2D _MainTex;
		sampler2D _FadeTex;
 
        struct Input {
            float2 uv_MainTex;
			fixed4 color : COLOR;
        };
       
        float _RotationSpeed;
 
        void vert (inout appdata_full v) {
            v.texcoord.xy -=0.5;
           
            float s = sin (_Time.x * _RotationSpeed);
            float c = cos (_Time.x * _RotationSpeed);
           
            float2x2 rotationMatrix = float2x2( c, -s, s, c);
            rotationMatrix *=0.5;
            rotationMatrix +=0.5;
            rotationMatrix = rotationMatrix * 2-1;
            v.texcoord.xy = mul ( v.texcoord.xy, rotationMatrix );
            v.texcoord.xy += 0.5;
        }
 
        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex).a * IN.color;
            o.Albedo = 0;
			o.Emission = lerp(c,0,tex2D(_FadeTex, IN.uv_MainTex * 0.1)*2);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
