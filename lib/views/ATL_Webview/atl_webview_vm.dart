// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:stacked/stacked.dart';
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

// class ATLWebViewVM extends BaseViewModel {
//   //
//   // Example for URL parameters:
//   // http://localhost:57042/?uid=123&tournamentName=veloxis
//   //

//   String? currentUrl;
//   List<Map<String, dynamic>> standings = [];

//   String? uidParam;
//   String? tournamentNameParam;
//   String message = 'Loading URL parameters...';
//   init() async {
//     await getUrl();
//     getQueryParams();
//     await fetchStandings();
//     await fetchMatchdays();
//   }

//   getUrl() {
//     if (html.window != null) {
//       currentUrl = html.window.location.href;
//       notifyListeners();
//     }
//   }

//   void getQueryParams() {
//     // Uri.base represents the current URI of the application.
//     // On the web, this will be the browser's URL.
//     final Uri uri = Uri.base;

//     // queryParameters is a Map<String, String> containing all query parameters.
//     // For a URL like http://localhost:XXXX/?init=someValue&i=anotherValue
//     // uri.queryParameters will be {'init': 'someValue', 'i': 'anotherValue'}
//     final Map<String, String> queryParams = uri.queryParameters;

//     uidParam = queryParams['uid'];
//     tournamentNameParam = queryParams['tournamentName'];

//     // if (uidParam != null && tournamentNameParam != null) {
//     //   message = 'init: $uidParam\ni: $tournamentNameParam';
//     // } else if (uidParam != null) {
//     //   message = 'init: $uidParam\ni: (not found)';
//     // } else if (tournamentNameParam != null) {
//     //   message = 'init: (not found)\ni: $tournamentNameParam';
//     // } else {
//     //   message = 'No "init" or "i" parameters found in URL.';
//     // }
//     notifyListeners();
//   }

//   Future<void> fetchStandings() async {
//     setBusy(true);

//     if (uidParam == null || tournamentNameParam == null) {
//       message = 'Missing URL parameters.';
//       setBusy(false);
//       return;
//     }

//     final rulesSnap = await FirebaseFirestore.instance
//         .collection(uidParam!)
//         .doc(tournamentNameParam)
//         .collection('MatchRules')
//         .doc('Rules')
//         .get();

//     final pointsVictory = rulesSnap['pointsVictory'] ?? 3;
//     final pointsTie = rulesSnap['pointsTie'] ?? 1;
//     final pointsLose = rulesSnap['pointsLose'] ?? 0;

//     final matchSnapshot = await FirebaseFirestore.instance
//         .collection(uidParam!)
//         .doc(tournamentNameParam)
//         .collection('Matches')
//         .get();

//     Map<String, Map<String, dynamic>> players = {};

//     for (var doc in matchSnapshot.docs) {
//       final data = doc.data();
//       final matches = List.from(data['matches']);

//       for (var matchObj in matches) {
//         final match = matchObj['match'][0];
//         final player1 = match['player1'];
//         final player2 = match['player2'];
//         final score1 = match['scores']['player1'] ?? 0;
//         final score2 = match['scores']['player2'] ?? 0;
//         final isDraw = match['draw'] ?? false;

//         if (!players.containsKey(player1)) {
//           players[player1] = {
//             'name': player1,
//             'played': 0,
//             'win': 0,
//             'draw': 0,
//             'loss': 0,
//             'points': 0,
//             'pf': 0,
//             'pa': 0,
//           };
//         }

//         if (!players.containsKey(player2)) {
//           players[player2] = {
//             'name': player2,
//             'played': 0,
//             'win': 0,
//             'draw': 0,
//             'loss': 0,
//             'points': 0,
//             'pf': 0,
//             'pa': 0,
//           };
//         }

//         // If match played (not both 0-0)
//         if (score1 != 0 || score2 != 0) {
//           players[player1]!['played']++;
//           players[player2]!['played']++;

//           players[player1]!['pf'] += score1;
//           players[player1]!['pa'] += score2;
//           players[player2]!['pf'] += score2;
//           players[player2]!['pa'] += score1;

//           if (isDraw) {
//             players[player1]!['draw']++;
//             players[player2]!['draw']++;
//             players[player1]!['points'] += pointsTie;
//             players[player2]!['points'] += pointsTie;
//           } else {
//             if (score1 > score2) {
//               players[player1]!['win']++;
//               players[player2]!['loss']++;
//               players[player1]!['points'] += pointsVictory;
//               players[player2]!['points'] += pointsLose;
//             } else {
//               players[player2]!['win']++;
//               players[player1]!['loss']++;
//               players[player2]!['points'] += pointsVictory;
//               players[player1]!['points'] += pointsLose;
//             }
//           }
//         }
//       }
//     }

//     standings = players.values.toList();

//     standings.sort((a, b) {
//       if (b['points'] != a['points']) {
//         return b['points'].compareTo(a['points']);
//       } else {
//         return b['pf'].compareTo(a['pf']);
//       }
//     });

//     message = 'Data fetched successfully!';
//     print('Standings: \n$standings');
//     setBusy(false);
//   }

//   List<Map<String, dynamic>> matchdays = [];

//   Future<void> fetchMatchdays() async {
//     setBusy(true);

//     final collection = await FirebaseFirestore.instance
//         .collection(uidParam!)
//         .doc(tournamentNameParam)
//         .collection('Matches');

//     final querySnapshot = await collection.get();

//     matchdays = querySnapshot.docs.map((doc) {
//       final data = doc.data();
//       final matches = (data['matches'] as List).map((e) {
//         final matchData = e['match'][0];
//         return {
//           'player1': matchData['player1'],
//           'player2': matchData['player2'],
//           'score1': matchData['scores']['player1'] ?? '-',
//           'score2': matchData['scores']['player2'] ?? '-',
//           'winer': matchData['winner'] ?? '',
//           'loser': matchData['loser'] ?? '',
//           'draw': matchData['draw'] ?? false,
//         };
//       }).toList();

//       int matchdayNum = int.tryParse(doc.id.replaceAll('matchday', '')) ?? 0;

//       String formattedMatchday = matchdayNum >= 1 && matchdayNum <= 9
//           ? '0$matchdayNum'
//           : '$matchdayNum';

//       return {
//         'matchday': formattedMatchday,
//         'matches': matches,
//       };
//     }).toList();

//     matchdays.sort((a, b) => a['matchday'].compareTo(b['matchday']));
//     print('Matchdays: \n$matchdays');

//     setBusy(false);
//   }
// }

// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // Conditional import for web

class ATLWebViewVM extends BaseViewModel {
  //
  // Example for URL parameters:
  // http://localhost:57042/?uid=123&tournamentName=veloxis
  //

  String? uidParam;
  String? tournamentNameParam;
  String _errorMessage = ''; // State to hold any error messages

  List<Map<String, dynamic>> standings = [];
  List<Map<String, dynamic>> matchdays = [];

  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  /// Initializes the ViewModel by extracting URL parameters and fetching data.
  Future<void> init() async {
    setBusy(true); // Start loading state
    _errorMessage = ''; // Clear previous errors

    try {
      _extractUrlParameters(); // Extract parameters first

      if (uidParam == null || tournamentNameParam == null) {
        _errorMessage =
            'Missing required URL parameters (uid or tournamentName). '
            'URL must contain ?uid=YOUR_UID&tournamentName=YOUR_TOURNAMENT_NAME';
        print(_errorMessage);
        setBusy(false); // Stop busy state on error
        notifyListeners();
        return;
      }

      await fetchStandings(); // Fetch standings
      await fetchMatchdays(); // Fetch matchdays
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Error during init: $e');
    } finally {
      setBusy(false); // End loading state regardless of success or error
      notifyListeners();
    }
  }

  /// Extracts 'uid' and 'tournamentName' from the current browser URL.
  void _extractUrlParameters() {
    // Check if running on web (kIsWeb from foundation.dart is also an option, but dart:html implies web)
    if (html.window != null) {
      final Uri uri = Uri.base;
      final Map<String, String> queryParams = uri.queryParameters;

      uidParam = queryParams['uid'];
      tournamentNameParam = queryParams['tournamentName'];

      print(
          'URL Parameters Extracted: UID=$uidParam, TournamentName=$tournamentNameParam');
    } else {
      // This ViewModel is designed for web, but handle non-web gracefully if ever run elsewhere
      _errorMessage =
          'URL parameter extraction is only applicable for web builds.';
      print(_errorMessage);
    }
  }

  /// Fetches and calculates standings data from Firestore.
  Future<void> fetchStandings() async {
    try {
      final rulesSnap = await FirebaseFirestore.instance
          .collection(uidParam!)
          .doc(tournamentNameParam)
          .collection('MatchRules')
          .doc('Rules')
          .get();

      final pointsVictory = rulesSnap.data()?['pointsVictory'] ?? 3;
      final pointsTie = rulesSnap.data()?['pointsTie'] ?? 1;
      final pointsLose = rulesSnap.data()?['pointsLose'] ?? 0;

      final matchSnapshot = await FirebaseFirestore.instance
          .collection(uidParam!)
          .doc(tournamentNameParam)
          .collection('Matches')
          .get();

      Map<String, Map<String, dynamic>> players = {};

      for (var doc in matchSnapshot.docs) {
        final data = doc.data();

        final matches = (data['matches'] as List? ?? [])
            .where((item) => item is Map<String, dynamic>)
            .map((item) {
              if (item.containsKey('match') &&
                  item['match'] is List &&
                  item['match'].isNotEmpty) {
                return item['match'][0]; // Old format
              }
              return item; // New format
            })
            .where((match) =>
                match.containsKey('player1') &&
                match.containsKey('player2') &&
                match.containsKey('scores'))
            .toList();

        for (var match in matches) {
          final player1 = match['player1'];
          final player2 = match['player2'];
          final score1 = match['scores']?['player1'] ?? 0;
          final score2 = match['scores']?['player2'] ?? 0;
          final isDraw = match['draw'] ?? false;

          players.putIfAbsent(player1, () => _initPlayer(player1));
          players.putIfAbsent(player2, () => _initPlayer(player2));

          // Only process if at least one player scored
          if (score1 != 0 || score2 != 0) {
            players[player1]!['played'] += 1;
            players[player2]!['played'] += 1;

            players[player1]!['pf'] += score1;
            players[player1]!['pa'] += score2;
            players[player2]!['pf'] += score2;
            players[player2]!['pa'] += score1;

            if (isDraw || score1 == score2) {
              players[player1]!['draw'] += 1;
              players[player2]!['draw'] += 1;
              players[player1]!['points'] += pointsTie;
              players[player2]!['points'] += pointsTie;
            } else if (score1 > score2) {
              players[player1]!['win'] += 1;
              players[player2]!['loss'] += 1;
              players[player1]!['points'] += pointsVictory;
              players[player2]!['points'] += pointsLose;
            } else {
              players[player2]!['win'] += 1;
              players[player1]!['loss'] += 1;
              players[player2]!['points'] += pointsVictory;
              players[player1]!['points'] += pointsLose;
            }
          }
        }
      }

      standings = players.values.toList();

      // Add PF-PA difference for sorting
      for (var player in standings) {
        player['diff'] = player['pf'] - player['pa'];
      }

      // Sort: Points DESC -> PF-PA Diff DESC -> PF DESC
      standings.sort((a, b) {
        if (b['points'] != a['points']) {
          return b['points'].compareTo(a['points']);
        } else if (b['diff'] != a['diff']) {
          return b['diff'].compareTo(a['diff']);
        } else {
          return b['pf'].compareTo(a['pf']);
        }
      });

      print('Standings: \n$standings');
    } catch (e) {
      _errorMessage = 'Failed to fetch standings data: $e';
      print('Error fetching standings: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _initPlayer(String name) {
    return {
      'name': name,
      'played': 0,
      'win': 0,
      'draw': 0,
      'loss': 0,
      'points': 0,
      'pf': 0,
      'pa': 0,
      'diff': 0, // PF-PA difference
    };
  }

  /// Fetches and formats matchdays data from Firestore.
  Future<void> fetchMatchdays() async {
    try {
      final collection = await FirebaseFirestore.instance
          .collection(uidParam!)
          .doc(tournamentNameParam)
          .collection('Matches');

      final querySnapshot = await collection.get();

      matchdays = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final matches = (data['matches'] as List? ?? []).map((e) {
          final matchData = e;
          return {
            'player1': matchData['player1'],
            'player2': matchData['player2'],
            'score1': matchData['scores']?['player1'] ?? '-',
            'score2': matchData['scores']?['player2'] ?? '-',
            'winner': matchData['winner'] ?? '',
            'loser': matchData['loser'] ?? '',
            'draw': matchData['draw'] ?? false,
            'date': matchData['date'] ?? 'Not Decided',
            'time': matchData['time'] ?? 'Not Decided',
          };
        }).toList();

        int matchdayNum = int.tryParse(doc.id.replaceAll('matchday', '')) ?? 0;

        String formattedMatchday = matchdayNum >= 1 && matchdayNum <= 9
            ? '0$matchdayNum'
            : '$matchdayNum';

        return {
          'matchday': formattedMatchday,
          'matches': matches,
        };
      }).toList();

      matchdays.sort((a, b) =>
          (a['matchday'] as String).compareTo(b['matchday'] as String));
      print('Matchdays: \n$matchdays');
    } catch (e) {
      _errorMessage = 'Failed to fetch matchdays data: $e';
      print('Error fetching matchdays: $e');
      rethrow; // Re-throw to be caught by the outer init try-catch
    }
  }
}
