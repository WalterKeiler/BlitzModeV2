Shader "Custom/Field"
{
	
    Properties
    {
    	[Toggle] useWorldSpace ("Use World Space", Int) = 1
        fieldColor ("Field Color", Color) = (.05,1,.01,1)
        lineColor ("Line Color", Color) = (1,1,1,1)
        lineOfScrimmageColor ("Line Of Scrimmage Color", Color) = (.2,.9,.9,1)
        firstDownColor ("First Down Color", Color) = (1,.8,0,1)
        lineOfScrimmage ("Line Of Scrimmage", Float) = 0
        firstDownLine ("First Down Line", Float) = 20
        numberIndent ("Number Indent", Int) = 10
        numberSpacing ("Number Spacing", Float) = 1.5
        yardsLength ("Yards Length", Int) = 100
        yardsWidth ("Yards Width", Int) = 54
        lineWidth ("Line Width", Float) = .1
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
	        #include "Assets/Shaders/SDFNumbers.cginc"
	        
			int useWorldSpace;
	        fixed4 fieldColor;
	        fixed4 lineColor;
	        fixed4 lineOfScrimmageColor;
	        fixed4 firstDownColor;
	        float lineOfScrimmage;
	        float firstDownLine;
	        int numberIndent;
	        float numberSpacing;
	        int yardsLength;
	        int yardsWidth;
	        float lineWidth;
			float2 fieldPos;

	        sampler2D _MainTex;
			float4 _MainTex_ST;
	        
	        struct appdata
	        {
	            float4 vertex : POSITION;
	            float2 uv : TEXCOORD0;
	        };

	        struct v2f
	        {
	            float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 worldPos : TEXCOORD2;
	        };

			v2f vert (appdata v)
	        {
	            v2f o;
	            o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				float a,b,c,d,e,f,g,h;
				a = 0.0;
				b = 0.0;
				c = 1.0;
				d = 1.0;
				e = float(-yardsLength) *0.5;
				f = float(-yardsWidth) *0.5;
				g = float(yardsLength) *0.5;
				h = float(yardsWidth) *0.5;

				fieldPos = float2(
					e + (o.uv.x - a) * (g - e) / (c - a),
					f + (o.uv.y - b) * (h - f) / (d - b)
					);
				o.uv = fieldPos;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
	            return o;
	        }
	        
	        float Zero(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,zero,9,offset,inverted) - .25;

				return x;
			}
			float One(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,one,5,offset,inverted) - .25;

				return x;
			}
			float Two(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,two,9,offset,inverted) - .25;
				return x;
			}
			float Three(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,three,15,offset,inverted) - .25;
				return x;
			}
			float Four(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,four,7,offset,inverted) - .25;
				return x;
			}
			float Five(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,five,10,offset,inverted) - .25;

				return x;
			}
			float Six(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,six,12,offset,inverted) - .25;
        		
				return x;
			}
			float Seven(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,seven,4,offset,inverted) - .25;

				return x;
			}
			float Eight(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,eight,15,offset,inverted) - .25;

				float invert = inverted ? -1.0 : 1.0;

				float2 pos1 = float2(-.9,-.4) * invert;
				float2 pos2 = float2(-.5,0) * invert;

				float p = sdSegment(fieldPos + offset,pos1,pos2)- .25;
				x = min(x, p);

				return x;
			}
			float Nine(float2 offset, bool inverted)
			{
				float x = ArrayToSegment(fieldPos,nine,12,offset,inverted) - .25;

				return x;
			}

			float DrawNumbers(float xpos, float ypos, float spacing)
			{
				float b[5];

				float t[5];

				uint yard = ((uint)yardsLength / 2) - uint(xpos);
				//yard /= 10;
				int digits[5];
				int digitNum = 0;
				while (float(yard) > 0.1)
				{
				    uint digit = yard % 10;
				    yard /= 10;
				    digits[digitNum] = digit;
					digitNum++;
				}

				//digit width * digitNum
				float width = float(digitNum) * (spacing + 1.15) - spacing;
				// added half of a digit to account for the digit being cetered in the middle
				float space = 0.575 - width / 2.0;
				for(int i = digitNum - 1; i >= 0; i--)
				{
					switch(digits[i])
					{
						case 0:
							//min one side of the field with the other
							b[i] = min(Zero(float2(xpos + space,-ypos),false),Zero(float2(-xpos + space,-ypos),false));
							t[i] = min(Zero(float2(xpos + -space,ypos),true),Zero(float2(-xpos + -space,ypos),true));
							break;
						case 1:
							b[i] = min(One(float2(xpos + space,-ypos),false),One(float2(-xpos + space,-ypos),false));
							t[i] = min(One(float2(xpos + -space,ypos),true),One(float2(-xpos + -space,ypos),true));
							break;
						case 2:
							b[i] = min(Two(float2(xpos + space,-ypos),false),Two(float2(-xpos + space,-ypos),false));
							t[i] = min(Two(float2(xpos + -space,ypos),true),Two(float2(-xpos + -space,ypos),true));
							break;
						case 3:
							b[i] = min(Three(float2(xpos + space,-ypos),false),Three(float2(-xpos + space,-ypos),false));
							t[i] = min(Three(float2(xpos + -space,ypos),true),Three(float2(-xpos + -space,ypos),true));
							break;
						case 4:
							b[i] = min(Four(float2(xpos + space,-ypos),false),Four(float2(-xpos + space,-ypos),false));
							t[i] = min(Four(float2(xpos + -space,ypos),true),Four(float2(-xpos + -space,ypos),true));
							break;
						case 5:
							b[i] = min(Five(float2(xpos + space,-ypos),false),Five(float2(-xpos + space,-ypos),false));
							t[i] = min(Five(float2(xpos + -space,ypos),true),Five(float2(-xpos + -space,ypos),true));
							break;
						case 6:
							b[i] = min(Six(float2(xpos + space,-ypos),false),Six(float2(-xpos + space,-ypos),false));
							t[i] = min(Six(float2(xpos + -space,ypos),true),Six(float2(-xpos + -space,ypos),true));
							break;
						case 7:
							b[i] = min(Seven(float2(xpos + space,-ypos),false),Seven(float2(-xpos + space,-ypos),false));
							t[i] = min(Seven(float2(xpos + -space,ypos),true),Seven(float2(-xpos + -space,ypos),true));
							break;
						case 8:
							b[i] = min(Eight(float2(xpos + space,-ypos),false),Eight(float2(-xpos + space,-ypos),false));
							t[i] = min(Eight(float2(xpos + -space,ypos),true),Eight(float2(-xpos + -space,ypos),true));
							break;
						case 9:
							b[i] = min(Nine(float2(xpos + space,-ypos),false),Nine(float2(-xpos + space,-ypos),false));
							t[i] = min(Nine(float2(xpos + -space,ypos),true),Nine(float2(-xpos + -space,ypos),true));
							break;
						default:
							break;
					}
					space += 1.15 + spacing;
				}

				float d = 1000000000000.0;
				for(int j = 0; j < digitNum; j++)
				{
					float s = min(b[j],t[j]);
					d = min(d,s);
				}

				return d;
			}

	        fixed4 frag (v2f i) : SV_Target
	        {
	        	fieldPos = useWorldSpace == 1 ? i.worldPos.xz : i.uv;
	            float halfWidth = float(yardsWidth) * .5;
				float halfLength = float(yardsLength) * .5;
				int closestLargeYard;
				int closestSmallYard;

				float fullLines = CreateLines(fieldPos,yardsLength,yardsWidth,5, closestLargeYard);
				float partialLines = CreateLines(fieldPos,yardsLength,yardsWidth,1, closestSmallYard);

				float edgeDist = sdBox(fieldPos,float2(halfLength,halfWidth));
				float partialLineBox = sdBox(fieldPos,float2(halfLength,halfWidth - halfWidth / 10.0));

				float los = sdSegment(fieldPos, float2(lineOfScrimmage, float(yardsWidth)), float2(lineOfScrimmage, -float(yardsWidth)))-0.10;
				float fd = sdSegment(fieldPos, float2(firstDownLine, float(yardsWidth)), float2(firstDownLine, -float(yardsWidth)))-0.10;

				float3 losVec = (los<0.0) ? float3(1,1,1) : float3(0,0,0);
				losVec -= step(1,edgeDist);
				
				float3 fdVec = (fd<0.0) ? float3(1,1,1) : float3(0,0,0);
				fdVec -= step(1,edgeDist);

				float3 col = (fullLines>0.0) ? float3(1,1,1) : float3(0,0,0);
				
				col *= step(fullLines,lineWidth);
				col += step(1,partialLineBox);
				col *= step(partialLines,lineWidth);
				col += step(1,edgeDist);

				float3 onLine = (abs(fullLines) < .5) ? float3(1,1,1) : float3(0,0,0);
				float onTenYard = (((uint)closestLargeYard) % 10 == 0) ? 1.0 : 0.0;

				float3 onEdge = float(step(0, partialLineBox + float(numberIndent))).xxx;
				onEdge *= float(step((partialLineBox + float(numberIndent)) - 1.0, 0)).xxx;

				float d = DrawNumbers(float(closestLargeYard) * onTenYard,halfWidth - float(numberIndent),numberSpacing);

				col += (d<0.0) ? float3(1,1,1) : float3(0,0,0);
				
				losVec = clamp(losVec,0,1);
				fdVec = clamp(fdVec,0,1);
				col = clamp(col,0,1);

				col -= losVec;
				col -= fdVec;

				col = clamp(col,0,1);
				
				float3 lineCol = col * lineColor;
				float3 fieldCol = -col * fieldColor;
				float3 losCol = losVec * lineOfScrimmageColor;
				float3 fdCol = fdVec * firstDownColor;

				float3 finalCol = lineCol + fieldColor + losCol + fdCol;
				
				finalCol = clamp(finalCol,0,1);
				return half4(finalCol,1);
	        }
	        ENDCG
		}
    }
    FallBack "Diffuse"
}
