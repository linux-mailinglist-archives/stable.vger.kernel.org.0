Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0639E1F360B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 10:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgFIIXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 04:23:38 -0400
Received: from mail-eopbgr30124.outbound.protection.outlook.com ([40.107.3.124]:63103
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728034AbgFIIXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 04:23:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zmeq9y42FxfXrLgacnjU/YT9hzT0wraee6Pq0uDCAfUwn1Lvn9AZTNJm3usZ2bR7Et+BCFGX5SL9g0jly/ytI1O3dJ1+6y2o8YA7b+L2BXW80qufWzBh90DZeaWCFGnFkYItCLjNtW9Zzhk+uL1knBjM8LGaREtGuRcBw0uDTZa3lRsnEnEAN8tcVOwrJtqSAh/jMIXqGHqnfzTYXgUFed7V4hrT3CyP//uT5kmTFvDdfcPLPBush46BE90x25fboszp6iW358e1Pihn9tYcSGjoahJsF8HO3yBSEcuV0og/iFtao+kauDqfZsBDeqMT4IdliC+QKQ+/45idAnwT9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw1+QD+dZcHJ5X7zGaZ2DOPe9+1Gz7NZ6CY0sb02xk8=;
 b=bU6e+70+S7eTEi1JrcyYmP6hQwOb/IVNJjdoVxdNvKZ8JZNAZnbX7R/ihANcjaL8EyCHSRrmlgm33NQ10V2UXwQOgAIaP4sDQCX0imFRd4zdr3hLrLlqcTrt/xUnktBcEzTUGT9J3mr8YuslUxWNlyTveH1QqVeMVB9+61FLIQKUaUwRrJoEaxHYboDWF5E/SH6fTwPOkSQ7rbnbpZQKeF0c2UAiMx/46fx/adaQ1hWIb2arkF8qFFa8Atvy9il70EDa5/yyEvUXglemZ3o+GsyhV3G4ECtbNwiS9XzZE+t5bvNs2FJU9t1s7kDmOybisxuQAwewXca0XSAHLuE7/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw1+QD+dZcHJ5X7zGaZ2DOPe9+1Gz7NZ6CY0sb02xk8=;
 b=d/0KV0vawMlS+RnwM/qSdknY70P2MP4hFXX3SFe/5sGGtQlbQRx1JQuLR1zzuDDchVPl7mvNalKGhc1sN0jsjunHuZG3Axbcj4hr7sHrtW0QxZpfKvC/Q4oY+npxj3a1bOrNp5r+SLDfQ0FM75q8Wy+oktOiC9T/KF5naloA9Fg=
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:50::12)
 by DB7PR10MB1947.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:5:b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3066.18; Tue, 9 Jun 2020 08:23:30 +0000
Received: from DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048]) by DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acc5:2acd:49a6:5048%7]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 08:23:30 +0000
From:   Schrempf Frieder <frieder.schrempf@kontron.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Fabio Estevam <festevam@gmail.com>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v2] serial: imx: Fix handling of TC irq in combination
 with DMA
Thread-Topic: [PATCH v2] serial: imx: Fix handling of TC irq in combination
 with DMA
Thread-Index: AQHWPi7m3YXfW/ta4UitHElBbvaQXajP8iSA
Date:   Tue, 9 Jun 2020 08:23:30 +0000
Message-ID: <a0b56107-bea0-7105-3021-030b181b2260@kontron.de>
References: <20200609072259.8259-1-frieder.schrempf@kontron.de>
In-Reply-To: <20200609072259.8259-1-frieder.schrempf@kontron.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=kontron.de;
x-originating-ip: [77.246.119.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df7343b0-5f11-4326-6a59-08d80c4e648b
x-ms-traffictypediagnostic: DB7PR10MB1947:
x-microsoft-antispam-prvs: <DB7PR10MB1947B225B927D4AD7AB639C5E9820@DB7PR10MB1947.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:226;
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n6420Fct38Bj26RBcrzED4nwfehPa5Hsofs8Yg3irWreRjC1U1P2Iq5LN34wEEJ4E5AC5jWCReIpYMiCs1dgFfmv9LpsepkZoNrdSzRGb/MQvs2gmwrdOINeT3ss7D7TFlZFbllqDnx5Eb8tzqJwivZoF5vM3tyl9NmR38vs6YtWo1UGhJqRHnmgPiaD0/iho8KUM48GI4gOVY55wGByLG5JOkns2HPVCYsXxD7TwFDYNfAkGxR038yBFTvprkP3pS90PRTPt28rGlrIZljHqmcdMZrzxx1YBqixW+RFxGw7BFcpgdiyj/OV9gXOQeFT4YLvzGgU/LYAECAGuFU3Zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR10MB2490.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(396003)(39850400004)(346002)(2906002)(6512007)(71200400001)(8936002)(478600001)(8676002)(186003)(54906003)(6486002)(6506007)(66574014)(83380400001)(36756003)(53546011)(26005)(5660300002)(91956017)(31696002)(66446008)(66556008)(66476007)(66946007)(86362001)(31686004)(6916009)(76116006)(2616005)(4326008)(316002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: oAh78Kf/Lxx52wX94LrDSvsMGqz1TFmIoUreo76oy/lEoudLJYZOkz7WP2AQYwAGva7/40TyNtf8MP8c+LgCC+89+v+TIUvPng9WGd8d8fjzdnVGMEc3vAoEHnes5Se8qkfGW++G2HTdjeDiohDdXgZQEfIjO71o6FXtuXplrEYlyEJOl/trx+1OgLXg5R0Cd3rgITM4V6ich1CmlA19uNHbsYvlp2KrU2KDN67FVBkQE8jCuyP+gK6kZB4nIC4MfkdtLw3dTknQq57cJ5axFoxua9ony0wSCfuEsjhtILQIxHoL4EHUH//e21cWFfAYdwnEsYrG3nEfVe6Xjs6jz82YeqTR/AneZm+QeQTsoRMRNJe4zJDDBKU9UNmZzek8JE5zLaB2RgjRlbsXhJ+9ymTEDiX6iPTlOJrsWw8Tj2bYon+56H5u1++SnNHAmFzITKQSm9q9KqeGEm+uGA/4uw9i1ATiKZ5QriBLP73wOo2oF5getlCBeXAHDwKDFfJp
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F34DAD4B8396954A9E88D62D1B8BB53D@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: df7343b0-5f11-4326-6a59-08d80c4e648b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 08:23:30.6146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QHMz8D7MUyTVaokHuacpothlo3DTHfcKwd85TgqZjNCul+QK1Chq0NjE/MeOUkVOdUGHo8TgMIw/XGB+R3ry8O1YWUlcN/7iBsDpXoi56IY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB1947
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDkuMDYuMjAgMDk6MjMsIFNjaHJlbXBmIEZyaWVkZXIgd3JvdGU6DQo+IEZyb206IFV3ZSBL
bGVpbmUtS8O2bmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9uaXguZGU+DQo+IA0KPiBjb21t
aXQgMTg2NjU0MTQ5MjY0MWMwMjg3NGJmNTFmOWQ4NzEyYjU1MTBmMmM2NCB1cHN0cmVhbQ0KPiAN
Cj4gV2hlbiB1c2luZyBSUzQ4NSBoYWxmIGR1cGxleCB0aGUgVHJhbnNtaXR0ZXIgQ29tcGxldGUg
aXJxIGlzIG5lZWRlZCB0bw0KPiBkZXRlcm1pbmUgdGhlIG1vbWVudCB3aGVuIHRoZSB0cmFuc21p
dHRlciBjYW4gYmUgZGlzYWJsZWQuIFdoZW4gdXNpbmcNCj4gRE1BIHRoaXMgaXJxIG11c3Qgb25s
eSBiZSBlbmFibGVkIHdoZW4gRE1BIGhhcyBjb21wbGV0ZWQgdG8gdHJhbnNmZXIgYWxsDQo+IGRh
dGEuIE90aGVyd2lzZSB0aGUgQ1BVIG1pZ2h0IGJ1c2lseSB0cmlnZ2VyIHRoaXMgaXJxIHdoaWNo
IGlzIG5vdA0KPiBwcm9wZXJseSBoYW5kbGVkIGFuZCBzbyB0aGUgYWxzbyBwZW5kaW5nIGlycSBm
b3IgdGhlIERNQSB0cmFuc2ZlciBjYW5ub3QNCj4gdHJpZ2dlci4NCj4gDQo+IENjOiA8c3RhYmxl
QHZnZXIua2VybmVsLm9yZz4gIyB2NC4xNC54DQo+IFNpZ25lZC1vZmYtYnk6IFV3ZSBLbGVpbmUt
S8O2bmlnIDx1LmtsZWluZS1rb2VuaWdAcGVuZ3V0cm9uaXguZGU+DQo+IFNpZ25lZC1vZmYtYnk6
IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IFtCYWNr
cG9ydCB0byB2NC4xNF0NCj4gU2lnbmVkLW9mZi1ieTogRnJpZWRlciBTY2hyZW1wZiA8ZnJpZWRl
ci5zY2hyZW1wZkBrb250cm9uLmRlPg0KPiAtLS0NCg0KU29ycnksIGZvcmdvdCB0aGUgY2hhbmdl
bG9nOg0KDQpDaGFuZ2VzIGZvciBiYWNrcG9ydCB2MjoNCiogUmVtb3ZlIGFuIHVucmVsYXRlZCBh
ZGRpdGlvbmFsIGJsYW5rIGxpbmUuDQoNCj4gV2hlbiB1c2luZyBSUzQ4NSB3aXRoIERNQSBlbmFi
bGVkIHNpbXBseSB0cmFuc21pdHRpbmcgc29tZSBkYXRhIG9uIG91cg0KPiBpLk1YNlVMTCBiYXNl
ZCBib2FyZHMgb2Z0ZW4gZnJlZXplcyB0aGUgc3lzdGVtIGNvbXBsZXRlbHkuIFRoZSBoaWdoZXIN
Cj4gdGhlIGJhdWRyYXRlLCB0aGUgZWFzaWVyIGl0IGlzIHRvIHJlcHJvZHVjZSB0aGUgaXNzdWUu
IFRvIHRlc3QgdGhpcyBJDQo+IHNpbXBseSB1c2VkOg0KPiANCj4gc3R0eSAtRiAvZGV2L3R0eW14
YzEgc3BlZWQgMTE1MjAwDQo+IHdoaWxlIHRydWU7IGRvIGVjaG8gVEVTVCA+IC9kZXYvdHR5bXhj
MTsgZG9uZQ0KPiANCj4gV2l0aG91dCB0aGUgcGF0Y2ggdGhpcyBsZWFkcyB0byBhbiBhbG1vc3Qg
aW1tZWRpYXRlIHN5c3RlbSBmcmVlemUsDQo+IHdpdGggdGhlIHBhdGNoIGFwcGxpZWQsIGV2ZXJ5
dGhpbmcga2VlcHMgd29ya2luZyBhcyBleHBlY3RlZC4NCj4gLS0tDQo+ICAgZHJpdmVycy90dHkv
c2VyaWFsL2lteC5jIHwgMjIgKysrKysrKysrKysrKysrKysrLS0tLQ0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCAxOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdHR5L3NlcmlhbC9pbXguYyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9pbXguYw0KPiBp
bmRleCAzZjI2MDVlZGQ4NTUuLjcwYzczNzIzNjg3MCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy90
dHkvc2VyaWFsL2lteC5jDQo+ICsrKyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9pbXguYw0KPiBAQCAt
NTM4LDYgKzUzOCwxMSBAQCBzdGF0aWMgdm9pZCBkbWFfdHhfY2FsbGJhY2sodm9pZCAqZGF0YSkN
Cj4gICANCj4gICAJaWYgKCF1YXJ0X2NpcmNfZW1wdHkoeG1pdCkgJiYgIXVhcnRfdHhfc3RvcHBl
ZCgmc3BvcnQtPnBvcnQpKQ0KPiAgIAkJaW14X2RtYV90eChzcG9ydCk7DQo+ICsJZWxzZSBpZiAo
c3BvcnQtPnBvcnQucnM0ODUuZmxhZ3MgJiBTRVJfUlM0ODVfRU5BQkxFRCkgew0KPiArCQl0ZW1w
ID0gcmVhZGwoc3BvcnQtPnBvcnQubWVtYmFzZSArIFVDUjQpOw0KPiArCQl0ZW1wIHw9IFVDUjRf
VENFTjsNCj4gKwkJd3JpdGVsKHRlbXAsIHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVQ1I0KTsNCj4g
Kwl9DQo+ICAgDQo+ICAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnNwb3J0LT5wb3J0LmxvY2ss
IGZsYWdzKTsNCj4gICB9DQo+IEBAIC01NTUsNiArNTYwLDEwIEBAIHN0YXRpYyB2b2lkIGlteF9k
bWFfdHgoc3RydWN0IGlteF9wb3J0ICpzcG9ydCkNCj4gICAJaWYgKHNwb3J0LT5kbWFfaXNfdHhp
bmcpDQo+ICAgCQlyZXR1cm47DQo+ICAgDQo+ICsJdGVtcCA9IHJlYWRsKHNwb3J0LT5wb3J0Lm1l
bWJhc2UgKyBVQ1I0KTsNCj4gKwl0ZW1wICY9IH5VQ1I0X1RDRU47DQo+ICsJd3JpdGVsKHRlbXAs
IHNwb3J0LT5wb3J0Lm1lbWJhc2UgKyBVQ1I0KTsNCj4gKw0KPiAgIAlzcG9ydC0+dHhfYnl0ZXMg
PSB1YXJ0X2NpcmNfY2hhcnNfcGVuZGluZyh4bWl0KTsNCj4gICANCj4gICAJaWYgKHhtaXQtPnRh
aWwgPCB4bWl0LT5oZWFkIHx8IHhtaXQtPmhlYWQgPT0gMCkgew0KPiBAQCAtNjE3LDEwICs2MjYs
MTUgQEAgc3RhdGljIHZvaWQgaW14X3N0YXJ0X3R4KHN0cnVjdCB1YXJ0X3BvcnQgKnBvcnQpDQo+
ICAgCQlpZiAoIShwb3J0LT5yczQ4NS5mbGFncyAmIFNFUl9SUzQ4NV9SWF9EVVJJTkdfVFgpKQ0K
PiAgIAkJCWlteF9zdG9wX3J4KHBvcnQpOw0KPiAgIA0KPiAtCQkvKiBlbmFibGUgdHJhbnNtaXR0
ZXIgYW5kIHNoaWZ0ZXIgZW1wdHkgaXJxICovDQo+IC0JCXRlbXAgPSByZWFkbChwb3J0LT5tZW1i
YXNlICsgVUNSNCk7DQo+IC0JCXRlbXAgfD0gVUNSNF9UQ0VOOw0KPiAtCQl3cml0ZWwodGVtcCwg
cG9ydC0+bWVtYmFzZSArIFVDUjQpOw0KPiArCQkvKg0KPiArCQkgKiBFbmFibGUgdHJhbnNtaXR0
ZXIgYW5kIHNoaWZ0ZXIgZW1wdHkgaXJxIG9ubHkgaWYgRE1BIGlzIG9mZi4NCj4gKwkJICogSW4g
dGhlIERNQSBjYXNlIHRoaXMgaXMgZG9uZSBpbiB0aGUgdHgtY2FsbGJhY2suDQo+ICsJCSAqLw0K
PiArCQlpZiAoIXNwb3J0LT5kbWFfaXNfZW5hYmxlZCkgew0KPiArCQkJdGVtcCA9IHJlYWRsKHBv
cnQtPm1lbWJhc2UgKyBVQ1I0KTsNCj4gKwkJCXRlbXAgfD0gVUNSNF9UQ0VOOw0KPiArCQkJd3Jp
dGVsKHRlbXAsIHBvcnQtPm1lbWJhc2UgKyBVQ1I0KTsNCj4gKwkJfQ0KPiAgIAl9DQo+ICAgDQo+
ICAgCWlmICghc3BvcnQtPmRtYV9pc19lbmFibGVkKSB7DQo+IA==
