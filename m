Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DC127A7D
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEWK17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:27:59 -0400
Received: from mail-eopbgr10099.outbound.protection.outlook.com ([40.107.1.99]:39552
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727434AbfEWK17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 06:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9N7U1hHB2+kFxwPdfDXjGNKDcsljba8pvupsN2BuNhI=;
 b=S9En+dM3MBY8OtW9dBp9e21UllEODPi+SXM546irUvHgkrDHLl0M6+EgIBVo54GQnvNnaixk0dEy+G+zpfV7rV21cgOzHl4TdKZnnZdR6zxmDV8HdTD/ukAOOBtnxGkKwaexUm8fiT7jn+0NBybq+JlqYsQZaUsocytYGMwo/yY=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (52.133.6.141) by
 HE1PR0702MB3546.eurprd07.prod.outlook.com (52.133.5.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.10; Thu, 23 May 2019 10:27:54 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::8c3f:5775:198e:e0e7]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::8c3f:5775:198e:e0e7%7]) with mapi id 15.20.1922.017; Thu, 23 May 2019
 10:27:54 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sdf@google.com" <sdf@google.com>
Subject: Re: [PATCH 4.19 144/187] selftests/bpf: skip verifier tests for
 unsupported program types
Thread-Topic: [PATCH 4.19 144/187] selftests/bpf: skip verifier tests for
 unsupported program types
Thread-Index: AQHU6sn8QVhCOWS0Hkay8JS9zuUSbKZ4zsWA
Date:   Thu, 23 May 2019 10:27:54 +0000
Message-ID: <16ec5436310b0df657a4898e3d15ccc3b9aab8e2.camel@nokia.com>
References: <20190404084603.119654039@linuxfoundation.org>
         <20190404084609.946908305@linuxfoundation.org>
In-Reply-To: <20190404084609.946908305@linuxfoundation.org>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fc85a63-cee4-4aa7-320e-08d6df69512b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:HE1PR0702MB3546;
x-ms-traffictypediagnostic: HE1PR0702MB3546:
x-microsoft-antispam-prvs: <HE1PR0702MB3546F7F424A606686762670CB4010@HE1PR0702MB3546.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(366004)(376002)(136003)(189003)(199004)(256004)(54906003)(99286004)(6486002)(26005)(14454004)(14444005)(8936002)(229853002)(486006)(316002)(186003)(11346002)(118296001)(110136005)(81166006)(81156014)(446003)(68736007)(476003)(8676002)(2616005)(478600001)(2906002)(66066001)(6116002)(3846002)(5660300002)(2501003)(53936002)(6246003)(86362001)(305945005)(102836004)(71190400001)(71200400001)(36756003)(6506007)(7736002)(25786009)(76176011)(73956011)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(6436002)(4326008)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3546;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XSBz7NKFpyK4K0yrrvj68AcsqgM4eMbbUCtfjG/0dXngKrzRDh4qFfx05/rZVWLL/mqvL/Qfa0Vc6x+w6XdeUT/9TwVuXAHoGwmRONBNL4bI2yjX9U4XyeIs09V5s3PfLxXFJ6gLsHlvMwNj4FRESOTDMG+A5qXKLuX7Ma9N7BcW8tG3zcH6bCpP3OYaZeWYk5eoA8OWBTy3nLkHRF4C7ZZ/MOE3Pnu4ETHCSs02Udv9G9kilKI/KInlaqtVDxyttkAXBry0nDeb2l7//5GM4jBWGaa/y0EdiUM0oOEV4pC7gixM+SObS2EwSdl6jJt+WWgw48NsedLeefRKUjovXRaiLIUibksVrIbxrgUJDx980BnBeW8zgdX6GY7gG0pS27aKZ9V7QcVaaLgKZ35kOl9wTHhZAo5bz/CAObCL9s4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D956D698EB78946BE2919F6A5506B36@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc85a63-cee4-4aa7-320e-08d6df69512b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 10:27:54.3950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tommi.t.rantala@nokia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3546
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDE5LTA0LTA0IGF0IDEwOjQ4ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IDQuMTktc3RhYmxlIHJldmlldyBwYXRjaC4gIElmIGFueW9uZSBoYXMgYW55IG9iamVj
dGlvbnMsIHBsZWFzZSBsZXQNCj4gbWUga25vdy4NCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLQ0K
PiANCj4gWyBVcHN0cmVhbSBjb21taXQgODE4NGQ0NGM5YTU3N2EyZjE4NDJlZDZjYzg0NGJmZDRh
OTk4MWQ4ZSBdDQo+IA0KPiBVc2UgcmVjZW50bHkgaW50cm9kdWNlZCBicGZfcHJvYmVfcHJvZ190
eXBlKCkgdG8gc2tpcCB0ZXN0cyBpbiB0aGUNCj4gdGVzdF92ZXJpZmllcigpIGlmIGJwZl92ZXJp
ZnlfcHJvZ3JhbSgpIGZhaWxzLiBUaGUgc2tpcHBlZCB0ZXN0IGlzDQo+IGluZGljYXRlZCBpbiB0
aGUgb3V0cHV0Lg0KDQpIaSwgdGhpcyBwYXRjaCBhZGRlZCBpbiA0LjE5LjM0IGNhdXNlcyB0ZXN0
X3ZlcmlmaWVyIGJ1aWxkIGZhaWx1cmUsIGFzDQpicGZfcHJvYmVfcHJvZ190eXBlKCkgaXMgbm90
IGF2YWlsYWJsZToNCg0KZ2NjIC1XYWxsIC1PMiAtSS4uLy4uLy4uL2luY2x1ZGUvdWFwaSAtSS4u
Ly4uLy4uL2xpYiAtSS4uLy4uLy4uL2xpYi9icGYNCi1JLi4vLi4vLi4vLi4vaW5jbHVkZS9nZW5l
cmF0ZWQgLURIQVZFX0dFTkhEUg0KLUkuLi8uLi8uLi9pbmNsdWRlICAgIHRlc3RfdmVyaWZpZXIu
YyAvcm9vdC9saW51eC0NCjQuMTkuNDQvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL2xpYmJw
Zi5hIC1sY2FwIC1sZWxmIC1scnQgLWxwdGhyZWFkDQotbyAvcm9vdC9saW51eC00LjE5LjQ0L3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3ZlcmlmaWVyDQp0ZXN0X3ZlcmlmaWVyLmM6
IEluIGZ1bmN0aW9uIOKAmGRvX3Rlc3Rfc2luZ2xl4oCZOg0KdGVzdF92ZXJpZmllci5jOjEyNzc1
OjIyOiB3YXJuaW5nOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbg0K4oCYYnBmX3By
b2JlX3Byb2dfdHlwZeKAmTsgZGlkIHlvdSBtZWFuIOKAmGJwZl9wcm9ncmFtX19zZXRfdHlwZeKA
mT8gWy0NCldpbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0NCiAgaWYgKGZkX3Byb2cgPCAw
ICYmICFicGZfcHJvYmVfcHJvZ190eXBlKHByb2dfdHlwZSwgMCkpIHsNCiAgICAgICAgICAgICAg
ICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn5+DQogICAgICAgICAgICAgICAgICAgICAgYnBmX3By
b2dyYW1fX3NldF90eXBlDQovdXNyL2Jpbi9sZDogL3RtcC9jY0V0eUxoay5vOiBpbiBmdW5jdGlv
biBgZG9fdGVzdF9zaW5nbGUnOg0KdGVzdF92ZXJpZmllci5jOigudGV4dCsweGExOSk6IHVuZGVm
aW5lZCByZWZlcmVuY2UgdG8NCmBicGZfcHJvYmVfcHJvZ190eXBlJw0KY29sbGVjdDI6IGVycm9y
OiBsZCByZXR1cm5lZCAxIGV4aXQgc3RhdHVzDQptYWtlWzFdOiAqKiogWy4uL2xpYi5tazoxNTI6
IC9yb290L2xpbnV4LQ0KNC4xOS40NC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF92
ZXJpZmllcl0gRXJyb3IgMQ0KDQoNCi0gVG9tbWkNCg0KPiBFeGFtcGxlOg0KPiANCj4gLi4uDQo+
IDY3OS9wIGJwZl9nZXRfc3RhY2sgcmV0dXJuIFIwIHdpdGhpbiByYW5nZSBTS0lQICh1bnN1cHBv
cnRlZCBwcm9ncmFtDQo+IHR5cGUgNSkNCj4gNjgwL3AgbGRfYWJzOiBpbnZhbGlkIG9wIDEgT0sN
Cj4gLi4uDQo+IFN1bW1hcnk6IDg2MyBQQVNTRUQsIDE2NSBTS0lQUEVELCAzIEZBSUxFRA0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogU3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogRGFuaWVsIEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4NCj4g
U2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiAtLS0NCj4g
IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3ZlcmlmaWVyLmMgfCA5ICsrKysrKysr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3ZlcmlmaWVy
LmMNCj4gYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF92ZXJpZmllci5jDQo+IGlu
ZGV4IDlkYjVhNzM3OGY0MC4uMjk0ZmMxOGFiYTJhIDEwMDY0NA0KPiAtLS0gYS90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF92ZXJpZmllci5jDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi90ZXN0X3ZlcmlmaWVyLmMNCj4gQEAgLTMyLDYgKzMyLDcgQEANCj4gICNp
bmNsdWRlIDxsaW51eC9pZl9ldGhlci5oPg0KPiAgDQo+ICAjaW5jbHVkZSA8YnBmL2JwZi5oPg0K
PiArI2luY2x1ZGUgPGJwZi9saWJicGYuaD4NCj4gIA0KPiAgI2lmZGVmIEhBVkVfR0VOSERSDQo+
ICAjIGluY2x1ZGUgImF1dG9jb25mLmgiDQo+IEBAIC01Niw2ICs1Nyw3IEBADQo+ICANCj4gICNk
ZWZpbmUgVU5QUklWX1NZU0NUTCAia2VybmVsL3VucHJpdmlsZWdlZF9icGZfZGlzYWJsZWQiDQo+
ICBzdGF0aWMgYm9vbCB1bnByaXZfZGlzYWJsZWQgPSBmYWxzZTsNCj4gK3N0YXRpYyBpbnQgc2tp
cHM7DQo+ICANCj4gIHN0cnVjdCBicGZfdGVzdCB7DQo+ICAJY29uc3QgY2hhciAqZGVzY3I7DQo+
IEBAIC0xMjc3MCw2ICsxMjc3MiwxMSBAQCBzdGF0aWMgdm9pZCBkb190ZXN0X3NpbmdsZShzdHJ1
Y3QgYnBmX3Rlc3QNCj4gKnRlc3QsIGJvb2wgdW5wcml2LA0KPiAgCWZkX3Byb2cgPSBicGZfdmVy
aWZ5X3Byb2dyYW0ocHJvZ190eXBlID8gOg0KPiBCUEZfUFJPR19UWVBFX1NPQ0tFVF9GSUxURVIs
DQo+ICAJCQkJICAgICBwcm9nLCBwcm9nX2xlbiwgdGVzdC0+ZmxhZ3MgJg0KPiBGX0xPQURfV0lU
SF9TVFJJQ1RfQUxJR05NRU5ULA0KPiAgCQkJCSAgICAgIkdQTCIsIDAsIGJwZl92bG9nLA0KPiBz
aXplb2YoYnBmX3Zsb2cpLCAxKTsNCj4gKwlpZiAoZmRfcHJvZyA8IDAgJiYgIWJwZl9wcm9iZV9w
cm9nX3R5cGUocHJvZ190eXBlLCAwKSkgew0KPiArCQlwcmludGYoIlNLSVAgKHVuc3VwcG9ydGVk
IHByb2dyYW0gdHlwZSAlZClcbiIsDQo+IHByb2dfdHlwZSk7DQo+ICsJCXNraXBzKys7DQo+ICsJ
CWdvdG8gY2xvc2VfZmRzOw0KPiArCX0NCj4gIA0KPiAgCWV4cGVjdGVkX3JldCA9IHVucHJpdiAm
JiB0ZXN0LT5yZXN1bHRfdW5wcml2ICE9IFVOREVGID8NCj4gIAkJICAgICAgIHRlc3QtPnJlc3Vs
dF91bnByaXYgOiB0ZXN0LT5yZXN1bHQ7DQo+IEBAIC0xMjkwNSw3ICsxMjkxMiw3IEBAIHN0YXRp
YyB2b2lkIGdldF91bnByaXZfZGlzYWJsZWQoKQ0KPiAgDQo+ICBzdGF0aWMgaW50IGRvX3Rlc3Qo
Ym9vbCB1bnByaXYsIHVuc2lnbmVkIGludCBmcm9tLCB1bnNpZ25lZCBpbnQgdG8pDQo+ICB7DQo+
IC0JaW50IGksIHBhc3NlcyA9IDAsIGVycm9ycyA9IDAsIHNraXBzID0gMDsNCj4gKwlpbnQgaSwg
cGFzc2VzID0gMCwgZXJyb3JzID0gMDsNCj4gIA0KPiAgCWZvciAoaSA9IGZyb207IGkgPCB0bzsg
aSsrKSB7DQo+ICAJCXN0cnVjdCBicGZfdGVzdCAqdGVzdCA9ICZ0ZXN0c1tpXTsNCg0K
