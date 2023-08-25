#!/bin/bash
# vuquangtrong.github.io

# create a folder in shared memory
if [ -d "/dev/shm/streaming" ]; then
    echo ""
else
    mkdir -p /dev/shm/streaming
fi
# link it to current folder
if [[ -L streaming && -d $(readlink streaming) ]]; then
    echo ""
else
    ln -s /dev/shm/streaming streaming
fi

# create video segments for HLS and DASH
sudo ffmpeg -y \
    -input_format h264 -i /dev/video0 \
    -c:v copy \
    -f hls \
    -hls_time 1 \
    -hls_list_size 30 \
    -hls_flags delete_segments \
    /dev/shm/streaming/live.m3u8 &
    
python3 server.py
