#define HLSL
#include "P:\Quake-2\ref_dx11rg\DX11RenderEngine\DX11RenderEngine\CoreRenderSystem/CoreShaderInclude.h"
#include "P:\Quake-2\ref_dx11rg\DX11RenderEngine\DX11RenderEngine\CoreRenderSystem/Renderers/SkyboxRenderer/SkyboxConstBuffers.h"


struct VSIn {
	float3 pos : Position;
};

struct PSIn {
	float4 pos : SV_Position;
    float3 worldPos : Position;
};

PSIn vsIn(VSIn input)
{
    PSIn vso;
    vso.worldPos = input.pos;
    vso.pos = mul(mul(float4(input.pos, 0.0f), SkyboxTransform.view), SkyboxTransform.projection);
    // make sure that the depth after w divide will be 1.0 (so that the z-buffering will work)
    vso.pos.z = vso.pos.w;
    return vso;
}

TextureCube tex : register(t0);
SamplerState sam : register(s0);

float4 psIn(PSIn input) : SV_TARGET
{
#ifdef RED
    return float4(1,0,0,1);
#endif

    return tex.Sample(sam, input.worldPos);
}