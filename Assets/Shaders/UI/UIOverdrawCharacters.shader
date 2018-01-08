Shader "Ballistic/UI/OverdrawCharacters" {
Properties {
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

SubShader {

		Tags
	
		{ "RenderType"="Opaque" }

		GrabPass {}
		
CGPROGRAM
#pragma surface surf Lambert vertex:vert
#pragma target 3.0

sampler2D _BumpMap;
sampler2D _GrabTexture;
uniform float4 _AlbedoColor;
uniform sampler2D _SplattTex;
uniform sampler2D _ScatterTex;
uniform sampler2D _Scans;
uniform float _AnimatedMask;
uniform float _AnimatedFloat;

struct Input 
{	
	float3 viewDir;
	float4 scrPos;
	float2 uv_BumpMap;
};

	void vert (inout appdata_full v, out Input o)

	{
		UNITY_INITIALIZE_OUTPUT(Input,o);
		float4 hpos = UnityObjectToClipPos(v.vertex);
		#if UNITY_UV_STARTS_AT_TOP
		float scale = -1.0f;
		#else
		float scale = 1.0f;
		#endif
		o.scrPos.xy = (float2(hpos.x, hpos.y*scale) + hpos.w) * 0.5;
		o.scrPos.zw = hpos.zw;
	}

void surf (Input IN, inout SurfaceOutput o) {

	float2 screenUV = IN.scrPos.xy / IN.scrPos.w;

	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	fixed4 grab = tex2D(_GrabTexture,screenUV);
	
	half scan = tex2D(_Scans, ((screenUV * 20)- (_Time.y * 5))).a;
	half mask = tex2D(_ScatterTex, screenUV * 0.7 + float2(0,_AnimatedMask * 0.1)).r;
	
	half splat = tex2D(_SplattTex, (screenUV * fixed2(3,2)) + frac(float2(0.5,-0.2) * _Time.y * 0.6)).r;
	half scroll = tex2D(_SplattTex, (screenUV * fixed2(4,2.7)) - frac(float2(1,0.2) * _Time.y * 0.3)).a;
	
	half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
	
	half4 contour = rim * rim * fixed4(1.5,0.6,0.0,0.0);
	
	float trans = clamp(pow(splat * scroll * rim * _AnimatedFloat * 5 + mask, 4),0,1);

	o.Albedo = lerp(fixed4(0,0,0,0),(_AlbedoColor * scan + contour) * 4 * splat,trans);
	
	o.Emission = lerp(grab,0,trans);
	
}
ENDCG  
}

FallBack "Diffuse"
}

