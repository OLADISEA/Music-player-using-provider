import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  final SongModel songModel;
  final AudioPlayer audioPlayer;
  const NowPlaying({super.key, required this.songModel, required this.audioPlayer});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;

  @override
  initState(){
    super.initState();
    playSong(widget.songModel.uri);
  }

  playSong(String? uri){
    try{
      widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      widget.audioPlayer.play();
      isPlaying = true;
    }on Exception{
      log('Error passing song');
    }
  }
  @override
  Widget build(BuildContext context) {

    String formatTime(Duration duration){
      String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
      return formattedTime;
    }
    widget.audioPlayer.durationStream.listen((d) {
      duration = d!;
    });

    widget.audioPlayer.positionStream.listen((p) {
      position = p;
    });

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        body: SafeArea(

          child: Padding(
              padding: EdgeInsets.only(left: 25,right: 25,bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon:Icon(Icons.arrow_back),
                        onPressed: () =>Navigator.pop(context),),

                      Text('P L A Y L I S T'),

                      // menu button
                      IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.menu))
                    ],
                  ),
                  const SizedBox(height: 25,),

                  //album network
                  NeuBox(
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: QueryArtworkWidget(
                                //controller: _audioQuery,
                                id: widget.songModel.id,
                                type: ArtworkType.AUDIO,
                              ),
                          ),

                          // song and artist name and icon

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                // song and artist name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.songModel.displayNameWOExt,
                                      style:  const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),),
                                    Text(widget.songModel.artist??'Unknown Artist'),

                                    //favorite icon
                                    Icon(Icons.favorite,color: Colors.red,)
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ),

                  // song duration progress

                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            //shuffle icon
                            const Icon(Icons.shuffle),

                            //loop icon
                            const Icon(Icons.repeat),

                            //repeat icon
                            IconButton(
                                onPressed: (){
                                  //Provider.of<PlaylistProvider>(context,listen: false).toggleLoopMode();
                                },
                                icon: Icon(Icons.loop,color :Theme.of(context).colorScheme.inversePrimary
                                  ,)
                            ),


                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //start time
                            Text(formatTime(position)),

                            //end time
                            Text(formatTime(duration))
                          ],
                        ),
                      ),

                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0)
                        ),
                        child: Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (double double){
                            setState(() {

                            });
                            // duration when the user is sliding around
                          },
                          onChangeEnd: (double double){
                            //sliding has finished, go to that position in song duration
                            widget.audioPlayer.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),

                  //play back control
                  Row(
                    children: [
                      // skip previous
                      Expanded(
                        child: GestureDetector(
                          onTap: null,
                          child: const NeuBox(child: Icon(Icons.skip_previous),),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              if(isPlaying){
                                widget.audioPlayer.pause();
                              }else{
                                widget.audioPlayer.play();
                              }
                              isPlaying = !isPlaying;
                            });
                          },
                          child: NeuBox(child: Icon(isPlaying? Icons.pause: Icons.play_arrow),),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: GestureDetector(
                          onTap: null,
                          child: NeuBox(child: Icon(Icons.skip_next),),
                        ),
                      )
                    ],
                  )

                ],
              )


            // song duration progress



            //playback controls

          ),
        ),
      );


  }
}
