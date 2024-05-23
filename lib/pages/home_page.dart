import 'package:flutter/material.dart';
import 'package:music_player/pages/app_songs/app_playlist.dart';
import 'package:music_player/pages/device_songs/device_playlists.dart';

import '../components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Center(child: Text('P L A Y L I S T')),
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 53, top: 20, bottom: 10, right: 53),
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search in Library',
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.library_music), text: 'Device Playlists'),
                Tab(icon: Icon(Icons.playlist_play), text: 'App Playlists'),
                Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
                Tab(icon: Icon(Icons.download),text: 'Downloads',)

              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  // First tab content
                  DevicePlaylist(),
                  // Second tab content
                  AppPlaylist(),
                  // Third tab content
                  Center(child: Text('Favorites')),
                  //Fourth tab content
                  Center(child: Text('Downloads'),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
