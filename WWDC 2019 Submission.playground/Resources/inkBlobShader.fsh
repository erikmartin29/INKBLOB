bool DE( vec2 pp, float t )
{
	pp.y += (
			 .4 * sin(.5*2.3*pp.x+pp.y) +
			 .2 * sin(.5*5.5*pp.x+pp.y) +
			 0.1*sin(.5*13.7*pp.x )+
			 0.06*sin(.5*23.*pp.x ));
	
	pp.y += (
			 .4 * sin(.5*2.3*pp.x+pp.y * t));
	
	pp += vec2(0.,0.4)*t;
	
	float thresh = 4.3;
	
	
	bool check = pp.y > thresh;
	return check;
}

vec3 sceneColour(vec2 pp, float time )
{
	float endTime = 16.;
	float rewind = 2.;
	float t = mod( time, endTime+rewind );
	
	if( t > endTime )
		t = endTime * (1.-(t-endTime)/rewind);
	
	bool check = DE( pp, t);
	
	if(check)
	{
		// floor. not really happy with this at the moment..
		vec3 floorCol = vec3(1.0, 1.0, 1.0);
		return floorCol;
	}
	else
	{
		vec3 res = vec3(0.0, 0.0, 0.0);
		return res;
	}
}

void main()
{
	vec2 uv = v_tex_coord;
	
	vec2 x = uv - vec2(0.5, 0.5);
	float radius = length(x*2.0);
	float angle = atan(x.y, x.x);
	
	
	vec4 fragColor = vec4(0.0);
	fragColor.a = 1.0;
	fragColor.xyz = sceneColour(vec2(angle, radius) * 4.0, u_time);
	gl_FragColor = fragColor;
}

