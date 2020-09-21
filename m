Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F48272BBB
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgIUQXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:23:03 -0400
Received: from alln-iport-1.cisco.com ([173.37.142.88]:27702 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIUQXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 12:23:03 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 12:23:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3450; q=dns/txt; s=iport;
  t=1600705382; x=1601914982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NmOtbBpix8eOoFyTvOkc2RlSbKODp0NjLbu6IbOii7o=;
  b=l+AGU1XeahDNbmz9itkyQLT6U8Q9+x7MUb9pHTCflf8ZVCWM1ONLnPVk
   IDGIgRWvj5skKBfXmlznEyTvRI61jly1DdCVkELipd/RayYyr84gdV2ta
   +t/68m8YnNTE9kLecEzxUMD1FwhQPh+fzptNmtbcxPr7dZVqIvICjh7Ix
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ah07ITh+qxyJdI/9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+7ZRCN5u9qhV+PVoLeuLpIiOvT5qbnX2FIoZOMq2sLf5EEUR?=
 =?us-ascii?q?gZwd4XkAotDI/gawX7IffmYjZ8EJFEU1lorHKhNkFVXs35Yg6arni79zVHHB?=
 =?us-ascii?q?L5OEJ8Lfj0HYiHicOx2qiy9pTfbh8OiiC6ZOZ5LQ69qkPascxFjA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DJBQA80Whf/5NdJa1fHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgU+BUlEHcFkvLIQ6g0YDjXiYdIFCgREDVQsBAQENAQElCAI?=
 =?us-ascii?q?EAQGESwIXghQCJDgTAgMBAQsBAQUBAQECAQYEbYVcAQuFcgEBAQECARIREQw?=
 =?us-ascii?q?BATcBDwIBCBUDAgImAgICMBQBEAIEDgUigwWCSwMOIAEOqT4CgTmIYXaBMoM?=
 =?us-ascii?q?BAQEFgTMBg3IYghAJFHoqgnGDaYZSG4FBP4NsNT6ECAESASABF4MAgmCSdgE?=
 =?us-ascii?q?8hyObZ3UKgmeIdpFWIYQznE6Se4Nyhm+VGwIEAgQFAg4BAQWBayNncHAVgyQ?=
 =?us-ascii?q?JCj0XAg2OHwwXg06FFIVCdAIBNAIGCgEBAwl8jWMBAQ?=
X-IronPort-AV: E=Sophos;i="5.77,287,1596499200"; 
   d="scan'208";a="546017014"
Received: from rcdn-core-11.cisco.com ([173.37.93.147])
  by alln-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Sep 2020 16:15:55 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by rcdn-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id 08LGFtx0032229
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 21 Sep 2020 16:15:55 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 11:15:53 -0500
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 11:15:53 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 21 Sep 2020 11:15:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgaXnpn3xyX+KUjTNfUMC0VARGVmpD1qORBLVYrtEH0UZ1sF0T42HlzDLVTs0RMiPW+8p3ZKB8CoO1xmD0nZ/mLOSIWw0qE1gsBMZmZHf2Rws42cQlTLSaTR5kIJdcKkbrEZ8Ef6tctVzSVGOR7XWcxCO+Vj9jYS5PybZrYzK2p69O1kA29cgtGsH5pAlf5kXP/Xn0ZB44MzqrIcL13pYzzYkB2GqyN32U80ZZCkhJH/r9a+aqs1iSNFnDZdZOL3YZxIiUG+mpg2Rx8YphS1X2vyBH/Q+mWh92OO+pyJys372Ymq8LtIXiOTBgZXWS0IIgo6Lq93ulJuCnZEg21Lpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmOtbBpix8eOoFyTvOkc2RlSbKODp0NjLbu6IbOii7o=;
 b=F3wmRn1TDynwl3lhTgYnXJoltM5CmHXczicgx/t8BBFNDt64ByWDxSrF6mhGSIYHOjVcVIxYXpHwX7S/aQexJ65DvwoLRAtWzcH31sszGgMV3K7NMK/APAGqy6V33HIR2dIF7Hp0mKjr5S0bJPiV345QGiuh4IvraVXmhO/VEZc6llkPA7mQ6pUvag7mxrs+5vZ1SiHFOY9v9MWckvQfOuyPXDTfSJVPLvgCQcdvceWLSsMLpOhWO5UWeRuuDbcz2GisR0PYDHLBxdbBjqVwVGj/FbTvI8aM5vL+rDeHFv3FYzlyw5vIeWejnDRo/yylATOn7+MYcRAaUxNeI/2qmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmOtbBpix8eOoFyTvOkc2RlSbKODp0NjLbu6IbOii7o=;
 b=cuXxvqZeJQnGqmDrm4zFlrF3eFGC8E0IxPwCTd98yRB/nJ2jMeO9NCM8bUP0FloWrU8bA/opREMNnTnxoKdFi98eDdnkilaBsqsZYICVNipXH11YvXaphtOLg01VWpUxaTbbY+3d0YWnJZmx14cg6DOyXqyMguvLtATfqzoZGWk=
Received: from BY5PR11MB4182.namprd11.prod.outlook.com (2603:10b6:a03:183::10)
 by BY5PR11MB4387.namprd11.prod.outlook.com (2603:10b6:a03:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 16:15:51 +0000
Received: from BY5PR11MB4182.namprd11.prod.outlook.com
 ([fe80::1d4e:2269:63d7:f2d6]) by BY5PR11MB4182.namprd11.prod.outlook.com
 ([fe80::1d4e:2269:63d7:f2d6%6]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 16:15:51 +0000
From:   "Julius Hemanth Pitti (jpitti)" <jpitti@cisco.com>
To:     "greg@kroah.com" <greg@kroah.com>
CC:     "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xlpang@linux.alibaba.com" <xlpang@linux.alibaba.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "ktkhai@virtuozzo.com" <ktkhai@virtuozzo.com>
Subject: Re: [PATCH stable v5.8] mm: memcg: fix memcg reclaim soft lockup
Thread-Topic: [PATCH stable v5.8] mm: memcg: fix memcg reclaim soft lockup
Thread-Index: AQHWjVnICTJ+UtCgPE2sSYUp2ZCdyqlzSTGAgAABDAA=
Date:   Mon, 21 Sep 2020 16:15:51 +0000
Message-ID: <9dd7b7a8225a90019f74eb303b1f269d85628e94.camel@cisco.com>
References: <20200918011913.57159-1-jpitti@cisco.com>
         <20200921161205.GC1096614@kroah.com>
In-Reply-To: <20200921161205.GC1096614@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: kroah.com; dkim=none (message not signed)
 header.d=none;kroah.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c8:1005::348]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a58824b-c3a7-4cfb-d1cf-08d85e499c1f
x-ms-traffictypediagnostic: BY5PR11MB4387:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4387F9CAA7B16BEE4A7BCF69DA3A0@BY5PR11MB4387.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q6i2mbMfgSxrQbu1n/8Q7KozjXzSivHdUwyXoOF4U7JUYm3nBlEgNzevlQgh7HBql7vMg23rLpZRuf6+XsiwZYVysOwQv7TgOuR27vD3Ab8uECqoV5OCXeqN02aj8Ag9h4WERHV1J8EhDwQ1NrGGUu91DzowFEhSygTAuRzCx4nyKiWyAT+NwbfYQB3BsrhNheMvELJbi0lJlVof8by34+6d1DfV4B3fUjgzUMipHISlJ3quSvVM4J0+wvEi73U7UY2aM6aK7rlBzFEYDIkAsTJMt/v1uzEpBD6svEYVrjBw7ngpEThItWRw/lkMXsTA/zDBpREMhHpfn3M2zV2EoHPJa9GeiehlbsSJ+UQiTOGJAWNcgqDkiSBY1SHUHn0ikWnzwRBchuLdo9Sl5LoaW6HcMgyUJ4Lqyy60ds8+5I0YxVGPpnI5ZcjwONnmbAhC/xDa6oJ99yrwi9v9B83x00JbjLkyr3fnXymrnKFe4M+zNusz/bQdd3ShwDV0c8Gh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4182.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(396003)(376002)(346002)(8936002)(6506007)(76116006)(66476007)(83380400001)(7416002)(2906002)(66446008)(66556008)(71200400001)(66946007)(64756008)(478600001)(86362001)(6916009)(5660300002)(8676002)(6512007)(186003)(54906003)(316002)(966005)(4326008)(2616005)(36756003)(6486002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 20rGazRtdSNLFepgFgI7WJJj5BnZJ3kDwwb8EiFV/ntVxdNtYL+WUCwErxR7Fx2lcxpQgNL4zLnXe9jkxpRWoWMZUkg3wYbzmq2Yf240+VHbEXXxnmvBeRz81K6RcVhuCtShuve+eoUmKMb/DFY0AE/P0bu4mywwJgvOvsxbC3LWHRw/2szAbC72+e26EoLBR8+5keAGBk+FwM8QbBRYoHwXrqV3U8hduwhFie7taNH69QyodCGXXe6rAsWmpwksZfECFA10kzx5HkObpOpt1epM2PVM2iyrmAZt1gaeU20ld7qjRPo/9tt3JElZWY+zuEncnaT9GD4N4OjmYKnc2spbomtpoyuB3IAmL8pFwz1jYXzude476HWWUBfB3U3z8/ZMnvTQSeu7JlEsbLbjgjlMK/GkZx90MpXQVLREgIS03V4p6F145gcSOQL/Ygd+lqvyU0M5CneG9Y1h4jUpVoQO6L/tjdNJiQHAIr5phtyIKVtJIpijwA4hF0F6wx/DiD3cwyZ+5kwbqgpB6afgVFodX70gc4vULPL3NDwhUhJIod0yJcsa3Du/Ea/XProutB/SAGFkcIcuXEpWR3XtbsF/55GXdgHmnJ9U+Ds5MAvbhKHKxx6F9JXxMeW72ajfA9m+jJa6N2JDQzA2j6gznqd8PoJSydftUWDkh87JSAE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D71B1E09CAC4CD4289E6BB9848C974B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4182.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a58824b-c3a7-4cfb-d1cf-08d85e499c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 16:15:51.6020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kSm9N1ZOzfVS6cxYanbJEUX/awPoSv8DdXNW+oy3L02to6/A/an97xvLnszFf8MCrYxdAoYGcrmwr5+209iccA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4387
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: rcdn-core-11.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTIxIGF0IDE4OjEyICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBU
aHUsIFNlcCAxNywgMjAyMCBhdCAwNjoxOToxM1BNIC0wNzAwLCBKdWxpdXMgSGVtYW50aCBQaXR0
aSB3cm90ZToNCj4gPiBGcm9tOiBYdW5sZWkgUGFuZyA8eGxwYW5nQGxpbnV4LmFsaWJhYmEuY29t
Pg0KPiA+IA0KPiA+IGNvbW1pdCBlMzMzNmNhYjI1NzkwMTJiMWU3MmI1MjY1YWRmOThlMmQ2ZTI0
NGFkIHVwc3RyZWFtLg0KPiA+IA0KPiA+IFdlJ3ZlIG1ldCBzb2Z0bG9ja3VwIHdpdGggIkNPTkZJ
R19QUkVFTVBUX05PTkU9eSIsIHdoZW4gdGhlIHRhcmdldA0KPiA+IG1lbWNnDQo+ID4gZG9lc24n
dCBoYXZlIGFueSByZWNsYWltYWJsZSBtZW1vcnkuDQo+ID4gDQo+ID4gSXQgY2FuIGJlIGVhc2ls
eSByZXByb2R1Y2VkIGFzIGJlbG93Og0KPiA+IA0KPiA+ICAgd2F0Y2hkb2c6IEJVRzogc29mdCBs
b2NrdXAgLSBDUFUjMCBzdHVjayBmb3INCj4gPiAxMTFzIVttZW1jZ190ZXN0OjIyMDRdDQo+ID4g
ICBDUFU6IDAgUElEOiAyMjA0IENvbW06IG1lbWNnX3Rlc3QgTm90IHRhaW50ZWQgNS45LjAtcmMy
KyAjMTINCj4gPiAgIENhbGwgVHJhY2U6DQo+ID4gICAgIHNocmlua19scnV2ZWMrMHg0OWYvMHg2
NDANCj4gPiAgICAgc2hyaW5rX25vZGUrMHgyYTYvMHg2ZjANCj4gPiAgICAgZG9fdHJ5X3RvX2Zy
ZWVfcGFnZXMrMHhlOS8weDNlMA0KPiA+ICAgICB0cnlfdG9fZnJlZV9tZW1fY2dyb3VwX3BhZ2Vz
KzB4ZWYvMHgxZjANCj4gPiAgICAgdHJ5X2NoYXJnZSsweDJjMS8weDc1MA0KPiA+ICAgICBtZW1f
Y2dyb3VwX2NoYXJnZSsweGQ3LzB4MjQwDQo+ID4gICAgIF9fYWRkX3RvX3BhZ2VfY2FjaGVfbG9j
a2VkKzB4MmZkLzB4MzcwDQo+ID4gICAgIGFkZF90b19wYWdlX2NhY2hlX2xydSsweDRhLzB4YzAN
Cj4gPiAgICAgcGFnZWNhY2hlX2dldF9wYWdlKzB4MTBiLzB4MmYwDQo+ID4gICAgIGZpbGVtYXBf
ZmF1bHQrMHg2NjEvMHhhZDANCj4gPiAgICAgZXh0NF9maWxlbWFwX2ZhdWx0KzB4MmMvMHg0MA0K
PiA+ICAgICBfX2RvX2ZhdWx0KzB4NGQvMHhmOQ0KPiA+ICAgICBoYW5kbGVfbW1fZmF1bHQrMHgx
MDgwLzB4MTc5MA0KPiA+IA0KPiA+IEl0IG9ubHkgaGFwcGVucyBvbiBvdXIgMS12Y3B1IGluc3Rh
bmNlcywgYmVjYXVzZSB0aGVyZSdzIG5vIGNoYW5jZQ0KPiA+IGZvcg0KPiA+IG9vbSByZWFwZXIg
dG8gcnVuIHRvIHJlY2xhaW0gdGhlIHRvLWJlLWtpbGxlZCBwcm9jZXNzLg0KPiA+IA0KPiA+IEFk
ZCBhIGNvbmRfcmVzY2hlZCgpIGF0IHRoZSB1cHBlciBzaHJpbmtfbm9kZV9tZW1jZ3MoKSB0byBz
b2x2ZQ0KPiA+IHRoaXMNCj4gPiBpc3N1ZSwgdGhpcyB3aWxsIG1lYW4gdGhhdCB3ZSB3aWxsIGdl
dCBhIHNjaGVkdWxpbmcgcG9pbnQgZm9yIGVhY2gNCj4gPiBtZW1jZw0KPiA+IGluIHRoZSByZWNs
YWltZWQgaGllcmFyY2h5IHdpdGhvdXQgYW55IGRlcGVuZGVuY3kgb24gdGhlDQo+ID4gcmVjbGFp
bWFibGUNCj4gPiBtZW1vcnkgaW4gdGhhdCBtZW1jZyB0aHVzIG1ha2luZyBpdCBtb3JlIHByZWRp
Y3RhYmxlLg0KPiA+IA0KPiA+IFN1Z2dlc3RlZC1ieTogTWljaGFsIEhvY2tvIDxtaG9ja29Ac3Vz
ZS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogWHVubGVpIFBhbmcgPHhscGFuZ0BsaW51eC5hbGli
YWJhLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZv
dW5kYXRpb24ub3JnPg0KPiA+IEFja2VkLWJ5OiBDaHJpcyBEb3duIDxjaHJpc0BjaHJpc2Rvd24u
bmFtZT4NCj4gPiBBY2tlZC1ieTogTWljaGFsIEhvY2tvIDxtaG9ja29Ac3VzZS5jb20+DQo+ID4g
QWNrZWQtYnk6IEpvaGFubmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPg0KPiA+IExpbms6
IA0KPiA+IGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci8xNTk4NDk1NTQ5LTY3MzI0LTEtZ2l0LXNl
bmQtZW1haWwteGxwYW5nQGxpbnV4LmFsaWJhYmEuY29tDQo+ID4gU2lnbmVkLW9mZi1ieTogTGlu
dXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiA+IEZpeGVzOiBi
MGRlZGM0OWEyZGEgKCJtbS92bXNjYW4uYzogaXRlcmF0ZSBvbmx5IG92ZXIgY2hhcmdlZA0KPiA+
IHNocmlua2VycyBkdXJpbmcgbWVtY2cgc2hyaW5rX3NsYWIoKSIpDQo+ID4gQ2M6IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcNCj4gPiBTaWduZWQtb2ZmLWJ5OiBKdWxpdXMgSGVtYW50aCBQaXR0aSA8
anBpdHRpQGNpc2NvLmNvbT4NCj4gPiAtLS0NCj4gPiAgbW0vdm1zY2FuLmMgfCA4ICsrKysrKysr
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCj4gDQo+IFRoZSBGaXhlczog
dGFnIHlvdSBzaG93IGhlcmUgZ29lcyBiYWNrIHRvIDQuMTksIGNhbiB5b3UgcHJvdmlkZSBhDQo+
IDQuMTkueQ0KPiBhbmQgNS40LnkgdmVyc2lvbiBvZiB0aGlzIGFzIHdlbGw/DQpTdXJlLiBXaWxs
IHNlbmQgZm9yIGJvdGggNS40LnkgYW5kIDQuMTkueS4NCg0KPiANCj4gdGhhbmtzLA0KPiANCj4g
Z3JlZyBrLWgNCg==
