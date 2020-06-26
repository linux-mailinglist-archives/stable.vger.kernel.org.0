Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF920BC6E
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 00:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgFZWZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 18:25:28 -0400
Received: from mail-dm6nam11on2110.outbound.protection.outlook.com ([40.107.223.110]:59873
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgFZWZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 18:25:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idg4Npj5UZtUaW9qmJ0BP+vSJxnW1eVlMvREk9CUHaU62Dp+TzuYGzI8u0pYRnkRdKQdHkY/2WZGJFzLA7awtyH7dX3SoIjRWq7QmdMBnjdIrzbnQiOvlFMh/2geW1gwbOshHFB0jB9ciKZscwyaW6LN73AklhK11w9AeM6ugcZ/p61pzkfXgTqwfDuMPVHUJljezRw7dXv1wZcITagZpD0BUofTaqFQPOa+nfqDEBfqj1ofCn0B8kAVRITewjq3wL/RsAk8nRbNvIlU77uaKOTMuw9lYu4f+B7oGbvtnmxpmI2fFKPdpJmN8LsCkhFLs5dLmYh0110TAlpk0qdQUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHMvTifpHk0ZhjXXpCHPcXixCmUqWEMpjzxf1kKjdOk=;
 b=ahh3mSm53cRs9cuWdgk+BK1rzXJFIrRPy6sT93OJi38w/7Vk6cAa1PQPEsyUJtzQgBeoi7KoVhime6FDxz6K4/b2kqM3gl2VJVn40YJFcm53mhJPPAOYrNXN6aomDWLgwVgZRhmsW4agrTtxM17uSqIvhl4v+Se4Hlm8jwz9dkjWNptlnjAZ7ICrbq/oiKue91snk691j9oWFRKMB/SRlrqnUe+Hg46VJ9HUsYhS7KPUDlsGOfd5+3M6g7/4knb/uH7aOHi6fGkqdEjF4PaeIc/f1WG+wOG5XMfXVWUAbR/1VHHUzV2KEbtzM4SuOqh//utUQaU/GNJ6caCGUvkvjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHMvTifpHk0ZhjXXpCHPcXixCmUqWEMpjzxf1kKjdOk=;
 b=Dap4IodBH5B7E/n5J3b0A2KN7Iu0UgertSOhgYvoTrnsUK/0Ukn5USGkNCddvtPB4JMTxmHneZP0DChS7WVczC0tr/FHeuAsN1b/r9u4XIiHLzcsgL3wWfVrcRrBNR7N9o6ItfPs0BYUGUB9UWCf9KsSG5+CquVxkbqW1+JVd8I=
Received: from MN2PR21MB1453.namprd21.prod.outlook.com (2603:10b6:208:1f7::10)
 by MN2PR21MB1502.namprd21.prod.outlook.com (2603:10b6:208:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.5; Fri, 26 Jun
 2020 22:25:25 +0000
Received: from MN2PR21MB1453.namprd21.prod.outlook.com
 ([fe80::90ec:f75d:5e4a:cb26]) by MN2PR21MB1453.namprd21.prod.outlook.com
 ([fe80::90ec:f75d:5e4a:cb26%8]) with mapi id 15.20.3153.014; Fri, 26 Jun 2020
 22:25:25 +0000
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
Thread-Index: AQHWS+HzVTYTKiLVr0O7dTomrubg4KjrWqJQgAAa/lCAAAJBEIAAAZjQ
Date:   Fri, 26 Jun 2020 22:25:25 +0000
Message-ID: <MN2PR21MB1453750B4B63CDF190F393399C930@MN2PR21MB1453.namprd21.prod.outlook.com>
References: <1593193685-74615-1-git-send-email-joseph.salisbury@microsoft.com>
 <MW2PR2101MB10520D5E1FDE45C5DF03D073D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <MN2PR21MB1453A27BD0EBE78E7ECA49C99C930@MN2PR21MB1453.namprd21.prod.outlook.com>
 <MW2PR2101MB1052837695100EF9B4BC9874D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB1052837695100EF9B4BC9874D7930@MW2PR2101MB1052.namprd21.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 15c6cdd2-b10d-42c5-188b-08d81a1fd2dc
x-ms-traffictypediagnostic: MN2PR21MB1502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1502FCAFE8768ADCC59BC6B49C930@MN2PR21MB1502.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kjtlW6Y9PFR+0UUkLe6J4Xw2rsrXduOVmE64GiPbbxYwl27VTUeV3DWDzRnDdiGELZtNWpLphT+t+idJRxyVO2rMtLRlP7L/HkA9+stXfF7ECl4P6PpH0PjIwVerFn+nUcTBau758cEYT+r3WL1IiAg0HjgMXxXcMZuE68+Tq4WzgV3v0FDTbOHseO2jCIDpV1G5q3bZz8xA1MP6Z9JOfCMPunYdc24H2CeaWNnP4T7VvLQk2G+sV9p9gmco9RRr61hcM/G2rzaoJuZHzjp5BxkARZiOnynlKKZnweUIm283M0YRqmbZztUOtri0R4DMac5Tuj1ja5EDqiz85W6ycg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1453.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(66556008)(71200400001)(66476007)(8936002)(8990500004)(52536014)(110136005)(5660300002)(82960400001)(82950400001)(66946007)(76116006)(66446008)(316002)(54906003)(86362001)(2906002)(53546011)(8676002)(6506007)(64756008)(4326008)(7696005)(478600001)(55016002)(9686003)(10290500003)(33656002)(83380400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mh20clUw7S+/XP4QnHayCXo9N+CBsUCuA4tSS2+78hAqLPxviS3tJPorFgewCJ1q0rCvUKgdLuRNy1MKBzmYydB8cUB2+ZM+0FOKO55Ov6PCFTbBpvD5l7Omh3uhQ96O+FbkLW7IXr4GQC3zIGXDIDxMmy8LBkbOYCcqRjcnjQWpoN1MLXrsiyuwhn8qvs/yLOwE/rLX2innSdKFMpvZngoQlkttfTUuBkmkfEJQw+uTcNcrD7NmMiqmEL+teCEwiQMbcmpMmaPxIG6O5ReK8nFR11CRCs4SNXXoRP5wnGhRVtDqWHKVjmJGzO1Ey7nEm3PsNy//TTy/kigOoiADTzOMSYLiwzsWSD2Vi2urDm/EgOibXa7uHWFD2C9uvhPC4PmzY/omOuSrEp+OgPvK4UI5zbQL3+X8/V9aZLXpeNkVJkVhUW5Ifmvsksd20e53WcACftPrMob0CkYMDN619i6eYHDkyjmSeewqhye8gBLRbcXosX2ZDbIaE4Tri7A3U3yEbVxLoFc+WqLmcMWDl4AYHDBkOjTR3HPWeOoKpVI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1453.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c6cdd2-b10d-42c5-188b-08d81a1fd2dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 22:25:25.5807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lb3ufSh26skuhL+zBV1zS4vwF5LvRpHdhgkFR8WGMUUWYhn4lWLNnsN26bnxOZ/K6HVDy0u4boogESipyuDHnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1502
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBNaWNoYWVsIEtlbGxleSA8bWlr
ZWxsZXlAbWljcm9zb2Z0LmNvbT4gDQpTZW50OiBGcmlkYXksIEp1bmUgMjYsIDIwMjAgNjoyNCBQ
TQ0KVG86IEpvc2VwaCBTYWxpc2J1cnkgPEpvc2VwaC5TYWxpc2J1cnlAbWljcm9zb2Z0LmNvbT47
IEtZIFNyaW5pdmFzYW4gPGt5c0BtaWNyb3NvZnQuY29tPjsgSGFpeWFuZyBaaGFuZyA8aGFpeWFu
Z3pAbWljcm9zb2Z0LmNvbT47IFN0ZXBoZW4gSGVtbWluZ2VyIDxzdGhlbW1pbkBtaWNyb3NvZnQu
Y29tPjsgc2FzaGFsQGtlcm5lbC5vcmc7IHdlaS5saXVAa2VybmVsLm9yZw0KQ2M6IGxpbnV4LWh5
cGVydkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJFOiBbUEFUQ0hdIERyaXZlcnM6IGh2OiBDaGFu
Z2UgZmxhZyB0byB3cml0ZSBsb2cgbGV2ZWwgaW4gcGFuaWMgbXNnIHRvIGZhbHNlDQoNCkZyb206
IEpvc2VwaCBTYWxpc2J1cnkgPEpvc2VwaC5TYWxpc2J1cnlAbWljcm9zb2Z0LmNvbT4gIFNlbnQ6
IEZyaWRheSwgSnVuZSAyNiwgMjAyMCAzOjE2IFBNDQo+IA0KPiBUaGFua3MgZm9yIHRoZSBmZWVk
YmFjaywgTWljaGFlbC4gIEknbGwgc2VuZCBhIHYyLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gSm9l
DQoNCkEgcXVpY2sgbm90ZTogIFRoZSBzdHlsZSBvbiB0aGUgTGludXgga2VybmVsIG1haWxpbmcg
bGlzdHMgaXMgdG8gYWx3YXlzIHJlcGx5IGlubGluZSwgYWZ0ZXIgdGhlIHRleHQgeW91IGFyZSBy
ZXBseWluZyB0by4gIFRoaXMgaXMgcXVpdGUgZGlmZmVyZW50IGZyb20gdGhlIHN0eWxlIHVzdWFs
bHkgdXNlZCBpbnNpZGUgTWljcm9zb2Z0LCB3aGljaCBpcyBjYWxsZWQgInRvcCBwb3N0aW5nIi4N
Cg0KTWljaGFlbA0KDQpBQ0ssIHRoYW5rcyENCg0KSm9lDQoNCj4gDQo+IA0KPiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWNoYWVsIEtlbGxleSA8bWlrZWxsZXlAbWljcm9z
b2Z0LmNvbT4NCj4gU2VudDogRnJpZGF5LCBKdW5lIDI2LCAyMDIwIDQ6NTMgUE0NCj4gVG86IEpv
c2VwaCBTYWxpc2J1cnkgPEpvc2VwaC5TYWxpc2J1cnlAbWljcm9zb2Z0LmNvbT47IEtZIFNyaW5p
dmFzYW4gDQo+IDxreXNAbWljcm9zb2Z0LmNvbT47IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1p
Y3Jvc29mdC5jb20+OyBTdGVwaGVuIA0KPiBIZW1taW5nZXIgPHN0aGVtbWluQG1pY3Jvc29mdC5j
b20+OyBzYXNoYWxAa2VybmVsLm9yZzsgDQo+IHdlaS5saXVAa2VybmVsLm9yZw0KPiBDYzogbGlu
dXgtaHlwZXJ2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
DQo+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUkU6IFtQQVRDSF0gRHJpdmVy
czogaHY6IENoYW5nZSBmbGFnIHRvIHdyaXRlIGxvZyBsZXZlbCBpbiANCj4gcGFuaWMgbXNnIHRv
IGZhbHNlDQo+IA0KPiBGcm9tOiBKb3NlcGggU2FsaXNidXJ5IDxqb3NlcGguc2FsaXNidXJ5QG1p
Y3Jvc29mdC5jb20+IFNlbnQ6IEZyaWRheSwgDQo+IEp1bmUgMjYsIDIwMjAgMTA6NDggQU0NCj4g
Pg0KPiA+IFdoZW4gdGhlIGtlcm5lbCBwYW5pY3MsIG9uZSBwYWdlIHdvcnRoIG9mIGttc2cgZGF0
YSBpcyB3cml0dGVuIHRvIGFuIA0KPiA+IGFsbG9jYXRlZCBwYWdlLiAgVGhlIEh5cGVydmlzb3Ig
aXMgbm90aWZpZWQgb2YgdGhlIHBhZ2UgYWRkcmVzcyANCj4gPiB0cm91Z2ggdGhlIE1TUi4gIFRo
aXMgcGFuaWMgaW5mb3JtYXRpb24gaXMgY29sbGVjdGVkIG9uIHRoZSBob3N0LiAgDQo+ID4gU2lu
Y2Ugd2UgYXJlIG9ubHkgY29sbGVjdGluZyBvbmUgcGFnZSBvZiBkYXRhLCB0aGUgZnVsbCBwYW5p
YyBtZXNzYWdlIG1heSBub3QgYmUgY29sbGVjdGVkLg0KPiA+DQo+ID4gRWFjaCBsaW5lIG9mIHRo
ZSBwYW5pYyBtZXNzYWdlIGlzIHByZWZpeGVkIHdpdGggdGhlIGxvZyBsZXZlbCBvZiB0aGF0DQo+
ID4gcGFydGljdWxhciBtZXNzYWdlIGluIHRoZSBmb3JtIDxOPiwgd2hlcmUgTiBpcyB0aGUgbG9n
IGxldmVsLiAgIFRoZSB0eXBpY2FsDQo+ID4gNCBLYnl0ZXMgY29udGFpbnMgYW55d2hlcmUgZnJv
bSA1MCB0byAxMDAgbGluZXMgd2l0aCB0aGF0IGxvZyBsZXZlbCBwcmVmaXguDQo+ID4NCj4gPiBo
dl9kbXNnX2R1bXAoKSBtYWtlcyBhIGNhbGwgdG8ga21zZ19kdW1wX2dldF9idWZmZXIoKS4gIFRo
ZSBzZWNvbmQgDQo+ID4gYXJndW1lbnQgaW4gdGhlIGNhbGwgaXMgYSBib29sIGRlc2NyaWJlZCBh
czog4oCYQHN5c2xvZzogaW5jbHVkZSB0aGUg4oCcPDQ+4oCdIFByZWZpeGVz4oCZLg0KPiA+DQo+
ID4gV2l0aCB0aGlzIGNoYW5nZSwgd2Ugd2lsbCBub3Qgd3JpdGUgdGhlIGxvZyBsZXZlbCB0byB0
aGUgYWxsb2NhdGVkIA0KPiA+IHBhZ2UuICBUaGlzIHdpbGwgcHJvdmlkZSBhZGRpdGlvbmFsIHJv
b20gaW4gdGhlIGFsbG9jYXRlZCBwYWdlIGZvciANCj4gPiBtb3JlIGluZm9ybWF0aXZlIHBhbmlj
IGluZm9ybWF0aW9uLg0KPiANCj4gTGV0IG1lIHN1Z2dlc3QgdGlnaHRlbmluZyB0aGUgY29tbWl0
IG1lc3NhZ2UgYSBiaXQsIHdpdGggZm9jdXMgb24gdGhlICJ3aGF0Ig0KPiBhbmQgIndoeSIgcmF0
aGVyIHRoYW4gdGhlIGRldGFpbHMgb2YgdGhlIGNvZGUgY2hhbmdlLiAgQWxzbyB1c2UgDQo+IGlt
cGVyYXRpdmUgdm9pY2UgcGVyIHRoZSBMaW51eCBrZXJuZWwgZ3VpZGVsaW5lczoNCj4gDQo+IFdo
ZW4gdGhlIGtlcm5lbCBwYW5pY3MsIG9uZSBwYWdlIG9mIGttc2cgZGF0YSBtYXkgYmUgY29sbGVj
dGVkIGFuZCANCj4gc2VudCB0byBIeXBlci1WIHRvIGFpZCBpbiBkaWFnbm9zaW5nIHRoZSBmYWls
dXJlLiAgVGhlIGNvbGxlY3RlZCBrbXNnIA0KPiBkYXRhIHR5cGljYWxseSBjb250YWlucyA1MCB0
byAxMDAgbGluZXMsIGVhY2ggb2Ygd2hpY2ggaGFzIGEgbG9nIGxldmVsIA0KPiBwcmVmaXggdGhh
dCBpc24ndCB2ZXJ5IHVzZWZ1bCBmcm9tIGEgZGlhZ25vc3RpYyBzdGFuZHBvaW50LiAgU28gdGVs
bA0KPiBrbXNnX2R1bXBfZ2V0X2J1ZmZlcigpIHRvIG5vdCBpbmNsdWRlIHRoZSBsb2cgbGV2ZWws
IGVuYWJsaW5nIG1vcmUgDQo+IGluZm9ybWF0aW9uIHRoYXQgKmlzKiB1c2VmdWwgdG8gZml0IGlu
IHRoZSBwYWdlLg0KPiANCj4gPg0KPiA+IFJlcXVlc3RpbmcgaW4gc3RhYmxlIGtlcm5lbHMsIHNp
bmNlIG1hbnkga2VybmVscyBydW5uaW5nIGluIA0KPiA+IHByb2R1Y3Rpb24gYXJlIHN0YWJsZSBy
ZWxlYXNlcy4NCj4gPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gU2lnbmVk
LW9mZi1ieTogSm9zZXBoIFNhbGlzYnVyeSA8am9zZXBoLnNhbGlzYnVyeUBtaWNyb3NvZnQuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2h2L3ZtYnVzX2Rydi5jIHwgMiArLQ0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2h2L3ZtYnVzX2Rydi5jIGIvZHJpdmVycy9odi92bWJ1c19kcnYuYyBp
bmRleA0KPiA+IDkxNDdlZTlkNWY3ZC4uZDY5ZjRlZmEzNzE5IDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvaHYvdm1idXNfZHJ2LmMNCj4gPiArKysgYi9kcml2ZXJzL2h2L3ZtYnVzX2Rydi5jDQo+
ID4gQEAgLTEzNjgsNyArMTM2OCw3IEBAIHN0YXRpYyB2b2lkIGh2X2ttc2dfZHVtcChzdHJ1Y3Qg
a21zZ19kdW1wZXIgKmR1bXBlciwNCj4gPiAgCSAqIFdyaXRlIGR1bXAgY29udGVudHMgdG8gdGhl
IHBhZ2UuIE5vIG5lZWQgdG8gc3luY2hyb25pemU7IHBhbmljIHNob3VsZA0KPiA+ICAJICogYmUg
c2luZ2xlLXRocmVhZGVkLg0KPiA+ICAJICovDQo+ID4gLQlrbXNnX2R1bXBfZ2V0X2J1ZmZlcihk
dW1wZXIsIHRydWUsIGh2X3BhbmljX3BhZ2UsIEhWX0hZUF9QQUdFX1NJWkUsDQo+ID4gKwlrbXNn
X2R1bXBfZ2V0X2J1ZmZlcihkdW1wZXIsIGZhbHNlLCBodl9wYW5pY19wYWdlLCANCj4gPiArSFZf
SFlQX1BBR0VfU0laRSwNCj4gPiAgCQkJICAgICAmYnl0ZXNfd3JpdHRlbik7DQo+ID4gIAlpZiAo
Ynl0ZXNfd3JpdHRlbikNCj4gPiAgCQloeXBlcnZfcmVwb3J0X3BhbmljX21zZyhwYW5pY19wYSwg
Ynl0ZXNfd3JpdHRlbik7DQo+ID4gLS0NCj4gPiAyLjE3LjENCj4gDQo+IFdpdGggdGhlIGNvbW1p
dCBtZXNzYWdlIGNoYW5nZXMsDQo+IA0KPiBSZXZpZXdlZC1ieTogTWljaGFlbCBLZWxsZXkgPG1p
a2VsbGV5QG1pY3Jvc29mdC5jb20+DQo=
