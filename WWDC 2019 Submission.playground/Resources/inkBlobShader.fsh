bool DE( vec2 pp, float t )
{
	pp.y += (
			 .4 * sin(.5*2.3*pp.x+pp.y) +
			 .2 * sin(.5*5.5*pp.x+pp.y) +
			 0.1* sin(.5*13.7*pp.x )+
			 0.06*sin(.5*23.*pp.x ));
	
	pp.y += (.4 * sin(.5*2.3*pp.x+pp.y * t));
	
	pp += vec2(0.,0.4)*t;
	
	//how "far out"
	float thresh = 4.3;
	
	bool check = pp.y > thresh;
	return check;
}

vec4 sceneColour(vec2 pp, float time )
{
	float endTime = 32.;
	float rewind = 2.;
	float t = mod(time, endTime+rewind );
	
	if( t > endTime )
		t = endTime * (1.-(t-endTime)/rewind);
	
	bool check = DE( pp, t * 5.0);
	
	if(check)
	{
		// floor. not really happy with this at the moment..
		//black color
		vec4 floorCol = vec4(0.0, 0.0, 0.0, 1.0);
		return floorCol;
	}
	else
	{
		//white color
		vec4 res = vec4(0.0, 0.0, 0.0, 0.0);
		return res;
	}
}

void main()
{
	vec2 uv = v_tex_coord;
	
	vec2 x = uv - vec2(0.5, 0.5);
	float radius = length(x*4.0);
	float angle = atan(x.y, x.x);
	
	vec4 fragColor = vec4(0.0);
	fragColor = sceneColour(vec2(angle, -1.0 * radius) * 9.0, TEST);
	gl_FragColor = fragColor;
}
