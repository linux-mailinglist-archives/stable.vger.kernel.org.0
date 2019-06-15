Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6A046D3C
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 02:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbfFOAf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 20:35:57 -0400
Received: from mail-eopbgr760098.outbound.protection.outlook.com ([40.107.76.98]:63921
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbfFOAf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 20:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtyODL06gkmTfkzdYbi/wXOAXPrFJTVpwR2UoctfAlA=;
 b=lcxBgVNeTDV8Sa8qkHRFYx/ndDUXaU7Qu1oahstSvqFWJwrvacxyr1qmVrgqvkKfJbZ4vvGvoJG+iote7dtUDiS/N3ZypfQq0FlBz2VZ0Z+cF1X2J96dHk/EbTxvk1DLyEtVJbBLCCqS16ckewYYitKxy8gsHcShGOQfqcD4Njo=
Received: from CY4PR22MB0245.namprd22.prod.outlook.com (10.169.184.140) by
 CY4PR22MB0055.namprd22.prod.outlook.com (10.169.181.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Sat, 15 Jun 2019 00:35:40 +0000
Received: from CY4PR22MB0245.namprd22.prod.outlook.com
 ([fe80::485f:8a3b:54d1:5bce]) by CY4PR22MB0245.namprd22.prod.outlook.com
 ([fe80::485f:8a3b:54d1:5bce%4]) with mapi id 15.20.1987.013; Sat, 15 Jun 2019
 00:35:39 +0000
From:   Dmitry Korotin <dkorotin@wavecomp.com>
To:     Paul Burton <pburton@wavecomp.com>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dmitry Korotin <dkorotin@wavecomp.com>
Subject: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Topic: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Index: AQHVIxJBW2AHYf1PYUy4ub6PviN/IQ==
Date:   Sat, 15 Jun 2019 00:35:39 +0000
Message-ID: <CY4PR22MB02453FCB184A7ED1534D0C2CAFE90@CY4PR22MB0245.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::15) To CY4PR22MB0245.namprd22.prod.outlook.com
 (2603:10b6:903:11::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dkorotin@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [216.35.128.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 288bc447-f138-4e69-8c5c-08d6f129638f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR22MB0055;
x-ms-traffictypediagnostic: CY4PR22MB0055:
x-microsoft-antispam-prvs: <CY4PR22MB005538D4CD3622B0C7016201AFE90@CY4PR22MB0055.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(39850400004)(376002)(136003)(189003)(199004)(3846002)(99286004)(6116002)(52116002)(8936002)(74316002)(8676002)(2906002)(478600001)(14454004)(305945005)(66066001)(81156014)(7696005)(86362001)(68736007)(7736002)(81166006)(476003)(386003)(450100002)(4326008)(66946007)(102836004)(73956011)(486006)(71190400001)(14444005)(256004)(66556008)(6506007)(66446008)(64756008)(186003)(66476007)(6636002)(6436002)(52536014)(9686003)(33656002)(54906003)(26005)(107886003)(25786009)(316002)(55016002)(71200400001)(6862004)(53936002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR22MB0055;H:CY4PR22MB0245.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 544H2ivo4V5R60tnfSGvFFZiH8cgoc5f97A0KFdXMI+pmGa31hsqxIQxeJ2yS6rVFiWIBjEDyXxeUpqD0C1qc/EfnXnwp5+GLjGgidbuEkJnOwl/UVqFV4rZuQc+YSKOM5sdmlHifIajvXQBpjc6iOkElXYayM1881UayCkMX7iwBTJz47iAN9b/7kxDFkh8UDKXN+VaG8tfmj+FC+W6d5eRIHXcr4EaQDkVmm6Zwlj5H6oK+zQqKya8rUB2bpRoRUExTGf62vU5Dph5kJNPE7nykvBWmXKe8vi55+esEadAgwOeOnv9S5gsQ4wGaK1BwwHgdbNXdX3nP4qRaKQSufRZJRosL0u2893lvnqHfSLwpx7//pJ9Vv370T3IAVfMritP8/Ea97s/eSsQxxZSPpD3JtOWIO0Jz5C3NNUjBLg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wavecomp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288bc447-f138-4e69-8c5c-08d6f129638f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 00:35:39.9109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dkorotin@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR22MB0055
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ICAgIEFkZGVkIG1pc3NpbmcgRUhCIChFeGVjdXRpb24gSGF6YXJkIEJhcnJpZXIpIGluIG10YzAg
LT4gbWZjMCBzZXF1ZW5jZS4NCiAgICBNaXBzIGRvY3VtZW50YXRpb24gVm9sdW1lIElJSSAocmV2
IDYuMDMpIHRhYmxlIDguMS4NCg0KU2lnbmVkLW9mZi1ieTogRG1pdHJ5IEtvcm90aW4gPGRrb3Jv
dGluQHdhdmVjb21wLmNvbT4NCi0tLQ0KIGFyY2gvbWlwcy9tbS90bGJleC5jIHwgICAzMiArKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQ0KIDEgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0
aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9hcmNoL21pcHMvbW0vdGxi
ZXguYyBiL2FyY2gvbWlwcy9tbS90bGJleC5jDQppbmRleCA2NWI2ZTg1Li5iZjdmMTMxIDEwMDY0
NA0KLS0tIGEvYXJjaC9taXBzL21tL3RsYmV4LmMNCisrKyBiL2FyY2gvbWlwcy9tbS90bGJleC5j
DQpAQCAtMzkxLDYgKzM5MSw3IEBAIHN0YXRpYyBzdHJ1Y3Qgd29ya19yZWdpc3RlcnMgYnVpbGRf
Z2V0X3dvcmtfcmVnaXN0ZXJzKHUzMiAqKnApDQogc3RhdGljIHZvaWQgYnVpbGRfcmVzdG9yZV93
b3JrX3JlZ2lzdGVycyh1MzIgKipwKQ0KIHsNCiAJaWYgKHNjcmF0Y2hfcmVnID49IDApIHsNCisJ
CXVhc21faV9laGIocCk7DQogCQlVQVNNX2lfTUZDMChwLCAxLCBjMF9rc2NyYXRjaCgpLCBzY3Jh
dGNoX3JlZyk7DQogCQlyZXR1cm47DQogCX0NCkBAIC02NjgsMTAgKzY2OSwxMiBAQCBzdGF0aWMg
dm9pZCBidWlsZF9yZXN0b3JlX3BhZ2VtYXNrKHUzMiAqKnAsIHN0cnVjdCB1YXNtX3JlbG9jICoq
ciwNCiAJCQl1YXNtX2lfbXRjMChwLCAwLCBDMF9QQUdFTUFTSyk7DQogCQkJdWFzbV9pbF9iKHAs
IHIsIGxpZCk7DQogCQl9DQotCQlpZiAoc2NyYXRjaF9yZWcgPj0gMCkNCisJCWlmIChzY3JhdGNo
X3JlZyA+PSAwKSB7DQorCQkJdWFzbV9pX2VoYihwKTsNCiAJCQlVQVNNX2lfTUZDMChwLCAxLCBj
MF9rc2NyYXRjaCgpLCBzY3JhdGNoX3JlZyk7DQotCQllbHNlDQorCQl9IGVsc2Ugew0KIAkJCVVB
U01faV9MVyhwLCAxLCBzY3JhdGNocGFkX29mZnNldCgwKSwgMCk7DQorCQl9DQogCX0gZWxzZSB7
DQogCQkvKiBSZXNldCBkZWZhdWx0IHBhZ2Ugc2l6ZSAqLw0KIAkJaWYgKFBNX0RFRkFVTFRfTUFT
SyA+PiAxNikgew0KQEAgLTkzOCwxMCArOTQxLDEyIEBAIHZvaWQgYnVpbGRfZ2V0X3BtZGU2NCh1
MzIgKipwLCBzdHJ1Y3QgdWFzbV9sYWJlbCAqKmwsIHN0cnVjdCB1YXNtX3JlbG9jICoqciwNCiAJ
CXVhc21faV9qcihwLCBwdHIpOw0KIA0KIAkJaWYgKG1vZGUgPT0gcmVmaWxsX3NjcmF0Y2gpIHsN
Ci0JCQlpZiAoc2NyYXRjaF9yZWcgPj0gMCkNCisJCQlpZiAoc2NyYXRjaF9yZWcgPj0gMCkgew0K
KwkJCQl1YXNtX2lfZWhiKHApOw0KIAkJCQlVQVNNX2lfTUZDMChwLCAxLCBjMF9rc2NyYXRjaCgp
LCBzY3JhdGNoX3JlZyk7DQotCQkJZWxzZQ0KKwkJCX0gZWxzZSB7DQogCQkJCVVBU01faV9MVyhw
LCAxLCBzY3JhdGNocGFkX29mZnNldCgwKSwgMCk7DQorCQkJfQ0KIAkJfSBlbHNlIHsNCiAJCQl1
YXNtX2lfbm9wKHApOw0KIAkJfQ0KQEAgLTEyNTgsNiArMTI2Myw3IEBAIHN0cnVjdCBtaXBzX2h1
Z2VfdGxiX2luZm8gew0KIAlVQVNNX2lfTVRDMChwLCBvZGQsIEMwX0VOVFJZTE8xKTsgLyogbG9h
ZCBpdCAqLw0KIA0KIAlpZiAoYzBfc2NyYXRjaF9yZWcgPj0gMCkgew0KKwkJdWFzbV9pX2VoYihw
KTsNCiAJCVVBU01faV9NRkMwKHAsIHNjcmF0Y2gsIGMwX2tzY3JhdGNoKCksIGMwX3NjcmF0Y2hf
cmVnKTsNCiAJCWJ1aWxkX3RsYl93cml0ZV9lbnRyeShwLCBsLCByLCB0bGJfcmFuZG9tKTsNCiAJ
CXVhc21fbF9sZWF2ZShsLCAqcCk7DQpAQCAtMTYwMywxNSArMTYwOSwxOSBAQCBzdGF0aWMgdm9p
ZCBidWlsZF9zZXR1cF9wZ2Qodm9pZCkNCiAJCXVhc21faV9kaW5zbSgmcCwgYTAsIDAsIDI5LCA2
NCAtIDI5KTsNCiAJCXVhc21fbF90bGJsX2dvYXJvdW5kMSgmbCwgcCk7DQogCQlVQVNNX2lfU0xM
KCZwLCBhMCwgYTAsIDExKTsNCi0JCXVhc21faV9qcigmcCwgMzEpOw0KIAkJVUFTTV9pX01UQzAo
JnAsIGEwLCBDMF9DT05URVhUKTsNCisJCXVhc21faV9laGIoJnApOw0KKwkJdWFzbV9pX2pyKCZw
LCAzMSk7DQorCQl1YXNtX2lfbm9wKCZwKTsNCiAJfSBlbHNlIHsNCiAJCS8qIFBHRCBpbiBjMF9L
U2NyYXRjaCAqLw0KLQkJdWFzbV9pX2pyKCZwLCAzMSk7DQogCQlpZiAoY3B1X2hhc19sZHB0ZSkN
CiAJCQlVQVNNX2lfTVRDMCgmcCwgYTAsIEMwX1BXQkFTRSk7DQogCQllbHNlDQogCQkJVUFTTV9p
X01UQzAoJnAsIGEwLCBjMF9rc2NyYXRjaCgpLCBwZ2RfcmVnKTsNCisJCXVhc21faV9laGIoJnAp
Ow0KKwkJdWFzbV9pX2pyKCZwLCAzMSk7DQorCQl1YXNtX2lfbm9wKCZwKTsNCiAJfQ0KICNlbHNl
DQogI2lmZGVmIENPTkZJR19TTVANCkBAIC0xNjI1LDEzICsxNjM1LDE1IEBAIHN0YXRpYyB2b2lk
IGJ1aWxkX3NldHVwX3BnZCh2b2lkKQ0KIAlVQVNNX2lfTEFfbW9zdGx5KCZwLCBhMiwgcGdkYyk7
DQogCVVBU01faV9TVygmcCwgYTAsIHVhc21fcmVsX2xvKHBnZGMpLCBhMik7DQogI2VuZGlmIC8q
IFNNUCAqLw0KLQl1YXNtX2lfanIoJnAsIDMxKTsNCiANCiAJLyogaWYgcGdkX3JlZyBpcyBhbGxv
Y2F0ZWQsIHNhdmUgUEdEIGFsc28gdG8gc2NyYXRjaCByZWdpc3RlciAqLw0KLQlpZiAocGdkX3Jl
ZyAhPSAtMSkNCisJaWYgKHBnZF9yZWcgIT0gLTEpIHsNCiAJCVVBU01faV9NVEMwKCZwLCBhMCwg
YzBfa3NjcmF0Y2goKSwgcGdkX3JlZyk7DQotCWVsc2UNCi0JCXVhc21faV9ub3AoJnApOw0KKwkJ
dWFzbV9pX2VoYigmcCk7DQorCX0NCisNCisJdWFzbV9pX2pyKCZwLCAzMSk7DQorCXVhc21faV9u
b3AoJnApOw0KICNlbmRpZg0KIAlpZiAocCA+PSAodTMyICopdGxibWlzc19oYW5kbGVyX3NldHVw
X3BnZF9lbmQpDQogCQlwYW5pYygidGxibWlzc19oYW5kbGVyX3NldHVwX3BnZCBzcGFjZSBleGNl
ZWRlZCIpOw0KLS0gDQoxLjcuMQ0KDQo=
