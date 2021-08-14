gst-launch-1.0 -v \
    videomixer name=mix sink_0::alpha=1.0 sink_1::alpha=0.6 ! aspectratiocrop aspect-ratio=16/9 ! videoconvert ! autovideosink sync=false \
    filesrc location=dog.jpg ! decodebin ! videoconvert ! videoscale ! imagefreeze !\
    video/x-raw,format=RGB,width=256,height=256 ! tee name=t \
    t. ! queue ! mix. \
    t. ! queue ! tensor_converter !\
    tensor_transform mode=arithmetic option=typecast:float32,div:255.0 ! \
    tensor_filter framework=tensorflow2-lite model=data/unet.tflite ! \
    tensor_decoder mode=image_segment option1=tflite-deeplab ! mix.
