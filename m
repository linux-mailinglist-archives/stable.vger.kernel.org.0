Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8454F1D2B00
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 11:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgENJLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 05:11:06 -0400
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:59425
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725925AbgENJLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 05:11:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StkqR1UrFR8J+y/pcl+2cvH842H3Inhuc7XBfoFebn3zrW4dzCiwk03D3xEu/3iUwvvyibabI/dOm+4bCnbe37dEilDyegM6k9AnOv5x0Qo91nvFNrf7vXBVuxTrMTKz5JnWmaxzDV9em3+VIPPZNF8y+i30m1hceyuVNSPmXW1EeZgF3RIINlmK66hGHTE/UV5UopLEwllkOq+Juo1MFTKfPlonWPbGMVVuZYFDSuvEtGCfvUMGRy5X/VEaWA/bPDmHgEF3dA7QIX3AN8YwjsvEXvEd0WSZ+QJy7DHKT08MPLUrbL8owQ5YTKiAYfRyb85DzhakBOHHBCMeisAOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn8KunGMnX0oMCzCJKUTPa7BYrM4KczXk5XY1nt/TJ0=;
 b=AyNARNO/26eyUlrNynQbiq4sdv++tTh/BJsm4kLXNBgH0g7FXYpgUMh32rWN0D3TCy5YkHMlCvvlCmn5+VxdT28z1z2j3gGwBqm8g3Fg244I89ZFXDxVuS/4ELUQBSujCLusYWar6qDVQ07qDBXtZiw0TvTCGbKDTBmhcSFYqfbfm+Fkvp7kc/4CR3ajycm6WXjIM7FivlXW9RS8zu5PIcCYldxkmMpp3JIYfYvaUs3y590aO6WV4fsEU/zhTMSOPcoi6NX+Iuh8uhTL0XCr1Q2RdHU8v8TUKPVI35MzWeN+OPutB3lg9MYvVVr3Zf7nTmGZ6KTAurd4f24q+gBB3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn8KunGMnX0oMCzCJKUTPa7BYrM4KczXk5XY1nt/TJ0=;
 b=E54ZCSVdl4fnuo60nWY2GxK2SQhFNwc7bXwKzNwTjQbpNZHjFZFX/uLXxsnwU0zTOYPp7jeZhgW7jv2pELxAyNeKGqRhgY6PqL9jzWtw60lwTZWq5DO46h1HnmCBNPGW4d/zZFjeR7Ys/6y/eKEZAvEHQ3zHxB2lDJy6Fa1m6aM=
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com (2603:10a6:20b:118::20)
 by AM7PR04MB7080.eurprd04.prod.outlook.com (2603:10a6:20b:11b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Thu, 14 May
 2020 09:11:01 +0000
Received: from AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792]) by AM7PR04MB7157.eurprd04.prod.outlook.com
 ([fe80::7c34:7ade:17d0:b792%9]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 09:11:01 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Jun Li <jun.li@nxp.com>, Manu Gautam <mgautam@codeaurora.org>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: =?utf-8?B?UkU6IOWbnuWkjTogW1BBVENIIDEvMV0gdXNiOiBob3N0OiB4aGNpLXBsYXQ6?=
 =?utf-8?Q?_keep_runtime_active_when_remove_host?=
Thread-Topic: =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggMS8xXSB1c2I6IGhvc3Q6IHhoY2ktcGxhdDoga2Vl?=
 =?utf-8?Q?p_runtime_active_when_remove_host?=
Thread-Index: AQHWKAYIb9tWY8B1fk+YJlcdJaEypKij0LUAgAACtbCAATdlgIABD38AgAC0rICAAACTgIAAfnKAgAAAhGA=
Date:   Thu, 14 May 2020 09:11:01 +0000
Message-ID: <AM7PR04MB7157262EBB26A33F69226AE48BBC0@AM7PR04MB7157.eurprd04.prod.outlook.com>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
 <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>
 <62e24805-5c80-f6b4-b8ba-cb6d649a878b@linux.intel.com>
 <VE1PR04MB6528D2A1C08ED9F091BCF3FD89BF0@VE1PR04MB6528.eurprd04.prod.outlook.com>
 <20200514013221.GA20346@b29397-desktop>
 <20200514013425.GB10515@rowland.harvard.edu>
 <ac353786-16a5-8e23-4948-fbdef30a786f@linux.intel.com>
In-Reply-To: <ac353786-16a5-8e23-4948-fbdef30a786f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c19184d4-2dec-4972-e83c-08d7f7e6b934
x-ms-traffictypediagnostic: AM7PR04MB7080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB7080AFFF273BC3B54B1678CE8BBC0@AM7PR04MB7080.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3NzqRhdmnYumjYgjvA5ZE/hE9ZyQitmX1QfvDadOCJDtTr17SV+S7J1U+m3oois4c7y6XHUwNoCyeJnJl7qXF39hPzpsYwiHnYjPjA17L5h3A7jLUxYAZiKXCwWIFP9O1tNiXwqOXw2SmOl8VBDvwHbCOLl3kQTwIGlHRq51ZOf1juGj67hnLJ90xbxNNFlCgPZOVf+dARhAd8+f13/ZqELvKJra5rHsr1pYbhtMNS4KRQLEoMXPHfGQuEGUC+C5AzfLS5b/N2VtbwOY8E5tbX+A4V9EYwo234h5Oolceiioy4vxROYF4I3azhIY+sIMRG81q5UAMUIACWJO+3qguhncEfzQois33lmf5XRdVfvZvR00Px9PtptkfwyN7iIyFNJuqWy6s9CiVcgphtYfCNIU6NKIYO2MKizunIZXJTRJQCM/ooKASYOueYlajgWF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7157.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(55016002)(9686003)(478600001)(110136005)(316002)(54906003)(8936002)(86362001)(186003)(2906002)(76116006)(4326008)(66446008)(66476007)(66946007)(66556008)(44832011)(64756008)(71200400001)(7696005)(5660300002)(224303003)(6506007)(52536014)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 30HtN8aPWv3kMW5iqswpLArLb5vwKLoPftn8pkcmayQvehkJuJUeIYRF1n4I+rrYg9cF20gBnoK08ZQnLnG0R4cCIiH5hWFcTFwE9NuoFHR9X3vvamjSTW7uFgpyIoC4LocechTPMd3ppm2nPLpCldGppHssuNGLa4Nq1YDt4K3mevxg+OIZFHiWUJkzkeL02SULbXNr1T/F9/w9ewK+tSQTePezCL91sd8AowJ66GsrPTaGS7nm0782v8MJZr9UYu5EfW/Uo5FeYLAx0ckBDRiQiHawGqlLVDVI9Z1u3j/Wnto1bpQ9IBPvVJlFML6hepzsmsJiUNSDu7Noaa4UNuXS6hwg9gw/EgFgdDuDQLZpxKNt96USNIbWpAh7dKhc8WTOeC3tG6VkqaUTtyl90atYagRYRRuipH7Dq/UFyZ3Dl0ClVPs5wjG6DgOhR07B6zX3aY7BRHe0TUmzS1rANm0dXY9xT1wtHB/9RLRkR3o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19184d4-2dec-4972-e83c-08d7f7e6b934
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 09:11:01.6860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 26t8hdpeDntzKHDbzWS3R6+i56F/fGwaFzbFaKauJjxbFGYHjCr784xrpyaQZP33aiQ1oInOV4sF2Pn/Qpultw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7080
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IA0KPiA+Pj4NCj4gPj4+PiB4aGNpX3BsYXRfcmVtb3ZlKCkNCj4gPj4+DQo+ID4+Pj4gwqAgcG1f
cnVudGltZV9kaXNhYmxlKCkNCj4gPj4+DQo+ID4+Pj4gwqAgPHJlbW92ZSBhbmQgcHV0IGJvdGgg
aGNkJ3M+DQo+ID4+Pg0KPiA+Pj4+IMKgIHBtX3J1bnRpbWVfc2V0X3N1c3BlbmRlZCgpDQo+ID4+
Pg0KPiA+Pj4NCj4gPj4+DQo+ID4+Pj4gb3IgcG9zc2libHkgd3JhcHBpbmcgdGhlIHJlbW92ZSBp
biBhIHJ1bnRpbWUgZ2V0L3B1dDoNCj4gPj4+DQo+ID4+Pj4geGhjaV9wbGF0X3JlbW92ZSgpDQo+
ID4+Pg0KPiA+Pj4+ICBwbV9ydW50aW1lX2dldF9ub3Jlc3VtZSgpDQo+ID4+Pg0KPiA+Pj4+IMKg
IHBtX3J1bnRpbWVfZGlzYWJsZSgpDQo+ID4+Pg0KPiA+Pj4gwqA+ICA8cmVtb3ZlIGFuZCBwdXQg
Ym90aCBoY2Qncz4NCj4gPj4+DQo+ID4+PiDCoD4gIHBtX3J1bnRpbWVfc2V0X3N1c3BlbmRlZCgp
DQo+ID4+Pg0KPiA+Pj4gwqA+ICBwbV9ydW50aW1lX3B1dF9ub2lkbGUoKQ0KPiA+Pj4NCj4gPj4+
IEkgdGhpbmsgaXQncyBiZXR0ZXIgdG8ga2VlcCBydW50aW1lIGFjdGl2ZSBkdXJpbmcgZHJpdmVy
IHJlbW92YWwsDQo+ID4+PiBob3cgYWJvdXQgdGhpczoNCj4gPj4+DQo+ID4+PiBwbV9ydW50aW1l
X2dldF9zeW5jKCkNCj4gPj4+IDxyZW1vdmUgYW5kIHB1dCBib3RoIGhjZCdzPg0KPiA+Pj4gcG1f
cnVudGltZV9kaXNhYmxlKCkNCj4gPj4+IHBtX3J1bnRpbWVfcHV0X25vaWRsZSgpDQo+ID4+PiBw
bV9ydW50aW1lX3NldF9zdXNwZW5kZWQoKQ0KPiA+Pj4NCj4gPj4NCj4gPj4gSSB0aGluayBpdCBp
cyBtb3JlIHJlYXNvbmFibGUgc2luY2UgZm9yIHNvbWUgRFJEIGNvbnRyb2xsZXJzIGlmIERSRA0K
PiA+PiBjb3JlIGlzIHN1c3BlbmRlZCwgYWNjZXNzIHRoZSB4SENJIHJlZ2lzdGVyIChlZywgd2Ug
cmVtb3ZlDQo+ID4+IHhoY2ktcGxhdC1oY2QgbW9kdWxlIGF0IHRoZSB0aW1lKSBtYXkgaGFuZyB0
aGUgc3lzdGVtLiBBbGFuICYNCj4gPj4gTWF0aGlhcywgd2hhdCdzIHlvdXIgb3Bpbmlvbj8NCj4g
DQo+IE1ha2VzIHNlbnNlIHRvIG1lDQo+IA0KPiA+DQo+ID4gSnVuJ3Mgc3VnZ2VzdGlvbiBsb29r
cyBnb29kIHRvIG1lLg0KPiA+DQo+ID4gQWxhbiBTdGVybg0KPiA+DQo+IA0KPiBHcmVhdCwgbGV0
cyBnbyB3aXRoIHRoaXMgdGhlbi4NCj4gSnVuLCBvciBQZXRlciwgY291bGQgeW91IHR1cm4gdGhp
cyBpbnRvIGEgcGF0Y2ggYW5kIGNoZWNrIHRoYXQgaXQgd29ya3M/DQo+IEkgb25seSBnb3QgUENJ
IHhIQydzIHRvIHBsYXkgd2l0aCBteXNlbGYuDQo+IA0KIA0KSnVuLCB3b3VsZCB5b3UgcGxlYXNl
IGNyZWF0ZSBhIHBhdGNoIGZvciBpdC4gSSBoYXZlIHRlc3RlZCBpdCBhdCBDRE5TMyBwbGF0Zm9y
bSwNCmZlZWwgZnJlZSBhZGQgbXkgdGFnLg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgQ2hlbiA8cGV0
ZXIuY2hlbkBueHAuY29tPg0KVGVzdGVkLWJ5OiBQZXRlciBDaGVuIDxwZXRlci5jaGVuQG54cC5j
b20+DQoNClBldGVyDQo=
