Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C4941F2BA
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 19:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241951AbhJAROa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 13:14:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:36818 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhJARO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 13:14:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="248065675"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="248065675"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 10:11:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="540372638"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 01 Oct 2021 10:11:01 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 1 Oct 2021 10:11:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 1 Oct 2021 10:11:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 1 Oct 2021 10:11:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n67q4H0N/CpYVKkjMnI8QDV12TPweGMoTtLTd83Ajrhsr+4Pnivn+gk0epbgJXiOYbq1sByngjsz1ybJdksLE/IvXd8A/wejQ3Aoy+uMWGgJHN0c/4FjDQqGRdo2W88LSHWNW010gze5hChv1PYF6zFH75pNPq3CmxX6O76n3pArN8CAoACc+aaLFlFufxf6u8UAd/x92DqF4Jv9ar7FkIlbN9/S28Ak4eHAvZU0guS9dpmgYHAL5FTels4lRWurVk9+AYDllApMsMsq8I/ka9F3mIN4kEDFWrucN3nsZs4MTlJevuve7ug+OMHqqh/fA5B1WW5lc1F2eqEd6LO8VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFmAwTWE2mvCxiez88NjaJdD+VHvUKByhgnJbjD86ZU=;
 b=gD84LNwxiwGGFIhJHF8Wld64W5nVZcqlCMPfcgqk9HF1LB8vGxFcCFYH1QZp3mdbenfuxOQt8GjMOtnQR/IaJBRbv7pn4ZtMjt3FiPFg6JCwyVKcsu1BEXyWFJdQup/HKQmR+k+9WSSeSv2vKGNdzD8eFTM/aCEhKHZ/gjksTGQgnoNWXD41AGbqYKbXL7Vh3ze/3IvrQBM/tCAN8kh+eVcMYc1Fgw+6lcxErNn5KmkP3Cdl4Iuj9EI6k6XnOs+1VxFyKjnZvb19Coe6tE47QiMDuZsYwcOSdYnFvUVOvaFiFpDWvTPNg+rnS00Lf9IYaBFiP5pUlvKEAxaQAs/dXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFmAwTWE2mvCxiez88NjaJdD+VHvUKByhgnJbjD86ZU=;
 b=dX59ZqHzEqybbaeHTM9K/hrkT27Ew4AdtXh6PiPQGQGivrXy1nXPWUd3a5gGCUjstfBK9ADAf+J76iv+qTrAU+LzRzmyk9FCeeZEogIPX2YThfzaL4fLDhlS0ATeeoXWS3SPFt9UVbiSuon+88n3VUumLQ/eS+wCW3d5gRTwwEg=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM5PR11MB1867.namprd11.prod.outlook.com (2603:10b6:3:10c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.14; Fri, 1 Oct 2021 17:10:59 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da%9]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 17:10:59 +0000
Subject: Re: [PATCH 5.13 039/380] cpufreq: schedutil: Use kobject release()
 method to free sugov_tunables
To:     Sasha Levin <sashal@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Kevin Hao <haokexin@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <20210916155803.966362085@linuxfoundation.org>
 <20210916155805.299153663@linuxfoundation.org>
 <6592ddb7-3705-6eab-f54c-3f12dbd58a44@intel.com> <YUPB2HlDaoLfNrQ2@sashalap>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <f23cfecb-acb4-6026-f4a7-36971e2c3faf@intel.com>
Date:   Fri, 1 Oct 2021 19:10:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <YUPB2HlDaoLfNrQ2@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
Received: from [192.168.100.217] (213.134.175.164) by FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Fri, 1 Oct 2021 17:10:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4bbaa1f-9ec4-4b8d-be2b-08d984fe704b
X-MS-TrafficTypeDiagnostic: DM5PR11MB1867:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1867DEC4DA8CB6C302E878EACBAB9@DM5PR11MB1867.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPoiLGP1VaZZbAl2WAG6R8LKYoZmNB9i752xi6fRwpYtDnERZi+7mAx3MxfHog40VvrbrRyN4cQIA9jdLO+N0WPJ7UU3IbhMh2vTTElcJXNwts5xmzcCZ0ej2N5ZIPRxYuRj51Apic2MkpEaYjDCp+JG/a410Yc5wAfEgE5Ryb/fMwF8EuW0plM+nO+luJBP3Dh7F0eCtgtbzvM9CeLomnD8SXu9y/tfBVPyX9vjwKPlNvLPXO4DevfBLiXna0fiZrO8ckaAvUezBc3PLCLDiSW8RH61rMjdssOXA+VWAoQ/EwomktgwMjc8VrUmshrNR8S2ly4f2MXqZeNPtFgdEJldZV0xY17FTbAK5fu1shiGy64b6zykpDqD0/WpvEr91DMwysqMiitK9pMqqyHlz0vQxt3OHuuwT/v0SHLpcSyswhu1VgIp3nZ4GlGzhm1q/IU9wWXLQxqdOcHkSYe3VXG0603+z+f85fb34zuPLVXQkuFF1X28bnT7eJUq2S1nyxrH6aqe44tm9d1fId1k9w6vR742msQ7aPXWrZTw15eGOZxOV7KVXugqNBZAJsTjx6fZ28204VJ6LmoRsVhO4aRuIFRjla0xp2odqX3pCevHrbEDTfUu/3zElYmbKxUUIosfgxZ3qLsHvSnnRQgz+FjSpXKc1s9iRwcTcC0dmpO+cUO3aWHuBrwOAydjrKyLMvK112B1twAL3a16QgbawsV2z7I49vvp3OwxCHSoK9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(86362001)(54906003)(6486002)(5660300002)(66946007)(31696002)(8676002)(38100700002)(83380400001)(36916002)(4326008)(316002)(16576012)(956004)(2616005)(53546011)(508600001)(36756003)(31686004)(2906002)(6666004)(66556008)(6916009)(186003)(45080400002)(26005)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzNoN2dHb3QvQm0rZkhFREJYQmxHT0xjMmxoTGRRNVVDUjJDZTZLRlRYdHlp?=
 =?utf-8?B?SlVDQ0FyTnlxSzhUNFh2WHhRSFU3UWNLQStudTZVNkY3N1Jaa3MwRnhzREtW?=
 =?utf-8?B?elJoUEFzanh0dFB6VUgxL1YwTmtqd0xqZnp5Q25ZQmxGdzVoL3REUHl1ZCt0?=
 =?utf-8?B?Nmt2eHJPYURFZUcrdFVtWXJBYU9jZ3ljNUN3NVd1VmFrUmNYRE40SnpuVFdT?=
 =?utf-8?B?d2NIVWk4VWxQb3l0VlJTZ281d3pWRTIwRzdQcFpZcWlvMUovbmNGMitRUjFS?=
 =?utf-8?B?OXJSTWtqN1FWUVhORnAyTVhhMTdNZlpaR2V0eGxSczRBbkk3RldGOG55d3RW?=
 =?utf-8?B?Z0IxMEFpSXVkUmJtU2t3blBnb0VYRGRBNExwQ0cxTmZBR2J5WDBSaGY3S0ZZ?=
 =?utf-8?B?Zkkwb2g2QnpQdlZNRWFDN0c1WmhEWmpteUZXb1YzWFhDSHZSMEZicTJqeUxj?=
 =?utf-8?B?SFo1aFlZeFZjSDFEYnI3Vnk1ZGhOSk1hbnE3aDJldlpSa1N2eVNjT1kvTHU5?=
 =?utf-8?B?cndEUGZjU3dXUTRhQ1dRcm9tNWtWcnl5OXZoT1M0WU1UcDdHY3JILzhWNW1U?=
 =?utf-8?B?U21hSk9EQXo0MTkzVXR3NXFpYU1aWmlVQ01UQWpTTEFwNVRIR1hnWDJWK0VP?=
 =?utf-8?B?cFJOVTRsdFNsclJ5Q1BRK2greVpaUkxEQUhIeG44VW05TzJVODdEQUJtTncy?=
 =?utf-8?B?WDB6eWtxTU0ya1k3RjhPMy9IR0xVNVBBdk1QOTZVanJtSW8yUGhZM2xRMzhT?=
 =?utf-8?B?RE5ZZGRGcUkyb0pDMElmNUo0czNycE14ZGFxMmUvRW1raUtyQzR2U3hRakFt?=
 =?utf-8?B?NjNPUmdzS2s0dkJSTEowVFhwbGo1SzM4RWRFSjUvemtEZ3NOMnMxSEpXM0VX?=
 =?utf-8?B?bk1peGhYVFdqL1dYVm5QQXNsYnVZK2VXckxPT1pRblUvU2o1SmVjNVhwOE5j?=
 =?utf-8?B?VUpIclhhaGxmeHo5VkhRL2lVVUJJSlNIM2l5eHdDTk4yeUdMY2NxNk9ycTAy?=
 =?utf-8?B?bUhmVXkrUEN4dndzeEFHaDUwckhRcitIcWgxb3p4bXJhR3R3OExkZVJWNmtT?=
 =?utf-8?B?MWJ6bjl1NjRJWnd1NUNKZXZ4em9NRGJhT0I3YnpKUXNKWUJZYzBuaDRpRzZC?=
 =?utf-8?B?OGdObmtZMUU2cDllZjdyVDRtQnA1QTRUNGxBS21WTEV5b1R3enVSV1ZCSlRH?=
 =?utf-8?B?eTlsOHlGcFZ4VmJLUW9MUnRvUC8wRFhnVzhNa0FHUFlhMyt1N3VDZ1NuanMr?=
 =?utf-8?B?NGJnTkhlUEE1R3kyZU1LenQyenFFOXBiT2EzNmxuNGFGUHdibi9IZTZWWHBE?=
 =?utf-8?B?ZGFZMmFQZ2NkWGVhT1JEVGpKbU1FMTlUUlpEM3FYWHdrR2pHT0tzOC9Obnls?=
 =?utf-8?B?ZG1MeEdOZUJmMHZ3NTZQcjRMbmd5TisxZmM3UnRnUk5mNmtlY2xnSXNwc2ZD?=
 =?utf-8?B?dkI3OHBBc2lIalNrZlEwazVtUXVrcjIwWk9uQVRuUHZEOHQwL0wrcTQ5WGRP?=
 =?utf-8?B?bHVCOCtrNmN1VUVjQnhqTDR2a1UzSk9sVlBUMTZrVGF1Yk1INkpzYW44d2JY?=
 =?utf-8?B?a01zdVF1LzZ2TzNzVVBsNU1CWEtQdmdMYTJONUVWc2xBR3orakRoQ2wzbkd1?=
 =?utf-8?B?QjFRSTYwTnZHZTdkNEJFUUZLVXF4SmcyakQ4UG4rQVJ2cyt1WXV6eUgzWEZa?=
 =?utf-8?B?NUowTjhPOTFYdTU0WTRzc2hER0NzVTBwUVJEcTJ4SU9wMm43b0VVdEJHTDdT?=
 =?utf-8?Q?JhZ+gCsxMQ0CgZ29FHD3rcAnPIuWUyqGH9/feMk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4bbaa1f-9ec4-4b8d-be2b-08d984fe704b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 17:10:59.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kTb/0WUh0LTA4/lUGKmL60S/MOQWX4DfRZ3nitUsopGcsFRQwQhkOXXEsXVriucDOQ0WJo7T0fgSkoGrExKt9XVsEat8cnRAcPiaOfDXPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1867
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/17/2021 12:14 AM, Sasha Levin wrote:
> On Thu, Sep 16, 2021 at 06:55:49PM +0200, Rafael J. Wysocki wrote:
>> On 9/16/2021 5:56 PM, Greg Kroah-Hartman wrote:
>>> From: Kevin Hao <haokexin@gmail.com>
>>>
>>> commit e5c6b312ce3cc97e90ea159446e6bfa06645364d upstream.
>>>
>>> The struct sugov_tunables is protected by the kobject, so we can't free
>>> it directly. Otherwise we would get a call trace like this:
>>>   ODEBUG: free active (active state 0) object type: timer_list hint: 
>>> delayed_work_timer_fn+0x0/0x30
>>>   WARNING: CPU: 3 PID: 720 at lib/debugobjects.c:505 
>>> debug_print_object+0xb8/0x100
>>>   Modules linked in:
>>>   CPU: 3 PID: 720 Comm: a.sh Tainted: G        W 
>>> 5.14.0-rc1-next-20210715-yocto-standard+ #507
>>>   Hardware name: Marvell OcteonTX CN96XX board (DT)
>>>   pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
>>>   pc : debug_print_object+0xb8/0x100
>>>   lr : debug_print_object+0xb8/0x100
>>>   sp : ffff80001ecaf910
>>>   x29: ffff80001ecaf910 x28: ffff00011b10b8d0 x27: ffff800011043d80
>>>   x26: ffff00011a8f0000 x25: ffff800013cb3ff0 x24: 0000000000000000
>>>   x23: ffff80001142aa68 x22: ffff800011043d80 x21: ffff00010de46f20
>>>   x20: ffff800013c0c520 x19: ffff800011d8f5b0 x18: 0000000000000010
>>>   x17: 6e6968207473696c x16: 5f72656d6974203a x15: 6570797420746365
>>>   x14: 6a626f2029302065 x13: 303378302f307830 x12: 2b6e665f72656d69
>>>   x11: ffff8000124b1560 x10: ffff800012331520 x9 : ffff8000100ca6b0
>>>   x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 0000000000000001
>>>   x5 : ffff800011d8c000 x4 : ffff800011d8c740 x3 : 0000000000000000
>>>   x2 : ffff0001108301c0 x1 : ab3c90eedf9c0f00 x0 : 0000000000000000
>>>   Call trace:
>>>    debug_print_object+0xb8/0x100
>>>    __debug_check_no_obj_freed+0x1c0/0x230
>>>    debug_check_no_obj_freed+0x20/0x88
>>>    slab_free_freelist_hook+0x154/0x1c8
>>>    kfree+0x114/0x5d0
>>>    sugov_exit+0xbc/0xc0
>>>    cpufreq_exit_governor+0x44/0x90
>>>    cpufreq_set_policy+0x268/0x4a8
>>>    store_scaling_governor+0xe0/0x128
>>>    store+0xc0/0xf0
>>>    sysfs_kf_write+0x54/0x80
>>>    kernfs_fop_write_iter+0x128/0x1c0
>>>    new_sync_write+0xf0/0x190
>>>    vfs_write+0x2d4/0x478
>>>    ksys_write+0x74/0x100
>>>    __arm64_sys_write+0x24/0x30
>>>    invoke_syscall.constprop.0+0x54/0xe0
>>>    do_el0_svc+0x64/0x158
>>>    el0_svc+0x2c/0xb0
>>>    el0t_64_sync_handler+0xb0/0xb8
>>>    el0t_64_sync+0x198/0x19c
>>>   irq event stamp: 5518
>>>   hardirqs last  enabled at (5517): [<ffff8000100cbd7c>] 
>>> console_unlock+0x554/0x6c8
>>>   hardirqs last disabled at (5518): [<ffff800010fc0638>] 
>>> el1_dbg+0x28/0xa0
>>>   softirqs last  enabled at (5504): [<ffff8000100106e0>] 
>>> __do_softirq+0x4d0/0x6c0
>>>   softirqs last disabled at (5483): [<ffff800010049548>] 
>>> irq_exit+0x1b0/0x1b8
>>>
>>> So split the original sugov_tunables_free() into two functions,
>>> sugov_clear_global_tunables() is just used to clear the global_tunables
>>> and the new sugov_tunables_free() is used as kobj_type::release to
>>> release the sugov_tunables safely.
>>>
>>> Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on 
>>> scheduler utilization data")
>>> Cc: 4.7+ <stable@vger.kernel.org> # 4.7+
>>> Signed-off-by: Kevin Hao <haokexin@gmail.com>
>>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>  kernel/sched/cpufreq_schedutil.c |   16 +++++++++++-----
>>>  1 file changed, 11 insertions(+), 5 deletions(-)
>>>
>>> --- a/kernel/sched/cpufreq_schedutil.c
>>> +++ b/kernel/sched/cpufreq_schedutil.c
>>> @@ -536,9 +536,17 @@ static struct attribute *sugov_attrs[] =
>>>  };
>>>  ATTRIBUTE_GROUPS(sugov);
>>> +static void sugov_tunables_free(struct kobject *kobj)
>>> +{
>>> +    struct gov_attr_set *attr_set = container_of(kobj, struct 
>>> gov_attr_set, kobj);
>>> +
>>> +    kfree(to_sugov_tunables(attr_set));
>>> +}
>>> +
>>>  static struct kobj_type sugov_tunables_ktype = {
>>>      .default_groups = sugov_groups,
>>>      .sysfs_ops = &governor_sysfs_ops,
>>> +    .release = &sugov_tunables_free,
>>>  };
>>>  /********************** cpufreq governor interface 
>>> *********************/
>>> @@ -638,12 +646,10 @@ static struct sugov_tunables *sugov_tuna
>>>      return tunables;
>>>  }
>>> -static void sugov_tunables_free(struct sugov_tunables *tunables)
>>> +static void sugov_clear_global_tunables(void)
>>>  {
>>>      if (!have_governor_per_policy())
>>>          global_tunables = NULL;
>>> -
>>> -    kfree(tunables);
>>>  }
>>>  static int sugov_init(struct cpufreq_policy *policy)
>>> @@ -706,7 +712,7 @@ out:
>>>  fail:
>>>      kobject_put(&tunables->attr_set.kobj);
>>>      policy->governor_data = NULL;
>>> -    sugov_tunables_free(tunables);
>>> +    sugov_clear_global_tunables();
>>>  stop_kthread:
>>>      sugov_kthread_stop(sg_policy);
>>> @@ -733,7 +739,7 @@ static void sugov_exit(struct cpufreq_po
>>>      count = gov_attr_set_put(&tunables->attr_set, 
>>> &sg_policy->tunables_hook);
>>>      policy->governor_data = NULL;
>>>      if (!count)
>>> -        sugov_tunables_free(tunables);
>>> +        sugov_clear_global_tunables();
>>>      mutex_unlock(&global_tunables_lock);
>>>
>>>
>> Please defer adding this one.
>
> I'll drop, let us know when to bring it back.
>
You've just picked up the commit that this one depends on ("cpufreq: 
schedutil: Destroy mutex before kobject_put() frees the memory".


