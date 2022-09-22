Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEEA5E59C3
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 05:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIVD7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 23:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiIVD7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 23:59:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250B2ABD50;
        Wed, 21 Sep 2022 20:59:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJ6jbpn8cfbqW7CY5wb3aAd7dZviiDfXqzwifaClYvgEUQq0PmDbjHxpQWjcl9P72r58K9tlm7HaGFmlsBWwduEXPNJRb3oS9VgQI0w+s66OFY/CiNQSNk0DFy91cB/ifgboW7DIxbrX+eyVf2yWcQQH7jmlhE8L17yf8CDwCqDSLaBKCn0Pa8nCgW1Z8YMS8gtlH0JKsq8oaVKIYHbXJplERDNG4us/w04O/7wXMase/C8T+K5zWcQI1Vm9D20gX8se4N+1im0Hi/5B1p/6rCoZDIdQFD+BVrAwgFMzLLl3FRH1rmVhw/xRjaDVIxj7KzxDCtNQNH5fxI6pyzBFuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hl5r81CQtpuMo0ssJZyI3Q1zZ+CL78BchxMqyNz5iUw=;
 b=FdYflas4CSYKGCSaZtIOU6bYlzQcNmDLkkZjwbtL3T5X2Y0kdgaKbY3PfwcHQwfFdnxUtIimOXanrv+ciRc0idANPmG3ym/6PqMiZjvImAxxgWJLRbkQjh6b/YEluzpbcoCgAtsSpOZhHVju1cgtxeD5b5HVBprvrTctqA48Gf5vbM2YgOOZUdk/2skxbkEJc/kevy4V/OJ/tzTjO98tKz/SvumEsENKxS6aLEigfwc33p2lmPVuNLvrw9CN7LgmWQIm8ZIPxq22bcCjquu1ucF7/+hsmEFqUheHD9pSpeyTIwxGnsDeImy2AQho5fWhCuR9nIWzdY+KvliyOtdFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hl5r81CQtpuMo0ssJZyI3Q1zZ+CL78BchxMqyNz5iUw=;
 b=CztswcQE4+QpYrU5+6t4lQM4EM3RQH/6XuYtexVfx7ZreyMAhLgokMPM93ar8/gKrhjAyactrTWVPs76k/pgNvuJrO6wSQ3PxoIwtuXlF7AnURYUYEgkL19/dR6Z9v7062LXQE4Z4OOq0HhN7+kVIGJWZItnDAbPgq0o0EfQu/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6204.namprd12.prod.outlook.com (2603:10b6:930:23::19)
 by BL1PR12MB5317.namprd12.prod.outlook.com (2603:10b6:208:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 03:59:11 +0000
Received: from CY5PR12MB6204.namprd12.prod.outlook.com
 ([fe80::5557:a7f7:142d:5b0a]) by CY5PR12MB6204.namprd12.prod.outlook.com
 ([fe80::5557:a7f7:142d:5b0a%6]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 03:59:11 +0000
Message-ID: <fb54de68-d314-389c-0aff-9363ac2e50b9@amd.com>
Date:   Thu, 22 Sep 2022 09:28:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, gautham.shenoy@amd.com,
        Calvin Ong <calvin.ong@amd.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com> <YytrV2UMah8555+s@zn.tnic>
From:   Ananth Narayan <ananth.narayan@amd.com>
In-Reply-To: <YytrV2UMah8555+s@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0113.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::18) To CY5PR12MB6204.namprd12.prod.outlook.com
 (2603:10b6:930:23::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6204:EE_|BL1PR12MB5317:EE_
X-MS-Office365-Filtering-Correlation-Id: fec839cb-b0a7-4b85-b9ba-08da9c4ece1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPCm+DgTwmoLM//txegon98QoNA2u5f/TbLLZpE+nOP8dyRuo6ekEpvGywT4j2/5eycuz++UvHQvYIE6qFB5SLMwfUeRjc3xQlH7ez7Oue1UfhNx75/0sytG+l8b9lgHz8y/jYnVOBY43//ki8tEYNjw21EhTvs9O90VsMdBIH+2TAcDt96Z64oNRsLMu/gr5ipO793PBqOHptPU5KDNgrCjIy9XnvWv5UhWcSaSbxkBrc5YMUBt1W+01UJvw8sKzcWaNXLliNWZnQtYCH/VHWXyd/v4FwwwTsuwHPvRneSmF8SSxJJi9aPjf51garjjEzARd+oowWBL0VN0x4IrE5jI+8IG6DagieSy4WboUf7BLaPcrIXjSmW3y1lSme9jRyOr4VqQKT99HSFyqp7vj/zAVhF5HL/eRi8vGtNwSTgWt1SR4cOZ1VEC7afwMAKrOgMjDfTOu4pyjkMRNECx18SOSUeg/SL5nER+OGPLLw9DibA4Gvi8S7luaNuKiiH4k8mG+Kk+X6vngtistVPk8kbWcM0apq4TE2n3+B8vLMWMusYPyIy9QJHLie1sohG8CdmHoEp+9bQnUgltf57YLX9khyI1GyhWcl/kDUTL6Ru7cEQnfTKJVISQLepOVA0g8oEwpVbiLCQTBLDt6cGIbBtKs7ALhp7K0mrTfYf9M/W204cnecvcdUV/c0ITI5usjNYTnJf1E7iM/55r1Su2kOcgnrUgqfLOlm7HcPKoiPZPKz2afBD6XBFCBKwRdHuaR8RDjJpKAk8mm9jwFjfLQyjX0bvsBwQ51La58wAWgZgESSK/gfYheQpAyoVNvm8z146zUEQs7+TeArMb2Cp78orvaeH8sm0LK5awKdcwOLMPEGYEK92oH8oZcQs5mVaU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6204.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199015)(41300700001)(186003)(31686004)(36756003)(6506007)(8936002)(6486002)(316002)(2616005)(478600001)(38100700002)(54906003)(66946007)(66476007)(966005)(8676002)(66556008)(6666004)(44832011)(4326008)(26005)(6512007)(53546011)(86362001)(2906002)(31696002)(110136005)(5660300002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUlxcFRucnIyRFlBQ0kvSjc4WHF2eERzVlZpc0grWnMzbE5sUnVIdzhmcHc1?=
 =?utf-8?B?UFo5ZG42Vlh0dy9YTlRkM0hlZ1Uza3RLL2ZjU1JuLzZkOSs2UVhzdC9MRE9k?=
 =?utf-8?B?NDk1blBaQ0dZajZZODY5RERkMU84Q3lDSUpxZ29ma3JzUHlMTGpYZzB6bDdq?=
 =?utf-8?B?NWk0SU11T1lZLzNPRjdPUUlLQjZQb1kvYytTeDJna0pFQ3VHdHE0ZHBwL0Ex?=
 =?utf-8?B?NE96STFGR2E3VWFhZ1lBVnhwNUJ4aHh3djdaS1NpQmswWU9ZbldRUzVMV1h0?=
 =?utf-8?B?cDNEK1Q4Nm1kT3ZpTzZPNy9KdWthWlZzNEF2QUpBTFhQZ0ZsdFpndDNiR21N?=
 =?utf-8?B?bUlqdXpsL0ZZaFZRY3VoNmpHcHZpQytWS2pwQjQvYnJoUHFvQ2x1ZjVHY24w?=
 =?utf-8?B?dmJuSVl0S25wZE00Z3JZODE4WEtiSlhLLzFzcGt6M0J2TGt6MWVRL2FhVmMv?=
 =?utf-8?B?MStab0w0b1N4R2ZpMERHcno0SzltYXY4SWpQMFQ0QVdRc1AxZkZudGFEcnhN?=
 =?utf-8?B?K1FCY3pJYnNEZEVkdDNTMC9BbGNvR1l1OWRCVTJjc1VrRHZjblVmVmdmYWdm?=
 =?utf-8?B?L0J4WFFhbWdaWi9oMGFVaTFuT1RMWUtzSmFMQ2c3WGFtWUFuUEJiUHNlUjNR?=
 =?utf-8?B?NHNQWEd4OXFoNHdSNSsyY1VOUWlOTzhwdU5YaEUzeWp2U3JFM1Zac1MyWXBR?=
 =?utf-8?B?cUZYVVBSdkxrZ3k1RW1YODh3YlIyd0cxaWd4eE9TSkFHTExSbFppNG91Q0I2?=
 =?utf-8?B?TXJESHFEcGMvQ3hqbTVCeXJpMHVOQnVvdytvWlF1RnRQV2JlRzhaOGUvcHAy?=
 =?utf-8?B?NDFKcVAxTTBPSUpNWEQ5S1RaK3FITEFrb0s3QUJoTHVZRTBnTkpuRVRtMGdX?=
 =?utf-8?B?OUdKK1hlZVRUaHJTNTRuRGlVeU9hczVrM2ZGWFVWWFdJRDdlblVaSFhkZEpk?=
 =?utf-8?B?Rzg2ZTE5dkdnT0ZrM3l3dzdIT3AzMnhQR0Zndi9YYzY5N0ZUWUlGVEwvMm9p?=
 =?utf-8?B?R25TUmc4NlQ3a3Bma01GSDNCYmZPKzFKQmpTSkljTHNIektvZlhpd3cyc25n?=
 =?utf-8?B?NDZhdW9kYURmZit3SkxsTUkxR2RCUE1ZRGs4SndpOUljckcwekw1NHkvYW1R?=
 =?utf-8?B?RHREWFltaVJGd0FHS3NiUEdpOEREeTUzaHJJQ0IwYUpPcXBGZzJEZ2lBZm5p?=
 =?utf-8?B?VHZHamJVMmFuNThGSW1MLzVSN1drT0FpYzgwK09DRTdqV1Z5Rm9ZUCtwVUEv?=
 =?utf-8?B?clpUd3RiTnh1cjFMZ1M5SkVWbGJEbDdkUjBsUSsyazZWeWgxRkttR0FiS0Jl?=
 =?utf-8?B?a1lFMjBNNjBQdVNwOFZVRGFjMTVic2xJOC9iMVdpdUUreEFHNUNaa1lrODMx?=
 =?utf-8?B?aXU0UFVaRTAweG85bXFhZTN6b053NWtqc282YXNJQ04zQ25xS2NCK3ArbXV2?=
 =?utf-8?B?emh3L0pDMVY0RjBZa3Z6TCtmeUhQNUplNkZScDM4dUtBWmpHZ2hQUmhlNVNI?=
 =?utf-8?B?VXM2ckRVdm4zK0o2d2JsZnRjd3dndTZYbEpyeHFBK0ZIblptVCtwcDcvL3oy?=
 =?utf-8?B?WnRRN1dmYzB1ajdYZkhnamtrTVJaNndBKzhIMkNjWXBVcjJpT2JGLzlYZHNK?=
 =?utf-8?B?S3p6RG1kOWV4QW9QU2N6TDhhN1NuTnF0Tk4rVjdMVjhKV0MwanI2UnZkRXh1?=
 =?utf-8?B?UUlZVURlWUZka1RlY2laelF0QWNIQU82S21qVkVDd0UyVGpPYk9BSU43aERt?=
 =?utf-8?B?Mk01YWpscTd1SlJSVXZCSkovQTZXa2lpY2c3NUQ4Qnh3QXlGSFdoK2FxeHUz?=
 =?utf-8?B?U2VZVjRKUWVSRGpTT3VreEV4dGhRemQ1NmUzZXh4dUVVSHhmMCtTQkdCRVFh?=
 =?utf-8?B?cmxmME5XSmJmd0hhTnNLczRUdXBjMmswbU1haW1YWWE3YWdDUWZqUW5OdVdI?=
 =?utf-8?B?NmlacXhGSXBCeFFGQnpUbTVIYVl5aXR6NlBPaDE5MThHY1lEQnVlaUdXcXZZ?=
 =?utf-8?B?cWpSZmJ0WlcrRENXRU5WdWtVWnFCYURuNENwWFBMSWtQWGVyVmhWUDVKQTd6?=
 =?utf-8?B?YjZyVlhKZk84SGpVNlpSMktGYm1NOHY5Umd5Q29qelFHTXFsWlhRU2ptOTV6?=
 =?utf-8?Q?4A0nLtgUppsU54FUOBMDXmEKV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec839cb-b0a7-4b85-b9ba-08da9c4ece1e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6204.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 03:59:11.0066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GOF2V95w+9NRnXC4HHDrSWmri2il7AO0nXPT9HwHhI+gVIGgc0fBvdh+nZZBZ3j6QBEw/Fj2tJP3+c2GUmorw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5317
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 22-09-2022 01:21 am, Borislav Petkov wrote:
> On Wed, Sep 21, 2022 at 07:15:07AM -0700, Dave Hansen wrote:
>> In the end, the delay is because of buggy, circa 2006 chipsets?  So, we
>> use a CPU vendor specific check to approximate that the chipset is
>> recent and not affected by the bug?  If so, is there no better way to
>> check for a newer chipset than this?
> 
> So I did some git archeology but that particular addition is in some
> conglomerate, glued-together patch from 2007 which added the cpuidle
> tree:
> 
> commit 4f86d3a8e297205780cca027e974fd5f81064780
> Author: Len Brown <len.brown@intel.com>
> Date:   Wed Oct 3 18:58:00 2007 -0400
> 
>     cpuidle: consolidate 2.6.22 cpuidle branch into one patch

In fact, the code has moved around a fair bit and the check in its initial form
goes as far back as ACPI's posting for inclusion in the kernel in March 2002
[1]. We could not find any way of digging further back, yet.

Prior to that, I think the ACPI enablement code was being released independent
of the kernel per https://kernel.org/doc/ols/2004/ols2004v1-pages-121-132.pdf
and was included in Andrew's mm tree for a while.

From https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git
the first tag that contains code with the dummy read is v2.5.7 AFAICS.

Ananth

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux-fullhistory.git/commit/?id=972c16130d9dc182cedcdd408408d9eacc7d6a2d
