import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/pages/device_songs/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DevicePlaylist extends StatefulWidget {
  const DevicePlaylist({Key? key}) : super(key: key);

  @override
  State<DevicePlaylist> createState() => _DevicePlaylistState();
}

class _DevicePlaylistState extends State<DevicePlaylist> {

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    // (Optinal) Set logging level. By default will be set to 'WARN'.
    //
    // Log will appear on:
    //  * XCode: Debug Console
    //  * VsCode: Debug Console
    //  * Android Studio: Debug and Logcat Console
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
          // Default values:
          future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            // Display error, if any.
            if (item.hasError) {
              return Text(item.error.toString());
            }

            // Waiting content.
            if (item.data == null) {
              return const CircularProgressIndicator();
            }

            // 'Library' is empty.
            if (item.data!.isEmpty) return const Text("Nothing found!");

            // You can use [item.data!] direct or you can create a:
            // List<SongModel> songs = item.data!;
            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)
                        =>NowPlaying(
                            songModel: item.data![index],
                            audioPlayer: audioPlayer,
                        ))
                    );
                    // =>playSong(item.data![index].uri),

                  },
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  // This Widget will query/load image.
                  // You can use/create your own widget/method using [queryArtwork].
                  leading: QueryArtworkWidget(
                    controller: _audioQuery,
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }


}
