Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA8B51B27
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfFXTFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 15:05:30 -0400
Received: from mail-eopbgr730101.outbound.protection.outlook.com ([40.107.73.101]:32693
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729938AbfFXTFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 15:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEWtISEi3ceKr5CAh9tUs2m//2DcRztIMh7H4BzaQo0=;
 b=G8KAoyjqCVaT6BoC7eImGTLRNZwnz3D1tiC7pNGehB/XXdM9JyGkIXjS4ZFSFgdb3JPTsvr/twp6rKVKYKur/pZGNyOnEtRJ5UtJQ74u1tAe316/dNa6y0nuPEpBG8dCxYoOxfdH1k2pO2gZ+3TDCvKM1hkIBx/K0yEo3kP1atk=
Received: from CY4PR22MB0245.namprd22.prod.outlook.com (10.169.184.140) by
 CY4PR22MB0373.namprd22.prod.outlook.com (10.173.191.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:05:27 +0000
Received: from CY4PR22MB0245.namprd22.prod.outlook.com
 ([fe80::485f:8a3b:54d1:5bce]) by CY4PR22MB0245.namprd22.prod.outlook.com
 ([fe80::485f:8a3b:54d1:5bce%4]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 19:05:27 +0000
From:   Dmitry Korotin <dkorotin@wavecomp.com>
To:     Paul Burton <pburton@wavecomp.com>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dmitry Korotin <dkorotin@wavecomp.com>
Subject: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Topic: [PATCH] Added missing EHB in mtc0 -> mfc0 sequence.
Thread-Index: AQHVKr/IJ/I3WfJb9EWmSHJfQfE2CA==
Date:   Mon, 24 Jun 2019 19:05:27 +0000
Message-ID: <CY4PR22MB0245F6CD97467AAB12E437A5AFE00@CY4PR22MB0245.namprd22.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:a03:60::14) To CY4PR22MB0245.namprd22.prod.outlook.com
 (2603:10b6:903:11::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dkorotin@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [216.35.128.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e92d2ee8-3f1a-41ae-5be5-08d6f8d6ea96
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR22MB0373;
x-ms-traffictypediagnostic: CY4PR22MB0373:
x-microsoft-antispam-prvs: <CY4PR22MB037334B7B39A64180F65BC95AFE00@CY4PR22MB0373.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39840400004)(376002)(366004)(136003)(346002)(189003)(199004)(81166006)(6506007)(8936002)(81156014)(386003)(476003)(66946007)(33656002)(53936002)(66476007)(107886003)(6862004)(68736007)(99286004)(14454004)(52536014)(5660300002)(450100002)(478600001)(4326008)(64756008)(25786009)(73956011)(66556008)(486006)(66446008)(7696005)(52116002)(14444005)(256004)(305945005)(3846002)(6116002)(26005)(2906002)(74316002)(7736002)(316002)(54906003)(8676002)(6436002)(186003)(71190400001)(86362001)(102836004)(71200400001)(55016002)(66066001)(9686003)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR22MB0373;H:CY4PR22MB0245.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pJ7WmfR3PnSxBX55lR8rD6Xtu31SETFVW5/uOTr1zWWQZ30kTjAW9Ndy/taRxMlhxwK50vzDb9+Upm3KfFU3hftSUWJppchE7I1wbsShV/ZpAXd72/9m5QY6NO5me+XEJvz5Co9WfQa9o+MXl8ZpZgKTEUZQLyaVShf1XZt9auCR/ui3zWdl68s+R+MU0acIl7Xg7whGNjxmm9DmFEDhdZhRhW2PQyP29zA/uYtNDXl9/1q/BMvEobti149j7kDX1lTVBK185TchM4QkPHg2EiBr9PKKFGfb/Jceec5Id3m5U1iM7v6f2eaIZiRE0abhHiyThXSytgUhnYO1JHZxG6WLXGegtJ2wDy6pG4PRskBmWwldcENgN97aDvY/iAm3oaKhBLpAhCGWhXoskCjADih2rDExAF/hyeX/WlWUXDk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wavecomp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92d2ee8-3f1a-41ae-5be5-08d6f8d6ea96
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:05:27.8089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dkorotin@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR22MB0373
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QWRkZWQgbWlzc2luZyBFSEIgKEV4ZWN1dGlvbiBIYXphcmQgQmFycmllcikgaW4gbXRjMCAtPiBt
ZmMwIHNlcXVlbmNlLg0KV2l0aG91dCB0aGlzIGV4ZWN1dGlvbiBoYXphcmQgYmFycmllciBpdCdz
IHBvc3NpYmxlIGZvciB0aGUgdmFsdWUgcmVhZA0KYmFjayBmcm9tIHRoZSBLU2NyYXRjaCByZWdp
c3RlciB0byBiZSB0aGUgdmFsdWUgZnJvbSBiZWZvcmUgdGhlIG10YzAuDQoNClJlcHJvZHVjaWFi
bGUgb24gUDU2MDAgJiBQNjYwMC4NCg0KTWlwcyBkb2N1bWVudGF0aW9uIFZvbHVtZSBJSUkgKHJl
diA2LjAzKSB0YWJsZSA4LjEuDQoNClNpZ25lZC1vZmYtYnk6IERtaXRyeSBLb3JvdGluIDxka29y
b3RpbkB3YXZlY29tcC5jb20+DQotLS0NCiBhcmNoL21pcHMvbW0vdGxiZXguYyB8ICAgMjkgKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0NCiAxIGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlv
bnMoKyksIDkgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9hcmNoL21pcHMvbW0vdGxiZXgu
YyBiL2FyY2gvbWlwcy9tbS90bGJleC5jDQppbmRleCA2NWI2ZTg1Li4xNDRjZWIwIDEwMDY0NA0K
LS0tIGEvYXJjaC9taXBzL21tL3RsYmV4LmMNCisrKyBiL2FyY2gvbWlwcy9tbS90bGJleC5jDQpA
QCAtMzkxLDYgKzM5MSw3IEBAIHN0YXRpYyBzdHJ1Y3Qgd29ya19yZWdpc3RlcnMgYnVpbGRfZ2V0
X3dvcmtfcmVnaXN0ZXJzKHUzMiAqKnApDQogc3RhdGljIHZvaWQgYnVpbGRfcmVzdG9yZV93b3Jr
X3JlZ2lzdGVycyh1MzIgKipwKQ0KIHsNCiAJaWYgKHNjcmF0Y2hfcmVnID49IDApIHsNCisJCXVh
c21faV9laGIocCk7DQogCQlVQVNNX2lfTUZDMChwLCAxLCBjMF9rc2NyYXRjaCgpLCBzY3JhdGNo
X3JlZyk7DQogCQlyZXR1cm47DQogCX0NCkBAIC02NjgsMTAgKzY2OSwxMiBAQCBzdGF0aWMgdm9p
ZCBidWlsZF9yZXN0b3JlX3BhZ2VtYXNrKHUzMiAqKnAsIHN0cnVjdCB1YXNtX3JlbG9jICoqciwN
CiAJCQl1YXNtX2lfbXRjMChwLCAwLCBDMF9QQUdFTUFTSyk7DQogCQkJdWFzbV9pbF9iKHAsIHIs
IGxpZCk7DQogCQl9DQotCQlpZiAoc2NyYXRjaF9yZWcgPj0gMCkNCisJCWlmIChzY3JhdGNoX3Jl
ZyA+PSAwKSB7DQorCQkJdWFzbV9pX2VoYihwKTsNCiAJCQlVQVNNX2lfTUZDMChwLCAxLCBjMF9r
c2NyYXRjaCgpLCBzY3JhdGNoX3JlZyk7DQotCQllbHNlDQorCQl9IGVsc2Ugew0KIAkJCVVBU01f
aV9MVyhwLCAxLCBzY3JhdGNocGFkX29mZnNldCgwKSwgMCk7DQorCQl9DQogCX0gZWxzZSB7DQog
CQkvKiBSZXNldCBkZWZhdWx0IHBhZ2Ugc2l6ZSAqLw0KIAkJaWYgKFBNX0RFRkFVTFRfTUFTSyA+
PiAxNikgew0KQEAgLTkzOCwxMCArOTQxLDEyIEBAIHZvaWQgYnVpbGRfZ2V0X3BtZGU2NCh1MzIg
KipwLCBzdHJ1Y3QgdWFzbV9sYWJlbCAqKmwsIHN0cnVjdCB1YXNtX3JlbG9jICoqciwNCiAJCXVh
c21faV9qcihwLCBwdHIpOw0KIA0KIAkJaWYgKG1vZGUgPT0gcmVmaWxsX3NjcmF0Y2gpIHsNCi0J
CQlpZiAoc2NyYXRjaF9yZWcgPj0gMCkNCisJCQlpZiAoc2NyYXRjaF9yZWcgPj0gMCkgew0KKwkJ
CQl1YXNtX2lfZWhiKHApOw0KIAkJCQlVQVNNX2lfTUZDMChwLCAxLCBjMF9rc2NyYXRjaCgpLCBz
Y3JhdGNoX3JlZyk7DQotCQkJZWxzZQ0KKwkJCX0gZWxzZSB7DQogCQkJCVVBU01faV9MVyhwLCAx
LCBzY3JhdGNocGFkX29mZnNldCgwKSwgMCk7DQorCQkJfQ0KIAkJfSBlbHNlIHsNCiAJCQl1YXNt
X2lfbm9wKHApOw0KIAkJfQ0KQEAgLTEyNTgsNiArMTI2Myw3IEBAIHN0cnVjdCBtaXBzX2h1Z2Vf
dGxiX2luZm8gew0KIAlVQVNNX2lfTVRDMChwLCBvZGQsIEMwX0VOVFJZTE8xKTsgLyogbG9hZCBp
dCAqLw0KIA0KIAlpZiAoYzBfc2NyYXRjaF9yZWcgPj0gMCkgew0KKwkJdWFzbV9pX2VoYihwKTsN
CiAJCVVBU01faV9NRkMwKHAsIHNjcmF0Y2gsIGMwX2tzY3JhdGNoKCksIGMwX3NjcmF0Y2hfcmVn
KTsNCiAJCWJ1aWxkX3RsYl93cml0ZV9lbnRyeShwLCBsLCByLCB0bGJfcmFuZG9tKTsNCiAJCXVh
c21fbF9sZWF2ZShsLCAqcCk7DQpAQCAtMTYwMywxNSArMTYwOSwxNyBAQCBzdGF0aWMgdm9pZCBi
dWlsZF9zZXR1cF9wZ2Qodm9pZCkNCiAJCXVhc21faV9kaW5zbSgmcCwgYTAsIDAsIDI5LCA2NCAt
IDI5KTsNCiAJCXVhc21fbF90bGJsX2dvYXJvdW5kMSgmbCwgcCk7DQogCQlVQVNNX2lfU0xMKCZw
LCBhMCwgYTAsIDExKTsNCi0JCXVhc21faV9qcigmcCwgMzEpOw0KIAkJVUFTTV9pX01UQzAoJnAs
IGEwLCBDMF9DT05URVhUKTsNCisJCXVhc21faV9qcigmcCwgMzEpOw0KKwkJdWFzbV9pX2VoYigm
cCk7DQogCX0gZWxzZSB7DQogCQkvKiBQR0QgaW4gYzBfS1NjcmF0Y2ggKi8NCi0JCXVhc21faV9q
cigmcCwgMzEpOw0KIAkJaWYgKGNwdV9oYXNfbGRwdGUpDQogCQkJVUFTTV9pX01UQzAoJnAsIGEw
LCBDMF9QV0JBU0UpOw0KIAkJZWxzZQ0KIAkJCVVBU01faV9NVEMwKCZwLCBhMCwgYzBfa3NjcmF0
Y2goKSwgcGdkX3JlZyk7DQorCQl1YXNtX2lfanIoJnAsIDMxKTsNCisJCXVhc21faV9laGIoJnAp
Ow0KIAl9DQogI2Vsc2UNCiAjaWZkZWYgQ09ORklHX1NNUA0KQEAgLTE2MjUsMTMgKzE2MzMsMTYg
QEAgc3RhdGljIHZvaWQgYnVpbGRfc2V0dXBfcGdkKHZvaWQpDQogCVVBU01faV9MQV9tb3N0bHko
JnAsIGEyLCBwZ2RjKTsNCiAJVUFTTV9pX1NXKCZwLCBhMCwgdWFzbV9yZWxfbG8ocGdkYyksIGEy
KTsNCiAjZW5kaWYgLyogU01QICovDQotCXVhc21faV9qcigmcCwgMzEpOw0KIA0KIAkvKiBpZiBw
Z2RfcmVnIGlzIGFsbG9jYXRlZCwgc2F2ZSBQR0QgYWxzbyB0byBzY3JhdGNoIHJlZ2lzdGVyICov
DQotCWlmIChwZ2RfcmVnICE9IC0xKQ0KKwlpZiAocGdkX3JlZyAhPSAtMSkgew0KIAkJVUFTTV9p
X01UQzAoJnAsIGEwLCBjMF9rc2NyYXRjaCgpLCBwZ2RfcmVnKTsNCi0JZWxzZQ0KKwkJdWFzbV9p
X2pyKCZwLCAzMSk7DQorCQl1YXNtX2lfZWhiKCZwKTsNCisJfSBlbHNlIHsNCisJCXVhc21faV9q
cigmcCwgMzEpOw0KIAkJdWFzbV9pX25vcCgmcCk7DQorCX0NCiAjZW5kaWYNCiAJaWYgKHAgPj0g
KHUzMiAqKXRsYm1pc3NfaGFuZGxlcl9zZXR1cF9wZ2RfZW5kKQ0KIAkJcGFuaWMoInRsYm1pc3Nf
aGFuZGxlcl9zZXR1cF9wZ2Qgc3BhY2UgZXhjZWVkZWQiKTsNCi0tIA0KMS43LjENCg0K
