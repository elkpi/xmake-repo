package("vertc-sdk")
    set_kind("library")
    set_homepage("https://www.volcengine.com/docs/6348/75707")
    set_description("Volcengine Real Time Communication SDK")

    if is_host("linux") then
        add_urls("https://lf-unpkg.volccdn.com/obj/vcloudfe/sdk/VolcEngineRTC_Linux_Server/$(version)/1710147417130/VolcEngineRTC_Linux_x86_64_$(version).zip", {version = function (version)
            if version:ge("3.58.1") then
                return version .. ".200"
            end
        end,
        filename = "VolcEngineRTC_Linux_x86_64.zip"})
        add_versions("3.58.1", "d593a27e6f69165d7c397759d63bba618f7d83c379bb8c679654897eedced286")
    end

    on_install(function (package)
        os.cp("VolcEngineRTC_Linux_*/include", package:installdir())
        os.cp("VolcEngineRTC_Linux_*/lib", package:installdir())
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
#include <bytertc_video.h>
#include <byterts.h>
        ]]}, {configs = {languages = "cxx11"}}))
    end)
