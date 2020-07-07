Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365AB21637B
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 03:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgGGBsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 21:48:24 -0400
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:31974
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbgGGBsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 21:48:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHFU8mbQfiQlnWRGAfaqubxVsSfFvhp8vvQWJJs8ll/5HG97+8RklJLMDCuFcXslsQEJIJ7pQS2SwVABpYUlkopXhTLpbxHKSttxg1NkZkdNKAqmV2AOL/3AMizNOYl/9mcqfiNDxTvOpUPP2vUe9YPlDmzlMSFdcchUb22r8yfSo9JQUzqYusBwaBUWez3wXF4UKoyrkM9xudAZKCnK41zMaAoimv6WzWjFuGYEqq+QThUUFG4rT7CvevroJgRSSdMKZnimYzcYuQSrBEo6dCAw3YNXgCcqzb20cGMpwZRaLQgPYnCft7LJ0b5bPJHZJoNzP5RBrb8wCPO3hMohig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htoyR3RnNmHCqhs7aoPywtEJO8pw6YKvndEVw5xfhdI=;
 b=IMo42xQbpz7/91YSCjsPfBs9jWqFvy64rcocL4ZYNLVOrQBSjdxtJubVyusz6HomLcwmGUt7Radu4M6fDAt8ffDrviFeDVrLTIpc30OQcRkEjSIVNnsh38bAV+QP87U6u651vXKmebmcB/2uCKxDWBbCkdoEq3DRAkPhDRZSlBGSbQmyckqbLjPWpNM4MINpjpMY13JzuH3D6tg8lQToVv4PFaoC4d1tCiTnRTVfUSjqCyvvSmULKsavwi2sjiR9wtKQ+zPX8ovJmwqebH4cKv3ddYfikTfRaq7mWfZFiOI8pmkVbshzlo7jUV7oNrjyPDuQCR2QTWm04cyQn6PX9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htoyR3RnNmHCqhs7aoPywtEJO8pw6YKvndEVw5xfhdI=;
 b=Mu1hsetdKcHFg4yO+XbHPuVlPkuKwp+i9Ozb+JFUMjpwUUj3ofGS6jYmLIruyM65OAWdSt9I/JLJeGJJKSB4UWBGq8khuR856Yy20IwqI4hS2q033bazUr4oUf4032ncB5pf91pVqbxtUg+uNPFB4PowywpbkUQGR2kqOAKr28U=
Received: from VI1PR04MB5294.eurprd04.prod.outlook.com (2603:10a6:803:5a::22)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Tue, 7 Jul
 2020 01:48:18 +0000
Received: from VI1PR04MB5294.eurprd04.prod.outlook.com
 ([fe80::7545:cf5d:b8b0:4ab0]) by VI1PR04MB5294.eurprd04.prod.outlook.com
 ([fe80::7545:cf5d:b8b0:4ab0%5]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 01:48:18 +0000
From:   BOUGH CHEN <haibo.chen@nxp.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Adrian Hunter <adrian.hunter@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Doug Anderson <dianders@chromium.org>,
        "huyue2@yulong.com" <huyue2@yulong.com>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: RE: [PATCH] mmc: sdio: fix clock rate setting for SDR12/SDR25 mode
Thread-Topic: [PATCH] mmc: sdio: fix clock rate setting for SDR12/SDR25 mode
Thread-Index: AQHWSG9zIVpO28pXb0uRXZeXAQnnLKj6uFAAgAC2rQA=
Date:   Tue, 7 Jul 2020 01:48:18 +0000
Message-ID: <VI1PR04MB5294D51A326E7B010D10DE1490660@VI1PR04MB5294.eurprd04.prod.outlook.com>
References: <1592813959-5914-1-git-send-email-haibo.chen@nxp.com>
 <CAPDyKFphkPAgcOEd=j8EUoFyAz7Oj8DEXbgK=k7R15rizWWcTw@mail.gmail.com>
In-Reply-To: <CAPDyKFphkPAgcOEd=j8EUoFyAz7Oj8DEXbgK=k7R15rizWWcTw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30a65119-0908-4df7-f34c-08d82217d278
x-ms-traffictypediagnostic: VI1PR0402MB3615:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3615CCF5013F8468D9ADFC2C90660@VI1PR0402MB3615.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qAVopbGC8crpegzOKrO6WcP/UM3BTTDgUMMaWJ3E4JKmx+tHHlfNLtJVbUlI6lXbl+TpKqK+0nKzowsGTy+KZo5N747E5oosUU33yDc3LsoZgyn4zY/wOG8e9nyfhVtrjYEiXHiNzlg3+F6ljeuaKhBEj3inFS1j9ZefHTldAmcizevvVYuiXMtCCAyQzxdtfh3u+ke+iPNgZs4s90iElyWDZD0bAAy230rASMtT49QLuF7rLinqkRCsJKqykWXPZuX+mT+ygWi4+B4VxPLK3KlkqjMsPZSpnOMfl2XZ3nYM509ZC1+uLOZWUSVWy1y0CmjZmcDgjryyXGtpQwp/VA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5294.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(110136005)(66476007)(66946007)(66446008)(64756008)(66556008)(316002)(55016002)(54906003)(2906002)(9686003)(71200400001)(7696005)(33656002)(4326008)(8936002)(83380400001)(8676002)(478600001)(76116006)(86362001)(26005)(186003)(5660300002)(52536014)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: E/6xjj/m7RmvpJON5SYtn8bFNKK6Dc6HubQWZviOhF+VYoTwH6J6BXcqbMb6Z02mJS0ziSUxYDg4/EYbOiZxyhJjXzCmj3fjBD/1LNCug5uXnFOVMNp52hNytOvryzpokNij/iMoNsbnnNjKWcfmb/93V+t6czggb9Lo812CzMlfu3TXy5NutRn5c5iLea7rowpLdVnkIkEOsG0MMTUQfdqNoNBQZrva05flzc66SDz9g50zKLAK7yaqNJEit3mrCd9WbMdQ5t6tXYuwbEEV2awTy81m7M53wRD1L0E3polbcKg0dAZADqb+JWnCNmYh7GNIlRMOoy9XIfumwiwcV53tBTJrN3qmjMuXJBeOLd1zdb4+3cMbIWgnjhPESLL/s3Aj+otjQSGbSjVE+kikygUHuMxXWEOTe40AN6onRudbL3U9uQL5ryFnXXl6O0Bq6jY8pQjKi4jskgvBhv1Dd0TrvU9WEwvMfwUpZvZ68Yg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5294.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a65119-0908-4df7-f34c-08d82217d278
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 01:48:18.2220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTsNyM0DrR7Vn/CRL5abJMUAcJOIvu5OYAJ4Ttb0y+11zavviDkFmd5z26BX5veaYmv5AtpDe2o+Ynft1aO3ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBVbGYgSGFuc3NvbiBbbWFpbHRv
OnVsZi5oYW5zc29uQGxpbmFyby5vcmddDQo+IFNlbnQ6IDIwMjDlubQ35pyINuaXpSAyMjo0OQ0K
PiBUbzogQk9VR0ggQ0hFTiA8aGFpYm8uY2hlbkBueHAuY29tPg0KPiBDYzogQWRyaWFuIEh1bnRl
ciA8YWRyaWFuLmh1bnRlckBpbnRlbC5jb20+OyBsaW51eC1tbWNAdmdlci5rZXJuZWwub3JnOw0K
PiBQYWxpIFJvaMOhciA8cGFsaUBrZXJuZWwub3JnPjsgZGwtbGludXgtaW14IDxsaW51eC1pbXhA
bnhwLmNvbT47IEFuZHkgRHVhbg0KPiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT47IERvdWcgQW5kZXJz
b24gPGRpYW5kZXJzQGNocm9taXVtLm9yZz47DQo+IGh1eXVlMkB5dWxvbmcuY29tOyBNYXR0aGlh
cyBLYWVobGNrZSA8bWthQGNocm9taXVtLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbW1j
OiBzZGlvOiBmaXggY2xvY2sgcmF0ZSBzZXR0aW5nIGZvciBTRFIxMi9TRFIyNSBtb2RlDQo+IA0K
PiBPbiBNb24sIDIyIEp1biAyMDIwIGF0IDEwOjMwLCA8aGFpYm8uY2hlbkBueHAuY29tPiB3cm90
ZToNCj4gPg0KPiA+IEZyb206IEhhaWJvIENoZW4gPGhhaWJvLmNoZW5AbnhwLmNvbT4NCj4gPg0K
PiA+IEluIGN1cnJlbnQgY29kZSBsb2dpYywgd2hlbiB3b3JrIGluIFNEUjEyL1NEUjI1IG1vZGUs
IHRoZSBmaW5hbCBjbG9jaw0KPiA+IHJhdGUgaXMgaW5jb3JyZWN0LCBqdXN0IHRoZSBsZWdhbmN5
IDQwMEtIeiwgYmVjYXVzZSB0aGUNCj4gPiBjYXJkLT5zd19jYXBzLnNkM19idXNfbW9kZSBkbyBu
b3QgaGFzIHRoZSBmbGFnIFNEX01PREVfVUhTX1NEUjEyIG9yDQo+ID4gU0RfTU9ERV9VSFNfU0RS
MjUuIEJlc2lkZXMsIFNESU9fU1BFRURfU0RSMTIgaXMgYWN0dWFsbHkgdmFsdWUgMCwgYW5kDQo+
ID4gZXZlcnkgbW9kZSBuZWVkIHRvIGNvbmZpZyB0aGUgdGltaW5nIGFuZCBjbG9jayByYXRlLCBz
byByZW1vdmUgdGhlDQo+ID4g4oCYaWbigJkgb3BlcmF0b3IuDQo+ID4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBIYWlibyBDaGVuIDxoYWliby5jaGVuQG54cC5jb20+DQo+IA0KPiBUaGlzIGxvb2tzIGxp
a2UgYSByYXRoZXIgc2VyaW91cyBlcnJvciwgc2hvdWxkIHdlIHRhZyB0aGlzIGZvciBzdGFibGU/
DQoNClllcywgbmVlZCB0byBkbyB0aGF0Lg0KDQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+
DQoNCkJlc3QgUmVnYXJkcw0KSGFpYm8gQ2hlbg0KPiANCj4gSW4gdGhlIG1lYW50aW1lLCBJIGhh
dmUgYXBwbGllZCB0aGlzIGZvciBuZXh0IHRvIGdldCBpdCB0ZXN0ZWQsIHRoYW5rcyENCj4gDQo+
IEtpbmQgcmVnYXJkcw0KPiBVZmZlDQo+IA0KPiANCj4gDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bW1jL2NvcmUvc2Rpby5jIHwgMTUgKysrKysrKystLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCA4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tbWMvY29yZS9zZGlvLmMgYi9kcml2ZXJzL21tYy9jb3JlL3NkaW8uYyBpbmRleA0K
PiA+IDBlMzJjYTdiOTQ4OC4uN2I0MDU1M2QzOTM0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bW1jL2NvcmUvc2Rpby5jDQo+ID4gKysrIGIvZHJpdmVycy9tbWMvY29yZS9zZGlvLmMNCj4gPiBA
QCAtMTc2LDE1ICsxNzYsMTggQEAgc3RhdGljIGludCBzZGlvX3JlYWRfY2NjcihzdHJ1Y3QgbW1j
X2NhcmQgKmNhcmQsDQo+IHUzMiBvY3IpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgaWYg
KG1tY19ob3N0X3VocyhjYXJkLT5ob3N0KSkgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgaWYgKGRhdGEgJiBTRElPX1VIU19ERFI1MCkNCj4gPg0KPiBjYXJkLT5zd19jYXBz
LnNkM19idXNfbW9kZQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHw9DQo+IFNEX01PREVfVUhTX0REUjUwOw0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHw9DQo+IFNEX01PREVfVUhTX0REUjUwIHwg
U0RfTU9ERV9VSFNfU0RSNTANCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiArIFNEX01PREVfVUhTX1NEUjI1IHwgU0RfTU9E
RV9VSFNfU0RSMTI7DQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlm
IChkYXRhICYgU0RJT19VSFNfU0RSNTApDQo+ID4NCj4gY2FyZC0+c3dfY2Fwcy5zZDNfYnVzX21v
ZGUNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
PQ0KPiBTRF9NT0RFX1VIU19TRFI1MDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8PQ0KPiBTRF9NT0RFX1VIU19TRFI1MCB8IFNEX01PREVfVUhT
X1NEUjI1DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8DQo+ID4gKyBTRF9NT0RFX1VIU19TRFIxMjsNCj4gPg0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGRhdGEgJiBTRElPX1VIU19TRFIxMDQpDQo+ID4N
Cj4gY2FyZC0+c3dfY2Fwcy5zZDNfYnVzX21vZGUNCj4gPiAtICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB8PQ0KPiBTRF9NT0RFX1VIU19TRFIxMDQ7DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfD0NCj4gU0Rf
TU9ERV9VSFNfU0RSMTA0IHwgU0RfTU9ERV9VSFNfU0RSNTANCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gPiArIFNEX01PREVf
VUhTX1NEUjI1IHwgU0RfTU9ERV9VSFNfU0RSMTI7DQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgfQ0KPiA+DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gbW1jX2lvX3J3X2Rp
cmVjdChjYXJkLCAwLCAwLCBAQA0KPiAtNTM3LDEwDQo+ID4gKzU0MCw4IEBAIHN0YXRpYyBpbnQg
c2Rpb19zZXRfYnVzX3NwZWVkX21vZGUoc3RydWN0IG1tY19jYXJkICpjYXJkKQ0KPiA+ICAgICAg
ICAgbWF4X3JhdGUgPSBtaW5fbm90X3plcm8oY2FyZC0+cXVpcmtfbWF4X3JhdGUsDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjYXJkLT5zd19jYXBzLnVoc19tYXhfZHRyKTsN
Cj4gPg0KPiA+IC0gICAgICAgaWYgKGJ1c19zcGVlZCkgew0KPiA+IC0gICAgICAgICAgICAgICBt
bWNfc2V0X3RpbWluZyhjYXJkLT5ob3N0LCB0aW1pbmcpOw0KPiA+IC0gICAgICAgICAgICAgICBt
bWNfc2V0X2Nsb2NrKGNhcmQtPmhvc3QsIG1heF9yYXRlKTsNCj4gPiAtICAgICAgIH0NCj4gPiAr
ICAgICAgIG1tY19zZXRfdGltaW5nKGNhcmQtPmhvc3QsIHRpbWluZyk7DQo+ID4gKyAgICAgICBt
bWNfc2V0X2Nsb2NrKGNhcmQtPmhvc3QsIG1heF9yYXRlKTsNCj4gPg0KPiA+ICAgICAgICAgcmV0
dXJuIDA7DQo+ID4gIH0NCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo=
