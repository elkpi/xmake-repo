package("cpp-bundler")
    set_kind("binary")

    add_urls("git@code.elkpi.com:inf/cpp-bundler.git")

    on_install(function (package)
        import("core.base.option")
        os.vrunv("sh", {"./build.sh"})
        os.cp(path.join("output", "cpp-bundler"), package:installdir("bin"))
    end)

    on_test(function (package)
        os.vrun("cpp-bundler -h")
    end)
