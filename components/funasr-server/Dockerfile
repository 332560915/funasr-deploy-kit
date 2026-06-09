FROM registry.cn-hangzhou.aliyuncs.com/funasr_repo/funasr:funasr-runtime-sdk-cpu-0.4.7

COPY src/websocket-server.cpp /workspace/FunASR/runtime/websocket/bin/websocket-server.cpp

RUN set -eux; \
    cd /workspace/FunASR/runtime/websocket; \
    grep -n 'jsonresult\["is_final"\]' bin/websocket-server.cpp; \
    cmake --build build --target funasr-wss-server -j"$(nproc)"
