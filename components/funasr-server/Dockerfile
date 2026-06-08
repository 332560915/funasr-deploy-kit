FROM registry.cn-hangzhou.aliyuncs.com/funasr_repo/funasr:funasr-runtime-sdk-cpu-0.4.7

RUN set -eux; \
    cd /workspace/FunASR/runtime/websocket; \
    cp bin/websocket-server.cpp bin/websocket-server.cpp.orig; \
    sed -i 's/jsonresult\["is_final"\] = false;/jsonresult["is_final"] = true;/g' bin/websocket-server.cpp; \
    grep -n 'jsonresult\["is_final"\]' bin/websocket-server.cpp; \
    cmake --build build --target funasr-wss-server -j"$(nproc)"
