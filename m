Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9C240E4F2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347685AbhIPRGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:31341 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349326AbhIPRD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="308156170"
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="308156170"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 09:55:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="433850560"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 16 Sep 2021 09:55:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 16 Sep 2021 09:55:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 16 Sep 2021 09:55:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 16 Sep 2021 09:55:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nm6MqIdKrVaG7B3CrTLyjnDhsas2rWAoDCQjAdoeICRsFW9M0PpwC7pXG3nIhX+DfpVJGZWf/ABxn1ciJ2UbJ7JMOp0Z7Yx1+rudJGaIQxzIZhHa/U5k4nn39U5CgOoAPEmXcjlhakN6xa/jeMgJQUygbKNYRdBP06D4guG3HomYBl3E3QH/eCT5KUCfCTQgFbyKNEMwqOp5CSJJOYBtSSfWwLtSTc98Vg9QO/GiYkTx1vYJtvy5oAWJ/VTQUT7YzYUhGsOphVqVjZaPh63bobv7xP/PCbjGMqu5yybcVw4r5h2lHiPSVllrbd5Pw5u/83MGxO/2RRKW8ll9rCFj1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i2+HZPCkwxRLum5J35ZtBYC6eGnwp63kPsKZNQiPcP0=;
 b=MDucHC/7XQblYF4vaDu96nO6KUWqS5JplKtqcPfhF146frDaUgY5IgM1MceoJTnFNgzbxpXlfPIuiv1hd3Eha6MsRF9lYqXEevW1nXlIrMWMm2b1kVI41HrjBUA4XfZAY2OIJ8wUxUngMf94Tizv11HSkme+pb/v+RkZxUb1FKFENdcV667l2toIlr0I0c+f5G7s/gIRHz7BSDM0nn1yDpN5b0n23wywT965gZl2pwQp+2zjJSyGkX14oyUBym/4tV7flhy2AY7o5sDjFw/Cj8vwN+tlgKhqTeX3CRQhI3SeFv2YDB/TWylIR/IXSkbOoTOw6wT4LZAZWnoidWabLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2+HZPCkwxRLum5J35ZtBYC6eGnwp63kPsKZNQiPcP0=;
 b=p+k1FQySNcIvx+oBtmR2WL2dRAoAJJfvpfE1BGSAnvmmPMr9ZcSdf0p1fVU4tt6veJVcVpNlJ0MOMlXAd2C9V6Zhmikz3BjYmVRdJc1G260XP7EKYapBHGaydGys3y5iV+0DGELtLtgATrfy0OAq8wpijq1JQ3F06Hf4Ak9R2Lg=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM6PR11MB2681.namprd11.prod.outlook.com (2603:10b6:5:bd::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.16; Thu, 16 Sep 2021 16:55:55 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 16:55:54 +0000
Subject: Re: [PATCH 5.13 039/380] cpufreq: schedutil: Use kobject release()
 method to free sugov_tunables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Kevin Hao <haokexin@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <20210916155803.966362085@linuxfoundation.org>
 <20210916155805.299153663@linuxfoundation.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <6592ddb7-3705-6eab-f54c-3f12dbd58a44@intel.com>
Date:   Thu, 16 Sep 2021 18:55:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <20210916155805.299153663@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::9) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
Received: from [192.168.100.217] (213.134.175.198) by FR3P281CA0061.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Thu, 16 Sep 2021 16:55:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b151978-88ca-429e-8b34-08d97932d91f
X-MS-TrafficTypeDiagnostic: DM6PR11MB2681:
X-Microsoft-Antispam-PRVS: <DM6PR11MB2681166CF239497566379683CBDC9@DM6PR11MB2681.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dP7avIryMzMQ6qr4RUnKJtCl2OmwqWioSDOC6KInRIsf9WX8aWRnXPQhcZQYAX6mG6Ltc5AMs5yscrcHKjN1Vxg7j5XwAui1q0Y0GK9bgy3MI7d10REKbupQfpDi/cTeRlwVUuPSJ8WJpRCbaBQl2RFJN48aYdw8Civv7FDt/ykZXCqZRxpFIkur3ypqzh56OIKVlPHtQX7BC+Qf4U8NXgpCn7sw7frgxXgU4pVmN+F2aMzL9OQh6h8mIsPubI4+eENvpQSXYe3Sk1U2PSUDFIjUiwzLA9/b/PPRklOHCQ5IkG+ncUzyhpKZBPyjBxzUGQoOnZDimrsIq2+M99J3T8XC1vOsppdKM4vSjYDQBEMxRgFFkhI2DKsSdAkLGXXMOEGC8OdkRaDOzEvGkB2+vHRdip2EHp8CUhfO8brgtmgBrqRwsj8dC1itBBWkZzGOaSIDFGsqjRsO77y29QHC7AEK5jshEAVmySwK/yoz/PkPJvuNwWQwtx4MVWbzOS/dH0Bjw+/MXnzVdWiaDlvwwCmXObA7tQ1dnmqxhqQrokiXYYDdtPAp9TIHfylyToawMhNwBHe8cpPWo9IYCHFaoilGYWC+7l/2X1ZYivNLTfba23s4W7hj1sy5TXQ5Abypl7FCBcr7igBajIY1b0T4XyVUjGGWaisXznyjSOA8lrL8pX44ys91a+H3rigujhgp3ePO7FC9S9/S9IBtCU6nr6Ac4uPIm8s2RMsI6khCPeo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(16576012)(66946007)(8936002)(36756003)(66556008)(316002)(66476007)(6486002)(8676002)(54906003)(6666004)(36916002)(478600001)(53546011)(2616005)(2906002)(38100700002)(956004)(5660300002)(31686004)(186003)(31696002)(83380400001)(45080400002)(26005)(86362001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTZxRnBhSUw1dC9PTUIvV2xFenZOZmR2SjFxbDJrZ0xLeEovckFDbkhzTmlu?=
 =?utf-8?B?dkszT3Z0Tk9VanByQzRXcVh5U0lPb0Ird0taaDR3akY0Z1czVFVzb01oZEhE?=
 =?utf-8?B?YmVMS0ZMWkFIMG9kc3NtcDQ5QnY4TlhTTzhjTWtuNjJ5NmNyeHZTb2Y4dG83?=
 =?utf-8?B?RTI1ZlhiRjBEVlRoVlJDSXBlNTZJNUpaSWxYSW94dEF0NFROZVUydzNmWlNn?=
 =?utf-8?B?UlQvM2kwOWxpd1ZJQ1B6UHYrRC92TjF3YlpFRFkvK0dGaGZEMUN1dmRkVmhl?=
 =?utf-8?B?WGZVdFhOcHhWd3VLRGNjTUkrZGt6VGRBMDFJc1dtWWMrS0xtQWF3UENDZzdF?=
 =?utf-8?B?YmxJbXhiOElnZFJqbEpjTDRUaVVRVEkzZndXNjV6Mk1ONXB2N3JJeFhSUDZ6?=
 =?utf-8?B?Smx5UkVKdFZsWE1RN2dpbkVOUjYzdkVpRGhFQ0g1Vk5KRDZTSEJ1UkFzQVQ2?=
 =?utf-8?B?dko1Wk9hREpZR0FteHRiR0ExU2NqbXA4aHVvMzBvTUVKWk9JekVwVXZKMkxY?=
 =?utf-8?B?VmFVN0l6azhCZnpldHlQdHFDSnRhR3ovYk5sblVsUUdma2NpaXdERHlyNC9H?=
 =?utf-8?B?Wmg2b05LbkpWbDdINzBhcERMOWI5aVU1VjQwckkvbnYwNiszTTF4TlhPejZi?=
 =?utf-8?B?UnVhTVR6MlZQQ014U1lJUVpvdFhGem1DdHk1dVNGaXBrZTNrTkcxYVd2LytD?=
 =?utf-8?B?VEI5WUozNHdmNXh2TXBPd1FVMXMrVG9WdXRZR0JzZERPK3hRL2lJVGVRcW43?=
 =?utf-8?B?UmJ3MHFKdVZCd2tTWnIrdTUrRW1RQUNScDFLZ3hPajFYVHpzNHJrUHl4WUhv?=
 =?utf-8?B?eTVkL0VaSHRXTkRjZlB2U0FEbDFWb2pRVXVqOUNRYmpkV3Z4QjVJSU1sTy94?=
 =?utf-8?B?M2FnZmpmcUNucStMMThQeEp0c2FKN0RyN1ZDUitGZ20rekxxYm9tdi9qSTBy?=
 =?utf-8?B?Z0RwcGZGLytRSllkQk41V2ZsMGpVZkRDTGdPWnhKUUVZTEF5NnlVdCszcXB2?=
 =?utf-8?B?ZmV6MStDMmMzMFpSTVRBWUlHS1B4N2E2QjNhOHVJNGhPS01sYjVPbmdxYXRZ?=
 =?utf-8?B?UzExeC90Qmo3czlOUE02QU5WczNUaVVZMFIrSSt6bWFQQU5NdU1yQTZ1enVM?=
 =?utf-8?B?ZUQ1Z1RoUFJrQUFhSnVyQk9BZVp6Y0g4YzQyS2JGaTBiY05jamdyc0pSVlJS?=
 =?utf-8?B?VnFNbnZhZmRLcEx0T0ZlQThkRkVjaDZ5Z0hNckdWd1dtdTFiYlJxUG4vOUtI?=
 =?utf-8?B?SUtKK25laVMyYStnemZweTYvUittbnlJb0VZN3pURzl6cGxTLzMzaHp5dWVW?=
 =?utf-8?B?TytIcVU0STdpWUhBSWxza0hGa2lxWjgwSFpBbFByYjRudHZlWEhMZ0lFQzFw?=
 =?utf-8?B?WmhQdEhvM1QzekMrYU5GVTM2djM1MGhPYzBiZlpUUUF5UE94WFdxWmg3YXpz?=
 =?utf-8?B?SklSYU5EVGlrMmJtYkIrZUlzd2lCYzIwUndmeXd6VEc5VVN4M2R0MXVSNFdO?=
 =?utf-8?B?Y3dnQWVnSU5SYjN3MDIyMjZVRUkzT0R4RTRZaFc5UlBHNjVaVE9rOVJzd05P?=
 =?utf-8?B?Yk1hemxvWVh4T3R6UytrSDYvODI5Q0dnMzAyY3MzSzlGeVd6ZExiN2VDQkU2?=
 =?utf-8?B?N0tncTBwM1RQR0ZLZmZrVkVxSmVSblB6MWFIWUtTUFdHYmthaDBDcUU2aXYz?=
 =?utf-8?B?dnFjbVF5MVR3NGhrWmJrUEl1SzVhRUU3NWtDNGJQMXZCUXVhTkplZWQ2Zmtk?=
 =?utf-8?Q?mLXbXBZ62xY69759O3l4155lF7GZoX8r+9YPXNU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b151978-88ca-429e-8b34-08d97932d91f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 16:55:54.8675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odO5CbzOwSqAY55Oi5YJCXoFdQVRooB+s7VKBQTIO1e7RWoRrH+KRjvm08ly9RxjXgvffbio2IPTfb8fvYdizDeilNnk/MPsSS63sWoLIsQ=
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
> @@ -536,9 +536,17 @@ static struct attribute *sugov_attrs[] =
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
> @@ -638,12 +646,10 @@ static struct sugov_tunables *sugov_tuna
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
> @@ -706,7 +712,7 @@ out:
>   fail:
>   	kobject_put(&tunables->attr_set.kobj);
>   	policy->governor_data = NULL;
> -	sugov_tunables_free(tunables);
> +	sugov_clear_global_tunables();
>   
>   stop_kthread:
>   	sugov_kthread_stop(sg_policy);
> @@ -733,7 +739,7 @@ static void sugov_exit(struct cpufreq_po
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


