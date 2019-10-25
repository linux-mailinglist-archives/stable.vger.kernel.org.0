Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8050CE437F
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 08:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733136AbfJYGTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 02:19:01 -0400
Received: from mail-eopbgr750085.outbound.protection.outlook.com ([40.107.75.85]:60125
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbfJYGTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 02:19:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXwwF9Z4/QwGHEMo//WlCkMv9i9zLUnYW0zPaPAVCwmdPdyG4P9llCb+P+C5VhfZn9PhF8xGLSq9Evzq/lUqSVP9hXE5TSbPpXlv+ZSQgODU2K1ewNalrWEZ8EckClK9D0Q3zmpAW8DnkQ+KvwniI3z3AYp8hM2J0J0Kpcgm0biT6fVE1V5q+kaQDacOxfe4g+qfTY9bHpSdyAkXmqydc6iRK2hT4U26CcfD49P+a1cYqAlXtnXDyrYxLwS1ycy6LcCXG+h4O6hu+llzKPNimSN4KzBZCe4JA3hBuYbsoEVIGYFYJ94As7p07bog5qOy3VfmjAF5Yam3AgK/jrc5VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJzlKuRkehvksagqzdzePl2l3ehTLgtsvIYUxFq173A=;
 b=EmsllY7fJMcV1Crs9t88j3imQOneOVRBmEMVVzPMVgqvo1NTwGVjhlpPzGIWWkNJr9rBl4gzMwDJpNU2e1Cr/L3GNl+3hVfHV+1lTUPhjtJD8CHO1anGQR4yNM8kMsU0k2qnyTfi3S5FwAmIVxryDTedHUGyMEUwRFBPr9cMy4YlGWq1c+39RuqJC7ik8MemF2dAUr4aDypSKPfoaxXDRc2rEcHtFCaHSRE+Jz/iUDqWiYfhvPbobk+xoy5uJFTjY1Hh5Ai2z/WgqEGACAP8GEBpADVqqsazg3vmuP0KMPAlps5ko0lkproYaSAauYn3fPTDj65+ggP5AFE7euL1ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJzlKuRkehvksagqzdzePl2l3ehTLgtsvIYUxFq173A=;
 b=a0YitRH10UBvLl3xprhkcafKU6AI+79DSX3p8DV4GMImHccZB5x/c7eVY1EdnShumzreSoIvZghwA7KD/5tCUSlTGrovD8HEBSv9PcjD3K34VPRYYpmF+rFw2QIzGApP8C6wDyZ04BG199TpteRYKv2p/dptjDRCeFwEBwx0eU4=
Received: from BN8PR05MB6193.namprd05.prod.outlook.com (20.178.210.214) by
 BN8PR05MB6050.namprd05.prod.outlook.com (20.178.209.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.18; Fri, 25 Oct 2019 06:18:58 +0000
Received: from BN8PR05MB6193.namprd05.prod.outlook.com
 ([fe80::9c5d:367e:9e87:b0d7]) by BN8PR05MB6193.namprd05.prod.outlook.com
 ([fe80::9c5d:367e:9e87:b0d7%6]) with mapi id 15.20.2387.025; Fri, 25 Oct 2019
 06:18:57 +0000
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
Thread-Index: AQHVfffGKc9CRR2dekieWi7B72DxaadSSqyAgA0lZICAC+hNgA==
Date:   Fri, 25 Oct 2019 06:18:57 +0000
Message-ID: <0E5175FB-7058-4211-9AA4-9D5E2F6A30B9@vmware.com>
References: <1570581863-12090-1-git-send-email-akaher@vmware.com>
 <1570581863-12090-7-git-send-email-akaher@vmware.com>
 <f899be71-4bc0-d07b-f650-d85a335cdebb@suse.cz>
 <BF0587E3-D104-4DB2-B972-9BC4FD4CA014@vmware.com>
In-Reply-To: <BF0587E3-D104-4DB2-B972-9BC4FD4CA014@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1ce706d-31f9-4102-3ffe-08d75913383c
x-ms-traffictypediagnostic: BN8PR05MB6050:|BN8PR05MB6050:|BN8PR05MB6050:
x-ms-exchange-purlcount: 2
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR05MB6050461347E270B12A28D10DBB650@BN8PR05MB6050.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(199004)(189003)(14444005)(6506007)(66476007)(486006)(6436002)(66446008)(99286004)(76176011)(476003)(66066001)(64756008)(66946007)(6486002)(229853002)(66556008)(54906003)(110136005)(76116006)(71200400001)(316002)(91956017)(5660300002)(2906002)(71190400001)(102836004)(81156014)(81166006)(7736002)(2616005)(966005)(11346002)(26005)(256004)(6512007)(86362001)(3846002)(36756003)(6116002)(6246003)(305945005)(7416002)(8936002)(6306002)(25786009)(186003)(33656002)(478600001)(446003)(4326008)(2501003)(14454004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR05MB6050;H:BN8PR05MB6193.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U9UmCfeEePulMQRQNRNE5ehd+l6GRrTJra1FWQhsHHEdZbQAxGfaLG2wAEw0YBg5UYuzARBE3zLzBjzz53XNb1ZBXLpPgpomHa9K1FrIev/BmH5DMsVONi4LDJARyjq2afGlazVM+aL9HIZIbWxtkBgoujt3LM6/fjU2M/Bz/yTQccT7Y2V7FIoM/nqDJBVi7ayca+pY1qhnxdnLejbGAGmutfFMxDf0v9pJC3CtqL9DTEbLdnXrFSv8V6/Yt7hsfX+vzNE4inxEnpd3nxXpogyaB3V1BIUBZQr9PXDIK/vFpeDWkR41QAR/JqnJx7l73lDpNn+pgMFOUjDV2UtbJqaVP/93d11OpBQOEaRt+CXi1mbU9e4gjIw0lCum5JtB4//QfwuhgLMiWYxCYGysik0a866aUO8QUIgFM6p5O/t0NtWBixhI4HIoHcX5ZlZqxrxkREbFx7Ye4pCrKS6qyrupzqmx3y0uApyi+hIEATE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAFA460EC5D47E4BB66F7374ABEAE4DB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ce706d-31f9-4102-3ffe-08d75913383c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 06:18:57.5629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZti2L57uUDzuWyEmJBZh59+fFJ0BEzNB5xLw4rjKPZiJl+8rYfmf3bpTHrGNgchodu8ScMpoOMr+5XkcSovdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR05MB6050
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDE3LzEwLzE5LCA5OjU4IFBNLCAiQWpheSBLYWhlciIgPGFrYWhlckB2bXdhcmUu
Y29tPiB3cm90ZToNCiAgICANCj4gPiBUaGlzIHNlZW1zIHRvIGhhdmUgdGhlIHNhbWUgaXNzdWUg
YXMgdGhlIDQuOSBzdGFibGUgdmVyc2lvbiBbMV0sIGluIG5vdA0KPiA+IHRvdWNoaW5nIHRoZSBh
cmNoLXNwZWNpZmljIGd1cC5jIHZhcmlhbnRzLg0KPiA+ICAgIA0KPiA+IFsxXQ0KPiA+IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvNjY1MDMyM2YtZGJjOS1mMDY5LTAwMGItZjZiMGY5NDFh
MDY1QHN1c2UuY3ovDQo+ICAgIA0KPiBUaGFua3MgVmxhc3RpbWlsIGZvciBoaWdobGlnaHRpbmcg
dGhpcyBoZXJlLg0KPiANCj4gWWVzLCBhcmNoLXNwZWNpZmljIGd1cC5jIHZhcmlhbnRzIGFsc28g
bmVlZCB0byBoYW5kbGUgbm90IG9ubHkgZm9yIDQuNC55LA0KPiBob3dldmVyIGl0IHNob3VsZCBi
ZSBoYW5kbGVkIHRpbGwgNC4xOS55LiBJIGJlbGlldmUgaXQncyBiZXR0ZXIgdG8gc3RhcnQNCj4g
ZnJvbSA0LjE5LnkgYW5kIHRoZW4gYmFja3BvcnQgdGhvc2UgY2hhbmdlcyB0aWxsIDQuNC55Lg0K
PiAgICANCj4gQWZmZWN0ZWQgYXJlYXMgb2YgZ3VwLmMgKHdoZXJlIHBhZ2UtPmNvdW50IGhhdmUg
YmVlbiB1c2VkKSBhcmU6DQo+ICMxOiBnZXRfcGFnZSgpIHVzZWQgaW4gdGhlc2UgZmlsZXMgYW5k
IHRoaXMgaXMgc2FmZSBhcw0KPiAgICAgICAgaXQncyBkZWZpbmVkIGluIG1tLmggKGhlcmUgaXQn
cyBhbHJlYWR5IHRha2VuIGNhcmUgb2YpDQo+ICMyOiBnZXRfaGVhZF9wYWdlX211bHRpcGxlKCkg
aGFzIGZvbGxvd2luZzoNCj4gICAgICAgICAgICAgICBWTV9CVUdfT05fUEFHRShwYWdlX2NvdW50
KHBhZ2UpID09IDAsIHBhZ2UpOw0KPiAgICAgICAgICBOZWVkIHRvIGNoYW5nZSB0aGlzIHRvOg0K
PiAgICAgICAgICAgICAgIFZNX0JVR19PTl9QQUdFKHBhZ2VfcmVmX3plcm9fb3JfY2xvc2VfdG9f
b3ZlcmZsb3cocGFnZSksIHBhZ2UpOw0KPiAjMzogU29tZSBvZiB0aGUgZmlsZXMgaGF2ZSB1c2Vk
IHBhZ2VfY2FjaGVfZ2V0X3NwZWN1bGF0aXZlKCksDQo+ICAgICAgICBwYWdlX2NhY2hlX2FkZF9z
cGVjdWxhdGl2ZSgpIHdpdGggY29tYmluYXRpb24gb2YgY29tcG91bmRfaGVhZCgpLA0KPiAgICAg
ICAgdGhpcyBzY2VuYXJpbyBuZWVkcyB0byBiZSBoYW5kbGVkIGFzIGl0IHdhcyBoYW5kbGVkIGhl
cmU6DQo+ICAgICAgICAgICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvc3RhYmxlLzE1NzA1ODE4
NjMtMTIwOTAtNy1naXQtc2VuZC1lbWFpbC1ha2FoZXJAdm13YXJlLmNvbS8NCj4gICAgDQo+IFBs
ZWFzZSBzaGFyZSB3aXRoIG1lIGFueSBzdWdnZXN0aW9ucyBvciBwYXRjaGVzIGlmIHlvdSBoYXZl
IGFscmVhZHkgIA0KPiB3b3JrZWQgb24gdGhpcy4NCj4gICAgDQo+IENvdWxkIHdlIGhhbmRsZSBh
cmNoLXNwZWNpZmljIGd1cC5jIGluIGRpZmZlcmVudCBwYXRjaCBzZXRzIGFuZCANCj4gbGV0IHRo
ZXNlIHBhdGNoZXMgdG8gbWVyZ2UgdG8gNC40Lnk/DQogIA0KVmxhc3RpbWlsLCBwbGVhc2Ugc3Vn
Z2VzdCBpZiBpdCdzIGZpbmUgdG8gbWVyZ2UgdGhlc2UgcGF0Y2hlcyB0byA0LjQueQ0KYW5kIGhh
bmRsZSBhcmNoLXNwZWNpZmljIGd1cC5jIGluIGRpZmZlcmVudCBwYXRjaCBzZXRzIHN0YXJ0cyBm
cm9tIDQuMTkueSwNCnRoZW4gYmFja3BvcnQgYWxsIHRoZSB3YXkgdG8gNC40LnkuIA0KDQpHcmVn
LCBhbnkgc3VnZ2VzdGlvbiBmcm9tIHlvdXIgc2lkZS4NCg0KPiAgICAtIEFqYXkNCiAgICANCiAg
ICANCiAgICANCg0K
