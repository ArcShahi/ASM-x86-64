%ifndef MATRIX_INC
%define MATRIX_INC 

; Make them visible to linker 

global mat3_add
global mat3_mul
global mat3_mulv
global mat3_sub
global mat3_scale

global mat4_add
global mat4_mulv
global mat4_mul
global mat4_sub
global mat4_scale

;Export symbol for linker to include in symbol export table

export mat3_add
export mat3_mul
export mat3_mulv
export mat3_sub 
export mat3_scale 

export mat4_add
export mat4_mul
export mat4_mulv
export mat4_sub
export mat4_scale

%endif
