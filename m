Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C986255F082
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 23:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiF1VrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 17:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiF1VrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 17:47:06 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5B82CDE0;
        Tue, 28 Jun 2022 14:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656452824; x=1687988824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Yv1lA/FTCRIV9SE+OY3RJmhwnqYWl73YLB01XswsIa8=;
  b=EQj0CZt7xuT3PosIH4L6J/G2yOoVfLL3ns1fYj7wBTBcHSUUPJEiqG+P
   WMxE3t1/1SgYQoT+8T+0lwXsCn5LTy0kT9bfZWHru0UOnpnfY2Rg4wlm6
   VRvM16GlADgHgzIypGDGIKCok/Ss4W23fmWDr5BXUrVXkN6BjYkQY/lE3
   ApcwQ1W+rlcpG2LxPGIa4LuGhQt4XK4GYegnn6ZTbjZne6qQmQkoHU8qK
   3fUC0PNvA/NiIP0cZ2AbMIwA769GmfvyexjujQIH+GBzp52EDLWjzIXjL
   3mRp0+czXrXqvkvimdsT96G0+yYf+GXIJWGJuzRRVeqOE6BpKeHOWzU+S
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280617501"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280617501"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 14:47:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767315699"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 14:47:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 14:47:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 14:47:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 14:46:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b39DcUSpc4JoMey3kDzbMPnMxsPSEqz0X9ytkUC3qJ1br+q1UbV+0S5nplcurYA8rJCjSB9ZCucu8cY8hTeHNxO1XHekgB4Rx8y3osyFYDck2cCZAqf0YVajv1HH+jtMNnk0aBQDkDlrqIxmVPPFcs0gGpQHypwLj71TjO83mzBfGituyLkldVEHgPDaUqhjrlGP8iLXuIr5SQrBVica4ezxuN4ks9RNsXjEFzBThWI9Fhnr7fYHpQuftB1c7RIQQs6qbx6tU+zDBiLSkmOxT+Tk9Es6/68ezddMXPpen433Px8Y9hMwPHWjUHVogvFn2BvxIGFDt/FRRPH6ZgLmfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yv1lA/FTCRIV9SE+OY3RJmhwnqYWl73YLB01XswsIa8=;
 b=i/idMiGt83bkL0AR5XK22ha9q4yhYWR0/U9MzW3ygZ+U1DIsVw/PORBzP7vYeicxYB93iyA5Xw2woIJyYV9bH6EjjASkZVhcVl8hIl5y96qSb7ABo/KCwdZbf9NAGuJBBZgIpZNUQs+dvTKHhtpq8rPY+8D//d9Wt1841X0cOPB+NvTz+J6S677XWFQiKDYIbveklnTbVN/oLLyyAjQjPmlPTqdlqELUEaL3N4oIOrh7Xr9UluFYgSSaMAyOOQMa9zB7oD9xaYCyjEJXFV6zPWbSsKPof/759uQTrb/ay/3EcOEgUNRTXXXDU15ARnRu+jDRqMkhPYjidXVofHH7wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 21:46:48 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5373.022; Tue, 28 Jun 2022
 21:46:48 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Schofield, Alison" <alison.schofield@intel.com>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Cs, Abhi" <abhi.cs@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH] cxl/mbox: Fix missing variable payload checks in cmd size
 validation
Thread-Topic: [PATCH] cxl/mbox: Fix missing variable payload checks in cmd
 size validation
Thread-Index: AQHYiypUiUrQm/OV7EW6nyE84Lak261lWbQAgAABGIA=
Date:   Tue, 28 Jun 2022 21:46:48 +0000
Message-ID: <bb3eea9a46c1cfb28d20c6f253ac5c8bd13e8412.camel@intel.com>
References: <20220628200427.601714-1-vishal.l.verma@intel.com>
         <20220628214252.GA1578802@alison-desk>
In-Reply-To: <20220628214252.GA1578802@alison-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.2 (3.44.2-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 749f050b-abc9-4c0c-94d8-08da594fb448
x-ms-traffictypediagnostic: MN2PR11MB4760:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y2R4c3mkFDwAEkdY4SzG8NFqKdlJSDSoRRiTxcLVX43v5drOZ4xR5VSqi0aFyjNRqz7Ac81Qim1d1rZB0xQxBfbDQXkdS88SqT1Dsdyh5PO9clytrZU6EcRskqTj2WFdBaDdlL6cgkC9WMpi9EUD7/q8oe4Y+KORGjxOWQAKRNUnlykbnjanCM7VvkMp9wKP7dy4wKcq4A0daYH6enht+0TKzLS3JBLwnFA62i4COq720SlwZLkQKZ3wrKlMaDmpkq5Ih6PzPRUZDwHklwWbNeQ1B3aFXWyDEFhfPqykN/uGM/BTUTgsd7qF9jBzm9XesdkpBXplZJ2VgSBc7lSHi3o9qGGUQjqES1qBEU/lY+on/DnyK4wVn/9CK2JerT05iOZGEN5bORJ8+1kO8mc5pPzZTwzLuG9LiZ7xUA8p8dJzteovH3qtQ42g2x4UvzQ9wPFRj1SyH+mqVqkgCUXcLqYgWSk4LN2v4qacM6dcH95W2Lzn9a8cLPBlILTwj/dPBKTHE0wQm0tblZv7BfETKm4FqfpmmHpNWXZM+xt/byKb5Radrv4SUZ44NKr0a9SM8PnbQWJSKBbN5Hp0f9S6+wUzAla+qyftt1Jw6JHqL8TkFrRuA55TRF/4rb2CTDneM9GJmDq5OyPm7Znuo2t7Tkm32ZOF63tsQ5y7Zmx7Ce/6GyTUrbaVua1xI7b+i0l5eig5HnGICqgBXjxiKlzkDLed9fgclho3M5C00UBFWyQ0AamyEpGjmJALeBXS7dCdc+l645GzqN0yzOWZAXa0/0TEZ71+vAWAGvgQY5aXkl4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(396003)(376002)(136003)(86362001)(71200400001)(4326008)(91956017)(54906003)(83380400001)(66556008)(8676002)(76116006)(6506007)(478600001)(66946007)(8936002)(82960400001)(64756008)(26005)(450100002)(38070700005)(6512007)(6486002)(66446008)(36756003)(66476007)(122000001)(5660300002)(107886003)(41300700001)(37006003)(38100700002)(6636002)(2906002)(316002)(186003)(2616005)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2NqT1ZTcUNqVXVITTVUYS9rQ1hOSkF6OFc3RjBObExMOGZ2MUdnZ1V1bXBa?=
 =?utf-8?B?YjgyWHl1MmNyaGRYM2lOaE1Cd1U0OHBjeDVrZGdBZjFZWXVJeFhnakFnbFpM?=
 =?utf-8?B?MEFRcGtXanlybHdzRWpRelZVREIvV09PSGV0Vml1SDZaT1RMUExza0FwdVE1?=
 =?utf-8?B?WWZ3Mk84WVRxNHBWM2NIeTBtT1NSekRrR3VydzFpMEJnZWk2MU1RdnZLVGJl?=
 =?utf-8?B?UjdoV1dyY2RBS0tzWW5tbytIOTJiekdDTjY3L01yYVlmK1prZEpUNDUzOHhD?=
 =?utf-8?B?SEdESnZ5V2JOSGw3NUZOWGpHN242ZzQ0MDBpWUNqN2QxSmVSa2dCWHdORVhQ?=
 =?utf-8?B?UXlMTXdoQkdUSWZFK2MzcWlnR2N5c3diUTQxaTFRd2tDeW1GVEplb0NadGJN?=
 =?utf-8?B?MzJzcEpTcHU2bVV2VnNLc3drOWRlUTlSRVpXYjk5cVpxM2liZkxvMGU5RVlx?=
 =?utf-8?B?S0pHM3ZMZnRzUktCKzYwditSWS9VUUhHUjZhOWdUcmFONlBFRlhZRG5wM1dh?=
 =?utf-8?B?WXQ2bHBSNVl5V3FFQkRxN2Z2ZXVxTEtJUE9oWVBlTlREV1VBV2JjWjRkc3Vu?=
 =?utf-8?B?Q1pHV093T25tQ0ZKSm9GZmdPcHlNa1RzVjcvaTBNK3A5ZFIrellCZkxVZ2lp?=
 =?utf-8?B?bFBjMWhVWVNkOEpZNkt2emlNYnE2Z3h2S1hsNi9KWitHbXluRkE4dUpBWEJZ?=
 =?utf-8?B?dG5RM0REZGM0RzE4UzhoeVpYdWkwanB4K2JtMlRzWVJLMUtXd1NDK1hNTGhT?=
 =?utf-8?B?WEd1TmpPS3R5V2NoZmNlZWVyelN1UklRcE9ZR2hyMm9hNUF3Wk11b1UwZFhT?=
 =?utf-8?B?aStVVElmWmJUUmRGNHZpZWZ3NEZXZU9FeThvUFZVZi9UUzZ1U3V4dy83VUJx?=
 =?utf-8?B?MGc1TUJrN1MyR3c5cW14N3FuZTJDV0VadG1WakJHZzlKRHlhT25GZUhUMGxu?=
 =?utf-8?B?eVJTRlZEajZUa0JkQ25sQW1yTDB0YzZKLy9pNGVsczV5eWNkaGc2Zk9ISjN4?=
 =?utf-8?B?dFFkbk5tSHdmd1laSU9NNmp3ZDZEb3l2TWFHTkZQY2ZqN2hJTE1zSUJsckxX?=
 =?utf-8?B?aEVIR3h1aVljWk1YVitPSUVlNnJaZ3Nybkx2bU5NamdMQ09wcC9pc3NvL1J6?=
 =?utf-8?B?TjJmOWRodk8xOEs0RlNrc2hsOUxSVDBuaE9GeVIrcGhUdWFYTUFqbUJnRC9O?=
 =?utf-8?B?ckttTDdScGpGbm8yaGJwMWFzOEVWSkc2QnJaTDc4MzA2RHAralJMM01WRjJZ?=
 =?utf-8?B?OGFJVXpCbWFrYURGTk1UbkxKallHZVhKYy93NGtxOVdoMTFzSUZRLzh5d2dp?=
 =?utf-8?B?T3c0TlJsVVYrcmVRUTlmL0tuTTZ4ZFJEYVI0VEIyV3JqY3BWY0Z4NnVzQTdO?=
 =?utf-8?B?dTBabHhEOXN3dkljTUJNOE1TVHlNbEo2NkhpTWZsb2w2Z0RxR0dkcFhOQTVi?=
 =?utf-8?B?d3RmUmFEdE95bGZxOG9zQ25ma0htWms5c2tlMjdjaTNkUTkxT2JiRUg1b0Rs?=
 =?utf-8?B?ejYrU0hpNjdnVXY2b2NzK0d6Y002OUxSdUN2eS9lL3pidTFxMXNuaDJYZW0y?=
 =?utf-8?B?NmNMQm5uanZ0YjYvb3ZLekh5WFF2RVhKak5Dc0tPWjlLSHFyUWtpMGFCL3NU?=
 =?utf-8?B?TmprZUJGYjg5TFMrd3VlRm8vZXo4U1JrQlFmb2xtdDROQlFtY0lWLzVPMU1j?=
 =?utf-8?B?N1FoUjU3UzZ0TlhHSTd1VG9UZFVQdXRtQ2d2NHJ2ZHJocnUrdU9LRnE3TnVP?=
 =?utf-8?B?b1JZSXlqUXNtN2IwTXcrNXZyd0dFSFA4ODZEaHlsd3BGZlFwTS9FRlFxMisv?=
 =?utf-8?B?ZG42WGQwckhNUzZsTFMxYVl3d1BtaDFvNnZKRTM5THQ2NkxyOVF6RlBHcnlZ?=
 =?utf-8?B?ZGFyazNuKzJrUjVlQjA5SHprRTF5anBXS2xWZzhXbFJmT3AycVpFZVUyUnMy?=
 =?utf-8?B?dUsrZXRKd3BCbFFscHNMNEYwVWxWYlMyUGRzK2l2bHFXSzVEWEpvcThVMGRM?=
 =?utf-8?B?VkhwS1F6ZWNVZVlSYUJ6TVFEZGEzVDRrTGpMZG9RL2xKR3lxcnVhRmRSUThB?=
 =?utf-8?B?MWd2VUo4ZFFqbmtWMEU1L1RuVXYxVFZYN09zbWl4TmtkS2hNYm1NUzFJdnNz?=
 =?utf-8?B?TTlwSzErdUx3UkhSaUJqZkxlQytRSXNLdm9IMWxYeHZkSEFaK3FuTGdES1F0?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50842F8AEAB22C4FBE4F62F634ADA8C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749f050b-abc9-4c0c-94d8-08da594fb448
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 21:46:48.7821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RfKMFwwuqUT2WNCuIJ9YRTOaRLXIOXtzMl2AjwsCamJ8Z+0s4ghcnEx9g20s/VMNBd+B+mOSlTy7W3T4jCkTC8SDNlDnDXlqONoCzQS1X2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTI4IGF0IDE0OjQyIC0wNzAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBPbiBUdWUsIEp1biAyOCwgMjAyMiBhdCAwMTowNDoyN1BNIC0wNzAwLCBWaXNoYWwgVmVy
bWEgd3JvdGU6DQo+ID4gVGhlIGNvbnZlcnNpb24gb2YgY29tbWFuZCBzaXplcyB0byB1bnNpZ25l
ZCBtaXNzZWQgYSBjb3VwbGUgb2YNCj4gPiBjaGVja3MNCj4gPiBhZ2FpbnN0IHZhcmlhYmxlIHNp
emUgcGF5bG9hZHMgZHVyaW5nIGNvbW1hbmQgdmFsaWRhdGlvbiwgd2hpY2gNCj4gPiBtYWRlIGFs
bA0KPiA+IHZhcmlhYmxlIHBheWxvYWQgY29tbWFuZHMgdW5jb25kaXRpb25hbGx5IGZhaWwuIEFk
ZCB0aGUgY2hlY2tzIGJhY2sNCj4gPiB1c2luZw0KPiA+IHRoZSBuZXcgQ1hMX1ZBUklBQkxFX1BB
WUxPQUQgc2NoZW1lLg0KPiA+IA0KPiA+IFJlcG9ydGVkLWJ5OiBBYmhpIENzIDxhYmhpLmNzQGlu
dGVsLmNvbT4NCj4gPiBGaXhlczogMjZmODk1MzVhNWJiICgiY3hsL21ib3g6IFVzZSB0eXBlIF9f
dTMyIGZvciBtYWlsYm94IHBheWxvYWQNCj4gPiBzaXplcyIpDQo+ID4gQ2M6IDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPg0KPiA+IENjOiBJcmEgV2VpbnkgPGlyYS53ZWlueUBpbnRlbC5jb20+DQo+
ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IENjOiBB
bGlzb24gU2Nob2ZpZWxkIDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNvbT4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gDQo+IHdp
dGggb25lIGNhdmVhdCBiZWxvdy4uLg0KPiBSZXZpZXdlZC1ieTogQWxpc29uIFNjaG9maWVsZCA8
YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyENCg0K
DQo+ID4gLS0tDQo+ID4gwqBkcml2ZXJzL2N4bC9jb3JlL21ib3guYyB8IDEwICsrKysrKy0tLS0N
Cj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+
ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3hsL2NvcmUvbWJveC5jIGIvZHJpdmVycy9j
eGwvY29yZS9tYm94LmMNCj4gPiBpbmRleCA0MGUzY2NiMmJmM2UuLmQ5MjliODlkMTJhNyAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2N4bC9jb3JlL21ib3guYw0KPiA+ICsrKyBiL2RyaXZlcnMv
Y3hsL2NvcmUvbWJveC5jDQo+ID4gQEAgLTM1NSwxMiArMzU1LDE0IEBAIHN0YXRpYyBpbnQgY3hs
X3RvX21lbV9jbWQoc3RydWN0DQo+ID4gY3hsX21lbV9jb21tYW5kICptZW1fY21kLA0KPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FQlVTWTsNCj4gPiDCoA0KPiA+
IMKgwqDCoMKgwqDCoMKgwqAvKiBDaGVjayB0aGUgaW5wdXQgYnVmZmVyIGlzIHRoZSBleHBlY3Rl
ZCBzaXplICovDQo+ID4gLcKgwqDCoMKgwqDCoMKgaWYgKGluZm8tPnNpemVfaW4gIT0gc2VuZF9j
bWQtPmluLnNpemUpDQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAt
RU5PTUVNOw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChpbmZvLT5zaXplX2luICE9IENYTF9WQVJJ
QUJMRV9QQVlMT0FEKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoaW5m
by0+c2l6ZV9pbiAhPSBzZW5kX2NtZC0+aW4uc2l6ZSkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU5PTUVNOw0KPiANCj4gV2UgY2Fu
IGxlYXZlIGl0IHRvIERhbiB0byBhcmJpdHJhdGUsIGJ1dCBJIGRvbid0IHRoaW5rIG5lc3RlZA0K
PiBpZidzIHdpdGhvdXQgYnJhY2tldHMgZm9sbG93IGtlcm5lbCBjb2Rpbmcgc3R5bGUuDQo+IA0K
PiBIb3dldmVyLCBEYW4gZGlkbid0IGxpa2UgbXkgbmVzdGVkIGlmJ3Mgd2l0aCBicmFja2V0cyBl
aXRoZXIuDQo+IEhlJ2QgcHJlZmVyIHVzaW5nICYmDQoNCkhhIGZ1bm55IC0gSSBoYWQgJiYgb3Jp
Z2luYWxseSwgYnV0IHRoZW4gSSBzcG90dGVkIG5lc3RlZCBpZiAoKSBhIGZldw0KbGluZXMgYWJv
dmUgaW4gdGhlIHNhbWUgZmlsZSBpbiBjeGxfbWJveF9zZW5kX2NtZCgpLCBhbmQgc3dpdGNoZWQg
dG8NCnRoZSBzYW1lIHN0eWxlIDopDQoNCkknZCBiZSBoYXBweSB0byBjaGFuZ2UgdG8gJiYuDQoN
Cj4gDQo+ID4gwqANCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyogQ2hlY2sgdGhlIG91dHB1dCBidWZm
ZXIgaXMgYXQgbGVhc3QgbGFyZ2UgZW5vdWdoICovDQo+ID4gLcKgwqDCoMKgwqDCoMKgaWYgKHNl
bmRfY21kLT5vdXQuc2l6ZSA8IGluZm8tPnNpemVfb3V0KQ0KPiA+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gLUVOT01FTTsNCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoaW5m
by0+c2l6ZV9vdXQgIT0gQ1hMX1ZBUklBQkxFX1BBWUxPQUQpDQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlmIChzZW5kX2NtZC0+b3V0LnNpemUgPCBpbmZvLT5zaXplX291dCkN
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biAtRU5PTUVNOw0KPiA+IMKgDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCptZW1fY21kID0gKHN0cnVj
dCBjeGxfbWVtX2NvbW1hbmQpIHsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oC5pbmZvID0gew0KPiA+IA0KPiA+IGJhc2UtY29tbWl0OiAxOTg1Y2Y1ODg1MDU2MmU0Yjk2MGUx
OWQ0NmYwZDhmMTlkNmM3Y2JkDQo+ID4gLS0gDQo+ID4gMi4zNi4xDQo+ID4gDQoNCg==
