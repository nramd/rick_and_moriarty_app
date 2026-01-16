import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/character.dart';
import '../bloc/character/character_bloc.dart';
import '../bloc/character/character_event.dart';
import '../bloc/character/character_state.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import '../widgets/character_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<CharacterBloc>().add(const FetchCharactersEvent());
    context.read<FavoriteBloc>().add(const FetchFavoritesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharacterBloc>().add(const LoadMoreCharactersEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _navigateToDetail(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(character: character)),
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritePage()),
    ).then((_) {
      if (mounted) {
        context.read<FavoriteBloc>().add(const FetchFavoritesEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rick and Morty',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearch,
            tooltip: 'Search',
          ),
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: _navigateToFavorites,
                    tooltip: 'Favorites',
                  ),
                  if (state.favorites.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          state.favorites.length > 99
                              ? '99+'
                              : state.favorites.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          switch (state.status) {
            case CharacterStatus.initial:
            case CharacterStatus.loading:
              return const ShimmerGrid();
            case CharacterStatus.error:
              return ErrorDisplayWidget(
                message: state.errorMessage,
                onRetry: () {
                  context
                      .read<CharacterBloc>()
                      .add(const FetchCharactersEvent());
                },
              );
            case CharacterStatus.loaded:
            case CharacterStatus.loadingMore:
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<CharacterBloc>()
                      .add(const RefreshCharactersEvent());
                },
                color: AppColors.primaryGreen,
                child: _buildCharacterGrid(state),
              );
          }
        },
      ),
    );
  }

  Widget _buildCharacterGrid(CharacterState state) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favoriteState) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(Responsive.horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.gridColumns,
                  childAspectRatio: Responsive.cardAspectRatio,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final character = state.characters[index];
                    final isFavorite = favoriteState.isFavorite(character.id);

                    return CharacterCard(
                      character: character,
                      isFavorite: isFavorite,
                      onTap: () => _navigateToDetail(character),
                      onFavoriteToggle: () =>
                          _toggleFavorite(character, isFavorite),
                    );
                  },
                  childCount: state.characters.length,
                ),
              ),
            ),
            if (state.status == CharacterStatus.loadingMore)
              const SliverToBoxAdapter(
                child: LoadingMoreWidget(),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        );
      },
    );
  }

  void _toggleFavorite(Character character, bool isFavorite) {
    if (isFavorite) {
      context
          .read<FavoriteBloc>()
          .add(RemoveFavoriteEvent(characterId: character.id));
      _showSnackBar('${character.name} removed from favorites', isError: true);
    } else {
      context.read<FavoriteBloc>().add(AddFavoriteEvent(character: character));
      _showSnackBar('${character.name} added to favorites');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
