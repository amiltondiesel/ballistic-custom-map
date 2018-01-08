Shader "Ballistic/UI/GrabCollect"{

Category {

	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	
	Cull Off
	Lighting Off
	ZWrite Off
	
	SubShader {

	GrabPass {"_GrabPassUI"}
	
	}
}
}