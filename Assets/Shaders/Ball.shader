Shader "Unlit/Ball"
{
    Properties
    {
        ballColor ("Ball Color", Color) = (.4,.2,0,1)
        lineColor ("Line Color", Color) = (1,1,1,1)
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
            
            #include "UnityCG.cginc"
	        #include "Assets/Shaders/SDFFunctions.cginc"

			fixed4 ballColor;
			fixed4 lineColor;
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float d, dstep;
				float2 start, end;
				const int lace_count = 7;

				start = float2(0.5,0.3);
				end = float2(0.5, .7);
				d = sdSegment(i.uv, start, end) -0.01;

				for (int j = 0; j < lace_count; j++)
				{
					d = min(
						d,
						sdSegment(
							i.uv,
							start + float2(-0.025, float(j)/((float(lace_count)-1.0)/(end.y - start.y))),
							start + float2(0.025, float(j)/((float(lace_count)-1.0)/(end.y - start.y)))
						)-0.01
					);
				}

				fixed4 col = (d<0.0) ? lineColor : ballColor;
                return col;
            }
            ENDCG
        }
    }
}
