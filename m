Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A813020BAAC
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 22:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgFZUx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 16:53:29 -0400
Received: from mail-dm6nam11on2094.outbound.protection.outlook.com ([40.107.223.94]:20353
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725803AbgFZUx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 16:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PY37XvIJlGbFigavvT07zMC9MlclWjobsPY6OkF/+TAqlt1ZEv1vBd+bpCWUWTuRraSDUkMyf6TN6+ZhIYuEvtqn7Kj+AU1lfkUZq86gjtx88RPvdKubE/hblPco9qQabee4s7cg5TLPBch/p72cu1E+T9Tzx1iVz3oM/rUTRbd/CtoxOZSXzrOxVzoDvixc15jl80vs1cXSKa7a2+bPIvCWfT5LiE16Fyqqt3RXQuxgYs9Ee0hiQjucHQGAoW9caGxBEJFFYdYjswyP6jD83kYumHihxtK9jv+LRvGxkZvBlpw1Kf4uhKRI9t78pn7wkGVNaiqc6KZIlIXbVYj7Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fee7cRALjuCK2Je7psVdChFHV0A6/W7a5S74IYesyWg=;
 b=MFGit+ch/kyFdKxuPBsZuZ5BJ8PZRDe9ZXRia4Vbey+f44NE73G8RuwoWgQus1KHh5xjDQEfmsAg16Wuy0HgUNFOWZA65mW4+WGSXOdoOVn7EjwhWmpchKQIMHdzEyWpEJ2TbUysvaaz8YDn+Y5dguuWvUukVYmBIecZZSOQU9dq8A8aHye00s1AQWR6XvCPUXLreRnu1GZwoAr9ppPigpm5GIPzj8igw+WNTtiTu8DwWFT4dhS2pU2NMyjEtxi9YXtxRDxcFYMgwe1ghXY7LERATxATsOMDXguRBEAl2MWJxllDqIfFsY/CKI+03AcgwH0hC9usfclEf5jyeWgTKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fee7cRALjuCK2Je7psVdChFHV0A6/W7a5S74IYesyWg=;
 b=aOKpSKV3Kf35eZN8+s57n5Jb++g01m6CoQvO48BEL24/tXo9FM3FSOUiBnCrs1D7guYjVbvJpSvpP7fLKYtkU7DdcDvhNJjRDHN7ftnnZu0tvzyXA1ovKqCxysoeFZYOa4/TtmGaWkrt5kj3/AGk0vsQfNA4vlgSnfaiknxkC+8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0730.namprd21.prod.outlook.com (2603:10b6:301:7f::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.5; Fri, 26 Jun
 2020 20:53:25 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%9]) with mapi id 15.20.3153.005; Fri, 26 Jun 2020
 20:53:25 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: Change flag to write log level in panic msg
 to false
Thread-Topic: [PATCH] Drivers: hv: Change flag to write log level in panic msg
 to false
Thread-Index: AQHWS+HzVTYTKiLVr0O7dTomrubg4KjrWqJQ
Date:   Fri, 26 Jun 2020 20:53:25 +0000
Message-ID: <MW2PR2101MB10520D5E1FDE45C5DF03D073D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <1593193685-74615-1-git-send-email-joseph.salisbury@microsoft.com>
In-Reply-To: <1593193685-74615-1-git-send-email-joseph.salisbury@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-06-26T20:53:23Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a4721757-2579-4dc7-adb6-85c2b12895f0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 62f40282-c549-400d-c757-08d81a12f876
x-ms-traffictypediagnostic: MWHPR2101MB0730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2101MB0730369D06FD30B3A415634ED7930@MWHPR2101MB0730.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HSFKm9+57eb9C4nEpU4bFW3grizJ0J5vlu8N8za5fnGPnEagi3Psg3/IhgddByWLayNmnN9CYthdp3byypaeVrx83x5RlWvrPj5eQ8GDHgDvSDQlAocvf6j0p7QebMWQSW6iRxYskzrfl2yW2XjRxQKz1bLJT/07hihbqhye6O7Y0b/rJCHD9oqLTVRqeCkgN7z2v1nJHWQqpAMUBgsUvTeHVbf/k66pdaPWfMklyuQPhWoQtCYHw6fc3RTuElUog4eYdNVT0swtCicl7QQGfW1Nb49A62cd0XGe9OBTtUw6SXreIOkeSSziJSb/SjSGVDktD3cYodPphEDIvkgCMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(82950400001)(186003)(82960400001)(4326008)(10290500003)(110136005)(6506007)(86362001)(2906002)(478600001)(8990500004)(52536014)(54906003)(316002)(66556008)(33656002)(26005)(76116006)(66446008)(66946007)(64756008)(5660300002)(66476007)(7696005)(55016002)(83380400001)(8936002)(71200400001)(9686003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DXtMWPWZrAX2TWE6DEZQ9Lxay8+r6Dp/AuMY2No8aU1sNFsNTjAMByYQsEOhNqx6/NQey0CbcTFRtK2keAx8bYnepoJqNe1nXnAZ9c4XbVVd45p2ZI3wTZWlaSVOGOZVhuQ8byd8Iy5EEaPl7F/c/w1Rd5hDeaNYLeFCjLejnIM99evMkw0jk8XhRh36Z4rMUkRDIUd9+LsezXDsUpRfplMASBijyShCSz+dlBHxNp7j/hTsfwd0jhcW2jcxadRA1adWRajNvOBanmYLCKo9BtikRKvknraFtWIBtJ4bLztOoum4lgdoexfKZVne8vcN0Hn0OQzcv1grUyzmyiooe6DN0Zj33xxw+RLcJY6UUrhVcihXM4r9g6bTmRLvCqpqvl6PDeW7SBj64rCfv58O1PlJ78wW85tCJoKo0WQIvUs/29RXK2uz6Cfnd2oFju7hsj+ikF+ZLhpseHZ398EbkGtYiYbAnxm2rVBHEr9cuV7ynT/072R2RF2hYCJ9GX3U
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f40282-c549-400d-c757-08d81a12f876
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 20:53:25.2502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKUtZFmYQbtcjzX+tF6+0uXiz+R+RrbmriNrugnUh5URu8uvUCxOPuewF3l84kia7itckgJ/N0Ww/+t8JnffPrmPiars4hqKACw8cGNTfxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0730
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSm9zZXBoIFNhbGlzYnVyeSA8am9zZXBoLnNhbGlzYnVyeUBtaWNyb3NvZnQuY29tPiBT
ZW50OiBGcmlkYXksIEp1bmUgMjYsIDIwMjAgMTA6NDggQU0NCj4gDQo+IFdoZW4gdGhlIGtlcm5l
bCBwYW5pY3MsIG9uZSBwYWdlIHdvcnRoIG9mIGttc2cgZGF0YSBpcyB3cml0dGVuIHRvIGFuIGFs
bG9jYXRlZA0KPiBwYWdlLiAgVGhlIEh5cGVydmlzb3IgaXMgbm90aWZpZWQgb2YgdGhlIHBhZ2Ug
YWRkcmVzcyB0cm91Z2ggdGhlIE1TUi4gIFRoaXMNCj4gcGFuaWMgaW5mb3JtYXRpb24gaXMgY29s
bGVjdGVkIG9uIHRoZSBob3N0LiAgU2luY2Ugd2UgYXJlIG9ubHkgY29sbGVjdGluZyBvbmUNCj4g
cGFnZSBvZiBkYXRhLCB0aGUgZnVsbCBwYW5pYyBtZXNzYWdlIG1heSBub3QgYmUgY29sbGVjdGVk
Lg0KPiANCj4gRWFjaCBsaW5lIG9mIHRoZSBwYW5pYyBtZXNzYWdlIGlzIHByZWZpeGVkIHdpdGgg
dGhlIGxvZyBsZXZlbCBvZiB0aGF0DQo+IHBhcnRpY3VsYXIgbWVzc2FnZSBpbiB0aGUgZm9ybSA8
Tj4sIHdoZXJlIE4gaXMgdGhlIGxvZyBsZXZlbC4gICBUaGUgdHlwaWNhbA0KPiA0IEtieXRlcyBj
b250YWlucyBhbnl3aGVyZSBmcm9tIDUwIHRvIDEwMCBsaW5lcyB3aXRoIHRoYXQgbG9nIGxldmVs
IHByZWZpeC4NCj4gDQo+IGh2X2Rtc2dfZHVtcCgpIG1ha2VzIGEgY2FsbCB0byBrbXNnX2R1bXBf
Z2V0X2J1ZmZlcigpLiAgVGhlIHNlY29uZCBhcmd1bWVudCBpbg0KPiB0aGUgY2FsbCBpcyBhIGJv
b2wgZGVzY3JpYmVkIGFzOiDigJhAc3lzbG9nOiBpbmNsdWRlIHRoZSDigJw8ND7igJ0gUHJlZml4
ZXPigJkuDQo+IA0KPiBXaXRoIHRoaXMgY2hhbmdlLCB3ZSB3aWxsIG5vdCB3cml0ZSB0aGUgbG9n
IGxldmVsIHRvIHRoZSBhbGxvY2F0ZWQgcGFnZS4gIFRoaXMNCj4gd2lsbCBwcm92aWRlIGFkZGl0
aW9uYWwgcm9vbSBpbiB0aGUgYWxsb2NhdGVkIHBhZ2UgZm9yIG1vcmUgaW5mb3JtYXRpdmUgcGFu
aWMNCj4gaW5mb3JtYXRpb24uDQoNCkxldCBtZSBzdWdnZXN0IHRpZ2h0ZW5pbmcgdGhlIGNvbW1p
dCBtZXNzYWdlIGEgYml0LCB3aXRoIGZvY3VzIG9uIHRoZSAid2hhdCINCmFuZCAid2h5IiByYXRo
ZXIgdGhhbiB0aGUgZGV0YWlscyBvZiB0aGUgY29kZSBjaGFuZ2UuICBBbHNvIHVzZSBpbXBlcmF0
aXZlDQp2b2ljZSBwZXIgdGhlIExpbnV4IGtlcm5lbCBndWlkZWxpbmVzOg0KDQpXaGVuIHRoZSBr
ZXJuZWwgcGFuaWNzLCBvbmUgcGFnZSBvZiBrbXNnIGRhdGEgbWF5IGJlIGNvbGxlY3RlZCBhbmQg
c2VudCB0bw0KSHlwZXItViB0byBhaWQgaW4gZGlhZ25vc2luZyB0aGUgZmFpbHVyZS4gIFRoZSBj
b2xsZWN0ZWQga21zZyBkYXRhIHR5cGljYWxseQ0KY29udGFpbnMgNTAgdG8gMTAwIGxpbmVzLCBl
YWNoIG9mIHdoaWNoIGhhcyBhIGxvZyBsZXZlbCBwcmVmaXggdGhhdCBpc24ndCB2ZXJ5DQp1c2Vm
dWwgZnJvbSBhIGRpYWdub3N0aWMgc3RhbmRwb2ludC4gIFNvIHRlbGwga21zZ19kdW1wX2dldF9i
dWZmZXIoKSB0byBub3QNCmluY2x1ZGUgdGhlIGxvZyBsZXZlbCwgZW5hYmxpbmcgbW9yZSBpbmZv
cm1hdGlvbiB0aGF0ICppcyogdXNlZnVsIHRvIGZpdCBpbiB0aGUgcGFnZS4NCg0KPiANCj4gUmVx
dWVzdGluZyBpbiBzdGFibGUga2VybmVscywgc2luY2UgbWFueSBrZXJuZWxzIHJ1bm5pbmcgaW4g
cHJvZHVjdGlvbiBhcmUNCj4gc3RhYmxlIHJlbGVhc2VzLg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogSm9zZXBoIFNhbGlzYnVyeSA8am9zZXBoLnNh
bGlzYnVyeUBtaWNyb3NvZnQuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvaHYvdm1idXNfZHJ2LmMg
fCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2h2L3ZtYnVzX2Rydi5jIGIvZHJpdmVycy9odi92
bWJ1c19kcnYuYw0KPiBpbmRleCA5MTQ3ZWU5ZDVmN2QuLmQ2OWY0ZWZhMzcxOSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9odi92bWJ1c19kcnYuYw0KPiArKysgYi9kcml2ZXJzL2h2L3ZtYnVzX2Ry
di5jDQo+IEBAIC0xMzY4LDcgKzEzNjgsNyBAQCBzdGF0aWMgdm9pZCBodl9rbXNnX2R1bXAoc3Ry
dWN0IGttc2dfZHVtcGVyICpkdW1wZXIsDQo+ICAJICogV3JpdGUgZHVtcCBjb250ZW50cyB0byB0
aGUgcGFnZS4gTm8gbmVlZCB0byBzeW5jaHJvbml6ZTsgcGFuaWMgc2hvdWxkDQo+ICAJICogYmUg
c2luZ2xlLXRocmVhZGVkLg0KPiAgCSAqLw0KPiAtCWttc2dfZHVtcF9nZXRfYnVmZmVyKGR1bXBl
ciwgdHJ1ZSwgaHZfcGFuaWNfcGFnZSwgSFZfSFlQX1BBR0VfU0laRSwNCj4gKwlrbXNnX2R1bXBf
Z2V0X2J1ZmZlcihkdW1wZXIsIGZhbHNlLCBodl9wYW5pY19wYWdlLCBIVl9IWVBfUEFHRV9TSVpF
LA0KPiAgCQkJICAgICAmYnl0ZXNfd3JpdHRlbik7DQo+ICAJaWYgKGJ5dGVzX3dyaXR0ZW4pDQo+
ICAJCWh5cGVydl9yZXBvcnRfcGFuaWNfbXNnKHBhbmljX3BhLCBieXRlc193cml0dGVuKTsNCj4g
LS0NCj4gMi4xNy4xDQoNCldpdGggdGhlIGNvbW1pdCBtZXNzYWdlIGNoYW5nZXMsDQoNClJldmll
d2VkLWJ5OiBNaWNoYWVsIEtlbGxleSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCg==
