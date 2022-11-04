Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77461A4DE
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 23:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKDWwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 18:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiKDWwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 18:52:17 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4248042996;
        Fri,  4 Nov 2022 15:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667602312; x=1699138312;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Rk+PoUG6OHjqpdJhRfD7VJKq6QxpZJEn5HTk6wavOBE=;
  b=ML/MlUHfMaK5c1PGIUiWeFFud/O1HMCtzayzgapaACGrGVSYKD1cG/r5
   KZLf5RvJYcgcl9NVuTFNqXg8Rf9GCo6IlunDkwk5S8wo9IwaVL6dT81sd
   QEMWsx70iC2c7vg/yAVwatkkPb7mlr6e21oGE1qsvkPUNkaPxOSgNDr2D
   1hEw9bIMu1pzDoEHmCNydNbSaxd6nMQf3IOwER3eLST+ICEIlPn48Isns
   j0Ox/WI5DQFZlG2A+IxV13A3OSOd9yXbcZ7U3Pwd5dNboY9+HQudyQkbA
   F44+6T6mzU9P2kIbc0DrtPQZGN6UKgeDNgppNwkA33QfXjjlsd1njjXEX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="293421088"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="293421088"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 15:51:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="613230686"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="613230686"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 04 Nov 2022 15:51:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 15:51:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 15:51:51 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 15:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqEHb7XqFRWbmscb6++pnJv08flWDb18xORJVlbkv5D3y4fWhCC8QUj2giLf6P2y1jhd9oNS2TC36+v2lVtN9T8xkGQaIK89aYXAokv8IIkXChtlYZQisBum3c/v4DkEXL0KhyXTsdfD7ilj1NdSwnPjQcN91wGEiji8asfX7cBpThhLlbJuXXEmxHj7D7qqNUu9KFr1vtK0J12Vg6+EkQDEHBZZCvKwqkqxwh3BVdQdM7+RlKLFGb7dsgkBJhF1bqNXVrtWgjCFLiY4bkq6ONj4WaQA4P0we/IHwnivT68ul+1O80N4+aDc19JwW2WF28P58qRSuuuPPXHO/S+rjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHaYpWVC3WwB97BjNn+sbYmETSOLSN5jumuPSjuyCek=;
 b=bg+tkCiHZR6vDAIHCkAR+uDBOwQhkZ2t1hJWjY62HEnohvY0Tln0xzSWRFdejBc0QfZhp2JrYgG0glL4zi+kqm7dJYyMoHp3dbTuQ3kIyD6UcVGTvxVlrzDz+PDDyGsB65tcO8jmLcUwGgiiTpF0cZqOhLQtEt4Gzt+uUmhcY19vEQKcJ114dYx3+MwcJ4yygDudTVqKc5Jh/Tl2yJTncNsnZkYipNnbhejRUfX7cIO9xfSSwRRF1O+uOyXJcyyGIoYx03YaxrG8snFk+KmyVsMg/4IJoURNxquqYjHUKpgMr2KmWyQtfi4x0Dcpm+PtlftAHwFP47ck78830a+ayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by IA0PR11MB7331.namprd11.prod.outlook.com
 (2603:10b6:208:435::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 22:51:48 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7194:47de:c1b1:2f63]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7194:47de:c1b1:2f63%12]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 22:51:47 +0000
Date:   Fri, 4 Nov 2022 15:51:45 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "Schofield, Alison" <alison.schofield@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lmw.bobo@gmail.com" <lmw.bobo@gmail.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 6/7] cxl/region: Fix 'distance' calculation with
 passthrough ports
Message-ID: <63659781dc640_1843229426@dwillia2-xfh.jf.intel.com.notmuch>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
 <166752185440.947915.6617495912508299445.stgit@dwillia2-xfh.jf.intel.com>
 <fa869572ab3190e0dacba8f5f133f750e9b30676.camel@intel.com>
 <63656110eb4eb_f52ac2941e@dwillia2-xfh.jf.intel.com.notmuch>
 <31b4e74e-3a6e-d2cf-48f8-7df2cafbebb4@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31b4e74e-3a6e-d2cf-48f8-7df2cafbebb4@intel.com>
X-ClientProxiedBy: BYAPR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:a03:80::18) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|IA0PR11MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b3f809-6607-4611-fbfe-08dabeb72788
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pcwn0QTEjezRHCAK/z1B62I075koNyt9Mh6ZWn8sHCJ8m1RZfS/LX5navvgcuAOrgSy+BViN54XBFX3omkxnNNykN/q2p/dDgsG3YaIuf/EQLKILojIW5PntDaYzh0Hz9ISECY6zqqMrq7gx2hd3VOQaeHFZCiT4jjwYx5Wvup9H1UuPVgdsgZh5IgTVQ0yGL3Uh/gIFDU4bD61gk6zRYlU27aaJngw/Sdmr5msei5CIpIvQ56747m3jLkIVc/5294fm0Tqfd1eJROfMCEBldhZbSoRf0vyBTC2HqOK6a1gJGXC13T3nIYGqgsetmqZTbKRPGR7ZZz6tiMIJftm4y/ZohPtd7tAXdkzQhYjYYvEpA9JJ9d2iQa491JnJagnbgVtvjFt4XoWAp6x2+ytL2lxWHersmwRNzPH8ZkDAdDCVjx9jYk77L6QVrxKRzeFn77xqd3qeFINGtg+syKU8YyMzVMxp1VWZ6pyURj2rRIbikRO945cuOV5Ssqc5l6AaxvKrEgzqEWQX9vEuEdUv5hRZu7XYngo5nDUm84CuaZ4Qw6upRQbkWRMgGESekZzO8UbHX8PY8OS4HPt9tSXHXGYoeSJumTMmhHMNPzltnEQUuhOgjRHRXn17ZMmbp/78kE8fwmWVuHkPJIf93kswVdMrBhVYA2abwNBDNw9979W+VpCezqjgMrZO3MEMTCN5sSiEQrswBtSGjwn3f8nlaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(478600001)(8676002)(107886003)(6486002)(82960400001)(2906002)(66556008)(66476007)(66946007)(4326008)(41300700001)(5660300002)(86362001)(8936002)(38100700002)(110136005)(316002)(54906003)(83380400001)(186003)(9686003)(26005)(53546011)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eE1obmNCS1NYaGFHMUFoL1Z6azIvRTdaNVJhVUVRNEl3OWx4cEY2eFUybWJv?=
 =?utf-8?B?ZHArWWNrZU9uaWV1bVNJMGYvcmpVaDM1cmQvV1JWUHE3bXoyN0JtWmxKQWt0?=
 =?utf-8?B?S2xwaFNlV2xUWjduOFVSdFNxbnJpTGpIYXErYXBkd2ZpYSs1R0lLMjhhNUNN?=
 =?utf-8?B?c1VWMHR2VVRFTGhaS2x0TklVdjZqRVhsSUFRdWx2Q29xbHhmaWZucTdEeCtq?=
 =?utf-8?B?elAwcTlKVEJkZEhoSUNlUlJRZXVpWmNCVWQvbmpvWEtabWxXSVdzY0txNXBx?=
 =?utf-8?B?Nm0vUVI2SHJDYnVjdzRPQWdjQXVWNHJTUktENjV2bE5FMVBqZHF6d3doYTBo?=
 =?utf-8?B?M1l6K0MwT0FoUUZGcXVXN3d0V0c0TEExeEkvS0Z0OUdQamdNOU0rdDBQOS9t?=
 =?utf-8?B?VnRTbHc3TjNGWmhkUkNST2dSY3IrNTlnbXpadHVwTEVIUEVZaXYvQWlNdUpK?=
 =?utf-8?B?eU5JSEQ4dmYyb2dzUCtnOEQ2UFFhbktxNVJOM2RnL0FldDYrOEV5UnEvYSts?=
 =?utf-8?B?TzRIa3crd2t4MDlyMmhPWWI2R2lsOEpTQzN3K1h1VFMxZ3o0MGVaTGtRRS8v?=
 =?utf-8?B?cDdodEtUbjlWVWI3REVGZW1sWkFFbjFaUExNK08yR3IyRU43aG5Xb2pZSG1v?=
 =?utf-8?B?eGJhV0xNa1lFNmpBMVBOWjdjNUFmbEdlVmFHdHByaGRrYjhKUU5TMEpBRUZt?=
 =?utf-8?B?anlxYitBbU9GdGFYN2h6MWpyRE1MRkM0aUdTMzloVGNyc2JBU2ZBRC9hU3cr?=
 =?utf-8?B?TjgzdXdaMTVndmUra0NzMVQxaEFhR1hheSsvUDV1eGlraTlndXJhNEo0Tm8z?=
 =?utf-8?B?a3pJdkRjN0ZhTndIaWwvc3c0V0EySkplVG5Kb0VrLzgyQ3AySEszUHFaeFJZ?=
 =?utf-8?B?TWM5dVl2UFZ0T2JzZ0Y0U1UzZWJzZ24zWkZMT1Zqb2REaXQwc1JoSlFCN1pI?=
 =?utf-8?B?NERkSGRxRHlaZ3JheUFkcVlPUVdpQTJlQlF4dUdoS2hxRXRhQTNjcUt3d2Er?=
 =?utf-8?B?eWlQRDNVWm1kRlJjdnBoZjVPdGR6L1VEOXBwN3JZWTh5WW5rQVFjc2I0S1I0?=
 =?utf-8?B?dXBHQ2ZYRzdvdGdTWmpxZXBtSmhVaWhZTU5kR3lLN1VCYUpLMjNQRmNNSHpY?=
 =?utf-8?B?T3hMdFNpUzZKayt6M2Y4OTBpcGMwR0hUTzJTbXJQNElOL1c0d3NETUErTGtY?=
 =?utf-8?B?bklCY2JpRWd4SzBZOGwzVy90WHBDWFRlWkVhc3BIRk5sVW9jUGlFL0g3Rkpq?=
 =?utf-8?B?UmpJUVJiVGMvZjVFdURRMWpIWFR4cHpjaVBFS1FWK0w1djM1ZENrbjJYNjZV?=
 =?utf-8?B?MCtqVmEyemx6U1p3VG5wL2MvT2JSV1RzOUNOZ3lseVE0d1d4QXE1REFONy93?=
 =?utf-8?B?djdKcEdrTEJJVlNJOXh0UzI5ZkF0ZFlVa1BtOUtxbGs2ZmhFcGRUM2UrbEdn?=
 =?utf-8?B?U3pwK0g3RGUwTGtFejl5NFpFc0NyeXRkYU15WlE4TlZLSG1oM2hScHM2K25O?=
 =?utf-8?B?OEx2SkN1MDl3ak5RQmpQR2d4cUFJdlZSWEcxY2VzK0ZYV2JWWTVGQlZlVGRE?=
 =?utf-8?B?eXliYVhlQ2tPR1ZuOU03TjVpRUpraVBBMFZsaUpudkNmckx0UDhvYWhGQXVY?=
 =?utf-8?B?ZlVEVzZnc3ZxM0xuUEFlVjlwK2Z5QVRHQW1Ddi9pUXZTK0dubnZKdTJYZU5i?=
 =?utf-8?B?ckJBRkV3ajJmMFNYMGo5QjRnaWJCNjFpZmI2cllyZ0F6RjJKcVZxUWNJaVFl?=
 =?utf-8?B?ODdVSWxVYklqaVRvalR4OGUrK3VYRlZHOWVTa25uQ2FPNml6em1SeXA4U0gz?=
 =?utf-8?B?allsbHNFRGIweHBwRHlwQnhwcnpDYkJWb2dJektqUlhmc0VvVE5uSDQ0VUM3?=
 =?utf-8?B?R3hIT0NTdzUwdVIzWVpZeFJjYU4rMEU3ZlN3NEQ0UjIrajZXRXR6NzZzOE90?=
 =?utf-8?B?Z3ZEWlZENTJ6OEdqODVudUdaL2IwOHdmSDZVcTFWbU81dmdBdVNEd2tXTTFz?=
 =?utf-8?B?SklKZDlTdStGZ0lnTWhuUDVESXU1SzRLYitBZmRWN2RnZUtsZ3A5MjNBOHBx?=
 =?utf-8?B?cU5rdERFalRYT2tzNG0vVXVCSisyWlovcWRpTFUzeDFTM1VoRjhzalRjdnp1?=
 =?utf-8?B?b3djMEhyUko1L3NpTXZVWDBkUWM2QXZZYzNlTmZvODZJV1lIakIrR0g0V2hG?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b3f809-6607-4611-fbfe-08dabeb72788
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 22:51:47.9331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z9eG/C5+mWbswcLQ/UtrjMZGwqUrVgeOUBTimrCUx2lxjMCCFXNU6G6ECSXldPt3oaQ5FK8HgHTDUsbZHicxofyp0MA+ZQXObBoG3shYkfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7331
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dave Jiang wrote:
> 
> 
> On 11/4/2022 11:59 AM, Dan Williams wrote:
> > Verma, Vishal L wrote:
> >> On Thu, 2022-11-03 at 17:30 -0700, Dan Williams wrote:
> >>> When programming port decode targets, the algorithm wants to ensure that
> >>> two devices are compatible to be programmed as peers beneath a given
> >>> port. A compatible peer is a target that shares the same dport, and
> >>> where that target's interleave position also routes it to the same
> >>> dport. Compatibility is determined by the device's interleave position
> >>> being >= to distance. For example, if a given dport can only map every
> >>> Nth position then positions less than N away from the last target
> >>> programmed are incompatible.
> >>>
> >>> The @distance for the host-bridge-cxl_port a simple dual-ported
> >>                                     ^
> >> Is this meant to be "the distance for the host-bridge to a cxl_port"?
> > 
> > No, but I will preface this explanation by admitting "distance" may not
> > be the best term for what this value is describing. CXL decode routes to
> > targets in a round robin fashion per-port. Take the diagram below:
> > 
> >   ┌───────────────────────────────────┬──┐
> >   │WINDOW0                            │x2│
> >   └─────────┬─────────────────┬───────┴──┘
> >             │                 │
> >   ┌─────────▼────┬──┐  ┌──────▼───────┬──┐
> >   │HB0           │x2│  │HB1           │x2│
> >   └──┬────────┬──┴──┘  └─┬─────────┬──┴──┘
> >      │        │          │         │
> >   ┌──▼─┬──┐ ┌─▼──┬──┐  ┌─▼──┬──┐ ┌─▼──┬──┐
> >   │DEV0│x4│ │DEV1│x4│  │DEV2│x4│ │DEV3│x4│
> >   └────┴──┘ └────┴──┘  └────┴──┘ └────┴──┘
> >      0         2          1         3
> > 
> > ...where an x4 region is being established, and all the xN values are
> > the interleave-ways settings for those ports/devices. The @distance
> > value for that "HB0" port is 2. I.e. in order for 2 devices in that
> > region to be mapped under HB0 they must be at position X and X+2 in the
> > region.  The algorithm needs to be flexible to also allow this
> > configuration:
> > 
> >   ┌───────────────────────────────────┬──┐
> >   │WINDOW0                            │x2│
> >   └─────────┬─────────────────┬───────┴──┘
> >             │                 │
> >   ┌─────────▼────┬──┐  ┌──────▼───────┬──┐
> >   │HB0           │x2│  │HB1           │x2│
> >   └──┬────────┬──┴──┘  └─┬─────────┬──┴──┘
> >      │        │          │         │
> >   ┌──▼─┬──┐ ┌─▼──┬──┐  ┌─▼──┬──┐ ┌─▼──┬──┐
> >   │DEV3│x4│ │DEV2│x4│  │DEV1│x4│ │DEV0│x4│
> >   └────┴──┘ └────┴──┘  └────┴──┘ └────┴──┘
> >      3         1          2         0
> > 
> > ...and the algorithm can not know that a device is in the wrong position
> > until trying to map the peer (like DEV0 and DEV1 are peers) into the
> > decode. So "The @distance for the host-bridge-cxl_port" is referring to
> > the value "2" for host-bridge-cxl_port:HB0 and host-bridge-cxl_port:HB1
> > in the diagram.
> > 
> >> Also missing '/in/ a simple dual-ported..'?
> > 
> > Yes to this fixup though.
> > 
> >>
> >>> host-bridge configuration with 2 direct-attached devices is 1. An x2
> >>> region divded by 2 dports to reach 2 region targets.
> >>
> >> The second sentence seems slightly incomprehensible too.
> > 
> > Oh, I think I meant that to be s/. An/, i.e. an/:
> > 
> > "...host-bridge configuration with 2 direct-attached devices is 1, i.e.
> > an x2 region divded by 2 dports to reach 2 region positions"
> 
> s/divded/divided/ ?

Yup, thanks.
