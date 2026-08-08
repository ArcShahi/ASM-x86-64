%ifndef MATRIX_INC
%define MATRIX_INC 

; Make them visible to linker 

global mat3x3_add
global mat3x3_mul_mat3x3
global mat3x3_mul_vec3
global mat3x3_scale

global mat4x4_add
global mat4x4_mul_vec4
global mat4x4_mul_mat4x4
global mat4x4_scale

;Export symbol for linker to include in symbol export table

export mat3x3_add
export mat3x3_mul_mat3x3
export mat3x3_mul_vec3
exprot mat3x3_scale 

export mat4x4_add
export mat4x4_mul_mat4x4
export mat4x4_mul_mat4x1
export mat4x4_scale

%endif
