import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> recentSearches = [
    'Hamburguesas',
    'Pizzería Napoli',
    'Completos',
  ];

  final List<String> popularSearches = [
    'Hamburguesas',
    'Pizzas',
    'Completos',
    'Bebidas',
  ];

  void _search(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      return;
    }

    final normalizedQuery = query.toLowerCase();

    const availableSearches = [
      'hamburguesas',
      'hamburguesa',
      'pizzas',
      'pizza',
      'pizzería napoli',
      'completos',
      'completo',
      'bebidas',
      'bebida',
    ];

    if (availableSearches.contains(normalizedQuery)) {
      Navigator.pushNamed(context, AppRoutes.searchResults, arguments: query);
    } else {
      Navigator.pushNamed(context, AppRoutes.noResults, arguments: query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        ),
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: _search,
            decoration: InputDecoration(
              hintText: 'Buscar comida o restaurante',
              hintStyle: const TextStyle(color: Colors.black45, fontSize: 15),
              prefixIcon: const Icon(Icons.search, color: Colors.black54),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                icon: const Icon(Icons.close, color: Colors.black45),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            const Text(
              'Búsquedas recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 14),

            ...recentSearches.map(
              (search) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, color: Colors.black45),
                title: Text(search),
                trailing: const Icon(
                  Icons.north_west,
                  size: 18,
                  color: Colors.black38,
                ),
                onTap: () {
                  _searchController.text = search;
                  _search(search);
                },
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Búsquedas populares',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: popularSearches.map((search) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    _searchController.text = search;
                    _search(search);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Text(
                      search,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
