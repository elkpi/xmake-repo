package("joker")
    set_homepage("https://code.elkpi.com/cpputil/joker")

    add_urls("https://code.elkpi.com/cpputil/joker.git")

    add_versions("0.0.1", "9f8adaac6fb444f6a00ecb09731e9c3c245451b4")

    on_install(function (package)
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)

    end)
