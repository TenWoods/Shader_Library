Shader "Unlit/CRTshader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_PixelTex ("Pixel Texture", 2D) = "white" {}
		_PixelNum ("Pixel Num", Int) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _PixelTex;
			int _PixelNum;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.uv);
				UNITY_APPLY_FOG(i.fogCoord, col);
				fixed2 pixel_uv = frac(i.uv * _PixelNum);
				fixed3 pixelColor = tex2D(_PixelTex, pixel_uv).rgb;
				return color * fixed4(pixelColor, 1.0);
			}
			ENDCG
		}
	}
}
