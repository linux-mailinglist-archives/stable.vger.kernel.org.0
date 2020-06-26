Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2FD20BC4B
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 00:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgFZWP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 18:15:56 -0400
Received: from mail-dm6nam11on2114.outbound.protection.outlook.com ([40.107.223.114]:64225
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgFZWP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 18:15:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9q77+2ycOMpe2cy7S2C0gwvodZGL2ub1RkUqzF0fjxBJU7Z70s03tN0hAbzcN7YI9HptZsAAadkoGcFLI5YpVJ8x+GJhF5dqWOO6HedHnrQj4SS+VWKw70QELv+/UOwP0K7p2sGLF4AuCwrgjcA1WtXzK6cbbH8/RuKmGWiar2jFaWJiWQOdLJ8++AMiNkBKVEJh3VLhmpnljDM2LXmaPdfry3NK3aAJG8f2vnmudf7aAKHCNOQ/vGGs71Aw4hLSge68oeFgKMdNtFRNuY3o+AfZIdEb/txR8WsWwDQ5u+LP7cJId+8/nt3zD1pXGqpYTPHbcPvxL568QddXz3kBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAnq3IpSHW3SwZWnhiug4xjVskgvhfvaWMwYleFaDCM=;
 b=Z9Lx5Z0kK0JX1KGFbcOHZKPI4L1WBZ6HrNB1GhvMeqz12CeoXlZiYC8o0JNccrQDwiePBAjYrObNSOBBghgVBs+/lX+++TKcO6WcnUG9ANeP39vhWR5h6oQUxm/iDiNP2G6bPa1uPwKjPmoyyM4yc06wgXcJPcyxZ5TlVCxTFa4JVIW8UZvCv3pAdb0a6eUfIKPWT/CUtlWOVWfiJZK3aWvnZTkN81EtDVgmGVocyyUsjmH720no7uXqn8q7z5gNajN/bFaygfDE/EdBIVlpVkIXGpiZRNIvu2kwJxraMm3u+bFWiBVj3x9Cqel/AjbUDlmqRHx//Z8gEs8S/CxdUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAnq3IpSHW3SwZWnhiug4xjVskgvhfvaWMwYleFaDCM=;
 b=ar+jluGs0GQ2S3zPC194hHzVPBOXHNGHcWbZ0pI2Wt7TUJSftRxkhH15ZLT8qmqObd5FkG5UwQ6K7whtyIntRYvcx3Z/jr+6EFsNq+kYbultizxDSfyDvGFQzESX8wyam4tWb5HYdwtx7PXDhbtnxwAKME1QfgFeDTsFj0bMXZg=
Received: from MN2PR21MB1453.namprd21.prod.outlook.com (2603:10b6:208:1f7::10)
 by BL0PR2101MB1331.namprd21.prod.outlook.com (2603:10b6:208:92::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.3; Fri, 26 Jun
 2020 22:15:53 +0000
Received: from MN2PR21MB1453.namprd21.prod.outlook.com
 ([fe80::90ec:f75d:5e4a:cb26]) by MN2PR21MB1453.namprd21.prod.outlook.com
 ([fe80::90ec:f75d:5e4a:cb26%8]) with mapi id 15.20.3153.014; Fri, 26 Jun 2020
 22:15:53 +0000
From:   Joseph Salisbury <Joseph.Salisbury@microsoft.com>
To:     Michael Kelley <mikelley@microsoft.com>,
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
Thread-Index: AQHWS+HzVTYTKiLVr0O7dTomrubg4KjrWqJQgAAa/lA=
Date:   Fri, 26 Jun 2020 22:15:53 +0000
Message-ID: <MN2PR21MB1453A27BD0EBE78E7ECA49C99C930@MN2PR21MB1453.namprd21.prod.outlook.com>
References: <1593193685-74615-1-git-send-email-joseph.salisbury@microsoft.com>
 <MW2PR2101MB10520D5E1FDE45C5DF03D073D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB10520D5E1FDE45C5DF03D073D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
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
x-originating-ip: [2600:1000:b023:153d:f8cf:5fe1:3d:9387]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e21e407-92bd-4a97-3dfe-08d81a1e7dbf
x-ms-traffictypediagnostic: BL0PR2101MB1331:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB13311899F55B72F6C8B82EE79C930@BL0PR2101MB1331.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jk/WCZ/aNLvmj+NP3PSiyCEl0NlOuX8CZYO7vYhGhNzszjQhImm9v/MAlS7MMQaQERcFhkq9C6bz3EuOyFBH4y5at53b9AjUfDN9lGc9Fj1NoLdHCjr0TdAYhpzwzaI8W25jorelhDAWry6Zz4tMAswea3kQJtz9DZQM76GJp8eRHoGdB0TOnv9Z2Su5noGs9PMUetx1/1bJwlt0pUpHVsimgupfiF2evp6KL30zScqb+SX2oRZidcVCuyKMhIYFvGVWKSAhIcPeaxq8fb8WTWY6no3f9qFt6GudeC4o5QWYjFIbEuPYLMqfxuOa4sWq9WUwLhKzvQ1no4iC2VUHIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1453.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(9686003)(53546011)(6506007)(86362001)(186003)(7696005)(4326008)(10290500003)(8990500004)(2906002)(478600001)(55016002)(8676002)(83380400001)(5660300002)(33656002)(71200400001)(66446008)(66946007)(64756008)(82960400001)(76116006)(52536014)(66476007)(66556008)(110136005)(54906003)(8936002)(82950400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: p66881FTGKRhi+tl14nVgY/p1Iib1ov6thOYlTHhNm6FUHEyrxxTl1KiAyfS0bI+sZfSLp/Do1DPAxHc4d6EVd10PxLtoXNQu8AEuwMY8q7N0l4t8DHQUqII0lcQZ810jz8nABC3kSwfuRYAgIEdZkIpnP57V48SplQPcppMId4ZJulndBRDcOylz3hnRxCpWuH+Aiyb+5S30CggpGwcrhTUEXyvyzugOc9IdGu/KVqw5Isc7Ihfbs6Op7hTDvCrqGganin/9VOResfHDMmVh2gM4eEB8kMX3cCy0zSy9BACA+gJVtjvw2OtslmcDlVew0bnTxP6P+POwEGcUAA1IHUMCo9cQDAsrItyXYvcDGqSHN1QmhJIjUQ9KHfBFqNMljS+Kmadx5mEIVreXXpwPXJOOTmPQ7oaXqdjdQc+BmDWwN42y4XjJL3fjXYuEleb51G0J2Ou3LZ46BQ9qUPBgBJnVo2TWDcHq8A6rokGJQ6lUxHKBex9TPLyP+5V5FFB6Wehh0Mem6HDjSBX5Vqmei2b9CR8ZBwNnuwX4jGM+H4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1453.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e21e407-92bd-4a97-3dfe-08d81a1e7dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 22:15:53.2537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DJAMXuwh/LywVNmcGOA5msGZUpeuEV7qr+zP6Oq3WWp7vOrQlR0gycbgEV3oY4kWX8Qs28fyBJQ39Gq9yAZ1XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1331
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhhbmtzIGZvciB0aGUgZmVlZGJhY2ssIE1pY2hhZWwuICBJJ2xsIHNlbmQgYSB2Mi4NCg0KVGhh
bmtzLA0KDQpKb2UNCg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogTWljaGFl
bCBLZWxsZXkgPG1pa2VsbGV5QG1pY3Jvc29mdC5jb20+IA0KU2VudDogRnJpZGF5LCBKdW5lIDI2
LCAyMDIwIDQ6NTMgUE0NClRvOiBKb3NlcGggU2FsaXNidXJ5IDxKb3NlcGguU2FsaXNidXJ5QG1p
Y3Jvc29mdC5jb20+OyBLWSBTcmluaXZhc2FuIDxreXNAbWljcm9zb2Z0LmNvbT47IEhhaXlhbmcg
WmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBTdGVwaGVuIEhlbW1pbmdlciA8c3RoZW1t
aW5AbWljcm9zb2Z0LmNvbT47IHNhc2hhbEBrZXJuZWwub3JnOyB3ZWkubGl1QGtlcm5lbC5vcmcN
CkNjOiBsaW51eC1oeXBlcnZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSRTogW1BBVENIXSBEcml2
ZXJzOiBodjogQ2hhbmdlIGZsYWcgdG8gd3JpdGUgbG9nIGxldmVsIGluIHBhbmljIG1zZyB0byBm
YWxzZQ0KDQpGcm9tOiBKb3NlcGggU2FsaXNidXJ5IDxqb3NlcGguc2FsaXNidXJ5QG1pY3Jvc29m
dC5jb20+IFNlbnQ6IEZyaWRheSwgSnVuZSAyNiwgMjAyMCAxMDo0OCBBTQ0KPiANCj4gV2hlbiB0
aGUga2VybmVsIHBhbmljcywgb25lIHBhZ2Ugd29ydGggb2Yga21zZyBkYXRhIGlzIHdyaXR0ZW4g
dG8gYW4gDQo+IGFsbG9jYXRlZCBwYWdlLiAgVGhlIEh5cGVydmlzb3IgaXMgbm90aWZpZWQgb2Yg
dGhlIHBhZ2UgYWRkcmVzcyB0cm91Z2ggDQo+IHRoZSBNU1IuICBUaGlzIHBhbmljIGluZm9ybWF0
aW9uIGlzIGNvbGxlY3RlZCBvbiB0aGUgaG9zdC4gIFNpbmNlIHdlIA0KPiBhcmUgb25seSBjb2xs
ZWN0aW5nIG9uZSBwYWdlIG9mIGRhdGEsIHRoZSBmdWxsIHBhbmljIG1lc3NhZ2UgbWF5IG5vdCBi
ZSBjb2xsZWN0ZWQuDQo+IA0KPiBFYWNoIGxpbmUgb2YgdGhlIHBhbmljIG1lc3NhZ2UgaXMgcHJl
Zml4ZWQgd2l0aCB0aGUgbG9nIGxldmVsIG9mIHRoYXQNCj4gcGFydGljdWxhciBtZXNzYWdlIGlu
IHRoZSBmb3JtIDxOPiwgd2hlcmUgTiBpcyB0aGUgbG9nIGxldmVsLiAgIFRoZSB0eXBpY2FsDQo+
IDQgS2J5dGVzIGNvbnRhaW5zIGFueXdoZXJlIGZyb20gNTAgdG8gMTAwIGxpbmVzIHdpdGggdGhh
dCBsb2cgbGV2ZWwgcHJlZml4Lg0KPiANCj4gaHZfZG1zZ19kdW1wKCkgbWFrZXMgYSBjYWxsIHRv
IGttc2dfZHVtcF9nZXRfYnVmZmVyKCkuICBUaGUgc2Vjb25kIA0KPiBhcmd1bWVudCBpbiB0aGUg
Y2FsbCBpcyBhIGJvb2wgZGVzY3JpYmVkIGFzOiDigJhAc3lzbG9nOiBpbmNsdWRlIHRoZSDigJw8
ND7igJ0gUHJlZml4ZXPigJkuDQo+IA0KPiBXaXRoIHRoaXMgY2hhbmdlLCB3ZSB3aWxsIG5vdCB3
cml0ZSB0aGUgbG9nIGxldmVsIHRvIHRoZSBhbGxvY2F0ZWQgDQo+IHBhZ2UuICBUaGlzIHdpbGwg
cHJvdmlkZSBhZGRpdGlvbmFsIHJvb20gaW4gdGhlIGFsbG9jYXRlZCBwYWdlIGZvciANCj4gbW9y
ZSBpbmZvcm1hdGl2ZSBwYW5pYyBpbmZvcm1hdGlvbi4NCg0KTGV0IG1lIHN1Z2dlc3QgdGlnaHRl
bmluZyB0aGUgY29tbWl0IG1lc3NhZ2UgYSBiaXQsIHdpdGggZm9jdXMgb24gdGhlICJ3aGF0Ig0K
YW5kICJ3aHkiIHJhdGhlciB0aGFuIHRoZSBkZXRhaWxzIG9mIHRoZSBjb2RlIGNoYW5nZS4gIEFs
c28gdXNlIGltcGVyYXRpdmUgdm9pY2UgcGVyIHRoZSBMaW51eCBrZXJuZWwgZ3VpZGVsaW5lczoN
Cg0KV2hlbiB0aGUga2VybmVsIHBhbmljcywgb25lIHBhZ2Ugb2Yga21zZyBkYXRhIG1heSBiZSBj
b2xsZWN0ZWQgYW5kIHNlbnQgdG8gSHlwZXItViB0byBhaWQgaW4gZGlhZ25vc2luZyB0aGUgZmFp
bHVyZS4gIFRoZSBjb2xsZWN0ZWQga21zZyBkYXRhIHR5cGljYWxseSBjb250YWlucyA1MCB0byAx
MDAgbGluZXMsIGVhY2ggb2Ygd2hpY2ggaGFzIGEgbG9nIGxldmVsIHByZWZpeCB0aGF0IGlzbid0
IHZlcnkgdXNlZnVsIGZyb20gYSBkaWFnbm9zdGljIHN0YW5kcG9pbnQuICBTbyB0ZWxsIGttc2df
ZHVtcF9nZXRfYnVmZmVyKCkgdG8gbm90IGluY2x1ZGUgdGhlIGxvZyBsZXZlbCwgZW5hYmxpbmcg
bW9yZSBpbmZvcm1hdGlvbiB0aGF0ICppcyogdXNlZnVsIHRvIGZpdCBpbiB0aGUgcGFnZS4NCg0K
PiANCj4gUmVxdWVzdGluZyBpbiBzdGFibGUga2VybmVscywgc2luY2UgbWFueSBrZXJuZWxzIHJ1
bm5pbmcgaW4gcHJvZHVjdGlvbiANCj4gYXJlIHN0YWJsZSByZWxlYXNlcy4NCj4gDQo+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IEpvc2VwaCBTYWxpc2J1cnkg
PGpvc2VwaC5zYWxpc2J1cnlAbWljcm9zb2Z0LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2h2L3Zt
YnVzX2Rydi5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9odi92bWJ1c19kcnYuYyBiL2Ry
aXZlcnMvaHYvdm1idXNfZHJ2LmMgaW5kZXggDQo+IDkxNDdlZTlkNWY3ZC4uZDY5ZjRlZmEzNzE5
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2h2L3ZtYnVzX2Rydi5jDQo+ICsrKyBiL2RyaXZlcnMv
aHYvdm1idXNfZHJ2LmMNCj4gQEAgLTEzNjgsNyArMTM2OCw3IEBAIHN0YXRpYyB2b2lkIGh2X2tt
c2dfZHVtcChzdHJ1Y3Qga21zZ19kdW1wZXIgKmR1bXBlciwNCj4gIAkgKiBXcml0ZSBkdW1wIGNv
bnRlbnRzIHRvIHRoZSBwYWdlLiBObyBuZWVkIHRvIHN5bmNocm9uaXplOyBwYW5pYyBzaG91bGQN
Cj4gIAkgKiBiZSBzaW5nbGUtdGhyZWFkZWQuDQo+ICAJICovDQo+IC0Ja21zZ19kdW1wX2dldF9i
dWZmZXIoZHVtcGVyLCB0cnVlLCBodl9wYW5pY19wYWdlLCBIVl9IWVBfUEFHRV9TSVpFLA0KPiAr
CWttc2dfZHVtcF9nZXRfYnVmZmVyKGR1bXBlciwgZmFsc2UsIGh2X3BhbmljX3BhZ2UsIEhWX0hZ
UF9QQUdFX1NJWkUsDQo+ICAJCQkgICAgICZieXRlc193cml0dGVuKTsNCj4gIAlpZiAoYnl0ZXNf
d3JpdHRlbikNCj4gIAkJaHlwZXJ2X3JlcG9ydF9wYW5pY19tc2cocGFuaWNfcGEsIGJ5dGVzX3dy
aXR0ZW4pOw0KPiAtLQ0KPiAyLjE3LjENCg0KV2l0aCB0aGUgY29tbWl0IG1lc3NhZ2UgY2hhbmdl
cywNCg0KUmV2aWV3ZWQtYnk6IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQuY29t
Pg0K
