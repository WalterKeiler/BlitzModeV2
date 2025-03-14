static const int arrayMaxLength = 15;

float smin(float a, float b, float k)
    {
        float h = max(k - abs(a - b), 0.0) / k;
        return min(a, b) - h * h * k * (1.0 / 4.0);
    }
    float sdBox( in float2 p, in float2 b )
    {
        float2 d = abs(p)-b;
        return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
    }
    float sdSegment( in float2 p, in float2 a, in float2 b )
    {
        float2 pa = p-a, ba = b-a;
        float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
        return length( pa - ba*h );
    }
    float sdOrientedBox( in float2 p, in float2 a, in float2 b, float th )
    {
        float l = length(b-a);
        float2  d = (b-a)/l;
        float2  q = (p-(a+b)*0.5);
        q = mul(float2(d.x,-d.y),float2(d.y,d.x))*q;
        q = abs(q)-float2(l,th)*0.5;
        return length(max(q,0.0)) + min(max(q.x,q.y),0.0);
    }
    float CreateLines(float2 pos,uint totalLength, int totalWidth,int interval, out int closestYard)
    {
        float d = 1000000000000.0;
        int yardIndex = -1;
        for(uint i = 0; i <= totalLength / 2; i += interval)
        {
            float nextDist = sdBox(pos,float2(float(i),float(totalWidth)));
            d = min(d,abs(nextDist));

            if(d == abs(nextDist) && i < totalLength / 2) yardIndex = i;
        }

        closestYard = yardIndex;

        return d;
    }

    float dot2(float2 input)
    {
        return dot(input,input);
    }

    float ArrayToSegment(float2 pos, float2 points[15], int size, float2 offset, bool inverted)
    {
        float d = 1000000000000.0;
        float invert = inverted ? -1.0 : 1.0;
        for(int i = 0; i < size - 1; i++)
        {
            float2 pos1 = points[i] * invert;
            float2 pos2 = points[i+1] * invert;

            float p = sdSegment(pos + offset,pos1,pos2);
            d = min(d,p);
        }
        return d;
    }