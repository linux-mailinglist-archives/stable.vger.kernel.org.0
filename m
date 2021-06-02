Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492C2398EC0
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhFBPgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 11:36:39 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:28195
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231751AbhFBPgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 11:36:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5/4bW1R+leMQayui3FhtQ68LWyaLlhbuNp1GamjngestEckZjr5FjjUfd/VjOv1q/qCuvsEPe0iOXOhHI0JjmmQh+M4lekefAcLehr674vM+jdvq5DhaV4LAxw/IMe8Fhch6KanC+kb9rosLZylkol7GooDkjo5+h8W1OitjRdilLTBWCDStG7H1SSJW/SJz8Tk2U5pIGjsM7Cx2vdDiZ8j6rEJ6KfdxFKwB+gP5+MKbFnQvY/kKaRUBehgGCUtu4clRTW1ImW2hlXn5kXAbE9qu0LSR8LpZMl4xoQaATr10g8xBqjIS/fcv9VX+4gVZ6rTFO+UUov/WJZ4F3/u/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xh6VMRcvzEdS6gJSbBlfV0oLfwAeApt4YEbCidLYKpo=;
 b=ZYgAnku2thaO1o8Bw7SKZrpInj20XzsekIl/Q2EJOcHzl4Kx297N0awdP/V+JNLGGPkclRC1s6zClb/3MKAlMBhU2AVGmSeD8Miao4oFaUF7cD/DswWtlu+Uqa8InPHrpxc9Oamw3ZODC/0glUfmi7uu0bvf3wDk98wJ0W/GlC6q731w9EyGWvKpBvc7hmVfvtibmI9RVF8VRjhu8wU9zCLqmrcIp4/w7HppmPAjydqX9EGqA2wufQ0smBPeQ2QtmjC9VHMEVZWRJMkHzIWq29L0o6WZyznqijB0iYuN0F7X18fz0YUgHgyRsAwMOIAfVnOXoC4hIfRsO62Lnyyiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xh6VMRcvzEdS6gJSbBlfV0oLfwAeApt4YEbCidLYKpo=;
 b=CJV3eW21LNQB4GC0D0GB85g0uONhbnFNauvbbW92d2lphO6N3EZz8PoG6V+/Z1nQj/KjeERknepRL/Fz7KA8joZYFg3My8cx978I7qLeX4NhQT1Ed2eGJypbVo6mONsSEY7oM4hpMp0ZJHIJuNf0cTb/t9uOeaqnF6qGkOzUgNM=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 15:34:54 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 15:34:54 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] Bluetooth: btrtl: rename USB fw for RTL8761
Thread-Topic: [PATCH 1/2] Bluetooth: btrtl: rename USB fw for RTL8761
Thread-Index: AQHXU+D3jtPPgp9Sg0y6T3uYCxTPh6sA4eiA
Date:   Wed, 2 Jun 2021 15:34:54 +0000
Message-ID: <d45aab64008f0ae759eba900549f2d7a85feefb3.camel@infinera.com>
References: <20210528164608.27941-1-joakim.tjernlund@infinera.com>
In-Reply-To: <20210528164608.27941-1-joakim.tjernlund@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7b88262-58c5-435c-5354-08d925dbf861
x-ms-traffictypediagnostic: PH0PR10MB4487:
x-microsoft-antispam-prvs: <PH0PR10MB4487E562D2BFD2B72597574FF43D9@PH0PR10MB4487.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IsQnF9TV9k3/TxLOJNmv95B/PLxDSJxnWChqhOO8l7enQNZeyBBas63AbDHiZNLVh2df89DP72QujwGELaSuAuifyytKPQ8pksCTSKucVeIpl3PDCrG7upZ3mx/VJOtbocBLxj8EWe/iopVRwpAREcVodogYVDsXP85nrbQHOodTOMEDJLm+caBDXB4lrSKYUAMrq1JbO0+HvpmqYWFglg+R0dQ0frQItS0wZEusKqc3A9zS8XrSZPxAZSNkBu/TXU0AP7vcLpvzxw1jOLjmG2xaOFnlfLaSxd1RvukVcKHWzK187BMrMpOpXCOmg8AR0XPNY0OzivNegApz4/ttYFPsTn0D/30XwAJqpGkqnINFOdh+kT/eZ4tEVWs4xEnf33f2VgJDD/WvMggGv8xYQxW/i2VjGd8Mn5JzVwnbIoD7WqHh2IeRHMqqvTD5HmOegS+0Un778Pbiag+LRr06/kIShh8QzIk26G+t7EOwpNXEXZHX1SvLN4ep/ZqpYwICvWldGYMzu5p3cqtGri3uscQuzUYgoomiGt8ef6lEi6rplHPYplU6oS5gzOMa8Sxb69SmythEk5JGy1yyjt7/Rp7Pxm7yUVCN7/bhPTCf2/Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(83380400001)(186003)(4326008)(26005)(450100002)(122000001)(64756008)(36756003)(8676002)(71200400001)(2906002)(478600001)(8936002)(66476007)(38100700002)(86362001)(316002)(5660300002)(66946007)(6512007)(91956017)(66446008)(76116006)(6506007)(6916009)(2616005)(66556008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bkM3a1J4L0Q0YitUNlkxMUpyQmRhTkYvdm1nSDhOd2ZsVlVWTWdYSTEwUlRx?=
 =?utf-8?B?blJDV2htYWUxUzNvMWJuM0gzeGczbFFrV0NGNEhzSEhYV0hYT28yK1owaCtk?=
 =?utf-8?B?MTMyZENKV2l5eWs3V3plS1hEaU1NYm9lU1ZTV016ckIzTjRLT2o0S3JMdFJo?=
 =?utf-8?B?dExvS2s3a3kxTDBoUjZ1TG9XcTY4ZW5aL1BmVEpURm1IdVpCUVpFczNPN2dY?=
 =?utf-8?B?d2tOODQ0cVFVWW9QQWd2SzBkMmFUSWNWSmU5d0JHV1M0KzYrU2NBY2FuNHll?=
 =?utf-8?B?NnFjZlB2WWQwS1lBc3ZpeGRIZjFvUW4wVDdCZkFCMk9VbEJlWlQ3cVNrdnhE?=
 =?utf-8?B?Z0E0RnNQNEx3U3RvMFppb1J2a2h6S3J2dkhjTEhpamlqYlBxVndKMnJLWXpD?=
 =?utf-8?B?RFM1L3NJcWozZVFQbWZpdTBEbWJkbngvdVc4NmFWRnVPdnR3a0ZZUnlJZmQ1?=
 =?utf-8?B?M1U0S1Z4NnBGbGY4WllQRFhYYVd5bG1qczgyN2gzYUJOWFBFcTk2Y0UvQ1lD?=
 =?utf-8?B?dERZK21aejBYeEZEOHAyUUdiN2RSTFhqYXEyeTZtTmNuRXZHVEpGcHQ3SnY0?=
 =?utf-8?B?aGJOZEVORnpGRXY3UGFRbk5vL1JTaWprUXVsam5Jc1ZGS0lZbnE3R1d1MkVX?=
 =?utf-8?B?b2lJQitoUFM2a2ZVQmpDaEl2alVhQytXNTl0SEsvWFRReDlLQSsxOFp6cVRH?=
 =?utf-8?B?WFdiWHdneDRvRDgyYUcrSEdlcWYySzdSei9JNm9iUk56MVhSQm5jT0h4dzBD?=
 =?utf-8?B?S2xoS0dSWDB4L2Y5U29HUVFxYXVtaWNmblRSRmhyV1haVUtHc3RxaTRobVhK?=
 =?utf-8?B?Y1h0TU9IWHc5YWR3WWY5aElKWlREamVkWVlldTc3bEY1dTlTNmNjRDJCazVZ?=
 =?utf-8?B?d1VPdEVjM0tJTTBDNFVOY0Y3UEtpT1ZtMjV2Uk5GcXozcU9rSWJrc0xiVVl4?=
 =?utf-8?B?WnBobmFlM2VTYmsvYm4xejNLL3VpczdSWDRYN3BlZUNKcXBiR1BGZWNicCtS?=
 =?utf-8?B?dWUzY1VYWEUvTTY0aVhzcDI1dmxPQWhJMUR6bGpqeHlSaDM5MDF2UUFSTjVh?=
 =?utf-8?B?OS91cjVtYi9Gb1M2OGViYi90dE1UM1VDK1lzdzFuQjNuVEF5TGtubkFBMnJj?=
 =?utf-8?B?dFNIaGtQYXpQRHZHV29keXR4RTFJTmhBVURFRXcrcTF1d01GQnpjek9oL0tt?=
 =?utf-8?B?YjBPdEFLSWN6MndZNkR4RVlDYVRrVndMY2NDbUFqdWU1aTloRCs3WHJxUFJL?=
 =?utf-8?B?ZXdkbkFhdWRqV2RZM2FjMjd3KzhJckJjV3pIbEdyeDFNb1ZSbTNoRzY2cFh6?=
 =?utf-8?B?dkg0N2dMQ3VpS2xwTGpJb2NGVTdxZHllOGFyN1hHVnRLdERzMHdrVEFVdjJ2?=
 =?utf-8?B?dkpSbWtWUjJsbUtHRXBmbjNyek5RRHlSYnJwZVhxVTdlMzZDenZBMXhGR3VD?=
 =?utf-8?B?OUZUZ0NFYXVyRDdHcjljQXpvYjFlZmtRVER1TGN2ZGZSa1JyempHSVFuYW1D?=
 =?utf-8?B?amdEUUhLc3g4VHNXVW0wWDF0R281R1NpWEFrS1NBbkZZdEMzejJzVFZTZUov?=
 =?utf-8?B?NENPVDFzQmJOV1R3K3U5b2NzbzdyN2xuRzArTUx3a3lVMXZyVnAzeEVBZDZx?=
 =?utf-8?B?SXFCanVMcTVseHhzOC9JVm5YbkdiQ1Y4aExOdlNUNGRYa0o3WXFHb2NGN0FH?=
 =?utf-8?B?NUl2K3NoRWhCMTU4TXFEaSt0anNZTVhzYWNlaE9QMjBRVGp2eFFuaE9nd243?=
 =?utf-8?Q?NVS4hRK6pmjA6sRvd3TfJh3m2mCzO/n/YkLM+BX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <03A9F3A9F4A87949A95F221E01E0A71E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b88262-58c5-435c-5354-08d925dbf861
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 15:34:54.3564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hLL++g6UvzgNYEiix7iflzAnRFvdNQCx7nZNvNAfrEhnTzh9o5lI/re5V0S6I2N5LxU1Xs0H0yT9AsnpxLSOEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

R2VudGxlIHBpbmcgLi4uDQoNCk9uIEZyaSwgMjAyMS0wNS0yOCBhdCAxODo0NiArMDIwMCwgSm9h
a2ltIFRqZXJubHVuZCB3cm90ZToNCj4gRnJvbTogSm9ha2ltIFRqZXJubHVuZCA8Sm9ha2ltLlRq
ZXJubHVuZEBpbmZpbmVyYS5jb20+DQo+IA0KPiBBY2NvcmRpbmcgUmVhbHRla3Mgb3duIEJUIGRy
aXZlcnMgZmlybXdhcmUgUlRMODc2MUIgaXMgZm9yIFVBUlQNCj4gYW5kIFJUTDg3NjFCVSBpcyBm
b3IgVVNCLg0KPiANCj4gQ2hhbmdlIGV4aXN0aW5nIDg3NjFCIHRvIFVBUlQgYW5kIGFkZCBhbiA4
NzYxQlUgZW50cnkgZm9yIFVTQg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFRqZXJubHVu
ZCA8Sm9ha2ltLlRqZXJubHVuZEBpbmZpbmVyYS5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+IC0tLQ0KPiDCoGRyaXZlcnMvYmx1ZXRvb3RoL2J0cnRsLmMgfCA5ICsrKysrKysr
LQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2JsdWV0b290aC9idHJ0bC5jIGIvZHJpdmVycy9ibHVl
dG9vdGgvYnRydGwuYw0KPiBpbmRleCBlN2ZlNWZiMjI3NTMuLmNjZWY4YjJjZmVlMiAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9ibHVldG9vdGgvYnRydGwuYw0KPiArKysgYi9kcml2ZXJzL2JsdWV0
b290aC9idHJ0bC5jDQo+IEBAIC0xMzIsMTIgKzEzMiwxOSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IGlkX3RhYmxlIGljX2lkX3RhYmxlW10gPSB7DQo+IMKgCSAgLmNmZ19uYW1lID0gInJ0bF9idC9y
dGw4NzYxYV9jb25maWciIH0sDQo+IMKgDQo+IA0KPiDCoAkvKiA4NzYxQiAqLw0KPiAtCXsgSUNf
SU5GTyhSVExfUk9NX0xNUF84NzYxQSwgMHhiLCAweGEsIEhDSV9VU0IpLA0KPiArCXsgSUNfSU5G
TyhSVExfUk9NX0xNUF84NzYxQSwgMHhiLCAweGEsIEhDSV9VQVJUKSwNCj4gwqAJICAuY29uZmln
X25lZWRlZCA9IGZhbHNlLA0KPiDCoAkgIC5oYXNfcm9tX3ZlcnNpb24gPSB0cnVlLA0KPiDCoAkg
IC5md19uYW1lICA9ICJydGxfYnQvcnRsODc2MWJfZncuYmluIiwNCj4gwqAJICAuY2ZnX25hbWUg
PSAicnRsX2J0L3J0bDg3NjFiX2NvbmZpZyIgfSwNCj4gwqANCj4gDQo+ICsJLyogODc2MUJVICov
DQo+ICsJeyBJQ19JTkZPKFJUTF9ST01fTE1QXzg3NjFBLCAweGIsIDB4YSwgSENJX1VTQiksDQo+
ICsJICAuY29uZmlnX25lZWRlZCA9IGZhbHNlLA0KPiArCSAgLmhhc19yb21fdmVyc2lvbiA9IHRy
dWUsDQo+ICsJICAuZndfbmFtZSAgPSAicnRsX2J0L3J0bDg3NjFidV9mdy5iaW4iLA0KPiArCSAg
LmNmZ19uYW1lID0gInJ0bF9idC9ydGw4NzYxYnVfY29uZmlnIiB9LA0KPiArDQo+IMKgCS8qIDg4
MjJDIHdpdGggVUFSVCBpbnRlcmZhY2UgKi8NCj4gwqAJeyBJQ19JTkZPKFJUTF9ST01fTE1QXzg4
MjJCLCAweGMsIDB4YSwgSENJX1VBUlQpLA0KPiDCoAkgIC5jb25maWdfbmVlZGVkID0gdHJ1ZSwN
Cg0K
