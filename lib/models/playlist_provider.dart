import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier{
  final List<Song> _playlist = [
    // 1st song
    Song(
        songName: 'ALL OF ME',
        artistName: 'John Legend',
        albumArtImagePath: 'assets/images/all_of_me.jpg',
        audioPath: 'audio/all of me.mp3'
    ),

    //2nd song

    Song(
        songName: 'Faded',
        artistName: 'Alan Walker',
        albumArtImagePath: 'assets/images/faded.jpg',
        audioPath: 'audio/faded.mp3'
    ),
    Song(
        songName: 'Faded',
        artistName: 'Alan Walker',
        albumArtImagePath: 'assets/images/faded.jpg',
        audioPath: 'audio/faded.mp3'
    ),
  ];

  //index of the current song playing
  int? _currentSongIndex;

  /*
  AUDIO PLAYER
   */
  //audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  //duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  //constructor
  PlaylistProvider(){
    listenToDuration();
  }
  //initially not playing
  bool _isPlaying = false;

  //play the song
  void play() async{
    final String path = _playlist[currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  //pause the current song
  void pause() async{
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();

  }



  // resume playing
  void resume() async{
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() async{
    if(_isPlaying){
      pause();
    }else{
      resume();
    }
    notifyListeners();
  }

  //seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play the next song
  void playNextSong(){
    if(_currentSongIndex != null){
      if(_currentSongIndex! < _playlist.length - 1){
        //go to the next song if the song is not the last one
        currentSongIndex = _currentSongIndex! +  1;

      }else{
        currentSongIndex = 0;
      }
    }
  }

  //play the previous song
  void playPreviousSong() async{
    // if more than two seconds have passed, restart the current song
    if(_currentDuration.inSeconds > 2){

    }
    //if it is within the first two seconds of the song go to the previous song
    else{
      if(currentSongIndex! > 0){
        currentSongIndex = currentSongIndex! - 1;
      }else{
        //if it is the first song, loop back to last song
        currentSongIndex = _playlist.length - 1;

      }
    }
  }

  //list to duration
  void listenToDuration(){
    //listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();

    });
    //listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose audio player
  /*
  G E T T E R S
   */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
  S E T T E R S
   */

  set currentSongIndex(int? newIndex){
    _currentSongIndex = newIndex;
    if(newIndex != null){
      play();
    }
    notifyListeners();
  }
}