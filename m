Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5219FE7E14
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 02:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfJ2BjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 21:39:09 -0400
Received: from m4a0041g.houston.softwaregrp.com ([15.124.2.87]:38263 "EHLO
        m4a0041g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727703AbfJ2BjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 21:39:09 -0400
Received: FROM m4a0041g.houston.softwaregrp.com (15.120.17.147) BY m4a0041g.houston.softwaregrp.com WITH ESMTP;
 Tue, 29 Oct 2019 01:38:12 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 29 Oct 2019 01:38:44 +0000
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 29 Oct 2019 01:38:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be75Dub55E90qtKXi0mtk8SDGCP1GNv6nICbtz4UPgJ4cjyl9co4KhX7QjL4vLz2pWP5aB+53pz7aNB32j1eP8RFQQoHSEdHpnquqnTvAWkWjaCcEDcAhXlNYPpuu7KwxAQCMpc7CGsqyO0AzJXe2NNguDGIUT20+Cg44gmGOtvjHSckF6OEVBAOadpqyHfGUe45R5fo3r+uKBSOlAZOTGJd+YqCQpc01YDwUh47g4TzDM38tQif+4+CrvD7pYXTi93R20+NL/PUSfqw9U/h2gkzvSYLUKOlehHHnWZhwFJIEzM8QwKca9p7m6G+CARFkocOZ//q5iclpEGbHQPa2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jF9S6iX5K1DpgzmN80iyTlDwQoTip9TMgT4/Ycze5Us=;
 b=X0tz1zbpHmKDglNHWi4fi2cOjcWGCQcqyyah3nbll3zDckRtTRanGWO6VBDNiI9D7ZElBe/erGfjtJIpqPDQv5vpExq3N5+rhdywbR5JdV4Wj27Y+s2v59JjIbO0LSp6AazqPp9UgzTtsL8pkL7HMQlFXWYhtCe+U0guiEP/XqhaeNhTwVUYTTe6Ud2vq6Q30ldbnlx5j6paiCPffgWvl171m80ptxQMyf6oWZPIu1uz0r6Q/ELfWvtRzdW6Rr/kxhQm/D5TkC28Y4ryrJvh0L2KSBf16mgWWM1ZkssLRz5qeFMGWR5Z0iCN30jsThPsmNcndUHUEp0rovw/zfub/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BY5PR18MB3266.namprd18.prod.outlook.com (10.255.163.207) by
 BY5PR18MB3234.namprd18.prod.outlook.com (10.255.163.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 01:38:42 +0000
Received: from BY5PR18MB3266.namprd18.prod.outlook.com
 ([fe80::5c5:8dae:70ef:a254]) by BY5PR18MB3266.namprd18.prod.outlook.com
 ([fe80::5c5:8dae:70ef:a254%4]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 01:38:42 +0000
From:   Qu WenRuo <wqu@suse.com>
To:     Sasha Levin <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     David Sterba <DSterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] btrfs: tracepoints: Fix wrong parameter
 order for qgroup" failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] btrfs: tracepoints: Fix wrong parameter
 order for qgroup" failed to apply to 4.19-stable tree
Thread-Index: AQHVjOub0hy5CrUqpE+iLWKwDWDCMadwLQiAgACsRQA=
Date:   Tue, 29 Oct 2019 01:38:41 +0000
Message-ID: <9b779226-bf27-4111-1919-17a725377189@suse.com>
References: <157219129664247@kroah.com> <20191028152157.GC1554@sasha-vm>
In-Reply-To: <20191028152157.GC1554@sasha-vm>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: TY2PR0101CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::20) To BY5PR18MB3266.namprd18.prod.outlook.com
 (2603:10b6:a03:1a1::15)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=wqu@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [13.231.109.76]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: baed1caa-7fb8-4b5b-62d5-08d75c10ba80
x-ms-traffictypediagnostic: BY5PR18MB3234:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3234315B11A7113321B1CFDCD6610@BY5PR18MB3234.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(189003)(199004)(31696002)(6486002)(86362001)(14444005)(256004)(6436002)(7736002)(229853002)(66066001)(305945005)(26005)(102836004)(81156014)(81166006)(54906003)(53546011)(6506007)(386003)(186003)(99286004)(478600001)(110136005)(8936002)(25786009)(76176011)(2616005)(476003)(14454004)(52116002)(8676002)(486006)(11346002)(446003)(5660300002)(4326008)(316002)(6512007)(6246003)(71190400001)(36756003)(71200400001)(2501003)(66476007)(2906002)(31686004)(66446008)(64756008)(66946007)(66556008)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3234;H:BY5PR18MB3266.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WUyj+LBFMkLsC60NtvcvamesNa2rOoaj1Imv6tgZq21vDOJyIj0saWOhu2tZSyX895Thz9yn1Xdqz/UVutiXPaGgs7FKmtGIga9HpnkTQCYLIHu/Ls07l4MfrPa8TJJG8uWtkT42faoEC8vSq/Y+6VIvlJNj1XHhxp0+noJkouDdErsKJD/hybY2tFTyIS9hg0J5CnAKQ1kNp4F2Q+KC4W940ps2O7iOGMDoWX9k2t/Pyrm6unnS7C19GbIOldJ5fabQP3XDWaJhJh/HkJ6IaWIAoskeI9ExlsKeKhGcG5fSqw03lITEWswrFUgzURtyv4XE0jbu2+C7GHb+1DGqtP+UeKE+FUc5bI6OQBw6c1Is+6H2bmiZVeNkOULnfX4o8hMSbV+gET6/iihKGAVZgGxfb9JEJE2FAg5/fjtdFsphcGVcu0T9hH09ObB3Md54
Content-Type: text/plain; charset="utf-8"
Content-ID: <B66884A4C7CA9241AD0E1DF5CA832E9E@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: baed1caa-7fb8-4b5b-62d5-08d75c10ba80
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 01:38:41.6721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W8RtmPWDlFMD7/UltLgK/oYVXDc8YWII+fo99Jbn873kXuKPtOhkD4+jQDPe9J6m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3234
X-OriginatorOrg: suse.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCk9uIDIwMTkvMTAvMjgg5LiL5Y2IMTE6MjEsIFNhc2hhIExldmluIHdyb3RlOg0KPiBPbiBT
dW4sIE9jdCAyNywgMjAxOSBhdCAwNDo0ODoxNlBNICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0
aW9uLm9yZyB3cm90ZToNCj4+DQo+PiBUaGUgcGF0Y2ggYmVsb3cgZG9lcyBub3QgYXBwbHkgdG8g
dGhlIDQuMTktc3RhYmxlIHRyZWUuDQo+PiBJZiBzb21lb25lIHdhbnRzIGl0IGFwcGxpZWQgdGhl
cmUsIG9yIHRvIGFueSBvdGhlciBzdGFibGUgb3IgbG9uZ3Rlcm0NCj4+IHRyZWUsIHRoZW4gcGxl
YXNlIGVtYWlsIHRoZSBiYWNrcG9ydCwgaW5jbHVkaW5nIHRoZSBvcmlnaW5hbCBnaXQgY29tbWl0
DQo+PiBpZCB0byA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4uDQo+Pg0KPj4gdGhhbmtzLA0KPj4N
Cj4+IGdyZWcgay1oDQo+Pg0KPj4gLS0tLS0tLS0tLS0tLS0tLS0tIG9yaWdpbmFsIGNvbW1pdCBp
biBMaW51cydzIHRyZWUgLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pg0KPj4gRnJvbSBmZDJiMDA3ZWFl
Yzg5ODU2NGUyNjlkMWY0NzhhMmRhMDM4MGVjZjUxIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0K
Pj4gRnJvbTogUXUgV2VucnVvIDx3cXVAc3VzZS5jb20+DQo+PiBEYXRlOiBUaHUsIDE3IE9jdCAy
MDE5IDEwOjM4OjM2ICswODAwDQo+PiBTdWJqZWN0OiBbUEFUQ0hdIGJ0cmZzOiB0cmFjZXBvaW50
czogRml4IHdyb25nIHBhcmFtZXRlciBvcmRlciBmb3IgcWdyb3VwDQo+PiBldmVudHMNCj4+DQo+
PiBbQlVHXQ0KPj4gRm9yIGJ0cmZzOnFncm91cF9tZXRhX3Jlc2VydmUgZXZlbnQsIHRoZSB0cmFj
ZSBldmVudCBjYW4gb3V0cHV0IGdhcmJhZ2U6DQo+Pg0KPj4gwqBxZ3JvdXBfbWV0YV9yZXNlcnZl
OiA5YzdmNmFjYy1iMzQyLTQwMzctYmM0Ny03ZjZlNGQyMjMyZDc6DQo+PiByZWZyb290PTUoRlNf
VFJFRSkgdHlwZT1EQVRBIGRpZmY9Mg0KPj4NCj4+IFRoZSBkaWZmIHNob3VsZCBhbHdheXMgYmUg
YWxpbmdlZCB0byBzZWN0b3Igc2l6ZSAoNGspLCBzbyB0aGVyZSBpcw0KPj4gZGVmaW5pdGVseSBz
b21ldGhpbmcgd3JvbmcuDQo+Pg0KPj4gW0NBVVNFXQ0KPj4gRm9yIHRoZSB3cm9uZyBAZGlmZiwg
aXQncyBjYXVzZWQgYnkgd3JvbmcgcGFyYW1ldGVyIG9yZGVyLg0KPj4gVGhlIGNvcnJlY3QgcGFy
YW1ldGVycyBhcmU6DQo+Pg0KPj4gwqBzdHJ1Y3QgYnRyZnNfcm9vdCwgczY0IGRpZmYsIGludCB0
eXBlLg0KPj4NCj4+IEhvd2V2ZXIgdGhlIHBhcmFtZXRlcnMgdXNlZCBhcmU6DQo+Pg0KPj4gwqBz
dHJ1Y3QgYnRyZnNfcm9vdCwgaW50IHR5cGUsIHM2NCBkaWZmLg0KPj4NCj4+IEZpeGVzOiA0ZWUw
ZDg4MzJjMmUgKCJidHJmczogcWdyb3VwOiBVcGRhdGUgdHJhY2UgZXZlbnRzIGZvciBtZXRhZGF0
YQ0KPj4gcmVzZXJ2YXRpb24iKQ0KPj4gQ0M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyA0LjE5
Kw0KPj4gUmV2aWV3ZWQtYnk6IE5pa29sYXkgQm9yaXNvdiA8bmJvcmlzb3ZAc3VzZS5jb20+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBRdSBXZW5ydW8gPHdxdUBzdXNlLmNvbT4NCj4+IFJldmlld2VkLWJ5
OiBEYXZpZCBTdGVyYmEgPGRzdGVyYmFAc3VzZS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBEYXZp
ZCBTdGVyYmEgPGRzdGVyYmFAc3VzZS5jb20+DQo+IA0KPiBKdXN0IG5lZWRlZCBzb21lIGxvdmUg
dG8gd29yayBhcm91bmQgbWlzc2luZyA0ZmQ3ODZlNmMzZDY3ICgiYnRyZnM6DQo+IFJlbW92ZSAn
b2JqZWN0aWQnIG1lbWJlciBmcm9tIHN0cnVjdCBidHJmc19yb290IikuIFF1ZXVlZCB1cCBmb3Ig
NC4xOS4NCj4gDQoNCkFGQUlLIEkganVzdCBzZW50IG91dCB0aGUgZml4ZWQgcGF0Y2hlcyBmb3Ig
NC4xOSBhbmQgNS4zIGJyYW5jaGVzLg0KDQpUaGFua3MsDQpRdQ0K
