Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7629B2CD948
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 15:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436634AbgLCOf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 09:35:27 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5675 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436632AbgLCOf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 09:35:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607006125; x=1638542125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vTXcx0IErMshe2XtTANjxvPmVgJpd2n6QyksbKHKAq4=;
  b=uSLE2MbidaHuqE5t95qVohg9mtzt0mn9OZ/5OkLfPZKL9XjHgsakXmaf
   wKO2zpQ8ZiBwch4e34MsO8YngMy+ANQ+y0BU7IaCY7G3vYQCuhySNbSwg
   WrlG8nIEaZuhR8p8Ye9PcEvn+qfhvT0hEb/zvNvqptvW6G03YDwB/ZYBn
   JZsCI2cEzu7cGAbLbW7xcCEgqLSq2z83/fkjmaJ2bmpHgAh/TaYWf7gR3
   W6Fxd7MIIoM/Umiw9/05/HZ58tpOd2QyuWgQNOwOIFWpBrQ5iQYW52nYg
   5LHSdNUKQ9EMQxHsCzxsp/25sZUea3bpwDksUFRdnkpT0lY9Hd3aIqb7Z
   g==;
IronPort-SDR: bnu8a5n8tRsuOV//0OUmrye2B8vEANQ1TtJBEBdHnslX4ijF+mKyz2Q4zy2LSxHGdwG+YtL3Wz
 VD8A71eBR/rXeyRVDbmcIxyq/BbET3W3y1l6lKdrdkUQ9lTMjSxoXEDCEdm72GnHr5TG0rEPzz
 PW6t7/lS2E1y5Y1cQQmhwLy8GPrX1H2tBppiWMSRdef3LSxDIQhnQT+Lnp/PPz1SGy/dQSmztF
 Eo10+euSWFfBarTAxw0vcijDd/LJhKFzVoHeQW9odj17c0/GvQmNsCOg0HW4CGexjCGViUBKqh
 L5o=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="35963898"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 07:34:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 07:34:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 3 Dec 2020 07:34:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4pV7du6qOlyv4CfmDka+ZqmcGcQ1AjpQ7yVQfGT6wC5Qne3uQsJCSyiCzPudb0W/OphAstXK782k9dKmfyaU4iMgVBYwX2i4moMN3CiWRXAL2i+WTMNAN6OwlHvnhsknmipFCItteWeEWaVWkrAIyXpUzIWl6Dp/r3a+p/yCyLMKzzbC59OeajC3yGG8qBa3BTv8fZaaFDyMY2mHnfVRFqzUEk/Z2Cav7153plEdtaLPeioIpnrn13dLa5YlcHYyqb+D/6+CBgoogj+w0A787DLw2shEGroyGDAzdBp4ecbc22gBIRxW2ZhNotdUieo0K+b+rjPjhbBRMJ/JdN1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTXcx0IErMshe2XtTANjxvPmVgJpd2n6QyksbKHKAq4=;
 b=EaKGe/UJPY2OyKIs2+3cPRXWchHmiA4IBAsz6b5Dk3SYEyTiVE9Q6tMLWvw+PdXnMEXzUqLo85VZFZ9fPwZtZj5UtzBH1oIudK6Zs8cIFCM3ewcBcT6BQZ2GC+7KOkxd2saRDZnBGGjil0Xm9M41tKKmgCU3amrlGyrmmHayzoPngogXmaRTEd851uWdGoZYxi9Th5EZzU94sMfk1XhuO1+4B4eDQJcfpmY3X0m9SQRzhpglMNXAr6ANISAyLOU1jjAKifkUGXXK5fnPT+UO4NaA5NuM29cwH0+W+FljxSxXGef4IWdigJTNOryVvdlmGcSfh2kDPB5/yaR809yeCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTXcx0IErMshe2XtTANjxvPmVgJpd2n6QyksbKHKAq4=;
 b=o0vOSe8qPL/Bxwh/jTW5yo5iOxkdbhlv67I9/3ej0ms3i7aAy3Dcze25XNL3LaQle4OE53ZeVwVvSrGxDz3VgOb3c15/FFOi855zDDwwp4Dpi24dG7CHXXWnbVQkoPl1oQBtgIjIgiBsGudrrXUvhC6+34fBMCdnQ7TK8okWwPw=
Received: from SA2PR11MB4874.namprd11.prod.outlook.com (2603:10b6:806:f9::23)
 by SA0PR11MB4750.namprd11.prod.outlook.com (2603:10b6:806:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 14:34:18 +0000
Received: from SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761]) by SA2PR11MB4874.namprd11.prod.outlook.com
 ([fe80::6903:3212:cc9e:761%7]) with mapi id 15.20.3632.020; Thu, 3 Dec 2020
 14:34:17 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <michael@walle.cc>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <boris.brezillon@collabora.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
Thread-Topic: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
Thread-Index: AQHWyYFhbYejLXpUREmrcdCKcR8FGQ==
Date:   Thu, 3 Dec 2020 14:34:17 +0000
Message-ID: <44be8e3c-86ca-501e-e575-55f17747bda6@microchip.com>
References: <20201202230040.14009-1-michael@walle.cc>
 <20201202230040.14009-2-michael@walle.cc>
In-Reply-To: <20201202230040.14009-2-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [79.115.63.95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 974217db-7acd-4eab-4464-08d897988410
x-ms-traffictypediagnostic: SA0PR11MB4750:
x-microsoft-antispam-prvs: <SA0PR11MB4750C904973E2C064546718EF0F20@SA0PR11MB4750.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SfvtGKDALkggJCntT1Be7GIsB/OaBIYPyamcELTlgxgBw2Jjz88m1avG/LlQQyjyBZtJTTTLJRnkk5ex3sVXf4ew1278qNr93FVJ8UkLhGIvilNhzK9L11jSYJnDi/rQYBZZB3P7kEXCr4ZEKlyu2Hwn53bGqNeRtnYlOugTG0Lf9MXv4UTZOiBWO/1fsq5bWKHQQI3khC/uWTX0s0EV/GVQndzoKgvVDo9PVDSAY4VwARbhez/L+BidzXIowEdPbXEZNP5S162RBPWRnML/5q78IazmHk6EdzT/AQuckQWOx1Xefxkom1e60RfIHUJHgBvdCNXdLU5P1v7QlFwpvQ4yZAOPKFz/vbsuoDP9geEzTBR2ubUV2EpxCGmC1S7ma2i1v5bxkCxTArOBCMEKl+qikKvY3aGQ5manSuHlgSk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4874.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(39860400002)(396003)(36756003)(8936002)(186003)(6486002)(66946007)(6512007)(5660300002)(26005)(8676002)(66476007)(66556008)(316002)(6506007)(53546011)(64756008)(66446008)(76116006)(71200400001)(2616005)(86362001)(4326008)(110136005)(31696002)(2906002)(31686004)(478600001)(54906003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WGplY2pHbGtNMU8rdFcxcHA3OEdaQkVxdHM1czYyQW96dHFML1VyK3dXSlpB?=
 =?utf-8?B?TCtDMmdWcjE4UEl0Uk1FZi9HeTd0OXdOUlU1YUZ5aWRKaWtGOUFKOGxDcjZU?=
 =?utf-8?B?SHpnQ21pT0RUdW9rMmlicFNJNWlUK01FVzVQR3pBYWJVeTdQaURHWlBsVVpp?=
 =?utf-8?B?d0dkYzZ5Z1dvQjZXUXRuZjl3V0p0cElWb0FCbWdXd1dIcTIvaDFYT0orbkpL?=
 =?utf-8?B?U2FMcFcxTkJLNUV5Slg3YUdIRUVUeHRScnhrSzRLYWZsU2J5cGxrTXdSZjl1?=
 =?utf-8?B?alRPM08vTXllWUlGdVBLTmQxQm1WWHRWMVhUNERHeFBDcXQ5YWhTcHh6Q1Rp?=
 =?utf-8?B?c01mUThxbnY1UVJ1blBSbndmam50OEQ2bGdrcFArakxpSkVSU3QrOEdTcE1O?=
 =?utf-8?B?TEYraEZ4MzhEYVd0ZjJYT1RJUFgxYmhtbjBtSzM3S3NWck5uMkJKN3U4eXNr?=
 =?utf-8?B?azlyaFJ0NnNXbnJCZHIveE9aTmh0bWtpUGJiSUtOKzR0L0VjcTJjZEYxbERr?=
 =?utf-8?B?VkZhMGduc2Y2bzBtLzVqUkpmakduT3B4d0MwNHNLN2lpRVNERytxNmV2MkEx?=
 =?utf-8?B?MU8rTjhRb25TZlMyM25QSVZDV204akpsbHVMRG1TMzBCbmd4d0gxbXpUbjM1?=
 =?utf-8?B?SWltQ3B4by9JRXkvTnJseVZhVFI1K2hwa3p0L2JOQWlrN2lNdzNuUVJRYVBH?=
 =?utf-8?B?MS9sMS9kTGpYV2tHbFJjVGhJQnl4UGZoeEtKTkVFRjc1VkpzdUpaOEpyWnBP?=
 =?utf-8?B?TnppelBHUUNVNUh2cFd2Q0U3QTZ4ZTV2d1k4Y2EzYTJibm54WENwTGgrS3B3?=
 =?utf-8?B?RmdwaEtvS3ZTL3RnTzlmbUlPTG9LVE90WWFjMlVObldicDg1dWRlbTh3S0lG?=
 =?utf-8?B?WXpVRGY4ZmhnSEw1cUN0MzNnckxOQThQK1JIWnFFeFBzUHlTWE44YUpBVXd6?=
 =?utf-8?B?T1BLWFpEK3dFVEtFZmh4UEh6VFFNRWNaVG5CZnhMMVFTYXlETHd1cWdpUGxi?=
 =?utf-8?B?blZzTThUZG5Td2F3c2wrNHNSNkhIeEs4c21zMHp2UlBSOW15YitOMnN6WXhF?=
 =?utf-8?B?cEVMcW42MkdsZzNoYnVKQzQvSk9YMEZWMVVZbkJPOEVrdjl2Z3hETW8ydERV?=
 =?utf-8?B?ZjhRclZleGptdFpTOFhsaFJORUFqWTE3bUp3bS8zZTFGams5dS81U1BNWUFW?=
 =?utf-8?B?NXA0WTJqZ0xzVUNwTHNPQzliUTNjazY1K0pUcWtUV3NVdGV4eWR0WkRRS0Ux?=
 =?utf-8?B?c216bEZVbUFoREUvZTFOVTIzRGkwZHhHYmFGU3dzZWZ4dTlMZFNHMlg3REpm?=
 =?utf-8?Q?wi8xys/hYSjpU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAC9C167A65E844FADB404438A21FC6D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4874.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974217db-7acd-4eab-4464-08d897988410
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 14:34:17.7316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kXhxVdOt1U7xT8nJ5r7gSOMhUo7DTlQ0g2eOg9DogrNGTGdYEV49L3mL/C+32ZIqIirYKOhekm4cUfbGKoDYDg8kfst6UXeSBT/6p29qsSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4750
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTIvMy8yMCAxOjAwIEFNLCBNaWNoYWVsIFdhbGxlIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IFRoaXMgZmxhc2ggcGFydCBhY3R1YWxseSBoYXMg
NCBibG9jayBwcm90ZWN0aW9uIGJpdHMuDQo+IA0KPiBSZXBvcnRlZC1ieTogVHVkb3IgQW1iYXJ1
cyA8dHVkb3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZyAjIHY1LjcrDQoNCldoaWxlIHRoZSBwYXRjaCBpcyBjb3JyZWN0IGFjY29yZGluZyB0byB0
aGUgZGF0YXNoZWV0LCBpdCB3YXMNCm5vdCB0ZXN0ZWQsIHNvIGl0J3Mgbm90IGEgY2FuZGlkYXRl
IGZvciBzdGFibGUuIEkgd291bGQgdXBkYXRlDQp0aGUgY29tbWl0IG1lc3NhZ2UgdG8gaW5kaWNh
dGUgdGhhdCB0aGUgdGhlIHBhdGNoIHdhcyBtYWRlDQpzb2xlbHkgb24gZGF0YXNoZWV0IGluZm8g
YW5kIG5vdCB0ZXN0ZWQsIEkgd291bGQgYWRkIHRoZSBmaXhlcw0KdGFnLCBhbmQgc3RyaXAgY2Mt
aW5nIHRvIHN0YWJsZS4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFdhbGxlIDxtaWNoYWVs
QHdhbGxlLmNjPg0KDQpXaXRoIHRoZSBhYm92ZSBhZGRyZXNzZWQ6DQoNClJldmlld2VkLWJ5OiBU
dWRvciBBbWJhcnVzIDx0dWRvci5hbWJhcnVzQG1pY3JvY2hpcC5jb20+DQoNCj4gLS0tDQo+IEkg
ZGlkbid0IGFkZCB0aGUgRml4ZXM6IHRhZyBiZWNhdXNlIHdlIGRlcGVuZCBvbiB0aGUgNGJpdCBC
UCBzdXBwb3J0IHdoaWNoDQo+IHdhcyBpbnRyb2R1Y2VkIGluIDUuNy4NCj4gDQo+IGNoYW5nZXMg
c2luY2UgdjY6DQo+ICAtIG5ldyBwYXRjaA0KPiANCj4gIGRyaXZlcnMvbXRkL3NwaS1ub3Ivc3N0
LmMgfCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbXRkL3NwaS1ub3Ivc3N0LmMgYi9kcml2
ZXJzL210ZC9zcGktbm9yL3NzdC5jDQo+IGluZGV4IGUwYWY2ZDI1ZDU3My4uMGFiMDc2MjRmYjcz
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL210ZC9zcGktbm9yL3NzdC5jDQo+ICsrKyBiL2RyaXZl
cnMvbXRkL3NwaS1ub3Ivc3N0LmMNCj4gQEAgLTE4LDcgKzE4LDggQEAgc3RhdGljIGNvbnN0IHN0
cnVjdCBmbGFzaF9pbmZvIHNzdF9wYXJ0c1tdID0gew0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBTRUNUXzRLIHwgU1NUX1dSSVRFKSB9LA0KPiAgICAgICAgIHsgInNzdDI1dmYwMzJi
IiwgSU5GTygweGJmMjU0YSwgMCwgNjQgKiAxMDI0LCA2NCwNCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgU0VDVF80SyB8IFNTVF9XUklURSkgfSwNCj4gLSAgICAgICB7ICJzc3QyNXZm
MDY0YyIsIElORk8oMHhiZjI1NGIsIDAsIDY0ICogMTAyNCwgMTI4LCBTRUNUXzRLKSB9LA0KPiAr
ICAgICAgIHsgInNzdDI1dmYwNjRjIiwgSU5GTygweGJmMjU0YiwgMCwgNjQgKiAxMDI0LCAxMjgs
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFNFQ1RfNEsgfCBTUElfTk9SXzRCSVRf
QlApIH0sDQo+ICAgICAgICAgeyAic3N0MjV3ZjUxMiIsICBJTkZPKDB4YmYyNTAxLCAwLCA2NCAq
IDEwMjQsICAxLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTRUNUXzRLIHwgU1NU
X1dSSVRFKSB9LA0KPiAgICAgICAgIHsgInNzdDI1d2YwMTAiLCAgSU5GTygweGJmMjUwMiwgMCwg
NjQgKiAxMDI0LCAgMiwNCj4gLS0NCj4gMi4yMC4xDQo+IA0KDQo=
