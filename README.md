# DJKeyObfuscation

Helps facilitate key obfuscation. 

Read the comments in the "work" function of DJKeyObfuscation.m to hopefully understand more of what this does.

# Using

1. Use the "printObfuscationSecretArray:" function to NSLog() what this array is supposed to be. Take this value and store it. This is a byte array of SHA(class name) XOR'ed with the secret key. (for obfuscation)
2. Delete any other string reference to your secret key.
3. When you need your key, call "keyFromArray:length:" with the stored byte array. This will convert the obfuscated byte array back into the key
4. Use the key, then discard.

# Recommended

It is recommended to also ass the following to your main.m function to disable debugging attacks

```
#import <dlfcn.h>
#import <sys/types.h>

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif  // !defined(PT_DENY_ATTACH)

void disable_gdb() {
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}

int main(int argc, char *argv[]) {
    #if !(DEBUG) // Don't interfere with Xcode debugging sessions.
        disable_gdb();
    #endif

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil,
            NSStringFromClass([MyAppDelegate class]));
    }
}
```

# Resources

Check out http://www.splinter.com.au/2014/09/16/storing-secret-keys/ for full description of proper obfuscation.
