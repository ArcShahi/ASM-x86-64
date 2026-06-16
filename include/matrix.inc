%ifndef MATRIX_INC
%define MATRIX_INC 

; Make them visible to linker  
global mat4x4_add
global mat4x4_mul_mat4x1 
global mat4x4_mul_mat4x4
global mat4x4_scale

;Export symbol for linker to include in lib and dll
export mat4x4_add
export mat4x4_mul_mat4x4
export mat4x4_mul_mat4x1
export mat4x4_scale

%endif
