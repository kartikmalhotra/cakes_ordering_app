import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:foodeasecakes/main.dart';

class Utils {
  static showFailureToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }

  static Future<void> showSuccessToast(message, {Toast? toastLength}) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }

  static String utf8convert(String text) {
    try {
      List<int> bytes = text.toString().codeUnits;
      return utf8.decode(bytes);
    } catch (exe) {
      return text;
    }
  }

  static showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'X',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void copyMessageClipboard({String? message}) async {
    if (message != null) {
      Clipboard.setData(ClipboardData(text: message));
    }
    await Utils.showSuccessToast(
        "Your message is copied to clipboard, Long press to paste it");
  }

  static Future<String?>? downloadVideoFile(String videoUrl) async {
    try {
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      var documentDirectory = await getTemporaryDirectory();
      String fileName = videoUrl.split('/').last;
      var filePathAndName = documentDirectory.path + '/' + fileName;

      await Dio().download(videoUrl, filePathAndName,
          onReceiveProgress: (received, total) {
        // if (total != -1) {
        print((received / total * 100).toStringAsFixed(0) + "%");
        // }
      });

      return filePathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  // static Future<String?>? convertVideoFromHorizontalToVertical(
  //     String videoLocalUrl) async {
  //   try {
  //     var tempDirectory = await getTemporaryDirectory();
  //     String newName = DateTime.now().microsecondsSinceEpoch.toString();
  //     var newPathAndName = tempDirectory.path + '/' + newName + ".mp4";
  //     File file = File(newPathAndName);

  //     await FFmpegKit.execute(
  //             "-i $videoLocalUrl -lavfi [0:v]scale=1920*2:1080*2,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[0:v]scale=-1:1080[ov];[bg][ov]overlay=(W-w)/2:(H-h)/2,crop=w=1920:h=1080 ${file.path}")
  //         .then((session) async {
  //       final returnCode = await session.getReturnCode();
  //       print(await session.getAllLogsAsString());
  //       final output = await session.getOutput();
  //       print("Outputs" + output!);

  //       // The list of logs generated for this execution
  //       final logs = await session.getLogs();
  //       print("Logs" + logs.first.toString());

  //       // The list of statistics generated for this execution (only available on FFmpegSession)
  //       final statistics = await (session).getStatistics();
  //       print("Statistics" + statistics.toString());
  //       if (ReturnCode.isSuccess(returnCode)) {
  //         // SUCCESS

  //       } else if (ReturnCode.isCancel(returnCode)) {
  //         // CANCEL

  //       } else {}
  //     });

  //     return newPathAndName;
  //   } on DioError catch (e) {
  //     print(e.message);
  //   }
  //   return null;
  // }

  static Future<void> showToastMessageDialog(String message) async {
    await showDialog(
      context: App.globalContext,
      builder: (context) {
        return AlertDialog(
          content: Text(message,
              style: Theme.of(App.globalContext)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
    return;
  }

  /// Converting Gif2Video
//   static Future<String?>? convertGIFToVideoFile(String videoUrl) async {
//     try {
// //path of the gif file.
//       // final String outputFile = videoUrl.replaceRange(videoUrl.length - 3,
//       //     videoUrl.length, "mp4"); //path to export the mp4 file.

//       /// Download GIF
//       var tempDirectory = await getTemporaryDirectory();
//       String newName = DateTime.now().microsecondsSinceEpoch.toString();
//       var filePathAndName = tempDirectory.path + '/' + newName + ".mp4";

//       await Dio().download(videoUrl, filePathAndName,
//           onReceiveProgress: (received, total) {});

//       //  Convert GIF to video
//       var newPathAndName = tempDirectory.path +
//           '/' +
//           DateTime.now().microsecondsSinceEpoch.toString() +
//           ".mp4";
//       await FFmpegKit.execute("-f gif -i $filePathAndName $newPathAndName")
//           .whenComplete(() => print("Gif converted to video"));

//       return newPathAndName;
//     } on DioError catch (e) {
//       print(e.message);
//     }
//     return null;
//   }

  static Future<String?>? downloadImageFile(String imageUrl,
      {String? path}) async {
    try {
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      var documentDirectory = await getTemporaryDirectory();
      String fileName = imageUrl.split('/').last;
      String? filePathAndName;
      if (path != null) {
        filePathAndName = path;
      } else {
        filePathAndName = documentDirectory.path + '/' + fileName;
      }

      await Dio().download(imageUrl, filePathAndName,
          onReceiveProgress: (received, total) {
        // if (total != -1) {
        //   print((received / total * 100).toStringAsFixed(0) + "%");
        // }
      });

      return filePathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static Future<File?> downloadPDFFile(String url) async {
    try {
      Response response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      String? storagePath;
      if (Platform.isIOS) {
        storagePath = (await getApplicationDocumentsDirectory()).path;
      } else {
        storagePath = (await getExternalStorageDirectory())!.path;
      }
      print(storagePath + "/" + url.split("/").last);
      File file = File(storagePath + "/" + url.split("/").last);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<String?>? downloadPdfFile(String pdfUrl) async {
    try {
      if (await Permission.storage.request().isGranted) {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Granted");
        }
      } else {
        if (kDebugMode) {
          print("MANAGE_EXTERNAL_STORAGE Not Granted");
        }
      }
      String directoryPath;
      if (Platform.isIOS) {
        directoryPath = (await getApplicationDocumentsDirectory()).path;
      } else {
        directoryPath = (await getExternalStorageDirectory())!.path;
      }
      String fileName = pdfUrl.split('/').last;
      String? filePathAndName;
      filePathAndName = directoryPath + "/" + fileName;
      print(filePathAndName);

      // Uint8List data = Uint8List.fromList(pdfUrl.data);
      // await FileSaver.instance
      //     .saveFile(pdfUrl, Uint8List, pdfUrl.split(".").last);
      await Dio().download(pdfUrl, filePathAndName,
          onReceiveProgress: (received, total) {
        // if (total != -1) {
        //   print((received / total * 100).toStringAsFixed(0) + "%");
        // }
      }).whenComplete(() => print("Files downloaded"));

      return filePathAndName;
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  static List<String?> extractHashtags(String text) {
    Iterable<Match> matches = RegExp(r"\B(\#[a-zA-Z]+\b)").allMatches(text);
    return matches.map((m) => m[0]).toList();
  }

  // static void navigateToPage(RemoteMessage? message,
  //     {bool openedFromTerminatedState = false}) {
  //   print("Notification post type is ${message?.data["post_type"]}");
  // }

  static bool checkSelected(
      String id, String type, List<Map<String, dynamic>> accountsMetadata) {
    for (int i = 0; i < accountsMetadata.length; i++) {
      if (accountsMetadata[i]["accountId"] == id) {
        if (type == "storyReminder" &&
            (accountsMetadata[i]["storyReminder"] ?? false)) {
          return true;
        }

        if (type == "reelReminder" &&
            (accountsMetadata[i]["reelReminder"] ?? false)) {
          return true;
        }
        if (type == "carouselReminder" &&
            (accountsMetadata[i]["carouselReminder"] ?? false)) {
          return true;
        }
        if (type == "personalTimelineReminder" &&
            (accountsMetadata[i]["personalTimelineReminder"] ?? false)) {
          return true;
        }
        if (type == "nonAdminGroupsReminder" &&
            (accountsMetadata[i]["nonAdminGroupsReminder"] ?? false)) {
          return true;
        }
        if (type == "feedReminder" &&
            (accountsMetadata[i]["feedReminder"] ?? false)) {
          return true;
        }
        if (type == "autoFeed" && (accountsMetadata[i]["autoFeed"] ?? false)) {
          if ((accountsMetadata[i]["autoCarousel"] ?? false) ||
              (accountsMetadata[i]["autoReel"] ?? false)) {
            Utils.showSuccessToast(
                "You can only post to one instagram post at a time");
          }

          accountsMetadata[i]["autoCarousel"] = false;
          accountsMetadata[i]["autoReel"] = false;

          return true;
        }
        if (type == "autoReel" && (accountsMetadata[i]["autoReel"] ?? false)) {
          if ((accountsMetadata[i]["autoFeed"] ?? false) ||
              (accountsMetadata[i]["autoCarousel"] ?? false)) {
            Utils.showSuccessToast(
                "You can only post to one instagram post at a time");
          }
          accountsMetadata[i]["autoFeed"] = false;
          accountsMetadata[i]["autoCarousel"] = false;
          return true;
        }
        if (type == "autoCarousel" &&
            (accountsMetadata[i]["autoCarousel"] ?? false)) {
          accountsMetadata[i]["autoFeed"] = false;
          if ((accountsMetadata[i]["autoReel"] ?? false) ||
              (accountsMetadata[i]["autoFeed"] ?? false)) {
            Utils.showSuccessToast(
                "You can only post to one instagram post at a time");
          }
          accountsMetadata[i]["autoFeed"] = false;
          accountsMetadata[i]["autoReel"] = false;
          return true;
        }
      }
    }
    return false;
  }

  // static Future<String?> mergeIntoVideo(List<String> imagePath) async {
  //   dynamic limit = 10;

  //   String savedFilePath = "";

  //   if (Platform.isAndroid) {
  //     savedFilePath = (await getTemporaryDirectory()).path;
  //   } else {
  //     savedFilePath = (await getLibraryDirectory()).path;
  //   }
  //   //  Convert GIF to video
  //   savedFilePath = '${savedFilePath}/out.mp4';

  //   final MediaInformationSession mediaInformation =
  //       await FFprobeKit.getMediaInformation(imagePath.first.toString());
  //   final MediaInformation? mp = mediaInformation.getMediaInformation();

  //   var documentDirectory = await getTemporaryDirectory();

  //   String filePathAndName = (documentDirectory.path ?? "") + '/' + "*.jpg";

  //   try {
  //     await FFmpegKit.execute(
  //             "-i ${filePathAndName} -c:v libx264 -pix_fmt yuv420p ${savedFilePath}")
  //         .then((result) {
  //       return File(savedFilePath).path;
  //     }, onError: (error) {
  //       print("Error" + error);
  //     }).whenComplete(() => print("Gif converted to video"));

  //     return File(savedFilePath).path;

  //     /// To combine audio with video
  //   } catch (exe) {
  //     return null;
  //   }
  // }

  static bool validateLink(String message) {
    RegExp exp = RegExp(
        r'^(http(s):\/\/.)[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)$');
    Iterable<RegExpMatch> matches = exp.allMatches(message);
    if (matches.isNotEmpty) {
      return true;
    }
    return false;
  }

  // static MediaType? getMediaType(String imagePath) {
  //   if (imagePath.isNotEmpty && imagePath.length > 4) {
  //     String extension =
  //         imagePath.substring(imagePath.length - 4, imagePath.length);
  //     if (extension.contains("jpeg") ||
  //         extension.contains("jpg") ||
  //         extension.contains("png")) {
  //       return MediaType.Image;
  //     } else if (extension.contains("gif")) {
  //       return MediaType.Gif;
  //     } else if (extension.contains("webp") || extension.contains("mp4")) {
  //       return MediaType.Video;
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // static SocialMedia? getSocialMedia(String imagePath) {
  //   if (imagePath.isNotEmpty && imagePath.length > 4) {
  //     String extension =
  //         imagePath.substring(imagePath.length - 4, imagePath.length);
  //     if (extension.contains("jpeg") ||
  //         extension.contains("jpg") ||
  //         extension.contains("png")) {
  //       return MediaType.Image;
  //     } else if (extension.contains("gif")) {
  //       return MediaType.Gif;
  //     } else if (extension.contains("webp") || extension.contains("mp4")) {
  //       return MediaType.Video;
  //     } else {
  //       return null;
  //     }
  //   }
  // }
}
