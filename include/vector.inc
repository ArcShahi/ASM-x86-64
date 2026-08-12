%ifndef VECTOR_INC
%define VECTOR_INC

; Make them visisble to linker
global vec3_add
global vec4_add 
global vec3_normalize
global vec3_reflect
global vec3_refract
global vec3_sub
global vec4_sub
global vec3_scale 
global vec4_scale 
global vec3_dot 
global vec4_dot
global cross_product

; Tell linker to include it into symbol export table
export vec3_add
export vec3_scale
export vec3_normalize
export vec3_reflect
export vec3_refract
export vec3_sub
export vec4_sub
export vec4_scale
export vec3_dot
export vec4_dot
export vec4_add
export cross_product

%endif 
