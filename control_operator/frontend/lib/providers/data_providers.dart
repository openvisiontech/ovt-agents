/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..

 * Open Vision Technology, LLC. and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto. Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from Open Vision Technology, LLC. is strictly prohibited.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **********************************************************************************
 */

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
