Shader "Unity-Noises/SimplexNoiseGradient/Update"
{
	Properties
	{
		_Intensity("Intensity", Range(0,1)) = 1.0
		_Color("Color", Color) = (1,1,1,1)
		_Scale("Scale", Range(0,10)) = 5
		_Offset("Offset", Range(-3, 3)) = 0
		_Speed("Speed", Range(-5,5)) = 0.3
		_Octave("OctaveNumber", Range(1,6)) = 6
		_OctaveScale("OctaveScaleIncrease", Range(0,10)) = 2
		_Attenuation("OctaveAttenuation", Range(0,1)) = 0.5
		_IsTimeControlled("Is time controlled ? (1=yes)", Range(0,1)) = 0
	}

		CGINCLUDE

#include "UnityCustomRenderTexture.cginc"
#include "../../../Includes/SimplexNoise3D.hlsl"

		float4 _Color;
	float _Octave;
	float _OctaveScale;
	float _Scale;
	float _Offset;
	float _Attenuation;
	float _Speed;
	float _IsTimeControlled;
	float _ControlledTime;
	float _Intensity;

	half4 frag(v2f_customrendertexture i) : SV_Target
	{
		float2 uv = i.globalTexcoord;

		float4 output = _Offset;

		float time = _IsTimeControlled == 1.0f ? _ControlledTime : _Time.y;

		output += SimplexNoiseGradient_Octaves(float3(uv, 0), _Scale, float3(0.0f, 0.0f, _Speed), uint(_Octave), _OctaveScale, _Attenuation, time);

		return output * _Color * _Intensity;

	}

		ENDCG

		SubShader
	{
		Cull Off ZWrite Off ZTest Always
			Pass
		{
			Name "Update"
			CGPROGRAM
			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag
			ENDCG
		}
	}
}
