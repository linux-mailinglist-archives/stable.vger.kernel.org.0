Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1EB13C28A
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 14:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAONVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 08:21:43 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:60676 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbgAONVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 08:21:43 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4D796406D1;
        Wed, 15 Jan 2020 13:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579094502; bh=bSjzwBHMi5Ro4v9yLQ5+r6cdjQ/cXNCPl5B4Q9vOTeo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=GywcEK5KQzqrhypRX2lIbkQrfCmvk7UeDEyEhCYhGRB2RkCSdqYtey3erHB+CO9Kn
         uo0PvmzmegI0Wek0lErwFbh+1m985H1yM+A0w+stkgjVCod/A4nBQFi2gNfGa8zlG+
         D7daQYZ7iCR0jgKsCiX6tRANpCfZm3Imi24ZvO7u4vSptFo2NATaTbg5wyZwRRCMzg
         8/e30m163CG4rh1NSEW8UOEmoqJnqKw7NCLBZSyB8cGcjkJWVL9yrsBl7He6vpEgKE
         0qL40YKxEaiNIdNbwKajYI7Y16QmCrGMI3h/+hJHxYhwIzkRTDtp1r12qGuhJH2/VY
         ya7z1LheLrLGQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DA4E9A0067;
        Wed, 15 Jan 2020 13:21:40 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 15 Jan 2020 05:21:26 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 15 Jan 2020 05:21:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IA57NMEUHv+w1xbmMwwOBel3tE+MpCyQ8LIZLbuF+W/kZD1lkYKeMfIdDeTHDoaMA89KWSJtf1TqLqU6l6LMAb9ojHEdwyTU3rWPZhOUzd3WVCpOwaGcVr2WUo7ClmOs3i3h3KcgHaNoJBbZgpfDvWIhAxLG3d2bUjba8LTyvpEp58w6NXASaC5AAzJnqArCsX3nTsofcLZ3n3nAmeFgRMw/3JZoZf6IZxdKj3gKGwnhlf8Llq5nJvs2ExbUz8LIs0E3He7hVA+iib8nBnGHjkSkzhf0AMowqmYJRaxpUWShn3tWPCLqCs/joJZIDHvSfU0x/7f1aA0bREpLbWTDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSjzwBHMi5Ro4v9yLQ5+r6cdjQ/cXNCPl5B4Q9vOTeo=;
 b=C3Gj1PC1xW13vV4sfUbRNG6Vm1+k9ZSGnhMEmYOSf5kL8eSHmzR5TFwhrT4zym0fm7VGM+XKwPU9I82jJ7eD3K5ut86a21XMfOoI51Vyjdf4f/XFRzd+36zFW586gQv7ZBpfFtsvGDlXpgfPnk6F6RDS1N0/L68lsrooF4oHBpXwXMyk0S0pJyfsvGotz8aSyJAn4cw2UYmbpUpGoFJFcZAWidxn1ayhUTKiLop6zbk/mBGsbOSm9Miia38ZAc6vnQXfafgGbkOmya0uZ3HVRu3Y8lSwLM0UdAmm/qQ+yR9pUdGwDwZVRmcWiQpTk2S5jVkURDN6SjEJGSQogeDjPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSjzwBHMi5Ro4v9yLQ5+r6cdjQ/cXNCPl5B4Q9vOTeo=;
 b=p4n5Yg8KCDqTrafySqgPvucT9b9omwZf1DEHW70kwUpWk1PfmPH/WtKquwxXmE/0+c0Ey7rzCX6+4rNJIvJvB4R49QayiN1/V2xD5Hh54tquBisJEHuQxxuV6wxUw5lsjRJPzNaeEcTXyj5RYWmbGxMp5KHk4DISwbgdaRDBrsU=
Received: from MN2PR12MB4093.namprd12.prod.outlook.com (52.135.51.203) by
 MN2PR12MB2861.namprd12.prod.outlook.com (20.179.81.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Wed, 15 Jan 2020 13:21:24 +0000
Received: from MN2PR12MB4093.namprd12.prod.outlook.com
 ([fe80::35cf:644a:cfa6:72f8]) by MN2PR12MB4093.namprd12.prod.outlook.com
 ([fe80::35cf:644a:cfa6:72f8%7]) with mapi id 15.20.2644.015; Wed, 15 Jan 2020
 13:21:24 +0000
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jack Mitchell <ml@embed.me.uk>
Subject: Re: [PATCH v2] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Topic: [PATCH v2] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Index: AQHVtDRRsaiaBcZrbkqd1BwqA8ZVG6fr5PUA
Date:   Wed, 15 Jan 2020 13:21:24 +0000
Message-ID: <c2dd753e-d891-72f0-409e-5f23e5f170f0@synopsys.com>
References: <38a93a8deedd76dbc22bb1e41b4fc998f3750c95.1576516371.git.hminas@synopsys.com>
In-Reply-To: <38a93a8deedd76dbc22bb1e41b4fc998f3750c95.1576516371.git.hminas@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hminas@synopsys.com; 
x-originating-ip: [46.162.196.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d392eded-214c-4964-afe7-08d799bdd21d
x-ms-traffictypediagnostic: MN2PR12MB2861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB28619194BD267CE066BE35EBA7370@MN2PR12MB2861.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:293;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(136003)(346002)(366004)(199004)(189003)(6512007)(91956017)(478600001)(31696002)(76116006)(6486002)(64756008)(54906003)(316002)(66946007)(4326008)(66446008)(66476007)(66556008)(8936002)(36756003)(2906002)(31686004)(86362001)(5660300002)(8676002)(81156014)(71200400001)(110136005)(53546011)(26005)(6506007)(2616005)(81166006)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR12MB2861;H:MN2PR12MB4093.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NCAFrbpbqDbPmYCRRheh6LlJ42uHmND8WFDcM92ml/KK2gTQLMDvwCfyDciukoDmQowYVx3slOQvGzdN+tZTiTlI5riiz6Lu6ub1tFGuycaTJZWzgFJZ5LBZ2roM6U51cqwNt0db5rY1yD9Atgq/ee/UgI3cTnepODyegIrdGhhlnc0Foi0C273U9W9kUpfsWCN6xz/QYxuUxT6KqHwEhXvCgIL4W9hEnmXWVtOO9RX2erDo0xjmBzT2Z/BaK/NDbsdI+EUT1NREFI5XBNeWx6VXskB5SN18wVrH6howOYD0SYywBYvSpiroEZe5uMhyRcfHHp5j4BLTZufRo4rKos6g1rBJPH+lMOhAdXGYEExdEubMrY8kHhakW3dfMxXLHaJ6UOPYB/z2+k1Fqj/J2dEXNqxl/p8mB4H7obimzh4KOL3h3MXFo4JmahLyOdjR
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4047543E61C5644AB8E8BC47D83E2D7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d392eded-214c-4964-afe7-08d799bdd21d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:21:24.8328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UbP3NP2Z9P3/OFpjvCh/mtvy+jLwqUihgOKww5v6T1AJ+OD9Y0PILjXssFgsKd4yy9Z4cFO7ru1KJblVU7MDAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2861
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpPbiAxMi8xNi8yMDE5IDk6MTQgUE0sIE1pbmFzIEhhcnV0eXVueWFuIHdy
b3RlOg0KPiBTRVQvQ0xFQVJfRkVBVFVSRSBmb3IgUmVtb3RlIFdha2V1cCBhbGxvd2FuY2Ugbm90
IGhhbmRsZWQgY29ycmVjdGx5Lg0KPiBHRVRfU1RBVFVTIGhhbmRsaW5nIHByb3ZpZGVkIG5vdCBj
b3JyZWN0IGRhdGEgb24gREFUQSBTdGFnZS4NCj4gSXNzdWUgc2VlbiB3aGVuIGdhZGdldCdzIGRy
X21vZGUgc2V0IHRvICJvdGciIG1vZGUgYW5kIGNvbm5lY3RlZA0KPiB0byBNYWNPUy4NCj4gQm90
aCBhcmUgZml4ZWQgYW5kIHRlc3RlZCB1c2luZyBVU0JDViBDaC45IHRlc3RzLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogTWluYXMgSGFydXR5dW55YW4gPGhtaW5hc0BzeW5vcHN5cy5jb20+DQo+IEZp
eGVzOiBmYTM4OWE2ZDc3MjYgKCJ1c2I6IGR3YzI6IGdhZGdldDogQWRkIHJlbW90ZV93YWtldXBf
YWxsb3dlZCBmbGFnIikNCj4gVGVzdGVkLWJ5OiBKYWNrIE1pdGNoZWxsIDxtbEBlbWJlZC5tZS51
az4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+IENoYW5nZXMgaW4gdjI6
DQo+IC0gQWRkIEZpeGVzIHRhZw0KPiAtIEFkZCBUZXN0ZWQtYnkgdGFnDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBNaW5hcyBIYXJ1dHl1bnlhbiA8aG1pbmFzQHN5bm9wc3lzLmNvbT4NCj4gLS0tDQo+
ICAgZHJpdmVycy91c2IvZHdjMi9nYWRnZXQuYyB8IDI4ICsrKysrKysrKysrKysrKystLS0tLS0t
LS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMi9nYWRnZXQuYyBiL2RyaXZl
cnMvdXNiL2R3YzIvZ2FkZ2V0LmMNCj4gaW5kZXggNmJlMTBlNDk2ZTEwLi4zYTYxNzZjMjIzNzEg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzIvZ2FkZ2V0LmMNCj4gKysrIGIvZHJpdmVy
cy91c2IvZHdjMi9nYWRnZXQuYw0KPiBAQCAtMTYzMiw2ICsxNjMyLDcgQEAgc3RhdGljIGludCBk
d2MyX2hzb3RnX3Byb2Nlc3NfcmVxX3N0YXR1cyhzdHJ1Y3QgZHdjMl9oc290ZyAqaHNvdGcsDQo+
ICAgCXN0cnVjdCBkd2MyX2hzb3RnX2VwICplcDAgPSBoc290Zy0+ZXBzX291dFswXTsNCj4gICAJ
c3RydWN0IGR3YzJfaHNvdGdfZXAgKmVwOw0KPiAgIAlfX2xlMTYgcmVwbHk7DQo+ICsJdTE2IHN0
YXR1czsNCj4gICAJaW50IHJldDsNCj4gICANCj4gICAJZGV2X2RiZyhoc290Zy0+ZGV2LCAiJXM6
IFVTQl9SRVFfR0VUX1NUQVRVU1xuIiwgX19mdW5jX18pOw0KPiBAQCAtMTY0MywxMSArMTY0NCwx
MCBAQCBzdGF0aWMgaW50IGR3YzJfaHNvdGdfcHJvY2Vzc19yZXFfc3RhdHVzKHN0cnVjdCBkd2My
X2hzb3RnICpoc290ZywNCj4gICANCj4gICAJc3dpdGNoIChjdHJsLT5iUmVxdWVzdFR5cGUgJiBV
U0JfUkVDSVBfTUFTSykgew0KPiAgIAljYXNlIFVTQl9SRUNJUF9ERVZJQ0U6DQo+IC0JCS8qDQo+
IC0JCSAqIGJpdCAwID0+IHNlbGYgcG93ZXJlZA0KPiAtCQkgKiBiaXQgMSA9PiByZW1vdGUgd2Fr
ZXVwDQo+IC0JCSAqLw0KPiAtCQlyZXBseSA9IGNwdV90b19sZTE2KDApOw0KPiArCQlzdGF0dXMg
PSAxIDw8IFVTQl9ERVZJQ0VfU0VMRl9QT1dFUkVEOw0KPiArCQlzdGF0dXMgfD0gaHNvdGctPnJl
bW90ZV93YWtldXBfYWxsb3dlZCA8PA0KPiArCQkJICBVU0JfREVWSUNFX1JFTU9URV9XQUtFVVA7
DQo+ICsJCXJlcGx5ID0gY3B1X3RvX2xlMTYoc3RhdHVzKTsNCj4gICAJCWJyZWFrOw0KPiAgIA0K
PiAgIAljYXNlIFVTQl9SRUNJUF9JTlRFUkZBQ0U6DQo+IEBAIC0xNzU4LDcgKzE3NTgsMTAgQEAg
c3RhdGljIGludCBkd2MyX2hzb3RnX3Byb2Nlc3NfcmVxX2ZlYXR1cmUoc3RydWN0IGR3YzJfaHNv
dGcgKmhzb3RnLA0KPiAgIAljYXNlIFVTQl9SRUNJUF9ERVZJQ0U6DQo+ICAgCQlzd2l0Y2ggKHdW
YWx1ZSkgew0KPiAgIAkJY2FzZSBVU0JfREVWSUNFX1JFTU9URV9XQUtFVVA6DQo+IC0JCQloc290
Zy0+cmVtb3RlX3dha2V1cF9hbGxvd2VkID0gMTsNCj4gKwkJCWlmIChzZXQpDQo+ICsJCQkJaHNv
dGctPnJlbW90ZV93YWtldXBfYWxsb3dlZCA9IDE7DQo+ICsJCQllbHNlDQo+ICsJCQkJaHNvdGct
PnJlbW90ZV93YWtldXBfYWxsb3dlZCA9IDA7DQo+ICAgCQkJYnJlYWs7DQo+ICAgDQo+ICAgCQlj
YXNlIFVTQl9ERVZJQ0VfVEVTVF9NT0RFOg0KPiBAQCAtMTc2OCwxNiArMTc3MSwxNyBAQCBzdGF0
aWMgaW50IGR3YzJfaHNvdGdfcHJvY2Vzc19yZXFfZmVhdHVyZShzdHJ1Y3QgZHdjMl9oc290ZyAq
aHNvdGcsDQo+ICAgCQkJCXJldHVybiAtRUlOVkFMOw0KPiAgIA0KPiAgIAkJCWhzb3RnLT50ZXN0
X21vZGUgPSB3SW5kZXggPj4gODsNCj4gLQkJCXJldCA9IGR3YzJfaHNvdGdfc2VuZF9yZXBseSho
c290ZywgZXAwLCBOVUxMLCAwKTsNCj4gLQkJCWlmIChyZXQpIHsNCj4gLQkJCQlkZXZfZXJyKGhz
b3RnLT5kZXYsDQo+IC0JCQkJCSIlczogZmFpbGVkIHRvIHNlbmQgcmVwbHlcbiIsIF9fZnVuY19f
KTsNCj4gLQkJCQlyZXR1cm4gcmV0Ow0KPiAtCQkJfQ0KPiAgIAkJCWJyZWFrOw0KPiAgIAkJZGVm
YXVsdDoNCj4gICAJCQlyZXR1cm4gLUVOT0VOVDsNCj4gICAJCX0NCj4gKw0KPiArCQlyZXQgPSBk
d2MyX2hzb3RnX3NlbmRfcmVwbHkoaHNvdGcsIGVwMCwgTlVMTCwgMCk7DQo+ICsJCWlmIChyZXQp
IHsNCj4gKwkJCWRldl9lcnIoaHNvdGctPmRldiwNCj4gKwkJCQkiJXM6IGZhaWxlZCB0byBzZW5k
IHJlcGx5XG4iLCBfX2Z1bmNfXyk7DQo+ICsJCQlyZXR1cm4gcmV0Ow0KPiArCQl9DQo+ICAgCQli
cmVhazsNCj4gICANCj4gICAJY2FzZSBVU0JfUkVDSVBfRU5EUE9JTlQ6DQo+IA0KDQpXaGF0IGFi
b3V0IHRoaXMgcGF0Y2g/DQoNCg0KDQpUaGFua3MsDQpNaW5hcw0K
