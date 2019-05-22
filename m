Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE2825BA9
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 03:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfEVBew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 21:34:52 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:24230
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbfEVBev (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 21:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9RBZMpkScmW0tmxR9D/1y3JO1wDPva9EwWy1bOkW9Y=;
 b=hA2GaKWw/YFQ/8t8Eqz3eDDj/ygUWC3moJRuPCTt2AGETsii8dKFF12s1OaenS8g1hde/DKdOsYGIODQqeRCDef36HP5EDffDguXNKmGS8v2176OUv1N4lqkyixnGZseOuMqIaGqgnOq6YPIzo5HY4VkfzgssC4b5lf0XiTlOg0=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB4147.eurprd04.prod.outlook.com (52.134.125.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Wed, 22 May 2019 01:34:47 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378%6]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 01:34:47 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to audio_pll2_out
Thread-Topic: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Thread-Index: AQHVED6JGbhPMl1ASUycBcbN9uhZig==
Date:   Wed, 22 May 2019 01:34:46 +0000
Message-ID: <20190522014832.29485-1-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.16.4
x-clientproxiedby: HK2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:202:2e::25) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3f2d4ee-26ea-441c-fb57-08d6de55aaa3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4147;
x-ms-traffictypediagnostic: AM0PR04MB4147:
x-microsoft-antispam-prvs: <AM0PR04MB41479692C944ED56D60F6E5C88000@AM0PR04MB4147.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(199004)(189003)(386003)(52116002)(102836004)(6506007)(2201001)(99286004)(86362001)(6512007)(25786009)(66476007)(66446008)(64756008)(66556008)(6436002)(6486002)(66946007)(73956011)(305945005)(71190400001)(8936002)(66066001)(81166006)(71200400001)(81156014)(4326008)(5660300002)(8676002)(486006)(36756003)(476003)(44832011)(68736007)(50226002)(1076003)(2616005)(7416002)(54906003)(110136005)(256004)(7736002)(498600001)(2906002)(186003)(26005)(14454004)(6116002)(3846002)(2501003)(53936002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4147;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /kewJrZJ3XT3brvq7Fq3CF5v7P/wsq4224JbMV6iTUkEctZJBkaJ0meJt7c5YRRqwm2iQbDnm+PnaUfg2S/fE2AMFT/gCmCLr4squRmZn5Zw5wOUMjNe79ldI28xm09WhWbIrbEdpcG3XCq2vtWzbU8mG0HrACHbni1JJeEUbJ06JmsD0lit4vXVwKvcrOWNcS5/ZZe/5fEIns86M8Y5WP563GtHa6sXBwZuHfe15suVjW3UCTL2gYirsn/lta+KJ9+tFdixASKjBu07+luOLuTkqsCyTcaSyJTQXaXFzvmDh5+1XdKGSj/X9oBaE4Lpx2KEAA22AkxAUmpczDgx0rwtLES4ZEDnzDfi+7juPi9HW+A/XPAI7/VokaJeuV23vwRqUlcPdlcvE/cBnHPAwAMlKRlPnUllcqbzca6+r9s=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f2d4ee-26ea-441c-fb57-08d6de55aaa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 01:34:46.7483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4147
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhlcmUgaXMgbm8gYXVkaW9fcGxsMl9jbGsgcmVnaXN0ZXJlZCwgaXQgc2hvdWxkIGJlIGF1ZGlv
X3BsbDJfb3V0Lg0KDQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQpGaXhlczogYmE1NjI1
YzNlMjcgKCJjbGs6IGlteDogQWRkIGNsb2NrIGRyaXZlciBzdXBwb3J0IGZvciBpbXg4bW0iKQ0K
U2lnbmVkLW9mZi1ieTogUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+DQotLS0NCiBkcml2ZXJz
L2Nsay9pbXgvY2xrLWlteDhtbS5jIHwgNiArKystLS0NCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvaW14
L2Nsay1pbXg4bW0uYyBiL2RyaXZlcnMvY2xrL2lteC9jbGstaW14OG1tLmMNCmluZGV4IDFlZjg0
MzhlM2Q2ZC4uM2E4ODk4NDZhMDVjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jbGsvaW14L2Nsay1p
bXg4bW0uYw0KKysrIGIvZHJpdmVycy9jbGsvaW14L2Nsay1pbXg4bW0uYw0KQEAgLTMyNSw3ICsz
MjUsNyBAQCBzdGF0aWMgY29uc3QgY2hhciAqaW14OG1tX2RzaV9kYmlfc2Vsc1tdID0geyJvc2Nf
MjRtIiwgInN5c19wbGwxXzI2Nm0iLCAic3lzX3BsbA0KIAkJCQkJICAgICJzeXNfcGxsMl8xMDAw
bSIsICJzeXNfcGxsM19vdXQiLCAiYXVkaW9fcGxsMl9vdXQiLCAidmlkZW9fcGxsMV9vdXQiLCB9
Ow0KIA0KIHN0YXRpYyBjb25zdCBjaGFyICppbXg4bW1fdXNkaGMzX3NlbHNbXSA9IHsib3NjXzI0
bSIsICJzeXNfcGxsMV80MDBtIiwgInN5c19wbGwxXzgwMG0iLCAic3lzX3BsbDJfNTAwbSIsDQot
CQkJCQkgICAic3lzX3BsbDNfb3V0IiwgInN5c19wbGwxXzI2Nm0iLCAiYXVkaW9fcGxsMl9jbGsi
LCAic3lzX3BsbDFfMTAwbSIsIH07DQorCQkJCQkgICAic3lzX3BsbDNfb3V0IiwgInN5c19wbGwx
XzI2Nm0iLCAiYXVkaW9fcGxsMl9vdXQiLCAic3lzX3BsbDFfMTAwbSIsIH07DQogDQogc3RhdGlj
IGNvbnN0IGNoYXIgKmlteDhtbV9jc2kxX2NvcmVfc2Vsc1tdID0geyJvc2NfMjRtIiwgInN5c19w
bGwxXzI2Nm0iLCAic3lzX3BsbDJfMjUwbSIsICJzeXNfcGxsMV84MDBtIiwNCiAJCQkJCSAgICAg
ICJzeXNfcGxsMl8xMDAwbSIsICJzeXNfcGxsM19vdXQiLCAiYXVkaW9fcGxsMl9vdXQiLCAidmlk
ZW9fcGxsMV9vdXQiLCB9Ow0KQEAgLTM2MSwxMSArMzYxLDExIEBAIHN0YXRpYyBjb25zdCBjaGFy
ICppbXg4bW1fcGRtX3NlbHNbXSA9IHsib3NjXzI0bSIsICJzeXNfcGxsMl8xMDBtIiwgImF1ZGlv
X3BsbDFfDQogCQkJCQkic3lzX3BsbDJfMTAwMG0iLCAic3lzX3BsbDNfb3V0IiwgImNsa19leHQz
IiwgImF1ZGlvX3BsbDJfb3V0IiwgfTsNCiANCiBzdGF0aWMgY29uc3QgY2hhciAqaW14OG1tX3Zw
dV9oMV9zZWxzW10gPSB7Im9zY18yNG0iLCAidnB1X3BsbF9vdXQiLCAic3lzX3BsbDFfODAwbSIs
ICJzeXNfcGxsMl8xMDAwbSIsDQotCQkJCQkgICAiYXVkaW9fcGxsMl9jbGsiLCAic3lzX3BsbDJf
MTI1bSIsICJzeXNfcGxsM19jbGsiLCAiYXVkaW9fcGxsMV9vdXQiLCB9Ow0KKwkJCQkJICAgImF1
ZGlvX3BsbDJfb3V0IiwgInN5c19wbGwyXzEyNW0iLCAic3lzX3BsbDNfY2xrIiwgImF1ZGlvX3Bs
bDFfb3V0IiwgfTsNCiANCiBzdGF0aWMgY29uc3QgY2hhciAqaW14OG1tX2RyYW1fY29yZV9zZWxz
W10gPSB7ImRyYW1fcGxsX291dCIsICJkcmFtX2FsdF9yb290IiwgfTsNCiANCi1zdGF0aWMgY29u
c3QgY2hhciAqaW14OG1tX2Nsa28xX3NlbHNbXSA9IHsib3NjXzI0bSIsICJzeXNfcGxsMV84MDBt
IiwgIm9zY18yN20iLCAic3lzX3BsbDFfMjAwbSIsICJhdWRpb19wbGwyX2NsayIsDQorc3RhdGlj
IGNvbnN0IGNoYXIgKmlteDhtbV9jbGtvMV9zZWxzW10gPSB7Im9zY18yNG0iLCAic3lzX3BsbDFf
ODAwbSIsICJvc2NfMjdtIiwgInN5c19wbGwxXzIwMG0iLCAiYXVkaW9fcGxsMl9vdXQiLA0KIAkJ
CQkJICJ2cHVfcGxsIiwgInN5c19wbGwxXzgwbSIsIH07DQogDQogc3RhdGljIHN0cnVjdCBjbGsg
KmNsa3NbSU1YOE1NX0NMS19FTkRdOw0KLS0gDQoyLjE2LjQNCg0K
