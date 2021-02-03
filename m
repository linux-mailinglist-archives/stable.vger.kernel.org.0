Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C66030D20A
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 04:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhBCDRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 22:17:23 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:58889 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhBCDOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 22:14:21 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1133DwdeE032343, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs01.realtek.com.tw[172.21.6.94])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 1133DwdeE032343
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 3 Feb 2021 11:13:58 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 11:13:58 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 11:13:58 +0800
Received: from RTEXMBS01.realtek.com.tw ([fe80::5d07:e256:a2a2:81ee]) by
 RTEXMBS01.realtek.com.tw ([fe80::5d07:e256:a2a2:81ee%5]) with mapi id
 15.01.2106.006; Wed, 3 Feb 2021 11:13:58 +0800
From:   =?big5?B?p2Sp/rzhIFJpY2t5?= <ricky_wu@realtek.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] misc: rtsx: modify rts522a init flow
Thread-Topic: [PATCH] misc: rtsx: modify rts522a init flow
Thread-Index: AQHW+VIadKdnxD2IaEOFj+RBUcrF36pERNUAgAF0JHA=
Date:   Wed, 3 Feb 2021 03:13:58 +0000
Message-ID: <c836b619b5da47c69165a738d7200014@realtek.com>
References: <20210202105641.29330-1-ricky_wu@realtek.com>
 <20210202122738.GA87016@bjorn-Precision-5520>
In-Reply-To: <20210202122738.GA87016@bjorn-Precision-5520>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.88.99]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmpvcm4gSGVsZ2FhcyA8
aGVsZ2Fhc0BrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAyLCAyMDIxIDg6
MjggUE0NCj4gVG86IKdkqf684SBSaWNreSA8cmlja3lfd3VAcmVhbHRlay5jb20+DQo+IENjOiBh
cm5kQGFybmRiLmRlOyBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsgeXVlaGFpYmluZ0BodWF3
ZWkuY29tOw0KPiB1bGYuaGFuc3NvbkBsaW5hcm8ub3JnOyBiaGVsZ2Fhc0Bnb29nbGUuY29tOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG1pc2M6IHJ0c3g6IG1vZGlmeSBydHM1MjJhIGluaXQgZmxv
dw0KPiANCj4gVGhlIHN1YmplY3QgbGluZSBjb3VsZCBiZSBtb3JlIGRlc2NyaXB0aXZlLiAgQWxs
IHBhdGNoZXMgbW9kaWZ5IHNvbWV0aGluZywgc28NCj4gdGhlIG9ubHkgcmVhbCBpbmZvcm1hdGlv
biBpdCBjb250YWlucyBpcyAicnRzNTIyYSIgYW5kICJpbml0Ii4gIE1heWJlIGl0IGNvdWxkDQo+
IHNheSBzb21ldGhpbmcgYWJvdXQgcG93ZXJpbmcgb2ZmIE9DUCAod2hhdGV2ZXIgdGhhdCBpcykg
d2hlbiBubyBtZW1vcnkNCj4gY2FyZCBpcyBwcmVzZW50Lg0KPiANCg0KT2ssIEkgd2lsbCB1cGRh
dGUgdGhlIHN1YmplY3QgbGluZSBhdCBWMiANCiJtaXNjOiBydHN4OiBpbml0IG9mIHJ0czUyMmEg
YWRkIHBvd2VyIG9mZiBPQ1Agd2hlbiBubyBjYXJkIGlzIHByZXNlbnQiDQoNCj4gT24gVHVlLCBG
ZWIgMDIsIDIwMjEgYXQgMDY6NTY6NDFQTSArMDgwMCwgcmlja3lfd3VAcmVhbHRlay5jb20gd3Jv
dGU6DQo+ID4gRnJvbTogUmlja3kgV3UgPHJpY2t5X3d1QHJlYWx0ZWsuY29tPg0KPiA+DQo+ID4g
UG93ZXIgZG93biBPQ1AgZm9yIHBvd2VyIGNvbnN1bXB0aW9uDQo+ID4gd2hlbiBjYXJkIGlzIG5v
dCBleGlzdCBhdCBpbml0X2h3KCkNCj4gDQo+IEkgYXNzdW1lICJjYXJkIGlzIG5vdCBleGlzdCIg
bWVhbnMgIm5vIFNEL01NQyBjYXJkIGlzIHByZXNlbnQiLg0KPiANCg0KUmlnaHQsIGl0J3MgdGhh
dCBtZWFucywgSSB3aWxsIG1vZGlmeSB0aGlzIGRlc2NyaXB0aW9uIGF0IFYyDQoNCj4gV2h5IGRv
IHlvdSBvbmx5IGRvIHRoaXMgZm9yIDUyMjc/ICAiY2FyZF9leGlzdCIgc2VlbXMgdG8gYmUgYSBn
ZW5lcmljDQo+IGNvbmNlcHQgKGl0J3MgaW4gc3RydWN0IHJ0c3hfcGNyIGFuZCBzZXQgYnkgdGhl
IGdlbmVyaWMgcnRzeF9wY2lfaW5pdF9odygpKS4NCj4gQ291bGQvc2hvdWxkIHRoaXMgYmUgZG9u
ZSBmb3Igb3RoZXIgY2FyZCByZWFkZXJzIGFzIHdlbGw/DQo+IA0KDQpPbmx5IHJ0czUyMmEgbmVl
ZCB0byBkbyB0aGlzLCBvdGhlciBjYXJkIHJlYWRlcnMgY2FuIGRvIEhXIGF1dG8gcG93ZXIgZG93
bg0KDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gDQo+IFBlciBodHRwczovL3d3
dy5rZXJuZWwub3JnL2RvYy9odG1sL3Y1LjEwL3Byb2Nlc3Mvc3RhYmxlLWtlcm5lbC1ydWxlcy5o
dG1sDQo+IChvcHRpb24gMSkgdGhpcyBpcyBzdWZmaWNpZW50LiAgWW91IHNob3VsZCBub3QgaW5j
bHVkZSBzdGFibGVAa2VybmVsLm9yZyBpbiB0aGUNCj4gY2M6IGxpc3QgYWJvdmUuDQo+IA0KDQpJ
IGFtIG5vdCB2ZXJ5IGNsZWFyLCBJIHdhbnQgdGhpcyBwYXRjaCB0byBTdGFibGUgdHJlZSwgc28g
SSBhZGRlZCB0aGlzIFRhZyhDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZykNCklmIEkgcmVtb3Zl
IHRoaXMgVGFnLCBpdCBtZWFucyB0aGlzIHBhdGNoIG5vdCBnbyB0byBTdGFibGUgVHJlZT8NCg0K
Umlja3kNCg0KPiA+IFNpZ25lZC1vZmYtYnk6IFJpY2t5IFd1IDxyaWNreV93dUByZWFsdGVrLmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9taXNjL2NhcmRyZWFkZXIvcnRzNTIyNy5jIHwgNSAr
KysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9taXNjL2NhcmRyZWFkZXIvcnRzNTIyNy5jDQo+ID4gYi9kcml2ZXJz
L21pc2MvY2FyZHJlYWRlci9ydHM1MjI3LmMNCj4gPiBpbmRleCA4ODU5MDExNjcyY2IuLjgyMDBh
ZjIyYjUyOSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL21pc2MvY2FyZHJlYWRlci9ydHM1MjI3
LmMNCj4gPiArKysgYi9kcml2ZXJzL21pc2MvY2FyZHJlYWRlci9ydHM1MjI3LmMNCj4gPiBAQCAt
Mzk4LDYgKzM5OCwxMSBAQCBzdGF0aWMgaW50IHJ0czUyMmFfZXh0cmFfaW5pdF9odyhzdHJ1Y3Qg
cnRzeF9wY3INCj4gPiAqcGNyKSAgew0KPiA+ICAJcnRzNTIyN19leHRyYV9pbml0X2h3KHBjcik7
DQo+ID4NCj4gPiArCS8qIFBvd2VyIGRvd24gT0NQIGZvciBwb3dlciBjb25zdW1wdGlvbiAqLw0K
PiA+ICsJaWYgKCFwY3ItPmNhcmRfZXhpc3QpDQo+ID4gKwkJcnRzeF9wY2lfd3JpdGVfcmVnaXN0
ZXIocGNyLCBGUERDVEwsIE9DX1BPV0VSX0RPV04sDQo+ID4gKwkJCQlPQ19QT1dFUl9ET1dOKTsN
Cj4gPiArDQo+ID4gIAlydHN4X3BjaV93cml0ZV9yZWdpc3RlcihwY3IsIEZVTkNfRk9SQ0VfQ1RM
LA0KPiBGVU5DX0ZPUkNFX1VQTUVfWE1UX0RCRywNCj4gPiAgCQlGVU5DX0ZPUkNFX1VQTUVfWE1U
X0RCRyk7DQo+ID4gIAlydHN4X3BjaV93cml0ZV9yZWdpc3RlcihwY3IsIFBDTEtfQ1RMLCAweDA0
LCAweDA0KTsNCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo+IA0KPiAtLS0tLS1QbGVhc2UgY29u
c2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
