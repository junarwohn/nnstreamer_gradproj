gst-launch-1.0 -v \
   filesrc location=data/test.png ! decodebin ! videoconvert ! videoscale ! imagefreeze !\
   video/x-raw,format=RGB,width=257,height=257,framerate=10/1 ! tee name=t \
   t. ! queue ! mix. \
   t. ! queue ! tensor_converter !\
   tensor_transform mode=arithmetic option=typecast:float32,add:0.0,div:255.0 !\
   tensor_filter framework=pytorch model=data/unet_210623.pth !\
   tensor_decoder mode=image_segment option1=snpe-depth ! mix. \
   videomixer name=mix sink_0::alpha=0.7 sink_1::alpha=0.6 ! videoconvert !  videoscale ! autovideosink \
