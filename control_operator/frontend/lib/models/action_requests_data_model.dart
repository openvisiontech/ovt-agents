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

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionRequestsDataModel extends Notifier<ActionRequestsDataModel> {
  @override
  ActionRequestsDataModel build() => this;
  @override
  bool updateShouldNotify(
    ActionRequestsDataModel previous,
    ActionRequestsDataModel next,
  ) => true;

  bool _assetListUpdate = false;
  bool _assetListAutoUpdate = false;
  bool _serviceListUpdate = false;
  bool _agentListUpdate = false;
  bool _resourceListUpdate = false;
  bool _dataTopicListUpdate = false;
  bool _dataTopicClientListUpdate = false;
  bool _transformReporterListUpdate = false;
  bool _statusDetailsUpdate = false;
  bool _resourceDetailsUpdate = false;
  bool _agentStatusUpdate = false;
  bool _agentDetailsUpdate = false;
  bool _serviceListAutoUpdate = false;

  void toggleAssetListAutoUpdate() {
    _assetListAutoUpdate = !_assetListAutoUpdate;
    state = this;
  }

  void leavingDomainScreen() {
    _assetListUpdate = false;
    _assetListAutoUpdate = false;
  }

  void leavingAssetScreen() {
    _serviceListUpdate = false;
    _agentListUpdate = false;
    _resourceListUpdate = false;
    _dataTopicListUpdate = false;
    _dataTopicClientListUpdate = false;
    _transformReporterListUpdate = false;
    _statusDetailsUpdate = false;
    _resourceDetailsUpdate = false;
    _agentStatusUpdate = false;
    _agentDetailsUpdate = false;
    _serviceListAutoUpdate = false;
  }

  void leavingAIAssistScreen() {
    _serviceListAutoUpdate = false;
  }

  bool get assetListUpdate => _assetListUpdate;
  bool get assetListAutoUpdate => _assetListAutoUpdate;
  bool get serviceListUpdate => _serviceListUpdate;
  bool get agentListUpdate => _agentListUpdate;
  bool get resourceListUpdate => _resourceListUpdate;
  bool get dataTopicListUpdate => _dataTopicListUpdate;
  bool get dataTopicClientListUpdate => _dataTopicClientListUpdate;
  bool get transformReporterListUpdate => _transformReporterListUpdate;
  bool get statusDetailsUpdate => _statusDetailsUpdate;
  bool get resourceDetailsUpdate => _resourceDetailsUpdate;
  bool get agentStatusUpdate => _agentStatusUpdate;
  bool get agentDetailsUpdate => _agentDetailsUpdate;
  bool get serviceListAutoUpdate => _serviceListAutoUpdate;

  set assetListUpdate(bool value) {
    _assetListUpdate = value;
    state = this;
  }

  set assetListAutoUpdate(bool value) {
    _assetListAutoUpdate = value;
    state = this;
  }

  set serviceListUpdate(bool value) {
    _serviceListUpdate = value;
    state = this;
  }

  set agentListUpdate(bool value) {
    _agentListUpdate = value;
    state = this;
  }

  set resourceListUpdate(bool value) {
    _resourceListUpdate = value;
    state = this;
  }

  set dataTopicListUpdate(bool value) {
    _dataTopicListUpdate = value;
    state = this;
  }

  set dataTopicClientListUpdate(bool value) {
    _dataTopicClientListUpdate = value;
    state = this;
  }

  set transformReporterListUpdate(bool value) {
    _transformReporterListUpdate = value;
    state = this;
  }

  set statusDetailsUpdate(bool value) {
    _statusDetailsUpdate = value;
    state = this;
  }

  set resourceDetailsUpdate(bool value) {
    _resourceDetailsUpdate = value;
    state = this;
  }

  set agentStatusUpdate(bool value) {
    _agentStatusUpdate = value;
    state = this;
  }

  set agentDetailsUpdate(bool value) {
    _agentDetailsUpdate = value;
    state = this;
  }

  set serviceListAutoUpdate(bool value) {
    _serviceListAutoUpdate = value;
    state = this;
  }
}
