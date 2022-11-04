Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4745619136
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 07:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiKDGnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 02:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKDGnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 02:43:08 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E2E2A407;
        Thu,  3 Nov 2022 23:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667544187; x=1699080187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PYKVBPMl/jsYlxb4dx8tcb9WtCdTRlha3QA3+rUvFwE=;
  b=YwYOMHxNEQgd53faV6XBdNmgKcOlB+e8ixS9/jI6FAVLwnZEEuJdIjPY
   rTP0PZpAkklQDEGKDgeMpH+T8wn0UFXz9iyOig7hc8B7B0gn06SzVU8km
   dBtlnvz6k+7OcJncTNCDGvVoKM04v90zUdJqomXTwgTKj2TtygfxPBXWa
   8tFuW+gpv9+59WsScpTf+GzPY2sWqvgFX1J3GqSxdN8DPkXitgaRjXQ+/
   Dm/j9eQGkRHExwXKq5af+jtCJpFtPlxN9OIr4zeAozzefuSILksp2y3ry
   xr2Vf3O7X0NuTgGkZoDYjm3cBNtgLL/WSRiRzif9QFOSeyacsjJNWX+PG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="307517684"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="307517684"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 23:43:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="964238957"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="964238957"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 03 Nov 2022 23:43:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 23:43:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 23:43:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 23:43:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/yXzvll7Fe0nW6Pf5bxh3nLD8hk1NksxtHQRvqCgzXPRV8O4B2wc57iQ+3O+Hhdi6dSmAqU5v10R49Avww6EK1sWeq6gqEsNSJES05pbsOvAMD3prUYH93749P6sF84Ny7KVcnS0N1m+LvpM83VQ4lERlnE5Wy1BRnmYfuJenWIYNPkLDlFEgUGoSPXeWvKRh6xleMN27t/fh84i2xEJDY1XUhe3UCB8ItcQ2h+DiWz/Zls9JALWmAnork0zAolIcXsBa+k72tuh8TKWdka5kmoAM5hfNn4u5yJlkf9mV6SlEz5JOF/cxTMrP8hml2tJAedBY83nixePtwVnW93bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYKVBPMl/jsYlxb4dx8tcb9WtCdTRlha3QA3+rUvFwE=;
 b=gHrMCW8l8UfHG/Xu24VDQJ63jIrjroWQOX1Xriz32n6/rLUFbk4U/QQ40U/EB1oZHeEH4rD4qz71hyGv7qfOzutLSbdXFS4Kt3bCLgTY0eR+n3LDRg4Qm84l/j4on373vgLVVUJdb2FnMm9r3MM3WTCwj6IMp2PiH3GuE+rgsa4Kk19AeFJDxvHyHI3DDblgjFZ6ODta+N9KkGQMWHJoVspIxTa00PMXoyzTpAfAfmtHyvHIh7Osh0vzmyo1qfAA4syZzOfyxvw5hjCo01GBVc77L+k+PT/cR5ra1UTZ8tIy6ugx/eiMQqFTy9xVcDyBuBZoMDDYfIscQknHvWuCNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 06:42:59 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 06:42:59 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "Schofield, Alison" <alison.schofield@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lmw.bobo@gmail.com" <lmw.bobo@gmail.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 6/7] cxl/region: Fix 'distance' calculation with
 passthrough ports
Thread-Topic: [PATCH 6/7] cxl/region: Fix 'distance' calculation with
 passthrough ports
Thread-Index: AQHY7+S8fPtXASKXW0G+JkGu6ICIKq4uUZAA
Date:   Fri, 4 Nov 2022 06:42:58 +0000
Message-ID: <fa869572ab3190e0dacba8f5f133f750e9b30676.camel@intel.com>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
         <166752185440.947915.6617495912508299445.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166752185440.947915.6617495912508299445.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|DS7PR11MB5966:EE_
x-ms-office365-filtering-correlation-id: bbf07d66-6158-4b8d-881e-08dabe2fd00e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oGMlEcAJpdoYgFPQmhnuHvzMbHD4gu2hyARE+DAIu0Gsv74dHMkwTKegiQdAGPFX6Aqk18jXsrhvwF0K7Szpi9fWLToC2sVvV9kLdjdXCgTzdg5jd8la7lOgbN64zxtWa2wq7yjvVemDnAKwuuRUEhYnlBT5HjplirEQEJB5qJj4QctyIUfhPA6hpJdF2U8RisE6X5f4IAT0tWjB3/izK49r2M9H6yErmtzrL4XnVWWJeVGMn73g8xBZIbaVmoSqoJjkKo3IzzidbreKRKXUENHwoajNX7k1n7tmDALwKUsQI4rl2x+TN+JQ6OQ27CVHSq/igkAM7sBm3qZAWwcpnPlSjh0IdSapjBAe4jhr+D8mxaC6ZavRLGsI/800lWhb5IL04bzr2HMh8v15g34uU3FmtpRnmCTo9zlZ3NT02S0WyNxPIqi75XAsvVvbufoZ6b/TAwt20bgfWu9gbLTTov06pF3o9s5aZlnhPVfeMRcoaNDp32R7Jxy40TnE9V4SRNY1ttIWvjNQ6koloi843/Xueyf0ywTZq+OQxXC7P5zySUpzQRBoTSUvyyA6NhfR3JhhrGgNJ1nkbsjqDFMmXV0Ep1/nkm25W1CiIQgBPrCyJZNiy58xB5/1x+uiWU+oSsmMAVvwneMFwwXgMQN9RRYUX6KKsQFrZST5cKQBpc5bBXfr/UeXeBamDR2Y31+1GuubuRVyQOMrmPqTKFvqtROKw1fsyCEMMZxq0UWbSrQ8AAQCRiBUqi09c/EnDfCHBBv5T5fL1YfG8iYWW0miJvX9ROW74pNNWBE+GDHwvUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(36756003)(6486002)(966005)(71200400001)(86362001)(2906002)(38070700005)(5660300002)(8936002)(107886003)(83380400001)(122000001)(38100700002)(316002)(186003)(54906003)(82960400001)(66946007)(26005)(6506007)(8676002)(6512007)(2616005)(66556008)(478600001)(110136005)(76116006)(64756008)(91956017)(4326008)(66446008)(66476007)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUxIemQ3VWVEUHhWb1hqUTJ4cFlER3krS1BUaldnYk9hekJJNkJRTWJROVAy?=
 =?utf-8?B?NHJYVEp3Y0RubnNsZUVaSzd3QXB1RmxkTnkwRHdGa0ZtSTVWNnA4TDloLytr?=
 =?utf-8?B?S0k0UVB2QkRpYmxGalBxWHRmWklrQkJyZmxiQW5ib2hMc01BMmNaVXRhNVBE?=
 =?utf-8?B?Y29UajN6MTJaQ1ZtcmFJdTNpK09sbEVFOTJtZEViWEZvK3ZFK29DVnQ1TVRl?=
 =?utf-8?B?WmVyajluRjc5NFZ0NXNWaGxiUVpwRnJhVVdkZUdjQmpzWG1PWGRCZ3YxNWQ0?=
 =?utf-8?B?ZWcySlM2ZUdMSkZZSFQzTzczOVlkSC93MzV6d1lyQXlWRzNPTG0vV1g5NVp5?=
 =?utf-8?B?dE5ISElBeFNCRkxxaVBjVDFWZ0xMQSsvNW5wRW1RZFV3d1RheDZNTkU3bUJv?=
 =?utf-8?B?UlNqM1lQVnY0eGhROE9UbVROZlc5ZHcrQVNLUnlVUzU2aGtPMThLRnltV1lB?=
 =?utf-8?B?bzBqQndSUnl4SnpNS0hlOXByOWJiQzhOZ3BPcGwweVgyelNvdnB0Zkk5UlZs?=
 =?utf-8?B?dWVzSHk3THdsbmRvTkhqUGhZNmNFaUJVdzh2RlM2aXRyelVsajlIS3UxWUYx?=
 =?utf-8?B?akdGb2ZVb0NsSnphVnZKVFVoWHcxUUJBL082aFhaSCtLdVFsMTlMUFlUQTBu?=
 =?utf-8?B?WGhEdXVMc2JIK2RsekMzUDk0UE9Ma0tOeHdVbS9xay9pdUhLVXZBbDVqWFU3?=
 =?utf-8?B?QjcvY2dIa3YzTjBZRTlybUEzSkRjMXJ0TktVMHZlTXk1eE5wZng5VDYydmw2?=
 =?utf-8?B?VEZVUmFxVnIwd1FhVG1WWFBtajdkaEVuS1JrN29sNVdRMHIxYURFNk9icGFS?=
 =?utf-8?B?a2xlWTdMQUUrRjJ0b004anhTbGt5Y1dRWGdHY3F2ajFWbXZNblVxMkFDdFJL?=
 =?utf-8?B?TnRJc0VCMFd6SG9tWjhpR2VpemEvSGF5WkRoVFpHWHhTMTRLeDJUdWg1VUYz?=
 =?utf-8?B?TmJadXNqWUlRVXMvWEIzcmFQQ1pQZzZNeUFsZFNQa3lBWEQyV0IzV1JPV1Uv?=
 =?utf-8?B?Q0FMcXc1NldyVTZ0Qms2UGJXNXBPWlBnU1FHZ0ZXcEoyOEVlcWZnRFRZa3F4?=
 =?utf-8?B?bW9jUmdpa2gwNzdqbmlGS0FuekJXS0lEWmJNL1ZjN0hOL2FGM0plVUVIalg0?=
 =?utf-8?B?aCthd01uWVQ5bUtpMHJjdmlCenVvL1hhaUdqbEUwZTZhQnZqbVc0R2g0MS9l?=
 =?utf-8?B?aEg3K1F1cytrUmNGVFVobndseUM3QUpsZHRINExWWXBXTlkxYW5hT01PMmlo?=
 =?utf-8?B?MW9GblpSVE9oaFVDeU9ES0hVOVlSbXl1OVZQZDI5T0c2bDZDVWFDQlMvUDgw?=
 =?utf-8?B?V0Fra0dPbXUyVXNjazc0LzllM1o5TjB2dWtrZWxwc004OXNMdnF4eGhQUmZq?=
 =?utf-8?B?dnYvK2xsbHdqT1lqQ1dPVjdwNnlnZ2tyY3ZhY1FiWmIzbjNVaStSSk94Z1o2?=
 =?utf-8?B?WTVUcjNab2kwVU13NStmd1JiUjFUSit2emJhUmpsMjRWUCs1aU0vRUtiV2RK?=
 =?utf-8?B?TlZ1RVBoSlNrMUFPMElFTml4SW5vRzNzNFRZQ3ZmWHJIK0llMldCUFNUSC9y?=
 =?utf-8?B?NG9oQUdrQ004Q1VxQXBCayt0dFhTK0lOdGNzcXFJankySG14Wk0vWkxzNkdT?=
 =?utf-8?B?Y1kwY1laZGF5dzhlSVY4cmdCaVJUT1RVZHZGU21DU2kxZGpKT1JWWnpqaUlv?=
 =?utf-8?B?Ym0rSEllQk03NTBhL3orT0l4aTQzUUpueVJ6WUc0Q3hDOVZGR0NSZDZmeTJP?=
 =?utf-8?B?SFAzRHVBM2xBdDFXMmtmYnJMVGlOMmw3Qm1pL3liMnBoSFNMRHFVNklMS2Q1?=
 =?utf-8?B?MHU3N3RWWWdqMkR2RVd6SlJMQkpRam1kandIMHZIQlhIWUdKajFiL2tnUTlD?=
 =?utf-8?B?T2tNMWxBSXdOUVZDang3dVdMdGtKRGR6U2toUDRqYzR0MXRCV1UyYUF6QXNW?=
 =?utf-8?B?eis2RFJrQysyKzR4YzBpUHBxZ0hOTG5LRWFrM1laaU95UE83K2VZOWk4c05E?=
 =?utf-8?B?R2FuVG13WFo1eHpmOU5ULzhMK3I4TWJ6Z2V6NC9FQTFMbkhwcDI1Ris0UWN6?=
 =?utf-8?B?SnRHSjIzZVhsaE0yT0lqWXVhbWc4RW9VRFlxMVQvQXZZVWx2SDhndWdoV0RW?=
 =?utf-8?B?K3FrazdESi9iNkJmN05yOGJKdnBOcXJHUG1nc01XK0h0TlRjeGpmSUIyUjY4?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C7CF2CAFE32B84DA4AC350392816B2B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf07d66-6158-4b8d-881e-08dabe2fd00e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 06:42:58.9075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CirEv+bTtpSWR82Ec/qr3+d/sD1RHXqWlTWb4iFSc1175ZiKwTtAX21e2AkKd0reK+NHMeO7DgduebXG9ZjTAIHZ64E6YE4TLQ1Ukl8pzpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5966
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTAzIGF0IDE3OjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
V2hlbiBwcm9ncmFtbWluZyBwb3J0IGRlY29kZSB0YXJnZXRzLCB0aGUgYWxnb3JpdGhtIHdhbnRz
IHRvIGVuc3VyZSB0aGF0Cj4gdHdvIGRldmljZXMgYXJlIGNvbXBhdGlibGUgdG8gYmUgcHJvZ3Jh
bW1lZCBhcyBwZWVycyBiZW5lYXRoIGEgZ2l2ZW4KPiBwb3J0LiBBIGNvbXBhdGlibGUgcGVlciBp
cyBhIHRhcmdldCB0aGF0IHNoYXJlcyB0aGUgc2FtZSBkcG9ydCwgYW5kCj4gd2hlcmUgdGhhdCB0
YXJnZXQncyBpbnRlcmxlYXZlIHBvc2l0aW9uIGFsc28gcm91dGVzIGl0IHRvIHRoZSBzYW1lCj4g
ZHBvcnQuIENvbXBhdGliaWxpdHkgaXMgZGV0ZXJtaW5lZCBieSB0aGUgZGV2aWNlJ3MgaW50ZXJs
ZWF2ZSBwb3NpdGlvbgo+IGJlaW5nID49IHRvIGRpc3RhbmNlLiBGb3IgZXhhbXBsZSwgaWYgYSBn
aXZlbiBkcG9ydCBjYW4gb25seSBtYXAgZXZlcnkKPiBOdGggcG9zaXRpb24gdGhlbiBwb3NpdGlv
bnMgbGVzcyB0aGFuIE4gYXdheSBmcm9tIHRoZSBsYXN0IHRhcmdldAo+IHByb2dyYW1tZWQgYXJl
IGluY29tcGF0aWJsZS4KPiAKPiBUaGUgQGRpc3RhbmNlIGZvciB0aGUgaG9zdC1icmlkZ2UtY3hs
X3BvcnQgYSBzaW1wbGUgZHVhbC1wb3J0ZWQKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBeCklzIHRoaXMgbWVhbnQgdG8gYmUgInRoZSBkaXN0YW5jZSBmb3IgdGhlIGhvc3QtYnJp
ZGdlIHRvIGEgY3hsX3BvcnQiPwoKQWxzbyBtaXNzaW5nICcvaW4vIGEgc2ltcGxlIGR1YWwtcG9y
dGVkLi4nPwoKPiBob3N0LWJyaWRnZSBjb25maWd1cmF0aW9uIHdpdGggMiBkaXJlY3QtYXR0YWNo
ZWQgZGV2aWNlcyBpcyAxLiBBbiB4Mgo+IHJlZ2lvbiBkaXZkZWQgYnkgMiBkcG9ydHMgdG8gcmVh
Y2ggMiByZWdpb24gdGFyZ2V0cy4KClRoZSBzZWNvbmQgc2VudGVuY2Ugc2VlbXMgc2xpZ2h0bHkg
aW5jb21wcmVoZW5zaWJsZSB0b28uCj4gCj4gQW4geDQgcmVnaW9uIHVuZGVyIGFuIHgyIGhvc3Qt
YnJpZGdlIHdvdWxkIG5lZWQgMiBpbnRlcnZlbmluZyBzd2l0Y2hlcwo+IHdoZXJlIHRoZSBAZGlz
dGFuY2UgYXQgdGhlIGhvc3QgYnJpZGdlIGxldmVsIGlzIDIgKHg0IHJlZ2lvbiBkaXZpZGVkIGJ5
Cj4gMiBzd2l0Y2hlcyB0byByZWFjaCA0IGRldmljZXMpLgo+IAo+IEhvd2V2ZXIsIHRoZSBkaXN0
YW5jZSBiZXR3ZWVuIHBlZXJzIHVuZGVybmVhdGggYSBzaW5nbGUgcG9ydGVkCj4gaG9zdC1icmlk
Z2UgaXMgYWx3YXlzIHplcm8gYmVjYXVzZSB0aGVyZSBpcyBubyBsaW1pdCB0byB0aGUgbnVtYmVy
IG9mCj4gZGV2aWNlcyB0aGF0IGNhbiBiZSBtYXBwZWQuIEluIG90aGVyIHdvcmRzLCB0aGVyZSBh
cmUgbm8gZGVjb2RlcnMgdG8KPiBwcm9ncmFtIGluIGEgcGFzc3Rocm91Z2gsIGFsbCBkZXNjZW5k
YW50cyBhcmUgbWFwcGVkIGFuZCBkaXN0YW5jZSBvbmx5Cj4gc3RhcnRzIG1hdHRlcnMgZm9yIHRo
ZSBpbnRlcnZlbmluZyBkZXNjZW5kYW50IHBvcnRzIG9mIHRoZSBwYXNzdGhyb3VnaAoKc3RhcnRz
IHRvIG1hdHRlcj8KCj4gcG9ydC4KPiAKPiBBZGQgdHJhY2tpbmcgZm9yIHRoZSBudW1iZXIgb2Yg
ZHBvcnRzIG1hcHBlZCB0byBhIHBvcnQsIGFuZCB1c2UgdGhhdCB0bwo+IGRldGVjdCB0aGUgcGFz
c3Rocm91Z2ggY2FzZSBmb3IgY2FsY3VsYXRpbmcgQGRpc3RhbmNlLgo+IAo+IENjOiA8c3RhYmxl
QHZnZXIua2VybmVsLm9yZz4KPiBSZXBvcnRlZC1ieTogQm9ibyBXTCA8bG13LmJvYm9AZ21haWwu
Y29tPgo+IFJlcG9ydGVkLWJ5OiBKb25hdGhhbiBDYW1lcm9uIDxKb25hdGhhbi5DYW1lcm9uQGh1
YXdlaS5jb20+Cj4gTGluazogaHR0cDovL2xvcmUua2VybmVsLm9yZy9yLzIwMjIxMDEwMTcyMDU3
LjAwMDAxNTU5QGh1YXdlaS5jb20KPiBGaXhlczogMjdiM2Y4ZDEzODMwICgiY3hsL3JlZ2lvbjog
UHJvZ3JhbSB0YXJnZXQgbGlzdHMiKQo+IFNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFu
Lmoud2lsbGlhbXNAaW50ZWwuY29tPgo+IC0tLQo+IMKgZHJpdmVycy9jeGwvY29yZS9wb3J0LmPC
oMKgIHzCoMKgIDExICsrKysrKysrKy0tCj4gwqBkcml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jIHzC
oMKgwqAgOSArKysrKysrKy0KPiDCoGRyaXZlcnMvY3hsL2N4bC5owqDCoMKgwqDCoMKgwqDCoCB8
wqDCoMKgIDIgKysKPiDCoDMgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKCk90aGVyIHRoYW4gdGhlIGFib3ZlLCBsb29rcyBnb29kLAoKUmV2aWV3ZWQtYnk6
IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPgoKPiAKPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9jeGwvY29yZS9wb3J0LmMgYi9kcml2ZXJzL2N4bC9jb3JlL3BvcnQuYwo+IGlu
ZGV4IGJmZmRlODYyZGUwYi4uZTc1NTY4NjRlYTgwIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvY3hs
L2NvcmUvcG9ydC5jCj4gKysrIGIvZHJpdmVycy9jeGwvY29yZS9wb3J0LmMKPiBAQCAtODExLDYg
KzgxMSw3IEBAIHN0YXRpYyBzdHJ1Y3QgY3hsX2Rwb3J0ICpmaW5kX2Rwb3J0KHN0cnVjdCBjeGxf
cG9ydCAqcG9ydCwgaW50IGlkKQo+IMKgc3RhdGljIGludCBhZGRfZHBvcnQoc3RydWN0IGN4bF9w
b3J0ICpwb3J0LCBzdHJ1Y3QgY3hsX2Rwb3J0ICpuZXcpCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDC
oHN0cnVjdCBjeGxfZHBvcnQgKmR1cDsKPiArwqDCoMKgwqDCoMKgwqBpbnQgcmM7Cj4gwqAKPiDC
oMKgwqDCoMKgwqDCoMKgZGV2aWNlX2xvY2tfYXNzZXJ0KCZwb3J0LT5kZXYpOwo+IMKgwqDCoMKg
wqDCoMKgwqBkdXAgPSBmaW5kX2Rwb3J0KHBvcnQsIG5ldy0+cG9ydF9pZCk7Cj4gQEAgLTgyMSw4
ICs4MjIsMTQgQEAgc3RhdGljIGludCBhZGRfZHBvcnQoc3RydWN0IGN4bF9wb3J0ICpwb3J0LCBz
dHJ1Y3QgY3hsX2Rwb3J0ICpuZXcpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZGV2X25hbWUoZHVwLT5kcG9ydCkpOwo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FQlVTWTsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IC3CoMKg
wqDCoMKgwqDCoHJldHVybiB4YV9pbnNlcnQoJnBvcnQtPmRwb3J0cywgKHVuc2lnbmVkIGxvbmcp
bmV3LT5kcG9ydCwgbmV3LAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIEdGUF9LRVJORUwpOwo+ICsKPiArwqDCoMKgwqDCoMKgwqByYyA9IHhhX2luc2Vy
dCgmcG9ydC0+ZHBvcnRzLCAodW5zaWduZWQgbG9uZyluZXctPmRwb3J0LCBuZXcsCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBHRlBfS0VSTkVMKTsKPiArwqDC
oMKgwqDCoMKgwqBpZiAocmMpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
biByYzsKPiArCj4gK8KgwqDCoMKgwqDCoMKgcG9ydC0+bnJfZHBvcnRzKys7Cj4gK8KgwqDCoMKg
wqDCoMKgcmV0dXJuIDA7Cj4gwqB9Cj4gwqAKPiDCoC8qCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y3hsL2NvcmUvcmVnaW9uLmMgYi9kcml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jCj4gaW5kZXggYzUy
NDY1ZTA5ZjI2Li5jMDI1M2RlNzQ5NDUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9jeGwvY29yZS9y
ZWdpb24uYwo+ICsrKyBiL2RyaXZlcnMvY3hsL2NvcmUvcmVnaW9uLmMKPiBAQCAtOTkwLDcgKzk5
MCwxNCBAQCBzdGF0aWMgaW50IGN4bF9wb3J0X3NldHVwX3RhcmdldHMoc3RydWN0IGN4bF9wb3J0
ICpwb3J0LAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoY3hsX3JyLT5ucl90YXJnZXRzX3NldCkgewo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW50IGksIGRpc3RhbmNlOwo+IMKgCj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRpc3RhbmNlID0gcC0+bnJfdGFyZ2V0cyAv
IGN4bF9yci0+bnJfdGFyZ2V0czsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogUGFzc3Rocm91Z2ggcG9ydHMgaW1w
b3NlIG5vIGRpc3RhbmNlIHJlcXVpcmVtZW50cyBiZXR3ZWVuCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqIHBlZXJzCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
Lwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAocG9ydC0+bnJfZHBvcnRzID09
IDEpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkaXN0
YW5jZSA9IDA7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVsc2UKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRpc3RhbmNlID0gcC0+bnJf
dGFyZ2V0cyAvIGN4bF9yci0+bnJfdGFyZ2V0czsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGZvciAoaSA9IDA7IGkgPCBjeGxfcnItPm5yX3RhcmdldHNfc2V0OyBpKyspCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGVwLT5kcG9y
dCA9PSBjeGxzZC0+dGFyZ2V0W2ldKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJjID0gY2hlY2tfbGFzdF9wZWVyKGN4
bGVkLCBlcCwgY3hsX3JyLAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2N4bC9jeGwuaCBiL2RyaXZl
cnMvY3hsL2N4bC5oCj4gaW5kZXggMTE2NGFkNDlmM2QzLi5hYzc1NTU0YjVkNzYgMTAwNjQ0Cj4g
LS0tIGEvZHJpdmVycy9jeGwvY3hsLmgKPiArKysgYi9kcml2ZXJzL2N4bC9jeGwuaAo+IEBAIC00
NTcsNiArNDU3LDcgQEAgc3RydWN0IGN4bF9wbWVtX3JlZ2lvbiB7Cj4gwqAgKiBAcmVnaW9uczog
Y3hsX3JlZ2lvbl9yZWYgaW5zdGFuY2VzLCByZWdpb25zIG1hcHBlZCBieSB0aGlzIHBvcnQKPiDC
oCAqIEBwYXJlbnRfZHBvcnQ6IGRwb3J0IHRoYXQgcG9pbnRzIHRvIHRoaXMgcG9ydCBpbiB0aGUg
cGFyZW50Cj4gwqAgKiBAZGVjb2Rlcl9pZGE6IGFsbG9jYXRvciBmb3IgZGVjb2RlciBpZHMKPiAr
ICogQG5yX2Rwb3J0czogbnVtYmVyIG9mIGVudHJpZXMgaW4gQGRwb3J0cwo+IMKgICogQGhkbV9l
bmQ6IHRyYWNrIGxhc3QgYWxsb2NhdGVkIEhETSBkZWNvZGVyIGluc3RhbmNlIGZvciBhbGxvY2F0
aW9uIG9yZGVyaW5nCj4gwqAgKiBAY29tbWl0X2VuZDogY3Vyc29yIHRvIHRyYWNrIGhpZ2hlc3Qg
Y29tbWl0dGVkIGRlY29kZXIgZm9yIGNvbW1pdCBvcmRlcmluZwo+IMKgICogQGNvbXBvbmVudF9y
ZWdfcGh5czogY29tcG9uZW50IHJlZ2lzdGVyIGNhcGFiaWxpdHkgYmFzZSBhZGRyZXNzIChvcHRp
b25hbCkKPiBAQCAtNDc1LDYgKzQ3Niw3IEBAIHN0cnVjdCBjeGxfcG9ydCB7Cj4gwqDCoMKgwqDC
oMKgwqDCoHN0cnVjdCB4YXJyYXkgcmVnaW9uczsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGN4
bF9kcG9ydCAqcGFyZW50X2Rwb3J0Owo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaWRhIGRlY29k
ZXJfaWRhOwo+ICvCoMKgwqDCoMKgwqDCoGludCBucl9kcG9ydHM7Cj4gwqDCoMKgwqDCoMKgwqDC
oGludCBoZG1fZW5kOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgY29tbWl0X2VuZDsKPiDCoMKgwqDC
oMKgwqDCoMKgcmVzb3VyY2Vfc2l6ZV90IGNvbXBvbmVudF9yZWdfcGh5czsKPiAKCg==
