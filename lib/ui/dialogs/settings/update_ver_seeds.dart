import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nososova/configs/default_seeds.dart';

import '../../../configs/app_config.dart';
import '../../../l10n/app_localizations.dart';
import '../../config/responsive.dart';
import '../../theme/style/colors.dart';
import '../../theme/style/sizes.dart';
import '../../theme/style/text_style.dart';

class UpdateVerSeedsWidget extends StatefulWidget {
  const UpdateVerSeedsWidget({super.key});

  @override
  State createState() => _UpdateVerSeedsWidgetState();
}

enum StatusGetDNS { loading, ok, reject }

class _UpdateVerSeedsWidgetState extends State<UpdateVerSeedsWidget> {
  StatusGetDNS status = StatusGetDNS.loading;
  List<String> dnsSeeds = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    await Future.delayed(const Duration(seconds: 3));

    try {
      final lookupResults = await InternetAddress.lookup(AppConfig.seedsDNS);
      for (var element in lookupResults) {
        var address = element.address;
        if (!dnsSeeds.contains(address)) {
          dnsSeeds.add(address);
        }
      }

      if (mounted) {
        if (dnsSeeds.isNotEmpty || dnsSeeds.length >= 3) {
          setState(() {
            status = StatusGetDNS.ok;
            DefaultSeeds().writeSeedsToFile(dnsSeeds.join(','));
          });

      } else {
        throw Exception("DNS NOT VALID");
      }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (mounted) {
        setState(() {
          status = StatusGetDNS.reject;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.isMobile(context)
            ? CustomSizes.paddingDialogMobile
            : CustomSizes.paddingDialogDesktop,
        horizontal: CustomSizes.paddingDialogVertical,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.verfNodes,
            style: AppTextStyles.itemMedium,
          ),
          status == StatusGetDNS.loading
              ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator())
              : status == StatusGetDNS.ok
                  ? Text("O",
                      style: AppTextStyles.statusSeed.copyWith(
                          color: CustomColors.positiveBalance, fontSize: 20))
                  : Text("X",
                      style: AppTextStyles.statusSeed.copyWith(
                          color: CustomColors.negativeBalance, fontSize: 20)),
        ],
      ),
    );
  }
}
