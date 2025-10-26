import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  AudioPlayerHandler() {
    _init();
  }

  Future<void> _init() async {
    // Listen for changes in playback state
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    
    // Listen for changes in current item
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        mediaItem.add(queue.value![index]);
      }
    });

    // Load initial playlist
    await _player.setAudioSource(_playlist);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    final audioSource = AudioSource.uri(Uri.parse(mediaItem.id));
    await _playlist.clear();
    await _playlist.add(audioSource);
    await _player.setAudioSource(_playlist);
    this.mediaItem.add(mediaItem);
    await play();
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = AudioSource.uri(Uri.parse(mediaItem.id));
    await _playlist.add(audioSource);
    queue.add([...queue.value ?? [], mediaItem]);
  }
}