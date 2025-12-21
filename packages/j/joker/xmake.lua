package("joker")
    set_homepage("https://code.elkpi.com/cpputil/joker")

    add_urls("https://code.elkpi.com/cpputil/joker.git")

    add_versions("0.0.1", "9f8adaac6fb444f6a00ecb09731e9c3c245451b4")
    add_versions("0.0.2", "d927a03b9ab60dc629503e141d55e10ad937a0c0")

    on_install(function (package)
        import("package.tools.xmake").install(package)
        os.cp("include/joker", package:installdir("include"))
    end)

    on_test(function (package)

    end)
