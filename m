Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110FF11FF35
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 08:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfLPHul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 02:50:41 -0500
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:13962 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbfLPHul (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 02:50:41 -0500
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBG7oYsO008181;
        Mon, 16 Dec 2019 02:50:34 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-00128a01.pphosted.com with ESMTP id 2wvtcfu960-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 02:50:34 -0500
Received: from m0167091.ppops.net (m0167091.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBG7oXVL008176;
        Mon, 16 Dec 2019 02:50:33 -0500
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0b-00128a01.pphosted.com with ESMTP id 2wvtcfu95x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 02:50:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mx9lfuzJn9b20TdpgNikp0I6+N4epuRQJQ2FYV4wV85xb3yscWXNTR3HukbJncltDD+5P4p750Ejy9bYHH8zgE07S/uSKBRyimrkB5s0I0keZfL8FyVwqXoJ7Gy0eXtqh5wqvZrVNXrV0dst4z8geL4FRUc8lFKZsZ5ecxGeV5eaUoHdgawxBr01Xvgn5R+DKMRsfWu7oUGrO1JNOU7WvWGW7VoqEnuBMZYL8syvnJHJI/6v3CJuMPZxJ5MMSsL39T3F5l4rTPyM2YpoZ7Ngntbl9QZIjMerOUQG/17HKhzEub25Ec4JY7gIKUxk5DJJYYVbi+bCcwFXgcOj/mMSYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOnEOxTld7/JDodGnk6AMp7c/JyQHqKmAAyoBfm7hGY=;
 b=PXBZ66euI13pmNXz1zQ5FJH5J2XnqgMIAS6x+xlNVJ34srPRl+cFfYlOyw6OraNC1l6NaxaGldWNCn/9EhuqzXcBfGJe8FyaXlg3elOisRLtORhmexb8GRPpa2AJq7PMyLpEjnE4Qdu0RmjtjJTKC8rLREV/y+8JZFhgLusH2ZT2chTAKyG/6/FJ+HORjpz2lpIdAK/D7nSqpiXjzyC++Qswy/1ZOPtkVdg22uyBjO27z8g/ycVGXGS5F5/R374bdNbeLnQrCpBPnoJh1RL1WP6Q0B/CDFY18hT4hC9z1E1lmUItVZ1dPnJirOUnE64yqBg5oRU46glDcMyWoUixKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOnEOxTld7/JDodGnk6AMp7c/JyQHqKmAAyoBfm7hGY=;
 b=p+EEs5pcNaFfLgtRvYXjh+hFHQefzgHrZ35WOJ/AMABkpIWmCRTOwAFb3F/yc8w2kozg512PoS0NkIfd6GQUO/Gbq7+rqRlMVxxxkJ/JC+t0/C5RybEKSInW/EnPTYnPAPOKrQKMjk0sxgEht4+gESKLUIdr2w4ZGnfAOW0Apv0=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5287.namprd03.prod.outlook.com (20.180.4.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Mon, 16 Dec 2019 07:50:32 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::dce7:7fec:f33f:ad39%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 07:50:32 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "jic23@jic23.retrosnub.co.uk" <jic23@jic23.retrosnub.co.uk>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.4 137/350] iio: pressure: zpa2326: fix
 iio_triggered_buffer_postenable position
Thread-Topic: [PATCH AUTOSEL 5.4 137/350] iio: pressure: zpa2326: fix
 iio_triggered_buffer_postenable position
Thread-Index: AQHVr541gG0Hk+MQQ0inqjnKjPHUzKe7YVUAgAEKagA=
Date:   Mon, 16 Dec 2019 07:50:32 +0000
Message-ID: <0ff5f7ede826feb6185260a9d2c87fb89e799166.camel@analog.com>
References: <20191210210735.9077-1-sashal@kernel.org>
         <20191210210735.9077-98-sashal@kernel.org>
         <20191215155700.5183d752@archlinux>
In-Reply-To: <20191215155700.5183d752@archlinux>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b8b41f91-7d04-4ca8-3645-08d781fca0ea
x-ms-traffictypediagnostic: CH2PR03MB5287:
x-microsoft-antispam-prvs: <CH2PR03MB528716F3B919B7A47EFDB1A4F9510@CH2PR03MB5287.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(366004)(39860400002)(376002)(199004)(189003)(2616005)(6512007)(66946007)(110136005)(66476007)(66556008)(2906002)(54906003)(64756008)(66446008)(6486002)(4326008)(71200400001)(186003)(4001150100001)(76116006)(8936002)(6506007)(5660300002)(26005)(81156014)(81166006)(86362001)(478600001)(36756003)(8676002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5287;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Jyz8IRiRBJfauWipHH9c/KEef0sC0wWqKJ7EbJB1kUxF1k4325Dg7unn7nporP375cXcF5m4hCG+22Hnz6F3TrXmXdwuPLbZdvgofbkvMVAEY1Ve8pMsMe/cYJbPYrTVIyBzc4gOeO9ON+OyWUBBRCsipZ636aNmMHsmR/hA4uokcFG+EMZZlVdqbIJO5F2dyLPsfdOQg0fcgta1jK2c4C36uULK01RP5iLaQ3wjFxr2yljDJ8yw1YpEUtehn13InUhomGMku+eBo2ryK7o5fqdnzZs0HgY96GuHb/5mdyanzVAW+8HGRFhVq0A/uH2/L+KOYUbzhtNfndHdPT2Z1YrawzX/Lv0QloKgOaw9y/XqyJxFeipn/467j/OBBo4Wp1mlz2jRZdw6tEULyVnTStLR6bahYSinTp6Ovz3FgXkYDiVLWaTnkn/+kFe2WRu
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BABC2F2A972BD458EEC3C4DA36A327E@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b41f91-7d04-4ca8-3645-08d781fca0ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 07:50:32.6286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6s/X4350/+ZpOtEy/8u+igE9lN6x57l+ezRZAx7hrPpkDmBkPhdyV3Ttk7C0LCUTLrA8lW2c160TsGHkPQyqUArLR8Ohw13piIXuHZOSctw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5287
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_01:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1031 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912160070
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDE5LTEyLTE1IGF0IDE1OjU3ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBbRXh0ZXJuYWxdDQo+IA0KPiBPbiBUdWUsIDEwIERlYyAyMDE5IDE2OjA0OjAyIC0wNTAw
DQo+IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiA+IEZyb206
IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQo+ID4g
DQo+ID4gWyBVcHN0cmVhbSBjb21taXQgZmUyMzkyYzY3ZGI5NzMwZDQ2ZjExZmM0ZmFkZmE3YmZm
YTg4NDNmYSBdDQo+ID4gDQo+ID4gVGhlIGlpb190cmlnZ2VyZWRfYnVmZmVyX3twcmVkaXNhYmxl
LHBvc3RlbmFibGV9IGZ1bmN0aW9ucw0KPiA+IGF0dGFjaC9kZXRhY2gNCj4gPiB0aGUgcG9sbCBm
dW5jdGlvbnMuDQo+ID4gDQo+ID4gVGhlIGlpb190cmlnZ2VyZWRfYnVmZmVyX3Bvc3RlbmFibGUo
KSBzaG91bGQgYmUgY2FsbGVkIGJlZm9yZSAodG8NCj4gPiBhdHRhY2gNCj4gPiB0aGUgcG9sbCBm
dW5jKSBhbmQgdGhlbiB0aGUNCj4gPiANCj4gPiBUaGUgaWlvX3RyaWdnZXJlZF9idWZmZXJfcHJl
ZGlzYWJsZSgpIGZ1bmN0aW9uIGlzIGhvb2tlZCBkaXJlY3RseQ0KPiA+IHdpdGhvdXQNCj4gPiBh
bnl0aGluZywgd2hpY2ggaXMgcHJvYmFibHkgZmluZSwgYXMgdGhlIHBvc3RlbmFibGUoKSB2ZXJz
aW9uIHNlZW1zIHRvDQo+ID4gYWxzbw0KPiA+IGRvIHNvbWUgcmVzZXQvd2FrZS11cCBvZiB0aGUg
ZGV2aWNlLg0KPiA+IFRoaXMgd2lsbCBtZWFuIGl0IHdpbGwgYmUgZWFzaWVyIHdoZW4gcmVtb3Zp
bmcgaXQ7IGkuZS4gaXQganVzdCBnZXRzDQo+ID4gcmVtb3ZlZC4NCj4gDQo+IEFoLiBJIHNob3Vs
ZCBoYXZlIGFkZGVkIGEgbm90ZSB0byB0aGlzIG9uZSBhcyB3ZWxsLiAgVGhpcyBpcyBtb3JlIGdl
bmVyYWwNCj4gcmV3b3JrLCB0aGF0IGlzIGEgZml4IGluIHRoZSBzZW5zZSBvZiBicmluZ2luZyB0
aGluZ3MgdG93YXJkcyBhIHN0YW5kYXJkDQo+IHdheSBvZiBkb2luZyB0aGluZ3MgcmF0aGVyIHRo
YW4gJ2ZpeGluZycgYSBrbm93biBidWcuDQo+IA0KPiBBbGV4LCBmb3IgYW55IG1vcmUgb2YgdGhl
c2UsIGxldHMgbm90IGhhdmUgZml4IGluIHRoZSB0aXRsZSAodGhvdWdoIHRoZXkNCj4gc29ydCBv
ZiBkbyAnZml4JyB0aGluZ3MpLg0KPiANCg0KQWNrLg0KSSBkb24ndCB0aGluayB0aGVyZSBhcmUg
bWFueSBkcml2ZXJzIGxlZnQgdGhvdWdoLg0KQnV0IHdpbGwga2VlcCB0aGlzIGluIG1pbmQuDQoN
ClRoYW5rcw0KQWxleA0KDQoNCj4gVGhhbmtzLA0KPiANCj4gSm9uYXRoYW4NCj4gDQo+ID4gU2ln
bmVkLW9mZi1ieTogQWxleGFuZHJ1IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9n
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKb25hdGhhbiBDYW1lcm9uIDxKb25hdGhhbi5DYW1l
cm9uQGh1YXdlaS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBr
ZXJuZWwub3JnPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2lpby9wcmVzc3VyZS96cGEyMzI2LmMg
fCAxNiArKysrKysrKystLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMo
KyksIDcgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaWlvL3By
ZXNzdXJlL3pwYTIzMjYuYw0KPiA+IGIvZHJpdmVycy9paW8vcHJlc3N1cmUvenBhMjMyNi5jDQo+
ID4gaW5kZXggOWQwZDA3OTMwMjM2ZS4uOTlkZmUzM2VlNDAyZiAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL2lpby9wcmVzc3VyZS96cGEyMzI2LmMNCj4gPiArKysgYi9kcml2ZXJzL2lpby9wcmVz
c3VyZS96cGEyMzI2LmMNCj4gPiBAQCAtMTI0Myw2ICsxMjQzLDExIEBAIHN0YXRpYyBpbnQgenBh
MjMyNl9wb3N0ZW5hYmxlX2J1ZmZlcihzdHJ1Y3QNCj4gPiBpaW9fZGV2ICppbmRpb19kZXYpDQo+
ID4gIAljb25zdCBzdHJ1Y3QgenBhMjMyNl9wcml2YXRlICpwcml2ID0gaWlvX3ByaXYoaW5kaW9f
ZGV2KTsNCj4gPiAgCWludCAgICAgICAgICAgICAgICAgICAgICAgICAgIGVycjsNCj4gPiAgDQo+
ID4gKwkvKiBQbHVnIG91ciBvd24gdHJpZ2dlciBldmVudCBoYW5kbGVyLiAqLw0KPiA+ICsJZXJy
ID0gaWlvX3RyaWdnZXJlZF9idWZmZXJfcG9zdGVuYWJsZShpbmRpb19kZXYpOw0KPiA+ICsJaWYg
KGVycikNCj4gPiArCQlnb3RvIGVycjsNCj4gPiArDQo+ID4gIAlpZiAoIXByaXYtPndha2VuKSB7
DQo+ID4gIAkJLyoNCj4gPiAgCQkgKiBXZSB3ZXJlIGFscmVhZHkgcG93ZXIgc3VwcGxpZWQuIEp1
c3QgY2xlYXIgaGFyZHdhcmUgRklGTw0KPiA+IHRvDQo+ID4gQEAgLTEyNTAsNyArMTI1NSw3IEBA
IHN0YXRpYyBpbnQgenBhMjMyNl9wb3N0ZW5hYmxlX2J1ZmZlcihzdHJ1Y3QNCj4gPiBpaW9fZGV2
ICppbmRpb19kZXYpDQo+ID4gIAkJICovDQo+ID4gIAkJZXJyID0genBhMjMyNl9jbGVhcl9maWZv
KGluZGlvX2RldiwgMCk7DQo+ID4gIAkJaWYgKGVycikNCj4gPiAtCQkJZ290byBlcnI7DQo+ID4g
KwkJCWdvdG8gZXJyX2J1ZmZlcl9wcmVkaXNhYmxlOw0KPiA+ICAJfQ0KPiA+ICANCj4gPiAgCWlm
ICghaWlvX3RyaWdnZXJfdXNpbmdfb3duKGluZGlvX2RldikgJiYgcHJpdi0+d2FrZW4pIHsNCj4g
PiBAQCAtMTI2MCwxNiArMTI2NSwxMyBAQCBzdGF0aWMgaW50IHpwYTIzMjZfcG9zdGVuYWJsZV9i
dWZmZXIoc3RydWN0DQo+ID4gaWlvX2RldiAqaW5kaW9fZGV2KQ0KPiA+ICAJCSAqLw0KPiA+ICAJ
CWVyciA9IHpwYTIzMjZfY29uZmlnX29uZXNob3QoaW5kaW9fZGV2LCBwcml2LT5pcnEpOw0KPiA+
ICAJCWlmIChlcnIpDQo+ID4gLQkJCWdvdG8gZXJyOw0KPiA+ICsJCQlnb3RvIGVycl9idWZmZXJf
cHJlZGlzYWJsZTsNCj4gPiAgCX0NCj4gPiAgDQo+ID4gLQkvKiBQbHVnIG91ciBvd24gdHJpZ2dl
ciBldmVudCBoYW5kbGVyLiAqLw0KPiA+IC0JZXJyID0gaWlvX3RyaWdnZXJlZF9idWZmZXJfcG9z
dGVuYWJsZShpbmRpb19kZXYpOw0KPiA+IC0JaWYgKGVycikNCj4gPiAtCQlnb3RvIGVycjsNCj4g
PiAtDQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgDQo+ID4gK2Vycl9idWZmZXJfcHJlZGlzYWJsZToN
Cj4gPiArCWlpb190cmlnZ2VyZWRfYnVmZmVyX3ByZWRpc2FibGUoaW5kaW9fZGV2KTsNCj4gPiAg
ZXJyOg0KPiA+ICAJenBhMjMyNl9lcnIoaW5kaW9fZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSBidWZm
ZXJpbmcgKCVkKSIsIGVycik7DQo+ID4gIA0K
