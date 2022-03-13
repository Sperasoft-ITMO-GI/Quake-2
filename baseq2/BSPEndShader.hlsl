#define HLSL
#include "P:\Quake-2\ref_dx11rg\DX11RenderEngine\DX11RenderEngine\CoreRenderSystem/CoreShaderInclude.h"
#include "P:\Quake-2\ref_dx11rg\DX11RenderEngine\DX11RenderEngine\CoreRenderSystem/Renderers/EndRenderer/EndRendererConstBuffer.h"

struct VSIn
{
    float2 pos : Position;
    float2 uv : TEXCOORD;
};

struct PSIn
{
    float4 pos : SV_Position;
    float2 uv : TEXCOORD;
};

PSIn vsIn(VSIn input)
{
    PSIn output = (PSIn)0;

    output.pos = float4(input.pos, 0.0f, 1.0f);
    output.uv = input.uv;
    return output;
}


Texture2D diffuseColor : register(t0);
Texture2D lightmap : register(t2);
Texture2D bloomMask : register(t1);

#ifdef ALPHA
Texture2D alphaSurfaces : register(t3);
#endif

SamplerState basicSampler : register(s0);

float4 psIn(PSIn input) : SV_Target
{
    float2 texCoord = input.uv;

#ifdef BLOOMONLY
	return bloomMask.Sample(basicSampler, texCoord);
#endif
#ifdef COLORONLY
	return diffuseColor.Sample(basicSampler, texCoord);
#endif
#ifdef LIGHTONLY
	return lightmap.Sample(basicSampler, texCoord);
#endif
    
#ifdef ALPHAONLY
#ifdef ALPHA
    float4 alphaColor = alphaSurfaces.Sample(basicSampler, texCoord);
    //alphaColor.w = 0.3;
    return alphaColor;
#endif
	return 0;
#endif

#ifdef ALPHA
	float4 alphaColor = alphaSurfaces.Sample(basicSampler, texCoord);
	alphaColor.w = 0.3;
	return alphaColor;
#endif

    float4 color = diffuseColor.Sample(basicSampler, texCoord);
    float4 light = lightmap.Sample(basicSampler, texCoord);
    float4 bloom = bloomMask.Sample(basicSampler, texCoord);
    return color*light + float4(bloom.rgb, 0.0f);

}
