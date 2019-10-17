Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11354DB257
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 18:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfJQQ3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 12:29:02 -0400
Received: from mail-eopbgr810081.outbound.protection.outlook.com ([40.107.81.81]:28000
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392968AbfJQQ3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 12:29:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiDZgM+jZUQzqe3p1ykxmkdNHwobsLyO/PMKNskJO9t8ZjA7nonCFkATtoVMJk2hhbhHeLOAP9aKNqojt1GSwGs5DTarcXjPKdbUxgOKBARNBMXminYTnxQxs+faMZ8kqJyc/PX/u4kA0UFC9UExVoRx/HZsXCg9NHn/1CKeCwTfJ21Q653H+tGSWWoO9/je8O0T4Orhxg/6vSdTCJ+VC0s77TnjuCodRoopKaOo8gcNLzE1TKv4aNRlUc7OXBR2uziqutyyjj+FKfd5bo3LZHwBYGL72+VvQrPNe7bbpRIfs/5PZ1e7Olx4y1Hnfhg57I2BP9PV7KxJ/6dLghcQaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IOvRIRGh3Bl9lOTZKpGMLh5eFo5cLcEhWhin3LkuYs=;
 b=mx6W1/iRBfq3h09IGzQuog9M9MFEe1nKQRXoIlifPCb+qdkVQI3tErcKUe6u5Q06b3jv1yGo9rwWNwN1FlhSKj4fiZ+5NkDxl8Yp7KytJsvIOFfZLIzMGboGf0V8IY1OL0q6PKTZnCI6jYwdXTOylH8zOdr311xh7zHuctlnhm2HrwMZYaRAJQ3CG+xleNb9a+IslNwx5vfgor8Z97lsmxnaqFaLvXGYYqGIYAtpPUaSUAD2ngbX/JTdIntBOvoyJrEZU1/EeGTBxYbk8C/oby8vcNdYOCqfSlXBzAz5J1qjY3wIJsOxo0mI6/+PQaNLZ+3uK0+V5Kml9cCArPWrmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IOvRIRGh3Bl9lOTZKpGMLh5eFo5cLcEhWhin3LkuYs=;
 b=O8UQs3OCsj0YIfI04XJ0sMCPfFdkFWMTTRGfDTAZNiSQcK+0O8sCfGZurw7chdOi7+j3oRAmX30EosubysH5lICtI38qVKDZbzWoN4boySxX4avtPId5GtbWySZBGaeZ2JAJGweVhYuyKdapuV9zpL8TJFrGrI0h8q6PgIRSRNI=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6464.namprd05.prod.outlook.com (20.178.246.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.16; Thu, 17 Oct 2019 16:28:56 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f9be:d2d8:1003:99b5]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f9be:d2d8:1003:99b5%6]) with mapi id 15.20.2347.021; Thu, 17 Oct 2019
 16:28:56 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "punit.agrawal@arm.com" <punit.agrawal@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mszeredi@redhat.com" <mszeredi@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Steven Rostedt <srostedt@vmware.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v2 6/8] mm: prevent get_user_pages() from overflowing page
 refcount
Thread-Topic: [PATCH v2 6/8] mm: prevent get_user_pages() from overflowing
 page refcount
Thread-Index: AQHVfffGKc9CRR2dekieWi7B72DxaadSSqyAgA0lZIA=
Date:   Thu, 17 Oct 2019 16:28:56 +0000
Message-ID: <BF0587E3-D104-4DB2-B972-9BC4FD4CA014@vmware.com>
References: <1570581863-12090-1-git-send-email-akaher@vmware.com>
 <1570581863-12090-7-git-send-email-akaher@vmware.com>
 <f899be71-4bc0-d07b-f650-d85a335cdebb@suse.cz>
In-Reply-To: <f899be71-4bc0-d07b-f650-d85a335cdebb@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [2405:204:549c:9b0:157a:adf0:3cf7:b301]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 513f87e1-ea4d-4795-d702-08d7531f1b79
x-ms-traffictypediagnostic: MN2PR05MB6464:|MN2PR05MB6464:|MN2PR05MB6464:
x-ms-exchange-purlcount: 2
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB64641D91921390EA8EFC8BDDBB6D0@MN2PR05MB6464.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(199004)(189003)(66446008)(478600001)(6436002)(14454004)(25786009)(71190400001)(71200400001)(102836004)(966005)(2501003)(99286004)(6512007)(186003)(6486002)(8676002)(86362001)(8936002)(14444005)(81166006)(229853002)(81156014)(76176011)(6306002)(33656002)(5660300002)(256004)(11346002)(2616005)(476003)(316002)(64756008)(66556008)(446003)(305945005)(4326008)(91956017)(76116006)(66476007)(6506007)(110136005)(54906003)(486006)(66946007)(6246003)(7736002)(7416002)(6116002)(2906002)(46003)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6464;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nAdprhsS138QtDDDkafsVykjYk77snaXupS/KIR+mseVAiTfMB+5jYns5YrenXsB5rDKvwof3VIJWVAhYGy04Ay4bDgsb3Mi2yhHjyDqJTuPivHDh0l1LA5VMn11pZ/UDjOxGsBuHzjmODWyHe0w4pt8vla/VGeoR/k7mO6irRWJoPm65Qr5t86GEeXT11owk+oS1bPA/dLkdHg3gQ3JhVbBVSjQ42oPl+mDDhHvMRNMXWH4+PwRgYS0G8kXjchAFwaFugi1va6r6DeJneB5WAn7w2I+LRlMsyDtFhUI/er66f43wWTg0LZmZLGnxSZEk2NAILufdXlGVPfMpcxC1jKNO+r65l3AOtTE8h5ph6HL7A9j9FvSrUlQg1l8WKGKTfFz49Piy3fNEIhUl1qJ6iSzMPMzu2t2na0KQRiBnsO5bgYYDxFteZ7KpzoBPWWRsvt8vPvxMMiRZ0BjzaLl/g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD83800ADC0A5B448D372E251057C55B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 513f87e1-ea4d-4795-d702-08d7531f1b79
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 16:28:56.5166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PtfFgwfZeoqoCqJLxuv3Tgabwx3ThrmFhK+hVl6vN3QRHJDdr3/KF3dxzLkZqrgM9YAeLMKaASyIjbN/AcxbHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6464
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQrvu79PbiAwOS8xMC8xOSwgNjo0MyBQTSwgIlZsYXN0aW1pbCBCYWJrYSIgPHZiYWJrYUBzdXNl
LmN6PiB3cm90ZToNCg0KPj4gUmVwb3J0ZWQtYnk6IEphbm4gSG9ybiA8amFubmhAZ29vZ2xlLmNv
bT4NCj4+IEFja2VkLWJ5OiBNYXR0aGV3IFdpbGNveCA8d2lsbHlAaW5mcmFkZWFkLm9yZz4NCj4+
IENjOiBzdGFibGVAa2VybmVsLm9yZw0KPj4gU2lnbmVkLW9mZi1ieTogTGludXMgVG9ydmFsZHMg
PHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPj4gWyA0LjQueSBiYWNrcG9ydCBub3Rl
czoNCj4+ICAgQWpheTogQWRkZWQgbG9jYWwgdmFyaWFibGUgJ2Vycicgd2l0aC1pbiBmb2xsb3df
aHVnZXRsYl9wYWdlKCkNCj4+ICAgICAgICAgZnJvbSAyYmU3Y2ZlZDk5NWUsIHRvIHJlc29sdmUg
Y29tcGlsYXRpb24gZXJyb3INCj4+ICAgU3JpdmF0c2E6IFJlcGxhY2VkIGNhbGwgdG8gZ2V0X3Bh
Z2VfZm9sbCgpIHdpdGggdHJ5X2dldF9wYWdlX2ZvbGwoKSBdDQo+PiBTaWduZWQtb2ZmLWJ5OiBT
cml2YXRzYSBTLiBCaGF0IChWTXdhcmUpIDxzcml2YXRzYUBjc2FpbC5taXQuZWR1Pg0KPj4gU2ln
bmVkLW9mZi1ieTogQWpheSBLYWhlciA8YWthaGVyQHZtd2FyZS5jb20+DQo+PiAtLS0NCj4+ICBt
bS9ndXAuYyAgICAgfCA0MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
LS0tDQo+PiAgbW0vaHVnZXRsYi5jIHwgMTYgKysrKysrKysrKysrKysrLQ0KPj4gIDIgZmlsZXMg
Y2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+ICAgIA0KPiBUaGlz
IHNlZW1zIHRvIGhhdmUgdGhlIHNhbWUgaXNzdWUgYXMgdGhlIDQuOSBzdGFibGUgdmVyc2lvbiBb
MV0sIGluIG5vdA0KPiB0b3VjaGluZyB0aGUgYXJjaC1zcGVjaWZpYyBndXAuYyB2YXJpYW50cy4N
Cj4gICAgDQo+IFsxXQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzY2NTAzMjNmLWRi
YzktZjA2OS0wMDBiLWY2YjBmOTQxYTA2NUBzdXNlLmN6Lw0KDQpUaGFua3MgVmxhc3RpbWlsIGZv
ciBoaWdobGlnaHRpbmcgdGhpcyBoZXJlLg0KDQpZZXMsIGFyY2gtc3BlY2lmaWMgZ3VwLmMgdmFy
aWFudHMgYWxzbyBuZWVkIHRvIGhhbmRsZSBub3Qgb25seSBmb3IgNC40LnksDQpob3dldmVyIGl0
IHNob3VsZCBiZSBoYW5kbGVkIHRpbGwgNC4xOS55LiBJIGJlbGlldmUgaXQncyBiZXR0ZXIgdG8g
c3RhcnQNCmZyb20gNC4xOS55IGFuZCB0aGVuIGJhY2twb3J0IHRob3NlIGNoYW5nZXMgdGlsbCA0
LjQueS4NCg0KQWZmZWN0ZWQgYXJlYXMgb2YgZ3VwLmMgKHdoZXJlIHBhZ2UtPmNvdW50IGhhdmUg
YmVlbiB1c2VkKSBhcmU6DQojMTogZ2V0X3BhZ2UoKSB1c2VkIGluIHRoZXNlIGZpbGVzIGFuZCB0
aGlzIGlzIHNhZmUgYXMNCiAgICAgICBpdCdzIGRlZmluZWQgaW4gbW0uaCAoaGVyZSBpdCdzIGFs
cmVhZHkgdGFrZW4gY2FyZSBvZikNCiMyOiBnZXRfaGVhZF9wYWdlX211bHRpcGxlKCkgaGFzIGZv
bGxvd2luZzoNCiAgICAgICAgICAgICAgIFZNX0JVR19PTl9QQUdFKHBhZ2VfY291bnQocGFnZSkg
PT0gMCwgcGFnZSk7DQogICAgICAgICAgIE5lZWQgdG8gY2hhbmdlIHRoaXMgdG86DQogICAgICAg
ICAgICAgICBWTV9CVUdfT05fUEFHRShwYWdlX3JlZl96ZXJvX29yX2Nsb3NlX3RvX292ZXJmbG93
KHBhZ2UpLCBwYWdlKTsNCiMzOiBTb21lIG9mIHRoZSBmaWxlcyBoYXZlIHVzZWQgcGFnZV9jYWNo
ZV9nZXRfc3BlY3VsYXRpdmUoKSwNCiAgICAgICBwYWdlX2NhY2hlX2FkZF9zcGVjdWxhdGl2ZSgp
IHdpdGggY29tYmluYXRpb24gb2YgY29tcG91bmRfaGVhZCgpLA0KICAgICAgIHRoaXMgc2NlbmFy
aW8gbmVlZHMgdG8gYmUgaGFuZGxlZCBhcyBpdCB3YXMgaGFuZGxlZCBoZXJlOg0KICAgICAgICAg
ICBodHRwczovL2xvcmUua2VybmVsLm9yZy9zdGFibGUvMTU3MDU4MTg2My0xMjA5MC03LWdpdC1z
ZW5kLWVtYWlsLWFrYWhlckB2bXdhcmUuY29tLw0KDQpQbGVhc2Ugc2hhcmUgd2l0aCBtZSBhbnkg
c3VnZ2VzdGlvbnMgb3IgcGF0Y2hlcyBpZiB5b3UgaGF2ZSBhbHJlYWR5ICANCndvcmtlZCBvbiB0
aGlzLg0KDQpDb3VsZCB3ZSBoYW5kbGUgYXJjaC1zcGVjaWZpYyBndXAuYyBpbiBkaWZmZXJlbnQg
cGF0Y2ggc2V0cyBhbmQgDQpsZXQgdGhlc2UgcGF0Y2hlcyB0byBtZXJnZSB0byA0LjQueT8NCg0K
LSBBamF5DQoNCg0K
