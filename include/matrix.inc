%ifndef MATRIX_INC
%define MATRIX_INC 

; Make them visible to linker 

global mat3_add
global mat3_mul_mat3
global mat3_mul_vec3
global mat3_sub
global mat3_scale

global mat4_add
global mat4_mul_ve4
global mat4_mul_mat4
global mat4_sub
global mat4x4_scale

;Export symbol for linker to include in symbol export table

export mat3_add
export mat3_mul_mat3
export mat3_mul_vec3
export mat3_sub 
export mat3_scale 

export mat4_add
export mat4_mul_mat4
export mat4_mul_vec4
export mat4_sub
export mat4_scale

%endif
