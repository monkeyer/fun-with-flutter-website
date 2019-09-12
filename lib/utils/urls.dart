import 'package:meta/meta.dart';

const blogTestingUrl = 'http://localhost:8000';
const blogProductionUrl = 'https://fun-with-blog.firebaseapp.com';

const funWithYouTubeUrl = 'https://www.youtube.com/funwithflutter';
const funWithGithubUrl = 'https://github.com/funwithflutter';

const PackageUrl waveSliderPackage = PackageUrl(
    pubUrl: 'https://pub.dev/packages/wave_slider',
    youtubeUrl:
        'https://www.youtube.com/playlist?list=PLjr4ufdmNA4J2-KwMutexAjjf_VmjL1eH');
const PackageUrl splashTapPackage = PackageUrl(
    pubUrl: 'https://pub.dev/packages/splash_tap',
    youtubeUrl: 'https://www.youtube.com/watch?v=7qkhpeZdD7U');

@immutable
class PackageUrl {
  const PackageUrl({this.pubUrl = '', this.youtubeUrl = ''})
      : assert(pubUrl != null && youtubeUrl != null);

  final String pubUrl;
  final String youtubeUrl;
}
