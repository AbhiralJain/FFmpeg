import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/stream_information.dart';

class GetMediaInfo {
  getfileinfo(String path) async {
    int? height;
    int? width;
    String? orientation;
    String? duration;
    String? bitrate;
    String? frate;
    final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();
    await _flutterFFprobe.getMediaInformation(path).then((info) {
      if (info.getMediaProperties()!['filename'] != null) {
        path = info.getMediaProperties()!['filename'];
      }
      if (info.getMediaProperties()!['duration'] != null) {
        duration = info.getMediaProperties()!['duration'];
      }
      if (info.getMediaProperties()!['bit_rate'] != null) {
        bitrate = info.getMediaProperties()!['bit_rate'];
      }

      if (info.getStreams() != null) {
        List<StreamInformation>? streams = info.getStreams();

        if (streams!.isNotEmpty) {
          for (var stream in streams) {
            if (stream.getAllProperties()['width'] != null) {
              width = stream.getAllProperties()['width'];
            }
            if (stream.getAllProperties()['height'] != null) {
              height = stream.getAllProperties()['height'];
            }
            if (stream.getAllProperties()['bit_rate'] != null) {
              bitrate = stream.getAllProperties()['bit_rate'];
            }
            if (stream.getAllProperties()['r_frame_rate'] != '0/0') {
              frate = stream.getAllProperties()['r_frame_rate'];
            }
            if (stream.getAllProperties()['tags'] != null) {
              Map<dynamic, dynamic> tags = stream.getAllProperties()['tags'];
              tags.forEach((key, value) {
                if (key == 'rotate' && value == '90') {
                  orientation = '90';
                }
              });
            }
          }
        }
      }
    });
    orientation ??= '0';
    Map map = {
      'height': height,
      'width': width,
      'orientation': orientation,
      'duration': duration,
      'bitrate': bitrate,
      'framerate': frate,
    };
    return map;
  }
}
