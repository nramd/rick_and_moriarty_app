import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/search_characters.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_event.dart';
import '../bloc/favorite/favorite_state.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../widgets/character_list_item.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(searchCharacters: sl<SearchCharacters>()),
      child: const _SearchPageContent(),
    );
  }
}

class _SearchPageContent extends StatefulWidget {
  const _SearchPageContent();

  @override
  State<_SearchPageContent> createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<_SearchPageContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchBloc>().add(const LoadMoreSearchResultsEvent());
    }
  }

  bool get _isBottom {
    if (! _scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      context.read<SearchBloc>().add(SearchCharactersEvent(query: query));
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const ClearSearchEvent());
  }

  void _navigateToDetail(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(character: character)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(isDark),
          // Results
          Expanded(
            child:  BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case SearchStatus.initial:
                    return _buildInitialState();
                  case SearchStatus.loading:
                    return const LoadingWidget();
                  case SearchStatus.empty:
                    return EmptySearchWidget(query: state.query);
                  case SearchStatus. error:
                    return ErrorDisplayWidget(
                      message: state.errorMessage,
                      onRetry: () {
                        context.read<SearchBloc>().add(
                          SearchCharactersEvent(query: state.query),
                        );
                      },
                    );
                  case SearchStatus.loaded:
                  case SearchStatus.loadingMore:
                    return _buildSearchResults(state);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      padding:  EdgeInsets.all(Responsive.horizontalPadding),
      child: TextField(
        controller: _searchController,
        onChanged:  _onSearchChanged,
        autofocus: true,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors. textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: 'Search characters...',
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor:  isDark ? AppColors.cardDark : AppColors.cardLight,
          border: OutlineInputBorder(
            borderRadius:  BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:  BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons. search,
            size: 80,
            color: isDark ?  Colors.grey[700] : Colors. grey[300],
          ),
          const SizedBox(height:  16),
          Text(
            'Search for characters',
            style: AppTextStyles. bodyLarge.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors. textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try "Rick", "Morty", or "Summer"',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favoriteState) {
        return ListView.builder(
          controller: _scrollController,
          padding:  EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding),
          itemCount: state.characters.length + (state.status == SearchStatus.loadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.characters.length) {
              return const LoadingMoreWidget();
            }

            final character = state.characters[index];
            final isFavorite = favoriteState.isFavorite(character.id);

            return CharacterListItem(
              character: character,
              isFavorite: isFavorite,
              onTap: () => _navigateToDetail(character),
              onFavoriteToggle: () => _toggleFavorite(character, isFavorite),
            );
          },
        );
      },
    );
  }

  void _toggleFavorite(Character character, bool isFavorite) {
    if (isFavorite) {
      context.read<FavoriteBloc>().add(RemoveFavoriteEvent(characterId:  character.id));
      _showSnackBar('${character.name} removed from favorites', isError: true);
    } else {
      context.read<FavoriteBloc>().add(AddFavoriteEvent(character: character));
      _showSnackBar('${character.name} added to favorites');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ?  AppColors.error : AppColors. primaryGreen,
        behavior:  SnackBarBehavior. floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}