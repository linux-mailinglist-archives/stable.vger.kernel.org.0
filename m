Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C7161A06A
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 19:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKDS7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 14:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKDS7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 14:59:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08BA26ADD;
        Fri,  4 Nov 2022 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667588377; x=1699124377;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=SJytII6Ep7Y+7kIn7zePquYujtKLVgs8d6DX9X5/DXw=;
  b=fzjHNVXRRP00u9nQAZxNonDjHwrRC/8ahdIV/epGoqE9kLA+ybeIUpQl
   w8atY/36Y3g60CeJrLWmBq6nf4FaMTJ3V4z3VquPDOVlsmvGaIKeV7eAV
   konHNqfFUm9s+CuB0Mcrw3KLnO58MO3mgDWRaUF8jJXu/FqXxq3B8NUDT
   d5tdvHEjs9Eh3ghJmw9MVmZ/cWKjUO2Mfp5PiCQAn5KYWq63Vx8zDgPDo
   s96CNnsfmoPv6JEJ5w2a0hSFbJkF9SG0hn3YI0J6try6AFZDhoDC/GMkv
   Pql/l0x2lvIlPoJqLUCcisHG6qx8rsIbBJeKTWyBa7uPAWVJ4sG3Q8VkH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="310044374"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="310044374"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 11:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="666470606"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="666470606"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 04 Nov 2022 11:59:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 11:59:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 11:59:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 11:59:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVNNcVuJQ7Gg2/1d+s/vnngz6rhTvKYBpyBCwwPfAQJFK8q40n1HszBpMhiPVCJKtegHEyd+eKCMyu40d+Ia3vlYBkShq+pb1z9SV3UAc/Md7PflllEWYybKAfJ4quwZ9f/IPpEAPW1NUefwNfsGoP2onIuGFjTWCvvi/GpUo8dgxIVK9ETTLFZjZaeOo9iaQDJxCb2iJdMSFe9E7V5jLyjEzHixQdohEwuGNvcKjOIauw7iZnTuCImRTR/188FqxkInGBUk1t1etuuNnc4zVKSXF6nrTYonL9J4Vc5190re5JosNOqM2rNwZqugQywY73w/MrQRv0mESS9zUeslRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHXvi4FjXS8RBKIXfddc0LN83iWFIebu1UgjpzGkqHw=;
 b=mjF0ICJotcSJw0+t5GgdL5dX6udENwBZhSCM1XqTXFml56MfBtqOvX1C3i50QjxRws33CPZE/9lKijDHJpQ79hlO68mklUmkNQxMjANpl78t46f4ULF24m8yGUdNiG6bLgSx8IpY6iKaYiRhesb9Tvfwkpz2hDVg5kfECfuj8apkh4+ta8WKsOFQqQM4A+AW3m3x7fU7KL7/FL1WrrcjPdpw4cLpjfsteEqLbVC3SGg+XrI1o/pbFbZoYI01633c/8ID1blpkjCBtLXCi6UKzctwXj12m2m93IO7sc1aYGl5quZXOUqp3nfJ+w8LrIjZEgMhgxTdfIYZWcT/fC3Fjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM4PR11MB5389.namprd11.prod.outlook.com
 (2603:10b6:5:394::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 4 Nov
 2022 18:59:31 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7194:47de:c1b1:2f63]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7194:47de:c1b1:2f63%12]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 18:59:31 +0000
Date:   Fri, 4 Nov 2022 11:59:29 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "Schofield, Alison" <alison.schofield@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lmw.bobo@gmail.com" <lmw.bobo@gmail.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 6/7] cxl/region: Fix 'distance' calculation with
 passthrough ports
Message-ID: <63656110eb4eb_f52ac2941e@dwillia2-xfh.jf.intel.com.notmuch>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
 <166752185440.947915.6617495912508299445.stgit@dwillia2-xfh.jf.intel.com>
 <fa869572ab3190e0dacba8f5f133f750e9b30676.camel@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa869572ab3190e0dacba8f5f133f750e9b30676.camel@intel.com>
X-ClientProxiedBy: SJ0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::28) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM4PR11MB5389:EE_
X-MS-Office365-Filtering-Correlation-Id: 7225a0a9-3dcf-4725-e253-08dabe96b48f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XliibZACmx6l/u3yw72Y0pPh/N+JiBz2/G5GgUDJnY72pZ9HEwT8yzpMJMxKA9J2shCpfq102+8qVH1vLnNahkin/BKymzJ+qF540hCWjCtd+bY4WQbIPzjSvwkLDGtGxJM9w7v85s43T39LIjrRYsOpBQLr532tLM81a935XD963fYAgmxDSlwa3ie9xfVhq4vat5dYIzYsUgk2KPSxErXZQaOjzcLkKOazvM4lrmWhvDVF5LLMyQEfO6/pSwt63O2KLPpVfZLaOafe0VHozJAg36/bpOsDg4K+XINq8yAQt9uZoWx45pIYm2VsdETA6INE3H4Izh3bCMqbxxZgAAnjMDBb7tkYzz1loPZBcJTa+Uu2YSXa9Ipe1dV/7tYJGyLTe2kAac4k3bxQXZ5UFafQuoOYHXrwexUMCPTmAzlQcGOz8qAzscKjkpD0ONlmSTGibXc4C1dR1OmGjI5wLfyT3bQWH37qKnMsVi/nZx/ctpFERM08Tim0SDgr/iIouPPr+hU7GK+cn0qsASX2CbdjjOZHyyvIe2JAxJ4vsBT+4/OZMpgfRjmH8hj3WrWlOgeItIHfSGY0uyY82AZtaOxAcTKPuwxGX3nZXox0q8b1QZGgLi9AG+qYFWg2LrimsOobc8Bj3Up4Irc8vjUXKGt7ak6ysCJEaV0j3lerCKCJ1o0o1doXMGScoK0aFj4lJQmARbpDPP5bZyXdekNVyoCloPjlHb+XwLHaJOcF48Czd9JM/8pyOtxSJS3ScQf9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(83380400001)(38100700002)(82960400001)(86362001)(2906002)(8936002)(6506007)(107886003)(186003)(26005)(9686003)(316002)(6512007)(966005)(110136005)(66946007)(5660300002)(66556008)(41300700001)(66476007)(478600001)(54906003)(4326008)(8676002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWl6dkZ3QjRuenl4MTZVSWFWdkJxQXVmWTMvM2gxTVlRMlJtbVY3NXBVTWta?=
 =?utf-8?B?bHYwZUFtMDl0WHRZMEhNZlhhcU5LLzNkVGJ3dFI3UlNlci92amMvei9IblUz?=
 =?utf-8?B?c3prZklDeGNtTjZPeVcvT0xzenVtN25qOGU2MUdhL2ZDOHdEMDJkUzlreTN4?=
 =?utf-8?B?QTZ5M1VaZWxPTXhvbEh2alZ5N2RDaDFvaVlkWTh2SjZ2dm1XWE4xREhHSk5m?=
 =?utf-8?B?TGFhendDOGI1Y2dKa3BkR0Z5SzY5Y1h5L255VXFacGUwb1VUd0pKczFPN2ZT?=
 =?utf-8?B?Z1pRSVNoeURkV0FJaGJmcExzZE5NenVGY3pNZlhjdlhOM3JLRERoaExzSEx6?=
 =?utf-8?B?emROOVRsWGNaTktnUFJCRlZMN1lDdmVKNHNxMGR2Q2NLVVgrVTVGNzRHVGNv?=
 =?utf-8?B?OE95bFUrOU5Bd0FTVWhtbUFMQVFTK0tWd2pTbCtVWkJQU2djNDRtWXVkUXpl?=
 =?utf-8?B?SjhaUk9EcUFkTmkxWCtNS2xib0cySmZaeFMxazBwWiswZzVpTW1jN2xtQkZJ?=
 =?utf-8?B?RDlHeHdmY0NTTGx2UElpWkFRVGpBZTNyVHFjM2Z1cWozNG1rVUlmajVIRnBp?=
 =?utf-8?B?MHdiNlYwaU9xdTdGVFNrVllzY2IwU05yVHNIMTVHNHFvakdxTUt5SHNaQXdy?=
 =?utf-8?B?L2c4ZHRpN1F2TWRGYUV3ejI5SmNEQzg1cmVLTEN6ZVhkV2VwLzFvNTVpcDRp?=
 =?utf-8?B?UmFhMFZFTVhmVEJUOVVFVlk4TXdhMVlPcCs3azJpNFN3aDlIeVdDRWMzd3Zu?=
 =?utf-8?B?NTQrNG5nRzVMdVdYcWs3SUJ3alpoRTZnbHVKaCtVMGFRU3RXc2UyOVBUbHM4?=
 =?utf-8?B?c3Q3UUpSM2tjc1VzanA2bzJHaC9ycWUvQThHRFpvR3VBM1A2ZjhCU0ZZOFFV?=
 =?utf-8?B?Z2E1dFMxdGRHUGNMRUdkUXRxVkVmRHFsVlVWRy9qdWFLL3p0U3pKdTlpQlNi?=
 =?utf-8?B?eHUzaGJxN0x0Q0JUWTBlNEQvWGVsSytBZlhabFBEWk1kZStPaVh2M0ZHTEdh?=
 =?utf-8?B?b3J1RVhoQkRtNkl4ZTZSbTNFN2hQa3h4cFJZK0Jha2ZKNEVhRkdPQnhoU0Zk?=
 =?utf-8?B?TzJMZ1BUaHhGL2p1NERvZWIrSEJRK1pxZjlWNGpvVG1mSVVleUJtdEhNazBn?=
 =?utf-8?B?MzRyMDlZUlZHMDc1cmJORWU0cFd2Qy9ROGVPRUNCTmh5WW9ta1p5NHliNExy?=
 =?utf-8?B?S3VMWkllTnljamh2ajVxTFVwL1RHclk4LzZSajZiUzk0UEUyYm5wTW83MndJ?=
 =?utf-8?B?WTBxa1ZLaHZVb010R2JLTkJnMDI3bGs2M0NvWmpxNFkrdnBkNEh6cWZJVlEr?=
 =?utf-8?B?SzdQdmRMcUxjdUtaZy80Tk45bE9UM1dEaXBDRy9jRlJqQklOZ1J3NGdGTGhK?=
 =?utf-8?B?QUVOOC81cmJXUkRsQWlHaFRzQllReExSR2pyTGV0RDQwankwU1I0YTlkLzMr?=
 =?utf-8?B?MlhmWnNQRExja0h0WHVQc1A5TEtaYnRkQjZqbkF0SXpieHFWaTdsYU1BaGJT?=
 =?utf-8?B?YzdIV0tpSmdMTDAvRUtiSmxWekRzS21ucGpSNVpxVHJhWFYzcU92bWY1b01z?=
 =?utf-8?B?V2VOQjFWd1ozRlEybjYwR0hLZzRnMEc2V2F4R25JekIwZGlZT2xCc25NSkd5?=
 =?utf-8?B?eEVITUFFTmVHa0U2bDJMWGNrRVlMRTNwMjdveTNNRmdEMURBcVpFUzRJcTVm?=
 =?utf-8?B?ZlAveUZjT0JXVk5jOWVSVXpwN1ArUmhVWkxJVGEwQlRjZ1d1dVlSVi9UaUtk?=
 =?utf-8?B?d0cvbCthSmovMTk5WnJ4dWV1aHlzK01BL2dvTzRVdXV2NWxINXZ5eHcxd1Rh?=
 =?utf-8?B?WWtkRjRoZlZNM2c5TXdMdjJoUnJJQ1NZYnpFOE5zZUZHUmwxM1NBQjk2Y213?=
 =?utf-8?B?bU1QclNuZWhhbkVYbTNyakxoOWtFeThmSDVDVVc3M2pFMDlKSXFjTGtMeDZi?=
 =?utf-8?B?cFdiYzEyU1RSbGdoQVRjVzBmZ3NtUTY0MU1hVHJuNlpyNjg3dlVYWUYraHUy?=
 =?utf-8?B?RGNrTEN3OFBtQVFiUzllNm8wbkx0aDhkQlJwUlRzYTZsUExQdmRzdHhmaS8x?=
 =?utf-8?B?c0liUGJEMjBsVFJZb2lXTzJkRDQxNW50cUxiV212YzN4SlpSQWRJdHBGSGNF?=
 =?utf-8?B?TFBhRmZhd2JQd2tKSzZrVzg2NE5TRm8yS2dEUjhoa09Fd0dMTlgyV0NWc3VH?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7225a0a9-3dcf-4725-e253-08dabe96b48f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 18:59:31.1921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GycixIacYKuksNGeDC2LIy1/whdX6kpyygnw81FL1997zvUIKArTAolGcLSB+PCJrmmjoNnapyiZ9GE4FNGKhD8e8cX3/34uJEnIZm06CF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5389
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Verma, Vishal L wrote:
> On Thu, 2022-11-03 at 17:30 -0700, Dan Williams wrote:
> > When programming port decode targets, the algorithm wants to ensure that
> > two devices are compatible to be programmed as peers beneath a given
> > port. A compatible peer is a target that shares the same dport, and
> > where that target's interleave position also routes it to the same
> > dport. Compatibility is determined by the device's interleave position
> > being >= to distance. For example, if a given dport can only map every
> > Nth position then positions less than N away from the last target
> > programmed are incompatible.
> > 
> > The @distance for the host-bridge-cxl_port a simple dual-ported
>                                    ^
> Is this meant to be "the distance for the host-bridge to a cxl_port"?

No, but I will preface this explanation by admitting "distance" may not
be the best term for what this value is describing. CXL decode routes to
targets in a round robin fashion per-port. Take the diagram below:

 ┌───────────────────────────────────┬──┐
 │WINDOW0                            │x2│
 └─────────┬─────────────────┬───────┴──┘
           │                 │
 ┌─────────▼────┬──┐  ┌──────▼───────┬──┐
 │HB0           │x2│  │HB1           │x2│
 └──┬────────┬──┴──┘  └─┬─────────┬──┴──┘
    │        │          │         │
 ┌──▼─┬──┐ ┌─▼──┬──┐  ┌─▼──┬──┐ ┌─▼──┬──┐
 │DEV0│x4│ │DEV1│x4│  │DEV2│x4│ │DEV3│x4│
 └────┴──┘ └────┴──┘  └────┴──┘ └────┴──┘
    0         2          1         3

...where an x4 region is being established, and all the xN values are
the interleave-ways settings for those ports/devices. The @distance
value for that "HB0" port is 2. I.e. in order for 2 devices in that
region to be mapped under HB0 they must be at position X and X+2 in the
region.  The algorithm needs to be flexible to also allow this
configuration:

 ┌───────────────────────────────────┬──┐
 │WINDOW0                            │x2│
 └─────────┬─────────────────┬───────┴──┘
           │                 │
 ┌─────────▼────┬──┐  ┌──────▼───────┬──┐
 │HB0           │x2│  │HB1           │x2│
 └──┬────────┬──┴──┘  └─┬─────────┬──┴──┘
    │        │          │         │
 ┌──▼─┬──┐ ┌─▼──┬──┐  ┌─▼──┬──┐ ┌─▼──┬──┐
 │DEV3│x4│ │DEV2│x4│  │DEV1│x4│ │DEV0│x4│
 └────┴──┘ └────┴──┘  └────┴──┘ └────┴──┘
    3         1          2         0

...and the algorithm can not know that a device is in the wrong position
until trying to map the peer (like DEV0 and DEV1 are peers) into the
decode. So "The @distance for the host-bridge-cxl_port" is referring to
the value "2" for host-bridge-cxl_port:HB0 and host-bridge-cxl_port:HB1
in the diagram.

> Also missing '/in/ a simple dual-ported..'?

Yes to this fixup though.

> 
> > host-bridge configuration with 2 direct-attached devices is 1. An x2
> > region divded by 2 dports to reach 2 region targets.
> 
> The second sentence seems slightly incomprehensible too.

Oh, I think I meant that to be s/. An/, i.e. an/:

"...host-bridge configuration with 2 direct-attached devices is 1, i.e.
an x2 region divded by 2 dports to reach 2 region positions"


> > 
> > An x4 region under an x2 host-bridge would need 2 intervening switches
> > where the @distance at the host bridge level is 2 (x4 region divided by
> > 2 switches to reach 4 devices).
> > 
> > However, the distance between peers underneath a single ported
> > host-bridge is always zero because there is no limit to the number of
> > devices that can be mapped. In other words, there are no decoders to
> > program in a passthrough, all descendants are mapped and distance only
> > starts matters for the intervening descendant ports of the passthrough
> 
> starts to matter?

s/starts matters/matters/

> 
> > port.
> > 
> > Add tracking for the number of dports mapped to a port, and use that to
> > detect the passthrough case for calculating @distance.
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: Bobo WL <lmw.bobo@gmail.com>
> > Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Link: http://lore.kernel.org/r/20221010172057.00001559@huawei.com
> > Fixes: 27b3f8d13830 ("cxl/region: Program target lists")
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/core/port.c   |   11 +++++++++--
> >  drivers/cxl/core/region.c |    9 ++++++++-
> >  drivers/cxl/cxl.h         |    2 ++
> >  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> Other than the above, looks good,
> 
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> > 
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index bffde862de0b..e7556864ea80 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -811,6 +811,7 @@ static struct cxl_dport *find_dport(struct cxl_port *port, int id)
> >  static int add_dport(struct cxl_port *port, struct cxl_dport *new)
> >  {
> >         struct cxl_dport *dup;
> > +       int rc;
> >  
> >         device_lock_assert(&port->dev);
> >         dup = find_dport(port, new->port_id);
> > @@ -821,8 +822,14 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
> >                         dev_name(dup->dport));
> >                 return -EBUSY;
> >         }
> > -       return xa_insert(&port->dports, (unsigned long)new->dport, new,
> > -                        GFP_KERNEL);
> > +
> > +       rc = xa_insert(&port->dports, (unsigned long)new->dport, new,
> > +                      GFP_KERNEL);
> > +       if (rc)
> > +               return rc;
> > +
> > +       port->nr_dports++;
> > +       return 0;
> >  }
> >  
> >  /*
> > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > index c52465e09f26..c0253de74945 100644
> > --- a/drivers/cxl/core/region.c
> > +++ b/drivers/cxl/core/region.c
> > @@ -990,7 +990,14 @@ static int cxl_port_setup_targets(struct cxl_port *port,
> >         if (cxl_rr->nr_targets_set) {
> >                 int i, distance;
> >  
> > -               distance = p->nr_targets / cxl_rr->nr_targets;
> > +               /*
> > +                * Passthrough ports impose no distance requirements between
> > +                * peers
> > +                */
> > +               if (port->nr_dports == 1)
> > +                       distance = 0;
> > +               else
> > +                       distance = p->nr_targets / cxl_rr->nr_targets;
> >                 for (i = 0; i < cxl_rr->nr_targets_set; i++)
> >                         if (ep->dport == cxlsd->target[i]) {
> >                                 rc = check_last_peer(cxled, ep, cxl_rr,
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 1164ad49f3d3..ac75554b5d76 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -457,6 +457,7 @@ struct cxl_pmem_region {
> >   * @regions: cxl_region_ref instances, regions mapped by this port
> >   * @parent_dport: dport that points to this port in the parent
> >   * @decoder_ida: allocator for decoder ids
> > + * @nr_dports: number of entries in @dports
> >   * @hdm_end: track last allocated HDM decoder instance for allocation ordering
> >   * @commit_end: cursor to track highest committed decoder for commit ordering
> >   * @component_reg_phys: component register capability base address (optional)
> > @@ -475,6 +476,7 @@ struct cxl_port {
> >         struct xarray regions;
> >         struct cxl_dport *parent_dport;
> >         struct ida decoder_ida;
> > +       int nr_dports;
> >         int hdm_end;
> >         int commit_end;
> >         resource_size_t component_reg_phys;
> > 
> 



