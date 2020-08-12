Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2A52428EC
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 13:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgHLL45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 07:56:57 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:16053 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726404AbgHLL45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 07:56:57 -0400
X-UUID: 10aa1452e0844a42bbf49cb88f8400f7-20200812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=CPfvLHBxlQlMKioayJomvxJW3VbWFN9owalBbLtburM=;
        b=M5Ikbd4qPeLS5jyUTSz9kWCUmWje9AsCNpgncMYhCDsGxhvzgS/aydCT5ulaJQ0lpBXlwWRZDdIo+HUX2sF0sEpRFanHFKOa8wv2eL7fy0sLKlLdGggqpCKA8T9S3sYQKP0TktNrTUozxuzuQnnVatXMv/Tu8jg5e/ejlnwF8fQ=;
X-UUID: 10aa1452e0844a42bbf49cb88f8400f7-20200812
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1390825609; Wed, 12 Aug 2020 19:56:47 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31N1.mediatek.inc
 (172.27.4.69) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Aug
 2020 19:56:46 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Aug 2020 19:56:46 +0800
Message-ID: <1597233352.10188.2.camel@mhfsdcap03>
Subject: Re: Aw: [PATCH 3/3] mmc: mediatek: add optional module reset
 property
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     Frank Wunderlich <frank-w@public-files.de>
CC:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        <stable@vger.kernel.org>
Date:   Wed, 12 Aug 2020 19:55:52 +0800
In-Reply-To: <trinity-5b810acf-eb8f-452e-b08a-30e1fe46226d-1597226878715@3c-app-gmx-bap56>
References: <20200812093726.10123-1-wenbin.mei@mediatek.com>
         <20200812093726.10123-4-wenbin.mei@mediatek.com>
         <trinity-5b810acf-eb8f-452e-b08a-30e1fe46226d-1597226878715@3c-app-gmx-bap56>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: EE4356F3A23EF08C004D9C72FDAC0CE917E712D37CC61975CF9F4085EF6906DC2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHJlcGx5Lg0KSSB3aWxsIGFkZCB0aGlzIGluIHRoZSBuZXh0IHZlcnNp
b24uDQpPbiBXZWQsIDIwMjAtMDgtMTIgYXQgMTI6MDcgKzAyMDAsIEZyYW5rIFd1bmRlcmxpY2gg
d3JvdGU6DQo+ID4gR2VzZW5kZXQ6IE1pdHR3b2NoLCAxMi4gQXVndXN0IDIwMjAgdW0gMTE6Mzcg
VWhyDQo+ID4gVm9uOiAiV2VuYmluIE1laSIgPHdlbmJpbi5tZWlAbWVkaWF0ZWsuY29tPg0KPiA+
IEJldHJlZmY6IFtQQVRDSCAzLzNdIG1tYzogbWVkaWF0ZWs6IGFkZCBvcHRpb25hbCBtb2R1bGUg
cmVzZXQgcHJvcGVydHkNCj4gDQo+ID4gVGhpcyBwYXRjaCBhZGRzIGEgb3B0aW9uYWwgcmVzZXQg
bWFuYWdlbWVudCBmb3IgbXNkYy4NCj4gPiBTb21ldGltZXMgdGhlIGJvb3Rsb2FkZXIgZG9lcyBu
b3QgYnJpbmcgbXNkYyByZWdpc3Rlcg0KPiA+IHRvIGRlZmF1bHQgc3RhdGUsIHNvIG5lZWQgcmVz
ZXQgdGhlIG1zZGMgY29udHJvbGxlci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFdlbmJpbiBN
ZWkgPHdlbmJpbi5tZWlAbWVkaWF0ZWsuY29tPg0KPiANCj4gVGhhbmtzIGZvciBwb3N0aW5nIHRo
ZSBmaXggdG8gTWFpbmxpbmUNCj4gDQo+IGltaG8gdGhpcyBzaG91bGQgY29udGFpbiBhIGZpeGVz
LVRhZyBhcyBpdCBmaXhlcyBlTU1DLUFjY2VzcyBvbiBtdDc2MjIvQnBpLVI2NA0KPiANCj4gYmVm
b3JlIHdlIGdvdCB0aGVzZSBFcnJvcnMgb24gbW91bnRpbmcgZU1NQyBpb24gUjY0Og0KPiANCj4g
WyAgIDQ4LjY2NDkyNV0gYmxrX3VwZGF0ZV9yZXF1ZXN0OiBJL08gZXJyb3IsIGRldiBtbWNibGsw
LCBzZWN0b3IgMjA0ODAwIG9wIDB4MTooV1JJVEUpIGZsYWdzIDB4ODAwIHBoeXNfc2VnIDEgcHJp
byBjbGFzcyAwDQo+IFsgICA0OC42NzYwMTldIEJ1ZmZlciBJL08gZXJyb3Igb24gZGV2IG1tY2Js
azBwMSwgbG9naWNhbCBibG9jayAwLCBsb3N0IHN5bmMgcGFnZSB3cml0ZQ0KPiANCj4gRml4ZXM6
IDk2NjU4MGFkMjM2ZSAoIm1tYzogbWVkaWF0ZWs6IGFkZCBzdXBwb3J0IGZvciBNVDc2MjIgU29D
IikNCj4gVGVzdGVkLUJ5OiBGcmFuayBXdW5kZXJsaWNoIDxmcmFuay13QHB1YmxpYy1maWxlcy5k
ZT4NCj4gDQo+IGFuZCBpdCBuZWVkcyB0byBiZSBmaXhlZCBhdCBsZWFzdCBmb3IgNS40Kywgc28g
YWRkaW5nIHN0YWJsZS1DQw0KPiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCg0K

