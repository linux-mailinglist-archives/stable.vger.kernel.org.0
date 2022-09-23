Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8595E7F59
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiIWQQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIWQQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:16:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7C912E407;
        Fri, 23 Sep 2022 09:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1BtFTiB8mSPKirzou1lsznx/Ti/FPMPSmz1/5mqiFI3W5COrbtECxYEP76MDMblmXiwhmNNanQHVgbqRoAoI6OLUUUNuI2eLVq7EwFOHsfGHcdjgSyHzst2aEkcBiGZyu1VyUA0c2jGcOY+Pj0qIYSYJl+3pDGDMFDjBg3NrWj9FCo1TxKeQfIkGKXqb4G/CHCVFzdviADOyjV5uqneCrWfKmW4ulhMNEU5Y6JGk1TH8vEWw0g6cMUGG57kwagUWrN7mK3pEI7cb/ycriJIOXhkISOStgp7ACDpn8G5jBjOBmszE9AH7UD4gcbI1BhgKogesrli42KzFNOV2trXng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KL3kJxBYpaFE+fQr0FIYBYKGlTUsKMJJdjOwrWnnTU=;
 b=OiGxePEm8je0gB/ATGO86R35IDqIedA30YGKm9OLkTvD8Wd1IqUB6mzL/wOgr0tsD3RQ/P6bmzDakKakeZBWAFSMljvR0eDMfUqZttzd0Y727d2B5mRNBWcT/dkutJX7BykyDMMs0rWe9HVUCJcDRYkxDCDARTbKf32oIAD0LjEO2GO0G7pGlGdNWjLMX9TMPKd6j3vKsSLGS4cF/lS1yXW5gJbe8HsPH4WJnLf2jjj2niXCDqXdgv1Aun0J8e9XtTcZeZWRk2THYVsgq0wV5kxGRRoHL9tL/s3yCxkzn/ZOiE6/aF4KMWgcKIhG9RY9jUnL77podTbw2vLTabJHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KL3kJxBYpaFE+fQr0FIYBYKGlTUsKMJJdjOwrWnnTU=;
 b=YrvbLzvjhwl9nW/QDNKGbZVH7twEHONuVi/sUGprDAR3ZY64DgTLD8C9or0Zg4Eidu7s40yM8btdlBvQymo08JqTl7T8MWwPI8menZiqQZ0Glr6QIK5EWjWFMg/W8YQaMOGImZTNetc4xJSH8zBaFA4TwiEyXcXS0OMfdiyT0tc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6204.namprd12.prod.outlook.com (2603:10b6:930:23::19)
 by DM4PR12MB5746.namprd12.prod.outlook.com (2603:10b6:8:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 16:16:01 +0000
Received: from CY5PR12MB6204.namprd12.prod.outlook.com
 ([fe80::5557:a7f7:142d:5b0a]) by CY5PR12MB6204.namprd12.prod.outlook.com
 ([fe80::5557:a7f7:142d:5b0a%6]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:16:01 +0000
Message-ID: <c34717e7-3e6f-9bed-8d7f-9573f6cfbd18@amd.com>
Date:   Fri, 23 Sep 2022 21:45:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     dave.hansen@intel.com, eric.morton@amd.com
Cc:     andi@lisas.de, bp@alien8.de, calvin.ong@amd.com,
        daniel.lezcano@linaro.org, dave.hansen@linux.intel.com,
        gautham.shenoy@amd.com, gpiccoli@igalia.com,
        kprateek.nayak@amd.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, mario.limonciello@amd.com,
        peterz@infradead.org, puwen@hygon.cn, rafael@kernel.org,
        regressions@lists.linux.dev, rui.zhang@intel.com,
        stable@vger.kernel.org, tglx@linutronix.de
References: <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com>
 <20220923160106.9297-1-ermorton@ericmoronsm1mbp.amd.com>
From:   Ananth Narayan <ananth.narayan@amd.com>
In-Reply-To: <20220923160106.9297-1-ermorton@ericmoronsm1mbp.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0198.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::7) To CY5PR12MB6204.namprd12.prod.outlook.com
 (2603:10b6:930:23::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6204:EE_|DM4PR12MB5746:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d122192-1cf6-430f-7de4-08da9d7ee824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlNiPS7GzucECkPzED/g6xPdsmYmfmPSGa7G9mWi8zbRyCXlRJKekCt/MTnl6zVoMHCmal11QpxTxwbi9Vap+D0Q1zwroFel5sOMdhBQw8gzhUPOji0v8Fh62ma/Xwyh3HmpmS7NKpQTvxuRwktFhlm0FUR+trWMS1PA5G3mORRubGVoxDUFNDTh17uV5PfDIGs8TpRQ6SEGc7oYGjrBS5/SS7ioKcf/s1rbfW11FgnUuzazj2bTsEaLP3tQR/J7CQzetpv3ex9Gs1qhDNEgWD/I9cxObgX61Z19rOfN+m/9KuaIvtbKvxKdOPTqtyKzkI/d/MkhJ971Jbv/wtSkPRKaUffUVbiGdOxV4x23gXxh5WvYaWVVARm64q6/PERR+2kOSxBK/3hH6NA8n4Zc41DqMDcxOUvG2vDBGNGeWjHcJ8s6jfMv5pi0B3BqWLAlPhdorY9inUCAL1wUQf+YxkrE/Vs3txVI8nEgZoBVmoHey0iRSP5U3Mz3kMYQgvPnih8gW9oV0YR5zyX+Jli4mdFXhZn67k7wzJVVm1YM/C4fYOCAWqpf870XWXBL1NPUxSb6xxv7A6YANTDfwoXipYyqMm5dZwebCVDoksouMp8vrHIpItDpx//GeNCqo2SC4Xdg5nGil0o5/6I9eBRr7hsBM0xwh/+XEqQfB4SIAr8T/MTD83MPb/kCWhrluU/H2FvIrRR8RR22zFx+K2WV3XKTv4FYHmb+GUNGcaHD1kleumqhDSgQUVp3NyeNkAeQTLEiNC3ayrRRecdDh5muSmVpsh5ACUZMbge6WzJGonE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6204.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(6636002)(478600001)(8936002)(26005)(66946007)(66476007)(6486002)(316002)(5660300002)(2906002)(53546011)(7416002)(66556008)(6506007)(6512007)(6666004)(36756003)(8676002)(2616005)(83380400001)(44832011)(41300700001)(31696002)(4326008)(31686004)(86362001)(38100700002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ME9zOFFnR3JCM0JOMkliNWFiUmxwdlZjM2xFdmFITEJPUjczWStnU0tQaDhw?=
 =?utf-8?B?a1A5Z0xmRC9BQmc2Vkh2V0R6ZnE3TnNtTlJtRkNLQUc5bDE5YTFXeFQ0TVY3?=
 =?utf-8?B?TjBoNDBmdGN2OTAwTzFJVk5KYjVHY2pWaDR6U3hFZDFXbS9aamkvdm51T1JH?=
 =?utf-8?B?MENXbFVkS1NJMnFncDhHaks0VEE0MkJPMXU2MStoYUxseEt3cng0bTVMb1c0?=
 =?utf-8?B?MEE5SS9SZDZHKytjYlZvYUxyT1RSUjJsWTB1KzhybGlhS1BUZXZLOFB1WFhq?=
 =?utf-8?B?VXlmakNuV0c0TTRnSUZxSW1BMVF4S0wxT2FPTkx4TS9OTzBnS0locDRiSjZ0?=
 =?utf-8?B?NUJOS0oyR0xsMEZrendabFNVSzYzcTlUTmhabjRROThjeVA1RUd6K082U0xZ?=
 =?utf-8?B?bmZ4Ym85djNyeWExd2l0RHZhbExRSVZEOVpZVUhpZUVkZm9tMDRiNlpMVS91?=
 =?utf-8?B?TjdweTBRdll6Y0dCaTJLWUwxWStneFZGcEZwa2VQUEdScEh3NlpJZGYrc21T?=
 =?utf-8?B?OVRtR1BtM3pZS3NFQTU2ZFd0eXMzM2pDNzVMMjlFL21wcEFXRFBmUjNZeFlK?=
 =?utf-8?B?aGlXWTlvMWtuelBNSFZDNlVwTXpFQUpTSTMyaWViTkZsczQySSszQWYyeXM3?=
 =?utf-8?B?WDBYckdGY0NKdXF5NVhYeEt2dlR2QXhtUndhazNLQ3NZc2huaFZQb2dhVjZz?=
 =?utf-8?B?a09rNUwxRGxObHQ2V0YzQmQ4QmV6T0FWNWRNVDI3OHIyQmp5V2J0dGt0a3k5?=
 =?utf-8?B?SytoczlzL1RESll4aU5GOWtSUWg5aGpVT25OTVJNd1JyQkQxcThQYjRkYVJx?=
 =?utf-8?B?OEJuWkxmZUJnQWUzUXRPaHJUYzluUnd4RnpiUnBnT1NubFhCbEI4dEFTa1Fh?=
 =?utf-8?B?SXFNTDdHSHJER1VPRmtlL2JzUGE1MHMyUStzVmVYTGFwWkRUN0NEaTJZdC9U?=
 =?utf-8?B?bk1QaitpR0o1UVlIWVkxOVBKT3ZGNVhCTkdOZFJyMldTQTVZQVhjRzJZTHA1?=
 =?utf-8?B?LzFWYUpGR2dsTFhWSCtqTC83aVhpOGY4V3Y5aE9BZS9RTHYyb0JHaGl1dU9i?=
 =?utf-8?B?dG4wcXBBNVIySDFtVXRYcmZSWEgvT1RJUitMaGZVUncycDl4UEdiQjh6M1JR?=
 =?utf-8?B?ZThvcUhPR0NNTzNhWTBPbDVNQnh0SVhBTHR5c01UbEkrQ3NBVU5lNFVuWmdz?=
 =?utf-8?B?ZXZNWkdCejV2RURlQWVwOS84aGVLK0VNQmpQL2tReEJVVFJLUTJ1RWZ0QTU1?=
 =?utf-8?B?bzF6bnpUSW5RZkdtQWpsRUxCOTFOL1JZYVM1SnE4OURsWmcreWtQOGwwczhU?=
 =?utf-8?B?ZXNEeVU4MmRNVUpSU2tXWUJsQWVRT0tkNkc4ajZDSnkrakZNZmxEam1DTDFr?=
 =?utf-8?B?dTJwSEdTOEd2dGhsS2JCMXpyR25Pa05qNFVuakxocERPU1U5Z2djYlkrTkJV?=
 =?utf-8?B?ZHl0c0pFL3VMcnZTK1RYaFVjK0lTRkJZWEpsY09reDNMbkFqekd6YnpzMmR3?=
 =?utf-8?B?TGZnY3MvL2RsdGRzTWUzT2NBY1RrTUxzOVVsQWMvMWxla0xiL3Z4WU1Oa2hG?=
 =?utf-8?B?aitzRWg3WTNTTG9uOXRZWmd1UVNxSDZoVEFxcHhITUp4dGlIOGxxdUVsVlBR?=
 =?utf-8?B?czdvRjdOMW5ndlVkM1d3bExkNVBIZmVubFRYY0hmRXp0Y0MxN0psbWhJaWFh?=
 =?utf-8?B?MVFJTU5lRHl4WXZGVUcwWHMzanEvYVhKVlc3aW8vWHdHQXhtQ0F5bmRKTHQ0?=
 =?utf-8?B?MStic29nYTdHQzNxOENHU2FOeU16U2RLS2w0VmpmRTdmSGMrSFplazg4UTBC?=
 =?utf-8?B?UjFpQldZTnVSaGN5bVVUVmlxRVl4aUVxdkJMQU5OMldiMmw2ckIyYm5IbWV1?=
 =?utf-8?B?WS9lZzRQQ05iUGpFaDhwTjRybC9FZVZlMHNVdTRyY3FvY1hxZFA1Y1hzS0hT?=
 =?utf-8?B?bkszZUQxdnF5em1RUWpObHJTc2xWblRWTlRjNlZKYkVubklZODgwbC8vaHU1?=
 =?utf-8?B?NURIYkpMR1BwS2RETHRpN2N1SmJydGdrenVxL25Bd01VNUNXS2R0TFlFWVZs?=
 =?utf-8?B?MjVnM2xFVDYzendGT0xrSkM0ZGg2ZE9KYXgvOTFDeEJHS2tzaFRwK0RQd3hO?=
 =?utf-8?Q?V4q5H8MrIhKTOSgW2+CEWLgWo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d122192-1cf6-430f-7de4-08da9d7ee824
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6204.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:16:01.6553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8Vq4Lz+JfzMUr7CCc3iOsmmzwQ2pQLSgFSP3p3Obv/qdu7BCHmlRDUMlqMJP85REZy+PY3xK+1ulUx0lGHDfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric,
The MTA mangled your address. So the note is not showing up on the list.
Responding so this hopefully shows up on lkml for the records.

Apologies to everyone else for duplicates.

Regards,
Ananth

On 23-09-2022 09:31 pm, AMD\ermorton wrote:
> On 2022-09-21 14:15, David Hansen wrote:
> 
>>> Do X86_FEATURE_ZEN CPUs just have unusually painful
>>> inl(acpi_fadt.xpm_tmr_blk.address) implementations?
> 
> Hi David,
> 
> I'm glad you asked this.
> 
> Obviously the words "painful" and "slow" are arbitrary. But... since there are many aspects such as the platform, core clock frequency, system clock frequency, etc, that play into this, I will refrain from any precise numbers.
> 
> I would say that x86 platforms (that today have in excess of a hundred processors) generally design the legacy PM_TMR and other serial resources in the Southbridge/FCH with the underlying assumption that (a) the kernel accesses them "rarely" in non-performance sensitive code and, more importantly, (b) that it is unlikely to have multiple processors access them "simultaneously". These resources are a fair distant from the processor, and unlike memory controllers, these resources were not designed to have multiple simultaneous accesses running in parallel.
> 
> So let's assert that, to start off with, the accesses are already "slow" from the processor standpoint because of this distance. It is likely that most x86 implementations could easily take around 500ns-1us round trip. The exact number will vary, but a quick sanity test on current x86 production platforms match that for a "singleton" access.
> 
> That alone is well over 1000 core clocks and seems to be reason enough to avoid doing this INL when it is not necessary.
> 
> But as the PM_TMR is not designed to handle simultaneous accesses, if multiple processors do simultaneously access this resource (or even "close to simultaneous"), the first access might be "slow", the second access might be "slower", and well, the 100th access might be "painful". And there are interrupt cases where this can indeed happen - due to this ancient workaround...
> 
> Note that a quick sanity test that we created when we understood this tbench data suggested to me that Intel platforms are not immune from the impact of this worst-case access pattern either. This is not surprising to me. But we did not do an exhaustive check.
> 
> Sincerely,
> Eric Morton
> AMD Infinity Fabric and SOC Architecture
