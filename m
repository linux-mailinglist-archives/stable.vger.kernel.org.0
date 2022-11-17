Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC4062D28E
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 06:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiKQFEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 00:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKQFED (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 00:04:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BC22EF09;
        Wed, 16 Nov 2022 21:03:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gylLpBJSOQLuP5K9Kum7r+hiDdnfmKlW1ctk8R3d7IjmPqWgAkvbIOfHaVS1hyCcTh7A8POujinXEGHlrNCM846ApS5Z3wm4QQvxaP4smAaSzeaawhjxdaEdcLmE+ddC1t0vRgubXzDGkK32xwmWlT6LJWQ1BylR4gyinyzwiYw8NexGI8MwGUh2q2tHa7B+teOsfndcRzgHyEFT/hNR6chFL9CZJVwcpX5PINLs/x3OHyWsF/vZWFSxQ9gdo52l7cFLqsf/hO87Nxy7Q+n+Ar3efSA9iGO8b+HZDcHAWYZPUCxBUBEx/3Wpz72axVqqFKMxv5tQb3e6zhgjMgBUeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNc4Im9qyhuwBHH9oSveTHwX2TnKFhkZZHYh+/8XvOQ=;
 b=JbaXH3f5uTUp6vUKmeVJ6u4MEaYmXGtfoD5agh/x9w4KWfT+GS+yZUyhObji9no0Dl4puq4Fw74ZblXAEccKS1alzyVZb4TzaRZ3XMJIMhirGHHDRXMLRa2pPT+S97GRYa6sd+bX5uKtJP2G92bSBUjVafARC8AcmXvF6dg04ovLXTf0V7VpeBC4eaYt0Etihu3g3g2pELC42o2Hl6RWiKYWXzlUhODdn1qpZ68KnrMKH7heW9O96i04XJckUhmhXwWETP9yTNkV8d8dQ0BxxHALjB2+aNy88EZSlkIfWsp+rYGNCOiSv66Fsjy6qVNbIMev1wuFM8DwZWO3DaY1zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNc4Im9qyhuwBHH9oSveTHwX2TnKFhkZZHYh+/8XvOQ=;
 b=iDAhbgfd3ZxJkuOLF6JI35nlC3TLwCpV/9hF34fdxVbQlu+6iK79y+KVshwQf60rV3oQyV3PBgHbK+xMtR+mjPZt2JIwDHh5NRWVnjQTKyg8k2NpzOFNywIuwH459eoCxbosu4tMLkkyialqTlsqNDYhjyx6tbXO/8/QHFLM8jY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB3876.namprd12.prod.outlook.com (2603:10b6:a03:1a7::26)
 by DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Thu, 17 Nov 2022 05:03:58 +0000
Received: from BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::b6f2:3174:a1c2:44b5]) by BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::b6f2:3174:a1c2:44b5%7]) with mapi id 15.20.5813.013; Thu, 17 Nov 2022
 05:03:57 +0000
Message-ID: <2a5a8727-a339-8be3-5383-395033c07c12@amd.com>
Date:   Thu, 17 Nov 2022 10:33:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/5] cpufreq: amd-pstate: cpufreq: amd-pstate: reset
 MSR_AMD_PERF_CTL register at init
Content-Language: en-US
To:     Perry Yuan <Perry.Yuan@amd.com>, rafael.j.wysocki@intel.com,
        ray.huang@amd.com, viresh.kumar@linaro.org,
        Mario.Limonciello@amd.com
Cc:     Nathan.Fontenot@amd.com, Alexander.Deucher@amd.com,
        Deepak.Sharma@amd.com, Shimmer.Huang@amd.com, Li.Meng@amd.com,
        Xiaojian.Du@amd.com, gautham.shenoy@amd.com,
        ananth.narayan@amd.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221117024955.3319484-1-Perry.Yuan@amd.com>
 <20221117024955.3319484-2-Perry.Yuan@amd.com>
From:   Wyes Karny <wyes.karny@amd.com>
In-Reply-To: <20221117024955.3319484-2-Perry.Yuan@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::30) To BY5PR12MB3876.namprd12.prod.outlook.com
 (2603:10b6:a03:1a7::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3876:EE_|DS0PR12MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: aa4d3013-eaed-4dc3-d5a0-08dac85921e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mi7eH4FMdESBP3ir1VJGYWXqNKjKT8QAxFkqsFw50z2Yynzb9w7K2F97wY5s58wuh5XEhNw0YG9CnCR0l3UiDEUflsU5iXZ3TNdp4R0O+sFYJZTIw18KtPl3G09nguFE3RjSSsTgjwCN+MWa6D0shGC0+qN784RfB1AHYsdAJ6uChql/UkMRmF771pcpWhoJIaUYjYsp9aqksUsE76X6wZfSIbo61c7JLG0r0Ay3pfPZqdPCL1TwbMYDZdx7jZZ78nRCPCDvRpucT+PJQL99BKoMGm3FKkhQNwQGhifbFpIAVeqVcB4TIhLBThCB5BVTAuZ3HpWkrp1X9Zj8kBfZXDIO365LnHEY8HfMPsAvkgJgskYyc8aQVPp1UL2VR0RpFXu+nlEO86fCu0x/hWsBb4MaKqFMV852dq7mWtqm4+ml67MnCFuH74VGRj3PpYknOrEGEG+c/x4yeYGN//XNHHO2Fx5nXkkwJSF3FfHzFAqTsmT2qSVwjtiYImLmgkiT4Z+NOjq9+dA8YezPJJkWFgZdWKc+0qH5RREW8PVVWdcARxdYKqwn9O+9UC0QTspDInjr7VpOY3zezXnjQGD87X19SWbH5ItyZVvei+SGWRZDTwGXOt7qQ/vz/7gAYsaEeZuL+v27JgU3td0FYoULOWJQnW02exV5dP297I2zt2IRZPV0yRN+i8UR9UGRFaUZZcUgrvjVqXk7sYtQOSqTVmgx7SHXwWyqhD7c6NMvGHg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3876.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(38100700002)(66899015)(31686004)(31696002)(86362001)(36756003)(41300700001)(186003)(316002)(66476007)(66556008)(4326008)(66946007)(8676002)(8936002)(2616005)(83380400001)(6486002)(478600001)(6512007)(5660300002)(44832011)(6506007)(6666004)(2906002)(53546011)(26005)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFY1NXhad0RlMW9IckUvNVUzNVhWWXJ0NEI3WG92ZTlPcmV4UU5QdUxueVBm?=
 =?utf-8?B?TWJDVGRETmRSMGlGVEE4N08xQTdKM1RCdW02K1FzeHJMMFBjNjVPSVNLdVlF?=
 =?utf-8?B?WkRBdEY4VWgxSjhTeTdkN2Jxc0RuTmJObFp1bEVNamsweVpjdjk1RmQ4WThX?=
 =?utf-8?B?YkpBeDdaUHl1TFFHZmtTOGtMK1kycGRMbmNmc2Y5TkZ2Vnd2TFBIakNTcGx4?=
 =?utf-8?B?YWhZV0hUaHBLRzE1ZjV6MjNMUFYxd29haUtSNnlyZFdBNzcvWmhiOEkwZXFY?=
 =?utf-8?B?bUhYZUNTY2p1QUdXRTllNEVJazUzaXl2dzVqR3lZOXRqTzRyZlFrdmRjNkp0?=
 =?utf-8?B?blhVYUc0ZmRpUll4TjZ1NzVnd1VzSmNFdGZHZlNYMEpncWg2V3l5YWo0NFhD?=
 =?utf-8?B?UkRLVTFSRDNLNjhnR1BHUERsNW1wak9wR2JUYTZLTmhqeXhuTDFsQU4yNkpB?=
 =?utf-8?B?cHUvbk9IYWpiSHUyUElWV2k3TzFQZXplWHp0L2xxQUYwTGY1MzFsUUN0ekFV?=
 =?utf-8?B?VzFyYy9NQkpjMjIrSVdCRDZheTZaWUJGenBheGQ1dEtTRXpubXRrQjE3MEFG?=
 =?utf-8?B?UnpQemlOZ29pU0p5NzhKZWZLL2dOTC9VRlVaM1FBUVRMZXNDN2NveDFReE9q?=
 =?utf-8?B?cU0vYllBaXg3QVdFTkIvKzRHeEs1b2ROM25Jc1kwZkoxZ2NnSzZ2V2tWelFR?=
 =?utf-8?B?MXZRaUFwaFJuRUdONzNLYlpYQWgzV0ZvNEd6YTlwd2FrSitINDZkSHduSkt5?=
 =?utf-8?B?TllXb09MRzk5QkhMUVpQR3VySmVub1cyM3p0ekJrNFRoaFNvVWV4YjkrOE9E?=
 =?utf-8?B?all3a08wcnVQckI5WnBJWEppSXg5WVhqSG85YkkvVUdBNnNaNjlFT1Z1S3dw?=
 =?utf-8?B?eFIzaDkwREFpUGx5M2VEdW1USldWSUxBZHpRcndXWTJrRmZ1S2dKdmY2cWRp?=
 =?utf-8?B?ZGZIcUQ2WVRqQkFRNU9JK04yTTNlYXc0ZmJIdFJBZGhDRHRMdGVDbS8raDZF?=
 =?utf-8?B?S0gwVktEVkxPZ2k1aWtMUWM3ZFRCMWtJbXRBenI1R3cxYTZNdklvOXM1VlRr?=
 =?utf-8?B?NUJxTGRCUFNhRFJrdUl6U29zWDRscTRWZDg1NlU5NDVFYmo1cnVuT2tkTWZ3?=
 =?utf-8?B?L2IwcVpnNEh0RGRzWFNJSWpSQVNrcHplTllKVzRkMGt4MHBMZW56RFZHOGVy?=
 =?utf-8?B?dUlqeEdnSDlSSUVtdHRIU3Z4Z1RCSU92ZDRQRzNoWFFFamVQclFxb1MwYy92?=
 =?utf-8?B?eG1EWFArTm5hM0R0ZW0xQU5lVUlqTGF5Wnc3VjQ4MTNSTS8wVllqbmxJUFpR?=
 =?utf-8?B?b0I1dkdSMkI4cnhrS2Z4c01FRkx3S3ZycWdRWDdNRnhiUDJKaEx1eWg3QU8r?=
 =?utf-8?B?OGkvZkNYUHpiUmxveDUwV3ZVVUgyT0FOV1hjR2FnVnc2amtvRVgwUUtvdXZp?=
 =?utf-8?B?WXpsNW1kUmFYWm9tRElFcDQzck81bzVtTU9RVnFNcldueE9lQTN3SzBWZ24y?=
 =?utf-8?B?Sk1ZeEZLN2hoMS9iWmJGNzZNbTRLSTRuWitjcU12Y0U0RXFXMTh5cGM2QnZJ?=
 =?utf-8?B?dUxBd2YxQmRiQzlja0FLeVVqNEttVUZidzB4aDBNSU1OakZIM1FHcElUa0Jw?=
 =?utf-8?B?SU1VSWgxQ0dhU1ZKaG1pc0ZpZEdOcjIwL1NGZGxxRm1SbWdPdGFNL0FFSytL?=
 =?utf-8?B?NjJ0Y3NZb3Jta1dPUmNaR01zVFQxcWZRMm92Ync5MkVwQ2ltYXdxb240REs0?=
 =?utf-8?B?U3RxVUJJZXlhWk9GUWZ1UHJCeWo2L1djRTY5UG9XU05KVTlNNmt4dGxTb2lX?=
 =?utf-8?B?MllSTmZjanUwZG1wSDdnL0RHb1pLVXE0M0VENGpGRjdPQmNQeXhoeG9YY3NV?=
 =?utf-8?B?N0dSWjI3TUJ6cS9qcmdsNnV2ajFaOWxRcDQ2ZW0rQUJUTHo1NWw3NytOZUhj?=
 =?utf-8?B?Nm5aZVo4ZDdtYUFmUTFmNS9ocEw4Mngxb0pqbjBiWnYzRm5kSjZSM2c5MVdl?=
 =?utf-8?B?Q0xUOUxUNkQydkh2S3cwdWdGR0VwaTZYV2JxdjYrUXozTWtJYTZrV3pLRDU3?=
 =?utf-8?B?N3ZxQytUK1hkb285djN3U2NlMmUzRStZcTRSVDV2Y01mVXhUMnFmc3VnYStI?=
 =?utf-8?Q?yGk3UwCYMIB+DiEZdIg2F9MTy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4d3013-eaed-4dc3-d5a0-08dac85921e7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3876.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 05:03:57.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqztG5oTBfiWDmHUlGP/+pPcxih/oH254JzsGY7qWZ0mDvnYmirKdNTyj2kXvSEfeXzF89wKgsoWs25R1ya2XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6559
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/17/2022 8:19 AM, Perry Yuan wrote:
> From: Wyes Karny <wyes.karny@amd.com>
> 
> MSR_AMD_PERF_CTL is guaranteed to be 0 on a cold boot. However, on a
> kexec boot, for instance, it may have a non-zero value (if the cpu was
> in a non-P0 Pstate).  In such cases, the cores with non-P0 Pstates at
> boot will never be pushed to P0, let alone boost frequencies.
> 
> Kexec is a common workflow for reboot on Linux and this creates a
> regression in performance. Fix it by explicitly setting the
> MSR_AMD_PERF_CTL to 0 during amd_pstate driver init.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Wyes Karny <wyes.karny@amd.com>
> Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>

Tested-by: Wyes Karny <wyes.karny@amd.com>

> ---
>  drivers/cpufreq/amd-pstate.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
> index ace7d50cf2ac..d844c6f97caf 100644
> --- a/drivers/cpufreq/amd-pstate.c
> +++ b/drivers/cpufreq/amd-pstate.c
> @@ -424,12 +424,22 @@ static void amd_pstate_boost_init(struct amd_cpudata *cpudata)
>  	amd_pstate_driver.boost_enabled = true;
>  }
>  
> +static void amd_perf_ctl_reset(unsigned int cpu)
> +{
> +	wrmsrl_on_cpu(cpu, MSR_AMD_PERF_CTL, 0);
> +}
> +
>  static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
>  {
>  	int min_freq, max_freq, nominal_freq, lowest_nonlinear_freq, ret;
>  	struct device *dev;
>  	struct amd_cpudata *cpudata;
>  
> +	/*
> +	 * Resetting PERF_CTL_MSR will put the CPU in P0 frequency,
> +	 * which is ideal for initialization process.
> +	 */
> +	amd_perf_ctl_reset(policy->cpu);
>  	dev = get_cpu_device(policy->cpu);
>  	if (!dev)
>  		return -ENODEV;

-- 
Thanks & Regards,
Wyes
