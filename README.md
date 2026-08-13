# ASM-x86-64

**Assembly sandbox**: Implementation of mathematical formulas, alogrithms and other operations. It uses NASM , follows x64(Windows) ABI , runs on Intel & AMD chips.


## Features
- AVX2 SIMD Linear Algebra library
- AVX2 SIMD numerical calculation procedures
- IO Procedures
- Maths procedures
- String operations ( More in queue)

----


It'll get more and more sophisticated as I learn new things. It's also a reference for me and other people.


Learning SIMD is fun, but there's not a single place to learn it. You'll have to become an adventurer to learning it collecting knowledge bit by bit. The goal is to have fun writing assembly and possibly benchmark it against popular libraries.


The SIMD instruction use `AVX2` instruction set which will work with both Intel and AMD CPUs just fine.

I use my custom [PowerShell script](https://gist.github.com/ArcShahi/eb3bbc0568130a1519e604e476ec13b6) to Assemble and link to create an executable or library.



>[!IMPORTANT]
> NOT FOR PRODUCTION USE
>
> Use : BLAS, Intel MKL, Eigen, GLM, Direct X Maths libraries for anything serious.


## Usage of Linear Algebra library

**Use it only if you're learning or testing assembly**.


```cpp

// Create lib using my script and use it VS26 MSVC
// neko ".\simd\vector.asm" ,".\simd\matrix.asm", ".\simd\vec3_rotate.asm" -OutType dll -OutName "awsm"

#include <print>
#include <awsm.hpp> // only tested function

int main()
{

    awsm::vec3 res{};
    awsm::vec3 u{0.f,6.f,9.f};
    awsm::vec3 v{4.f,2.f,0.f};

    awsm::cross_product(res,u,v);
    std::println("x {} y {} z {}",res.x,res.y,res.z);

    std::println("Dot(u,v) = {}",awsm::vec3_dot(u,v));

    // Matrix Operation

    awsm::mat3 m1{};
    m.r0 = { 1.f, 2.f, 3.f };
    m.r1 = { 4.f, 5.f, 6.f };
    m.r2 = { 7.f, 8.f, 9.f };

    awsm::mat3 m2{
		{ 3.f, -2.f, 1.f },
		{ 6.f, -4.f, -1.f },
		{ 9.f, -6.f, 1.f }
	};

    awsm::mat3 ans{};

    awsm::mat3_add(ans,m1,m2);

    // See include/awsm.hpp for more available tested functions
}


````


## TODO :
- Benchmarking against `glm`
- Quaternions for transformation
- ~~Testing~~
- ~~Vector3 rotation (Tait-Bryan angles)~~


## Questions ?


1. Why not use Syscall for IO ? 
    
    Have you seen Windows syscall procedure ? No thanks.. I'll stick with CRT for now. 
2. Why not use `rpb` as frame pointer ? 
    
    Compilers in optimized build don't use `rbp` as frame pointer anymore. MSVC compiler may use `R13` but I think only when `_malloca` is used.
3. Why learn Assembly this day and age ? 

    Because I CAN. 
4. Can It run faster than High level languages tho? 

    Hell no. 
5. Any recommendation , issues or question ? 

    Create an issue...I've nothing better to do all day anyways.

----

## AI POLICY :

AI usage for code generation and documentation is forbidden for this project.
> Shahi (*prefers natural stupidity over artificial intelligence*)

----

## References : 

- [Creel](https://www.youtube.com/@WhatsACreel) : I wouldn't have started Assembly if I didn't find his YouTube videos. Awesome videos for introduction to Assembly language and his Australian accent and humour makes his videos very fun to watch.
- Intel software developer manuals for serious stuff : https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
- For quick Instruction references. It's exremelly helpful : https://www.felixcloutier.com/x86/
- Windows ABI Docs. Bit weird things there but can't write Windows assembly without it: https://learn.microsoft.com/en-us/cpp/build/x64-software-conventions?view=msvc-170 
- [Compiler Explorer](https://godbolt.org/) by Matt Godbolt.Compiler explorer is I think all you need after learning basics of Assembly to learn further Assembly. Just look at how different compilers do stuff at different level of optimization.
- [SIMD for C++ Dev](http://const.me/) by Konstantin . It's very short and sweet. It has very simple diagrams for awful...awful instruction such as shuffle, blend,broadcast.
- [Intel Intrinsics guide](https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html) It's very cool guide and it has pseudocode for instructions so it can be helpful most of the time. Use AVX Instruction set 


Thanks a lot guys ^_^


----


