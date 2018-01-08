Shader "Ballistic/FX/RefractiveScopeGrab"{

	// MEDIUM QUALITY

    SubShader {
	
        Tags { "Queue" = "Background" "LightMode" = "Always"}
		LOD 200

		Cull Off
		ZWrite Off

        GrabPass {"_GrabMaskScope"
		Tags{ "Queue" = "Background" "LightMode" = "Always" }
		}

    }
	
Fallback Off
	
}