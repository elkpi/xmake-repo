package("libdispatch")

    set_homepage("https://apple.github.io/swift-corelibs-libdispatch/")
    set_description("Grand Central Dispatch (GCD or libdispatch) provides comprehensive support for concurrent code execution on multicore hardware.")
    set_license("Apache-2.0")

    add_urls("https://github.com/apple/swift-corelibs-libdispatch.git", {alias = "github"})

    add_versions("github:swift-5.5.3-RELEASE", "5cc1c6679822fd18368664482a5bba57270467f4")

    add_deps("cmake")

    on_load("windows", "linux", "macosx", function (package)
    end)

    on_install("windows", "linux", "macosx", function (package)
        local configs = {"-DBUILD_TESTING=OFF", "-DCMAKE_C_COMPILER=clang", "-DCMAKE_CXX_COMPILER=clang++"}
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        -- assert(package:has_cincludes({"dispatch/dispatch.h"}))
        -- assert(package:has_cxxincludes({"dispatch/dispatch.h"}))
    end)
