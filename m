Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EA847DF68
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 08:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346782AbhLWHPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 02:15:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:31067 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346776AbhLWHPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 02:15:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640243749; x=1671779749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3TINdcwllOdLlwsAbceL2VNIdUzunzPhfHyaT5b2OOg=;
  b=gMyFHDOe9blolEILwhtj40FJKPco4KsKY8aoEf8FT+M0cRXjImd1CZwA
   w4D0A/ErgCay7wLr+aPoQfvzIDd9CrlPJAWbDc8qDM1XgHlgci53H4D+a
   SzkZYIlCuTHstZYoQ4+r4O3W+JQ3y2QkpeF7Z2FjdJAdOcR/HLHkfRO4G
   MecEqGthhlFWZ1JK59ufCC+hDIPim6lT3Nxh896BUfPP0iVS8TlIirrX4
   kTHfec+cx/WCwr4DZ9ndhkmpCKTvKEAQZ1WD1gPy5MEz6ZkbIFrui5paM
   Hr3H0WoSLIgMA9Dk0r+AhDc2U5ou+Iy41ZiByxMaKgJhdCPCKkc13WVne
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="240725929"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="240725929"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 23:15:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="756673844"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 22 Dec 2021 23:15:48 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 23:15:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 22 Dec 2021 23:15:47 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 22 Dec 2021 23:15:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnfQmfHJbDPOTH+l8D2f5LJCdqGviaSYrgshNkjPWu/WIpM1BG5lzoWphSh5vUPdokcgIdrsRl32y/lQrAP54acMN+0gBClP4AWLPqel7Sol050F38Rs+pBFzGSpHOrCM0kW8Lx5f6lBnzQShuXcuWxP/jJlfOibBmD0E7ef8PGmErdWWj7vdXgJBEzUnsC3BSonH71uLOLfAhvOpynxGnsaf/9dudKMqC2LvAEMqyAb29gd139LQ35fhXtVJeE5Au3SqNO2EA+YpdYHfQgn20LycDaVqWi95y+6MBEsA0rK6tUSxiI2i2AvxAFbedUU43R6jCubgmyW0DHS+KGxhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TINdcwllOdLlwsAbceL2VNIdUzunzPhfHyaT5b2OOg=;
 b=n9hf1eeJJJcG9HKQquEtT3J1j4vNtk3ca3zq3MXHl8jUy+Enn15Y4jE1sg8cbbHuajhXytp5uiVTbcvVWyIEkZyBSeQ3RmnNJ5lZCu9yFcO3s/d4ET+oyXe3fcrRXbI61IiHFr36+tjrEoiNB5WwdHuxsHIqvmH/rJD5HYbvX+O9n6gQBIoE5qNfWLHj5b/O+e07mkHLzcmC6yViV2wlLZ1XhvFniqbBJFCKOODzE/5UXfQWQKJA28VLGFuchDPyE1C95vHTMWpa4p81+OkXLrc7qLnS9LPjvg5OY0d0qSGNR9/Y5BIvw1usFSk5NXpU8mSTak/6EcfBREVQlFWnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB2041.namprd11.prod.outlook.com (2603:10b6:3:d::7) by
 DM6PR11MB2953.namprd11.prod.outlook.com (2603:10b6:5:6a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.20; Thu, 23 Dec 2021 07:15:40 +0000
Received: from DM5PR11MB2041.namprd11.prod.outlook.com
 ([fe80::5156:fa52:a0ba:da2]) by DM5PR11MB2041.namprd11.prod.outlook.com
 ([fe80::5156:fa52:a0ba:da2%3]) with mapi id 15.20.4801.024; Thu, 23 Dec 2021
 07:15:40 +0000
From:   "Pawnikar, Sumeet R" <sumeet.r.pawnikar@intel.com>
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Pawnikar, Sumeet R" <sumeet.r.pawnikar@intel.com>
Subject: RE: [PATCH] thermal/drivers/int340x: add functions for mbox read and
 write commands
Thread-Topic: [PATCH] thermal/drivers/int340x: add functions for mbox read and
 write commands
Thread-Index: AQHX91R9RK9PaWj+xUSkYL/cLnVTQKw+uwKAgAAN4gCAAMtI0A==
Date:   Thu, 23 Dec 2021 07:15:40 +0000
Message-ID: <DM5PR11MB204144E3ECD2E9855E08BA2EBB7E9@DM5PR11MB2041.namprd11.prod.outlook.com>
References: <20211222165300.8222-1-sumeet.r.pawnikar@intel.com>
         <CAJZ5v0gyGsOjiFsw1FP4ZXP7yXNFwcjRtrbdR0Gov_xMFhYRew@mail.gmail.com>
 <a41970ea5e650f49dfa6470ee47110c1be8719a7.camel@linux.intel.com>
In-Reply-To: <a41970ea5e650f49dfa6470ee47110c1be8719a7.camel@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64186975-49bc-49c2-81c1-08d9c5e406f4
x-ms-traffictypediagnostic: DM6PR11MB2953:EE_
x-microsoft-antispam-prvs: <DM6PR11MB2953C95A7362DD7557857584BB7E9@DM6PR11MB2953.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZN8+BsSigwh9eNsdZS5I43eTAK8VUZUKHkgEobjGAMyc9rZDbEHCmc9paqdypuze+Fi7x4ZAuFg7Zbv4nzQ2OWbVpbGpYFhtXsxEum/jUpdvgybHkCUwQm7L+RlzeGtzFfxRyESd+RjMhIL/JCuGNv4goPiuM+Qp37ymHY8kwevGdWQhxLtKqpvm+S+DXnZ0B+D5d43VYMg0v3SXQUB5y7fBR0WqBK3jfNnsNOxVltdGb6GSLjDK9+0M5sdZFyT7FxryB61YIpsvwBVCyzbR/IJcDdL0DnvaYLb6F2ollOoCX7U206aXVtfKg6E3WwjMNEtiELaqUk5+TvFCuBOsx2EMt03GH0U3hM6PE+qlZLW5u/yuWd9cPNpGyQybnhRRW14FOM4FHEOL0zPynYbfugA0dUM2SRpx2kPEFjzLk+z0xGig1vq5dmvDNyrCWzxPPTwCWSDqFlIsM10daP0gmDP3zQOsPLy0Kcj5GHPWlc4Z/lDHPjqI6l4IlyHIbjD448UH0de5b/x7izsiVBn74dVkPoQAoFCsAjMxi+wPyjilV70nI6KSffBb+/zii8Lu9jOdgWJgKojF66nQU/WnHtqPnXv8a3PhBlBoQX19AbQ5vT9iTLC5nqFpE7Tm4B1zpiKDxLaZm6VE3Ic+ZUUYbF/PzZix3svM6FJfqxI/JlAs9pyCmwoQMV8k9H+AorDx4z4VVs0AYqEgchq0Z4LSM/FKv1n0zQa4FmjdvhzJfH8AwRhW8aLpsPXTTSqlHA+A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB2041.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(4326008)(26005)(6506007)(71200400001)(2906002)(186003)(86362001)(38070700005)(83380400001)(33656002)(55016003)(7696005)(9686003)(8936002)(38100700002)(8676002)(82960400001)(52536014)(5660300002)(4001150100001)(316002)(122000001)(110136005)(54906003)(66556008)(64756008)(66476007)(66446008)(66946007)(508600001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzNCTGlZd1VKTEM4SGhSankrMU9NcExERjEwVm01dUJYb1hjcGhsd0tNWnVM?=
 =?utf-8?B?VjRDTlJXZHV0dFd0UWthbnhCb2V1a1dncW50TzhpRHdiczdwQjJvbWl2WVZO?=
 =?utf-8?B?WklMK1lqNjNIMlNkalBxZWhRaDNMU1lRbVNoQnR5ZjJZb0pNWGMyYlNCd2NV?=
 =?utf-8?B?T0JjcjFMK2Z4UmswaVl1L0w2d0VTMXkzbDlTeFB1U2s5dlBML1h0NkhuRDdT?=
 =?utf-8?B?U1NYelJGcXRiMSsrZVRiTU1GUDBqdzdtVXBpVUo3Y3FXeVRWcnpFc25ucmFN?=
 =?utf-8?B?c21lN0tsU0NyTkhUMUlpSU9GdkRqaEdRNHBpdG5OM1VWMGJSdDZhRTZUamhC?=
 =?utf-8?B?ZzFrTzduSDI1bWcxRWtXUllhcmZGb1JNQksza2hISDhNQnVRU2I3blVac2dw?=
 =?utf-8?B?cXhRYlF6NGZ6bFhLeVFHZFd5enY0M2x5aXZpY3JkWkFOQnE3Qm9zSUFJMFFn?=
 =?utf-8?B?c1ZnNGVQZjlqTW5QOGNOL2hPZk9zUEgva2hyY00vT1YwNTRCcHdadHJLZzF1?=
 =?utf-8?B?VHM3cndZQWI5QU5XRnM1Nk9jazBIWElrUjBaSHpIU1gvYzl6dVE5RHdWMkR3?=
 =?utf-8?B?Q0x0dithUWRBVXZyL3YxNSt5dkpycGllM2JjQUVuVEVFdTRkNWhRRmt6ZkRT?=
 =?utf-8?B?am9PcUIyZk5kTDBVdGh6TTFtenZaSFJQcXlyRGFSZ3JhdmxMejBWWG9rTHAy?=
 =?utf-8?B?RDhSRXUrVXM5eXI5bkFrU2VWVlFRNU9wZmZqMDdoOWpkSys0ejdFVEdvRVp3?=
 =?utf-8?B?ODlYOStpQ1RCNjl3R0lXbFY5L0UwblUzMisvY1NjaUp1WnJOdjgxWTVLek1Y?=
 =?utf-8?B?YVVqb3pnZFNtb1BLa2ptdjJ4TElXelRNcUtWbTJ6S1NjZFFJTGxBYmtQcjU3?=
 =?utf-8?B?b3hydHVsaXJDeUVhTHhzZUcrUVlCME1vaU5Icy9lUXMwc0FxNktLVHRwdEdr?=
 =?utf-8?B?YWVERHhOdmZ1Vm5DdEhJcE8wdG9qWTNSTHlqcHpuV3hSak9KeW1ONEV4aHlq?=
 =?utf-8?B?UHpVZ2ZueUxuRXJ0VUcxZGVSbVhLVnJMTlhDeTBoVnNSWkU5WTdjR1cxNnVv?=
 =?utf-8?B?YXBWeWtuNlM1OFU5WFQrZEtoRE5YSnFxM0J2azcwUHdRQTZPZ1lnTGxibmRn?=
 =?utf-8?B?bG9XNGtFV1JBTTY0SU9UQURBa1dlTVB6ZnNsRHJpemxPdC84bnVhNHRZaTli?=
 =?utf-8?B?Wk9jVzNneThLMXNFa3l6UDM4V1dMbHRJMzFscHZUMTY4MlZTbjUxeXU1dTlk?=
 =?utf-8?B?dW9sVVBXLzZzZ0JOSlcvNzB6OUIzV2RlWVV3aUNheUg2SURtVmJNT3dvcjBM?=
 =?utf-8?B?NHRaMDhReCtwRFVkdmxBTmsrblBEenAzbXFJWkdBV2tpTWduTiszOUFKQWRF?=
 =?utf-8?B?bGphQkNoeE4ydG5JdW1NMXVOZVQrR1lpbEs5OUprWE9Ja0xvNllmMWgvZkRR?=
 =?utf-8?B?SVVPSWo0VHFkUXlVRXFkdWs1K3lucEdNS0xmTy9aUXJQZGlYcWlacy9xc3hj?=
 =?utf-8?B?aU5PR1VBeksvV0o5Tm5NenMrM1BScjVPMWhTRnVlM0s2Y1NGckw2MklkbU1U?=
 =?utf-8?B?N1l4azZkbnM2aGtUVCtvb1BRd1dPRVZ3NFBKaGJEVjFIUW9oaGl4OUR6WUgz?=
 =?utf-8?B?VTEyRGhLamZ1bHJKUXltYm5LTGZVTXkxbytVbnA3SElvc3VIZnlLbWlXQXBq?=
 =?utf-8?B?NW04ajhuTFNOWXFMRG9vTmg0bEtDbDlTZjI0blNqMWRGM2ZRV3F3TDJKMHFH?=
 =?utf-8?B?a1N4WThOMnlVVFR0M1Z4TXVkWUdIZE1HSVVkeGFsZGtwbVBJMzM3dFQ4bjZG?=
 =?utf-8?B?NFRNTmY5MzdGbW5jQXBUZnlBMnNKQml2SnBNczhwQUMxZndMWkdJa0VvY2cw?=
 =?utf-8?B?WDkrYmJZUTBFMVVBejNQNzlVcmI1TWhaK3dTQ1M5ci81NTVab0FuMTNPRVVn?=
 =?utf-8?B?R1JlakQrcjA5bXVUdXppdXQxZGlxK3NBcTJqazJQNG5XekF0S3gvamlDeXpR?=
 =?utf-8?B?QUV1Nkw1TExBR2RrM1dUOGxOdmNCdHdrb1JzbWpDUUFiQkE2ZXFKZ0VKd1ZH?=
 =?utf-8?B?Wng2SWZDeDM4Kzh4WUJxVzBXOHhnN1ZCYUdZYmRVMHFjaXRScGJqRXNxbGp4?=
 =?utf-8?B?UFV3VHNxWmdKUE9jcHloWW1kd29sb1NPSWxhTXptUGtlZ3Z4R2x6ZlQvVm5o?=
 =?utf-8?B?bnd3aC95cVZZNnZuY015M24yMXZLNVduY2l0ZlZEYmRIdTFLNEE4dmFmcXFV?=
 =?utf-8?B?dUUyUjlmVk9IelZKdU8zYjRYOHhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB2041.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64186975-49bc-49c2-81c1-08d9c5e406f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2021 07:15:40.8259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B+WdjzXxYUQYjNmIqI0cKJnlh1NRa+JGyz6PS8mo5c/S7Ub6hDHZt7URg0yW9QpzYepOdCzCJ1I6H6gScPELSNNa22QojSwLGvFWjdIXm4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2953
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogc3Jpbml2YXMgcGFuZHJ1
dmFkYSA8c3Jpbml2YXMucGFuZHJ1dmFkYUBsaW51eC5pbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgRGVjZW1iZXIgMjIsIDIwMjEgMTE6MTYgUE0NCj4gVG86IFJhZmFlbCBKLiBXeXNvY2tp
IDxyYWZhZWxAa2VybmVsLm9yZz47IFBhd25pa2FyLCBTdW1lZXQgUg0KPiA8c3VtZWV0LnIucGF3
bmlrYXJAaW50ZWwuY29tPg0KPiBDYzogRGFuaWVsIExlemNhbm8gPGRhbmllbC5sZXpjYW5vQGxp
bmFyby5vcmc+OyBMaW51eCBQTSA8bGludXgtDQo+IHBtQHZnZXIua2VybmVsLm9yZz47IExpbnV4
IEtlcm5lbCBNYWlsaW5nIExpc3QgPGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnPjsg
U3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSB0
aGVybWFsL2RyaXZlcnMvaW50MzQweDogYWRkIGZ1bmN0aW9ucyBmb3IgbWJveCByZWFkDQo+IGFu
ZCB3cml0ZSBjb21tYW5kcw0KPiANCj4gT24gV2VkLCAyMDIxLTEyLTIyIGF0IDE3OjU2ICswMTAw
LCBSYWZhZWwgSi4gV3lzb2NraSB3cm90ZToNCj4gPiBPbiBXZWQsIERlYyAyMiwgMjAyMSBhdCA1
OjUzIFBNIFN1bWVldCBQYXduaWthcg0KPiA+IDxzdW1lZXQuci5wYXduaWthckBpbnRlbC5jb20+
IHdyb3RlOg0KPiA+ID4NCj4gPiA+IFRoZSBleGlzdGluZyBtYWlsIG1lY2hhbmlzbSBvbmx5IHN1
cHBvcnRzIHdyaXRpbmcgb2Ygd29ya2xvYWQgdHlwZXMuDQo+ID4gPiBCdXQgbWFpbGJveCBjb21t
YW5kIGZvciBSRklNIChjbWQgPSAweDA4KSBhbHNvIHJlcXVpcmVzIHdyaXRlDQo+ID4gPiBvcGVy
YXRpb24gd2hpY2ggd2FzIGlnbm9yZWQuIFRoaXMgcmVzdWx0cyBpbiBmYWlsaW5nIHRvIHN0b3Jl
IFJGSQ0KPiA+ID4gcmVzdHJpY3Rpb24uDQo+ID4gPiBUaGlzIHJlcXVpcmVzIGVuaGFuY2luZyBt
YWlsYm94IHdyaXRlcyBmb3Igbm9uIHdvcmtsb2FkIGNvbW1hbmRzDQo+ID4gPiBhbHNvLg0KPiA+
ID4gU28sIHJlbW92ZSB0aGUgY2hlY2sgZm9yIE1CT1hfQ01EX1dPUktMT0FEX1RZUEVfV1JJVEUg
aW4NCj4gbWFpbGJveA0KPiA+ID4gd3JpdGUsIHdpdGggdGhpcyBvdGhlciB3cml0ZSBjb21tYW5k
cyBhbHNvIGNhbiBiZSBzdXBvb3J0ZWQuIEJ1dCBhdA0KPiA+ID4gdGhlIHNhbWUgdGltZSwgd2Ug
aGF2ZSB0byBtYWtlIHN1cmUgdGhhdCB0aGVyZSBpcyBubyBpbXBhY3Qgb24gcmVhZA0KPiA+ID4g
Y29tbWFuZHMsIGJ5IG5vdCB3cml0aW5nIGFueXRoaW5nIGluIG1haWxib3ggZGF0YSByZWdpc3Rl
ci4NCj4gPiA+IFRvIHByb3Blcmx5IGltcGxlbWVudCwgYWRkIHR3byBzZXBhcmF0ZSBmdW5jdGlv
bnMgZm9yIG1ib3ggcmVhZCBhbmQNCj4gPiA+IHdyaXRlIGNvbW1hbmQgZm9yIHByb2Nlc3NvciB0
aGVybWFsIHdvcmtsb2FkIGNvbW1hbmQgdHlwZS4gVGhpcw0KPiA+ID4gaGVscHMgdG8gZGlmZmVy
ZW50aWF0ZSB0aGUgcmVhZCBhbmQgd3JpdGUgd29ya2xvYWQgY29tbWFuZCB0eXBlcw0KPiA+ID4g
d2hpbGUgc2VuZGluZyBtYm94IGNvbW1hbmQuDQo+ID4gPg0KPiA+ID4gRml4ZXM6IDVkNmZiYzk2
YmQzNiAoInRoZXJtYWwvZHJpdmVycy9pbnQzNDB4OiBwcm9jZXNzb3JfdGhlcm1hbDoNCj4gPiA+
IEV4cG9ydCBhZGRpdGlvbmFsIGF0dHJpYnV0ZXMiKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogU3Vt
ZWV0IFBhd25pa2FyIDxzdW1lZXQuci5wYXduaWthckBpbnRlbC5jb20+DQo+ID4gPiBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZ8KgIyA1LjE0Kw0KPiA+DQo+ID4gVGhpcyByZXF1aXJlcyBhbiBB
Q0sgZnJvbSBTcmluaXZhcy4NCj4gDQo+IEkgZm91bmQgc29tZSBtb3JlIGlzc3VlcyBpbiB0aGlz
IHBhdGNoIGFmdGVyIG15IHByaW9yIGludGVybmFsIHJldmlldy4NCj4gDQo+IDEuIFN1YmplY3Qg
b2YgcGF0Y2ggc2hvdWxkIGJlIHdoYXQgaXMgdGhpcyBwYXRjaCBmb3IgcmF0aGVyIHRoYW4gaG93
Lg0KPiBTb21ldGhpbmcgbGlrZToNCj4gRml4IFJGSU0gbWFpbGJveCB3cml0ZSBjb21tYW5kcw0K
PiANClN1cmUsIGxldCBtZSBmb2xsb3cgdGhpcy4gDQoNCj4gMi4gVGhlcmUgaXMgb25lIGlzc3Vl
IGluIHRoZSBjb2RlIGJlbG93Lg0KPiANCj4gPg0KPiA+ID4gLS0tDQo+ID4gPg0KPiANCj4gWy4u
Ll0NCj4gDQo+ID4gPiArc3RhdGljIGludCBzZW5kX21ib3hfcmVhZF9jbWQoc3RydWN0IHBjaV9k
ZXYgKnBkZXYsIHUxNiBpZCwgdTMyDQo+ID4gPiBkYXRhLCB1NjQgKnJlc3ApDQo+IFRoZXJlIGlz
IG5vIHVzZSBvZiAiZGF0YSIgYXJndW1lbnQgZm9yIHJlYWQgIGFmdGVyIHNwaWx0IG9mIHJlYWQg
YW5kIHdyaXRlDQo+IGNvbW1hbmRzLCBpZiB5b3UgbG9vayBhdCB0aGUgY29kZSBiZWZvcmUuDQo+
IA0KWWVzLCBJIHdpbGwgdXBkYXRlIGFjY29yZGluZyB0byB0aGlzLiANCg0KPiA+ID4gK3sNCj4g
PiA+ICvCoMKgwqDCoMKgwqAgc3RydWN0IHByb2NfdGhlcm1hbF9kZXZpY2UgKnByb2NfcHJpdjsN
Cj4gPiA+ICvCoMKgwqDCoMKgwqAgdTMyIHJlZ19kYXRhOw0KPiA+ID4gK8KgwqDCoMKgwqDCoCBp
bnQgcmV0Ow0KPiA+ID4NCj4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICgh
Y21kX3Jlc3ApDQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgYnJlYWs7DQo+ID4gPiArwqDCoMKgwqDCoMKgIHByb2NfcHJpdiA9IHBjaV9nZXRfZHJ2
ZGF0YShwZGV2KTsNCj4gPiA+DQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoY21kX2lkID09IE1CT1hfQ01EX1dPUktMT0FEX1RZUEVfUkVBRCkNCj4gPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqY21kX3Jlc3AgPSByZWFkbCgo
dm9pZCBfX2lvbWVtICopDQo+ID4gPiAocHJvY19wcml2LT5tbWlvX2Jhc2UgKyBNQk9YX09GRlNF
VF9EQVRBKSk7DQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbHNlDQo+ID4g
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKmNtZF9yZXNw
ID0gcmVhZHEoKHZvaWQgX19pb21lbSAqKQ0KPiA+ID4gKHByb2NfcHJpdi0+bW1pb19iYXNlICsg
TUJPWF9PRkZTRVRfREFUQSkpOw0KPiA+ID4gK8KgwqDCoMKgwqDCoCBtdXRleF9sb2NrKCZtYm94
X2xvY2spOw0KPiA+ID4NCj4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFr
Ow0KPiA+ID4gLcKgwqDCoMKgwqDCoCB9IHdoaWxlICgtLXJldHJpZXMpOw0KPiA+ID4gK8KgwqDC
oMKgwqDCoCByZXQgPSB3YWl0X2Zvcl9tYm94X3JlYWR5KHByb2NfcHJpdik7DQo+ID4gPiArwqDC
oMKgwqDCoMKgIGlmIChyZXQpDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBn
b3RvIHVubG9ja19tYm94Ow0KPiA+ID4gKw0KPiA+ID4gK8KgwqDCoMKgwqDCoCB3cml0ZWwoZGF0
YSwgKHByb2NfcHJpdi0+bW1pb19iYXNlICsgTUJPWF9PRkZTRVRfREFUQSkpOw0KPiBUaGUgYWJv
dmUgaXMgbm90IHJlcXVpcmVkIGZvciByZWFkLiBUaGlzIGlzIHdoYXQgd2Ugd2FudGVkIHRvIGF2
b2lkIGZvcg0KPiByZWFkcy4NCj4gDQpMZXQgbWUgcmVtb3ZlIHRoaXMgYW5kIHRlc3QgbmV3IGNo
YW5nZXMgYW5kIHBvc3QgVjIgZm9yIHJldmlldy4NCg0KVGhhbmtzLA0KU3VtZWV0Lg0KDQo+IFRo
YW5rcywNCj4gU3Jpbml2YXMNCj4gDQo+ID4gPiArwqDCoMKgwqDCoMKgIC8qIFdyaXRlIGNvbW1h
bmQgcmVnaXN0ZXIgKi8NCj4gPiA+ICvCoMKgwqDCoMKgwqAgcmVnX2RhdGEgPSBCSVRfVUxMKE1C
T1hfQlVTWV9CSVQpIHwgaWQ7DQo+ID4gPiArwqDCoMKgwqDCoMKgIHdyaXRlbChyZWdfZGF0YSwg
KHByb2NfcHJpdi0+bW1pb19iYXNlICsNCj4gPiA+IE1CT1hfT0ZGU0VUX0lOVEVSRkFDRSkpOw0K
PiA+ID4gKw0KPiA+ID4gK8KgwqDCoMKgwqDCoCByZXQgPSB3YWl0X2Zvcl9tYm94X3JlYWR5KHBy
b2NfcHJpdik7DQo+ID4gPiArwqDCoMKgwqDCoMKgIGlmIChyZXQpDQo+ID4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIHVubG9ja19tYm94Ow0KPiA+ID4gKw0KPiA+ID4gK8Kg
wqDCoMKgwqDCoCBpZiAoaWQgPT0gTUJPWF9DTURfV09SS0xPQURfVFlQRV9SRUFEKQ0KPiA+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKnJlc3AgPSByZWFkbChwcm9jX3ByaXYtPm1t
aW9fYmFzZSArDQo+ID4gPiBNQk9YX09GRlNFVF9EQVRBKTsNCj4gPiA+ICvCoMKgwqDCoMKgwqAg
ZWxzZQ0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKnJlc3AgPSByZWFkcShw
cm9jX3ByaXYtPm1taW9fYmFzZSArDQo+ID4gPiBNQk9YX09GRlNFVF9EQVRBKTsNCj4gPiA+DQo+
ID4gPiDCoHVubG9ja19tYm94Og0KPiA+ID4gwqDCoMKgwqDCoMKgwqAgbXV0ZXhfdW5sb2NrKCZt
Ym94X2xvY2spOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4gPiA+IMKgfQ0K
PiA+ID4NCj4gPiA+IC1pbnQgcHJvY2Vzc29yX3RoZXJtYWxfc2VuZF9tYm94X2NtZChzdHJ1Y3Qg
cGNpX2RldiAqcGRldiwgdTE2DQo+ID4gPiBjbWRfaWQsIHUzMiBjbWRfZGF0YSwgdTY0ICpjbWRf
cmVzcCkNCj4gPiA+ICtpbnQgcHJvY2Vzc29yX3RoZXJtYWxfc2VuZF9tYm94X3JlYWRfY21kKHN0
cnVjdCBwY2lfZGV2ICpwZGV2LA0KPiB1MTYNCj4gPiA+IGlkLCB1MzIgZGF0YSwgdTY0ICpyZXNw
KQ0KPiA+ID4gwqB7DQo+ID4gPiAtwqDCoMKgwqDCoMKgIHJldHVybiBzZW5kX21ib3hfY21kKHBk
ZXYsIGNtZF9pZCwgY21kX2RhdGEsIGNtZF9yZXNwKTsNCj4gPiA+ICvCoMKgwqDCoMKgwqAgcmV0
dXJuIHNlbmRfbWJveF9yZWFkX2NtZChwZGV2LCBpZCwgZGF0YSwgcmVzcCk7DQo+ID4gPiDCoH0N
Cj4gPiA+IC1FWFBPUlRfU1lNQk9MX0dQTChwcm9jZXNzb3JfdGhlcm1hbF9zZW5kX21ib3hfY21k
KTsNCj4gPiA+ICtFWFBPUlRfU1lNQk9MX05TX0dQTChwcm9jZXNzb3JfdGhlcm1hbF9zZW5kX21i
b3hfcmVhZF9jbWQsDQo+ID4gPiBJTlQzNDBYX1RIRVJNQUwpOw0KPiA+ID4gKw0KPiA+ID4gK2lu
dCBwcm9jZXNzb3JfdGhlcm1hbF9zZW5kX21ib3hfd3JpdGVfY21kKHN0cnVjdCBwY2lfZGV2ICpw
ZGV2LA0KPiA+ID4gdTE2IGlkLCB1MzIgZGF0YSkNCj4gPiA+ICt7DQo+ID4gPiArwqDCoMKgwqDC
oMKgIHJldHVybiBzZW5kX21ib3hfd3JpdGVfY21kKHBkZXYsIGlkLCBkYXRhKTsgfQ0KPiA+ID4g
K0VYUE9SVF9TWU1CT0xfTlNfR1BMKHByb2Nlc3Nvcl90aGVybWFsX3NlbmRfbWJveF93cml0ZV9j
bWQsDQo+ID4gPiBJTlQzNDBYX1RIRVJNQUwpOw0KPiA+ID4NCj4gPiA+IMKgLyogTGlzdCBvZiB3
b3JrbG9hZCB0eXBlcyAqLw0KPiA+ID4gwqBzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IHdvcmts
b2FkX3R5cGVzW10gPSB7IEBAIC0xMDQsNyArMTI2LDYgQEANCj4gPiA+IHN0YXRpYyBjb25zdCBj
aGFyICogY29uc3Qgd29ya2xvYWRfdHlwZXNbXSA9IHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgIE5V
TEwNCj4gPiA+IMKgfTsNCj4gPiA+DQo+IA0KDQo=
