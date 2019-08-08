precision highp float;

uniform sampler2D u_tex;
uniform float u_bgRes;
uniform float u_screenRes;
uniform vec2 u_camera;
uniform float u_time;

varying vec2 v_uv;

#ifdef VERTEX

    attribute vec2 a_position;

    void main()
    {
        gl_Position = vec4(a_position, 0, 1);
        v_uv = a_position.xy*0.5 + 0.5;
    }

#endif
#ifdef FRAGMENT

    void main()
    {
        vec2 lookupUV = (v_uv - .5) * u_screenRes / u_bgRes + u_camera;
        vec4 normalMapLookup = texture2D(u_tex, lookupUV);

        vec2 fromCam = lookupUV - u_camera;
        float dist = .5*length(fromCam);
        vec2 dir = normalize(fromCam);

        float radialAmount = .8 * clamp(1. - dist*2.*u_bgRes/u_screenRes, 0., 1.);
        float angleAmount = dot(dir, 2.*normalMapLookup.xy-1.);

        vec3 color = vec3(.1,1,0) * angleAmount * radialAmount * radialAmount;

        gl_FragColor = vec4(color, normalMapLookup.a);
    }

#endif