Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8FF789F6
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 12:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfG2K6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 06:58:11 -0400
Received: from mail-eopbgr40091.outbound.protection.outlook.com ([40.107.4.91]:2231
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387424AbfG2K6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 06:58:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUghTPm3vYCfwP1JLvXwQmFgH9rWd9KwbktWiC2GZFAkVkp75owNB1lCCAGrdbrOXXHjLLY7/vbHgKnpJL2pP4RHBtUOioxzEnhAdgXkd9440e1JdES72LxhCgACEcWxFCHy9PSnk6b59+d0E9kBwbyuTHicJlEIT9aKsoM1YglCSSsY2oYpZUuV1qQZW/fJ0oowhNuEliFyIGKkB/aMmQPW1y+Nx3HcfoR60MXbw/M34Vn9rX/OVMLvga8y1VdJjTPpsQ6txgXqNmcpCg6Htda+T19YV39Wjwu0XRvW2F7Hl+icCDXa6yAx4Q4xyjtyq5aPutalbwmr18YFC96FGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVTn9j8VBZrIA78PRkbLkn0dfOPvDZp0uaOBNASeRls=;
 b=NU3LpzVKfxwaXGchJih6R32fZbwuaPevbTm77O+gkYsOhPbeMJqM6eUQmo79mU06m83Ds5tiYMSKyjgNGfUYFM9UD7eTU1nXxoD5rFcRYD9NiaBQeI2zf2uwtofj0Y03tZDPqeQ9FHar8XZXwfxEV8vEz3hbWwn+fF+ngIVnHXEkaw3qmFzPMNBYet86blOFsvJ8FrF0z+8H8wzFYmzZLqNLk/PHV70UZXExXW7x4gwKXZhUTghptzjZE1stpI4vqGQlxGqJbmXOxKFwBZNTCkNA2ibzu3dtgpnhaHxlfnLNbhEgMlLnMu4QNJ95AjTjXgdJEeKZQTEsXng0ZRviHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVTn9j8VBZrIA78PRkbLkn0dfOPvDZp0uaOBNASeRls=;
 b=J+guKqIedDtCtn/VpjF7PMIzS2tcyPddreDZdpqFy4Eal1w+UbVDpz1mi+FKuPoM5jZVhfy+z+804Tg7gCZAh1kdgPMG0daBpP+bQnsabVR9WqyHxglibX0uv0/XSaDe8m43+98Is4CXfm1LCqk42sycsq33lbP2n2GWFYG9ufQ=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB6565.eurprd05.prod.outlook.com (20.179.18.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 10:58:06 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 10:58:06 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
CC:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Suvorov Alexander <cryosay@gmail.com>
Subject: Re: [PATCH 0/1] This patch fixes connection detection for monitors
 w/o DDC.
Thread-Topic: [PATCH 0/1] This patch fixes connection detection for monitors
 w/o DDC.
Thread-Index: AQHVQtjbQmQDpUU8tU2AbrHFyIUWg6bbM5+AgAY9oAA=
Date:   Mon, 29 Jul 2019 10:58:06 +0000
Message-ID: <CAGgjyvEA54kR3U8Lyz-1-vPS74raT6SpoM0e8YYcm12T=0r50A@mail.gmail.com>
References: <20190725110520.26848-1-oleksandr.suvorov@toradex.com>
 <20190725113237.d2dwxzientte4j3n@flea>
In-Reply-To: <20190725113237.d2dwxzientte4j3n@flea>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR10CA0031.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::11) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAXoLmpEfk7cs81hPZuEMXMlexrC4UwndGIfEnVjh9ImxkF4kYkb
        IuTQu/3YSoZEvGJk6W2bbmg3/50T6Mn6CNxfVcE=
x-google-smtp-source: APXvYqx6lzkOl+k2q/4Rzqx/zOA50Zxjrtiesmb/seUsMHRH0SIHei35eUParrN1FfG1RFnaGvTBkgZWcpPex6hvGWc=
x-received: by 2002:a17:906:d8ab:: with SMTP id
 qc11mr21568720ejb.219.1564397455287; Mon, 29 Jul 2019 03:50:55 -0700 (PDT)
x-gmail-original-message-id: <CAGgjyvEA54kR3U8Lyz-1-vPS74raT6SpoM0e8YYcm12T=0r50A@mail.gmail.com>
x-originating-ip: [209.85.208.47]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6bc66ae-5b2c-4af3-db27-08d71413a287
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB6565;
x-ms-traffictypediagnostic: AM6PR05MB6565:
x-microsoft-antispam-prvs: <AM6PR05MB656543BBDD280FECA9BBAC84F9DD0@AM6PR05MB6565.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39850400004)(396003)(136003)(346002)(376002)(199004)(189003)(476003)(53936002)(71190400001)(6436002)(55446002)(486006)(11346002)(61266001)(44832011)(66066001)(66946007)(66476007)(66556008)(64756008)(66446008)(14454004)(6506007)(53546011)(102836004)(446003)(14444005)(256004)(386003)(61726006)(99286004)(2501003)(76176011)(52116002)(71200400001)(5640700003)(8936002)(9686003)(6512007)(498394004)(6862004)(305945005)(81156014)(81166006)(68736007)(107886003)(4326008)(450100002)(3846002)(6116002)(95326003)(5660300002)(6246003)(316002)(25786009)(478600001)(86362001)(6486002)(26005)(229853002)(2351001)(186003)(2906002)(8676002)(7736002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6565;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DFAAtTM034HG4rMxYKiZXPba+zT61MFAgUKBLyIrxU5x+j3O3q/XH4fsKIVPipUGCiL6nsvK/d9e8RLl0joEV9oIkWs7cvEbAji78HgYUf3HMxqNJLMuzZ4vsDgmRsHeCeLNzsEy9xXEtsQ/Xx8XUGexaFErubQjnw6mPoPMJ9YSkWculrY15mr/CUhkZq9meXDko25tVxEbo/Ki5et9McgPCdD14e/OcPd4Q9uQLdRgyH48LvJsvXscPV+Mm4EnrSFyDyL5qGLM29AEWZL43tzrP/17kF9QoSYkGnZGOyQMtDbwhbjFCIC7BoAP0ZTEBXUHiUvuc3yR0B++iJaQkKH5xVjwkqD+zltB/RH2UjTVKWGDaFuwwnrL54L2czZzN8cOYH7MwCX9RDyuneANwNP96fI4r0pdELFHvKOln8s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD8527AE2B61E24188F88057352B77FF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bc66ae-5b2c-4af3-db27-08d71413a287
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 10:58:06.0890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6565
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBKdWwgMjUsIDIwMTkgYXQgNTo0MSBQTSBtYXhpbWUucmlwYXJkQGZyZWUtZWxlY3Ry
b25zLmNvbQ0KPG1heGltZS5yaXBhcmRAZnJlZS1lbGVjdHJvbnMuY29tPiB3cm90ZToNCj4NCj4g
T24gVGh1LCBKdWwgMjUsIDIwMTkgYXQgMTE6MDU6MjNBTSArMDAwMCwgT2xla3NhbmRyIFN1dm9y
b3Ygd3JvdGU6DQo+ID4NCj4gPiBFdmVuIGluIHNvdXJjZSBjb2RlIG9mIHRoaXMgZHJpdmVyIHRo
ZXJlIGlzIGFuIGF1dGhvcidzIGRlc2NyaXB0aW9uOg0KPiA+ICAgICAvKg0KPiA+ICAgICAgKiBF
dmVuIGlmIHdlIGhhdmUgYW4gSTJDIGJ1cywgd2UgY2FuJ3QgYXNzdW1lIHRoYXQgdGhlIGNhYmxl
DQo+ID4gICAgICAqIGlzIGRpc2Nvbm5lY3RlZCBpZiBkcm1fcHJvYmVfZGRjIGZhaWxzLiBTb21l
IGNhYmxlcyBkb24ndA0KPiA+ICAgICAgKiB3aXJlIHRoZSBEREMgcGlucywgb3IgdGhlIEkyQyBi
dXMgbWlnaHQgbm90IGJlIHdvcmtpbmcgYXQNCj4gPiAgICAgICogYWxsLg0KPiA+ICAgICAgKi8N
Cj4gPg0KPiA+IFRoYXQncyB0cnVlLiBEREMgYW5kIFZHQSBjaGFubmVscyBhcmUgaW5kZXBlbmRl
bnQsIGFuZCB0aGVyZWZvcmUNCj4gPiB3ZSBjYW5ub3QgZGVjaWRlIHdoZXRoZXIgdGhlIG1vbml0
b3IgaXMgY29ubmVjdGVkIG9yIG5vdCwNCj4gPiBkZXBlbmRpbmcgb24gdGhlIGluZm9ybWF0aW9u
IGZyb20gdGhlIEREQy4NCj4gPg0KPiA+IFNvIHRoZSBtb25pdG9yIHNob3VsZCBhbHdheXMgYmUg
Y29uc2lkZXJlZCBjb25uZWN0ZWQuDQo+DQo+IFdlbGwsIG5vLiBMaWtlIHlvdSBzYWlkLCB3ZSBj
YW5ub3QgZGVjaWRlZCB3aGV0aGVyIGlzIGNvbm5lY3RlZCBvcg0KPiBub3QuDQoNCk1heGltZSwg
dGhhbmtzLCBJIGFncmVlIHRoYXQncyBhIGJhZCBzb2x1dGlvbi4NCkJ1dCBJIHN0aWxsIHRoaW5r
IHdlIHNob3VsZCBiZSBhYmxlIHRvIGRlZmluZSB0aGUgRFQgbm9kZSBvZiBhIGRldmljZSBmb3IN
CnRoaXMgZHJpdmVyIHRvIGNsYWltIHRoZSBjb25uZWN0b3IgaXMgYWx3YXlzIGNvbm5lY3RlZC4N
ClBsZWFzZSBzZWUgbXkgZm9sbG93aW5nIHRob3VnaHRzLg0KDQo+ID4gVGh1cyB0aGVyZSBpcyBu
byByZWFzb24gdG8gdXNlIGNvbm5lY3RvciBkZXRlY3QgY2FsbGJhY2sgZm9yIHRoaXMNCj4gPiBk
cml2ZXI6IERSTSBzdWItc3lzdGVtIGNvbnNpZGVycyBtb25pdG9yIGFsd2F5cyBjb25uZWN0ZWQg
aWYgdGhlcmUNCj4gPiBpcyBubyBkZXRlY3QoKSBjYWxsYmFjayByZWdpc3RlcmVkIHdpdGggZHJt
X2Nvbm5lY3Rvcl9pbml0KCkuDQo+ID4NCj4gPiBIb3cgdG8gcmVwcm9kdWNlIHRoZSBidWc6DQo+
ID4gKiBzZXR1cDogaS5NWDhRWFAsIExDRElGIHZpZGVvIG1vZHVsZSArIGdwdS9kcm0vbXhzZmIg
ZHJpdmVyLA0KPiA+ICAgYWR2NzEyeCBWR0EgREFDICsgZHVtYi12Z2EtZGFjIGRyaXZlciwgVkdB
LWNvbm5lY3RvciB3L28gRERDOw0KPiA+ICogdHJ5IHRvIHVzZSBkcml2ZXJzIGNoYWluIG14c2Zi
LWRybSArIGR1bWItdmdhLWRhYzsNCj4gPiAqIGFueSBEUk0gYXBwbGljYXRpb25zIGNvbnNpZGVy
IHRoZSBtb25pdG9yIGlzIG5vdCBjb25uZWN0ZWQ6DQo+ID4gICA9PT09PT09PT09PQ0KPiA+ICAg
JCB3ZXN0b24tc3RhcnQNCj4gPiAgICQgY2F0IC92YXIvbG9nL3dlc3Rvbi5sb2cNCj4gPiAgICAg
ICAuLi4NCj4gPiAgICAgICBEUk06IGhlYWQgJ1ZHQS0xJyBmb3VuZCwgY29ubmVjdG9yIDMyIGlz
IGRpc2Nvbm5lY3RlZC4NCj4gPiAgICAgICAuLi4NCj4gPiAgICQgY2F0IC9zeXMvZGV2aWNlcy9w
bGF0Zm9ybS81YTE4MDAwMC5sY2RpZi9kcm0vY2FyZDAvY2FyZDAtVkdBLTEvc3RhdHVzDQo+ID4g
ICB1bmtub3duDQo+DQo+IEFuZCB0aGF0J3MgZXhhY3RseSB3aGF0J3MgYmVpbmcgcmVwb3J0ZWQg
aGVyZTogd2UgY2Fubm90IGRlY2lkZSBpZiBpdA0KPiBpcyBjb25uZWN0ZWQgb3Igbm90LCBzbyBp
dCdzIHVua25vd24uDQo+DQo+IElmIHdlc3RvbiBjaG9vc2VzIHRvIGlnbm9yZSBjb25uZWN0b3Jz
IHRoYXQgYXJlIGluIGFuIHVua25vd24gc3RhdGUsDQo+IEknZCBzYXkgaXQncyB3ZXN0b24ncyBw
cm9ibGVtLCBzaW5jZSBpdCdzIG11Y2ggYnJvYWRlciB0aGFuIHRoaXMNCj4gcGFydGljdWxhciBk
ZXZpY2UuDQoNCklmIHdlIGxvb2sgYXQgdGhlIGNvZGUgb2YgZHJtX3Byb2JlX2hlbHBlci5jLCB3
ZSBjYW4gc2VlLCB0aGUNCmRybV9oZWxwZXJfcHJvYmVfZGV0ZWN0X2N0eCgpIGFzc3VtZSB0aGUg
Y2FibGUgaXMgY29ubmVjdGVkIGlmIHRoZXJlIGlzIG5vDQpkZXRlY3QoKSBjYWxsYmFjayByZWdp
c3RlcmVkLg0KLi4uDQogICAgICAgICAgICAgICAgaWYgKGZ1bmNzLT5kZXRlY3RfY3R4KQ0KICAg
ICAgICAgICAgICAgICAgICAgICAgIHJldCA9IGZ1bmNzLT5kZXRlY3RfY3R4KGNvbm5lY3Rvciwg
JmN0eCwgZm9yY2UpOw0KICAgICAgICAgICAgICAgICBlbHNlIGlmIChjb25uZWN0b3ItPmZ1bmNz
LT5kZXRlY3QpDQogICAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gY29ubmVjdG9yLT5mdW5j
cy0+ZGV0ZWN0KGNvbm5lY3RvciwgZm9yY2UpOw0KICAgICAgICAgICAgICAgICBlbHNlDQogICAg
ICAgICAgICAgICAgICAgICAgICAgcmV0ID0gY29ubmVjdG9yX3N0YXR1c19jb25uZWN0ZWQ7DQou
Li4NCg0KVGhlIGRyaXZlciBkdW1iLXZnYS1kYWMgc3VwcG9ydHMgYm90aCBEVCBjb25maWd1cmF0
aW9uczoNCi0gd2l0aCBEREMgY2hhbm5lbCwgdGhhdCBhbGxvd3MgdXMgdG8gZGV0ZWN0IGlmIHRo
ZSBjYWJsZSBpcyBjb25uZWN0ZWQ7DQotIHdpdGhvdXQgRERDIGNoYW5uZWwuIEluIHRoaXMgY2Fz
ZSwgSU1ITywgdGhlIGRyaXZlciBzaG91bGQgYmVoYXZlDQp0aGUgc2FtZSB3YXkgYXMgYQ0KICBj
b25uZWN0b3IgZHJpdmVyIHdpdGhvdXQgcmVnaXN0ZXJlZCBkZXRlY3QoKSBjYWxsYmFjay4NCg0K
U28gd2hhdCBhYm91dCB0aGUgcGF0Y2ggbGlrZT8NCg0KQEAgLTgxLDYgKzgxLDEzIEBAIGR1bWJf
dmdhX2Nvbm5lY3Rvcl9kZXRlY3Qoc3RydWN0IGRybV9jb25uZWN0b3INCipjb25uZWN0b3IsIGJv
b2wgZm9yY2UpDQogew0KICAgICAgICBzdHJ1Y3QgZHVtYl92Z2EgKnZnYSA9IGRybV9jb25uZWN0
b3JfdG9fZHVtYl92Z2EoY29ubmVjdG9yKTsNCg0KKyAgICAgICAvKg0KKyAgICAgICAgKiBJZiBJ
MkMgYnVzIGZvciBEREMgaXMgbm90IGRlZmluZWQsIGFzdW1lIHRoYXQgdGhlIGNhYmxlDQorICAg
ICAgICAqIGlzIGFsd2F5cyBjb25uZWN0ZWQuDQorICAgICAgICAqLw0KKyAgICAgICBpZiAoUFRS
X0VSUih2Z2EtPmRkYykgPT0gLUVOT0RFVikNCisgICAgICAgICAgICAgICByZXR1cm4gY29ubmVj
dG9yX3N0YXR1c19jb25uZWN0ZWQ7DQorDQogICAgICAgIC8qDQogICAgICAgICAqIEV2ZW4gaWYg
d2UgaGF2ZSBhbiBJMkMgYnVzLCB3ZSBjYW4ndCBhc3N1bWUgdGhhdCB0aGUgY2FibGUNCiAgICAg
ICAgICogaXMgZGlzY29ubmVjdGVkIGlmIGRybV9wcm9iZV9kZGMgZmFpbHMuIFNvbWUgY2FibGVz
IGRvbid0DQoNCi0tIA0KQmVzdCByZWdhcmRzDQpPbGVrc2FuZHIgU3V2b3Jvdg0KDQpUb3JhZGV4
IEFHDQpBbHRzYWdlbnN0cmFzc2UgNSB8IDYwNDggSG9ydy9MdXplcm4gfCBTd2l0emVybGFuZCB8
IFQ6ICs0MSA0MSA1MDANCjQ4MDAgKG1haW4gbGluZSkNCg==
