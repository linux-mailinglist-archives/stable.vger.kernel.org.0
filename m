Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7315EAE01
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiIZRTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiIZRTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:19:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C99EBD55;
        Mon, 26 Sep 2022 09:33:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+mqp3Pwox2LEdbqaS6bnfNcamU0JDseiyufxoA4vmpvW9BrvT/JxjibITD0XrGxc47FQBmLDhtdcoN0SbsRH67B4IA3t8niWa6uL0ukybK93QFU+uiqM/neQA+arzXixC3X96Bn60kBUwd1LKJWrhMoaClPE8nB1Ufo2KULk92lUK3O+6HkqqMcNtRcyHH7LgM4z68LJ54Hgeb0kdKT1Yv3EQSKx0zIUNlgXfAqXIEnLlN1EaixyrXVaMP2F8wE/+e1GkPrBX3Rwke9LJJDuOk6x1Lz7lAYv7yaKFK47O13VY4BpsW8mwMfR1ha3y4RLs9sEtkMWe8FxRtfiSo7tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhihAAiv/Rj9q7FBjXgPkoa7q1jz3JScj6j4fTuSry8=;
 b=Pp3/9Vr0IvyVBN9Wz9gBgJe+2uA2hSgEYwGEhr+TDBD+SfSYp4MrWvpODAP+dYsgWGlceIjEz91slCkKhakFmp+D5pJk1D2AVe+7fn1hPqe07av8jn5P1SFtsH5INgGsNX5aTL75wbDaqr5i84WM40CROQVrayWko356soz2qmqTEfjNYBb27c3bPiYPR+hm4FTUlvPd57iuLV4nUr0eNerfnfmw3IwduiVdNCigg6Q4OgET9gyqMqJU1PayhzefLXD0h0cazG9npErbYnuJmXgspJKZ6XzDMJJ/2aArNRnQQlKnONWRsIpU2gPESTKLrK9O2wT1jrvhffgUYHplQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhihAAiv/Rj9q7FBjXgPkoa7q1jz3JScj6j4fTuSry8=;
 b=bTlN1qU5pL94rJlSADM7Hcx8ZYfvAsJy15rFov3kNgzfhMDqdJrFb1mAeDSTkC6XXwbbYeBTkghWQCp4bha/+R8bpBgXf7RnEHsGqSExfg0iVxRBQDuspkMKp3CyTERIXozDx8Ds5anB6mJzzp0RxtxipWMfCPLUaik2SrjX38g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13)
 by DM4PR12MB6589.namprd12.prod.outlook.com (2603:10b6:8:b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Mon, 26 Sep
 2022 16:33:03 +0000
Received: from SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33]) by SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33%4]) with mapi id 15.20.5632.021; Mon, 26 Sep 2022
 16:33:03 +0000
Message-ID: <9875e20e-8363-74ef-349d-d339eddb3cc2@amd.com>
Date:   Mon, 26 Sep 2022 22:02:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        andi@lisas.de, puwen@hygon.cn, mario.limonciello@amd.com,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
References: <20220923153801.9167-1-kprateek.nayak@amd.com>
 <YzGWHMIsD7RBhEP+@hirez.programming.kicks-ass.net>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <YzGWHMIsD7RBhEP+@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0114.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::23) To SN1PR12MB2381.namprd12.prod.outlook.com
 (2603:10b6:802:2f::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:EE_|DM4PR12MB6589:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e2fcd25-d73b-41f3-32b8-08da9fdcc830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZJwxR9CTec5VHv+MovSZiGPpUB+vOkvbkoAG1s9OwU1W8TXDyszopQoWK4rtaIq6sZ78bewd2EbgOrMo0yPYpzlDxhEwwZJfcaFWpDXzEI9730ItD6AR8UPmXJh8cCxVepFnhw9VTQQO3+Ff1x7ZYLtgFy2FPHJjixofukpK4ggWHP2AMe7y6rV7GTB8p79qdM98+L4F8t4ZONIQzBgBi53L/p2zpTuAvqpu7j3R/HmM1L6bVrgY3whiJdFF2FddUdCXhabQZ5mpU7SRc50IYSiANfwzonX2kk9vSSV1uE4j48efr9oEaUKSNMdQi1IsDQ6ooCWXH46A2Hc/cJSpZWkTflGGdsie7IQfXIRHRVOghFQ4ty59oIJp/p8hQTLLMZ5abyx3Tuc/GC+iV42tMLe2mRJbvlicYyOdWXxZVXJBXmwUlGsb1/DhOHJBsEksU30mSDm7KwpK5OTwv9SPLkVtl9BABNTHiTx3dtdofAPVL+zC845itlRtH3gu/aJegl30O+B9ZLDSGj5MFVq0zbrhhj+K8dMjvj5hpXG0Gs2ZR88mXgDjDPHSERnOxBae0XnpTTK7ZpQKUPIUToTv2lNTewBqHXj0l4XzKv2I1zgYwevfSp0pjHEU8n9g7zNKEuIGVDMoCMR+j3R2uQz/5JaQz5w39TYXtMZ7gP9Tw2Cng8mGP8KMlhH1XFqmKp9jhZKYG+M30uLo0pFKfE9+ZnUTIT5XaFIVjtBsVhMqZTWge4MaMuEDYk45FkHxL4XcTGoABbAjxBDV2GZ7biojwlsR/HfHdTY5yKkBDfkytO5Yni6HVUV6eYlBTrr0Qiw3SvtGITsmD5NSEAcxi6rfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199015)(478600001)(41300700001)(53546011)(6506007)(2616005)(6512007)(6666004)(186003)(6486002)(26005)(7416002)(66946007)(4326008)(83380400001)(8676002)(66476007)(66556008)(36756003)(2906002)(54906003)(8936002)(5660300002)(31686004)(6916009)(316002)(38100700002)(31696002)(66899012)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkNGSXh5L211ZlR0a0t1T09iNlEwUTRxeC9wNkZaN3AyTEdvQ0VudTIyWEFK?=
 =?utf-8?B?MXFMNmx1L01pb0I2WlliZC9DZ3BKejhRNkhBRS9hK0c0OURNZ3ZkZlNyM21U?=
 =?utf-8?B?Ynp6b1ZEQUIwZStpZXl0dHhBRGM0QlorOVhlbjNnMmIrZG9ub2duUHBNUzMr?=
 =?utf-8?B?S3JHMmFiZGVESUJoQ2U1enprSWF6L2MrSUY1ZXVQQ1I3NnR6QmoyTkYyakYy?=
 =?utf-8?B?ZFNSWkdzM0d3YkE0K1JLdHpSWG9sTE5nUjNqUHpySU1NYlEwNGQycEdpTEpj?=
 =?utf-8?B?OTdUSHJiOFRqYWt0MGRGRUlHSFd0a1BaWnBUYjBsY0NVcDN0ZUkrajBuK1Q1?=
 =?utf-8?B?RFZaK3RQcXVGKzFTYjRxUzJnTHl4UXgzS2Ztd3dWaklCYUVheTBnWHVKWkdP?=
 =?utf-8?B?QkUvNFEvYWtLeXZ5OEYzVXl2ajllT0FKbGQycVgxb09NUHhGQXgzZ1ZXZkdt?=
 =?utf-8?B?ZWFPRzdnRXpFU2pPelFGQjVhRUNWS1RSSVl1K2ZTQUd0OXJSQ0lBNmZwN25J?=
 =?utf-8?B?bWlvYWlLOW1sWmlvVmNLMWxLOC94WVNGL2J4U2VHQ1ArZ2ZzOWJQaTVYQWh1?=
 =?utf-8?B?RjZWRHdPL2dVM1dDZDhEa2hJWkdTVnFrYmltdk8zQU1sOXc3cHFQcTJrN3NY?=
 =?utf-8?B?VlZZSUg2NG9TOXFsUGNua2luZFMyYUV2eDV4U1JSWW1paWRvL1RPVlR6ZUV2?=
 =?utf-8?B?YzM5SktWQ24xU1RvakNWWXFXTXFCYjZqVGlPelFiKzBmNGI3L2YvVzYyNTNQ?=
 =?utf-8?B?NGI4ZElqaVk0L09PSk5Lb3BjTlBaOThmQW55VEN0ZWVwdHNWaWhTZU9HRmIw?=
 =?utf-8?B?RVNVMm56aEkzU2t4ZnlkRlZEUkhmcWN6NVhVcUpFalFZQU1nSloyRDFvanNZ?=
 =?utf-8?B?Y0tFanBld3B0dW4vUnN4ZjFOYXBrQ0lBajFxeUNrMS9XUzl2SjRPRG8rRnZu?=
 =?utf-8?B?c1RTNnBJWkxTSC9GSG9jUkFxQVIzMXIrZzF4UlYzeDVFMkVTUFFxQU5Ld2pO?=
 =?utf-8?B?QVBhNnZVd3BmcTBOajRQZ3p2WUIweWZZQitONGl4ZVBpY3JNRURNNXhBd2dk?=
 =?utf-8?B?R1VGQWxwZG9ZcnAwbGxYYkk0TG9uaFQ4eVZOS3FvVHJFUUNXQXZrUHVKT2JN?=
 =?utf-8?B?eU15YjhYS3BRSU5iek85THdqbmdicDRNQUZVcVJFZllzaU1UbEZJNnl4ME9U?=
 =?utf-8?B?aEZHbncwRlFHWHhWWUJDTTFFb2ZZenBwc2c2dXpkV05pZ3ROM3EzVENRSDhh?=
 =?utf-8?B?T0tSd0ZZT3JQRXJkOGFDc3dSTTRqMW1jaWhaNHd5R21MM2ZxWWMzNk94dUMv?=
 =?utf-8?B?ZVRlT2QvUHY2TlJpcE51OTdkdXVqOVpBNG1XOGRJQStHSGh0WTMxL2crZk0v?=
 =?utf-8?B?eTBwbUlzWTVMZitTOC9Rb09UL3NBVmdDYnhib042MDhRYUUycGtmdzVXK0Ix?=
 =?utf-8?B?SmR4NzNsMjROYlc5UWw2Y2xUY1NFZDlhaE9pRDNLbmpyMjQ5REt2alYrQzhn?=
 =?utf-8?B?emhhTHRHeHJ5a2hqbWJreTZFNWhvRytPd2xQWE5rOGwyZEhGMWlJaXRHS2pZ?=
 =?utf-8?B?NjhmL0g4K1V4K3J4RHNqZ2N3bVRUWHFCc2g3YTJIY3dVYkhlSE90ZjA3VVR3?=
 =?utf-8?B?TWl0WUR2ZE43SG1EQXlaTHNaMVJlcER1Vy9MSjBiNzl5N1kwQjY5bERxU2hP?=
 =?utf-8?B?dVlsZXovdUdSaG5Jb2JBZzdNL2lXVDVSYTVXaHJyQU9KbDFpTUJ6Qjl5eXVu?=
 =?utf-8?B?REtSWXJneVBNUmRNc2x3MkVDS2VRTHBxaC9SZDJTS05pWW5VeTNTeTlxMFZh?=
 =?utf-8?B?a2crUGlRU3lMS0UwN1ZJY2NvejIxbmRKK1oreVdwelY1WmtZaVJSNE9lbTZx?=
 =?utf-8?B?QzdrbVgrbDNOYnRVK2ZRVE0xYzFXbkR3UXpWZ1FGaWZFYVJPZ3NFM2hUM3gw?=
 =?utf-8?B?cDlkTVpXT2d0K0lrUDV4aVZZLzJJRU9rMnREWjFXYXVVc2VQeTZLbGtKeVBU?=
 =?utf-8?B?MlpZYS91aUpXNGRrY0lnOHlrSitSU0RUQXlRbUlpL3pjblJ6T3dCMjVRb1g3?=
 =?utf-8?B?UU9UOHpBdEltMU9FcUpHQ0lqQWJLWC9VRnhoV3ZIQjYzbFlpbHk4QzNyTjVj?=
 =?utf-8?Q?lIbQ2+ynqfzrwNxU6sIdvfnXa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2fcd25-d73b-41f3-32b8-08da9fdcc830
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 16:33:03.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPDY0JlomBaeGBlT8Nn05Ql/04VJZqZqeozJMMSbToT5ZKmO8wfi0kJqiB3MAF+uPyeyJgeQq0cmubx1wOvrgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6589
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Peter,

On 9/26/2022 5:37 PM, Peter Zijlstra wrote:
> On Fri, Sep 23, 2022 at 09:08:01PM +0530, K Prateek Nayak wrote:
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index ef4775c6db01..fcd3617ed315 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -460,5 +460,6 @@
>>  #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
>>  #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
>>  #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
>> +#define X86_BUG_STPCLK			X86_BUG(29) /* STPCLK# signal does not get asserted in time during IOPORT based C-state entry */
>>  
>>  #endif /* _ASM_X86_CPUFEATURES_H */
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index 48276c0e479d..8cb5887a53a3 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -988,6 +988,18 @@ static void init_amd(struct cpuinfo_x86 *c)
>>  	if (!cpu_has(c, X86_FEATURE_XENPV))
>>  		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
>>  
>> +	/*
>> +	 * CPUs based on the Zen microarchitecture (Fam 17h onward) can
>> +	 * guarantee that STPCLK# signal is asserted in time after the
>> +	 * P_LVL2 read to freeze execution after an IOPORT based C-state
>> +	 * entry. Among the older AMD processors, there has been at least
>> +	 * one report of an AMD Athlon processor on a VIA chipset
>> +	 * (circa 2006) having this issue. Mark all these older AMD
>> +	 * processor families as being affected.
>> +	 */
>> +	if (c->x86 < 0x17)
>> +		set_cpu_bug(c, X86_BUG_STPCLK);
>> +
>>  	/*
>>  	 * Turn on the Instructions Retired free counter on machines not
>>  	 * susceptible to erratum #1054 "Instructions Retired Performance
>> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>> index 2d7ea5480ec3..96fe1320c238 100644
>> --- a/arch/x86/kernel/cpu/intel.c
>> +++ b/arch/x86/kernel/cpu/intel.c
>> @@ -696,6 +696,18 @@ static void init_intel(struct cpuinfo_x86 *c)
>>  		((c->x86_model == INTEL_FAM6_ATOM_GOLDMONT)))
>>  		set_cpu_bug(c, X86_BUG_MONITOR);
>>  
>> +	/*
>> +	 * Intel chipsets prior to Nehalem used the ACPI processor_idle
>> +	 * driver for C-state management. Some of these processors that
>> +	 * used IOPORT based C-states could not guarantee that STPCLK#
>> +	 * signal gets asserted in time after P_LVL2 read to freeze
>> +	 * execution properly. Since a clear cut-off point is not known
>> +	 * as to when this bug was solved, mark all the chipsets as
>> +	 * being affected. Only the ones that use IOPORT based C-state
>> +	 * transitions via the acpi_idle driver will be impacted.
>> +	 */
>> +	set_cpu_bug(c, X86_BUG_STPCLK);
>> +
>>  #ifdef CONFIG_X86_64
>>  	if (c->x86 == 15)
>>  		c->x86_cache_alignment = c->x86_clflush_size * 2;
> 
> Quiz time:
> 
>   #define X86_VENDOR_INTEL       0
>   #define X86_VENDOR_CYRIX       1
>   #define X86_VENDOR_AMD         2
>   #define X86_VENDOR_UMC         3
>   #define X86_VENDOR_CENTAUR     5
>   #define X86_VENDOR_TRANSMETA   7
>   #define X86_VENDOR_NSC         8
>   #define X86_VENDOR_HYGON       9
>   #define X86_VENDOR_ZHAOXIN     10
>   #define X86_VENDOR_VORTEX      11
>   #define X86_VENDOR_NUM         12
>   #define X86_VENDOR_UNKNOWN     0xff
> 
> For how many of the above have you changed behaviour?

The proposed logic does alter the behavior for x86 chipsets that depend
on acpi_idle driver and have IOPORT based C-state. Based on what
Rafael and Dave suggested, I have marked all Intel processors to be
affected by this bug. In light of Andreas' report, I've also marked
all the pre-family 17h AMD processors to be affected by this bug to avoid
causing any regression.

It is hard to tell if any other vendor had this bug in their chipsets.
Dave's patch does not make this consideration either and limits the
dummy operation to only Intel chipsets using acpi_idle driver.
(https://lore.kernel.org/all/78d13a19-2806-c8af-573e-7f2625edfab8@intel.com/)
If folks reported a regression, I would have been happy to fix it for
them.

> 
> Not to mention that this is the gazillion-th time AMD has failed to
> change HYGON in lock-step. That's Zen too -- deal with it.

Hygon is based on the Zen microarchitecture (equivalent to Fam 17h on
AMD) and they too do not need the the dummy wait op to ensure correct
behavior. Hence, they are not marked with x86_BUG_STPCLK.

In the patch description, I've called out:

"mark all the Intel processors and pre-family 17h
AMD processors with x86_BUG_STPCLK. In the acpi_idle driver, restrict the
dummy wait during IOPORT based C-state transitions to only these
processors."
 
Both Hygon and AMD Fam 17h+, which are based on Zen microachitecture, are
not affected by x86_BUG_STPCLK and hence skip the dummy wait op.

Did I miss something?
--
Thanks and Regards,
Prateek
