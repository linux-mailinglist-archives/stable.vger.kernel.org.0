Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFCA1FC9D0
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 11:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgFQJ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 05:27:20 -0400
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:41064 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgFQJ1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 05:27:20 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 05H9R9P1016297; Wed, 17 Jun 2020 18:27:09 +0900
X-Iguazu-Qid: 34trcFcTTcnf7jvp5N
X-Iguazu-QSIG: v=2; s=0; t=1592386029; q=34trcFcTTcnf7jvp5N; m=zsIHo39DpcHb4LeDkX+xuQO10PPLqkJHF/C46IDj/YA=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id 05H9R8a9008789;
        Wed, 17 Jun 2020 18:27:08 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 05H9R87p008587;
        Wed, 17 Jun 2020 18:27:08 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 05H9R89i017125;
        Wed, 17 Jun 2020 18:27:08 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifVWP6CaqoHjkCyJrsYfMNbzLeKOSpbincQmczR7Gk/sqMBA6/EL3WfK47nvycBGNjydfNf0/y18C1EmTD1SkxEaePtLebaG05Kho0zNpWf+E3412aRSFX/MtyTS4yUitHfbpcEnOx2ZlunsVjQf+6NUk/1f8/nUuW/JaWyjbInmqhnN9Txa7yM0iozj9gbVq1ajYc+GMAM0j97PlpSe4OeO5qQFLkCKNrUTAHUYeJOcWVT7dCOJ8jXNm1jfNzrxqeaq2Ry5JFoXrBIH44TLVWalHfULG51OcoQRxZp05fygYRXp1XSDZG8qhfLiTfBC0C/erU2bMTnBZU+YJnfhWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/NiHfYfeGGfEefQf/VvmAgtYVvup8cNasYS9XCTUr8=;
 b=G39Tju9Qt/16EtKEgFtQH2Xw07TuVOutJ+KOVFyMxzCdykVh6Ivf9kyzKN01Pa18pLMHzw9D2TgGblwkyAxIRaTCqk0H0dF5KrPG/QOvfjIkJqB8zUerPFpHR0SW5uWBJ7wOJG5ta/YvC5LXOa6JVU7F1Ene75NXZTM7GVn7+wLEL3z8kJAF3968k+5R7tykwLJOqCTn+WUlTNoBOrEsl9Jiwf3nJDxqN9P5ud30FNKGbDK47bVimYDeGP4jMtbn802fGAOeLPMzCN2jYKRdZSM517beG/ma1/HzPXNiMRnsKag43niIXkBxbWSrVbQMsE2NTz4ev/D7ynolVyhG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <ardb@kernel.org>,
        <rafael.j.wysocki@intel.com>
Subject: RE: [PATCH 5.4 064/134] ACPI: GED: add support for _Exx / _Lxx
 handler methods
Thread-Topic: [PATCH 5.4 064/134] ACPI: GED: add support for _Exx / _Lxx
 handler methods
Thread-Index: AQHWQ/Q8j4hpKScBzEO+XPSykaTGM6jciEDAgAACHMA=
Date:   Wed, 17 Jun 2020 09:26:41 +0000
X-TSB-HOP: ON
Message-ID: <OSBPR01MB2983F4C32B052F1438964A93929A0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
References: <20200616153100.633279950@linuxfoundation.org>
 <20200616153103.838898964@linuxfoundation.org>
 <OSBPR01MB29835381F4879AF2614194F3929A0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB29835381F4879AF2614194F3929A0@OSBPR01MB2983.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=toshiba.co.jp;
x-originating-ip: [103.91.184.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0fdf65d-d3e8-4ce1-ccc5-08d812a08b53
x-ms-traffictypediagnostic: OSBPR01MB1912:
x-microsoft-antispam-prvs: <OSBPR01MB19123D58EFD95C70065E917C929A0@OSBPR01MB1912.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 04371797A5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tzZCtfPnu/dE90jnN73lodK03JZYScKMT8kYPJ/gciVmrK/BRhBe2OfxvSj3rDipgFIebGacDclRHLnhc/x6KfX8y64c48GJzoFgaY3kXi9S/8UEmZNplNpbgVG5nMh3/ojEUbU2rx8R7ovW+Eh7r/OVDGtNlKkClJtNsy+vU5qpFtDD4y+51goQf5J/hsHca3X+SP1KxGKqATgHvxYcgvgNvWb7jd9XDBKg4YyRLPBw8dN7h2CdVMOruObQgywVvYr0o5hn2Hqeh2Fypup0hfDaiI73QpBUxeJu3TI7oNXTJrDdPH0nP5IYjwKcP71u2J58zaN8K+4TkWGL1EboAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2983.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(53546011)(6506007)(316002)(2940100002)(4326008)(7696005)(33656002)(52536014)(54906003)(478600001)(110136005)(2906002)(186003)(66946007)(64756008)(66476007)(66556008)(83380400001)(66446008)(76116006)(9686003)(5660300002)(8676002)(26005)(8936002)(86362001)(71200400001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: UKVgtd3BqLfGAb0CJfU+Scp8+/QGCNn+n0Z+jXAbhmVzZbFeAqz2X/LtJFeJrOZx3UVFc/8YscQDLtEj5H0ptgwATmeMNKNdH8+UEWKnoBK0qY+SJZCHIPgpaYD7QbLZQS7FogIttCyZR88ESyLlP8cmimuEErIiRKq5eo0wal01h+eeeLpuXOXXr8FPSRARKDyWGEYC/p6kGeWN/BeHlc0E5l2CTzz84jkvlNYuuI1LsJKZ5SM5OxyyhrYhlt0ZHNpMs30LiqT+IX7cqsYGgTN2PR4JqN7o+NqC302R4VDkhAR8JZW+Jv49BrLTLM0XNhWi+RAM5iYx/2cHrUu+o2Q1mW81NNnAKHHJ6jbr9vilpeV2xI5ykkY7FdSCJbfyxVTMejOKel3l1BYLKN68OKBai45cXNKHug32dGsRZNiDAO00rAM2jVeL1uBs1GtDECNLpm4uc/BLx16+ewt+v3tDbpL3YG78qB/JoK72bQY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0fdf65d-d3e8-4ce1-ccc5-08d812a08b53
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2020 09:26:41.3388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7y82D41GdEXz9Dn65R0II+YJjK7cswJFyQMLy5apFuF6oKPottx2KGoSYSUSj7+f0kHe6Xhw3gntzUg4dz3nP2/JkCsqiFC+S22amObpSfjJi70Re+baFBpsi38YUWYE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1912
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgYWdhaW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogaXdhbWF0
c3Ugbm9idWhpcm8o5bKp5p2+IOS/oea0iyDilqHvvLPvvLfvvKPil6/vvKHvvKPvvLQpDQo+IFNl
bnQ6IFdlZG5lc2RheSwgSnVuZSAxNywgMjAyMCA2OjIzIFBNDQo+IFRvOiBHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgQXJkIEJpZXNoZXV2ZWwgPGFy
ZGJAa2VybmVsLm9yZz47IFJhZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWwuai53eXNvY2tpQGludGVs
LmNvbT4NCj4gU3ViamVjdDogUkU6IFtQQVRDSCA1LjQgMDY0LzEzNF0gQUNQSTogR0VEOiBhZGQg
c3VwcG9ydCBmb3IgX0V4eCAvIF9MeHggaGFuZGxlciBtZXRob2RzDQo+IA0KPiBIaSwNCj4gDQo+
ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBzdGFibGUtb3duZXJAdmdl
ci5rZXJuZWwub3JnIFttYWlsdG86c3RhYmxlLW93bmVyQHZnZXIua2VybmVsLm9yZ10gT24gQmVo
YWxmIE9mIEdyZWcgS3JvYWgtSGFydG1hbg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAxNywg
MjAyMCAxMjozNCBBTQ0KPiA+IFRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4g
Q2M6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBzdGFi
bGVAdmdlci5rZXJuZWwub3JnOyBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPjsNCj4g
UmFmYWVsDQo+ID4gSi4gV3lzb2NraSA8cmFmYWVsLmoud3lzb2NraUBpbnRlbC5jb20+DQo+ID4g
U3ViamVjdDogW1BBVENIIDUuNCAwNjQvMTM0XSBBQ1BJOiBHRUQ6IGFkZCBzdXBwb3J0IGZvciBf
RXh4IC8gX0x4eCBoYW5kbGVyIG1ldGhvZHMNCj4gPg0KPiA+IEZyb206IEFyZCBCaWVzaGV1dmVs
IDxhcmRiQGtlcm5lbC5vcmc+DQo+ID4NCj4gPiBjb21taXQgZWE2ZjNhZjRjNWU2M2Y2OTgxYzBi
MGFiOGViZWM0MzhlMmQ1ZWY0MCB1cHN0cmVhbS4NCj4gPg0KPiA+IFBlciB0aGUgQUNQSSBzcGVj
LCBpbnRlcnJ1cHRzIGluIHRoZSByYW5nZSBbMCwgMjU1XSBtYXkgYmUgaGFuZGxlZA0KPiA+IGlu
IEFNTCB1c2luZyBpbmRpdmlkdWFsIG1ldGhvZHMgd2hvc2UgbmFtaW5nIGlzIGJhc2VkIG9uIHRo
ZSBmb3JtYXQNCj4gPiBfRXh4IG9yIF9MeHgsIHdoZXJlIHh4IGlzIHRoZSBoZXggcmVwcmVzZW50
YXRpb24gb2YgdGhlIGludGVycnVwdA0KPiA+IGluZGV4Lg0KPiA+DQo+ID4gQWRkIHN1cHBvcnQg
Zm9yIHRoaXMgbWlzc2luZyBmZWF0dXJlIHRvIG91ciBBQ1BJIEdFRCBkcml2ZXIuDQo+ID4NCj4g
PiBDYzogdjQuOSsgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjQuOSsNCj4gPiBTaWduZWQt
b2ZmLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFJhZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWwuai53eXNvY2tpQGludGVsLmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24u
b3JnPg0KPiA+DQo+IA0KPiBUaGlzIHBhdGNoIGFsc28gcmVxdWlyZXMgdGhlIGZvbGxvd2luZyBw
YXRjaC4NCj4gUGxlYXNlIGFwcGx5IHRvIHRoaXMga2VybmVsIHZlcnNpb24sIDQuOSwgNC4xNCwg
NC4xOSwgNS42IGFuZCA1LjcuDQo+IA0KPiBGcm9tIGU1YzM5OWIwYmQ2NDkwYzEyYzBhZjJhOWVh
YTlkN2NkODA1ZDUyYzkgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxDQo+IEZyb206IEFyZCBCaWVz
aGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+IERhdGU6IFdlZCwgMjcgTWF5IDIwMjAgMTM6Mzc6
MDAgKzAyMDANCg0KSSB1cGRhdGUgd2l0aCB0aGUgY29ycmVjdCBpbmZvcm1hdGlvbi4NCg0KY29t
bWl0IGU1YzM5OWIwYmQ2NDkwYzEyYzBhZjJhOWVhYTlkN2NkODA1ZDUyYzkNCkF1dGhvcjogQXJk
IEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4NCkRhdGU6ICAgV2VkIE1heSAyNyAxMzozNzow
MCAyMDIwICswMjAwDQoNCi4uLi4NCg0KQmVzdCByZWdhcmRzLA0KICBOb2J1aGlybw0KDQo+IA0K
PiAgICAgQUNQSTogR0VEOiB1c2UgY29ycmVjdCB0cmlnZ2VyIHR5cGUgZmllbGQgaW4gX0V4eCAv
IF9MeHggaGFuZGxpbmcNCj4gDQo+ICAgICBDb21taXQgZWE2ZjNhZjRjNWU2M2Y2OSAoIkFDUEk6
IEdFRDogYWRkIHN1cHBvcnQgZm9yIF9FeHggLyBfTHh4IGhhbmRsZXINCj4gICAgIG1ldGhvZHMi
KSBhZGRlZCBhIHJlZmVyZW5jZSB0byB0aGUgJ3RyaWdnZXJpbmcnIGZpZWxkIG9mIGVpdGhlciB0
aGUNCj4gICAgIG5vcm1hbCBvciB0aGUgZXh0ZW5kZWQgQUNQSSBJUlEgcmVzb3VyY2Ugc3RydWN0
LCBidXQgaW5hZHZlcnRlbnRseSB1c2VkDQo+ICAgICB0aGUgd3JvbmcgcG9pbnRlciBpbiB0aGUg
bGF0dGVyIGNhc2UuIE5vdGUgdGhhdCBib3RoIHBvaW50ZXJzIHJlZmVyIHRvIHRoZQ0KPiAgICAg
c2FtZSB1bmlvbiwgYW5kIHRoZSAndHJpZ2dlcmluZycgZmllbGQgYXBwZWFycyBhdCB0aGUgc2Ft
ZSBvZmZzZXQgaW4gYm90aA0KPiAgICAgc3RydWN0IHR5cGVzLCBzbyBpdCBjdXJyZW50bHkgaGFw
cGVucyB0byB3b3JrIGJ5IGFjY2lkZW50LiBCdXQgbGV0J3MgZml4DQo+ICAgICBpdCBub25ldGhl
bGVzcw0KPiANCj4gICAgIEZpeGVzOiBlYTZmM2FmNGM1ZTYzZjY5ICgiQUNQSTogR0VEOiBhZGQg
c3VwcG9ydCBmb3IgX0V4eCAvIF9MeHggaGFuZGxlciBtZXRob2RzIikNCj4gICAgIFNpZ25lZC1v
ZmYtYnk6IEFyZCBCaWVzaGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+DQo+ICAgICBTaWduZWQtb2Zm
LWJ5OiBSYWZhZWwgSi4gV3lzb2NraSA8cmFmYWVsLmoud3lzb2NraUBpbnRlbC5jb20+DQo+IA0K
PiBCZXN0IHJlZ2FyZHMsDQo+ICAgTm9idWhpcm8NCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
YWNwaS9ldmdlZC5jIHwgICAyMiArKysrKysrKysrKysrKysrKysrLS0tDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gLS0tIGEv
ZHJpdmVycy9hY3BpL2V2Z2VkLmMNCj4gPiArKysgYi9kcml2ZXJzL2FjcGkvZXZnZWQuYw0KPiA+
IEBAIC03OSw2ICs3OSw4IEBAIHN0YXRpYyBhY3BpX3N0YXR1cyBhY3BpX2dlZF9yZXF1ZXN0X2lu
dGUNCj4gPiAgCXN0cnVjdCByZXNvdXJjZSByOw0KPiA+ICAJc3RydWN0IGFjcGlfcmVzb3VyY2Vf
aXJxICpwID0gJmFyZXMtPmRhdGEuaXJxOw0KPiA+ICAJc3RydWN0IGFjcGlfcmVzb3VyY2VfZXh0
ZW5kZWRfaXJxICpwZXh0ID0gJmFyZXMtPmRhdGEuZXh0ZW5kZWRfaXJxOw0KPiA+ICsJY2hhciBl
dl9uYW1lWzVdOw0KPiA+ICsJdTggdHJpZ2dlcjsNCj4gPg0KPiA+ICAJaWYgKGFyZXMtPnR5cGUg
PT0gQUNQSV9SRVNPVVJDRV9UWVBFX0VORF9UQUcpDQo+ID4gIAkJcmV0dXJuIEFFX09LOw0KPiA+
IEBAIC04NywxNCArODksMjggQEAgc3RhdGljIGFjcGlfc3RhdHVzIGFjcGlfZ2VkX3JlcXVlc3Rf
aW50ZQ0KPiA+ICAJCWRldl9lcnIoZGV2LCAidW5hYmxlIHRvIHBhcnNlIElSUSByZXNvdXJjZVxu
Iik7DQo+ID4gIAkJcmV0dXJuIEFFX0VSUk9SOw0KPiA+ICAJfQ0KPiA+IC0JaWYgKGFyZXMtPnR5
cGUgPT0gQUNQSV9SRVNPVVJDRV9UWVBFX0lSUSkNCj4gPiArCWlmIChhcmVzLT50eXBlID09IEFD
UElfUkVTT1VSQ0VfVFlQRV9JUlEpIHsNCj4gPiAgCQlnc2kgPSBwLT5pbnRlcnJ1cHRzWzBdOw0K
PiA+IC0JZWxzZQ0KPiA+ICsJCXRyaWdnZXIgPSBwLT50cmlnZ2VyaW5nOw0KPiA+ICsJfSBlbHNl
IHsNCj4gPiAgCQlnc2kgPSBwZXh0LT5pbnRlcnJ1cHRzWzBdOw0KPiA+ICsJCXRyaWdnZXIgPSBw
LT50cmlnZ2VyaW5nOw0KPiA+ICsJfQ0KPiA+DQo+ID4gIAlpcnEgPSByLnN0YXJ0Ow0KPiA+DQo+
ID4gLQlpZiAoQUNQSV9GQUlMVVJFKGFjcGlfZ2V0X2hhbmRsZShoYW5kbGUsICJfRVZUIiwgJmV2
dF9oYW5kbGUpKSkgew0KPiA+ICsJc3dpdGNoIChnc2kpIHsNCj4gPiArCWNhc2UgMCAuLi4gMjU1
Og0KPiA+ICsJCXNwcmludGYoZXZfbmFtZSwgIl8lYyUwMmhoWCIsDQo+ID4gKwkJCXRyaWdnZXIg
PT0gQUNQSV9FREdFX1NFTlNJVElWRSA/ICdFJyA6ICdMJywgZ3NpKTsNCj4gPiArDQo+ID4gKwkJ
aWYgKEFDUElfU1VDQ0VTUyhhY3BpX2dldF9oYW5kbGUoaGFuZGxlLCBldl9uYW1lLCAmZXZ0X2hh
bmRsZSkpKQ0KPiA+ICsJCQlicmVhazsNCj4gPiArCQkvKiBmYWxsIHRocm91Z2ggKi8NCj4gPiAr
CWRlZmF1bHQ6DQo+ID4gKwkJaWYgKEFDUElfU1VDQ0VTUyhhY3BpX2dldF9oYW5kbGUoaGFuZGxl
LCAiX0VWVCIsICZldnRfaGFuZGxlKSkpDQo+ID4gKwkJCWJyZWFrOw0KPiA+ICsNCj4gPiAgCQlk
ZXZfZXJyKGRldiwgImNhbm5vdCBsb2NhdGUgX0VWVCBtZXRob2RcbiIpOw0KPiA+ICAJCXJldHVy
biBBRV9FUlJPUjsNCj4gPiAgCX0NCj4gPg0KDQo=
