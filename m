Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FD08A3F5
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfHLREt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 13:04:49 -0400
Received: from mail-eopbgr690052.outbound.protection.outlook.com ([40.107.69.52]:13794
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726334AbfHLREt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 13:04:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mX/qfb7rJ+0xrPv08MXrgwXSsfYTh/QW3vm33tNCUi3LfKhG17mZvpji6pwDK6FNUkJsPIsyD4X4e5+4qWaZnzh9mgGvL9RtL10BCEyDN12Uy0xHW1NpVIrDpk4NyBxxHmongmjYwO3wyq7X9j2S4WWOVVNnGSTDxzEJY1k5PotglYQF+ilPs2AQ0ZbA7rw0YU6WdTPzJYqk0hTQzeO61e+FKXqxgTqaWyS52IbrQP/KJQGq9Atrcqun19Qlb0HfU8u/z44jvUqEvSXdrZU5BVj+VZm7LFLXLlaUgaLewaJ01SXrDXPDWixX/Kc1XBfkt5B/bKSot2LxyJN5YypQMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqeOSF2uVV0Pw3UJyp3m4QCYBqr7nYPIZQf/jdwVuOc=;
 b=KpR7LUPv/VWo0tjv49U44PMP5JJLqHymiAG02GT7iq4l6qK3jQRpaE8/NcQHR3vQqWvfnvyR1nbumxzrA6ESzs8IZGDeNzqSLdQJWpOIrLcKZ919yretp285vCT9c4WMCxpobhCQLlnJdh7kcjxKvO4qxaAVSzdVUmLEQaZd4Us5dQSMMrlY8AStMGQ2g6/3EeruJBwan4DeGYIFd7OfeNbBn5cbQHi+Xh86XByw2tdgdcBDHyaCDc/cdRdBpJuIqsAq5QWecZfAXv7HxdlI3qrF6c/OOqOso8b+WobYEkd+WHhXv5jYYdLfcmRPpuukVc966IjJNQ/Pzdw76XwImw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqeOSF2uVV0Pw3UJyp3m4QCYBqr7nYPIZQf/jdwVuOc=;
 b=xSFHQk2eFgn9tnsG/Nc2p9LiRs0sElCxlMkT6eBbRW8AmFit2x6raS9w90YiXNh9aqLi4mnxOFY7PVWX5pBD1/UrYpHz8HiE2yH0luHISOfzlBcqHwnafbAUxjDFktRolBw0MfvrG7PbvQrGrm22B05tsGnoaoEqcchPmuO7fZI=
Received: from DM5PR12MB1705.namprd12.prod.outlook.com (10.175.88.22) by
 DM5PR12MB1434.namprd12.prod.outlook.com (10.168.238.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Mon, 12 Aug 2019 17:04:32 +0000
Received: from DM5PR12MB1705.namprd12.prod.outlook.com
 ([fe80::a129:1f1a:52a9:4ac3]) by DM5PR12MB1705.namprd12.prod.outlook.com
 ([fe80::a129:1f1a:52a9:4ac3%5]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 17:04:32 +0000
From:   "Koenig, Christian" <Christian.Koenig@amd.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Sean Paul <seanpaul@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] dma-buf/sw_sync: Synchronize signal vs syncpt free
Thread-Topic: [PATCH] dma-buf/sw_sync: Synchronize signal vs syncpt free
Thread-Index: AQHVUSSfh3Cyqz65rEqZBiZ3bM219qb3vbWA
Date:   Mon, 12 Aug 2019 17:04:32 +0000
Message-ID: <994a1925-6d96-505f-c7f9-78a1cdf82051@amd.com>
References: <20190812154247.20508-1-chris@chris-wilson.co.uk>
In-Reply-To: <20190812154247.20508-1-chris@chris-wilson.co.uk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
x-clientproxiedby: PR2P264CA0015.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::27)
 To DM5PR12MB1705.namprd12.prod.outlook.com (2603:10b6:3:10c::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f1dd84e-dff7-4050-f7a6-08d71f472528
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1434;
x-ms-traffictypediagnostic: DM5PR12MB1434:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM5PR12MB14340B025C6728710FBFB6B583D30@DM5PR12MB1434.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(189003)(199004)(4326008)(25786009)(86362001)(64126003)(2906002)(31696002)(6306002)(66446008)(64756008)(66556008)(229853002)(66476007)(6436002)(66946007)(6512007)(81156014)(31686004)(8676002)(6486002)(81166006)(65806001)(65956001)(305945005)(66574012)(7736002)(71200400001)(71190400001)(36756003)(6116002)(256004)(14444005)(5660300002)(53936002)(46003)(6246003)(486006)(476003)(52116002)(65826007)(99286004)(966005)(14454004)(478600001)(2616005)(11346002)(446003)(316002)(2501003)(186003)(76176011)(110136005)(8936002)(386003)(102836004)(58126008)(54906003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1434;H:DM5PR12MB1705.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B00jbzpTWTHfFgxfIxNBh1oxoWFtP56Jhe8pdzzGVChmtAZYSl+qEExT0b2tskhHJuqlfQg+leJDgu137RTv4g2pEB1prxB5UQ/LVp5rHBXJnquFXJw2QAvtRdUFBFPe0Awv9P9pTmYCDycQzo6x3pt1rDMYorpGKj3bhSBkHghGOXjHtVPY2sDr1BhbBFYS8mygRnT22Yn7xopTpwB41RsMS65bVaQ8fDv+7VHapy0mZ8Fv/Ka3SzdZgAxF9uYVW0JynWw/wMoA95rQ56IQNWB8/16vzxv7E7c5uTDLX5a8MNHlxt6n6E50l8CiW1zuzD2jMh5aveBDxDM7XhQyqSnKXjXJQNCd7lTxgCmBvJULPBCnGWRYcv8NSD2pM4yeEwFoPtngUyqMBoC2av1ciHXI0tXj3hI1FXiosIHonj4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C458AB0D4393364BA9853C163F4AFEA9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1dd84e-dff7-4050-f7a6-08d71f472528
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 17:04:32.6093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: znU2NKXMOw6AIbDHeJeEgGkMOKPFjh02PBnbAfkyiLWAlr2fLq2DYR301oCu3r5W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1434
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QW0gMTIuMDguMTkgdW0gMTc6NDIgc2NocmllYiBDaHJpcyBXaWxzb246DQo+IER1cmluZyByZWxl
YXNlIG9mIHRoZSBzeW5jcHQsIHdlIHJlbW92ZSBpdCBmcm9tIHRoZSBsaXN0IG9mIHN5bmNwdCBh
bmQNCj4gdGhlIHRyZWUsIGJ1dCBvbmx5IGlmIGl0IGlzIG5vdCBhbHJlYWR5IGJlZW4gcmVtb3Zl
ZC4gSG93ZXZlciwgZHVyaW5nDQo+IHNpZ25hbGluZywgd2UgZmlyc3QgcmVtb3ZlIHRoZSBzeW5j
cHQgZnJvbSB0aGUgbGlzdC4gU28sIGlmIHdlDQo+IGNvbmN1cnJlbnRseSBmcmVlIGFuZCBzaWdu
YWwgdGhlIHN5bmNwdCwgdGhlIGZyZWUgbWF5IGRlY2lkZSB0aGF0IGl0IGlzDQo+IG5vdCBwYXJ0
IG9mIHRoZSB0cmVlIGFuZCBpbW1lZGlhdGVseSBmcmVlIGl0c2VsZiAtLSBtZWFud2hpbGUgdGhl
DQo+IHNpZ25hbGVyIGdvZXMgb250byB0byB1c2UgdGhlIG5vdyBmcmVlZCBkYXRhc3RydWN0dXJl
Lg0KPg0KPiBJbiBwYXJ0aWN1bGFyLCB3ZSBnZXQgc3RydWN0IGJ5IGNvbW1pdCAwZTJmNzMzYWRk
YmYgKCJkbWEtYnVmOiBtYWtlDQo+IGRtYV9mZW5jZSBzdHJ1Y3R1cmUgYSBiaXQgc21hbGxlciB2
MiIpIGFzIHRoZSBjYl9saXN0IGlzIGltbWVkaWF0ZWx5DQo+IGNsb2JiZXJlZCBieSB0aGUga2Zy
ZWVfcmN1Lg0KPg0KPiBCdWd6aWxsYTogaHR0cHM6Ly9idWdzLmZyZWVkZXNrdG9wLm9yZy9zaG93
X2J1Zy5jZ2k/aWQ9MTExMzgxDQo+IEZpeGVzOiBkMzg2MmU0NGRhYTcgKCJkbWEtYnVmL3N3LXN5
bmM6IEZpeCBsb2NraW5nIGFyb3VuZCBzeW5jX3RpbWVsaW5lIGxpc3RzIikNCj4gUmVmZXJlbmNl
czogMGUyZjczM2FkZGJmICgiZG1hLWJ1ZjogbWFrZSBkbWFfZmVuY2Ugc3RydWN0dXJlIGEgYml0
IHNtYWxsZXIgdjIiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBXaWxzb24gPGNocmlzQGNocmlz
LXdpbHNvbi5jby51az4NCj4gQ2M6IFN1bWl0IFNlbXdhbCA8c3VtaXQuc2Vtd2FsQGxpbmFyby5v
cmc+DQo+IENjOiBTZWFuIFBhdWwgPHNlYW5wYXVsQGNocm9taXVtLm9yZz4NCj4gQ2M6IEd1c3Rh
dm8gUGFkb3ZhbiA8Z3VzdGF2b0BwYWRvdmFuLm9yZz4NCj4gQ2M6IENocmlzdGlhbiBLw7ZuaWcg
PGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4NCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3Jn
PiAjIHY0LjE0Kw0KDQpBY2tlZC1ieTogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5p
Z0BhbWQuY29tPg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMvZG1hLWJ1Zi9zd19zeW5jLmMgfCAxMyAr
KysrKy0tLS0tLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgOCBkZWxl
dGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hLWJ1Zi9zd19zeW5jLmMgYi9k
cml2ZXJzL2RtYS1idWYvc3dfc3luYy5jDQo+IGluZGV4IDA1MWY2YzI4NzNjNy4uMjdiMWQ1NDll
ZDM4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2RtYS1idWYvc3dfc3luYy5jDQo+ICsrKyBiL2Ry
aXZlcnMvZG1hLWJ1Zi9zd19zeW5jLmMNCj4gQEAgLTEzMiwxNyArMTMyLDE0IEBAIHN0YXRpYyB2
b2lkIHRpbWVsaW5lX2ZlbmNlX3JlbGVhc2Uoc3RydWN0IGRtYV9mZW5jZSAqZmVuY2UpDQo+ICAg
ew0KPiAgIAlzdHJ1Y3Qgc3luY19wdCAqcHQgPSBkbWFfZmVuY2VfdG9fc3luY19wdChmZW5jZSk7
DQo+ICAgCXN0cnVjdCBzeW5jX3RpbWVsaW5lICpwYXJlbnQgPSBkbWFfZmVuY2VfcGFyZW50KGZl
bmNlKTsNCj4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiAgIA0KPiArCXNwaW5fbG9ja19pcnFz
YXZlKGZlbmNlLT5sb2NrLCBmbGFncyk7DQo+ICAgCWlmICghbGlzdF9lbXB0eSgmcHQtPmxpbmsp
KSB7DQo+IC0JCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+IC0NCj4gLQkJc3Bpbl9sb2NrX2lycXNh
dmUoZmVuY2UtPmxvY2ssIGZsYWdzKTsNCj4gLQkJaWYgKCFsaXN0X2VtcHR5KCZwdC0+bGluaykp
IHsNCj4gLQkJCWxpc3RfZGVsKCZwdC0+bGluayk7DQo+IC0JCQlyYl9lcmFzZSgmcHQtPm5vZGUs
ICZwYXJlbnQtPnB0X3RyZWUpOw0KPiAtCQl9DQo+IC0JCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
ZmVuY2UtPmxvY2ssIGZsYWdzKTsNCj4gKwkJbGlzdF9kZWwoJnB0LT5saW5rKTsNCj4gKwkJcmJf
ZXJhc2UoJnB0LT5ub2RlLCAmcGFyZW50LT5wdF90cmVlKTsNCj4gICAJfQ0KPiArCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoZmVuY2UtPmxvY2ssIGZsYWdzKTsNCj4gICANCj4gICAJc3luY190aW1l
bGluZV9wdXQocGFyZW50KTsNCj4gICAJZG1hX2ZlbmNlX2ZyZWUoZmVuY2UpOw0KDQo=
