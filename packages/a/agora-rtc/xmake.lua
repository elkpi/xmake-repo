package("agora-rtc")
    set_kind("library")
    set_homepage("https://doc.shengwang.cn/doc/rtc-server-sdk/cpp/resources")


    if is_host("linux") then
        if is_arch("arm64") then
            add_urls("https://download.agora.io/rtsasdk/release/Agora-RTC-aarch64-linux-gnu-$(version).tgz", {version = function (version)
                if version:ge("v4.4.32") then
                    return version .. "-20250425_150503-675674"
                end
            end,
            filename = "Agora-RTC-aarch64-linux-gnu.tgz"})
            add_versions("v4.4.32", "4186434bd841124d4975abc7b1cd09c938b1bb8ce66b1c7f9f9ada576eb5a91d")
        else
            add_urls("https://download.agora.io/rtsasdk/release/Agora-RTC-x86_64-linux-gnu-$(version).tgz", {version = function (version)
                if version:ge("v4.4.32") then
                    return version .. "-20250425_144419-675648"
                end
            end, filename = "Agora-RTC-x86_64-linux-gnu.tgz"})
            add_versions("v4.4.32", "9a71c4a5d6fca717e0cdb0bb407086b266466977d10c987ff7d6ba0e3fc14f38")
        end
    end

    on_install(function (package)
        local lib_dir = path.join(package:installdir(), "lib")
        os.mkdir(lib_dir)
        os.cp("agora_sdk/include", package:installdir())
        os.cp("agora_sdk/*.so", lib_dir)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
#include "AgoraBase.h"
#include "IAgoraService.h"
#include "NGIAgoraAudioTrack.h"
#include "NGIAgoraLocalUser.h"
#include "NGIAgoraMediaNode.h"
#include "NGIAgoraMediaNodeFactory.h"
#include "NGIAgoraRtcConnection.h"

void test() {
    int32_t build_num = 0;

    getAgoraSdkVersion(&build_num);
}
        ]]}, {configs = {languages = "cxx11"}}))
    end)
