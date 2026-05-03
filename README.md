# ASM-x86-64

This repo. is a stepping stone for me in  the way of learning SIMD and insintrics.  

It contains simple Assembly programs written using NASM. It follows Windows ABI and works on Intel and AMD chips. 
It's basically a reference for me or other people.

It'll be updated when I feel like writing something in Assembly. Soon enough I'll add SIMD instructions.


I use my [custom PowerShell script](https://gist.github.com/ArcShahi/eb3bbc0568130a1519e604e476ec13b6) to Assembly and link. Trust me we'll need it. It's not that sophisticated yet, but it'll do for now. Add it environment path to call it from anywhere.

See help on how to use it , it's simple.

```powershell
# You'll see complete help description ( Use PowerShell )
help neko
# See example usage
help neko -Examples
```


### Questions ?


1. Why not use Syscall for IO ? 
    
    Have you seen Windows syscall procedure ? No thanks.. I'll stick with CRT for now. 
2. Why not use `rpb` as frame pointer ? 
    
    Compilers in optimized build don't use `rbp` as frame pointer anymore. MSVC compiler may use `R13` but I think only when `_malloca` is used.
3. Why learn Assembly this day and age ? 

    Because I CAN. 
4. Can It run faster than High level languages tho? 

    Hell no. 
5. Any recommendation , issues question ? 

    Create an issue...I've nothing better to do all day anyways.



## References : 

- [Creel](https://www.youtube.com/@WhatsACreel) : I wouldn't have started Assembly if I didn't find his YouTube videos. Awesome videos for introduction to Assembly language and his Australian accent and humour makes his videos very fun to watch.
- Intel software developer manuals for serious stuff : https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
- For quick Instruction references. It's exremelly helpful : https://www.felixcloutier.com/x86/
- Windows ABI Docs. Bit weird things there but can't write Windows assembly without it: https://learn.microsoft.com/en-us/cpp/build/x64-software-conventions?view=msvc-170 
- [Compiler Explorer](https://godbolt.org/) by Matt Godbolt.Compiler explorer is I think all you need after learning basics of Assembly to learn further Assembly. Just look at how different compilers do stuff at different level of optimization.




