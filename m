Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6659A5A86D1
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 21:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiHaTfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 15:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiHaTfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 15:35:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B64595E42
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661974542; x=1693510542;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ULxGzuwrKg9paD6NyDh5hWoToIGxvrTnTdfOzZHX1F4=;
  b=b8BSu+5LLveIn8C1+efxl0/MvPEqmaJyHtVyASe5HWK0czXBJCxI2jWg
   NSaN/CnM8/pMBnReFaZzIzMNVtMTP97lNgz/a1C66RiLSRRut2jCWhnRU
   XKhsAGLG+taLEf9RtayOsJ3LoKT9vs3Y0YcoohOq2LuqhayYxjS+jBvuW
   v+BSoto47SlMpp0S7y6MGt/jfBVhAlWSHJ+3f1cY4ecsGpRHPAmaw0m20
   FPTpsGwQU+ILISS0R1Q5zjcSsetLEirtdLcoTlPzF1lHqCanu7poRA7OM
   jCslNWZZtSxU5bJEpVapZFNKYlh1ZG4dfnqIw/sEPFUudJypEcnQlQWba
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="282504135"
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="282504135"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 12:35:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="589154472"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 31 Aug 2022 12:35:41 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 12:35:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 12:35:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 12:35:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 12:35:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkMH9SjfWaBe8vmgN7FsYVK/05DgUzTy4xgjD8+2rLdDHVASj2b1dv6X5oJ10yBkq7HY9sV3LHImcl6j3CVyn1IaaZlao0wgiPlmQPi4sAWKifGnv8WUv7wOQjsaYBNtNjvS1SXwoTi1e7DLhsRyttt5FihIWfS2N/8Kxg9EumlkxWQuFnzF3dmrkXiN0JBtcd+Zs4zM4X7vML+YrcN0hTWwkuwdjMpemilwBT5dFsEkC6YFX1g3jOT3X1L6h+MR9Sxro9FTaamSh3l9IkssY7EnPtXco26HDQ/1FuwCbMogtJXN6A9JFQzTaqHIVpeTypHDzjnjySgNLGzyxelnTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULxGzuwrKg9paD6NyDh5hWoToIGxvrTnTdfOzZHX1F4=;
 b=lfFLIIl9VQNsqvMW1Ra6jgbuvvmV+Lcmxnss1UyhJ0BszT2hZhg5XveJRmSYClzrglcDAi8qdN6P/NFxUpmTyflAFO91XZyqZP4MA68jynSeUSilaUr1AWG0ve7wIh2g4dP0ONWuMipLEQEf+9WmZyJ0yXRc1lM26CjepeTfkgZEOMGHiOtXSghfnFmg+EqVV+/nhP5/Q838ev2NeBhZhRH2visUbKIixqq1r217Ln2wEl2EA4bUYSTDOUpJFDsx4SoAfrazFZ8jqUyxCmx+Uukhi6+ErvLXJOS/9bpLqie/TBQuX/ZJGk3fC76E9ugqLbQwjxgBV2hTnMOQGskz1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by BN8PR11MB3604.namprd11.prod.outlook.com (2603:10b6:408:83::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 19:35:39 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ce8:1e4e:20d4:6bd4]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ce8:1e4e:20d4:6bd4%9]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 19:35:39 +0000
From:   "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
To:     "Dixit, Ashutosh" <ashutosh.dixit@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Venkatesh Reddy, Sushma" <sushma.venkatesh.reddy@intel.com>
Subject: Re: [PATCH] drm/i915/slpc: Let's fix the PCODE min freq table setup
 for SLPC
Thread-Topic: [PATCH] drm/i915/slpc: Let's fix the PCODE min freq table setup
 for SLPC
Thread-Index: AQHYvKUDx8W8Mu4koUOLJ86AqEgJAa3ILK0AgAE7ugA=
Date:   Wed, 31 Aug 2022 19:35:39 +0000
Message-ID: <b641360e84957a6a351e8aeea89cd2049a0899c6.camel@intel.com>
References: <87edwxzqir.wl-ashutosh.dixit@intel.com>
         <20220830191620.45119-1-rodrigo.vivi@intel.com>
         <874jxtz1e7.wl-ashutosh.dixit@intel.com>
In-Reply-To: <874jxtz1e7.wl-ashutosh.dixit@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05e48c16-5480-49c1-3ebb-08da8b87fc4a
x-ms-traffictypediagnostic: BN8PR11MB3604:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2zO49tBN5ENCOH+vinBweH5+fGih92DL95DGDz7m6jVPA36WEYAt3gGMhg8cj5HcphxvqBSIDDWgneCf9PbQtjiit1j0Mo7pkmPQw7uETwBbwRXDiFqkrK/CUtPdDh+nLOy15IJfKTUdz+ZpV4Kmg1JMZCt7S7kmaluLF/psRCa8mBPghCTU396cm3e6Kr9nl4pdB0x+CcV0wS4EA6icH+NhbML1CDl4ylqay1MHLpeKcuF6lync3eIA8CFIwxwVfpKFAQoN26X3FivyFy5Cj/rsEjBn7s8lwAPdNz3cWI7QqkeIx6Ch/KK20vf3U2So5E+VDwRWlY/T6sZUWjZ31AZbuqjsF0OMrHL3EKe7Dc7byHObpuPTYJouQfPcOPqaP1uc+9ibCT0fETuuTRqXwwyAfT+B1MhHBqlG9bd/jGeqeaYqkK91rwEZBvROERTAuc06TZ2hCta2dP6F+2jt4ekS8rrxnB4vq8XE9RneC2ocJBGuGfKagCXC0jW5UQPXrszU0EjJ5xlIYEJXEDpit04QOYEkrh8D1ApZWWDeyqke2b55VDbM14gUtRMfnogD8QajooSAcgZy2OHYDEJeMWyVG1AcaDD6lP4vNz7OGBsIYr+DYG3ww+wsrSH5onYZQ+kDr2hM+cNezsAxgrZHEotxbPBQc9UiPHgUnD1RcQqaelLPCDu58XeauojRZf4fMdjEvv/izgNTjOzSZcABAaygA/VcwLopdBckYTeXjBHVVkGDkcJE3pWu56GlmmuqLwr+n3QKb1Sq29iSrxKQPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(136003)(376002)(346002)(2906002)(107886003)(6506007)(8676002)(64756008)(4326008)(66446008)(66476007)(66556008)(66946007)(316002)(54906003)(6636002)(37006003)(36756003)(6486002)(71200400001)(2616005)(41300700001)(478600001)(26005)(6512007)(86362001)(82960400001)(38070700005)(186003)(83380400001)(91956017)(6862004)(8936002)(5660300002)(76116006)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTdpSnVNbUYxbkhEK3FNTlYwMGdISWRubWJ3WlFSUXhoNGpEMmlYMFNEdUZF?=
 =?utf-8?B?byt2TitoYjhWUGM5RkJQb2JhczEySXRNRTZzUUJOVWZsTWZCNUhBclFybVhL?=
 =?utf-8?B?UVp3MWRvRDdpM2dPdFd2UUVMa1JkSGxVUTlyd2p5b2dpdzFackRjQzZGdmZm?=
 =?utf-8?B?QUhDaUVTb0V4Qkg4WlZpR0FuVjlRclBvd2FtTUFXdVZtRmhvUEJhWUwyODZC?=
 =?utf-8?B?d3k1aFovamxwYlhod1pkeHdPbHVOM0F4UUFmVGdnL2I3Y2tuZ25SVW05K2xl?=
 =?utf-8?B?dklmWVJVS3JlaHpLQzRzUWcwMGhiTzlJdzgvek9LcG9ZMnlBOXI1d3dObC9W?=
 =?utf-8?B?dUhPbURtOUcybUUvSXlieFh3WkxMM2E5ZzIyL0R4R1dzOFhGdHVZY0pkaGIz?=
 =?utf-8?B?WjFQb1dHVE51ZkdkRnRRb2RkVUU5M3VKSVBtLzhLa1dZYVl0TU9kMTRPdkRv?=
 =?utf-8?B?a1cvaWk3RDJJMkNma20ycmwrOGgzdVNnL0JaczViNUsrQXRLWEUvb0RyQ0VI?=
 =?utf-8?B?TXB6YXdwTldVRnM5eEx4SDNyOGdBUnlkQS9HWkxvQ0hkeUI0SVF2NUh1VWtk?=
 =?utf-8?B?U3QxWTlHM2JaZHgwTlVKMWJQeHk5VnRxNDN6U2pWem1CTjNqN1FLWkc5cW52?=
 =?utf-8?B?RnpsZjRaOE0wZk1tam9rdGdLQkRiRE9hQmdGTENVYzhRbm5GWDVsdUVBYkNG?=
 =?utf-8?B?Wk5ySGIyVHQ0d3NmUkhXRS9OY2Nob0N0QlBwajNuVjlBRG8wakExbHNSenpR?=
 =?utf-8?B?aTF1Uk53L3JuMWF1d3I2RWR5R2Q0ODR2YWF4bVRUQnplMFNPQVRnNDlybGo0?=
 =?utf-8?B?c1NpNVFRU2JiRHN2OE1XRklsU0dBOEczT1R3N2xVeC9NOFJvTkxUZEdOaWNX?=
 =?utf-8?B?R3hHa3pxS1pMdytJY1RvQ3c2V0RJb2w4akY1ZWxXN0JNTHVHdFhBZTAyWjNq?=
 =?utf-8?B?OXNZVjJZUWt0eTgySkFwanovemlQS1pOZkxDMDFqbjEzNjlXcDZnQllCTmhm?=
 =?utf-8?B?STRJTkxqUnJIdFVTZ1lrYXllNGdxbWFoRjlmdVhlR000K1FTeCtnaEJEdCt0?=
 =?utf-8?B?NklBMnVpMElmMDZ5cmxVQ2l6eGFGNEcyZU10KzAzYXJ0UWllRkw5Wkp2ZWVs?=
 =?utf-8?B?VzM0SEo1WnR4R2FVNHRudGJTMVMyRWdOUmNQcktsRHpBMkhsRjZoZzJSazZk?=
 =?utf-8?B?cjlZVjZhZENPUjZkTzRpb1RYMDVYY1Y0RVJ0S1dqQkExR1V3YXEwTnRKRFYz?=
 =?utf-8?B?R0d4Njh4cWY1Y1dHUWJNYzkwdjRjNGRkaFI3Q3ZVeWJid1IrOGJBQW9ldld0?=
 =?utf-8?B?RnRFVzl4a1J4azdkWS9iUGNZcGpxL1liUG52RllncTJMZm1mN3ZHRFFZODFR?=
 =?utf-8?B?Rlc5WDZ2ZUltY0ZndHY1L096N3h0VnFBODNEb2xlOGh3blRwR1JscUQydUl1?=
 =?utf-8?B?SjVmSjNiVjZ6YmROaDdETmFXNnlQalNDTmttaU1hRC8rVGJzWStSbVFuRlY1?=
 =?utf-8?B?MDNoM2QyT3pJUU41cHFuTE56TUtHMzZqeEhiZEdWc3lDdE9UbmZtL0dVaFR1?=
 =?utf-8?B?Nm4xUDRJQ0ZNZHhxamJNV2lsR21QQVhydmdXb1ByNTZQREtNSFZxMXh2eExz?=
 =?utf-8?B?UitEcHZxaCtMOWcwMGk2cVVMR0VnMG9oOVd2NHBGZDhLanBFZEFmQXRaaUls?=
 =?utf-8?B?Q0xZV2JMWk02aVFUT0t0NjlZcXhYU2xGOUZJblZlVHZmajdRYUplYldqMHdx?=
 =?utf-8?B?VWRsWmNVRlFHOUdMOGMwbDJLRmlXeVNlN1dSc1VOVkNGV1ZNL0hDcVBSZVRR?=
 =?utf-8?B?WVpBYTMrd1JiVmpnV0hyTCtscGlTSndtSmdVb255b0l5NGJzV21vTGtHbllw?=
 =?utf-8?B?S0hESGlkdFAzTTdpVGErb2x1WjkzODA0dWsrN1JZTmI0ZWk4M1dNSDVUbWtv?=
 =?utf-8?B?SmpObjgwa0g3ak9FSjVOR1V0MFR1c2lhZVN6bVh4VVZMWXJqSHdxd1hOcFZB?=
 =?utf-8?B?QWMvdjF3aXcrbStPNWJPc292RHJ5YlNyRnp5VjF1d1NEcTJORlZ2OTFYQzgw?=
 =?utf-8?B?UU1sUkdXL09kaGR0em1XTWV5aVNQM0NKVHgyVWtBTGlDbCtKRUJuMHhFaUZp?=
 =?utf-8?B?SEdhaTNsK0ZxZGIzVDI1S0RlSnZiQWdvTU5VdkFPRyt4ODRONEY1dzZBNlBo?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30F65028E37A19448F5D193F2432C79D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e48c16-5480-49c1-3ebb-08da8b87fc4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 19:35:39.5291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PC4vBBKcZ1uAKDIcB0lKIj7R6GiL/IqYf+ZvNxV0KIir5nEuqqKmiIGUWhGw1Ti1P2u2w9hn/qJquXA59ijt8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3604
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTMwIGF0IDE3OjQ1IC0wNzAwLCBEaXhpdCwgQXNodXRvc2ggd3JvdGU6
DQo+IE9uIFR1ZSwgMzAgQXVnIDIwMjIgMTI6MTY6MjAgLTA3MDAsIFJvZHJpZ28gVml2aSB3cm90
ZToNCj4gPiANCj4gDQo+IEhpIFJvZHJpZ28sDQo+IA0KPiA+IEBAIC02NSwxMyArNjMsOCBAQCBz
dGF0aWMgYm9vbCBnZXRfaWFfY29uc3RhbnRzKHN0cnVjdCBpbnRlbF9sbGMNCj4gPiAqbGxjLA0K
PiA+IMKgwqDCoMKgwqDCoMKgwqAvKiBjb252ZXJ0IEREUiBmcmVxdWVuY3kgZnJvbSB1bml0cyBv
ZiAyNjYuNk1IeiB0bw0KPiA+IGJhbmR3aWR0aCAqLw0KPiA+IMKgwqDCoMKgwqDCoMKgwqBjb25z
dHMtPm1pbl9yaW5nX2ZyZXEgPSBtdWx0X2ZyYWMoY29uc3RzLT5taW5fcmluZ19mcmVxLCA4LA0K
PiA+IDMpOw0KPiA+IA0KPiA+IC3CoMKgwqDCoMKgwqDCoGNvbnN0cy0+bWluX2dwdV9mcmVxID0g
cnBzLT5taW5fZnJlcTsNCj4gPiAtwqDCoMKgwqDCoMKgwqBjb25zdHMtPm1heF9ncHVfZnJlcSA9
IHJwcy0+bWF4X2ZyZXE7DQo+ID4gLcKgwqDCoMKgwqDCoMKgaWYgKEdSQVBISUNTX1ZFUihpOTE1
KSA+PSA5KSB7DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIENvbnZlcnQg
R1QgZnJlcXVlbmN5IHRvIDUwIEhaIHVuaXRzICovDQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGNvbnN0cy0+bWluX2dwdV9mcmVxIC89IEdFTjlfRlJFUV9TQ0FMRVI7DQo+ID4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnN0cy0+bWF4X2dwdV9mcmVxIC89IEdF
TjlfRlJFUV9TQ0FMRVI7DQo+ID4gLcKgwqDCoMKgwqDCoMKgfQ0KPiA+ICvCoMKgwqDCoMKgwqDC
oGNvbnN0cy0+bWluX2dwdV9mcmVxID0gaW50ZWxfcnBzX2dldF9taW5fcmF3X2ZyZXEocnBzKTsN
Cj4gPiArwqDCoMKgwqDCoMKgwqBjb25zdHMtPm1heF9ncHVfZnJlcSA9IGludGVsX3Jwc19nZXRf
bWF4X3Jhd19mcmVxKHJwcyk7DQo+ID4gDQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiB0cnVl
Ow0KPiA+IMKgfQ0KPiA+IEBAIC0xMzAsNiArMTIzLDEyIEBAIHN0YXRpYyB2b2lkIGdlbjZfdXBk
YXRlX3JpbmdfZnJlcShzdHJ1Y3QNCj4gPiBpbnRlbF9sbGMgKmxsYykNCj4gPiDCoMKgwqDCoMKg
wqDCoMKgaWYgKCFnZXRfaWFfY29uc3RhbnRzKGxsYywgJmNvbnN0cykpDQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm47DQo+ID4gDQo+ID4gK8KgwqDCoMKgwqDCoMKg
LyoNCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBBbHRob3VnaCB0aGlzIGlzIHVubGlrZWx5IG9uIGFu
eSBwbGF0Zm9ybSBkdXJpbmcNCj4gPiBpbml0aWFsaXphdGlvbiwNCj4gPiArwqDCoMKgwqDCoMKg
wqAgKiBsZXQncyBlbnN1cmUgd2UgZG9uJ3QgZ2V0IGFjY2lkZW50YWxseSBpbnRvIGluZmluaXRl
DQo+ID4gbG9vcA0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqLw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlm
IChjb25zdHMubWF4X2dwdV9mcmVxIDw9IGNvbnN0cy5taW5fZ3B1X2ZyZXEpDQo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsNCj4gDQo+IEFzIEkgc2FpZCB0aGlzIGlz
IG5vdCBjb3JyZWN0IGFuZCBpcyBub3QgbmVlZGVkLiBJZg0KPiAnY29uc3RzLm1heF9ncHVfZnJl
cSA9PQ0KPiBjb25zdHMubWluX2dwdV9mcmVxJyB3ZSB3b3VsZCAqd2FudCogdG8gcHJvZ3JhbSBQ
Q09ERS4gSWYNCj4gJ2NvbnN0cy5tYXhfZ3B1X2ZyZXEgPCBjb25zdHMubWluX2dwdV9mcmVxJyB0
aGUgbG9vcCB3aWxsDQo+IGF1dG9tYXRpY2FsbHkNCj4gc2tpcCAoYW5kIGFsc28gaXQgaXMgbm90
IGFuIGluZmluaXRlIGxvb3ApLg0KDQp5ZWFwLCBidXQgaWYgd2UgY2hhbmdlIHRoaXMgY29uZGl0
aW9uIGluIHRoZSBsb29wIHdlIHdpbGwNCm1pc3Mgb25lIGVudHJ5IGluIHRoZSBjYXNlIHRoZXkg
YXJlIGVxdWFsLg0KU2luY2Ugd2UgYXJlIGRvaW5nIHRoaXMgZ2VuZXJpY2FsbHkgZm9yIDE1IHll
YXJzIG9mIGhhcmR3YXJlDQpJIGRpZG4ndCB3YW50IHRvIHRha2UgdGhlIHJpc2sgb2YgaGF2aW5n
IHNvbWUgb3V0IHRoZXJlDQp3aGVyZSB0aGUgbWluID0gbWF4IGFuZCB0aGUgMSBlbnRyeSBpbiB0
aGUgdGFibGUgaXMgbmVlZGVkLg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9ndC9pbnRlbF9ycHMuYw0KPiA+IGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3QvaW50
ZWxfcnBzLmMNCj4gPiBpbmRleCBkZTc5NGY1Zjg1OTQuLjI2YWY5NzQyOTJjNyAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndC9pbnRlbF9ycHMuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2d0L2ludGVsX3Jwcy5jDQo+ID4gQEAgLTIxNTYsNiArMjE1Niwy
NCBAQCB1MzIgaW50ZWxfcnBzX2dldF9tYXhfZnJlcXVlbmN5KHN0cnVjdA0KPiA+IGludGVsX3Jw
cyAqcnBzKQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGludGVs
X2dwdV9mcmVxKHJwcywgcnBzLQ0KPiA+ID5tYXhfZnJlcV9zb2Z0bGltaXQpOw0KPiA+IMKgfQ0K
PiA+IA0KPiA+ICt1MzIgaW50ZWxfcnBzX2dldF9tYXhfcmF3X2ZyZXEoc3RydWN0IGludGVsX3Jw
cyAqcnBzKQ0KPiANCj4gV2hhdCBkb2VzICJyYXciIG1lYW4/IE9yIGFyZSB3ZSBpbnRyb2R1Y2lu
ZyBhIG5ldyBjb25jZXB0IGhlcmUgdGhlbg0KPiB3ZSBuZWVkDQo+IHRvIGV4cGxhaW4gdGhlIG5l
dyBjb25jZXB0PyBJIHdhcyBwcmV2aW91c2x5IHRvbGQgdGhlcmUgaXMgYSBjb25jZXB0DQo+IG9m
ICJodw0KPiB1bml0cyIgb2YgZnJlcSBhbmQgaW50ZWxfZ3B1X2ZyZXEgd2lsbCBjb252ZXJ0IGZy
b20gImh3IHVuaXRzIiB0bw0KPiBNSHouDQoNCnllYXAsIGl0IGlzIHRoZSBodyB1bml0cywgc29t
ZSBmb2xrcyBhbHNvIGNhbGxpbmcgRklEIG9mIHRoZSBmcmVxcy4NCkkgY291bGRuJ3QgZmluZCBh
IGJldHRlciBuYW1lLg0KDQo+IA0KPiBBbHNvLCBJcyB0aGUgcmV0dXJuIHZhbHVlIGluIHVuaXRz
IG9mIDUwIE1IeiBpbiBhbGwgY2FzZXMgKHdlIGtub3cgaXQNCj4gaXMNCj4gZm9yIFNMUEMgYW5k
IEdlbiA5Kyk/IEluIHRoYXQgY2FzZSB3ZSBzaG91bGQgbmFtZSBzdWNoIGEgZnVuY3Rpb24gdG8N
Cj4gc29tZXRoaW5nIGxpa2UgaW50ZWxfcnBzX2dldF9tYXhfZnJlcV9pbl81MG1oel91bml0cz8N
Cg0KeWVhcCwgdGhhdCB3b3VsZCB3b3JrLi4uIGF0IGxlYXN0IHVudGlsIGluIHNvbWUgZnV0dXJl
IHBsYXRmb3JtIG91ciBodw0KZm9sa3MgbmVlZCB0byBmaW5kIGFub3RoZXIgYmFzZS4uLg0KDQo+
IA0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGludGVsX2d1Y19zbHBjICpzbHBj
ID0gcnBzX3RvX3NscGMocnBzKTsNCj4gPiArwqDCoMKgwqDCoMKgwqB1MzIgZnJlcTsNCj4gPiAr
DQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHJwc191c2VzX3NscGMocnBzKSkgew0KPiA+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gRElWX1JPVU5EX0NMT1NFU1Qoc2xwYy0+
cnAwX2ZyZXEsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBHVF9GUkVRVUVOQ1lfTVVMVElQ
TElFUik7DQo+ID4gK8KgwqDCoMKgwqDCoMKgfSBlbHNlIHsNCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZnJlcSA9IHJwcy0+bWF4X2ZyZXE7DQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGlmIChHUkFQSElDU19WRVIocnBzX3RvX2k5MTUocnBzKSkgPj0gOSkg
ew0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyog
Q29udmVydCBHVCBmcmVxdWVuY3kgdG8gNTAgSFogdW5pdHMgKi8NCj4gDQo+IDUwIE1IeiBhbmQg
bm90IDUwIEh6LiBBbHNvIHRoZSBjb21tZW50IHNob3VsZCBiZSBtb3ZlZCB0byBhYm92ZQ0KPiBy
cHNfdXNlc19zbHBjKCkgbGluZSBpZiByZXR1cm5lZCBmcmVxIGlzIGFsd2F5cyBpbiB1bml0cyBv
ZiA1MCBNSHouDQoNCnllYXAsIHRoaXMgY29tbWVudCB3YXMgYWxyZWFkeSB0aGVyZSBhbmQgcHJv
YmFibHkgd3JvbmcuLi4NCg0KPiANCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGZyZXEgLz0gR0VOOV9GUkVRX1NDQUxFUjsNCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgfQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gZnJlcTsNCj4gPiArwqDCoMKgwqDCoMKgwqB9DQo+ID4gK30NCj4gDQo+IEFsc28g
aXMgdGhpcyBmdW5jdGlvbiBlcXVpdmFsZW50IHRvIHRoaXM6DQo+IA0KPiB1MzIgaW50ZWxfcnBz
X2dldF9tYXhfZnJlcV9pbl81MG1oel91bml0cyhzdHJ1Y3QgaW50ZWxfcnBzICpycHMpDQo+IHsN
Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbnRlbF9ndWNfc2xwYyAqc2xwYyA9IHJwc190b19z
bHBjKHJwcyk7DQo+IMKgwqDCoMKgwqDCoMKgwqB1MzIgZnJlcTsNCj4gDQo+IMKgwqDCoMKgwqDC
oMKgwqAvKiBmcmVxIGluIE1IeiAqLw0KPiDCoMKgwqDCoMKgwqDCoMKgZnJlcSA9IHJwc191c2Vz
X3NscGMocnBzKSA/IHNscGMtPnJwMF9mcmVxIDoNCj4gaW50ZWxfZ3B1X2ZyZXEocnBzLT5tYXhf
ZnJlcSk7DQoNCmRvIHlvdSByZWFsbHkgd2FudCB0byBjb252ZXJ0IGZvcnRoIGFuZCBiYWNrPyBD
YW4gd2UgbWluaW1pemUgdGhlIG1hdGg/DQoNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
RElWX1JPVU5EX0NMT1NFU1QoZnJlcSwgR1RfRlJFUVVFTkNZX01VTFRJUExJRVIpOw0KPiB9DQo+
IA0KPiBTb3JyeSBJIGRvbid0IGhhdmUgYSBsb3Qgb2YgaGlzdG9yeSBpbiBob3cgdGhlc2UgZnJl
cXVlbmNpZXMgYXJlDQo+IHNjYWxlZA0KPiBzcGVjaWFsbHkgZm9yIG9sZCBwbGF0Zm9ybXMgbGlr
ZSBDSFYvVkxWL0dlbjYrLiBCdXQgYWZhaXUNCj4gaW50ZWxfZ3B1X2ZyZXEoKQ0KPiB3aWxsIGNv
bnZlcnQgdGhlIGZyZXEgdG8gTUh6IGZvciBhbGwgcGxhdGZvcm1zLg0KDQp5ZWFwLCBvbGQgcGxh
dGZvcm1zIGFsc28gY29uY2VybiBtZS4uLiBhbm90aGVyIHJlYXNvbiB0byBhdm9pZCBkb2luZw0K
c29tZXRoaW5nIG5ldyBhbmQgb25seSB1c2luZyB0aGUgY29udmVyc2lvbiB0aGF0IHdhcyBhbHJl
YWR5IHRoZXJlLg0KDQo+IA0KPiBBbmQgdGhlbiBkb2VzIGdldF9pYV9jb25zdGFudHMoKSBhY2Nl
cHQgZnJlcSBpbiA1MCBNSHogdW5pdHMgZm9yIGFsbA0KPiBwbGF0Zm9ybXM/DQoNClBsZWFzZSBu
b3RpY2UgdGhhdCB0aGVyZSdzIGFic29sdXRlbHkgbm8gY2hhbmdlIGZvciB0aGUgbm9uLXNscGMN
CnBsYXRmb3Jtcy4NCg0KPiANCj4gSWYgd2UgYXJlIG5vdCBzdXJlIGFib3V0IHRoaXMsIHdlIGNh
biBnbyB3aXRoIHlvdXIgdmVyc2lvbiB3aGljaCBpcw0KPiBjbG9zZXINCj4gdG8gdGhlIG9yaWdp
bmFsIHZlcnNpb24gaW4gZ2V0X2lhX2NvbnN0YW50cygpIGFuZCBzbyAic2FmZXIiIEkgZ3Vlc3Mu
DQoNCnNvIHlvdSBtZWFuIHRoaXMgdmVyc2lvbj8gOykNCg0KPiANCj4gVGhhbmtzLg0KPiAtLQ0K
PiBBc2h1dG9zaA0KDQpUaGFuayB5b3Ugc28gbXVjaCENCg==
