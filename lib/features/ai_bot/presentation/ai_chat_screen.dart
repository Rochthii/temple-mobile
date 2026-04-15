import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/colors.dart';
import '../data/ai_chat_repository.dart';


class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // State cho Streaming
  String _streamingContent = '';
  List<String> _streamingCitations = [];
  bool _isStreaming = false;

  void _sendMessage(String sessionId) async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isStreaming) return;
    
    _controller.clear();
    setState(() {
      _isStreaming = true;
      _streamingContent = '';
      _streamingCitations = [];
    });

    try {
      // 1. Gửi tin nhắn và lắng nghe luồng SSE
      final stream = ref.read(aiChatRepositoryProvider).sendMessageStream(sessionId, text);
      
      await for (final chunk in stream) {
        if (chunk.isDone) {
          setState(() {
            _isStreaming = false;
            _streamingContent = '';
            _streamingCitations = [];
          });
          break;
        }

        setState(() {
          _streamingContent += chunk.textDelta;
          if (chunk.citations != null && chunk.citations!.isNotEmpty) {
            _streamingCitations = chunk.citations!;
          }
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isStreaming = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(currentChatSessionIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'TRÍ TUỆ BÁT NHÃ',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primaryDark,
            letterSpacing: 4.0,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(color: Colors.transparent),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
      ),
      body: Stack(
        children: [
          // ── Lớp Nền Zen ──────────────────────────────────────────────
          const _ZenBackground(),
          
          sessionAsync.when(
            data: (sessionId) {
              final messagesStream = ref.watch(aiChatRepositoryProvider).watchMessages(sessionId);
              
              return Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<ChatMessageModel>>(
                      stream: messagesStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                        }
                        
                        final messages = snapshot.data ?? [];
                        
                        if (messages.isEmpty && !_isStreaming) {
                          return _buildEmptyState(context);
                        }

                        _scrollToBottom();

                        return ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 120, bottom: 40),
                          itemCount: messages.length + (_isStreaming ? 1 : 0),
                          separatorBuilder: (context, index) => const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            if (index < messages.length) {
                              final message = messages[index];
                              return _BloomMessage(
                                key: ValueKey(message.id),
                                isUser: message.isUser,
                                child: message.isUser
                                    ? _buildUserBubble(context, message.content)
                                    : _buildAiBubble(context, message.content, message.citations),
                              );
                            } else {
                              return _buildAiBubble(context, _streamingContent, _streamingCitations);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  _buildInputArea(context, sessionId),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (e, st) => Center(child: Text('Đăng nhập để trò chuyện.')),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 40),
          const SizedBox(height: 16),
          Text(
            'Bạch Sư, con có điều thắc mắc...',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.primaryDark,
            height: 1.5,
          ),
        ),
      ),
    );
  }

Widget _buildAiBubble(BuildContext context, String text, List<String>? citations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  text,
                  style: GoogleFonts.spectral(
                    color: AppColors.textPrimary,
                    fontSize: 16.5,
                    height: 1.8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (citations != null && citations.isNotEmpty) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: citations.map((citation) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bookmark_added_rounded, size: 12, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        citation,
                        style: GoogleFonts.outfit(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInputArea(BuildContext context, String sessionId) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.4)),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 4,
                minLines: 1,
                style: GoogleFonts.outfit(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Bạch Sư...',
                  hintStyle: GoogleFonts.outfit(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _AnimatedSendButton(
            onTap: () => _sendMessage(sessionId),
            hasText: _controller.text.isNotEmpty,
          ),
        ],
      ),
    );
  }
}

// ── WIDGETS TIỆN ÍCH ──────────────────────────────────────────────

class _ZenBackground extends StatelessWidget {
  const _ZenBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEF9F3), // Mầu giấy dó nhạt
            Color(0xFFFBF4E9), // Mầu nắng chiều
          ],
        ),
      ),
      child: CustomPaint(
        painter: _PaperTexturePainter(),
      ),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A860).withValues(alpha: 0.04)
      ..strokeWidth = 1;
    
    // Vẽ các chấm li ti như sợi giấy
    final random = Random(42); 
    for (int i = 0; i < 500; i++) {
      canvas.drawCircle(
        Offset(random.nextDouble() * size.width, random.nextDouble() * size.height),
        random.nextDouble() * 0.8,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BloomMessage extends StatelessWidget {
  final Widget child;
  final bool isUser;

  const _BloomMessage({super.key, required this.child, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _AnimatedSendButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool hasText;

  const _AnimatedSendButton({required this.onTap, required this.hasText});

  @override
  State<_AnimatedSendButton> createState() => _AnimatedSendButtonState();
}

class _AnimatedSendButtonState extends State<_AnimatedSendButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.05).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

