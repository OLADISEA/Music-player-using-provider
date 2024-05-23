import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:provider/provider.dart';

import '../../components/my_drawer.dart';
import '../../models/song.dart';

class AppPlaylist extends StatefulWidget {
  const AppPlaylist({Key? key}) : super(key: key);

  @override
  State<AppPlaylist> createState() => _AppPlaylistState();
}

class _AppPlaylistState extends State<AppPlaylist> {
  late final dynamic playlistProvider;
  @override
  void initState() {
    super.initState();

    //get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context,listen: false);
  }

  void goToSong(int songIndex){
    playlistProvider.currentSongIndex = songIndex;
    
    // NAVIGATE TO THE SONG PAGE
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SongPage()));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<PlaylistProvider>(
                builder: (context, value, child) {
                  final List<Song> playlist = value.playlist;
                  return ListView.builder(
                      itemCount: playlist.length,
                      itemBuilder: (context,index){
                        final Song song = playlist[index];
                        return Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              )
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(song.songName),
                                subtitle: Text(song.artistName),
                                leading: Image.asset(song.albumArtImagePath,width: 50,),
                                trailing: const Icon(Icons.more_vert),
                                onTap: () => goToSong(index),
                              ),
                              Divider(
                                indent: 17,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            ],
                          ),
                        );
                      }
                  );
                }
            ),
          ),
        ],

      ),
    );
  }
}
