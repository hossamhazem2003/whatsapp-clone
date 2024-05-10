import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/status_model.dart';

abstract class StatusRepo {
  void uploadStatus({
    required XFile statusImage,
    required BuildContext context,
  });

  Future<List<Status>> getStatus(BuildContext context);
}
