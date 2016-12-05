//

Shader "Custom/RimLight_ShadowCaster" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
		_RimPower ("Rim Power", Float) = 0.7
	}
	SubShader {
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct appdata {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;
					float3 color : COLOR;
				};

				uniform float4 _MainTex_ST;
				uniform float4 _RimColor;
				float _RimPower;
				v2f vert (appdata_base v) {
					v2f o;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
					float dotProduct = 1 - dot(v.normal, viewDir);
					float rimWidth = _RimPower;
					o.color = smoothstep(1 - rimWidth, 1.0, dotProduct);
					o.color *= _RimColor;
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					return o;
				}
				
				uniform sampler2D _MainTex;
				uniform float4 _Color;
				
				float4 frag(v2f i) : COLOR {
					float4 texcol = tex2D(_MainTex, i.uv);
					texcol *= _Color;
					texcol.rgb += i.color;
					return texcol;
				}
				
			ENDCG
		}
	}
	SubShader {
		LOD 100
		
	// Pass to render object as a shadow caster
		Pass {
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }
			
			Fog {Mode Off}
			ZWrite On
			ZTest LEqual
			Cull Off

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_shadowcaster
#pragma fragmentoption ARB_precision_hint_fastest
#pragma exclude_renderers d3d11_9x
#include "UnityCG.cginc"

struct v2f { 
	V2F_SHADOW_CASTER;
};

v2f vert( appdata_base v )
{
	v2f o;
	TRANSFER_SHADOW_CASTER(o)
	return o;
}

float4 frag( v2f i ) : COLOR
{
	SHADOW_CASTER_FRAGMENT(i)
}
ENDCG
		}
	}
}
