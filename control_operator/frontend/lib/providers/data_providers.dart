import '../models/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/data_models.dart';

final guiDataProvider = NotifierProvider<GuiDataModel, GuiDataModel>(
  GuiDataModel.new,
);

final headerDataProvider = NotifierProvider<HeaderDataModel, HeaderDataModel>(
  HeaderDataModel.new,
);

final domainDataProvider = NotifierProvider<DomainDataModel, DomainDataModel>(
  DomainDataModel.new,
);

final assetDataProvider = NotifierProvider<AssetDataModel, AssetDataModel>(
  AssetDataModel.new,
);

final actionRequestsProvider =
    NotifierProvider<ActionRequestsDataModel, ActionRequestsDataModel>(
      ActionRequestsDataModel.new,
    );

final gamepadDataProvider =
    NotifierProvider<GamepadDataModel, GamepadDataModel>(GamepadDataModel.new);

final streamDataProvider = NotifierProvider<StreamDataModel, StreamDataModel>(
  StreamDataModel.new,
);

final appConfigProvider = Provider<AppConfig>(
  (ref) =>
      AppConfig(workingDirectory: '', webRtcUrl: '', retryWebRTCConnect: 5000),
);
