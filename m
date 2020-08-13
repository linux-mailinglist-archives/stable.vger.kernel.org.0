Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D50824378E
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 11:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHMJXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 05:23:46 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:63912 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgHMJXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 05:23:46 -0400
X-UUID: 69c7f042203945fe9f2f0262515fa8fc-20200813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=UiYITuOicKAGf3efIhr1L/4MAUvnnb66uoIfzUsZtVU=;
        b=OwdlRZhp5ddX3eQ7woJgskXHC1sLsjSNuLLjHXCzaOWW+Iz6f9D90XTQYITXO2nFOsJx4n0Es/+GxAxNuWK6QJ9IvMdmai4H2N+JhclCO2Sq5VYE4U/s36kE3xK+CuNCIfKqxXdQ6dkgwcd8HSWSj2eBMSlo170+Mihgkt+7YuE=;
X-UUID: 69c7f042203945fe9f2f0262515fa8fc-20200813
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1892848216; Thu, 13 Aug 2020 17:23:39 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS31N1.mediatek.inc (172.27.4.69) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 13 Aug 2020 17:23:37 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 13 Aug 2020 17:23:37 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     <yong.mao@mediatek.com>
CC:     Wenbin Mei <wenbin.mei@mediatek.com>, <stable@vger.kernel.org>
Subject: [v4,1/3] mmc: dt-bindings: Add resets/reset-names for Mediatek MMC bindings
Date:   Thu, 13 Aug 2020 17:22:00 +0800
Message-ID: <20200813092202.28341-2-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200813092202.28341-1-wenbin.mei@mediatek.com>
References: <20200813092202.28341-1-wenbin.mei@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 36E132FF3076E93664A35AFF6961FB35FE41EC4B00777DE2AF839036CDC096DE2000:8
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

