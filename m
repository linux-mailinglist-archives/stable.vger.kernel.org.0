Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E7CDAF99
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 16:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388749AbfJQOQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 10:16:20 -0400
Received: from mail-eopbgr50118.outbound.protection.outlook.com ([40.107.5.118]:15933
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729632AbfJQOQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 10:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUIJinsW06WqyWJjmTN/HKSy8im1IDylaOqBpPZRmbaEWYXZehWtKZy2u3Ypl/zWJOCv0Kx5O5UonWWRmAmj83f92K0AHoCGDF9d2TbhAoIUDn5IuLd7QQIJqnd61SbDhV6BVlOEgyUmq0g4iMu13OBDDPdYB4lRhC39+HjaTC2R8OPPyQ6TUCwzSW0+LLTYTPA2B5aR9sFMOA8/GkT4MmJk25gyf3D830f9dDzHr4p+kxK/enloAFXnrxxM+xP1Es7SMULh3RvyeFk8iszXCRg/Jr/UJe8ID6CcDY53L2tafh2Q2NhJxzQi4GZM/GATJP+D02trQTjopmUkJSxFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cyf2DUTJY9QBoGckdC0rQEfdvuXF2el+Tpz1592WiMk=;
 b=NcUiaD/6ksH/xUA2Z/o0uV7LkmrqoJR1emdwqg3ToF6Uff/zuB+XNedjAWyc2nuTheLH66ihksPCoVO8KhxOczB3BMfg1txpjO6U7PzXdO2TZmQImy3FWopRDXE6OC8majN1PIbnu2kNrEypETbilv+xPc+jXZTLd8JauXEGiYVIhr4wLSi+jMsSfhf23ckblmRAyzjYjCCtyp/uR238fXfNofV+wDP+/6lI6dGT5D1gTAXctgSPiYuS5UoleAcw/Cjty55+8N6q7UrzyALqmJ/H/bb1+EbD3YTGlCCEHXO2iIYj3o3o9M5Z1WBVnQS1+HvD0/zVDX9I7YEtoZNCCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cyf2DUTJY9QBoGckdC0rQEfdvuXF2el+Tpz1592WiMk=;
 b=RsjVsTLWxCbw6hjL8cyDQJ5bWcDYgwUqditDTmqXqkARCourxsBbOui9/HcWe/7JUUJ4OC8hsmCzORM+Qp+GTGDcMRTi4jMcxPwjYlBJJKlqhk6IBPK0aFzwjl2NPwyI5ewQ2IMaGVxY+odrhPifEETwhuMM/svijPro9A+MDyM=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.212) by
 AM6PR05MB5702.eurprd05.prod.outlook.com (20.178.86.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 14:16:09 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35%5]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 14:16:09 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     "broonie@kernel.org" <broonie@kernel.org>
CC:     "festevam@gmail.com" <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Thread-Topic: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Thread-Index: AQHVhPVsKAZEluJB9E6wNlSBYDJtdQ==
Date:   Thu, 17 Oct 2019 14:16:09 +0000
Message-ID: <b90f4cfc04686a669d145b5c5e7e59e2edf58779.camel@toradex.com>
References: <20191016214844.038848564@linuxfoundation.org>
         <20191016214907.599726506@linuxfoundation.org>
         <20191016220044.GB11473@sirena.co.uk> <20191016221025.GA990599@kroah.com>
         <20191016223518.GC11473@sirena.co.uk> <20191016232358.GA994597@kroah.com>
         <de9630e5-341f-b48d-029a-ef1a516bf820@skidata.com>
         <AM6PR05MB653568E379699EE907E146BDF96D0@AM6PR05MB6535.eurprd05.prod.outlook.com>
         <CAGgjyvFQQ4E5VfZ3nwFu+7UiGOmkyXK-n9PHjo1p=iYNX5JrPw@mail.gmail.com>
         <20191017111122.GA4976@sirena.co.uk>
In-Reply-To: <20191017111122.GA4976@sirena.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 534bbcca-a223-493b-d345-08d7530c8ebb
x-ms-traffictypediagnostic: AM6PR05MB5702:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB57024A7F84C03B433F052981F96D0@AM6PR05MB5702.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(376002)(39850400004)(396003)(366004)(199004)(189003)(256004)(446003)(2351001)(36756003)(6486002)(11346002)(4326008)(3846002)(6116002)(6436002)(118296001)(86362001)(4001150100001)(66446008)(102836004)(7736002)(229853002)(305945005)(71190400001)(71200400001)(6512007)(2906002)(44832011)(8936002)(66476007)(6506007)(76176011)(91956017)(26005)(66556008)(64756008)(186003)(8676002)(81156014)(1730700003)(2616005)(486006)(5660300002)(316002)(5640700003)(476003)(107886003)(6916009)(81166006)(478600001)(99286004)(54906003)(76116006)(66946007)(6246003)(66066001)(25786009)(2501003)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB5702;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JYworj2tPsLgiBTh7267eXBL/0+v9vxZnUlOQdIRXRWBC+juOAcS8gRmT22q7wcjkVL7poeMj4fpgeThdd6mW2HWCpB7nWpbeDXPeTiIUYQpT1l26uMjoBaOGQXL3EtQNJQFN4C5zn8ISZ9p1T4s7uGqfTvcs8d3eoU8/kxVUTeaIw9tkP7vFIASf2i0l5IzicOKweAJJEyUo2vdsynqf88Xe/CmgB/Dhh0ChhfxaW8gFlqgsw7tg/Zld1b70hfgp9m6vYSEcM/4tkMBYXr0SiU9Hgb7sLPtrdcpu7NHTF0sNk4kfEYPxEKTx7kA3dh/qOvBe41e1lJhWYVbKg5FMsiL+QFuO+prq6xcxJlTTWE1Sqcdx5V+e+H4F2S6srz9FQ3nhtR41iAfcJpOkKxGTukwozW0l9cGro/6CVsF6DM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE1778185AC43F40B85765266DC164FB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534bbcca-a223-493b-d345-08d7530c8ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 14:16:09.3662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FBv4Wn9G7x0HuiunsPVD2fv519fo3LkT8xVMfyRb2OuMwOmEtdmhL+HzPF9arH0FwZvlhpe+tQ0tw+NGrKKyEVlo4S80KZuGit5UPUGuMSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5702
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDE5LTEwLTE3IGF0IDEyOjExICswMTAwLCBNYXJrIEJyb3duIHdyb3RlOg0KPiBP
biBUaHUsIE9jdCAxNywgMjAxOSBhdCAwOTo0OToyN0FNICswMDAwLCBPbGVrc2FuZHIgU3V2b3Jv
diB3cm90ZToNCj4gDQo+ID4gTWFyaywgb2J2aW91c2x5IHRoaXMgaXMgbm90IGEgTkVXIGZlYXR1
cmUuIFRoaXMgcGF0Y2ggYWRkcyBMT1NUDQo+ID4gc3RhbmRhcmQgY29udHJvbC4NCj4gDQo+IEl0
J3MgYSBuZXcgZmVhdHVyZSBmb3IgdGhpcyBDT0RFQyB0byBoYXZlIGNvbnRyb2wgb3ZlciB0aGUg
Y2FwdHVyZQ0KPiBtdXRlLA0KPiBvdGhlciBkZXZpY2VzIGhhdmUgb2YgY291cnNlIGhhZCBjb250
cm9sIG92ZXIgaXQgZm9yIGEgbG9uZyB0aW1lIGJ1dA0KPiBmb3INCj4gdGhpcyBkZXZpY2UgaXQn
cyBhIG5ldyBmZWF0dXJlLg0KDQoNCkFsbCB2ZXJzaW9ucyBvZiBkcml2ZXIgc2d0bDUwMDAgKHNp
bmNlIGNyZWF0aW5nIGluIDIwMTEpIGhhcyBhIGJ1ZyBpbg0Kc2d0bDUwMDBfcHJvYmUoKToNCi4u
Lg0KICAgICAgIHNuZF9zb2Nfd3JpdGUoY29kZWMsIFNHVEw1MDAwX0NISVBfQU5BX0NUUkwsDQog
ICAgICAgICAgICAgICAgICAgICAgIFNHVEw1MDAwX0hQX1pDRF9FTiB8DQogICAgICAgICAgICAg
ICAgICAgICAgIFNHVEw1MDAwX0FEQ19aQ0RfRU4pOw0KLi4uDQpUaGlzIGNvbW1hbmQgcmV3cml0
ZXMgdGhlIHdob2xlIHJlZ2lzdGVyIHZhbHVlIGluc3RlYWQgb2YganVzdCBlbmFibGluZw0KWkNE
IGZlYXR1cmUgZm9yIGhlYWRwaG9uZSBhbmQgYWRjLg0KDQpUaGlzIHJlZ2lzdGVyIGhhcyBiaXRz
IGZvciBIUC9MaW5lT3V0L0FEQyBtdXRpbmcsIHRodXMgc2d0bDUwMDBfcHJvYmUoKQ0KYWx3YXlz
IHVubXV0ZXMgSFAvTGluZU91dC9BREMuDQoNCkJlY2F1c2Ugb2YgdGhpcyBidWcsIEhQL0xpbmVP
dXQvQURDIHNvbWVob3cgd29ya2VkIHNldmVyYWwgeWVhcnM6IHRoZXNlDQpibG9ja3MgdW5tdXRl
ZCB1cG9uIHRoZSBwcm9iaW5nIG9mIGRldmljZSBhbmQgbmV2ZXIgbXV0ZWQgYWdhaW4uDQoNCkFu
ZCB0aGV5IGNvdWxkIG5vdCBiZSBtdXRlZC91bm11dGVkIC0gdGhlcmUgd2VyZSBubyBjb250cm9s
cyBmb3IgdGhhdC4NCg0KWyBJTUhPIHVuYWJsaW5nIG11dGUvdW5tdXRlIG9mIG1haW4gY29kZWMg
Y29tcG9uZW50cyBpcyBhIGJ1ZyB0b28gXS4NCg0KT24gMjAxNiwgdGhlIGNvbW1pdCA5MDRhOTg3
MzQ1MjU4IHdhcyBpbnRyb2R1Y2VkIGFuZCBhZGRlZCBhbiBhYmlsaXR5DQp0byBtdXRlL3VubXV0
ZSBIUC9MaW5lT3V0LCBidXQgbm90IEFEQyB1bmZvcnR1bmF0ZWx5Lg0KDQpPbiB0aGUgb3RoZXIg
aGFuZCwgdGhlIGJ1ZyBpbiBzZ3RsNTAwMF9wcm9iZSgpIChIUC9MaW5lT3V0L0FEQw0KdW5tdXRp
bmcpIGxlYWRzIHRvICJwb3AiIHNvdW5kIG9uIGRyaXZlciBsb2FkaW5nIChhY2NvcmRpbmcgdG8g
c2d0bDUwMDANCm1hbnVhbCwgYm90aCBIUC9MaW5lT3V0IHNob3VsZCBiZSBtdXRlZCB1cG9uIGRl
dmljZSBpbml0aWFsaXphdGlvbikuDQoNClRoZSBidWdmaXggNjMxYmM4ZjAxMzRhZSBzaG91bGQg
YmUgYXBwbGllZCBvbmx5IGFmdGVyIDkwNGE5ODczNDUyNTggKw0KNjk0YjE0NTU0ZDc1Zi4NCg0K
U28gSSBzZWUgMyB3YXlzOg0KDQoxLiBkcm9wIHRoaXMgcGF0Y2ggYW5kIHJldmVydCA2MzFiYzhm
MDEzNGFlIGluIHN0YWJsZSB2ZXJzaW9ucyA0LjE5LA0KNS4yLCA1LjMuDQpTbyB0aGUgYnVnIHdp
dGggdW5tdXRpbmcgYWxsIG91dHB1dHMgYW5kIEFEQyBvbiBkZXZpY2UgcHJvYmluZyB3aWxsDQpz
dGlsbCBwcmVzZW50IGluIGFsbCBrZXJuZWwgdmVyc2lvbnMgdGhhdCBpbmNsdWRlIHNndGw1MDAg
Y29kZWMgZHJpdmVyLg0KDQoyLiBrZWVwIDYzMWJjOGYwMTM0YWUgYW5kIGFkZCA2OTRiMTQ1NTRk
NzVmIHRvIDQuMTksIDUuMiBhbmQgNS4zLg0KDQozLiBhZGQgNjMxYmM4ZjAxMzRhZSB0byA0LjQs
IDQuOSBhbmQgNC4xNA0KICAgYWRkIDY5NGIxNDU1NGQ3NWYgdG8gNC40LTUuMw0KICAgYWRkIDkw
NGE5ODczNDUyNTggdG8gNC40DQpTbyB0aGlzIGJ1ZyB3aWxsIGJlIGZpeGVkIGluIGFsbCBzdXBw
b3J0ZWQgdmVyc2lvbnMuDQoNCg==
