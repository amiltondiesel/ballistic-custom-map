Shader "Ballistic/FX/BallisticCreateMask"{
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
		GrabPass {"_GrabMask"}
}

}
