package("libtpl")
    set_homepage("https://github.com/troydhanson/tpl")
    set_description("C library for serialization and IPC")

    add_urls("https://github.com/troydhanson/tpl/archive/refs/tags/v$(version).tar.gz")

    add_versions("1.6.1", "0b3750bf62f56be4c42f83c89d8449b24f1c5f1605a104801d70f2f3c06fb2ff")

    add_includedirs("include")
    add_links("tpl")
    add_deps("autoconf", "automake", "libtool")

    on_install(function (package)
        os.mkdir("config")
        os.vrun("sh ./bootstrap")

        local configs = {
            "--enable-shared=" .. (package:config("shared") and "yes" or "no"),
            "--enable-static=" .. (package:config("shared") and "no" or "yes")
        }
        import("package.tools.autoconf").install(package, configs)

        local pkgconfigdir = path.join(package:installdir(), "lib", "pkgconfig")
        os.mkdir(pkgconfigdir)
        io.writefile(path.join(pkgconfigdir, "libtpl.pc"), [[prefix=${pcfiledir}/../..
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: libtpl
Description: C library for serialization and IPC
Version: 1.6.1
Libs: -L${libdir} -ltpl
Cflags: -I${includedir}
]])
    end)

    on_test(function (package)
        assert(package:has_cfuncs("tpl_map", {includes = "tpl.h"}))
    end)
