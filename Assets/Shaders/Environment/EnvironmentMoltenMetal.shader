Shader "Ballistic/Environment/MoltenMetal" {
	Properties{

		_Color("Main Color", Color) = (1,1,1,1)
		_ReflectColor("Reflection Color", Color) = (1,1,1,0.5)
		[Gamma] _Exposure("Exposure", Range(0, 20)) = 1.0
		_MainTex("Base (RGB), RefStrength (A)", 2D) = "white" {}
		_DisTex("Distort (RG)", 2D) = "white" {}
		_Cube("Reflection Cubemap", Cube) = "" {}
		_BumpMap("Normalmap", 2D) = "bump" {}
	}

	SubShader {

		Tags{ "RenderType" = "Opaque" }
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		Cull Off
		LOD 200

		Pass{
		Name "BASE"
		Tags{ "LightMode" = "Always" }

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		struct v2f
		{
			float4  pos     : SV_POSITION;
			float4  color   : COLOR;
			float2	uv		: TEXCOORD0;
			float4	uv2		: TEXCOORD1;
			float3	I		: TEXCOORD2;
			float3	TtoW0 	: TEXCOORD3;
			float3	TtoW1	: TEXCOORD4;
			float3	TtoW2	: TEXCOORD5;
		};

		v2f vert(appdata_full v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord - frac(float2(_Time.x* 0.3, _Time.x));
			o.uv2.xy = v.texcoord + frac(float2(_Time.x,_Time.x * 1));
			o.uv2.zw = v.texcoord - frac(float2(_Time.x, _Time.x * 0.7));

			o.I = -WorldSpaceViewDir(v.vertex);

			float3 worldNormal = UnityObjectToWorldNormal(v.normal);
			float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
			float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
			o.TtoW0 = float3(worldTangent.x, worldBinormal.x, worldNormal.x);
			o.TtoW1 = float3(worldTangent.y, worldBinormal.y, worldNormal.y);
			o.TtoW2 = float3(worldTangent.z, worldBinormal.z, worldNormal.z);

			o.color = v.color;

			return o;
		}

			sampler2D _BumpMap;
			sampler2D _MainTex;
			sampler2D _DisTex;
			samplerCUBE _Cube;
			fixed4 _ReflectColor;
			fixed4 _Color;
			float _Exposure;

		fixed4 frag(v2f i) : SV_Target
		{
			fixed2 distort1 = tex2D(_DisTex,i.uv2.xy).rg;
			fixed2 distort2 = tex2D(_DisTex, i.uv2.zw).rg;
			fixed2 distortcomp = distort1 - distort2;
			fixed3 normal = UnpackNormal(tex2D(_BumpMap, i.uv + distortcomp));
			fixed4 tex = tex2D(_MainTex,i.uv + distortcomp);

			// transform normal to world space
			half3 wn;
			wn.x = dot(i.TtoW0, normal);
			wn.y = dot(i.TtoW1, normal);
			wn.z = dot(i.TtoW2, normal);

			// calculate reflection vector in world space
			half3 r = reflect(i.I, wn);

			half4 col = tex * _Color;

			half4 reflcolor = texCUBE(_Cube, r) * _ReflectColor;
			col = (col + reflcolor) * _Exposure * i.color.a;
			col.a = tex.a * i.color.a;

			return col;
		}
			ENDCG
		}
}

SubShader{

			Tags{ "RenderType" = "Opaque" }
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Off
			LOD 100

			Pass{
			Name "BASE"
			Tags{ "LightMode" = "Always" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

		struct v2f
		{
			float4  pos     : SV_POSITION;
			float4  color   : COLOR;
			float2	uv		: TEXCOORD0;
			float4	uv2		: TEXCOORD1;
			float3	I		: TEXCOORD2;
			float3	TtoW0 	: TEXCOORD3;
			float3	TtoW1	: TEXCOORD4;
			float3	TtoW2	: TEXCOORD5;
		};

		v2f vert(appdata_full v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord - frac(float2(_Time.x* 0.3, _Time.x));
			o.uv2.xy = v.texcoord + frac(float2(_Time.x,_Time.x * 1));
			o.uv2.zw = v.texcoord - frac(float2(_Time.x, _Time.x * 0.7));

			o.I = -WorldSpaceViewDir(v.vertex);

			float3 worldNormal = UnityObjectToWorldNormal(v.normal);
			float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
			float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
			o.TtoW0 = float3(worldTangent.x, worldBinormal.x, worldNormal.x);
			o.TtoW1 = float3(worldTangent.y, worldBinormal.y, worldNormal.y);
			o.TtoW2 = float3(worldTangent.z, worldBinormal.z, worldNormal.z);

			o.color = v.color;

			return o;
		}

		sampler2D _BumpMap;
		sampler2D _MainTex;
		sampler2D _DisTex;
		samplerCUBE _Cube;
		fixed4 _ReflectColor;
		fixed4 _Color;
		float _Exposure;

		fixed4 frag(v2f i) : SV_Target
		{
			fixed2 distort1 = tex2D(_DisTex,i.uv2.xy).rg;
		fixed2 distort2 = tex2D(_DisTex, i.uv2.zw).rg;
		fixed2 distortcomp = distort1 - distort2;
		fixed3 normal = UnpackNormal(tex2D(_BumpMap, i.uv + distortcomp));
		fixed4 tex = tex2D(_MainTex,i.uv + distortcomp);

		// transform normal to world space
		half3 wn;
		wn.x = dot(i.TtoW0, normal);
		wn.y = dot(i.TtoW1, normal);
		wn.z = dot(i.TtoW2, normal);

		// calculate reflection vector in world space
		half3 r = reflect(i.I, wn);

		half4 col = tex;

		half4 reflcolor = texCUBE(_Cube, r) * _ReflectColor;// *tex.a;
		col = (col + reflcolor) * 1.5;
		col.a = i.color.a * 0.8;

		return col;
		}
			ENDCG
		}
}
		FallBack "Legacy Shaders/VertexLit"
}