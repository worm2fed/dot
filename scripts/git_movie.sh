#!/bin/bash
gource \
	--camera-mode overview  \
	--seconds-per-day 0.5 \
	--hide mouse,progress \
	--highlight-all-users \
	-1280x720 \
	-o gource.ppm &&
ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i gource.ppm -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 4 -bf 0 gource.mp4
