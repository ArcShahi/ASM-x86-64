%ifndef VECTOR_INC
%define VECTOR_INC

; Make them visisble to linker
global Vec3_add
global Vec4_add 
global Vec3_reflect
global Vec3_scale 
global Vec4_scale 
global Vec3_dot 
global Vec4_dot
global cross_product

; Tell linker to include it into symbol export table
export Vec3_add
export Vec3_scale
export Vec3_reflect
export Vec4_scale
export Vec3_dot
export Vec4_dot
export Vec4_add
export cross_product

%endif 
