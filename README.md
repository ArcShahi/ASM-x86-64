# ASM-x86-64

This repo. is a sandbox. It contains implementation of mathematical formulas and alogrithms. It uses NASM syntax , follows x64(Windows) ABI , for Intel & AMD chips.

**Implemented almost every function we'll need to create a standalone linear algebra library**.
It's basically a reference for me or other people.


It'll be updated when I feel like writing something in Assembly. I've also added SIMD operations. Learning SIMD is fun, but there's not a single place to learn it. You'll have to become an adventurer to learning it collecting knowledge bit by bit. The goal is to have fun writing assembly and possibly benchmark it against popular libraries.


The SIMD instruction use `AVX2` instruction set which will work with both Intel and AMD CPUs just fine.

I use my custom [PowerShell script](https://gist.github.com/ArcShahi/eb3bbc0568130a1519e604e476ec13b6) to Assemble and link or create a `.lib`.  Trust me we'll need it.


>[!error] Fun only...
> Use : BLAS, Intel MKL, Eigen, GLM, Direct X Maths libraries for anything serious.


## Usage

**Use it only if your learning or testing assembly**.
```cpp
// Include a header with function defintions
extern "C" Vec3_add(Vec3* dest,Vec3* u,Vec3* v);
// ... and so one 

// use it 

Vec3 v{3.0f,6.9f,4.20f};
Vec3 u{1.0f,11.f,111.f};
Vec3 res{};

Vec3_add(&res,&u,&v);

````



## TODO :
- Matrix operations
- Testing 
- Benchmarking against `glm`
- Quaternion operations


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


----


