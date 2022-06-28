Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D59655F08F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 23:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiF1Vwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 17:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiF1Vwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 17:52:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618E53207F;
        Tue, 28 Jun 2022 14:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656453146; x=1687989146;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vvvvL1Lm4MJ0mGmU3cIdryC1L8Fm7RdZsamqKgKw6BY=;
  b=QPwYt815sFyK6dhk48YXH8zqILdrIYoLgrLsq+chO35HqCfDgcNkMsGQ
   WlnYExEfnX5hwgRqJaoMX99laCpT9dxxqClWOd5zUtbk+8vRV5/Vn6NIH
   /oEJpTQ/Trr/gEBOou5DiEdBuEJhVTGCzN3IbCfCD0fkJqCmyAmGwywkB
   Mj7fqHEpan2Xxa97WMCvv8TQrW3QjqqLhJ0YKISv81ICDPvAeGc2DMS9k
   G8L1tYBGW5fvPCZ6WJi/5OQaNQdLajImxU1Q/mLkPF36CK6aMb3Uj/PRW
   DWLBfpNtwiicwVfxs88vVANOrgEpkU1UyGjQrB9XEtaEfNN+hcY1L63gJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282950818"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282950818"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 14:52:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="717584350"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2022 14:52:26 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 14:52:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 14:52:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 14:52:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvogvrCs9ufB4Soq7aQUj5Z1Dr6/r08fWbI0xsMM4q88z0pCdLx5cK69JmWJVjAz0oeKNXWfJw73Q2sZeMKfVU1VSudXQxlTL6oC8d9gmg77SK8FM05fNGQsoNHhb7tNp/+pz1XzKINywVjxrHKINqZYqipIjdUfMOEgQqsJwUuT85Q8jrF3CMAGYlhfIdfH9+FpG40+o5aU5Pb08zj0AajqB3eClanIG3LbSDD+27/dqNurZXgWH94X8dVXGibLPqc1SgBPNYiuIuMO+3bq7xH1nOg/hDAqx1HfGM2vZRoryDdv/Jok5CxrRmQTgINLi7dv0oQ4fD0YUtxTxAUiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oEsyDOuvN/x2107m6p/UjXH9TiQxZciqo2tGq/pMcko=;
 b=cewKQam3Lj/04KIBnNzWgUCbwnXxTkinpv8tVAdJkCUk9PyBC8fmpcht4PeJZZ5tGHlHNfORS9TFIRNSn/F/fwv0dqdbyfovWq/lr8ll9FFYJztvKCD5Ay87qvIfkXDk2YXPGttzandrYuG/NAEV5u2SCOe4bYWj5li54Dep2/hw8tZ4dYFNrmH2LSXsbXW+et734P/xxtUM4cR7/Elo3NcFN7x6Oaz6sKRhRjO80iNdAife2RqLpWCdLuSsr/kOUl+E2QcjLWN0RNmp8ym2L+0YmU3pjTv0duW9BowxkfyxaO1P3suvUicyhWq9psgWr2lnepVfuqywnHrcRaCl7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SN6PR11MB3373.namprd11.prod.outlook.com
 (2603:10b6:805:c6::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 21:52:22 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 21:52:22 +0000
Date:   Tue, 28 Jun 2022 14:52:20 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "Schofield, Alison" <alison.schofield@intel.com>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Cs, Abhi" <abhi.cs@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH] cxl/mbox: Fix missing variable payload checks in cmd
 size validation
Message-ID: <62bb7814e502f_1bc66e2945a@dwillia2-xfh.notmuch>
References: <20220628200427.601714-1-vishal.l.verma@intel.com>
 <20220628214252.GA1578802@alison-desk>
 <bb3eea9a46c1cfb28d20c6f253ac5c8bd13e8412.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb3eea9a46c1cfb28d20c6f253ac5c8bd13e8412.camel@intel.com>
X-ClientProxiedBy: MWHPR10CA0068.namprd10.prod.outlook.com
 (2603:10b6:300:2c::30) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b571ec2b-d769-469d-f481-08da59507b21
X-MS-TrafficTypeDiagnostic: SN6PR11MB3373:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSfWpTlt9UtkWRdf3IWYmmegZxPHCESMUduLW4pyOd0g9BuDuTagvcaNVR9bnMJZSZw1BmXn01TLtiD/sRTrH5YXTU+aGRcGBg89GqbKw/HzX2M5ZwKSrA6a1PMui5yyqrvzCbyGU8vccH3ikmeI572GumFQ+8Es+ADoW6tIm8+z7qQmstckE/JdyleASf/M1oA5Z3aYSzETVwS+NWVb53K1SkYb8Lz/u2PMC3+/umOsYKOtCweQUhNTXsTZSPetq4tR4iluk17Oc6yVVObmU4Ha8FjU09dPtiLYCVY8AWgLemGeN/+J6mygq250SLc+bkm5xZ12UvYilEt2gKzEhnFMbLMe378BUMYA9WBk+wKS2aArLudbtPihKAYaCWk9Ml+fzgPGg6ADU5yRVJ/ba9wbpKPGCJB5MsgwA2uMQZp8w4bzcDbAMfEFH4O3nHPNdOjT5Pwje6dV3CIiqpC7G9w0vYOvzngC8rm/baw8N2uXxGWG75v+X3v6gBORonp/avQe58XtAb1YARvuBG3UiOCqU590ZfB0Xgzej45OK2sqcxa3ETymq0AKIoeW3tzEufCzJJ2Hc1wvp5neplNKoS/AZhpTLhlR6CE81IfowSVmoEkrqoRZOFl3+a5/cY5NPCpUvbExp1QZ6DTtYOKX9ZwFT0HQo582wPAYV6sp+8OAFv38/uGk/iknqL5CPyG8UvohyJXkGy4H39NDfo/k/5Hl3nSvve0COndlOumI1LRZzEn8m+3De9BUJBcjFL51
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(136003)(396003)(26005)(82960400001)(186003)(6506007)(8676002)(9686003)(86362001)(5660300002)(6512007)(83380400001)(8936002)(66946007)(66476007)(66556008)(4326008)(54906003)(6636002)(110136005)(38100700002)(478600001)(6486002)(107886003)(41300700001)(316002)(450100002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?LPdcfbW5Q9qWSFuX2pJxo6r0pyVes/b3qC6pIupoTv4nEyqTN+5vVfvtWq?=
 =?iso-8859-1?Q?hVK6j/W4aFmFyHG+TJWKUgA0p0K3PHRmHFouNaWAxKIIsI4zMQcDF1W3+Q?=
 =?iso-8859-1?Q?/BEfMLZwO7EONefi+6BGLzebEs5Nd04bkDucV5drJZwGH8aIdcX/K/P/+z?=
 =?iso-8859-1?Q?d7+q6ojUDeVjBYxYMVZya+MYz2YCFBhzTjOw5enKEKyfusS8X5ylU/7x/Z?=
 =?iso-8859-1?Q?NBvzr6Mc7xE/PSWekwa8OvtVYf/0cc1pNkcyMoOdAPaKUzXLtH6R8eWX8G?=
 =?iso-8859-1?Q?cGt5Jyo31dZIw1ocsFyydnM1iC3aUgw8T9ZYMGDRP/h2iT8hn12Dz58oZx?=
 =?iso-8859-1?Q?xbqINx2Tv+6a9/hCaoUKPhKj1DwETcJnAzVN6WCt/iF+WhbwHe7fuJW9L/?=
 =?iso-8859-1?Q?knheKvI/UL4VaDyb8Uec0CrYY0zBAn0i5QL6aRZXiYkMqsex/6XzPMClwU?=
 =?iso-8859-1?Q?9haDG56kH5oAW4NhqRKp99o4RigXGZVhNZXzWcPxMV3VeJy2hN8DpDtqJJ?=
 =?iso-8859-1?Q?B+ng3lSCEjVnB7roTS1yBYCXtnAl5z3bBvERQEdhUaTnAgCVHpx7CbPSRM?=
 =?iso-8859-1?Q?le0/TxOwoD1B9az7xDlcGlRKXuwohyoY4tibx7sXBKUs9JiEThIRmIe4V7?=
 =?iso-8859-1?Q?tPS/DbJ6+unADT6wrtrwBb8cSHr/huebWQBWgyYtP6JGP7eM28fJHTmQnP?=
 =?iso-8859-1?Q?2oEIyxb5MhKttBlMjlsfwJ2v3oOfqdqPobTClq0YWe/XVgnbpHVx2h00Bq?=
 =?iso-8859-1?Q?mUTgEcyY5nNbCfOAqzWt33vfTVPUeVI/19oybgrsAUbwU7D7h6qacnWbL/?=
 =?iso-8859-1?Q?JVPGYAyGTgN8G0jtCyRnYKwDh6DZNOC0h9X7N45Qq+k/ZV2lOnGpKIu8yG?=
 =?iso-8859-1?Q?lJRjXrnAeTtWzStnZQS1x9wG1Ah5sa52snFxaF9d3iowk8BsP9SOYC0lDO?=
 =?iso-8859-1?Q?qxl2KnLjCI7QMtzmSAbrj0HixyEqTTgzGTsFmpOiekt8KZiJBlH0uGGFCq?=
 =?iso-8859-1?Q?xZNNoUl+pnK/lUBycHmdfgd951CctE0dPRR8WYZPmc+pbSAzGeTXGx+OVu?=
 =?iso-8859-1?Q?8q9oqyRYqJdsjx8U7S23jit6yZsXI5oIIZnJxTUdupAloiW2VVXUJJGFTI?=
 =?iso-8859-1?Q?yjxbknINO88KZSXvxHdnZDE5a+QEwq79o+/VgKq+cNlnt2L/wW04M0hJWi?=
 =?iso-8859-1?Q?MgWmUs7+O0NSkHc04YC6ZEDWyFGrSTUJuwxyUQpfhJSx/hRIKf/0umK9Fp?=
 =?iso-8859-1?Q?fOhQYWxq9C7DMCvML2ZZCOTn9cg3hKpNtnKsxklc98QWWySMpSQDSN8VpT?=
 =?iso-8859-1?Q?f4dmNdoI1anBo4NvkADlDF/cbpFvE+S/wQ4E1yOFtvqqJlByy8m/96KIut?=
 =?iso-8859-1?Q?DAxPE8hKdxe9Ve9yefk3oPlhkF6ZxYfgry2/0Uw2Tn6hnU9dTupwTZGy3e?=
 =?iso-8859-1?Q?gxKDsuFaDvtrwQZOvrJRi6AiUFEDev/maRlV9tW7UwcwCj5e2xLCZD7ZQd?=
 =?iso-8859-1?Q?zkxRYEBSo9KisPlfhsVRSR5o0odLkzjmGq3NWnJLU20qOwQIoaWiAbdUpg?=
 =?iso-8859-1?Q?+tJYUrG5JFDdBHhLdiKESxmU4oAMNYAJtgmyOahrTtWVVWedDvgwbtU/3o?=
 =?iso-8859-1?Q?AiOPoWL+AW+5BhO2Y06cmLwPU7A6YYJbGZu8qF0cCHVAp6I0TLl7tlNQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b571ec2b-d769-469d-f481-08da59507b21
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 21:52:22.5518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/KN3/WAXzgQULxFZbmUy6aMVq9L2f6T5mW8/0e+3s+b8Dz5u8WsU3dhjlUY2jrkopxD9Yv7JHvttBf3Rt0GxO7Nb+rhwpTDIu9ockJCEjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3373
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

Verma, Vishal L wrote:
> On Tue, 2022-06-28 at 14:42 -0700, Alison Schofield wrote:
> > On Tue, Jun 28, 2022 at 01:04:27PM -0700, Vishal Verma wrote:
> > > The conversion of command sizes to unsigned missed a couple of
> > > checks
> > > against variable size payloads during command validation, which
> > > made all
> > > variable payload commands unconditionally fail. Add the checks back
> > > using
> > > the new CXL_VARIABLE_PAYLOAD scheme.
> > > 
> > > Reported-by: Abhi Cs <abhi.cs@intel.com>
> > > Fixes: 26f89535a5bb ("cxl/mbox: Use type __u32 for mailbox payload
> > > sizes")
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Ira Weiny <ira.weiny@intel.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: Alison Schofield <alison.schofield@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > 
> > with one caveat below...
> > Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> Thanks for the review!
> 
> 
> > > ---
> > >  drivers/cxl/core/mbox.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > > index 40e3ccb2bf3e..d929b89d12a7 100644
> > > --- a/drivers/cxl/core/mbox.c
> > > +++ b/drivers/cxl/core/mbox.c
> > > @@ -355,12 +355,14 @@ static int cxl_to_mem_cmd(struct
> > > cxl_mem_command *mem_cmd,
> > >                 return -EBUSY;
> > >  
> > >         /* Check the input buffer is the expected size */
> > > -       if (info->size_in != send_cmd->in.size)
> > > -               return -ENOMEM;
> > > +       if (info->size_in != CXL_VARIABLE_PAYLOAD)
> > > +               if (info->size_in != send_cmd->in.size)
> > > +                       return -ENOMEM;
> > 
> > We can leave it to Dan to arbitrate, but I don't think nested
> > if's without brackets follow kernel coding style.
> > 
> > However, Dan didn't like my nested if's with brackets either.
> > He'd prefer using &&
> 
> Ha funny - I had && originally, but then I spotted nested if () a few
> lines above in the same file in cxl_mbox_send_cmd(), and switched to
> the same style :)
> 
> I'd be happy to change to &&.

Yeah, lets go that route.

/me thanks Alison for catching it.
