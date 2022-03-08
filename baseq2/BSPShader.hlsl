#define HLSL
#include "P:/Quake-2/ref_dx11rg/DX11RenderEngine/DX11RenderEngine/CoreRenderSystem/CoreShaderInclude.h"
#include "P:/Quake-2/ref_dx11rg/DX11RenderEngine/DX11RenderEngine/CoreRenderSystem/Renderers/UPRenderer/UPConstBuffers.h"

struct VSIn {
	float3 pos     : Position;
	float2 uv      : TEXCOORD;
	float2 luv     : LIGHTTEXCOORD;
};


struct PSIn {
	float4 pos  : SV_Position;
	float2 uv   : TEXCOORD;
	float2 luv  : LIGHTTEXCOORD;
};


//cbuffer externalData {
//	matrix world;
//	matrix view;
//	matrix projection;
//	float4 color;
//	float2 texOffset;
//}



PSIn vsIn(VSIn input) {
	PSIn vso;

	float3 worldPosition = input.pos;

	vso.pos = mul(mul(mul(float4(worldPosition, 1.0f), UPTransform.world), UPTransform.view), UPTransform.projection);
	vso.uv = input.uv;
	vso.luv = input.luv;// -UPExtraData.texOffset;

	return vso;
}


Texture2D tex : register(t0); 
Texture2D lightMapText : register(t1);

SamplerState basicSampler : register(s0);
SamplerState lightSampler : register(s1);



struct PSOut {
	float4 color   : SV_Target0;
	float4 light   : SV_Target1;
	float  luminance   : SV_Target2;
	float4 alpha   : SV_Target3;
};

float CalcLuminance(float3 color)
{
	return max(dot(color, float3(0.299f, 0.587f, 0.114f)), 0.0001f);
}


PSOut psIn(PSIn input) : SV_Target
{
	PSOut pso;
	pso.color = float4(0, 0, 0, 0);
	pso.light = float4(0, 0, 0, 0);
	pso.luminance = 0;
	pso.alpha = float4(0, 0, 0, 0);
#ifdef RED
	pso.color = float4(1.0, 0, 0, 1.0f);
	pso.light = float4(1.0, 0, 0, 1.0f);
	pso.blume = float4(1.0, 0, 0, 1.0f);
	pso.alpha = float4(1.0, 0, 0, 1.0f);
	return pso;
#endif

#ifdef COLORED
	pso.color = color;
	pso.light = float4(1, 1, 1, 1);
	return color;
#endif


#ifdef ALPHA
	pso.color = float4(0, 0, 0, 0);
	pso.alpha = tex.Sample(basicSampler, input.uv);
	pso.alpha = tex.Sample(basicSampler, input.uv);
	return pso;
#endif 

//return float4(input.uv.x, input.uv.y, 0.0f ,1.0f);
	pso.color = tex.Sample(basicSampler, input.uv) ;
	//result = float4(1.0,1.0,1.0,1.0);
	pso.luminance = saturate(CalcLuminance(pso.color.rgb)*2-1);
//	float4 	
	
#ifdef LIGHTMAPPED
	pso.light = lightMapText.Sample(lightSampler, input.luv);
	pso.light.rgb += float3(1, 1, 1)*0.3;
	pso.light.w = 1.0;
#endif 

	return pso;
}




//VertexShaderOutput main(float2 pos : Position, float3 color : Color) {
//	VertexShaderOutput vso;
//	//matrix worldViewProj = mul(mul(world, view), projection);
//	//vso.pos = mul(float4(pos.x, pos.y, 0.0f, 1.0f), worldViewProj);
//	vso.pos = float4(pos.x, pos.y, 0.0f, 1.0f);
//	vso.color = float4(color, 1.0);
//	return vso;
//}