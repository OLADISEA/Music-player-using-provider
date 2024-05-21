import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:provider/provider.dart';

import '../components/my_drawer.dart';
import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic playlistProvider;
  @override
  void initState() {
    super.initState();

    //get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context,listen: false);
  }

  void goToSong(int songIndex){
    playlistProvider.currentSongIndex =  songIndex;
    
    // NAVIGATE TO THE SONG PAGE
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongPage()));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P L A Y L I S T'),
      ),
      drawer: MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;
            return ListView.builder(
              itemCount: playlist.length,
              itemBuilder: (context,index){
                final Song song = playlist[index];
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumArtImagePath,width: 50,),
                onTap: () => goToSong(index),
              );
              }
            );
        }
      ),
    );
  }
}
