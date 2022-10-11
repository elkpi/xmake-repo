package("pcre")

    set_homepage("https://www.pcre.org/")
    set_description("A Perl Compatible Regular Expressions Library")

    set_urls("https://github.com/xmake-mirror/pcre/releases/download/$(version)/pcre-$(version).tar.bz2", {alias = "xmake"})
    set_urls("https://sourceforge.net/projects/pcre/files/pcre/$(version)/pcre-$(version).tar.gz", {alias = "sf"})
    add_versions("xmake:8.45", "4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8")
    add_versions("sf:8.45", "4e6ce03e0336e8b4a3d6c2b70b1c5e18590a5673a98186da90d4f33c23defc09")
    add_versions("8.32", "d5d8634b36baf3d08be442a627001099583b397f456bc795304a013383b6423a")

    if is_plat("windows") then
        add_deps("cmake")
    end
    add_deps("zlib")

    add_configs("jit", {description = "Enable jit.", default = true, type = "boolean"})
    add_configs("bitwidth", {description = "Set the code unit width.", default = "8", values = {"8", "16", "32"}})

    on_load("windows", "mingw", function (package)
        if not package:config("shared") then
            package:add("defines", "PCRE_STATIC")
        end
    end)

    on_install("windows", function (package)
        local configs = {"-DPCRE_BUILD_TESTS=OFF"}
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        table.insert(configs, "-DPCRE_SUPPORT_JIT=" .. (package:config("jit") and "ON" or "OFF"))
        local bitwidth = package:config("bitwidth") or "8"
        if bitwidth ~= "8" then
            table.insert(configs, "-DPCRE_BUILD_PCRE8=OFF")
            table.insert(configs, "-DPCRE_BUILD_PCRE" .. bitwidth .. "=ON")
        end
        if package:debug() then
            table.insert(configs, "-DPCRE_DEBUG=ON")
        end
        import("package.tools.cmake").install(package, configs)
    end)

    on_install("macosx", "linux", "mingw", "cross", function (package)
        local configs = {}
        table.insert(configs, "--enable-shared=" .. (package:config("shared") and "yes" or "no"))
        table.insert(configs, "--enable-static=" .. (package:config("shared") and "no" or "yes"))
        if package:config("jit") then
            table.insert(configs, "--enable-jit")
        end
        local bitwidth = package:config("bitwidth") or "8"
        if bitwidth ~= "8" then
            table.insert(configs, "--disable-pcre8")
            table.insert(configs, "--enable-pcre" .. bitwidth)
        end
        if package:debug() then
            table.insert(configs, "--enable-debug")
        end
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        local bitwidth = package:config("bitwidth") or "8"
        local testfunc = string.format("pcre%s_compile", bitwidth ~= "8" and bitwidth or "")
        assert(package:has_cfuncs(testfunc, {includes = "pcre.h"}))
    end)
