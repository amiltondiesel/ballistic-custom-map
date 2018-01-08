Shader "Ballistic/FX/ShadowProject" 
{
	Properties 
	{   
		_Alpha("Alpha", Range(0.0, 1.0)) = 1.0
        _LightDirection ("Light Direction",Vector) = (0,1,0,0)        
        _GroundPosition ("Ground Position",Vector) = (0,0,0,0)
        [HideInInspector] _GroundNormal   ("Ground Normal Vector",Vector) = (0,1,0,0)
	}	

	SubShader 
	{
        Tags
        {
            "Queue" = "Transparent"
        }
		
		ZWrite Off
		Blend Zero SrcColor
		Cull Off
		
			Stencil
		{
			Ref 4
			Comp greater
			Pass replace
			Fail keep
		}
		
		 Pass 
         {            

            CGPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                float4 texcoord      : TEXCOORD0;                
            };

            struct v2f 
            {
                float4 vertex  : SV_POSITION;
                float4 texcoord   : TEXCOORD0;
            };
            
            half4 _LightDirection;
            half4 _GroundPosition;
            half4 _GroundNormal;   
			half  _AttenExp;
			half _Alpha;
            



            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                _LightDirection = normalize(_LightDirection);
                _GroundNormal = normalize(_GroundNormal);
                
				half3 offset = fixed3(0,0.03f,0);
                half4 ws_vertex = mul(unity_ObjectToWorld, v.vertex);					                    
                half plane_d = -dot(_GroundPosition.xyz - offset,_GroundNormal.xyz);
                half proj_scalar = - (dot(_GroundNormal.xyz,ws_vertex.xyz) + plane_d) / dot(_GroundNormal.xyz,_LightDirection.xyz);
         
                ws_vertex += (_LightDirection * proj_scalar);
				o.texcoord.z = distance(ws_vertex.xyz,_GroundPosition.xyz);			
                half4 os_vertex = mul(unity_WorldToObject, ws_vertex);
				os_vertex += float4(offset,0);
                o.vertex = UnityObjectToClipPos(os_vertex);
                o.texcoord.xyw  = o.vertex.xyw;
                return o;
            }
                        
            half4 frag (v2f i) : COLOR
            {   
                float r = saturate(i.texcoord.z * 0.7 + (1-_Alpha));
                return lerp(0,1,r);
            }
            ENDCG
        }
    }
}