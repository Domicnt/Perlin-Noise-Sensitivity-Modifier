/*
noise
Version 1.0 (Saturday, April 22, 2017)
Created: Saturday, April 22, 2017
Author: tidbit
Credit: 
	https://rosettacode.org/wiki/Perlin_noise#Java
*/



; see noise()
; this functions adds depth/detail/grit to noise()
; x/y/z       = how much in that direction
; detail      = how much grit to add. ideally 1-8
; persistence = extra grit ontop of detail
; http://flafla2.github.io/2014/08/09/perlinnoise.html
noiseDetail(x, y:=0, z:=0, detail:=3, persistence:=0.5)
{
	total := 0
	frequency := 1 ; 1
	amplitude := 1 ; 1
	maxValue := 0 ;  Used for normalizing result to 0.0 - 1.0
	loop, %detail%
	{
		total += noise(x * frequency, y * frequency, z * frequency) * amplitude

		maxValue += amplitude

		amplitude *= persistence
		frequency *= 2
	}
	return total/maxValue
}

; noise()
; by: tidbit
; version 1.0 (Saturday, April 22, 2017)
; credit: 
;        https://rosettacode.org/wiki/Perlin_noise#Java
;        GeekDude - Optimization
; about: generate perlin noise. Basically a smoothed semi-random number. x/y/z values are **usually** in small increments (0.1 or so).
; returns: a value from -1.0 to 1.0
noise(x, y:=0, z:=0)
{
	static ppp := 0
	if (!ppp)
	{
		permutation:=[151,160,137,91,90,15
		, 131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23
		, 190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33
		, 88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166
		, 77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244
		, 102,143,54, 65,25,63,161, 1,216,80]
		permutation.push(73,209,76,132,187,208,89,18,169,200,196
		, 135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123
		, 5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42
		, 223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9
		, 129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228
		, 251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107
		, 49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254
		, 138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180)
		
		ppp:=[]
		for k in permutation
			ppp[k-1] := permutation[k]
			; ppp[256+k-1] := ppp[k-1] := permutation[k]
	}
	xx   := floor(x) & 255   ; FIND UNIT CUBE THAT
	, yy := floor(y) & 255   ; CONTAINS POINT.
	, ZZ := floor(z) & 255
	, x  -= floor(x)         ; FIND RELATIVE xx,yy,ZZ
	, y  -= floor(y)         ; OF POINT IN CUBE.
	, z  -= floor(z)
	, u  := fade(x)          ; COMPUTE FADE CURVES
	, v  := fade(y)          ; FOR EACH OF xx,yy,ZZ.
	, w  := fade(z)
	, A  := ppp[xx]+yy
	, AA := ppp[A]+ZZ
	, AB := ppp[A+1]+ZZ      ; HASH COORDINATES OF THE 8 CUBE CORNERS
	, B  := ppp[xx+1]+yy
	, BA := ppp[B]+ZZ
	, BB := ppp[B+1]+ZZ

	return lerp(w,lerp(v,lerp(u,grad(ppp[AA  ], x  , y  , z  )   ; AND ADD
	                          , grad(ppp[BA  ], x-1, y  , z  ))  ; BLENDED
	                  , lerp(u, grad(ppp[AB  ], x  , y-1, z  )   ; RESULTS
	                          , grad(ppp[BB  ], x-1, y-1, z  ))) ; FROM  8
	          , lerp(v, lerp(u, grad(ppp[AA+1], x  , y  , z-1)   ; CORNERS
	                          , grad(ppp[BA+1], x-1, y  , z-1))  ; OF CUBE
	                  , lerp(u, grad(ppp[AB+1], x  , y-1, z-1)
	                          , grad(ppp[BB+1], x-1, y-1, z-1))))
}

; ----- needed for noise() -----
fade(t) 
{
	return (t ** 3) * (t * (t * 6 - 15) + 10)
}
	
lerp(start, stop, amt)
{
	return stop + start * (amt - stop)
}

grad(hash, x, y, z)
{
	h := hash & 15 ; CONVERT LO 4 BITS OF HASH CODE
	u := (h<8) ? x : y
	v := (h<4) ? y : (h=12 || h=14) ? x : z
	return ((h & 1 = 0) ? u : -u) + ((h & 2 = 0) ? v : -v)
}
; ----------