import 'package:cloud_firestore/cloud_firestore.dart';

class GameRatingRepository {
  final _db = FirebaseFirestore.instance;

  Future<Map<String, int>> getRatings(int gameId) async {
    final doc =
    await _db.collection('games').doc(gameId.toString()).get();

    if (!doc.exists) {
      await _db.collection('games').doc(gameId.toString()).set({
        'boas': 0,
        'ruins': 0,
      });
      return {'boas': 0, 'ruins': 0};
    }

    final data = doc.data()!;
    return {
      'boas': data['boas'],
      'ruins': data['ruins'],
    };
  }

  Future<void> addBoa(int gameId) async {
    final ref =
    _db.collection('games').doc(gameId.toString());

    await ref.update({
      'boas': FieldValue.increment(1),
    });
  }

  Future<void> addRuim(int gameId) async {
    final ref =
    _db.collection('games').doc(gameId.toString());

    await ref.update({
      'ruins': FieldValue.increment(1),
    });
  }
}
