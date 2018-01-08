Shader "Ballistic/Environment/WonderdomeWater" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_FoamColor ("Foam Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrGloss (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_WindShakeVelocity ("Shake Velocity", float) = 6
	_WindShakeForce ("Shake Force", float) = 0.18
	_WindDirection ("Wind Direction", Vector) = (0,1,1,0)

}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	Alphatest Greater 0
	Fog { Mode Off }
	ZWrite Off
	ColorMask RGB
	
CGPROGRAM

#pragma surface surf BlinnPhong vertex:VertShader alpha:blend
#pragma target 3.0

sampler2D _MainTex;
sampler2D _BumpMap;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;
fixed4 _FoamColor;
half _Shininess;
float _WindShakeVelocity;
float _WindShakeForce;
float4 _WindDirection;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	fixed4 color : COLOR;
	float3 worldRefl;
	INTERNAL_DATA
};

void VertShader (inout appdata_full v) 
		{
			half3 dir = normalize(_WindDirection);
			
			half atten = v.color.y;
			
			half sin0 = sin(_Time.x * _WindShakeVelocity*5 * atten);
			half sin1 = sin((_Time.x+3.567) * _WindShakeVelocity * atten);
			
			half3 shkVel = (sin0 * sin1 * dir * v.color.r);
			v.vertex.xyz += shkVel * _WindShakeForce;
		}

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex * _Color;
	o.Albedo = c.rgb + (IN.color.a * _FoamColor);
	
	o.Gloss = tex.a - IN.color.a;
	o.Specular = _Shininess;
	
	o.Normal = 0;
	o.Normal += UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap * 0.9));
	o.Normal += UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex * 1.1));
	o.Normal = normalize(o.Normal);
	
	float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	fixed4 reflcol = texCUBE (_Cube, worldRefl);
	fixed4 reffoam = reflcol * (1 - IN.color.a);
	o.Emission = reffoam * _ReflectColor.rgb + (IN.color.a * _FoamColor);
	o.Alpha = c.a + o.Emission;
}
ENDCG
}

FallBack "Transparent/Diffuse"
}
