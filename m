Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAFC68C484
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 18:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBFRXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 12:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBFRXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 12:23:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E5BF761;
        Mon,  6 Feb 2023 09:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675704172; x=1707240172;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y3j96Lo4tcCUAM11K88+qUIyYIk4QK8np/IfP89Vs7w=;
  b=nMqKAGjjBeINPis1j9SRXUEL5f5mRAJg7wQAhMGh1VguH5LPw9bX3wkg
   xbI4S/xi/15iwuFP/VAVHsIKlzVPtrvPHgsyR4ewq4YwJu7uC4r14hrIo
   iG58rPjBq3h0zjlIOlDVODtBNnithobfWKhTJ5JlNJlqgjAPfG1hOy+1+
   803lpH8rGk+n2CD8FvbuBFd9XGaH7ao/3G9DzzIFzMqNAeVc1GFDooQoR
   5T+6N1A4d2Ihs3K5f0bt9e1ec20irmOVh0ZigNbGt/a6PHYBVtJKB73zj
   35Qwlbl+Xs96P56/BsYJqV5zBIY5cpRAcXfl9JQ0RqBfpXacCmALOE9gj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="312914977"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="312914977"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 09:22:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809201673"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="809201673"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2023 09:22:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 09:22:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 09:22:49 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 09:22:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LETjxV2r+nPfRwMY8Ri6Gg1tbixAhajBpBoDJX2vZPSxvZ7SUKet8kvL982+JiM4bm4XL9Yjnhzi6u+IdZuaocl7+LD6FEygmY6gmrar//OTI3Ywr5XhiEQPsBrwvP+Y5iuQwbjqJt+Ok4/Ys2SAqT2Rv1y1eJMq7XkeyoIqWW6eo/mOMSBhuRolJM0yYPzpnbIrkNstdvNaCWEb/L2YUmmgAoxkw7ol9z+7LOd6YXKdqWe0yjMD8rwZPh9rXOcaPi8Ez6GPAQpJEpem/nvUN2cHtJF5aEugi9f6LObGJ5TefgqJOT0vdJ5f3t1HoEGencQsaHBaYsRdtYewHddFhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rt04NDI4TtkqGFvWGyk0dMaRo+lDx+QoDzE7svu1NT0=;
 b=VGQzEEqN/9ZNkv0fy7HFYZ+0OyNGGmTCqXkiQmRje0RgjC8Ce0WNn+C8fa492wR0BlJ/ccwBo6RbAwBIoOWJ6/HMN1Kt1p23PHtW8R79zB91SZQXKSn8lF3R1ajMToUSG7myo1A2nESNWUEAxnGf9l7yz5wS5XSYixZPx6UY7IDmmwrQKG/Sleuzfj6goGK2rhSK6KTL8j3eQgwuvxGWco34oHV3i2ojvysCgQ/rCjRKCPMeSH+ySQuYfqMhDPyIqm03TS8muQg+HifSFPsR63W+aWDFFjCEeX4Cu/mw/lj9ypI17DhnKm+rXGz84HMlLdSK9BqEDuAoA8FSxGq7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Mon, 6 Feb
 2023 17:22:46 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 17:22:46 +0000
Date:   Mon, 6 Feb 2023 09:22:43 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, <stable@vger.kernel.org>,
        <dave.hansen@linux.intel.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 10/18] cxl/region: Fix passthrough-decoder detection
Message-ID: <63e137638dd94_ea22229467@dwillia2-xfh.jf.intel.com.notmuch>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
 <Y+CSOeHVLKudN0A6@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y+CSOeHVLKudN0A6@kroah.com>
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ccb526-11b5-4492-cb96-08db0866c399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/lRc8PpSu5AjGjXkhorBIcEHNQ6wFvGDI0Y/bGT63gyHbd3Y+VoJ+H9gv3XIj2EAOZ4JnuJR/hliVFluyQcRx5754rRxRn1FoNV83GQ0keMX6K2ZtOakj+s0M4qi2AVW/Dq02x9MzHYJ06wPKRTbAlh7UH/smEfSeHshUACkqEe6hvxzTZyqLHxL3wgIRabrneXxp2kwFO1kwWsTNS7yh/lD3H+rIxg6XswtlAg5+PwcrbNVL9uzn1D0s0wR7/gVtNSduX+/55JQw3lcWFhAX1W2qsAET3lhgbjRxfM3Irfqwp8o70KN29ULdtiPxsKwhrOcFRjAdUTFUSIBsos7/cV9LctGqR2/oH78ZzDWL3t2jOBmap1S1mpW/j2blywCPMX1U8OrmFCsjoQMHLKzkH4aA7HLgqV8smkI/x+ZYO8SupE8ezY8IE+QPS7L2Js/PMcdouHMCZ2sRy3kPQcNn3Ojd2P/y7yDz2M2YEJyls7MTTj+TBYuSsP/mBW6BQefqJAcwQBmbq1WlhUl7GLwKLPYqqooow1xZAadG6J3At+op3ARAL57OiOn9jaCPMaoJ0s9AlHZB2+3Jf45yEcoEGYeZ8bWJlRGsz3IGdTYss3L+Jcx9bL17l7QRtQpbsa14rJIY3aV93Vo0QzNWcJIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199018)(2906002)(9686003)(8676002)(6512007)(6506007)(26005)(186003)(83380400001)(6666004)(41300700001)(66946007)(66556008)(66476007)(4326008)(110136005)(316002)(6486002)(478600001)(5660300002)(8936002)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L+mEmvVBpo4KSGYl+RkPQQHHJeTr7GzghDaaQWXASx/9mYHn8RuWg+At8iM7?=
 =?us-ascii?Q?x3aYGqKpEFtQ2VmfINQNV7zN1CWBQ2fpRUp9wcex4mEOHX6hEcCWDkOH2Mge?=
 =?us-ascii?Q?rL8rABd0yvcg6Ax2lhKJn4XDG5TwUuwqpMG6wMgA4N4/06dNHVrBH1zEs0ne?=
 =?us-ascii?Q?xjhOVMjCtIqw+ySnjCbHVxqhKq3PO86l33UQF7hbX9PXA4i4O0k/wGpEht7m?=
 =?us-ascii?Q?/8y0fjpdyHpyHWrG0OS6FaLOmhEvc3eYTVFkQvgne1XQtgcOgDQEiWNhf9oF?=
 =?us-ascii?Q?2FIqNetZBUMrEWc/i5CLJSvrSkGdt9ezUgFonEP/HU0bnKT+ljzIGy4Oi0r0?=
 =?us-ascii?Q?fozhvTjRyZzGpojZMezJ+/n5kFYVlshEyHW5s2lFhqXWw57b3k3xNfogvB4w?=
 =?us-ascii?Q?bGERBFUuduNRhv+fJ3Ry0s8NquGwcF5zwj1Z/IKDuBzgZSD3E/Zb8XzDyE4q?=
 =?us-ascii?Q?Hi6uSD88we57piaST4MxjU5NE9+oALZbwDxqYK9yW0ZBoB2qEjQ5xpQzepA9?=
 =?us-ascii?Q?/h2g0n8/G2f0llxlvzyMjzKSNINf6nvDdbXdqeXNHWjGBpNAPkAuLWB2fNh6?=
 =?us-ascii?Q?ANegSUea+YySfQ85UB50Qi3QOPjjg/XSSzCFRhCb1p7sPC89L1RUSqwGlBHL?=
 =?us-ascii?Q?/t7rcGngornMXE7hvb5Y0IqoLY0Mjq98ZjC6YDmb7wwaKYz0/iH0do2c5QFv?=
 =?us-ascii?Q?em1zl1/vWi4SkJaBVDnEQddHQC16ICeKDVeQN0W1lF0Ntj8POeAOpBgH2U5b?=
 =?us-ascii?Q?c4qF5VJblWNS2dR6zA6aNbJEzAakqT8ecTLLg24ZQAoPJ50yWkzWhcmvHUup?=
 =?us-ascii?Q?mgIqpUFzPHvp7jkfrteUuEiyaA5IFewDbO2ofRTe0m3JFXEwUy8aCNgKK/V2?=
 =?us-ascii?Q?UJ/Gc7vwiktAIFXrVecM5xbYjVs8AldXNzNxVhKSermG2ke6GJZigQq2sTu7?=
 =?us-ascii?Q?2Wz0at4vOL8cldMZ9IsBswQrR4spuWkavXPZ5AUX9s6Epyu2ZZVIsQ+PzT+1?=
 =?us-ascii?Q?HvNKN9pVHtDYXBKgh+Xe3hfZb4pwnW7SwQHW4ipIBE4sVztZ65btuVXLUdR4?=
 =?us-ascii?Q?x0aigp13BvzUSSR+iyy77jT8DBqVBPulMHXCAj6TuDrn4yDOfBcD0GNdhcGM?=
 =?us-ascii?Q?cBQA+okSPtr9b9SFRBXiNaJK0xLg9aLPCpwn7APrXhjRH2YYlU9GELQtL7yM?=
 =?us-ascii?Q?iIoXm40BagwUXWUyq5nEEKOPDpeuM1rgXt3QN0ipRfq1dYyqYUFx5oPTcoRk?=
 =?us-ascii?Q?BpZbqqI9M6RvGG5ukC/BSi6Rpg8+Y6Xk5jRPRv+lj4gjyVeUIjYPm9ysSBjb?=
 =?us-ascii?Q?XF2IMhR9Rn3+CQ8iEsOKALUXyaf26KN8Mfb/28LR6rrDwr49DKRtIVmXQSwz?=
 =?us-ascii?Q?tXCFX13P1H3d2U+fNZu8Q7oVKGb9ODHIm346VZPqO95BMvVCRg4JA3/g8Q/C?=
 =?us-ascii?Q?HAjZApqP0u/GxK+kiBhkuYHg8sXxuKHnbQAhU8BGMJjPapQYaD3mm3pG9QWv?=
 =?us-ascii?Q?YzcUZzJ/V4eWQ4iuXuSfYIW6qlTtRi+6GkER7BZ7zUz1toG4YxwRFc+O9WS/?=
 =?us-ascii?Q?wJevqZW65zxHrKzSMYgYv9s2y75HDZTfvpwuxPIbQJSOAfrzJ49o37CakHUq?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ccb526-11b5-4492-cb96-08db0866c399
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:22:46.5942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NBaSAvLbtmynWILyee57zmt6p8C+gvQpZTE55WJSRiU0DJOFPXWpwL5DIueknALC+2KrPKMn54gUFKSyaZjg12aM7YJ7E0iY75Ubzyku/90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH wrote:
> On Sun, Feb 05, 2023 at 05:03:24PM -0800, Dan Williams wrote:
> > A passthrough decoder is a decoder that maps only 1 target. It is a
> > special case because it does not impose any constraints on the
> > interleave-math as compared to a decoder with multiple targets. Extend
> > the passthrough case to multi-target-capable decoders that only have one
> > target selected. I.e. the current code was only considering passthrough
> > *ports* which are only a subset of the potential passthrough decoder
> > scenarios.
> > 
> > Fixes: e4f6dfa9ef75 ("cxl/region: Fix 'distance' calculation with passthrough ports")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> If a patch really is a "fix" that needs to go to stable kernels, why is
> it commit 10 out of 18?  Why isn't it going to Linus now for inclusion
> in 6.2-final?  Does it depend on the 9 earlier patches in this series?

In this case the urgency is low since the only environment known to
produce this configuration is QEMU. However, there's now a more
important CXL fix pending for this week, so this one can tag along.
