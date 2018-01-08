Shader "Ballistic/UI/Blur" {
    Properties {
		[HideInInspector]_MainTex ("Main Texture", 2D) = "grey" {}
        [HideInInspector]
		_StencilComp ("Stencil Comparison", Float) = 8
		[HideInInspector]
		_Stencil ("Stencil ID", Float) = 0
		[HideInInspector]
		_StencilOp ("Stencil Operation", Float) = 0
		[HideInInspector]
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		[HideInInspector]
		_StencilReadMask ("Stencil Read Mask", Float) = 255
    }
 
    Category {

        Tags { 
        	"Queue"="Transparent" 
        	"IgnoreProjector"="True" 
        	"RenderType"="Opaque" 
        }
		
		ZWrite Off

		Stencil {
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

        SubShader {
            GrabPass {                     
                Tags { "LightMode" = "Always" }
            }
            
            // Horizontal blur
            Pass {
            	Name "HORIZONTAL"
            
                Tags { "LightMode" = "Always" }
               
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
               
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
					o.color = v.color * 30;
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
               
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
               
                half4 frag( v2f i ) : COLOR {
                    half4 sum = half4(0,0,0,0);
 
                    #define GRABPIXEL(weight,kernelx) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x + _GrabTexture_TexelSize.x * kernelx * i.color.a, i.uvgrab.y, i.uvgrab.z, i.uvgrab.w))) * weight
 
                    sum += GRABPIXEL(0.05, -4.0);
                    sum += GRABPIXEL(0.09, -3.0);
                    sum += GRABPIXEL(0.12, -2.0);
                    sum += GRABPIXEL(0.15, -1.0);
                    sum += GRABPIXEL(0.18,  0.0);
                    sum += GRABPIXEL(0.15, +1.0);
                    sum += GRABPIXEL(0.12, +2.0);
                    sum += GRABPIXEL(0.09, +3.0);
                    sum += GRABPIXEL(0.05, +4.0);
                   
                    return sum;
                }
                
                ENDCG
            }
 
            GrabPass {                         
                Tags { "LightMode" = "Always" }
            }
            
            // Vertical blur
            Pass {
            	Name "VERTICAL"
                Tags { "LightMode" = "Always" }
               
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
               
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
					o.color = v.color * 30;
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
               
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
               
                half4 frag( v2f i ) : COLOR {
                    half4 sum = half4(0,0,0,0);
 
                    #define GRABPIXEL(weight,kernely) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x, i.uvgrab.y + _GrabTexture_TexelSize.y * kernely * i.color.a, i.uvgrab.z, i.uvgrab.w))) * weight
 
                    sum += GRABPIXEL(0.05, -4.0);
                    sum += GRABPIXEL(0.09, -3.0);
                    sum += GRABPIXEL(0.12, -2.0);
                    sum += GRABPIXEL(0.15, -1.0);
                    sum += GRABPIXEL(0.18,  0.0);
                    sum += GRABPIXEL(0.15, +1.0);
                    sum += GRABPIXEL(0.12, +2.0);
                    sum += GRABPIXEL(0.09, +3.0);
                    sum += GRABPIXEL(0.05, +4.0);
                   
                    return sum;
                }
                
                ENDCG
            }
            
            GrabPass {                     
                Tags { "LightMode" = "Always" }
            }
            
            // Horizontal blur
            Pass {
            	Name "HORIZONTAL"
            
                Tags { "LightMode" = "Always" }
               
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
               
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
					o.color = v.color * 30;
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
               
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
               
                half4 frag( v2f i ) : COLOR {
                    half4 sum = half4(0,0,0,0);
 
                    #define GRABPIXEL(weight,kernelx) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x + _GrabTexture_TexelSize.x * kernelx * i.color.a * 1.61, i.uvgrab.y, i.uvgrab.z, i.uvgrab.w))) * weight
 
                    sum += GRABPIXEL(0.05, -4.0);
                    sum += GRABPIXEL(0.09, -3.0);
                    sum += GRABPIXEL(0.12, -2.0);
                    sum += GRABPIXEL(0.15, -1.0);
                    sum += GRABPIXEL(0.18,  0.0);
                    sum += GRABPIXEL(0.15, +1.0);
                    sum += GRABPIXEL(0.12, +2.0);
                    sum += GRABPIXEL(0.09, +3.0);
                    sum += GRABPIXEL(0.05, +4.0);
                   
                    return sum;
                }
                
                ENDCG
            }
 
            GrabPass {                         
                Tags { "LightMode" = "Always" }
            }
            
            // Vertical blur
            Pass {
            	Name "VERTICAL"
                Tags { "LightMode" = "Always" }
               
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
               
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
					o.color = v.color * 30;
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
               
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
               
                half4 frag( v2f i ) : COLOR {
                    half4 sum = half4(0,0,0,0);
 
                    #define GRABPIXEL(weight,kernely) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x, i.uvgrab.y + _GrabTexture_TexelSize.y * kernely * i.color.a * 1.61, i.uvgrab.z, i.uvgrab.w))) * weight
 
                    sum += GRABPIXEL(0.05, -4.0);
                    sum += GRABPIXEL(0.09, -3.0);
                    sum += GRABPIXEL(0.12, -2.0);
                    sum += GRABPIXEL(0.15, -1.0);
                    sum += GRABPIXEL(0.18,  0.0);
                    sum += GRABPIXEL(0.15, +1.0);
                    sum += GRABPIXEL(0.12, +2.0);
                    sum += GRABPIXEL(0.09, +3.0);
                    sum += GRABPIXEL(0.05, +4.0);
                   
                    return sum;
                }
                
                ENDCG
            }
            
            // Distortion
            GrabPass {                         
                Tags { "LightMode" = "Always" }
            }
            
            Pass {
                Tags { "LightMode" = "Always" }
               
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
               
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
					fixed4 color : COLOR;
                };
               
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
					float2 texcoord : TEXCOORD1;
					fixed4 color : COLOR;
                };
               
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = v.texcoord;
					o.color = v.color;
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    
                    return o;
                }
               
                half4 _TintColor;
				sampler2D _MainTex;
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                
                half4 frag( v2f i ) : COLOR {
                    half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
					half tex = tex2D( _MainTex, i.texcoord).a;
                   	col = lerp (col, i.color, tex * i.color.a);
                    return col;
                }
                
                ENDCG
            }
        }
    }
}