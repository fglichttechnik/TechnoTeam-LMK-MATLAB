In analogy to the color factors in labSoft (see screenshot_colorfactors.jpg), the LMK GUI uses the 
following matrix and factors for filter correction. The last line of the matrix is used to calculate
the scotopic luminance of the image.


X1X2ZVVs = 

       [0.056618 	1.0718 		-0.0097523 	0.0074725 	0;...
    	0.0030606 	-0.060261 	-0.0034014 	1.0874 		0;...
    	0.19087 	0.011688 	0.14489 	-0.0094411 	0;...
    	0.0030606 	-0.060261 	-0.0034014 	1.0874 		0;...
    	0 		0 		0 		0 		1];

f1_l = 0.9704;	f2_x = 0.9742;
		f2_y = 0.9704;
		f2_z = 0.9629;   
f1_ls = 0,9704;



