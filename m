Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B0141397E
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhIUSG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 14:06:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:54116 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhIUSG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 14:06:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223466538"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="223466538"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 11:05:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="557043072"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 21 Sep 2021 11:05:28 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 11:05:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 11:05:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 11:05:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhpDOOLUXEffkxPOv0ik0EBObbjXNEuR3Kpdp332J3dPydn6XhmlrAVsxP+5h/B4nmHmym9pMYszmCWn/wx7IoOanIA769Ejzrh7ka9zJtOeUE2JOD+PQxSErV9iSivkpuRq8AMzbrMXdx0riBs9GnGm8+P5flODNfSoxYk57PaPnm6chuYW0bwuYTavelXW4/7NnpVBSMJzQXbHPJpN6RKDplxHCNiJF5fPC3yQJbDAnbzn8xycF0WNJ0jzXcJK51Hyk7SEhm/J1a3lv4Z9zXB/SfyE7EVxON7vtEPxOzw/YM0UEjSUjoeQVnyEQAcd0ctH1gsWS9lcXln+uDSveg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jpG7Tcl/3duURSyetoQBGfjgJkrP3C+fZfQ4zhKT6p8=;
 b=Efc0p5m5NagY4ADoJ7Oqel4mtq15/ihEASPvuxqdKJ4pP16Xx9+avPaymChaZbM9v9mMAt6oB6alXYqEhWXPSf4T3eAUTa95goKghxjiYSMfzHcG7nCBYAvkngSP99TaKwE5O2vi/9wKIRUD1pMyJwyxve9inZWtqg0olHg3njK5fzejXK63OliZuKOV21yPbTwls0FDR/tcT4J0Bkb8Oikqi9kkM/4s9/h1QNqR46kAzPhXCBf6XOZGDG4wIiR5UxUfzbjXOPA23U1m6r3FCRaF/bLwrp8JatYkmMqpDg4aiU6qhBJRuVqgGBXmq8RNVj5XVRz9RV/5KNuNIc+tEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpG7Tcl/3duURSyetoQBGfjgJkrP3C+fZfQ4zhKT6p8=;
 b=BQ0HtohujLmb/BSe59NeAUGLlabw5ru34Ehk4wQCcZzMG5yuoRHX3z4ppISp1Vi49uDrtBUVwwQg2QM+OczXYmTv2GSbQlPL4kgwmYHaxO5IUBrLvxY6+2Fex5o8l5nWK3f5kixg/l1SEpfW5oJDiON5dUWPRSNZ/Vfca1kfGxQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM6PR11MB2938.namprd11.prod.outlook.com (2603:10b6:5:64::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.18; Tue, 21 Sep 2021 18:05:26 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da%9]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 18:05:26 +0000
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <helgaas@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <x86@kernel.org>,
        <jose.souza@intel.com>, <hpa@zytor.com>, <bp@alien8.de>,
        <mingo@redhat.com>, <kai.heng.feng@canonical.com>,
        <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <rudolph@fb.com>, <xapienz@fb.com>, <bmilton@fb.com>,
        <stable@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "rafael@kernel.org" <rafael@kernel.org>
References: <20210916131739.1260552-1-kuba@kernel.org>
 <20210916150707.GA1611532@bjorn-Precision-5520>
 <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net>
 <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net> <87v92x775x.ffs@tglx>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <82c1b753-586d-dadf-54de-6509e70a00ea@intel.com>
Date:   Tue, 21 Sep 2021 20:05:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <87v92x775x.ffs@tglx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AS8PR04CA0072.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::17) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
Received: from [192.168.100.217] (213.134.187.97) by AS8PR04CA0072.eurprd04.prod.outlook.com (2603:10a6:20b:313::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Tue, 21 Sep 2021 18:05:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95968de2-5770-405a-db9a-08d97d2a63d2
X-MS-TrafficTypeDiagnostic: DM6PR11MB2938:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB29387A5A1E0AA59DE9DEDB7BCBA19@DM6PR11MB2938.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e0DKTxuE8AWV5HixncYOlxuJhsVynEivYc2YyBjM3GnxuAWirmh2N9aqeE8uKl9JwteREIgbrx8uR3Q6f99Uy+FFNXm1AZyDRs5CCdPcsk6WF9dslW1ylM3j1Kq+jZqph7vd+2yQOPav9yq3oFpaqJxpYkEdaouc/BEwm4WSt1X4nef+7wqdi36mq1fA232pnkYwkJkB72kGJ8CdSpHPmy9YrVNC/IA759wsCw3FrN32lN9bDIhEIALxkmI8+28P/1AKzT1B0OeuP89TMMn7+MaFWSv/Wd7CmwXKFVm476x68DLfqc88KHkuDsgjcO4DOKDtLZQU/yA++VHLlyys6XzeBjewBz+1+h6cekfAUmMfKOSfCdwiaJQPfBq8MIkxlxhmZmh4jbkn5L/oNeHgNEBvXUf2YmB7HAp5CYXG11AywcjK3DxB2t9xK4xkXsIP3OB097/lnVh308XIF1uQmO0+sIz5ggsCWTuYQgMDnvQsJFLJ2jh8o8gEckEt6HuAzbXHPHkMBH0rrQDf723WWvPba/zuY7SwS293ZuWw5y/N6sFAcv6W/hDEtJwzT/MzirvGKJxEYhAAWzeDhauuze7mMIpGPxxYw67y9d83O1loujbxtYZX0krP03EV4EXLX6rtsX8AWcI39zKVoLH/XiWFEEYA3hAPzfaPB/JkjZISXuV0Sy/+s/RaKfYIzwZJW4lUig/IX8vczjUaXgEqO1GsYcNsMFnn6AxOHMH/oiI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(66476007)(66946007)(66556008)(6486002)(2616005)(508600001)(186003)(31686004)(956004)(6666004)(36916002)(2906002)(26005)(5660300002)(31696002)(4326008)(316002)(38100700002)(8936002)(54906003)(110136005)(36756003)(83380400001)(8676002)(16576012)(86362001)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1YxUEs5Y0ZFUTRWTUNjQTRwNWdTdi90cmgzVzMyTnFseGppTlpKQUVacjNp?=
 =?utf-8?B?UGdpL2NqUEJ1bUZPZi9EenhiLzhjQzg5Y1FDMnNsbFd1b1ZOQndSNVI0Q0Fw?=
 =?utf-8?B?aFFIN2l6Uk8wQXpTZng0ZWpjZmgwRWFvOERBNTlwSnNmU1Z0QUlGQVk0aU1K?=
 =?utf-8?B?dDVWbW0xWUx0NE9XS3ZKMTROSytTbFcwTm5Ddk90cU42MjRwWkExMTRiV05n?=
 =?utf-8?B?VVFMOWtIeE5kMmNLSE5kbUVIT25IbzZrQVFkbFhCMks2R0NQYmh2QXlKQmpG?=
 =?utf-8?B?V1BSUVk0Q3pTRHBiYk84N3Q4NFRzRUFKK2x3MVpoSjllYVhMQ0FzZU1vbldp?=
 =?utf-8?B?b3FKNXdKVlZWYmYzdElqQWkwcVFIWW5wcEp1cW1OVThwVVZYWGlPSXU5dE5P?=
 =?utf-8?B?NTREUXNlaDE4bmpJMlFRQUErRXZhSkk1TzNUbmpKMDB3MHducWd6ZFJwdVRs?=
 =?utf-8?B?QkJhT2dLUjJMSnI1aGs3Tk51VGU4cEM1NHhtcVBGTmVSd3RLdTlMbFl4QjRi?=
 =?utf-8?B?OWtLcEhWeGNPMDk4KzdaQzJIT0NjbVU4MERsdFhpQ2J2bWxFTEUzd1hwcHBj?=
 =?utf-8?B?OHlyd2dDWEx4S3FzaTM2emJON0VQSE9vb2N1MGhlQjNCdkRqMWs5MVJPS2RL?=
 =?utf-8?B?U1hwYjVsaUN1K3M5S2czQ2RLcVhEYWxJT2duM1laSFNBbGxJb0xGMWUrR2J1?=
 =?utf-8?B?WmM3S1poSlJEeGd5THFnQmpabEVYaHR3S0l6OFkxN0JvQnlOTU1PTXN1UTVn?=
 =?utf-8?B?bkcvZHpJQm12b3VkbmowSDIyTWdHOWR5eWd4UnlWRVQrRm9NMXEzNERXUnk5?=
 =?utf-8?B?V1RJRE5INnAxNjJOUUc4TkxmdE1pVXRmM2hSN2lpT1dZQU4zWmdTVFhuRnNu?=
 =?utf-8?B?ei9CeW1CdytVUzFiQ0gzWGdjTVNIMmRhd1I4b0JoZGEzSW1sWnkxRzZpMzY2?=
 =?utf-8?B?aHc1U21JVGVyNFpoSWtpZitHelNiZTlvWU1PNFNGeW9jWHpERUF1UXBnOEtS?=
 =?utf-8?B?a0JkTW0wYmRJMDNndDRKcm16VXY4Q1k2b0hOMFhNUGxtaUNKTHBWRlJ1NGJl?=
 =?utf-8?B?YkQza291T2xwR3F1RlEzdjRjc3hjb1ZRU0ZHRVJvem10SkF4M0l5ZE1JdE9M?=
 =?utf-8?B?QTR0WS9sbmNaaWRZSEJnUk5qZFdZNnNBVjlySEJNTGp3a0ZRTldhcEtycytK?=
 =?utf-8?B?WEhreFJuSFErdDNtbklWN0huQ3FqeitORDAvb0IvSFVCaU1vK3U5Y05QYUFP?=
 =?utf-8?B?ZE50MDE1ZjJGbWN5YjExcDB3ZUlqTUhOSnFzNDRTM2ZMQ2U0R0NCUGp5QytG?=
 =?utf-8?B?VDIzRnJvV09xQVpOQ25BbmR4TVJ2Z1RVUWdRdDduRGNTYnVlVGtJY1IrdVZN?=
 =?utf-8?B?WHE3ME5YSjBYSCtwNVpFa2Z2TCtiN0JhKys2MmRpWkVyTVFHK2JXVGVrNy9K?=
 =?utf-8?B?OE4yRFlramhXWDFxVUpZRitIWXRJaE9xTjNvdjdRQ2RKTWEyd2FNRkJibjBR?=
 =?utf-8?B?bUMrclBYNnZWVlAvTlNCWSsrVmlSL2lHV1RPWndzdUxxWjRPOTNvN21sbnBT?=
 =?utf-8?B?NUdVelBHejZVMnBEZmlVZm05bWxWSXRVVHJjdS9pcCs1YmszNU1jOFVUTGc5?=
 =?utf-8?B?aUdjR3BYdHZQWW5OWWdlRlFRRWhRUkdMWVdnQnZFYzFpalZIUkFLWDJ5Lzd1?=
 =?utf-8?B?Q1ZwdTlUZVBTaXZ6NU5Nanoxb1dwSWdONlZYdDhjR0ZSZDZCK0JiL3pVZVpQ?=
 =?utf-8?Q?R3sNstekSjglneQAYxWrQHl1fkvRHzTwUgKzP7z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95968de2-5770-405a-db9a-08d97d2a63d2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 18:05:26.7941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajTQdAKkE3n+gYVaS4gT013ZwKnsReKAC8SRLTOxS3QAB60dlDn41292KAYYR4W2hAgHS4maUM2aFauSyHFNca8ORp6PhWZiSO8dWh2XMY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2938
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/2021 2:14 AM, Thomas Gleixner wrote:
> On Fri, Sep 17 2021 at 11:34, Peter Zijlstra wrote:
>> On Fri, Sep 17, 2021 at 11:11:49AM +0200, Peter Zijlstra wrote:
>>> On Thu, Sep 16, 2021 at 10:07:07AM -0500, Bjorn Helgaas wrote:
>>>> This seems to be an ongoing issue, not just a point defect in a single
>>>> product, and I really hate the onesy-twosy nature of this.  Is there
>>>> really no way to detect this issue automatically or fix whatever Linux
>>>> bug makes us trip over this?  I am no clock expert, so I have
>>>> absolutely no idea whether this is possible.
> Right, we need to have all these quirks because we can't define a
> generation cutoff based on family/model because X86 model is simply a
> random number. There might be some scheme behind it, but it's neither
> obvious nor documented.
>
> But the HPET on the affected machines goes south when the system enters
> PC10. So the right thing to do is to check whether PC10 is supported and
> force disable HPET if that's the case. That disablement is required
> independent of the clocksource watchdog problem because HPET is exposed
> in other ways as well.
>
> Questions for Rafael:
>
> What's the proper way to figure out whether PC10 is supported?

I can't say without research.  I think it'd be sufficient to check if 
C10 is supported, because asking for it is the only way to get PC10.

However, even if it is supported, the problem is not there until the 
kernel asks for C10.  So instead, I'd disable the TSC watchdog on the 
first attempt to ask the processor for C10 from the cpuidle code and I'd 
do that from the relevant drivers (intel_idle and ACPI idle).

There would be no TSC watchdog for the C10 users, but wouldn't that be a 
fair game?


> I got lost in the maze of intel_idle and ACPI muck and several other places
> which check that. Just grep for CPUID_MWAIT_LEAF and see how consistent
> all of that is.
>
> Why the heck can't we have _ONE_ authoritive implementation of that?
> Just because, right?
>
> Of course all of this is well documented as usual....
>
>>> X86 is gifted with the grant total of _0_ reliable clocks. Given no
>>> accurate time, it is impossible to tell which one of them is broken
>>> worst. Although I suppose we could attempt to synchronize against the
>>> PMU or MPERF..
>>>
>>> We could possibly disable the tsc watchdog for
>>> X86_FEATURE_TSC_KNOWN_FREQ && X86_FEATURE_TSC_ADJUST I suppose.
>>>
>>> And then have people with 'creative' BIOS get to keep the pieces.
>> Alternatively, we can change what the TSC watchdog does for
>> X86_FEATURE_TSC_ADJUST machines. Instead of checking time against HPET
>> it can check if TSC_ADJUST changes. That should make it more resillient
>> vs HPET time itself being off.
> I tried that and I hated the mess it created. Abusing the clocksource
> watchdog machinery for that is a nightmare. Don't even think about it.
>
> When TSC_ADJUST is available then we check the MSR when a CPU goes idle,
> but not more often than once per second. My concern is that we can't
> check TSC_ADJUST for modifications on fully loaded CPUs, but why do I
> still care?
>
> The requirements for ditching the watchdog should be:
>
>      X86_FEATURE_TSC_KNOWN_FREQ &&
>      X86_FEATURE_TSC_ADJUST &&
>      X86_FEATURE_NONSTOP_TSC &&
>      X86_FEATURE_ARAT
>
> But expecting X86_FEATURE_TSC_KNOWN_FREQ to be set on these HPET
> trainwreck equipped machines is wishful thinking:
>
> # cpuid -1 -l 0x15
> CPU:
>     Time Stamp Counter/Core Crystal Clock Information (0x15):
>        TSC/clock ratio = 176/2
>        nominal core crystal clock = 0 Hz
>
> We calculate that missing frequency then from leaf 0x16:
>
> # cpuid -1 -l 0x16
> CPU:
>     Processor Frequency Information (0x16):
>        Core Base Frequency (MHz) = 0x834 (2100)
>        Core Maximum Frequency (MHz) = 0x1068 (4200)
>        Bus (Reference) Frequency (MHz) = 0x64 (100)
>
> But we don't set the TSC_KNOWN_FREQ feature bit in the case that crystal
> clock is 0 and we need to use leaf 16. Which is entirely correct because
> the Core Base Frequency CPUID info is a joke:
>
> [    3.045828] tsc: Refined TSC clocksource calibration: 2111.993 MHz
>
> The refined calibration is pretty accurate according to NTP and if you
> take the CPUID 15/16 numbers into account even obvious with pure math:
>
>    TSC/clock ratio = 176/2
>    Core Base Frequency (MHz) = 0x834 (2100)
>
>    2100 / (176 / 2) = 23.8636 (MHz)
>
> which would be a very unusual crystal frequency. The refined calibration
> makes a lot more sense:
>
>    2112 / (176 / 2) = 24 (MHz)
>
> which is one of the very well known crystal frequencies of these
> machines.
>
> It's 2021 now and we are still not able to get reasonable information
> from hardware/firmware about this?
>
> Can the hardware and firmware people finaly get their act together?
>
> Here is the simple list of things we are asking for:
>
>   - Reliable TSC which cannot be tinkered with even by "value add" BIOSes
>
>   - Reliable information from hardware/firmware about the TSC frequency
>
>   - Hardware enforced (or firmware assisted) guarantees of TSC being
>     synchronized accross sockets
>
> We are asking for that for more than _twenty_ years now. All what we get
> are useless new features and as demonstrated in the case at hand new
> types of wreckage instead of a proper solution to the underlying
> problems.
>
> I'm personally dealing with the x86 timer hardware trainwrecks for more
> than 20 years now. TBH, I'm tired of this idiocy and very close to the
> point where I stop caring.
>
> Thanks,
>
>          tglx


