package("agora-dynamic-key")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/AgoraIO/Tools")
    set_license("MIT")

    add_urls("https://github.com/AgoraIO/Tools/archive/refs/tags/$(version).tar.gz",
             "https://github.com/AgoraIO/Tools.git")

    add_versions("2.0.4", "425ba1879fe4c5018bd97c75bf40761b9fdd39ce54d7f9967319d819cba7318d")

    add_patches("2.0.4", path.join(os.scriptdir(), "patches", "2.0.4.patch"), "7539e6f7bb57834d0a6e1fa12f7c479706a6517ed436abe47b06987448438a5c")

    add_deps("zlib", "openssl")

    on_install(function (package)
        local inc_dir = path.join(package:installdir(), "include")
        os.mkdir(inc_dir)
        os.cp("DynamicKey/AgoraDynamicKey/cpp/src/AccessToken.h", inc_dir)
        os.cp("DynamicKey/AgoraDynamicKey/cpp/src/utils.h", inc_dir)
        os.cp("DynamicKey/AgoraDynamicKey/cpp/src/Packer.h", inc_dir)
        os.cp("DynamicKey/AgoraDynamicKey/cpp/src/RtcTokenBuilder.h", inc_dir)
        os.cp("DynamicKey/AgoraDynamicKey/cpp/src/RtmTokenBuilder.h", inc_dir)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <RtcTokenBuilder.h>
            #include <RtmTokenBuilder.h>
        ]]}, {configs = {languages = "cxx11"}}))
    end)
