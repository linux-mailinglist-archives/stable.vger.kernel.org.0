Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F9F7648
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfKKOWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:22:07 -0500
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:6915
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbfKKOWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:22:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJjys583kz6CpQ099PWCTWAxCn/LXsQt4i5X0RHm2m+VbLacmxT3IXEkXNb30O3WdB6343D8YitMIvU5nOWZKfhSQO9cGN3W0lAJ2OlghrNc6ukyJL+OPs2ZbbSGp0UtU24e81fqMqJ0qPPnSeY7Fe+B6LENvNfUTeBDz+Q8D3j0vHUtFhYFIAMyeNncQdS1FitU32krjR/1DKwKrfaXBzQASrztvmYVJu2oiN4HOCmnp4PoM1lesn+OVaa/xhJHyjCNOrfZKLx7EkGES4Bz3O/bUTl6qhKX2rk9SbljyWq5ybMj5nF6Kvn+UTnKHMMfRvcnf5sKc/6FpZmHYvCG3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3a+rCSTqZZV53h2K7t44CCNv9BOT/QGS1mMNdeQNmw=;
 b=kCNGVJVYAwYbfwjedIhtnD/289bs9wowS6Yl65Gcbe4GXX7zBZbF6jGN68zWSXBH5rjx1X5k9ZeAmLlTvnJHoI+PgqEmGNZtfK7sW68nqtxvAEa78nSHkB6rXTZLShfb0H5tRcbfvSt5XT3skggr5QAEKdm4x1OhZd6KItEWaYh5gEozMBnbl/J1Lwyh2Hj8Txh58buYX57csfJRdSe2B5DdcONuoy4+cBEa68Z3YAjeH7VTjyi1Y/OJ/M2+e/wOTOQzSlXW73sPMvHrMFaBas5V10Dyz3qGQu29cYETez5Z1chHNgCzzwxakuV4sWdG3JzRlgDAz2XquRaDvAtPXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3a+rCSTqZZV53h2K7t44CCNv9BOT/QGS1mMNdeQNmw=;
 b=d0ckwy+WUMeY9ymHheG05e88Hv7ogw5kUbWjsBHpSA32XNuZZz8i+BcmqYkX5tNEiO+k/mlQf7TT72eotgOIhBFR2aaR9wDW+Dvyv/n767duaBgn68L1M753HsJD9+0Gu1vaIVE0mEamF4baRCNWSyXEi1Gx0bXCW2DPk1CvsuY=
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com (10.186.159.144) by
 VI1PR04MB7008.eurprd04.prod.outlook.com (52.133.247.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Mon, 11 Nov 2019 14:21:24 +0000
Received: from VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::dd0c:72dc:e462:16b3]) by VI1PR04MB7023.eurprd04.prod.outlook.com
 ([fe80::dd0c:72dc:e462:16b3%5]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 14:21:24 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] clk: imx8m: Use SYS_PLL1_800M as
 intermediate parent of" failed to apply to 5.3-stable tree
Thread-Topic: FAILED: patch "[PATCH] clk: imx8m: Use SYS_PLL1_800M as
 intermediate parent of" failed to apply to 5.3-stable tree
Thread-Index: AQHVmFh7a3y+tcFMOk20DNJ7WscCNqeF/ZmAgAAITIA=
Date:   Mon, 11 Nov 2019 14:21:24 +0000
Message-ID: <8dc0aaaa9ccdc43108fcb421518d8dd2c9cfdd9e.camel@nxp.com>
References: <157345338112980@kroah.com> <20191111135141.GC8496@sasha-vm>
In-Reply-To: <20191111135141.GC8496@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a26b15a-de7f-4089-7e7f-08d766b26edb
x-ms-traffictypediagnostic: VI1PR04MB7008:
x-microsoft-antispam-prvs: <VI1PR04MB700835806BB015F3E32088BDEE740@VI1PR04MB7008.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(189003)(199004)(26005)(478600001)(256004)(110136005)(6116002)(50226002)(6436002)(316002)(102836004)(99286004)(25786009)(3846002)(486006)(71190400001)(4326008)(305945005)(71200400001)(86362001)(81166006)(81156014)(6246003)(54906003)(8936002)(36756003)(14454004)(8676002)(7736002)(44832011)(2906002)(118296001)(4001150100001)(446003)(11346002)(2616005)(2501003)(6512007)(476003)(66946007)(5660300002)(76176011)(229853002)(186003)(66066001)(6506007)(53546011)(66556008)(66476007)(66446008)(64756008)(91956017)(76116006)(6486002)(99106002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7008;H:VI1PR04MB7023.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rF4e4/cO5JFUv68XcZGz+ZSdI6+t322dbMnOdOTIeWcVpvnvLC9pZRdQeMyjjR1qNKrBvDmZP1gn5he/KHOGNQnLdFzr27t4x8/EFB9zY/Q55Oy9FLzGn019M0MKCEF78fPxsrfQzVjKn5Dx4q53ZfqmoiJH7fRpirb5upQR9jIi3wJf2jg28PrHW/HyyDn2oQ1E6tdsVCN7E2mzo3vaOQLGdMbessT/rlWDNRbrGQoXjfSoGKGmFMI1xJXSPU8W5cvviXXpqwgAX3Hx/tXKxjRb1D2SIyFEPFjZLRrhRYu8jPdD2ClwxmhNSOkg85i1OBv9hMac5h1t66d0NCFtbwVn4i4r8bbyM0Uh6RpfE/8JmKsO45qOVPlLTsW7Fz5EHp6yNqPV4aYfuQDALXV8jxATbCeAnW3xTprRA9nCQ9NgBmqT14iDmpOm/Au/MjaC
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E1AF123A6964543BBF5EFF350C990DA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a26b15a-de7f-4089-7e7f-08d766b26edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 14:21:24.5299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jE0vEizIPlkt4W0a+r4/QaK4kGusRB6wW4v3KyaQ5I+vu8bdhoAJPZlowVt4soddk3r/hcHBIjqBEI/2WEdRpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7008
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDE5LTExLTExIGF0IDA4OjUxIC0wNTAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gTW9uLCBOb3YgMTEsIDIwMTkgYXQgMDc6MjM6MDFBTSArMDEwMCwgZ3JlZ2toQGxpbnV4Zm91
bmRhdGlvbi5vcmcNCj4gd3JvdGU6DQo+ID4gDQo+ID4gVGhlIHBhdGNoIGJlbG93IGRvZXMgbm90
IGFwcGx5IHRvIHRoZSA1LjMtc3RhYmxlIHRyZWUuDQo+ID4gSWYgc29tZW9uZSB3YW50cyBpdCBh
cHBsaWVkIHRoZXJlLCBvciB0byBhbnkgb3RoZXIgc3RhYmxlIG9yDQo+ID4gbG9uZ3Rlcm0NCj4g
PiB0cmVlLCB0aGVuIHBsZWFzZSBlbWFpbCB0aGUgYmFja3BvcnQsIGluY2x1ZGluZyB0aGUgb3Jp
Z2luYWwgZ2l0DQo+ID4gY29tbWl0DQo+ID4gaWQgdG8gPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+
Lg0KPiA+IA0KPiA+IHRoYW5rcywNCj4gPiANCj4gPiBncmVnIGstaA0KPiA+IA0KPiA+IC0tLS0t
LS0tLS0tLS0tLS0tLSBvcmlnaW5hbCBjb21taXQgaW4gTGludXMncyB0cmVlIC0tLS0tLS0tLS0t
LS0tLS0NCj4gPiAtLQ0KPiA+IA0KPiA+IEZyb20gYjIzNGZlOTU1ODYxNTA5OGQ4ZDYyNTE2ZTcw
NDFhZDdmOTllYmNlYSBNb24gU2VwIDE3IDAwOjAwOjAwDQo+ID4gMjAwMQ0KPiA+IEZyb206IExl
b25hcmQgQ3Jlc3RleiA8bGVvbmFyZC5jcmVzdGV6QG54cC5jb20+DQo+ID4gRGF0ZTogVHVlLCAy
MiBPY3QgMjAxOSAyMjoyMToyOCArMDMwMA0KPiA+IFN1YmplY3Q6IFtQQVRDSF0gY2xrOiBpbXg4
bTogVXNlIFNZU19QTEwxXzgwME0gYXMgaW50ZXJtZWRpYXRlDQo+ID4gcGFyZW50IG9mDQo+ID4g
Q0xLX0FSTQ0KPiA+IA0KPiA+IER1cmluZyBjcHUgZnJlcXVlbmN5IHN3aXRjaGluZyB0aGUgbWFp
biAiQ0xLX0FSTSIgaXMgcmVwYXJlbnRlZCB0bw0KPiA+IGFuDQo+ID4gaW50ZXJtZWRpYXRlICJz
dGVwIiBjbG9jay4gT24gaW14OG1tIGFuZCBpbXg4bW4gdGhlIDI0TSBvc2NpbGxhdG9yDQo+ID4g
aXMNCj4gPiB1c2VkIGZvciB0aGlzIHB1cnBvc2UgYnV0IGl0IGlzIGV4dHJlbWVseSBzbG93LCBp
bmNyZWFzaW5nIHdha2V1cA0KPiA+IGxhdGVuY2llcyB0byB0aGUgcG9pbnQgdGhhdCBpMmMgdHJh
bnNhY3Rpb25zIGNhbiB0aW1lb3V0IGFuZCBzeXN0ZW0NCj4gPiBiZWNvbWVzIHVucmVzcG9uc2l2
ZS4NCj4gPiANCj4gPiBGaXggYnkgc3dpdGNoaW5nIHRoZSAic3RlcCIgY2xrIHRvIFNZU19QTEwx
XzgwME0sIG1hdGNoaW5nIHRoZQ0KPiA+IGJlaGF2aW9yDQo+ID4gb2YgaW14OG0gY3B1ZnJlcSBk
cml2ZXJzIGluIGlteCB2ZW5kb3IgdHJlZS4NCj4gPiANCj4gPiBUaGlzIGJ1ZyB3YXMgbm90IGlt
bWVkaWF0ZWx5IGFwcGFyZW50IGJlY2F1c2UgdXBzdHJlYW0gYXJtNjQNCj4gPiBkZWZjb25maWcN
Cj4gPiB1c2VzIHRoZSAicGVyZm9ybWFuY2UiIGdvdmVybm9yIGJ5IGRlZmF1bHQgc28gbm8gY3B1
ZnJlcQ0KPiA+IHRyYW5zaXRpb25zDQo+ID4gaGFwcGVuLg0KPiA+IA0KPiA+IEZpeGVzOiBiYTU2
MjVjM2UyNzIgKCJjbGs6IGlteDogQWRkIGNsb2NrIGRyaXZlciBzdXBwb3J0IGZvcg0KPiA+IGlt
eDhtbSIpDQo+ID4gRml4ZXM6IDk2ZDYzOTJiNTRkYiAoImNsazogaW14OiBBZGQgc3VwcG9ydCBm
b3IgaS5NWDhNTiBjbG9jaw0KPiA+IGRyaXZlciIpDQo+IA0KPiA5NmQ2MzkyYjU0ZGIgZG9lc24n
dCBleGlzdCBvbiA1LjMsIHNvIEkndmUgbW9kaWZpZWQgdGhlIHBhdGNoIHRvIG9ubHkNCj4gZml4
IHRoZSBiYTU2MjVjM2UyNzIgcmVsYXRlZCBjb2RlIGFuZCBxdWV1ZWQgaXQgZm9yIDUuMy4gTmVp
dGhlcg0KPiBjb21taXQNCj4gZXhpc3RzIG9uIDQuMTkgYW5kIG9sZGVyLg0KDQpIZWxsbywNCg0K
VGhlIHBhdGNoIGZpeGVzIHRoZSBzYW1lIGJ1ZyBmb3IgdHdvIHZlcnkgc2ltaWxhciBTT0NzIHdo
aWNoIHdlcmUNCnVwc3RyZWFtZWQgYXQgZGlmZmVyZW50IHRpbWVzLiBJdCBpcyBzYWZlIHRvIHNw
bGl0IHRoZSBwYXRjaC4NCg0KLS0NClJlZ2FyZHMsDQpMZW9uYXJkDQo=
