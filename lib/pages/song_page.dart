import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String formatTime(Duration duration){
      String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
      return formattedTime;
    }
    return Consumer<PlaylistProvider>(builder: (context, value, child){
      final playList = value.playlist;
      final currentSong = playList[value.currentSongIndex??0];
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
                            child: Image.asset(currentSong.albumArtImagePath)
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
                                  Text(currentSong.songName,
                                  style:  const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),),
                                  Text(currentSong.artistName),

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
                                    Provider.of<PlaylistProvider>(context,listen: false).toggleLoopMode();
                                  },
                                    icon: Icon(Icons.loop,color: value.isLoopMode
                                        ? Colors.green
                                        :Theme.of(context).colorScheme.inversePrimary
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
                          Text(formatTime(value.currentDuration)),

                          //end time
                          Text(formatTime(value.totalDuration))
                        ],
                      ),
                    ),

                    SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0)
                        ),
                        child: Slider(
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: value.currentDuration.inSeconds.toDouble(),
                            activeColor: Colors.green,
                            onChanged: (double double){
                              // duration when the user is sliding around
                            },
                            onChangeEnd: (double double){
                              //sliding has finished, go to that position in song duration
                              value.seek(Duration(seconds: double.toInt()));
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
                        onTap: value.playPreviousSong,
                        child: const NeuBox(child: Icon(Icons.skip_previous),),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: value.pauseOrResume,
                        child: NeuBox(child: Icon(value.isPlaying? Icons.pause: Icons.play_arrow),),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playNextSong,
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

    });
  }
}
