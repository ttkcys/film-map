import 'package:filmmap/provider/movide_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (movieProvider.movie == null) {
            return const Center(child: Text('Failed to load movie'));
          }

          final movie = movieProvider.movie!;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black54,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle details button press
                      },
                      child: const Text('Details'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
