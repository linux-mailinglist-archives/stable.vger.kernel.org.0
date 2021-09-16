Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531DA40E0CD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhIPQYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:24:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:30230 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241828AbhIPQWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:22:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="222639632"
X-IronPort-AV: E=Sophos;i="5.85,298,1624345200"; 
   d="scan'208";a="222639632"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 09:13:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,298,1624345200"; 
   d="scan'208";a="530223094"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga004.fm.intel.com with ESMTP; 16 Sep 2021 09:13:39 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 16 Sep 2021 09:13:39 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 16 Sep 2021 09:13:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 16 Sep 2021 09:13:38 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 16 Sep 2021 09:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qiy5cU1DxAltdDq9o66OnJFWDEbu/vo+DLIZp3zw5/kJEqm3Q/GCIbgvJSrBGBzY6wE8tpdC4WecoKgKhi9ThX81c+nM24iBnudDZ6ZDNv6jyqUCgZ+kTijWx7YoSF/xNUCoW2Zuj3DZH3MDUTbBmuQSOyF0pY4Q/g22dAIh/f+sRiSBYEwGsQiOjoIvWrscsSTRmdStMD8mMqLFFowWAwV3UQfVuyJDwiS1Xw68tEowePGeItmUfjfV0ZrtFpP/FvJNw6RGqaFGKZWVVIq+mEfQKUBS4EW+Jee977b5N059P4wBQ3iX61ddrDlGmeWY+HKcOTXxmbhix53p2xe8uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lDoAfjO8uZmP35vdCqwrVUr86ZOe8+ejDnhUFQgdFFs=;
 b=nGws4nTzES+CfFTxsO9w/J34Vrre/LH7SP5Rc+FDTsQO/GcKol/HQjHAoX/vZHAlJZnwXVRS6C8xVz1L5umoE9rfNCkQdjG+wslOYMUzEVbzJWfDrZdgiD1TwVHemDTnGXgxgdVpMU8em4/relGOVE/+ejJ6EMRcfBkC3Hs1gJMSK2OnWou+VOTcBjpCGuB25Tf5uunum8CEFXxU7lnqyEVd/Vu3YpUnecXErnlyWKD15NlRXPgRRxN0LBLMjAP1X5zpX59m383Bn3mWyVMBXq+NQ0mebrSyVbrtnsKVWok9y4h6guYOkD8IUaKy9IJa4pFmMQqF8T7LevY9mNIkpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDoAfjO8uZmP35vdCqwrVUr86ZOe8+ejDnhUFQgdFFs=;
 b=t9DL180Xe0wVYzesYXKOulvcQnhN0/b083fDVrlkQxqJYIrJUvmKWF6OstqjCYbE/J/01B0XkDcqOkKzIfP1p687vR5DMboVSsp27e3JImy1qBbRhXMiZs/8rNvD3SY7HmA/osMHIc6iozhZ6z8WE1A/+9tSg3DQPpOt/+kdfXw=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM6PR11MB2939.namprd11.prod.outlook.com (2603:10b6:5:70::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.17; Thu, 16 Sep 2021 16:12:48 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 16:12:48 +0000
Subject: Re: [PATCH 5.10 033/306] cpufreq: schedutil: Use kobject release()
 method to free sugov_tunables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Kevin Hao <haokexin@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <20210916155753.903069397@linuxfoundation.org>
 <20210916155755.075805845@linuxfoundation.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <bb93bcd1-b9b3-fc11-0321-7be6eee5beb0@intel.com>
Date:   Thu, 16 Sep 2021 18:12:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <20210916155755.075805845@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR3P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::12) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
Received: from [192.168.100.217] (213.134.175.198) by FR3P281CA0064.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Thu, 16 Sep 2021 16:12:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8054a4a-3655-4cbd-2b21-08d9792cd373
X-MS-TrafficTypeDiagnostic: DM6PR11MB2939:
X-Microsoft-Antispam-PRVS: <DM6PR11MB293990239D7D0FEA666BC3C1CBDC9@DM6PR11MB2939.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uctj2dDjgCRm1TpAhSw7IVXpviXn3tKhkVrTHhRo8l4X9ycGzDzzS60jxVZHfbOn/t+LFyMe955+32w428fR1cl48eEN1bEUeAvnDz7cmdh95w+HaM0Xczuh1bmGcboltt3hPexsfXI5CixgcSsb4dmcnIl55dKLMrPyMDke5h/gg+U/ucdlkjACx9kJRhl3MYlEFPerIeSEEe4XD4r9K1dsEkZmJuoxNURPvQwxZb87SoNPCUU3av6JGw1XotHVJ5zGpKijKZ8L4ZC1LOi/gsoq0tj3PAoqKr/rD7o0lvcVhe3+g5IS0nsyQPBEuW0QAF5tCoBRVbNzVmd2ZQKzo+9rT7BXLu1yHgNP6vKly0bfDHPQkmn0lJLkPeyY5AIQMe2rLDwaJ4jLoX5n17mPYKrsyAcHrwWJFtkb3MWdeZcB4psZfKRGPSeL8QfWGD0LFF9daeDZCwRAdwGHUZ60VNCK7yAuERMbitroeP+ldp4cUTaWStVjO7TKZ0bztBJGUS0Jg+mJmx7ZE03PAI4bUwygSNlhIs5rqwrMI06rpBsUH2ca+hKfE39EUN02nDNgEuUQxgVwH4H2MAugAK3Lp8PJHEAZmPrI0QxfftidN8u9b9ycVyGSn1ijon4Ygl33TYwyxffXyKx/7exvo2zuByBy+QHJyGBA9UwYLiNU3Tv1zthOFI/BS/SUZsIXoIxo3tMHTAdqBJ8VmjZ+sjAdehvz1qMospZzTR8A9ZaxUqs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6486002)(53546011)(31686004)(316002)(36916002)(6666004)(8936002)(31696002)(38100700002)(16576012)(83380400001)(186003)(86362001)(956004)(4326008)(2616005)(5660300002)(66556008)(66476007)(66946007)(8676002)(36756003)(2906002)(508600001)(45080400002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S25tY3VqWUprVEcxc3RVdi8vZVlWaTRLWU56ZlhGeHBlVXNndG92VHJZaU8z?=
 =?utf-8?B?VG13NnpHSnZobzVFWkJ6YzFiRFhlY2xIaEZ1REtnTWJPRTFDNmFySGI5ZlVJ?=
 =?utf-8?B?eUxBaEZrajJMWiticm9mVzZaTlI2VlFTNFVITlVERWpoMzE2Q1ZlellJQnJV?=
 =?utf-8?B?VUh3a01LZ3BVNDBlSUJDSWFxOGRKZUgrT2FnU25vM2MvM3RXOVBWZHRETThx?=
 =?utf-8?B?WTBwYktnbDFIRVl4RFNPVGxnSkNKU21WRCtaSFVMMGtXZXJ6VXROTWw5OGVR?=
 =?utf-8?B?dEllaE02Q0MxNVpkd0xSa3lqSnA5Zll3WjIrQklMQ21EUzdCOGlvMzVheHF0?=
 =?utf-8?B?anMzNlV3ZVB4SG5icXlRSjQxSTlzWE5NNEJ0dUM3dU5mVlMwM0pYY2RBb2VZ?=
 =?utf-8?B?Zi9QNGFoS0NVRDNoalkzTmExN0VQQ2hrT2tqUkE2N0svM0l4QUIzSjlpTURX?=
 =?utf-8?B?bE1hQjZ5MERTN2w2YTY4MUdwdTYrMjdQTTV4NWNvbGxVY3p5UisxSmVGZGNy?=
 =?utf-8?B?eEM5Z2xGWG9SOEI5N2VWUVRHVFRYcllibWROSzhBWTNIbC9hYTVCRDFxNG1O?=
 =?utf-8?B?VVFwNmtldittbm1XK1lXYmFCL2plODl0aHphd1prMGFyY0hZZWNoTlhPMngy?=
 =?utf-8?B?Ykt1cUFKdGtRUlhEbFdGeVRpWEhHY09QT1pNa0M3OGhrVWFiVHVLRXczU1I4?=
 =?utf-8?B?T2tOVVd3NEVzd1RhZitHelBNYkxSTDZSQWhCN2dlbnM5N2NmYUlhNTJBZVBl?=
 =?utf-8?B?cEN6RVZjZHJaSXJ5SXlBOHczT3JmWEVkWExDbVo5bnhkWkF3SFdmNWVRTEdP?=
 =?utf-8?B?Sm1TNjcvM1JqK0JuK3lFTEJiMDJDeEtvWnVGTGJNMTVRT1lKdHBrRlZpUGdk?=
 =?utf-8?B?dkp6YVFwVWJlMmFmc1liSTZRcmQzMEZMcDRlTXYxaXRkbHZJc2J2eWgrZ0Zr?=
 =?utf-8?B?eVhyYXZVOVZwV3VLSWZ4TFZxSHBuQzN1ZXV6UWlYMEMyanBPblV2c29JVXNB?=
 =?utf-8?B?SjBUNzVZQVVuaTVjMDFCaWI5Y3Q0OWNucjFvemQ3eElYbzQvVEtHNkQ0cjBq?=
 =?utf-8?B?MGNNRFJOQ1U5S0JEUCtJTkowSWZiUG5XZ3FxSTRla0hFVW82TCtBTHNTRlBC?=
 =?utf-8?B?ZWpyT0RRd2dyUWJkMlNVaStwbDhISXhGVjRPMnYrNExZd296RCtYWVBQS2Jw?=
 =?utf-8?B?YTZDWWkyMlJFVm9PLzRjcWs5aElWaGJGL2JITU5CUU5qNCt4bVVNTmpLWFFG?=
 =?utf-8?B?SjUwUTVneDJHQURzS1kra0czMGczVUlhUDM5Yk9BaGl4RDJ4aTNpaFRIVTVM?=
 =?utf-8?B?SDBPUUdKbjVURjFRTVo0ZEt6SXhHb21OTk82YnRCNkk0VVJXNDRxUklxVHhy?=
 =?utf-8?B?VGpTTWRQazgzelFmc2hPVmUwNS81NTZPSkxPTktkRWJHU3FhK2JoMDU3eUMw?=
 =?utf-8?B?UG9EbWtPcXNTbDI4d1hKZ0l4eDFpU2ZCR2pOdDZVcll4MlNWVGtFWnRDWEd6?=
 =?utf-8?B?MmR2ZmVEZ3g2ZDd1Z3FvZGFiV085NG9jNkJ4TEU4MGVJeFVVYVBTc0JZNjFh?=
 =?utf-8?B?TDZGdGhwcGYremgwellVRndxWWlDeGhNNHo4SVZPZVZweU5hb01kdEg1Mjk0?=
 =?utf-8?B?MmZGUHBuRTBmdjM4a0tuZUpySUVsQXhWcFNpaDc0bFYwUDV4SzVQSkhzUUZn?=
 =?utf-8?B?d1NqNjJBcGUwTGtDR29xaWc5ODFZOFZ2L3ZUZEJUb2YwVHh0WkpqaXhjRUt6?=
 =?utf-8?Q?WWlRGhTVlKclpAnX0dPqpPuLurWbwhfwecBe4oP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8054a4a-3655-4cbd-2b21-08d9792cd373
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 16:12:48.4171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERlVEs7AOG0zVB6M1kzMYGdNhaTR3R7bFZVev/HGmZfqLGm41ATj7Vfpp+/cW9nV158yUxOvYtOy+HYcmgpZljji6tSjLdAX7pbjBgsbBec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2939
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
> @@ -610,9 +610,17 @@ static struct attribute *sugov_attrs[] =
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
> @@ -712,12 +720,10 @@ static struct sugov_tunables *sugov_tuna
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
> @@ -780,7 +786,7 @@ out:
>   fail:
>   	kobject_put(&tunables->attr_set.kobj);
>   	policy->governor_data = NULL;
> -	sugov_tunables_free(tunables);
> +	sugov_clear_global_tunables();
>   
>   stop_kthread:
>   	sugov_kthread_stop(sg_policy);
> @@ -807,7 +813,7 @@ static void sugov_exit(struct cpufreq_po
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
Please defer this one.

It uncovers a bug in cpufreq that needs to be fixed separately.


