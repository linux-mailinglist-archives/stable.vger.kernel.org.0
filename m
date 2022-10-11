Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901DB5FB35D
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 15:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJKNYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 09:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiJKNXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 09:23:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68104A110;
        Tue, 11 Oct 2022 06:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665494592; x=1697030592;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FpLbtzvaTx6ogfg/JZveZrV3QXhHwbwPvV9kFGNDTh0=;
  b=aFDK+j+Gd+x2TbnPv65in1one03GmiPEI0Q0fPI6D/gmdwxatjMfXgd5
   aCGzWz1ykHR12ROcBT/aGEhlRQ0qvOthlsrVhwpsPLQ9YU0hTBEemwpq7
   OV9OmNMFiMGzryDC5rWW+O70AOpJQAGIueVZNbBl8BJ08K4tEFgeUYkAc
   Mz29hGkPucI5g4/n1dgxywv8FdeA5/fTf95969nXo90lnva64AyfT6rK/
   yu7uASx1fecnBS2Hm/c8Ca9pWHjMGtbaisCykBLPe2fHwnzWtVVmzXST9
   ADxwnKAMhjWttU1Idmwf639q4tzAWrfgSZR16tb174joHBAOTZ7KZLIqj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="287764960"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="287764960"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 06:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="955334636"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="955334636"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 11 Oct 2022 06:23:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 06:23:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 11 Oct 2022 06:23:11 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 11 Oct 2022 06:23:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QT2/RIxGFSVGqpGuEE4v4scfmEUP3gmWD7QpWXnjp0JX1TF3VRo+9zy0HEdSF/pofS4/YUjDCr/4poSXNvYHUmBjX59TsA9SAgGycMQcRoY4oeTbSKXk7N9YEbz/OKV2p3AlQxyjrTnoG+HEsZxd4UUkn2p+a+z8W3HqW5uIoLYpR1hZYe0Q530WOWdO/L39utP+oj8PhVIFPHuTRgrRryQJETiQbl0gzWyZiO7DVYq9PQdyxmbRVZSHhVhOVChmGKrard/70yEvHkU8Gr5m55PCl+fLkYUhgeDw2TaSNurqiANsFfyTkSPd5sORGydsy50xW4XVw46XFG2vlXjp7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtfpPIrta0lgx3QqoIKGDXYF1E7NgcmflVsaQQ/OalA=;
 b=Bs+1qnLcxpzRyNrr/+UslomLc+rIW/7HSoR9yaJd4EB4TyXHgPrgyWkhFdf16j9CngMnb/+Cz+YqexMf04z609cr1CkfTPLWZ9mTFnTsjWgwYKET/TqrvUpKypTblJAepUJsDO/bebRy7kVN7YJpoONmJPlYFwCBuwAdobu/tcrMhFzFS/m3xM4ul23ExiQYUIpzkV48yW3EAYRg9vCmCzHtoDK8ytANgL6s17uRJPyjTQFlOpjpichYJyDxSlAzP1dueBjMWFYN/qheYYt8d2YS+JAGOYUXSERFubaqM63bNyJdJItmS5qqAt6OoCAH9mDBV5+l0ErIUymFJ7usdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6206.namprd11.prod.outlook.com (2603:10b6:208:3c6::8)
 by DM4PR11MB7256.namprd11.prod.outlook.com (2603:10b6:8:10c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Tue, 11 Oct
 2022 13:23:09 +0000
Received: from MN0PR11MB6206.namprd11.prod.outlook.com
 ([fe80::938a:4e6d:d912:db43]) by MN0PR11MB6206.namprd11.prod.outlook.com
 ([fe80::938a:4e6d:d912:db43%3]) with mapi id 15.20.5709.021; Tue, 11 Oct 2022
 13:23:09 +0000
Date:   Tue, 11 Oct 2022 21:22:50 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Pavel Machek <pavel@ucw.cz>
CC:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        <rafael@kernel.org>, <daniel.lezcano@linaro.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 4/4] thermal: intel_powerclamp: Use get_cpu()
 instead of smp_processor_id() to avoid crash
Message-ID: <Y0VuKmt5BGfB6nAE@chenyu5-mobl1>
References: <20221009205508.1204042-1-sashal@kernel.org>
 <20221009205508.1204042-4-sashal@kernel.org>
 <20221011113646.GA12080@duo.ucw.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221011113646.GA12080@duo.ucw.cz>
X-ClientProxiedBy: SG2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:3:17::20) To MN0PR11MB6206.namprd11.prod.outlook.com
 (2603:10b6:208:3c6::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6206:EE_|DM4PR11MB7256:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6286bb-08fa-4363-5ce7-08daab8bbd61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9Xp5O1ORQptLGfHh7ApiKQxa8WZiaEwgk6fO4d6OPKkYb0R/5/Nb8a8o7zIcq4xbVxCmJ2xy8Anp4NeCm83vhxD4FVzDztMXrsfn7ErPeC+TUAQd+bWZMDtnXfucLoE1D+B4p0V21X0BgmtQnxcBK6ao+nP8GrNHZHN+jSvBWeHW4akSqwfhl93yAyEk0hHkM8XJ176EMZFOqPsMe0nVaSTxnJvfnhNCCCn19eQw1135HNAjMUdM7rTyoMSr8kSOQrf3KxSsnliNgVmvV+WC1jQQ/Yu0Wn7niScOJLWJJUnIMWM5l/xdnqlKBaP2tlqnxcRRHPu3tde9fenoy7Jdc2OZshq82IkzOI2IcjHXTV2OpA3m+Uakgn5u1c9xEHYZSnw4qkkVg1mxaWJhnW7PKdGa1yzu22KPAh3NN6fwrPIXsRrA4n8/Hr78uQKpXkiWupBKywp+Jd8SMwigBJuqP0vZkcIfhSWRIHjg9N2/u43Bhcokvk1ZJem+GQ15e1dvx8vFKw93htxH6p0L7uzKfE25G2gl0WFzqgxmEtdbcr/PtySd1ozuCw9/fZUHNw3QyJ4uodDYNFMTTGRJm2IL32kELLiI/msyBuTE0uBZr3qHlcZH6gdmZ8Ix7IRYCD/FP0sTkgWNRihO4T1+ou5Jmoul/Y/1oHNuCFMhwgrGSxDe+w2uPWM0aPbh5NhP61JNrxGqWyto3ELIZflkeyZrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6206.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(6486002)(41300700001)(6666004)(478600001)(6916009)(26005)(9686003)(38100700002)(8676002)(66946007)(33716001)(4001150100001)(86362001)(54906003)(83380400001)(6506007)(66476007)(186003)(8936002)(4326008)(316002)(5660300002)(53546011)(66556008)(2906002)(6512007)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bjyj+uTfQrX6vIkG+b3dgDyY9L9ML4/XLYZqm/1i4NAp+fULSg+SF+eHwjKs?=
 =?us-ascii?Q?64veejwh85LXCgUrGo+YebpxasKo5k/XZ5j2B1Db6bjleGpIpZ0ATYWz0Y3p?=
 =?us-ascii?Q?eDpeq8lIYMLeFz1IURgj5iumd+hZLzmFOx6mCtmHgPTPKZJ5ztEbs1boeMnc?=
 =?us-ascii?Q?Bg7/WWOAcSTzlZEWn+UY0BLMvBVK/yIGlzn/bONYKdXdHWqaH3voF82nimCo?=
 =?us-ascii?Q?AquIRnDLG3WZP2kR/GjHNAL60d4hw+qCvM7cr4gDLlvyImXjZpPQ/zeN90Wg?=
 =?us-ascii?Q?3x6yB4aVyKqSBSd7iSJCnE6sRg1R/oAKNKiPMplj/JT8wzwApzTYWkw/0/nj?=
 =?us-ascii?Q?nCqcdVNl534Gz53bGpaz87iSEnSw9p4Qmi+eGYmvCvHgCl5M+LyrM/W3IpBK?=
 =?us-ascii?Q?i/VXlbXHhQNBznh+tdC4Ii4uvqMNsLs+f4dslugNFnCwy3XXaNIEzYBp9A4a?=
 =?us-ascii?Q?REpACh9ETZpOSOODlNG3nmnOaPFyGUyCH1NWw3gFZmyM0DPLWTAHjAKuGPST?=
 =?us-ascii?Q?Ngfv826A5KV4gC7IM1pOkqjg1a3XkLu4viTtkjYebZDeNyCnLKDDA+chokfR?=
 =?us-ascii?Q?LPgkPLokUue+KvbX4vnWrQWTN/lm0a7781KyYmG7SGLubnZ1IstTNP5r+yZe?=
 =?us-ascii?Q?DmHSteCVEo6kEAfcfFCba+X5S4CU/dTyTx0ycskR9x7KPWgCRui2rUyzdLJi?=
 =?us-ascii?Q?I78m7v4HCgdRTuXS5JmW9b6R6tgX4qml9O4aoyVEXKlLXa2xoYjzQuNpDwXT?=
 =?us-ascii?Q?SkxVpRmIwBbnk0B6IMhgjvp4pLKX7MCcTdtpIrqgDCAZ1n/u3opzUMvTUFEe?=
 =?us-ascii?Q?nIm4MXYJ9ELTtRr3IGduUXVIJfIK+Kd29iVlg8kp26oJT8RnI8tZxWx+jbWL?=
 =?us-ascii?Q?QNPxXPbD4scVPRz+I9N0OLP6PHAAYBwUUNY9xYfbJkDZCqlDXjA0SWCBTwWw?=
 =?us-ascii?Q?XWAVL7pkUSqQMuVLWflJrabJHeONuv7StXr0SIuvT9dcUvqicgXd5aDi43mj?=
 =?us-ascii?Q?Qy0qoPk7fKPw4xaL1B060gTfwAxH4Zt1i4ayYz+6qpTYj37FqjgEXBKhAF9Q?=
 =?us-ascii?Q?Y7BYEcrwkDKkVkA643ZQr7iURMkvjEzwLLiPc7pqaBazeLEDGI4coIDy9Jo7?=
 =?us-ascii?Q?7M7KujnPk2aMlxhXHKiH6Zn3Ntx7FnIOOkAhz73+2czcwehjovjPP0dQQN0Y?=
 =?us-ascii?Q?WIZx4hjSQF0o/E7xZJUrL4D85zhzlxJboJ6oz/M1d6CHuCiB8WwHCW1htCMh?=
 =?us-ascii?Q?qwLhacQU1UiIwkSgsVXr0YXgnzZ84tOK3ysVJ5vKYqci7rLClnGVqnPEJgsb?=
 =?us-ascii?Q?IS9rqdaSbJhhQVfiZporRnRtH9VjMTTX+FtUIpEtnQWvrvnJwawfK3SfJ9qF?=
 =?us-ascii?Q?59re1tQSY28X6ku8XqEkrPbERyNUVNCtfkKOVHOLLwLIUWbqTDWfa7oMv9hy?=
 =?us-ascii?Q?x38hJqOT7cm28Nv2cYImm5aPsOpmrbgKKiM7y+nkBwQtBwHpQnm7Frd47tUL?=
 =?us-ascii?Q?rY+o3iuYT8bXwUlQCoTrGVtM0RVrWGBG/vR4ReGPxSbDOLmNL+AkxEXLrDqz?=
 =?us-ascii?Q?sPMu0i3ErkGZU8o5N8S2qmp2cf3gTExgxQRa4l/l?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6286bb-08fa-4363-5ce7-08daab8bbd61
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6206.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 13:23:09.3987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JD/WKlmfd2eVUiIUaVTchOu0r9+tIdVaUwfDDUJ3Ne1vaEqEXxWwAfvmEdHGSamcZD935qBWyEFl4H3SuN6CgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,
On 2022-10-11 at 13:36:46 +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > 
> > [ Upstream commit 68b99e94a4a2db6ba9b31fe0485e057b9354a640 ]
> > 
> > When CPU 0 is offline and intel_powerclamp is used to inject
> > idle, it generates kernel BUG:
> > 
> > BUG: using smp_processor_id() in preemptible [00000000] code: bash/15687
> > caller is debug_smp_processor_id+0x17/0x20
> > CPU: 4 PID: 15687 Comm: bash Not tainted 5.19.0-rc7+ #57
> > Call Trace:
> > <TASK>
> > dump_stack_lvl+0x49/0x63
> > dump_stack+0x10/0x16
> > check_preemption_disabled+0xdd/0xe0
> > debug_smp_processor_id+0x17/0x20
> > powerclamp_set_cur_state+0x7f/0xf9 [intel_powerclamp]
> > ...
> > ...
> > 
> > Here CPU 0 is the control CPU by default and changed to the current CPU,
> > if CPU 0 offlined. This check has to be performed under cpus_read_lock(),
> > hence the above warning.
> > 
> > Use get_cpu() instead of smp_processor_id() to avoid this BUG.
> 
> This has exactly the same problem as smp_processor_id(), you just
> worked around the warning. If it is okay that control_cpu contains
> stale value, could we have a comment explaining why?
>
May I know why does control_cpu have stale value? The control_cpu
is a random picked online CPU which will be used later to collect statistics.
As long as the control_cpu is online, it is valid IMO.

thanks,
Chenyu
> Thanks,
> 								Pavel
> 								
> > +++ b/drivers/thermal/intel_powerclamp.c
> > @@ -519,8 +519,10 @@ static int start_power_clamp(void)
> >  
> >  	/* prefer BSP */
> >  	control_cpu = 0;
> > -	if (!cpu_online(control_cpu))
> > -		control_cpu = smp_processor_id();
> > +	if (!cpu_online(control_cpu)) {
> > +		control_cpu = get_cpu();
> > +		put_cpu();
> > +	}
> >  
> >  	clamping = true;
> >  	schedule_delayed_work(&poll_pkg_cstate_work, 0);
> > -- 
> > 2.35.1
> 
> -- 
> People of Russia, stop Putin before his war on Ukraine escalates.


