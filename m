Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648BA2CD83
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfE1RV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 13:21:29 -0400
Received: from mail-eopbgr760093.outbound.protection.outlook.com ([40.107.76.93]:30413
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbfE1RV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 13:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jREHrBi4ue6x7A8F8FbrwYEPGd+JT0ytdNHyMQo2hqA=;
 b=A5rKkwFExu99Ki3JeCB6LR5UqDXE2eTGUUBSSj3lBx6oBkMYPknw1LUrIoqHMRu09IoehCy2nVqoHYPVFzPWchj/KtEVvKz/AjfRzjV27Nq1LT/lD+4qDDmB8Dspm33aq70N2JbzE79fHDzS0lf83RIgWGQ6ARPoXszEdiMhfFg=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.174.162.17) by
 MWHPR2201MB1439.namprd22.prod.outlook.com (10.174.169.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.23; Tue, 28 May 2019 17:21:26 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::90ff:8d19:8459:834b%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 17:21:26 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
CC:     Paul Burton <pburton@wavecomp.com>,
        Kevin Hilman <khilman@baylibre.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] MIPS: pistachio: Build uImage.gz by default
Thread-Topic: [PATCH] MIPS: pistachio: Build uImage.gz by default
Thread-Index: AQHVFXnH89+CQ67b4kKYpTCf9/D2IA==
Date:   Tue, 28 May 2019 17:21:26 +0000
Message-ID: <20190528172111.3843-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::19) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:24::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f11b1c5-1d68-4134-86b0-08d6e390ea15
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1439;
x-ms-traffictypediagnostic: MWHPR2201MB1439:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR2201MB1439DF27AF85C6E6C2F7D40AC11E0@MWHPR2201MB1439.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39830400003)(396003)(376002)(366004)(346002)(136003)(199004)(189003)(386003)(478600001)(26005)(99286004)(2616005)(476003)(52116002)(73956011)(6506007)(50226002)(64756008)(54906003)(66446008)(8936002)(66946007)(71200400001)(2906002)(71190400001)(66556008)(102836004)(44832011)(68736007)(66476007)(81156014)(4326008)(81166006)(25786009)(6916009)(2351001)(186003)(486006)(6486002)(5660300002)(8676002)(256004)(305945005)(36756003)(3846002)(1076003)(6512007)(6116002)(316002)(42882007)(14454004)(7736002)(53936002)(66066001)(2501003)(6306002)(6436002)(5640700003)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1439;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CMPD4+2sdU8P6uude5O34VIZOBYOpztRQGZWhNe9PjMoLj1blb3gih8L631NlcAZOWkPnjd/VJOS1OlSif5sFhbHt49qW36ooekRelHqwrHxsavibgAwAYtFK0bAGvzVJBtvpR3fzWiHW0Cm3STBfDDI/iTg2qX+J3aP85qQ2w9GxXlwFeiJiKXBzzXNFn260ap7j06c5JXGkwUKEDDlBVeF7iqbxhA1YjDydpwr0YIH0Ehh2fz/IHyiCs25Xc1Js8NU66YZXkQ8FU4vARs5SLBnxWGuqNY6P7I0hJiOBNOTlvUL/j4YAv2hdb5CFL8RgEj/mr6G9sq/dV+CrJ09jJJUVk0/FMWCK0K7lik9o8irdlfPhaSKb3OCZEalw3y7b72b08+JrA1mWQe5DxHb0mDtwnu08s2Bly86E2niLrA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f11b1c5-1d68-4134-86b0-08d6e390ea15
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 17:21:26.5382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1439
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlIHBpc3RhY2hpbyBwbGF0Zm9ybSB1c2VzIHRoZSBVLUJvb3QgYm9vdGxvYWRlciAmIGdlbmVy
YWxseSBib290cyBhDQprZXJuZWwgaW4gdGhlIHVJbWFnZSBmb3JtYXQuIEFzIHN1Y2ggaXQncyB1
c2VmdWwgdG8gYnVpbGQgb25lIHdoZW4NCmJ1aWxkaW5nIHRoZSBrZXJuZWwsIGJ1dCB0byBkbyBz
byBjdXJyZW50bHkgcmVxdWlyZXMgdGhlIHVzZXIgdG8NCm1hbnVhbGx5IHNwZWNpZnkgYSB1SW1h
Z2UgdGFyZ2V0IG9uIHRoZSBtYWtlIGNvbW1hbmQgbGluZS4NCg0KTWFrZSB1SW1hZ2UuZ3ogdGhl
IHBpc3RhY2hpbyBwbGF0Zm9ybSdzIGRlZmF1bHQgYnVpbGQgdGFyZ2V0LCBzbyB0aGF0DQp0aGUg
ZGVmYXVsdCBpcyB0byBidWlsZCBhIGtlcm5lbCBpbWFnZSB0aGF0IHdlIGNhbiBhY3R1YWxseSBi
b290IG9uIGENCmJvYXJkIHN1Y2ggYXMgdGhlIE1JUFMgQ3JlYXRvciBDaTQwLg0KDQpNYXJrZWQg
Zm9yIHN0YWJsZSBiYWNrcG9ydCBhcyBmYXIgYXMgdjQuMSB3aGVyZSBwaXN0YWNoaW8gc3VwcG9y
dCB3YXMNCmludHJvZHVjZWQuIFRoaXMgaXMgcHJpbWFyaWx5IHVzZWZ1bCBmb3IgQ0kgc3lzdGVt
cyBzdWNoIGFzIGtlcm5lbGNpLm9yZw0Kd2hpY2ggd2lsbCBiZW5lZml0IGZyb20gdXMgYnVpbGRp
bmcgYSBzdWl0YWJsZSBpbWFnZSB3aGljaCBjYW4gdGhlbiBiZQ0KYm9vdGVkIGFzIHBhcnQgb2Yg
YXV0b21hdGVkIHRlc3RpbmcsIGV4dGVuZGluZyBvdXIgdGVzdCBjb3ZlcmFnZSB0byB0aGUNCmFm
ZmVjdGVkIHN0YWJsZSBicmFuY2hlcy4NCg0KU2lnbmVkLW9mZi1ieTogUGF1bCBCdXJ0b24gPHBh
dWwuYnVydG9uQG1pcHMuY29tPg0KUmV2aWV3ZWQtYnk6IEtldmluIEhpbG1hbiA8a2hpbG1hbkBi
YXlsaWJyZS5jb20+DQpUZXN0ZWQtYnk6IEtldmluIEhpbG1hbiA8a2hpbG1hbkBiYXlsaWJyZS5j
b20+DQpVUkw6IGh0dHBzOi8vZ3JvdXBzLmlvL2cva2VybmVsY2kvbWVzc2FnZS8zODgNCkNjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnICMgdjQuMSsNCi0tLQ0KDQogYXJjaC9taXBzL3Bpc3RhY2hp
by9QbGF0Zm9ybSB8IDEgKw0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KDQpkaWZm
IC0tZ2l0IGEvYXJjaC9taXBzL3Bpc3RhY2hpby9QbGF0Zm9ybSBiL2FyY2gvbWlwcy9waXN0YWNo
aW8vUGxhdGZvcm0NCmluZGV4IGQ4MGNkNjEyZGYxZi4uYzM1OTJiMzc0YWQyIDEwMDY0NA0KLS0t
IGEvYXJjaC9taXBzL3Bpc3RhY2hpby9QbGF0Zm9ybQ0KKysrIGIvYXJjaC9taXBzL3Bpc3RhY2hp
by9QbGF0Zm9ybQ0KQEAgLTYsMyArNiw0IEBAIGNmbGFncy0kKENPTkZJR19NQUNIX1BJU1RBQ0hJ
TykJCSs9CQkJCVwNCiAJCS1JJChzcmN0cmVlKS9hcmNoL21pcHMvaW5jbHVkZS9hc20vbWFjaC1w
aXN0YWNoaW8NCiBsb2FkLSQoQ09ORklHX01BQ0hfUElTVEFDSElPKQkJKz0gMHhmZmZmZmZmZjgw
NDAwMDAwDQogemxvYWQtJChDT05GSUdfTUFDSF9QSVNUQUNISU8pCQkrPSAweGZmZmZmZmZmODEw
MDAwMDANCithbGwtJChDT05GSUdfTUFDSF9QSVNUQUNISU8pCQk6PSB1SW1hZ2UuZ3oNCi0tIA0K
Mi4yMS4wDQoNCg==
