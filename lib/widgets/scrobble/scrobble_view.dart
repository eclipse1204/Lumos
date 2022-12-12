import 'dart:async';

import 'package:finale/services/generic.dart';
import 'package:finale/services/lastfm/lastfm.dart';
import 'package:finale/util/constants.dart';
import 'package:finale/util/preferences.dart';
import 'package:finale/util/social_media_icons_icons.dart';
import 'package:finale/widgets/base/titled_box.dart';

import 'package:finale/widgets/scrobble/music_recognition_component.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:universal_io/io.dart';

class ScrobbleView extends StatefulWidget {
  final Track? track;
  final bool isModal;

  const ScrobbleView({this.track, this.isModal = false});

  @override
  State<StatefulWidget> createState() => _ScrobbleViewState();
}

class _ScrobbleViewState extends State<ScrobbleView> {
  final _formKey = GlobalKey<FormState>();

  final _trackController = TextEditingController();
  final _artistController = TextEditingController();
  final _albumController = TextEditingController();
  final _albumArtistController = TextEditingController();

  var _useCustomTimestamp = false;
  DateTime? _customTimestamp;

  var _isLoading = false;

  late StreamSubscription _showAlbumArtistFieldSubscription;
  StreamSubscription? _appleMusicChangeSubscription;
  late bool _showAlbumArtistField;
  late bool _isAppleMusicEnabled;

  @override
  void initState() {
    super.initState();
    _trackController.text = widget.track?.name ?? '';
    _artistController.text = widget.track?.artistName ?? '';
    _albumController.text = widget.track?.albumName ?? '';

    _showAlbumArtistFieldSubscription =
        Preferences.showAlbumArtistField.changes.listen((value) {
      setState(() {
        _showAlbumArtistField = value;
      });
    });

    _showAlbumArtistField = Preferences.showAlbumArtistField.value;

    if (!widget.isModal) {
      _appleMusicChangeSubscription =
          Preferences.appleMusicEnabled.changes.listen((_) {
        setState(() {
          _isAppleMusicEnabled = Preferences.appleMusicEnabled.value;
        });
      });

      _isAppleMusicEnabled = Preferences.appleMusicEnabled.value;
    }
  }

  String? _required(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Required';
    }

    return null;
  }

  Future<void> _scrobble(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final response = await Lastfm.scrobble([
      BasicConcreteTrack(_trackController.text, _artistController.text,
          _albumController.text, _albumArtistController.text),
    ], [
      _useCustomTimestamp ? _customTimestamp! : DateTime.now()
    ]);

    setState(() {
      _isLoading = false;
    });

    if (widget.isModal) {
      Navigator.pop(context, response.ignored == 0);
      return;
    }

    if (response.ignored == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scrobbled successfully!')));
      _trackController.text = '';
      _artistController.text = '';
      _albumController.text = '';

      // Ask for a review
      if (await InAppReview.instance.isAvailable()) {
        InAppReview.instance.requestReview();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred while scrobbling')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: MusicRecognitionComponent(
          onTrackRecognized: (track) {
            setState(() {
              _trackController.text = track.title;
              _albumController.text = track.album.name;
              _artistController.text = track.artists.first.name;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _showAlbumArtistFieldSubscription.cancel();
    _appleMusicChangeSubscription?.cancel();
    _trackController.dispose();
    _artistController.dispose();
    _albumController.dispose();
    _albumArtistController.dispose();
  }
}
