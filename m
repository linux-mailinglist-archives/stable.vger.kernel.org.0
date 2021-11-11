Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B2044DDB6
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 23:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhKKWGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 17:06:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:45977 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234244AbhKKWGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 17:06:23 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233266009"
X-IronPort-AV: E=Sophos;i="5.87,227,1631602800"; 
   d="scan'208";a="233266009"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 14:03:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,227,1631602800"; 
   d="scan'208";a="670429152"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 11 Nov 2021 14:03:15 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 11 Nov 2021 14:03:14 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 11 Nov 2021 14:03:14 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 11 Nov 2021 14:03:14 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 11 Nov 2021 14:03:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eacG2BYHu/xoDVEgjrgEetBONzpo99DX9ZSYpTBXzjEYVEpuuCD8kDlqZQatRxucfFQtDzmIGttbDb3JuQZ918qYfrn0BgtfxPh3qsiwPOztpEExfgmiXmF+OKl9wUdi1JZc0qiHo+Il0rxaEm6kWE+9jgn3GkmQvGybb+g6a0hQqMuaCY7WbohpF5stCZ8q3pMVgHN36/SaZoPu45+EsmiZMN7qEOWOlq3kEvsmh3iXdr4InBdN2ErDKzL+NXaXxwtIdRwPiwoPpV8tvw3wVoSl4qnSLz1dTiJ63ZOODVzz5uB+PsWHQ7pxcpUMyj6p1W6ufriUnJ+ApO0JVaS5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0YM1xrmsQFnGlakphfx4taCPIWUAalATun24vx6ep0=;
 b=f5NTcQBRM3QNjSs3wiFjnaOM1pQyvWRVehyr5Pzw/Ue/dE3sKQDbkG0gPB1op43YpwjaTCegEfXsVw8rB5DZbnhg9ROT5fTHgeDWNnwGB/0oIHT/YooV5yRMPfoBtNESX1z2imAO6QW5plYPVlYXu4Oc/JuddwgZ0VSWoMa+PeIfwugUqApwJ9uxF0mMovTujMCYcwa4GMu0GkIrwRq0YIfzVDfWPLAKPcAkjM5WLtiGBvXeQmt5wQrPf8vL8wSvETwRZq1FPpWBfNUsN8NqzLK2kskkT+grcfSZ2KyS8/sIpX2eORO8sdJ2UolU42LBRjaHfB1drIr/poaa9D0gIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0YM1xrmsQFnGlakphfx4taCPIWUAalATun24vx6ep0=;
 b=b6yKdbiWDueMO8K6Qgu6d6JfdaEfTawP6gZCug7XGfpCeKiG00OQ03s77QSOZSiT/0G+U8bqzEftShcAgBrPhm0lps+z2on4W73pAq4mh5DvvJnsihUeJmqf7CFmuY15WGAmicOrd8jwtA+dE7U09VgJ9MXAL1ptRrEJR+KJ09Q=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4093.namprd11.prod.outlook.com (2603:10b6:208:13f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Thu, 11 Nov
 2021 22:03:12 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 22:03:11 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "Widawsky, Ben" <ben.widawsky@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "Schofield, Alison" <alison.schofield@intel.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH] cxl/pmem: Fix module reload vs workqueue state
Thread-Topic: [PATCH] cxl/pmem: Fix module reload vs workqueue state
Thread-Index: AQHX1yiiVAjLTOZQGk6zgoh2qH+l6av+4YIA
Date:   Thu, 11 Nov 2021 22:03:11 +0000
Message-ID: <0d268df9abc0e8c64e888e6504d5f2cead76cf6f.camel@intel.com>
References: <163665474585.3505991.8397182770066720755.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163665474585.3505991.8397182770066720755.stgit@dwillia2-desk3.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3368e1d1-2675-4b47-e416-08d9a55f0d9d
x-ms-traffictypediagnostic: MN2PR11MB4093:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB4093B98114273B1DE5C72856C7949@MN2PR11MB4093.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4njCE0retGlIso4wnr1YlPoaauYc9ebNv8aEM83g51e7a/1MoRQ4wc8uO0JxE9aex68/qt1/vCQoSaB1unkGL2ONjS/Obkms5wW4O5121QzfARN2yLBib97fB1ttwHpxivgJK8kcDRPAw3Swz0V5DRoFGb0l2yojWJW9x+Gxxfl9JRmJsrG8Hj8eRhEg079m+5qR2+BV/5iJsvg4mYoCLLqLRsWEeU7/Ug9PBO0/Z0imdl8vARz3mN4wyjYlWlRUOuCQKS1sx/pYiNkFD6ZtYWAMU+iI2KVGXV/Esyuc1Hg2+hat9YJ75v2vAvNOd2MutZBgOLHp2pCqGIp0ceS31jv8w1OnBUS9OqMQ0/bI1xS8ldahjS9BynpRymz3y9dA9nGkFfzoTcbQtbw6wjfyAGOyqlrlBQ6zLPWweUHEjHQRyOglcH+OIQOmtPwASzWxIAa6PBhNLxxcyUK1WQCYsj1Kz9JPxgk24yTrxooWoPTSBXbYct+bXuuk1Dj1FLW6shRqvXOQSyN1UIRQ4fN3OUR1KTOqGSMg70QRJzKh/Vxd3AbRR5d8rgyJJVoMEDjloyxvWldrCdLzcF06i8XrVfQlehgj96s7rDPZpgUzXvlBKxOeHbGPC/QAAJWg0UaFu01adhN0gAlEGEjUrXD09JX2CBABER6UGO9GspM+xBpzGHWRMhywqSMyEQfAgoWWISA0sfdwoaMUpwFvuExaSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(36756003)(316002)(5660300002)(38100700002)(110136005)(26005)(508600001)(38070700005)(54906003)(83380400001)(186003)(6506007)(86362001)(4326008)(8676002)(76116006)(66476007)(66556008)(66446008)(64756008)(122000001)(91956017)(82960400001)(66946007)(71200400001)(4001150100001)(2616005)(2906002)(6486002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3BpRXJJK3BqRG90YXVpQ00yU3R6dlRLdVNSbTV1d2J4NmFJbElsNlZIdGp5?=
 =?utf-8?B?TUdsUEl0MGw5ZjhxeEo1bjhFR2lETXBzc21zVzV6aDVnVGlZeEZpbXRkd1ll?=
 =?utf-8?B?Q3NZak00WWlzTXdSUlR5Q1lGUUhHMm9HVE5zb284VnRmWDAya3lyZldSVUh1?=
 =?utf-8?B?c0lhSFZmajBOWk9wbjNpRVdzYVRMVmUzRDVIV1lGcjBJMERvTXlaWjhHYkZP?=
 =?utf-8?B?TDR2TURoMVo5dDNFRk94b0hRZ01vQ3VJN0NGZFBBSjNMazl4VGxBcmhzNm5z?=
 =?utf-8?B?aGhTVzRlbUliMnNSQXBBOXpuaFhqSzFNem1yaEhocmczc0h5eXcvcTJCZWwr?=
 =?utf-8?B?eWFjeE54Z3FSMjBlV3A2dTNmak9vSkw2anltczBYZzNGdTlhcHV1MU51c3Q4?=
 =?utf-8?B?Z2oxOWdJUlY3SVlKNWlYblN4ZlpsUE1GNWhubml4ZDg0SllGRStnZ3hSYkc1?=
 =?utf-8?B?Zlc2bGltVjhiRXFibTVLQU1nMmxVNTlzZnA5VzFRMEcvTThUc1hQYlV6dEg1?=
 =?utf-8?B?azV6VUVwa2JpUk82ZW9wMUxSaFFON0g3UFFvRFlkV0k3clJqNFROeWF3WnNr?=
 =?utf-8?B?THJiV3k3Yzk5SlVKTjJQUXFPZ1RYRi85dlBzcC9vZCtYNVJkVmltME1rclRM?=
 =?utf-8?B?QjczZEQ3cVU1Rno5M0pRcVRRS3lCTVp6VGZocUN2TzFBcG54NFRkZ2Jndm52?=
 =?utf-8?B?TFN3S2RTY3FOQnd2MEo0NHhPcllGVnVIVWptdnBIT0xIdDE1eFRmNzhNcW56?=
 =?utf-8?B?MUwzRnMybE1oTktsbUpwektSSTJYYmZXdkZpdkxVTys0M3d0NWk4ekNRVG1l?=
 =?utf-8?B?RzRqRzR0aFhNVlVXTkQxWDZPakZtT2MwNWNXaG5qYW5pZ2VYNnVIOHY0S2ZU?=
 =?utf-8?B?dEJvdytYOTlDUVpycTNjUmF0bWxqVjZPME91b0VTNTBXbU96bm1rZVhJTUpi?=
 =?utf-8?B?ZGZ0bnlCV3I2WUppd3d6M2ZWSmVvWDhsbTN3TDJIZzRUUUV3MDFYWEJNUk1L?=
 =?utf-8?B?L05vMzZjVTI1cUN0UGJlVGFxTTNwaUw2UUNrVmJWQUl0UGxySUZ0MVZKSWJD?=
 =?utf-8?B?T2JGNmkvUGJpY1MrM3ZNemt1clloZUJDbUdGelFxeVZNQWl4NWE0czNNM1BZ?=
 =?utf-8?B?YXdZQStMbUNMV0t5dC82cEtIYzVJcEYwTkpCVmZXVXhLNXBxNTQ2Snp3SWdD?=
 =?utf-8?B?Rm9aazRvNmlYWHhTVXRLY1FJUGFUUUdjSGZEbm5lbVVyM3lFaGcyWFlZM25E?=
 =?utf-8?B?QkpIWGNMMWw0REsyUitpSnVPYUJMRllyTHgrVUdvZFo4TDRhWndoeWJzN0lL?=
 =?utf-8?B?K1o2ZVhPOFNZUExsdGtnUGhGRm4vS3JyY2ZPRDV1MkF4ZmMreEFBYUcva05B?=
 =?utf-8?B?MXFObHhDMWo3bEttR1M3SWlxU2JTMFJJMXphMFV1UlpzZU1JOFBDRWtiMlF2?=
 =?utf-8?B?eWZNVEdkcElJNFh2REhFTTM0MFRDVi9OYTVaUnFadjZueWpZZ2Rwc1JSS0h5?=
 =?utf-8?B?VzZTWW05azYwek5hWXhaa1BvV2oxT1dIRVRyTWRsLzY1SWlmVGpVQm1zWGhj?=
 =?utf-8?B?WCtLRk0rejZOc2Npb0M1UkpNTG9lczY4b1lHOVJlWGFTR24rSHF2ZmRhWDBT?=
 =?utf-8?B?a3Rqd3FtUkxTZk9JamRYR2E5L1pQcE5Pa2JNbVZRWlZsTlZJeVpPWWlnOFY0?=
 =?utf-8?B?NERqcW15NUttRE1xV3prQk1ZQzUxaHR2VWlpckdiV1Bvb29Ka3FHWjUxU0tk?=
 =?utf-8?B?QlptSEtGbFp4RG82Smc5NWd3dTdPQzY2ZjBYbS9VV3hnTUFUbkVXNGs0TXky?=
 =?utf-8?B?SERVVHdzMHlnczQ0VC8ySnk1VGwzeElvN0QzV3RzeFFuK2Vha096TXNqcE04?=
 =?utf-8?B?R2h3eFFyNG1rbVF4SUZNZ01ldzY2WDQ4Z2t6dUxHMnVLN1E3L3A5bitYTkdO?=
 =?utf-8?B?dlFzMHh0cFpvWFU4KzZGako2a0xuWFVOOTdEZzVIajhPeml0UllkOXFxUUJI?=
 =?utf-8?B?T3EwUG1nTHQzcjJVNTZaL05qa1J1TWdwUklPYXNUM3UyRVBIeDVPanlmVzU4?=
 =?utf-8?B?bCt0dEtMMnh2U2lwcGZlQ0pnVW8wY1dxd1p0Z1k3aktUbkRsbURpWVMyM3c1?=
 =?utf-8?B?a0drUEtzVWJMaHNLaWdXYmxXME80M3RFSzN5MU1Jc3VvU3RUNEFvem5Dc1pU?=
 =?utf-8?B?NndTanNsbjA4TlBWK2RHYjU2dHhxVkJtNkN1VERmR2pFS2VrMitZL3FjYnhp?=
 =?utf-8?Q?6HZTPbnZykdsxmyq/Y8m5aZsBeZYWPJwWoLL8n3vsg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2656E8188D7F114FAEC3408EF531830E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3368e1d1-2675-4b47-e416-08d9a55f0d9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 22:03:11.7623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cqhHOX84dVPCvK6LUbgBQGAyV1ZT4MEzNQfZLIIqAV+tlj1DHJJRArYNBSCJobWLu/VJtXjPPE8w9b1rNugL20nann7DwltaIFvqyMj9Rpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4093
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIxLTExLTExIGF0IDEwOjE5IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEEgdGVzdCBvZiB0aGUgZm9ybToNCj4gDQo+ICAgICB3aGlsZSB0cnVlOyBkbyBtb2Rwcm9iZSAt
ciBjeGxfcG1lbTsgbW9kcHJvYmUgY3hsX3BtZW07IGRvbmUNCj4gDQo+IE1heSBsZWFkIHRvIGEg
Y3Jhc2ggc2lnbmF0dXJlIG9mIHRoZSBmb3JtOg0KPiANCj4gICAgIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBwYWdlIGZhdWx0IGZvciBhZGRyZXNzOiBmZmZmZmZmZmMwNjYwMDMwDQo+ICAgICAjUEY6
IHN1cGVydmlzb3IgaW5zdHJ1Y3Rpb24gZmV0Y2ggaW4ga2VybmVsIG1vZGUNCj4gICAgICNQRjog
ZXJyb3JfY29kZSgweDAwMTApIC0gbm90LXByZXNlbnQgcGFnZQ0KPiAgICAgWy4uXQ0KPiAgICAg
V29ya3F1ZXVlOiBjeGxfcG1lbSAweGZmZmZmZmZmYzA2NjAwMzANCj4gICAgIFJJUDogMDAxMDow
eGZmZmZmZmZmYzA2NjAwMzANCj4gICAgIENvZGU6IFVuYWJsZSB0byBhY2Nlc3Mgb3Bjb2RlIGJ5
dGVzIGF0IFJJUCAweGZmZmZmZmZmYzA2NjAwMDYuDQo+ICAgICBbLi5dDQo+ICAgICBDYWxsIFRy
YWNlOg0KPiAgICAgID8gcHJvY2Vzc19vbmVfd29yaysweDRlYy8weDljMA0KPiAgICAgID8gcHdx
X2RlY19ucl9pbl9mbGlnaHQrMHgxMDAvMHgxMDANCj4gICAgICA/IHJ3bG9ja19idWcucGFydC4w
KzB4NjAvMHg2MA0KPiAgICAgID8gd29ya2VyX3RocmVhZCsweDJlYi8weDcwMA0KPiANCj4gSW4g
dGhhdCByZXBvcnQgdGhlIDB4ZmZmZmZmZmZjMDY2MDAzMCBhZGRyZXNzIGNvcnJlc3BvbmRzIHRv
IHRoZSBmb3JtZXINCj4gZnVuY3Rpb24gYWRkcmVzcyBvZiBjeGxfbnZiX3VwZGF0ZV9zdGF0ZSgp
IGZyb20gYSBwcmV2aW91cyBsb2FkIG9mIHRoZQ0KPiBtb2R1bGUsIG5vdCB0aGUgY3VycmVudCBh
ZGRyZXNzLiBGaXggdGhhdCBieSBhcnJhbmdpbmcgZm9yIC0+c3RhdGVfd29yaw0KPiBpbiB0aGUg
J3N0cnVjdCBjeGxfbnZkaW1tX2JyaWRnZScgb2JqZWN0IHRvIGJlIHJlaW5pdGlhbGl6ZWQgb24g
Y3hsX3BtZW0NCj4gbW9kdWxlIHJlbG9hZC4NCj4gDQo+IERldGFpbHM6DQo+IA0KPiBSZWNhbGwg
dGhhdCBDWEwgc3Vic3lzdGVtIHdhbnRzIHRvIGxpbmsgYSBDWEwgbWVtb3J5IGV4cGFuZGVyIGRl
dmljZSB0bw0KPiBhbiBOVkRJTU0gc3ViLWhpZXJhcmNoeSB3aGVuIGJvdGggYSBwZXJzaXN0ZW50
IG1lbW9yeSByYW5nZSBoYXMgYmVlbg0KPiByZWdpc3RlcmVkIGJ5IHRoZSBDWEwgcGxhdGZvcm0g
ZHJpdmVyIChjeGxfYWNwaSkgKmFuZCogd2hlbiB0aGF0IENYTA0KPiBtZW1vcnkgZXhwYW5kZXIg
aGFzIHB1Ymxpc2hlZCBwZXJzaXN0ZW50IG1lbW9yeSBjYXBhY2l0eSAoR2V0IFBhcnRpdGlvbg0K
PiBJbmZvKS4gVG8gdGhpcyBlbmQgdGhlIGN4bF9udmRpbW1fYnJpZGdlIGRyaXZlciBhcnJhbmdl
cyB0byByZXNjYW4gdGhlDQo+IENYTCBidXMgd2hlbiBlaXRoZXIgb2YgdGhvc2UgY29uZGl0aW9u
cyBjaGFuZ2UuIFRoZSBoZWxwZXINCj4gYnVzX3Jlc2Nhbl9kZXZpY2VzKCkgY2FuIG5vdCBiZSBj
YWxsZWQgdW5kZXJuZWF0aCB0aGUgZGV2aWNlX2xvY2soKSBmb3INCj4gYW55IGRldmljZSBvbiB0
aGF0IGJ1cywgc28gdGhlIGN4bF9udmRpbW1fYnJpZGdlIGRyaXZlciB1c2VzIGEgd29ya3F1ZXVl
DQo+IGZvciB0aGUgcmVzY2FuLg0KPiANCj4gVHlwaWNhbGx5IGEgZHJpdmVyIGFsbG9jYXRlcyBk
cml2ZXIgZGF0YSB0byBob2xkIGEgJ3N0cnVjdCB3b3JrX3N0cnVjdCcNCj4gZm9yIGEgZHJpdmVu
IGRldmljZSwgYnV0IGZvciBhIHdvcmtxdWV1ZSB0aGF0IG1heSBydW4gYWZ0ZXIgLT5yZW1vdmUo
KQ0KPiByZXR1cm5zLCBkcml2ZXIgZGF0YSB3aWxsIGhhdmUgYmVlbiBmcmVlZC4gVGhlICdzdHJ1
Y3QNCj4gY3hsX252ZGltbV9icmlkZ2UnIG9iamVjdCBob2xkcyB0aGUgc3RhdGUgYW5kIHdvcmtf
c3RydWN0IGRpcmVjdGx5Lg0KPiBVbmZvcnR1bmF0ZWx5IGl0IHdhcyBvbmx5IGFycmFuZ2luZyBm
b3IgdGhhdCBpbmZyYXN0cnVjdHVyZSB0byBiZQ0KPiBpbml0aWFsaXplZCBvbmNlIHBlciBkZXZp
Y2UgY3JlYXRpb24gcmF0aGVyIHRoYW4gdGhlIG5lY2Vzc2FyeSBvbmNlIHBlcg0KPiB3b3JrcXVl
dWUgKGN4bF9wbWVtX3dxKSBjcmVhdGlvbi4NCj4gDQo+IEludHJvZHVjZSBpc19jeGxfbnZkaW1t
X2JyaWRnZSgpIGFuZCBjeGxfbnZkaW1tX2JyaWRnZV9yZXNldCgpIGluDQo+IHN1cHBvcnQgb2Yg
aW52YWxpZGF0aW5nIHN0YWxlIHJlZmVyZW5jZXMgdG8gYSByZWNlbnRseSBkZXN0cm95ZWQNCj4g
Y3hsX3BtZW1fd3EuDQo+IA0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IEZpeGVz
OiA4ZmRjYjE3MDRmNjEgKCJjeGwvcG1lbTogQWRkIGluaXRpYWwgaW5mcmFzdHJ1Y3R1cmUgZm9y
IHBtZW0gc3VwcG9ydCIpDQo+IFJlcG9ydGVkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+DQoNClRyaWVkIHRoaXMgb3V0IGFuZCB3b3JrcyBmaW5lIG5vdywgdGhh
bmtzIGZvciB0aGUgcXVpY2sgZml4IQ0KDQpUZXN0ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFs
LmwudmVybWFAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9jeGwvY29yZS9wbWVtLmMg
fCAgICA4ICsrKysrKystDQo+ICBkcml2ZXJzL2N4bC9jeGwuaCAgICAgICB8ICAgIDggKysrKysr
KysNCj4gIGRyaXZlcnMvY3hsL3BtZW0uYyAgICAgIHwgICAyOSArKysrKysrKysrKysrKysrKysr
KysrKysrKystLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA0MiBpbnNlcnRpb25zKCspLCAzIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3hsL2NvcmUvcG1lbS5jIGIvZHJp
dmVycy9jeGwvY29yZS9wbWVtLmMNCj4gaW5kZXggNzZhNGZhMzk4MzRjLi5jYzQwMmNiN2E5MDUg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3hsL2NvcmUvcG1lbS5jDQo+ICsrKyBiL2RyaXZlcnMv
Y3hsL2NvcmUvcG1lbS5jDQo+IEBAIC01MSwxMCArNTEsMTYgQEAgc3RydWN0IGN4bF9udmRpbW1f
YnJpZGdlICp0b19jeGxfbnZkaW1tX2JyaWRnZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICB9DQo+
ICBFWFBPUlRfU1lNQk9MX05TX0dQTCh0b19jeGxfbnZkaW1tX2JyaWRnZSwgQ1hMKTsNCj4gIA0K
PiAtX19tb2NrIGludCBtYXRjaF9udmRpbW1fYnJpZGdlKHN0cnVjdCBkZXZpY2UgKmRldiwgY29u
c3Qgdm9pZCAqZGF0YSkNCj4gK2Jvb2wgaXNfY3hsX252ZGltbV9icmlkZ2Uoc3RydWN0IGRldmlj
ZSAqZGV2KQ0KPiAgew0KPiAgCXJldHVybiBkZXYtPnR5cGUgPT0gJmN4bF9udmRpbW1fYnJpZGdl
X3R5cGU7DQo+ICB9DQo+ICtFWFBPUlRfU1lNQk9MX05TX0dQTChpc19jeGxfbnZkaW1tX2JyaWRn
ZSwgQ1hMKTsNCj4gKw0KPiArX19tb2NrIGludCBtYXRjaF9udmRpbW1fYnJpZGdlKHN0cnVjdCBk
ZXZpY2UgKmRldiwgY29uc3Qgdm9pZCAqZGF0YSkNCj4gK3sNCj4gKwlyZXR1cm4gaXNfY3hsX252
ZGltbV9icmlkZ2UoZGV2KTsNCj4gK30NCj4gIA0KPiAgc3RydWN0IGN4bF9udmRpbW1fYnJpZGdl
ICpjeGxfZmluZF9udmRpbW1fYnJpZGdlKHN0cnVjdCBjeGxfbnZkaW1tICpjeGxfbnZkKQ0KPiAg
ew0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jeGwvY3hsLmggYi9kcml2ZXJzL2N4bC9jeGwuaA0K
PiBpbmRleCA1ZTJlOTM0NTE5MjguLmNhOTc5ZWUxMTAxNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9jeGwvY3hsLmgNCj4gKysrIGIvZHJpdmVycy9jeGwvY3hsLmgNCj4gQEAgLTIyMSw2ICsyMjEs
MTMgQEAgc3RydWN0IGN4bF9kZWNvZGVyIHsNCj4gIH07DQo+ICANCj4gIA0KPiArLyoqDQo+ICsg
KiBlbnVtIGN4bF9udmRpbW1fYnJpZ2Vfc3RhdGUgLSBzdGF0ZSBtYWNoaW5lIGZvciBtYW5hZ2lu
ZyBidXMgcmVzY2Fucw0KPiArICogQENYTF9OVkJfTkVXOiBTZXQgYXQgYnJpZGdlIGNyZWF0ZSBh
bmQgYWZ0ZXIgY3hsX3BtZW1fd3EgaXMgZGVzdHJveWVkDQo+ICsgKiBAQ1hMX05WQl9ERUFEOiBT
ZXQgYXQgYnJpZ2UgdW5yZWdpc3RyYXRpb24gdG8gcHJlY2x1ZGUgYXN5bmMgcHJvYmluZw0KPiAr
ICogQENYTF9OVkJfT05MSU5FOiBUYXJnZXQgc3RhdGUgYWZ0ZXIgc3VjY2Vzc2Z1bCAtPnByb2Jl
KCkNCj4gKyAqIEBDWExfTlZCX09GRkxJTkU6IFRhcmdldCBzdGF0ZSBhZnRlciAtPnJlbW92ZSgp
IG9yIGZhaWxlZCAtPnByb2JlKCkNCj4gKyAqLw0KPiAgZW51bSBjeGxfbnZkaW1tX2JyaWdlX3N0
YXRlIHsNCj4gIAlDWExfTlZCX05FVywNCj4gIAlDWExfTlZCX0RFQUQsDQo+IEBAIC0zMzMsNiAr
MzQwLDcgQEAgc3RydWN0IGN4bF9udmRpbW1fYnJpZGdlICpkZXZtX2N4bF9hZGRfbnZkaW1tX2Jy
aWRnZShzdHJ1Y3QgZGV2aWNlICpob3N0LA0KPiAgCQkJCQkJICAgICBzdHJ1Y3QgY3hsX3BvcnQg
KnBvcnQpOw0KPiAgc3RydWN0IGN4bF9udmRpbW0gKnRvX2N4bF9udmRpbW0oc3RydWN0IGRldmlj
ZSAqZGV2KTsNCj4gIGJvb2wgaXNfY3hsX252ZGltbShzdHJ1Y3QgZGV2aWNlICpkZXYpOw0KPiAr
Ym9vbCBpc19jeGxfbnZkaW1tX2JyaWRnZShzdHJ1Y3QgZGV2aWNlICpkZXYpOw0KPiAgaW50IGRl
dm1fY3hsX2FkZF9udmRpbW0oc3RydWN0IGRldmljZSAqaG9zdCwgc3RydWN0IGN4bF9tZW1kZXYg
KmN4bG1kKTsNCj4gIHN0cnVjdCBjeGxfbnZkaW1tX2JyaWRnZSAqY3hsX2ZpbmRfbnZkaW1tX2Jy
aWRnZShzdHJ1Y3QgY3hsX252ZGltbSAqY3hsX252ZCk7DQo+ICANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvY3hsL3BtZW0uYyBiL2RyaXZlcnMvY3hsL3BtZW0uYw0KPiBpbmRleCAxN2U4MmFlOTA0
NTYuLmI2NWEyNzJhMmQ2ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jeGwvcG1lbS5jDQo+ICsr
KyBiL2RyaXZlcnMvY3hsL3BtZW0uYw0KPiBAQCAtMzE1LDYgKzMxNSwzMSBAQCBzdGF0aWMgc3Ry
dWN0IGN4bF9kcml2ZXIgY3hsX252ZGltbV9icmlkZ2VfZHJpdmVyID0gew0KPiAgCS5pZCA9IENY
TF9ERVZJQ0VfTlZESU1NX0JSSURHRSwNCj4gIH07DQo+ICANCj4gKy8qDQo+ICsgKiBSZXR1cm4g
YWxsIGJyaWRnZXMgdG8gdGhlIENYTF9OVkJfTkVXIHN0YXRlIHRvIGludmFsaWRhdGUgYW55DQo+
ICsgKiAtPnN0YXRlX3dvcmsgcmVmZXJyaW5nIHRvIHRoZSBub3cgZGVzdHJveWVkIGN4bF9wbWVt
X3dxLg0KPiArICovDQo+ICtzdGF0aWMgaW50IGN4bF9udmRpbW1fYnJpZGdlX3Jlc2V0KHN0cnVj
dCBkZXZpY2UgKmRldiwgdm9pZCAqZGF0YSkNCj4gK3sNCj4gKwlzdHJ1Y3QgY3hsX252ZGltbV9i
cmlkZ2UgKmN4bF9udmI7DQo+ICsNCj4gKwlpZiAoIWlzX2N4bF9udmRpbW1fYnJpZGdlKGRldikp
DQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJY3hsX252YiA9IHRvX2N4bF9udmRpbW1fYnJpZGdl
KGRldik7DQo+ICsJZGV2aWNlX2xvY2soZGV2KTsNCj4gKwljeGxfbnZiLT5zdGF0ZSA9IENYTF9O
VkJfTkVXOw0KPiArCWRldmljZV91bmxvY2soZGV2KTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiAr
fQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBkZXN0cm95X2N4bF9wbWVtX3dxKHZvaWQpDQo+ICt7DQo+
ICsJZGVzdHJveV93b3JrcXVldWUoY3hsX3BtZW1fd3EpOw0KPiArCWJ1c19mb3JfZWFjaF9kZXYo
JmN4bF9idXNfdHlwZSwgTlVMTCwgTlVMTCwgY3hsX252ZGltbV9icmlkZ2VfcmVzZXQpOw0KPiAr
fQ0KPiArDQo+ICBzdGF0aWMgX19pbml0IGludCBjeGxfcG1lbV9pbml0KHZvaWQpDQo+ICB7DQo+
ICAJaW50IHJjOw0KPiBAQCAtMzQwLDcgKzM2NSw3IEBAIHN0YXRpYyBfX2luaXQgaW50IGN4bF9w
bWVtX2luaXQodm9pZCkNCj4gIGVycl9udmRpbW06DQo+ICAJY3hsX2RyaXZlcl91bnJlZ2lzdGVy
KCZjeGxfbnZkaW1tX2JyaWRnZV9kcml2ZXIpOw0KPiAgZXJyX2JyaWRnZToNCj4gLQlkZXN0cm95
X3dvcmtxdWV1ZShjeGxfcG1lbV93cSk7DQo+ICsJZGVzdHJveV9jeGxfcG1lbV93cSgpOw0KPiAg
CXJldHVybiByYzsNCj4gIH0NCj4gIA0KPiBAQCAtMzQ4LDcgKzM3Myw3IEBAIHN0YXRpYyBfX2V4
aXQgdm9pZCBjeGxfcG1lbV9leGl0KHZvaWQpDQo+ICB7DQo+ICAJY3hsX2RyaXZlcl91bnJlZ2lz
dGVyKCZjeGxfbnZkaW1tX2RyaXZlcik7DQo+ICAJY3hsX2RyaXZlcl91bnJlZ2lzdGVyKCZjeGxf
bnZkaW1tX2JyaWRnZV9kcml2ZXIpOw0KPiAtCWRlc3Ryb3lfd29ya3F1ZXVlKGN4bF9wbWVtX3dx
KTsNCj4gKwlkZXN0cm95X2N4bF9wbWVtX3dxKCk7DQo+ICB9DQo+ICANCj4gIE1PRFVMRV9MSUNF
TlNFKCJHUEwgdjIiKTsNCj4gDQoNCg==
