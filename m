Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6DD619002
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 06:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiKDFe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 01:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiKDFe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 01:34:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A39205F2;
        Thu,  3 Nov 2022 22:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667540091; x=1699076091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K5SE4Lo4VqQyK/FIOaIW/8gPW+raStCPDc6rYrNJKMk=;
  b=VrfV8fG4ri7E9KzqWncBl7E5phUz5UK5afzP8LQ5DD43iexNv9Wy98Xy
   Jx/J00tQypjNjYrJyjgQH6JKX6TjoO3fzq8MOjJcLeTuP5UXvQULhOkt5
   Wrt8xJplbD7+aEGtkK8tqts794OFcRz1tTmFka6uPIaszRnxMYQXJ90CX
   oXwm7/NpWKRyHBmPLW2HmxGlxnY4/lR13dAfCq8pYBfWbNbWKI/AAUvAw
   CsKYk7bBvX9D5IH9RbVwhnn3d5DmJXZzUvq9lA8ZevCoa5yK/qOHsFyJL
   jsgyMVs9zLKFNOLoDwKkk/osecsKL6ARkPdHA7Z1nLnzrr9Qf96OWnptp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="309876450"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="309876450"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 22:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="629614571"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="629614571"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 03 Nov 2022 22:34:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 22:34:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 22:34:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 22:34:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khowZeNFzyvIaK6aDUpgl279qFQx8xFhTaCgcIVBXiqZscs3KndDk4iQti/qF6fAYPlUuZX1/o2Zi4kK4fxu1KZzG7KeuYeR5HIT356m/hL9kMYjf7uptqG1FznRoC2PRvkwBtF7m4PXn+56IgN7DtlRAswweOAEY4mfWMm3bj1R7WysGQtaWcTHkZswk9/zHpCgoDkle7jsgNZsL9p6JMuOmk2zXRH0eLPYP6yzsIHHpu9aTsjbP/P6/beD62tLufgBsH4k4W9tNrSdl8JIXwzDjYNKzK2ctVTjepdMpz8oePAWe3yyD33CCUaR59+IEyxX1bFCG2kNUsl5aPnUZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5SE4Lo4VqQyK/FIOaIW/8gPW+raStCPDc6rYrNJKMk=;
 b=IE2sSNzhnJsyLyIUflPs5RGXLE0ntQcKhDqigrvSHKReIyMAdIvDyElDgJQQXADMHvhQTVVb/SrbW1YUP+qLajqj5HAomJyRQ03UB42OkEw2zJTdujySKgLPs9qOOsUV03Sl+RHF6ZWxVUKCXzG/vO9z/yDGd+J8tykvU/bKSd+IUYewY2yWTULvxADlmVadPQ6P1zfjSVnYw75v3sq2qb+yGcuPq56SHvTfafGPVR+50/yD46Hp4aSXRiy7fpIf+szm0Rj83hXXH3DP5MBUC4CngmpjSY4dkMben+bXJ6jB/7G2FMktBRDRG1ifd/io4Utw+8OFdop8p3gr/OaJNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SJ0PR11MB6766.namprd11.prod.outlook.com (2603:10b6:a03:47c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 05:34:37 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 05:34:35 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "Schofield, Alison" <alison.schofield@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 1/7] cxl/region: Fix region HPA ordering validation
Thread-Topic: [PATCH 1/7] cxl/region: Fix region HPA ordering validation
Thread-Index: AQHY7+Su70CC+Ur7SkaBXnAKHVuHba4uPnQA
Date:   Fri, 4 Nov 2022 05:34:35 +0000
Message-ID: <6d17f11acda95e662371be0b4a63a0f9cbabba0e.camel@intel.com>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
         <166752182461.947915.497032805239915067.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166752182461.947915.497032805239915067.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SJ0PR11MB6766:EE_
x-ms-office365-filtering-correlation-id: d48d7ba3-1c6a-4f83-a047-08dabe26423e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BwHGBUaXhMAP/ly6C2rUBP58L4K7pUjbRkjXvXvlu77bA1jDefcbDX/J/ad0oM9t4vskvIY6p5fsPId1EV0KlhAlghZJErIACD3da1AtY74JCvmcLS3z8m78+mO1uTEacVQ8dBEA6QNca/vAt9pkWK4qqw3iy8Jo6vLsNN6Uy0TWNrrqrQp6KgnB3PDUKLub2dElR16GgvHCiYBWgHUZ+0Tx/4gKDIi/F+JGRWJPEHkIThyr8vbWidz5rJr6LFvlGlqt20z/VsRCl/UOOVPVBuJsB+2UUnelAZeuRqxXoVwCx1aoXl0M/gx1y2wKeCQluSWKIaGQZj3gIjsitwrDDdJ9+ALcdF0D1/zObJzjtod2VDdVMahE0HNNH5MWCvy0vC8zDoavoW3ccP8PcidHzi69o6ATWSTBm3z5RMXHsHgDDxO/XilWShHUyQfJ+hHQ0QqBHl0OtTKGwOyTqy/XFl1Hth3NHR0tZ6C/SYA1AMTLbZQnSDDQ6B2QST20R4YMO9I6sIzdm2LPukFm94gMDbltmlqiy3h/3ixfBocy1Mrau82fnGlqxwxSgMtGqSj5m45LjCn/t89Dwej0CjHdyrunCyzsYvMZaZsbGPn1VGmy/qlgwgtDMt3zKVKCHHa25ki/BXEMsi9Ed4CpJoD+wTTe1suOFL6dzT4A1muJfl93MNY5IX8wOwT8WBEOzAgn+Uy1qrNcmze0D+THwglFmgVBMivOEVOqs7J2TuAuhfh6wRHmXg3t/LaERuin+c7fMwL6NuPttgvRfBk1Vgd50w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199015)(38070700005)(316002)(6506007)(54906003)(110136005)(5660300002)(66556008)(66476007)(450100002)(8676002)(36756003)(64756008)(91956017)(66946007)(76116006)(26005)(4326008)(66446008)(6512007)(8936002)(71200400001)(2616005)(83380400001)(186003)(122000001)(82960400001)(107886003)(86362001)(6486002)(478600001)(38100700002)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3pVM2FCeHQ4TXJtTW9Bd1NiblhWWStjazN4aVRQcnlVVVAvOWhiWTNxek1y?=
 =?utf-8?B?N1hxM3ZhZWpjSjZnL1k1Z0dUK0FzdFgxUEN2Mmp3RFcrSm85OUNhcE1qd1Vx?=
 =?utf-8?B?YXBNRXU0Z1NvWDlEeUdQVitlWnErbjBpMDVqbUQ2M3pTQVlvTkNZQThJZHhS?=
 =?utf-8?B?bmNpMWQ1Q2Nsek1iL0lnQ0VzSVZLcFhlWmFTTE43cS9QMkRnZ3dXdlN3QThJ?=
 =?utf-8?B?MXBnaDZBaXRsaHd0VnJNb21HRjN6UkJUd0dsSU0rK0VWYUNmc1p6ZXRDVmhi?=
 =?utf-8?B?WXhqTytYdlRvc01OUWxRQk5yVElPZW4ybkg0UldGb0VBY2UrdmNpOWxQOFZM?=
 =?utf-8?B?YmxaazB2bXRPN0k0T1Y4WEtLTTVtNmx6K3Y1UTQzMjkzaWxEVUhjdUdOekV4?=
 =?utf-8?B?WlNaQlAwL0JlcFJwUFNuaUJycndrQzh4RmQ2NkFPbWpzSlJXemtFdnhZMk94?=
 =?utf-8?B?WUs1Z1FUdnZ4bC9LNDQvOTNtWGZ6N1Noa3BaT0RMdTBmTG5sRC92VUxvMGNT?=
 =?utf-8?B?SU4waEtHT0NMUkNZZisyN3Z5UFhHZkRlWDhBOVVXUCs0TmVIV3IrQzBPaE5q?=
 =?utf-8?B?U01nZVNLNFdmSzhEdDloQzQ1QWdxa0RZM0wxWEt0UTRoZzM1NjF5Sks4a1dr?=
 =?utf-8?B?UVk1KzJwcDNSeUtGREYza01RRXlZN0g2SGZTWFRleUZhTlNIZDZKODhuSVY0?=
 =?utf-8?B?TTRhbVAzbmM5U0FLdEN5Wlp1WXdrZHN4Z0RsdGpvbW9PbG00YkhaY2R1K2J3?=
 =?utf-8?B?a2N4SE5NbTBJWnQ2cEszRkk2UDltbDdUdGpTeVVmcWNFY2UxVzNmbEQzQ0hQ?=
 =?utf-8?B?Nk05Um1qckw5SDllMWF4TlNrY1hzMFQxcEpGcUJIOXJxRlNtRk5BNnoxZlpz?=
 =?utf-8?B?cDI1T0FHWEtYaGVKNDRTVDR2UWIyRkJhcERpZFlrQTRQTnVmUS9pRDkwOE1V?=
 =?utf-8?B?c3c3TUxmNFZuWHoybkw5ZHZBTUZLQmtCaEJQb3c3ZFpGRW0rU1FwUC9MeC93?=
 =?utf-8?B?TnRFbmlIYUlkalcwNUZscVJ4RVh5bkpIWVptampOWGI3cEtHMmFWOUVQNWNU?=
 =?utf-8?B?bDB1QXhmandHNHZkNUJ1SlhPSk4xdm5ET0dQb2UrU2hTZml1S1J6OVRZRTkx?=
 =?utf-8?B?MVVjZS9jNysvMTJOeU1TTlUzdGs0eGtJK24vcVExOU1jUlVSbDVDRnFYY0xE?=
 =?utf-8?B?KzFHaXBkWVlFUWs2SnZUcEVMZlBJUWlpV1ZsbHlwN2FaWk02WDZRb3Y5V0ha?=
 =?utf-8?B?TFBzaE8vQ2pkcE1lQjJkZXJyMUhjeExjV080a0YvTi9FcjBVZlRmQndLdmJ5?=
 =?utf-8?B?Zk9HRGs1MkYva1dtV1NRS2pLL1dERXg2MlYza2tPM0RQOUVBWE8zamMzZWxH?=
 =?utf-8?B?alE3ckdtWTlPY0Z0Y2tJb3pGWmFzNUJrdnEvTmRWNEQrR3J5RDhJc05rWWVw?=
 =?utf-8?B?MkRmWXlkQkIyR1hlSkNHb2IrbTI0bDduUGhHb1dwT0FZZit0anovZGVYWnNU?=
 =?utf-8?B?RndmNXpoVnN0dSt4RXBPZ053TWtNNnVNQnlRb0FPQmRveWk5eVhmSlc3aGx1?=
 =?utf-8?B?a3kxZ0x5UjZCbUowNGVmWWZMTUlxN0dNWnoxTlo4cE40OENpdGZZeHc0WDZL?=
 =?utf-8?B?OHF6OHRtS0k5NWNuL1VQYmRLcDNXOFZSNjFCVmRhNkhZVzQxcnp2VEhHcDY2?=
 =?utf-8?B?ZTdadW03STFQTTlhc1VsdlE4dlBTeGRyeVdUNUZYc1phdFJ2NUVaQ0RMekMv?=
 =?utf-8?B?Wm9yUkFnTVNHR2tUODlRV1MvLy80MDdER3d0NVdTRVJkdCtKM2ZMelB1cWl1?=
 =?utf-8?B?dG5UNVJrSk5PZGtZTklYTWdLU01oUlduNzlFaUFPTmtHQkJsTnFkZit6NGRs?=
 =?utf-8?B?TFRnYUJiOTNmYzRCT2s2ZitFNmtwcHN2ZGl0bmp0UHg3MjZNMFB5TzFndWpv?=
 =?utf-8?B?NUVybnAwZkNnbTVYeUVBeEdiRlRCbDBTZmpKeHRuM3VIcEJpVU9LMXhKQVg4?=
 =?utf-8?B?cjJ2OHdMVytKUXE1eTlUMHZ0YUdXYW9VOHZvVC9PdEhpLytWbFB1dEZwMWN2?=
 =?utf-8?B?RHA5VjQrN3IxVXJPV2RmdllyTkFXQkJza05EQVJXK2txczYwRG1yUnZJNmw0?=
 =?utf-8?B?UnI3L0xuUFpaT3Y2Q2lIdDVjUm1OT09lb2pvQmxlaWROdjNuRnFla1JjTnRT?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E4A537EA57A1D4FBB470C3D56DCFFDE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d48d7ba3-1c6a-4f83-a047-08dabe26423e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 05:34:35.5156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yg5W5DUDtQR/tkGtlqLXtfyZgEv+gGt3Brb+w5zkpUWVp1RPcoY8RzIDnXni6fZJ7kt2ZiMPqK2yRufZppNm9iAnaipcK061aQuTXgdJXAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6766
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTAzIGF0IDE3OjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFNvbWUgcmVnaW9ucyBtYXkgbm90IGhhdmUgYW55IGFkZHJlc3Mgc3BhY2UgYWxsb2NhdGVkLiBT
a2lwIHRoZW0gd2hlbg0KPiB2YWxpZGF0aW5nIEhQQSBvcmRlciBvdGhlcndpc2UgYSBjcmFzaCBs
aWtlIHRoZSBmb2xsb3dpbmcgbWF5IHJlc3VsdDoNCj4gDQo+IMKgZGV2bV9jeGxfYWRkX3JlZ2lv
bjogY3hsX2FjcGkgY3hsX2FjcGkuMDogZGVjb2RlcjMuNDogY3JlYXRlZA0KPiByZWdpb245DQo+
IMKgQlVHOiBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLCBhZGRyZXNzOiAwMDAwMDAw
MDAwMDAwMDAwDQo+IMKgWy4uXQ0KPiDCoFJJUDogMDAxMDpzdG9yZV90YXJnZXROKzB4NjU1LzB4
MTc0MCBbY3hsX2NvcmVdDQo+IMKgWy4uXQ0KPiDCoENhbGwgVHJhY2U6DQo+IMKgIDxUQVNLPg0K
PiDCoCBrZXJuZnNfZm9wX3dyaXRlX2l0ZXIrMHgxNDQvMHgyMDANCj4gwqAgdmZzX3dyaXRlKzB4
MjRhLzB4NGQwDQo+IMKgIGtzeXNfd3JpdGUrMHg2OS8weGYwDQo+IMKgIGRvX3N5c2NhbGxfNjQr
MHgzYS8weDkwDQo+IA0KPiBzdG9yZV90YXJnZXROKzB4NjU1LzB4MTc0MDoNCj4gYWxsb2NfcmVn
aW9uX3JlZiBhdCBkcml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jOjY3Ng0KPiAoaW5saW5lZCBieSkg
Y3hsX3BvcnRfYXR0YWNoX3JlZ2lvbiBhdCBkcml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jOjg1MA0K
PiAoaW5saW5lZCBieSkgY3hsX3JlZ2lvbl9hdHRhY2ggYXQgZHJpdmVycy9jeGwvY29yZS9yZWdp
b24uYzoxMjkwDQo+IChpbmxpbmVkIGJ5KSBhdHRhY2hfdGFyZ2V0IGF0IGRyaXZlcnMvY3hsL2Nv
cmUvcmVnaW9uLmM6MTQxMA0KPiAoaW5saW5lZCBieSkgc3RvcmVfdGFyZ2V0TiBhdCBkcml2ZXJz
L2N4bC9jb3JlL3JlZ2lvbi5jOjE0NTMNCj4gDQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9y
Zz4NCj4gRml4ZXM6IDM4NGU2MjRiYjIxMSAoImN4bC9yZWdpb246IEF0dGFjaCBlbmRwb2ludCBk
ZWNvZGVycyIpDQo+IFNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNA
aW50ZWwuY29tPg0KPiAtLS0NCj4gwqBkcml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jIHzCoMKgwqAg
MyArKysNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQoNCk1ha2VzIHNlbnNl
LA0KDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+
DQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jIGIvZHJpdmVy
cy9jeGwvY29yZS9yZWdpb24uYw0KPiBpbmRleCBiYjZmNGZjODRhM2YuLmQyNmNhN2E2YmVhZSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jeGwvY29yZS9yZWdpb24uYw0KPiArKysgYi9kcml2ZXJz
L2N4bC9jb3JlL3JlZ2lvbi5jDQo+IEBAIC02NTgsNiArNjU4LDkgQEAgc3RhdGljIHN0cnVjdCBj
eGxfcmVnaW9uX3JlZg0KPiAqYWxsb2NfcmVnaW9uX3JlZihzdHJ1Y3QgY3hsX3BvcnQgKnBvcnQs
DQo+IMKgwqDCoMKgwqDCoMKgwqB4YV9mb3JfZWFjaCgmcG9ydC0+cmVnaW9ucywgaW5kZXgsIGl0
ZXIpIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgY3hsX3JlZ2lv
bl9wYXJhbXMgKmlwID0gJml0ZXItPnJlZ2lvbi0+cGFyYW1zOw0KPiDCoA0KPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKCFpcC0+cmVzKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnRpbnVlOw0KPiArDQo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGlwLT5yZXMtPnN0YXJ0ID4gcC0+cmVzLT5zdGFydCkg
ew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXZf
ZGJnKCZjeGxyLT5kZXYsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAiJXM6IEhQQSBvcmRlciB2aW9sYXRpb24gJXM6JXBy
IHZzDQo+ICVwclxuIiwNCj4gDQoNCg==
