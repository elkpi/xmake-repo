package("chromium_rnnoise")

    set_homepage("https://chromium.googlesource.com/chromium/src/third_party/+/refs/heads/main/rnnoise/")
    set_description("rnnoise from chromium")

    add_urls("https://code.elkpi.com/third_party/chromium_rnnoise.git")
    add_versions("2023.05.24", "e5507c00892a0935966a2f0c1dc66fa138361f49")

    add_configs("shared", {description = "Build shared library.", default = false, type = "boolean", readonly = true})

    if is_plat("linux") then
        add_syslinks("m")
    end

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), ".")
        import("package.tools.xmake").install(package)
        os.cp(path.join("src", "rnn_vad_weights.h"), package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:has_cxxincludes("rnn_vad_weights.h"))
    end)
