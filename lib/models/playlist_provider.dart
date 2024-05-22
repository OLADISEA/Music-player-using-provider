import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    // 1st song
    Song(
      songName: 'ALL OF ME',
      artistName: 'John Legend',
      albumArtImagePath: 'assets/images/all_of_me.jpg',
      audioPath: 'audio/all of me.mp3',
    ),

    // 2nd song
    Song(
      songName: 'Faded',
      artistName: 'Alan Walker',
      albumArtImagePath: 'assets/images/faded.jpg',
      audioPath: 'audio/faded.mp3',
    ),
  ];

  // Index of the current song playing
  int? _currentSongIndex;

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Initially not playing
  bool _isPlaying = false;

  // Repeat mode
  bool _isLoopMode = false;

  // Constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // Play the song
  Future<void> play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // Pause the current song
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume
  Future<void> pauseOrResume() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
    notifyListeners();
  }

  // Seek to a specific position in the current song
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  // Play the next song
  Future<void> playNextSong() async {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // Go to the next song if the current song is not the last one
        currentSongIndex = _currentSongIndex! + 1;
      } else if (_isLoopMode) {
        // Loop back to the first song if repeat mode is enabled
        currentSongIndex = 0;
      } else {
        // Stop playback if there are no more songs
        await _audioPlayer.stop();
        _isPlaying = false;
        notifyListeners();
      }
    }
  }

  // Play the previous song
  Future<void> playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      await seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // If it is the first song, loop back to the last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // Listen to duration changes
  void listenToDuration() {
    // Listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // Listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // Listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // Dispose audio player
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isLoopMode => _isLoopMode;

  // Setters
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }

  // Setters for repeat mode
  set loopMode(bool isRepeatMode) {
    _isLoopMode = isRepeatMode;
    notifyListeners();
  }

  // Toggle repeat mode
  void toggleLoopMode() {
    loopMode = !_isLoopMode;
  }
}
