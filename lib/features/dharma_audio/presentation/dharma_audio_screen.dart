import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/colors.dart';
import '../data/dharma_media_repository.dart';
import '../domain/models/dharma_media_model.dart';

class DharmaAudioScreen extends ConsumerStatefulWidget {
  const DharmaAudioScreen({super.key});

  @override
  ConsumerState<DharmaAudioScreen> createState() => _DharmaAudioScreenState();
}

class _DharmaAudioScreenState extends ConsumerState<DharmaAudioScreen> {
  final AudioPlayer _player = AudioPlayer();
  
  int _currentIndex = 0;
  bool _isPlaying = false;
  double _progress = 0.0;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    // Listen to player state
    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing && state.processingState != ProcessingState.completed;
        });
      }
    });

    // Listen to duration
    _player.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Listen to position
    _player.positionStream.listen((position) {
      if (mounted && _totalDuration.inMilliseconds > 0) {
        setState(() {
          _progress = position.inMilliseconds / _totalDuration.inMilliseconds;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadTrack(DharmaMediaModel track) async {
    try {
      await _player.setUrl(track.url);
      _player.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _togglePlay() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  String _formatDuration(Duration d) {
    if (d.inMilliseconds == 0) return "0:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    if (d.inHours > 0) {
      return "${d.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncTracks = ref.watch(dharmaAudioListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'PHÁP ÂM',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.primaryDark,
            letterSpacing: 2.0,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
      ),
      body: asyncTracks.when(
        data: (tracks) {
          if (tracks.isEmpty) {
            return Center(
              child: Text(
                'Chưa có bài pháp âm nào.',
                style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          final track = tracks[_currentIndex];
          final position = _totalDuration * _progress;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Circular Artwork with Frosted Glass Halo
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glass Halo
                      ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfaceBright.withValues(alpha: 0.4),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Core image
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(alpha: 0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                          image: DecorationImage(
                            image: track.thumbnailUrl != null 
                              ? NetworkImage(track.thumbnailUrl!)
                              : const NetworkImage('https://images.unsplash.com/photo-1605333190800-47b85e05c1d6?q=80&w=600&auto=format&fit=crop'), // Fallback Lotus image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Track Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        track.titleVi,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (track.descriptionVi != null) 
                        Text(
                          track.descriptionVi!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Playback Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Progress Bar
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primaryDark,
                          inactiveTrackColor: AppColors.divider,
                          thumbColor: AppColors.primaryDark,
                          trackHeight: 2.0,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        ),
                        child: Slider(
                          value: _progress.clamp(0.0, 1.0),
                          onChanged: (val) {
                            final seekTo = Duration(milliseconds: (_totalDuration.inMilliseconds * val).toInt());
                            _player.seek(seekTo);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: theme.textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
                            ),
                            Text(
                              _formatDuration(_totalDuration),
                              style: theme.textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded),
                            iconSize: 36,
                            color: AppColors.primaryDark.withValues(alpha: 0.7),
                            onPressed: () {
                              if (_currentIndex > 0) {
                                setState(() {
                                  _currentIndex--;
                                  _progress = 0;
                                  _totalDuration = Duration.zero;
                                });
                                _loadTrack(tracks[_currentIndex]);
                              }
                            },
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: () {
                              if (_player.playing) {
                                _togglePlay();
                              } else {
                                // If first time playing the track, load it
                                if (_player.processingState == ProcessingState.idle) {
                                  _loadTrack(track);
                                } else {
                                  _togglePlay();
                                }
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryDark,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryDark.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: AppColors.surfaceBright,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded),
                            iconSize: 36,
                            color: AppColors.primaryDark.withValues(alpha: 0.7),
                            onPressed: () {
                              if (_currentIndex < tracks.length - 1) {
                                setState(() {
                                  _currentIndex++;
                                  _progress = 0;
                                  _totalDuration = Duration.zero;
                                });
                                _loadTrack(tracks[_currentIndex]);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),

                // Track List
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceBright,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chuỗi Bài Giảng',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tracks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = tracks[index];
                          final isPlayingNow = index == _currentIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                                _progress = 0;
                                _totalDuration = Duration.zero;
                              });
                              _loadTrack(item);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isPlayingNow ? AppColors.background : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isPlayingNow ? AppColors.primaryDark.withValues(alpha: 0.1) : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isPlayingNow 
                                          ? AppColors.primaryDark 
                                          : AppColors.background,
                                    ),
                                    child: Icon(
                                      isPlayingNow ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded,
                                      color: isPlayingNow 
                                          ? AppColors.surfaceBright 
                                          : AppColors.primaryDark.withValues(alpha: 0.5),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.titleVi,
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: isPlayingNow 
                                                ? AppColors.primaryDark 
                                                : AppColors.textPrimary,
                                            fontWeight: isPlayingNow ? FontWeight.w600 : FontWeight.normal,
                                          ),
                                        ),
                                        if (item.fileSize != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '${(item.fileSize! / 1024 / 1024).toStringAsFixed(1)} MB',
                                            style: theme.textTheme.labelMedium?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 80), // Padding for Bottom Nav
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, stack) => Center(
          child: Text(
            'Lỗi tải Pháp âm: $error',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}
