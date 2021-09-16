Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CDB40E4CA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349388AbhIPRFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:05:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:32117 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347968AbhIPRBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:01:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="222649848"
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="222649848"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 09:55:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="509421962"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 16 Sep 2021 09:55:35 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 16 Sep 2021 09:55:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 16 Sep 2021 09:55:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 16 Sep 2021 09:55:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASsp+hmfrekUCzq4CJtWxOwD2dd7KxlW2Rb0eHiCia2iROHycaEeiCEtMACd5BHlsT9hBJpkJbmJ2qoZIB85AvPfRIF5Nz66Iv1QAZdHgK7dWAHaGTlXE9n+ysdL0hsluO3zqcXowA8deARvajKafSedJSgFrqgpYRcfj6SjDyeWju62zIcE6rkZ3imR3eN0m3i1CpZDA7CTgGv4y6cediGTV4Zh/3qkYscNlAaaRD2T5Tk/5cobubJjIUl4KwRerhVoJEYa45zhzeV7btKpw/jU8vEISiEJpz6GnFQSCDW8PuKtrFhiSjRs/DCKVwXj9Ud2oBK+H14TH5yIEGlVqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WosWUw0o3fczH2NOU8yV926zS4vyFgSDCikeqnH9yZM=;
 b=c83MY8RicThqbfyYs10GVI7vg8HxfqA/kABgDnQAMSJA8LZiXJkW/KzLAKvbJ5Ut/p7IJ17ejUOtt2i2918tkBJOiLHsKqMT5qTvFrRDE+BJ6UsmzzPxwdZ32ve3lK1cE4yE089qqLJT6+zYK9WxIHW9lMYSaqKf0SDOrG1axSSeFDE2CTWI21CHwEyPcuJ/nCpjFYd6MFMIB5DxV599voCvzr4hgwPGmP9ki3OJzJmQnASrO8dEaf3JgF/ZM8OhPTxa+TrnzyVbLLR67hWyiPy+sxCUxLUlz20hZq1imU7xxQqoMERa41SXBG8xzuWO7D5l5c03gRR2oLXVzSBQpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WosWUw0o3fczH2NOU8yV926zS4vyFgSDCikeqnH9yZM=;
 b=RnnfXQqMeIpdqAbHdx52RzqmanU7L/yPgG6QaoxR7SCOtcLSH0kUc/zVB2bLFJKu9Dh2q6ispGxrfozeRALdKkk82MLAullsf9mFPCw/QSNViMUDKY2K6fua5cb6cVjkBqDyy7m1LmBly4THbg8wcUtCpKM8NNUXpmBxDoWy6Oo=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM6PR11MB2681.namprd11.prod.outlook.com (2603:10b6:5:bd::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.16; Thu, 16 Sep 2021 16:55:33 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 16:55:33 +0000
Subject: Re: [PATCH 5.14 046/432] cpufreq: schedutil: Use kobject release()
 method to free sugov_tunables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Kevin Hao <haokexin@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <20210916155810.813340753@linuxfoundation.org>
 <20210916155812.370609496@linuxfoundation.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <8969cff0-ff69-caa1-4a89-4feefd8ed2a0@intel.com>
Date:   Thu, 16 Sep 2021 18:55:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <20210916155812.370609496@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR3P281CA0065.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::20) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
Received: from [192.168.100.217] (213.134.175.198) by FR3P281CA0065.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Thu, 16 Sep 2021 16:55:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 225bbf57-3bc8-4783-a0e0-08d97932cc64
X-MS-TrafficTypeDiagnostic: DM6PR11MB2681:
X-Microsoft-Antispam-PRVS: <DM6PR11MB26810DD457333194F785DB45CBDC9@DM6PR11MB2681.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zEVGXtuprqs4M+ciAFXfUAKdIaHQQH8mTVfm0SJGQ243OWPvUrwrhK0P7uY/Yc/lsScK384SbfU1KapC3NJbD5fYpECCIbmKLqzIPbVC8zw4VR0ZAs09Ob317mRoAEYq40pYJOb92HBty/c0LPgWDNEqbve/igekvKFTV2ZIUsJ6c50vvFOtCfD9KN5nC9YKQLmaUflgcaQdHwT9feN9j/XUJafNY9xAeXTefn3K/tnuTX4LKLTk+gRJAVsgQrddF3W9hTKTJ0qrzh8pma1xuLJpWHZyehMqbrBDBQUGxCSDtNOMqdKWTXuZkYTjiYUfGbxJ1iI7YJqdDqjxZ6eIYDG4LQW/nclVhUUPdiVXzhBRMpa286HIGHP0oA29LohxcEqQkFspY3VjTcRmH+DSTycg+1guvqcFDU2705jpY05ehKkMillzrugAKI6WXetZhuSEpIaM7iuuOWr8xGZR0qHNPi4yTVk/O8u24lj2OeTWuF4Gsk6BETUCiOMvaYV7WLdbeT38ops9mBpgfc2YGDfZ/aU3oLWUYUsMxWHaTWj6G37P8sXmg3sJ7PEilC209wOm8hdZXlkheVClG9gIIZz60Teityd0+QCiXJ8cq2QN5eV7oI63HkHnMWpt7svqgQrRVcYi4J2toetVCWlG/9E6qQD56VIS7yuCWFn2b+4Ckz01VLOJTXL9Ps72WZmjjHwTglhVRxIwU5bepGGFOWswRnNyLNcuUeRgXEMAOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(16576012)(66946007)(8936002)(36756003)(66556008)(316002)(66476007)(6486002)(8676002)(54906003)(6666004)(36916002)(478600001)(53546011)(2616005)(2906002)(38100700002)(956004)(5660300002)(31686004)(186003)(31696002)(83380400001)(45080400002)(26005)(86362001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0pJRWZIUHdRS0JDcVh2WWRhUWp2TEhSS0NlM3hjU3pJY3JOemFzb0l1M3JC?=
 =?utf-8?B?cW5SVkdLY0lWMFJOSEdYOG9yTGJxY21NQ2MvSE13TFhCUHdQM1ZxT0VFY0pv?=
 =?utf-8?B?MFdpbDBoVTQyZ25GV1FJQ1lPTldVellpMlRXc1Fvd2FmOEFvR3RUMzNVSDJF?=
 =?utf-8?B?dVFHWnVpN3lHYXlNUVhsSGdtM3JkUEgrQW1tWXJnUG5yN3BTaHBEUXByNnd0?=
 =?utf-8?B?bnNObUFpazFhUUlZSVVXdWpGbW5QbnBBREZ0N2M4aW1XdlNBVGIxcU9uNS93?=
 =?utf-8?B?bEtRcDE5NHAwZTJJaEFUVnFMcEtkOEIwZGVaUzZLVmZhV05Tb09BbEFzMng3?=
 =?utf-8?B?SXA4U1FvNHJIYkZ1VVFraUUxTjYzVFpWemVCVHEwa2M3eVVZMzhGYzZHSko1?=
 =?utf-8?B?WUFSYlVhbUNhdTlZOFAwdCs5Y2g2eDJvbW1wU25JanNTQlYrUzRveWJHOFRH?=
 =?utf-8?B?NURnc3ZDVXBXVHozN1FiMjA2Rm1yaGxoVzM4NGNsYUd1NkJoOFpmSHVvZHhS?=
 =?utf-8?B?dEFMamZzaWxLZWx3UUQ5UUpPWmlBSDljTzhsZDF1bEgxVjFXYzZsaGFUa01N?=
 =?utf-8?B?b2d4bzllU1BBY1lZZFg1NzNnMTUzYmJyTW43TkJBT1B6OXFaaDVWbTFkMUFB?=
 =?utf-8?B?VkI2c2VKRWpWQmFkNEdXbU54Qm11TEtQM2M0THJmMFBjZDdTVWlmLzlEeGk3?=
 =?utf-8?B?bUZrcUxFU2JDc3ZLU2toU0Q1SUx3ZGg2NmllZjN1S3ZuT3BuRlJLdFRiSnd5?=
 =?utf-8?B?cCsyR1FIMVYrQnRTTWRuWXZLMHFzdnBmUmZnUVY5Nk9ZYktzNERKR3pVOXNJ?=
 =?utf-8?B?Vmc2T05tTEpBVFRNa1lWU1BxTXk0YnV5UUNFamJGckZ6QXhhWmhkd2ZxSWxF?=
 =?utf-8?B?ZkVYbGtuMHE4L1Zqd3Y2Mlk5VEJqTU5zd1N1M0RSWDVUNlJqT3pmdVdpNENH?=
 =?utf-8?B?UnhmZ0ZJTGsyWnFVV3RpMGNuU09WNXoyRXRMcDlwMUNSYTdVaFkyUCtoWkx4?=
 =?utf-8?B?UmJxdVN5UnZKVjdycThrcHMrYVBla0Q5QUJqaUl2Rkl1aGVmRDl4NmxSSTh3?=
 =?utf-8?B?V2lQVFhTVUJzSDVmY2hjQ2hWOENzMkNJbnNTWmUrTkFJNm1WRjZtVnZDdUM0?=
 =?utf-8?B?cDJFb1Z0TlFnQ1c1bTZaV3pPem5yNnQ0ZXdvbk50MnF2QTVROE1OcUxjK1FO?=
 =?utf-8?B?VmlVWWMzM29SM0JPYVJtTlBvWndvNm9PMU9HZXB3V1BTY2QrSmkvUUgrb3B4?=
 =?utf-8?B?LzRDRmYvYVlVWlBCS3NwTUhpUEpIeW5GQy9TN3NtSzd2alVla2JGeExMZCs4?=
 =?utf-8?B?eTNrbVhVTFdQN25FTXBqVW0yNkJ0ODNYeGJIaFl5OVF4bENWUzBkRy9lcm9k?=
 =?utf-8?B?TDVVTyt6N3RSbFpUMnhtMkVrVkNVb0JVUzVDSEpBREp5a0pzbUdNUFpzWEdI?=
 =?utf-8?B?SmdnRXBLTzhkemV4U3RLb0hoQ0xGdkJUWjVjS2NqbDdjcmJTeEZlZGRkTnk1?=
 =?utf-8?B?blBQN1VKckdENkxOMTZNTjk4UUtCSXJpK3d2b0ZxTThqQWNabUxRRmZZWFhx?=
 =?utf-8?B?c2tHZ215Uy9hL3B3alNjdlRsak5XWEd5ays0ODZCMVg4QUZuU0FzRHRnS1Qr?=
 =?utf-8?B?SHBoRDhpUUtRWUpyUnZFNkZIL3Y5RW9XT3g0dmxnQndyTjZUMnRIUWlnc0Ev?=
 =?utf-8?B?aCtkVjYvVVdaSXdibURNVHF4Uml1NEZydllnUkJ2eVB0Zkw4N2R4OUZxbHJk?=
 =?utf-8?Q?4GC7oA9fZ6jBP55M90kn98MRwA7DrDhC5MMQYks?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 225bbf57-3bc8-4783-a0e0-08d97932cc64
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 16:55:33.5293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtKXDw+sqRP+EFOUXd9UvNCMahXxxZcm9eDC3e9BsDpXKcGNc5E5yHTdjxNOIv0gf/uch9dHxmIzVB0QyhSQrLUkn2VKTfzqOwye3ax6tzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2681
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/2021 5:56 PM, Greg Kroah-Hartman wrote:
> From: Kevin Hao <haokexin@gmail.com>
>
> commit e5c6b312ce3cc97e90ea159446e6bfa06645364d upstream.
>
> The struct sugov_tunables is protected by the kobject, so we can't free
> it directly. Otherwise we would get a call trace like this:
>    ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x30
>    WARNING: CPU: 3 PID: 720 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
>    Modules linked in:
>    CPU: 3 PID: 720 Comm: a.sh Tainted: G        W         5.14.0-rc1-next-20210715-yocto-standard+ #507
>    Hardware name: Marvell OcteonTX CN96XX board (DT)
>    pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
>    pc : debug_print_object+0xb8/0x100
>    lr : debug_print_object+0xb8/0x100
>    sp : ffff80001ecaf910
>    x29: ffff80001ecaf910 x28: ffff00011b10b8d0 x27: ffff800011043d80
>    x26: ffff00011a8f0000 x25: ffff800013cb3ff0 x24: 0000000000000000
>    x23: ffff80001142aa68 x22: ffff800011043d80 x21: ffff00010de46f20
>    x20: ffff800013c0c520 x19: ffff800011d8f5b0 x18: 0000000000000010
>    x17: 6e6968207473696c x16: 5f72656d6974203a x15: 6570797420746365
>    x14: 6a626f2029302065 x13: 303378302f307830 x12: 2b6e665f72656d69
>    x11: ffff8000124b1560 x10: ffff800012331520 x9 : ffff8000100ca6b0
>    x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 0000000000000001
>    x5 : ffff800011d8c000 x4 : ffff800011d8c740 x3 : 0000000000000000
>    x2 : ffff0001108301c0 x1 : ab3c90eedf9c0f00 x0 : 0000000000000000
>    Call trace:
>     debug_print_object+0xb8/0x100
>     __debug_check_no_obj_freed+0x1c0/0x230
>     debug_check_no_obj_freed+0x20/0x88
>     slab_free_freelist_hook+0x154/0x1c8
>     kfree+0x114/0x5d0
>     sugov_exit+0xbc/0xc0
>     cpufreq_exit_governor+0x44/0x90
>     cpufreq_set_policy+0x268/0x4a8
>     store_scaling_governor+0xe0/0x128
>     store+0xc0/0xf0
>     sysfs_kf_write+0x54/0x80
>     kernfs_fop_write_iter+0x128/0x1c0
>     new_sync_write+0xf0/0x190
>     vfs_write+0x2d4/0x478
>     ksys_write+0x74/0x100
>     __arm64_sys_write+0x24/0x30
>     invoke_syscall.constprop.0+0x54/0xe0
>     do_el0_svc+0x64/0x158
>     el0_svc+0x2c/0xb0
>     el0t_64_sync_handler+0xb0/0xb8
>     el0t_64_sync+0x198/0x19c
>    irq event stamp: 5518
>    hardirqs last  enabled at (5517): [<ffff8000100cbd7c>] console_unlock+0x554/0x6c8
>    hardirqs last disabled at (5518): [<ffff800010fc0638>] el1_dbg+0x28/0xa0
>    softirqs last  enabled at (5504): [<ffff8000100106e0>] __do_softirq+0x4d0/0x6c0
>    softirqs last disabled at (5483): [<ffff800010049548>] irq_exit+0x1b0/0x1b8
>
> So split the original sugov_tunables_free() into two functions,
> sugov_clear_global_tunables() is just used to clear the global_tunables
> and the new sugov_tunables_free() is used as kobj_type::release to
> release the sugov_tunables safely.
>
> Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
> Cc: 4.7+ <stable@vger.kernel.org> # 4.7+
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/sched/cpufreq_schedutil.c |   16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
>
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -537,9 +537,17 @@ static struct attribute *sugov_attrs[] =
>   };
>   ATTRIBUTE_GROUPS(sugov);
>   
> +static void sugov_tunables_free(struct kobject *kobj)
> +{
> +	struct gov_attr_set *attr_set = container_of(kobj, struct gov_attr_set, kobj);
> +
> +	kfree(to_sugov_tunables(attr_set));
> +}
> +
>   static struct kobj_type sugov_tunables_ktype = {
>   	.default_groups = sugov_groups,
>   	.sysfs_ops = &governor_sysfs_ops,
> +	.release = &sugov_tunables_free,
>   };
>   
>   /********************** cpufreq governor interface *********************/
> @@ -639,12 +647,10 @@ static struct sugov_tunables *sugov_tuna
>   	return tunables;
>   }
>   
> -static void sugov_tunables_free(struct sugov_tunables *tunables)
> +static void sugov_clear_global_tunables(void)
>   {
>   	if (!have_governor_per_policy())
>   		global_tunables = NULL;
> -
> -	kfree(tunables);
>   }
>   
>   static int sugov_init(struct cpufreq_policy *policy)
> @@ -707,7 +713,7 @@ out:
>   fail:
>   	kobject_put(&tunables->attr_set.kobj);
>   	policy->governor_data = NULL;
> -	sugov_tunables_free(tunables);
> +	sugov_clear_global_tunables();
>   
>   stop_kthread:
>   	sugov_kthread_stop(sg_policy);
> @@ -734,7 +740,7 @@ static void sugov_exit(struct cpufreq_po
>   	count = gov_attr_set_put(&tunables->attr_set, &sg_policy->tunables_hook);
>   	policy->governor_data = NULL;
>   	if (!count)
> -		sugov_tunables_free(tunables);
> +		sugov_clear_global_tunables();
>   
>   	mutex_unlock(&global_tunables_lock);
>   
>
>
Please defer adding this one.


