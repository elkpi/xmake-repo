set_project("rnnoise")

add_rules("mode.debug", "mode.release")

target("rnnoise")
    set_kind("static")
    add_files("src/rnn_vad_weights.cc")
    add_includedirs("src")

