Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA65C2437B8
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 11:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgHMJeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 05:34:25 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:11479 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgHMJeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 05:34:24 -0400
X-UUID: 8cceac4896734390b6825625a7971193-20200813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=UiYITuOicKAGf3efIhr1L/4MAUvnnb66uoIfzUsZtVU=;
        b=GLmefJgD2hfapLzyT394fjwmQSb/yiRFU4bs9xaUNYfLQMOhOEpbL+u0vr8liZiqaky773/YA+SlV+ZXQL7Flb6k8l0giZkLIGyw5/iEEc22uN2PLUH3pW7IAiqx5I76pX0/X8xTtFLSNhSRI+RQi/vTkAuopmQSJwY6CKYQJkY=;
X-UUID: 8cceac4896734390b6825625a7971193-20200813
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1373665491; Thu, 13 Aug 2020 17:34:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS31DR.mediatek.inc (172.27.6.102) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 13 Aug 2020 17:34:16 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 13 Aug 2020 17:34:14 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     <yong.mao@mediatek.com>
CC:     Wenbin Mei <wenbin.mei@mediatek.com>, <stable@vger.kernel.org>
Subject: [v4,1/3] mmc: dt-bindings: Add resets/reset-names for Mediatek MMC bindings
Date:   Thu, 13 Aug 2020 17:33:14 +0800
Message-ID: <20200813093316.28503-2-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200813093316.28503-1-wenbin.mei@mediatek.com>
References: <20200813093316.28503-1-wenbin.mei@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 69B2B36B9C72382A9ABE8DB6AC42701D0D8DCE4996681CC63897270C5FD81B192000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QWRkIGRlc2NyaXB0aW9uIGZvciByZXNldHMvcmVzZXQtbmFtZXMuDQoNCkNjOiA8c3RhYmxlQHZn
ZXIua2VybmVsLm9yZz4gIyB2NS40Kw0KRml4ZXM6IDk2NjU4MGFkMjM2ZSAoIm1tYzogbWVkaWF0
ZWs6IGFkZCBzdXBwb3J0IGZvciBNVDc2MjIgU29DIikNClNpZ25lZC1vZmYtYnk6IFdlbmJpbiBN
ZWkgPHdlbmJpbi5tZWlAbWVkaWF0ZWsuY29tPg0KVGVzdGVkLWJ5OiBGcmFuayBXdW5kZXJsaWNo
IDxmcmFuay13QHB1YmxpYy1maWxlcy5kZT4NCi0tLQ0KIERvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9tbWMvbXRrLXNkLnR4dCB8IDIgKysNCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbW1jL210ay1zZC50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbW1j
L210ay1zZC50eHQNCmluZGV4IDhhNTMyZjQ0NTNmMi4uMDlhZWNlYzQ3MDAzIDEwMDY0NA0KLS0t
IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21tYy9tdGstc2QudHh0DQorKysg
Yi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbW1jL210ay1zZC50eHQNCkBAIC00
OSw2ICs0OSw4IEBAIE9wdGlvbmFsIHByb3BlcnRpZXM6DQogCQkgICAgIGVycm9yIGNhdXNlZCBi
eSBzdG9wIGNsb2NrKGZpZm8gZnVsbCkNCiAJCSAgICAgVmFsaWQgcmFuZ2UgPSBbMDoweDddLiBp
ZiBub3QgcHJlc2VudCwgZGVmYXVsdCB2YWx1ZSBpcyAwLg0KIAkJICAgICBhcHBsaWVkIHRvIGNv
bXBhdGlibGUgIm1lZGlhdGVrLG10MjcwMS1tbWMiLg0KKy0gcmVzZXRzOiBQaGFuZGxlIGFuZCBy
ZXNldCBzcGVjaWZpZXIgcGFpciB0byBzb2Z0cmVzZXQgbGluZSBvZiBNU0RDIElQLg0KKy0gcmVz
ZXQtbmFtZXM6IFNob3VsZCBiZSAiaHJzdCIuDQogDQogRXhhbXBsZXM6DQogbW1jMDogbW1jQDEx
MjMwMDAwIHsNCi0tIA0KMi4xOC4wDQo=

