Shader "Ballistic/UI/GrabCollect2nd"{

Category {

	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	
	Cull Off
	Lighting Off
	ZWrite Off
	
	SubShader {

	GrabPass {"_GrabPassUI2nd"}
	
	}
}
}