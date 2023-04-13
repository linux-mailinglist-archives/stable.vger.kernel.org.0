Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588536E068F
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 07:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDMFwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 01:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMFwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 01:52:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4241544B9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 22:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681365142; x=1712901142;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=exkV6PTWyxMkYTClg81gcKQH+13lr1GUDFR5XilDCSo=;
  b=YLrKD13as/MCSHZq2QEx6oBtFEujDmi5+pVDXz9CkHzaQC8YGur/l77R
   aymZy3SL1PtVvo//1xq49D7YSJyNBVCkAdwLXtUOOrCRIOkGvvAPPKQN2
   U21/mOpAqvppPP89jRAGFUYjH7fGGP53uhNRRZ4EomV2PAwtZZuEBkEUw
   zfL4R15En9qYsZTe1ujgqyMH110Kfli1VmTnGW77X/LPtjp4ARyRYdEos
   e/CowWHwXsPEz+bmsLhItslCqUMEesQ+Xx63lQQzCAoa34VSQngsiv8Px
   q+SBJqNIFDIGexa93SQRnEEP8y+SMQo5lNm9jqb3RAkFdRKZ0eFxadBjd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409243663"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409243663"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 22:52:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="758533694"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="758533694"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 12 Apr 2023 22:52:21 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 22:52:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 22:52:21 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 22:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUBwvVoF32hJRcJ33qtLAk0GQnAAgItKdstdVeYzc+HpUHg3dnxKvVxDPs1nS8OG0dSulmSGEV/Siga26HPzHvOYf4tzmfEkCzFUjOA7DS0lXfzNbC2ckLtJCutMjJ8DzUuCZ64BPjNo21ph3ccDAiTyeVRhGRnVIG81WZBFadQnS+3Mxp27rSx756McQa7/vtXqOZexJOnx/ZFFozd6OXKR7plW/jF1j7QrRi+f59PbRzUSMpFBMR/VpLzd744cUTtBeTKRndPVi0eueXuUg7mAyFA46WsKT8uBOo0OgFsmQO2MD5iKz8vZkxi6LIbHjC97mPrILw9n0Z9RsF37Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0WlbZzd7LlNg6+rQEzjj+KQNHHL5uL+IP//c3QiEk0=;
 b=iqMqlt2rEBFMlmitMV9eTfoBh322aWERik2IDLF9v06uarJYeLf+3cGkJHKTLHm0UaWtNRoAIwVLHQyDTY6EC/wDw8+SWLj7TUtuG0NEqG3OUwNkEyJkmWpFjl60QAw5jMBAAWMZOQgzTWOhgtWAqeyEgkWkZbxb9WQEQoSXhdvlughTi2Nfg+xRvtoTkdRa84YMPgEIi8PptWDLzqLvMmt16CRpX/+yv3mLQMbmyx0yGXgxZEnY3ud2KjybNmOJOOUHGYb9cYL1M+ZrHhxl7kxo95czavHCa6l3NBNVomJzwZ4vluucxJTZJNv2Q/lvfNfZTHQY+DRmasJnxoEx9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by SJ0PR11MB6576.namprd11.prod.outlook.com (2603:10b6:a03:478::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Thu, 13 Apr
 2023 05:52:13 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::5ac7:aae0:92aa:74f0]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::5ac7:aae0:92aa:74f0%8]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 05:52:13 +0000
Date:   Thu, 13 Apr 2023 13:49:03 +0800
From:   Yujie Liu <yujie.liu@intel.com>
To:     Pratyush Yadav <ptyadav@amazon.de>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>, <stable@vger.kernel.org>,
        <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in
 smb2_query_info_compound()
Message-ID: <ZDeXz03lMG0RE46u@yujie-X299>
References: <ZC1fJiHvpbXcysXi@ec83ac1404bb>
 <mafs0o7o2h7o7.fsf@amazon.de>
 <2023040539-cherub-flattered-bcc0@gregkh>
 <2023040528-maroon-running-0fe2@gregkh>
 <mafs0jzyqh2sf.fsf_-_@amazon.de>
 <2023040502-shortcut-curtly-cc96@gregkh>
 <ZDZh+7jJgg4DR+IA@yujie-X299>
 <mafs0h6tlb5i9.fsf_-_@amazon.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <mafs0h6tlb5i9.fsf_-_@amazon.de>
X-ClientProxiedBy: SG2PR01CA0180.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::36) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|SJ0PR11MB6576:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab0cb1f-e3bc-474f-4db6-08db3be33aa6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iua9S7+fxiVscyaBGvLderPkMgbTEg0AuASXkanNXZsRUqEroviIJrcqxBG5xE9Xu8ErWD8DoZ7zGsWQswmkvLkil7bs8ROeaHBCNJQBFxx+Gj7xcwE9vlUXfRYcG/M+gM5Bk5XVk/yij8MwAStjDwGWn4405U0EFX9D0D03/5ufWiiCcJ6tiQcdwOmAf/3gh7FDzFLDKVz2N/0CjFpNyUTaptCDDyY7o5hAeB/eXfdsYGWiFxu1QM2ZEy2rh0LOQz5JHUliWOVaL87YBbCX/EWldo2w10/oMWzTUrlRmhFXjRYSP0LA5vh4OJJhC5neB5yqH8T/G6Z02hUr3RkiUrDPSRtsJPbvQgZqL83G3hOyBGk/NBVReWUrPqk6+Jl/l28LumzC0oSwvnY843pRM/y61H7JhqWU7fQ8j6ZsOd6PjvlspVwcXeQ5B4axwgm2yRwDA2jhS7vuEhxrbCrX8qRLGj6F+XoVNs+VKDmWlJXi8kxD1Wp35yMTWIRQ09QVp0USsIBpm/LevuP/iXvIWeclWShC3ssbi3pAWJuD33o/1YuO8BKtVaSXXE0znDEGGlY2ODn4RjK/zTIUOrLbwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199021)(478600001)(6666004)(83380400001)(86362001)(82960400001)(38100700002)(2906002)(6486002)(966005)(44832011)(6506007)(26005)(6512007)(316002)(9686003)(54906003)(5660300002)(186003)(4326008)(8676002)(8936002)(41300700001)(6916009)(33716001)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?indQuZCiWQJoiCPI5cW55Dtz0EuAIWTgMAJvYjTX24YhuxuftcGFXZ3n2ClI?=
 =?us-ascii?Q?VN4rGLJAr/pds5VgxLiEaje3ZGAvTa1ZdpeSZ1aJuknYPzih4eUwAVkcFHH4?=
 =?us-ascii?Q?OBS76VWXrKQ/JbNTKgSSKj50aEVXYWKaSX2w7l1MTjygzch+5yfy32Cv0YXk?=
 =?us-ascii?Q?J/VAKpBfgp/77iJNGPimXNir9PVqncWts9BSnKNIrZqdIW8MxqrQST8RgcOP?=
 =?us-ascii?Q?K7LSujLSTFsCaOFVaVV8V9lRUbii6AvVfdI8eBzaEc8WzuwyyQPmuFAfPUqs?=
 =?us-ascii?Q?O65Wq4elMFcvDQM4dxZgcbW57H+ILVIskLPslAJD1h1PVQ/RVd+kCOu8Icdx?=
 =?us-ascii?Q?p/MP5HUSFAUORHVjx65Uge5oinIq5N1YiWhNDefPgfXZrMJ3eVrEmJRvu2nM?=
 =?us-ascii?Q?FVDLfRINstYbL1lp0b+vH2aBz1WtvWk2bX1t2mExJx8hHai0oA92cVHkGVrD?=
 =?us-ascii?Q?PSukQmP88aUTNHk58nk95N8BDp3dDIlX/F3lLcPu2x0b44mqPfVuLY7Tt4WK?=
 =?us-ascii?Q?K0xlz9cLJ0oqJ7lNTY7vKpH/R4c4ZBAvPKEh9LNWPsaVAQrB/rntH+PxPxRZ?=
 =?us-ascii?Q?nmUkvqUjDp2IdPEudLmSPff7ClnikIJwNT9reOG0r0CSzJcknrx/ok68iwEj?=
 =?us-ascii?Q?dPcRouE2i4mi6HjYQRh0qa0zG2gQt9HzNq7sqT+8zCMJoAXjNn3ycjssDsk7?=
 =?us-ascii?Q?gU7UJEPWLmvYRep0JN/EZ2K6ArP+o2XeRrg2FWLMxk8TAvnFrL3SL+0+rSMZ?=
 =?us-ascii?Q?BopOycDzNPJzc6hVf5ZWHnocOaolkmI0Jaah2WLshsVJYxgdJMYwsPMS4UT3?=
 =?us-ascii?Q?919V91nxGxEw7Cc1csPBSRg6z40toEwOBX5sWsvTioDnBrkwf9DkcRcinsVl?=
 =?us-ascii?Q?J8Bbti6gGlmu2lFeBdZCJktdrjWBAic0sdH3cMXBcqtCvWMsqAFS0OKAd+xa?=
 =?us-ascii?Q?piGWFx98SqIy57DRNkghhlUAqxGZBN+V5I6ZMKSUjairV/NHjs5jUGxV6ceq?=
 =?us-ascii?Q?tTOPcTJ6d6/HyDlp932Vzdbvy+Qqe77wLDyqc639DHpjUMsmXIKkj2KlFDfr?=
 =?us-ascii?Q?/UE3muM5x43XhLdszB3rMceATH3NXmBCSNbSnx6irhl+2j5v2sCGFjpSroZ0?=
 =?us-ascii?Q?djsTwhMo8ONVwx2PULcPN95pK5CD7Df67VpOJ5vt0hCq/k4Sodxo2s/yxFaR?=
 =?us-ascii?Q?ibsFbeo83iZ51sRNKHWXgR+gxAgeR/ln7m+8od4H8IAD7dyTwybF160MY2qU?=
 =?us-ascii?Q?8e/Mt/qLFp2A2Xy2PzmLPMRAPMo4vUvrSZA0i+dz5Jk+RQpROxEqJn11by8C?=
 =?us-ascii?Q?9rOVUThEapstf2fTFtcE67F38Gpc5mQB76d710EIzP1CtJim42rSxDqkNE/C?=
 =?us-ascii?Q?J8F9iQJ2VgwtaXLFMgNrYwmJ4nMnJ8279U8Fg+lHJxCH6Urxt6a5f67abXIE?=
 =?us-ascii?Q?ugO4v40YtWq5NuW2Ne49IigcpdqG7NWaQBZws4VPK3jwHHENWjdPh1IeEhp7?=
 =?us-ascii?Q?P4EH8+0+Og9D31Q2nTVZ7dBxmQIl24g65aXFsP5RXVJGeTu+b22RbwOruodZ?=
 =?us-ascii?Q?Kldjfx0oAaWw+XLwqKK77ypUMj0VfcHTkl0/2IaZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab0cb1f-e3bc-474f-4db6-08db3be33aa6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 05:52:13.4480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctJfOaYIu3ixfV2jLXIdFA4aqHfb6qWIEpnY3GRzKs8+M0+rv/jiCPZnSa0ThmyMbg5nnUKqVoJemRYW2ZRbaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6576
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 03:21:34PM +0200, Pratyush Yadav wrote:
> On Wed, Apr 12 2023, Yujie Liu wrote:
> 
> > Hi Greg, Hi Pratyush,
> >
> > On Wed, Apr 05, 2023 at 04:22:58PM +0200, Greg KH wrote:
> >> On Wed, Apr 05, 2023 at 03:33:20PM +0200, Pratyush Yadav wrote:
> >> > On Wed, Apr 05 2023, Greg KH wrote:
> >> >
> >> > > On Wed, Apr 05, 2023 at 02:26:04PM +0200, Greg KH wrote:
> >> > >> On Wed, Apr 05, 2023 at 01:47:52PM +0200, Pratyush Yadav wrote:
> >> > >> > On Wed, Apr 05 2023, kernel test robot wrote:
> >> > >> >
> >> > >> > > Hi,
> >> > >> > >
> >> > >> > > Thanks for your patch.
> >> > >> > >
> >> > >> > > FYI: kernel test robot notices the stable kernel rule is not satisfied.
> >> > >> > >
> >> > >> > > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> >
> > Sorry the info at here is not accurate enough. We will improve the
> > wording.
> >
> >> > >> >
> >> > >> > I think the robot should also learn to look at the 'To:' header :-)
> >> > >>
> >> > >> Nope, the robot is correct, you submitted this incorrectly.
> >> > >
> >> > > Wait, maybe, I can't tell.
> >> >
> >> > My point is that it does not matter much if stable@vger.kernel.org is in
> >> > Cc or To. It gets the email regardless. In fact, that seems quite a
> >> > common practice to me [0][1]. So I'd say it would be nice if the robot
> >> > did not needlessly complain about this.
> >> >
> >> > [0] https://lore.kernel.org/stable/20230403140414.236685532@linuxfoundation.org/
> >> > [1] https://lore.kernel.org/stable/20230403140415.140110769@linuxfoundation.org/
> >> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=87f93d82e0952da18af4d978e7d887b4c5326c0b
> >
> > This warning is not caused by "stable@vger.kernel.org is in To or Cc".
> >
> > The document at [3] gives three options for sending patches to stable,
> > and seems option 3 should apply on this patch:
> >
> > [3] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> >
> > Option 3
> >
> > Send the patch, after verifying that it follows the above rules, to stable@vger.kernel.org. You must note the upstream commit ID in the changelog of your submission, as well as the kernel version you wish it to be applied to.
> >
> > The examples in link [0][1] have "upstream commit" in the changelog, but
> > this patch doesn't, so the robot flags a warning.
> 
> It is entirely possible for a patch for a stable tree to not have an
> upstream commit. For example, I sent a patch recently [0] that was
> caused by a buggy backport. The patch to fix it of course would not have
> an upstream commit since upstream was correct from the get-go. The bot
> should not complain about such patches.
>
> Funnily enough the bot did not complain there even though that patch
> also does not have an upstream commit hash. But it puts
> stable@vger.kernel.org in Cc instead of To.
> 
> [0] https://lore.kernel.org/all/20230411130210.113555-1-ptyadav@amazon.de/
>

Thanks for the information.

As for the patch at [0], the change log has:

This assignment was present in the upstream commit
5891cd5ec46c2 ("net_sched: add __rcu annotation to netdev->qdisc") ...

The robot wrongly considered the phrase "upstream commit ..." as
upstream info. Sorry about this.

We will keep improving the robot to understand various cases, but still
coulnd't avoid sending false positives sometimes. We apologize if the
robot makes any noise. We will fix the robot to correctly handle the
cases discussed in this thread. Thanks.

--
Best Regards,
Yujie
