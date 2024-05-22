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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SongPage()));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('P L A Y L I S T')),
      ),
      drawer: const MyDrawer(),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 33,top: 20,bottom: 10,right: 73),
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).colorScheme.inversePrimary)
            ),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search in Library',
                icon: Icon(Icons.search)
              ),
            ),
          ),

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
