Shader "Ballistic/FX/FPSCreateMask"{

    SubShader {
	
        Tags { "Queue" = "Background" }

        GrabPass {"_GrabMask"}

    }
}