import 'dart:math';

import 'package:noso_dart/models/noso/seed.dart';
import 'package:settings_yaml/settings_yaml.dart';

import '../models/app/test_seed.dart';
import '../path_app.dart';

class DefaultSeeds {
  final String keyVerSeeds = "verification_seeds";
  static const List<String> seedsVerification = [
    "204.10.194.22",
    "204.10.194.29",
    "204.10.194.32",
    "204.10.194.26",
    "204.10.194.33",
    "38.242.252.153",
    "157.173.99.119",
    "38.242.252.234",
    "4.233.61.8"
  ];

  /// Returns a random verified node if the resource is not specified, otherwise returns a node from the resource
  Future<String> getRandomNode(String? inputString) async {
    List<String> elements = (inputString ?? "").split(',');
    int elementCount = elements.length;
    if (elementCount > 0 && inputString != null && inputString.isNotEmpty) {
      int randomIndex = Random().nextInt(elementCount);
      var targetSeed = elements[randomIndex].split("|")[0];
      return targetSeed;
    } else {
      var devNode = await getVerificationSeedList();
      int randomDev = Random().nextInt(devNode.length);
      return devNode[randomDev].toTokenizer;
    }
  }

  Future<List<Seed>> getVerificationSeedList() async {
    var seedsForFile = await getSeedsForFile();
    var mSeedsArray = seedsForFile.split(',').map((e) => e.trim()).toList();
    List<Seed> outputSeeds = [];
    List<String> checkerSeeds;

    if (mSeedsArray.isEmpty || mSeedsArray.length < 3) {
      checkerSeeds = seedsVerification;
    } else {
      checkerSeeds = mSeedsArray;
    }

    for (String seed in checkerSeeds) {
      outputSeeds.add(Seed(ip: seed));
    }

    return outputSeeds;
  }

  Future<List<SeedTest>> getTestsSeeds() async {
    List<SeedTest> mSeeds = [];
    for (Seed seed in await getVerificationSeedList()) {
      mSeeds.add(SeedTest(name: seed.ip));
    }
    return mSeeds;
  }

  /// Writing verified nodes to a separate file
  void writeSeedsToFile(String value) async {
    var settings =
        SettingsYaml.load(pathToSettings: await PathAppUtil.getYamlConfig());
    settings[keyVerSeeds] = value;
    await settings.save();
  }

  /// Reading verified nodes from a separate file
  Future<String> getSeedsForFile() async {
    var settings =
        SettingsYaml.load(pathToSettings: await PathAppUtil.getYamlConfig());
    return settings[keyVerSeeds] ?? "";
  }
}
