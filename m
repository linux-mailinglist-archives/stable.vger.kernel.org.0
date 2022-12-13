Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0664B3D0
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiLMLKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 06:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiLMLJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 06:09:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2151FCF7;
        Tue, 13 Dec 2022 03:07:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyKCXKvODcre4kzRnfx+tcJsssmpmfU1sNV68hgl/xgPF4mcCytZSTSoE2+m3K2dwSnfAd+7Qzz4RoyIFm1zUiJTzzwEUHZVYcY0ygKJqWw2cobq0WcDC7YUtCf8T107vfIDvi3xD/Nrw3ELnuVRDiai/eaMoOqsZH0IUjakUhOhDCEmsoxuJxq8MpjMbeR2ApXZvKAr8KtxuwwdsREmIeArT6LK/OrTilnHqpYeuu7YIs5EERxxcg4o50XtXJMehvCnBFxGPazJjAao2k2bm7FyFxzspoctXillpzFp7rn3V6LJSYWbOY6qXU/sigLHj/c3TtRQprdMMtxEW5iYCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ef1tm1JqVInEcLVnBWVY7FblySQPWDKL7vW0xCAVoiY=;
 b=JUaDQ+YtLrV1Hy2wt43vWsA3d3hEo2kIAI5E/YX97X/o19/a7oo8q6NdY9n+LttkHYOA+Un2Ob2AKaGbiFcZsIwM107vJAoudiBcdw4yAJLbknogOGR2bkNtnFRUxVxxbK+seXLkETxpf8uxDPUcF7tc/f4RUD+2c7cHO9fx3HF1my80ZLf1Xo2CBgmPY1jGF+apLN7/jptcGqxpNoiCY1X7RrG7+QtW2AhbqZ1E81pD6f9MgM8BK9gzQ4wCrxnwJFxeufoUj9lT9OMXryu1PfF/ttbqMd9QeLx5+U2ZklX0Gi1fRciTfxCKu7w00nFTCcK/rIl4MmLRKDXxUcDE7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef1tm1JqVInEcLVnBWVY7FblySQPWDKL7vW0xCAVoiY=;
 b=Ptm9j7OYDcWwVPKtUl/QHDdPfgbt4LN4g8oCuRezAYd8rB1J9BD+zORiSi9Seh0kHbiHlKUgFNzU4zxx1m9eYflNQv6Icvs47gQOgg9QtMgZA3fP7YJbPd95akvUSqG22NEOajNRH2PRFXR7DIHQXh0dZhsknLeEt7dfXDdFbag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24)
 by CH2PR12MB4183.namprd12.prod.outlook.com (2603:10b6:610:7a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 11:07:51 +0000
Received: from CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4]) by CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4%6]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 11:07:51 +0000
Message-ID: <aada0f7c-5865-7d7e-0280-443ee1f416bf@amd.com>
Date:   Tue, 13 Dec 2022 16:37:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/1] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Cc:     Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>
References: <43568d5e6395fcab48262fa5b3d1a5112918fbe8.1669372199.git.Rijo-john.Thomas@amd.com>
 <7d4bca0d-2b31-26d5-26cd-655fd2b82107@amd.com>
 <aec3a8a8-e64e-c53a-a7fd-825d3ac4001e@amd.com>
 <eded8b50-14f1-c7b2-2176-12980fc70a71@amd.com>
Content-Language: en-US
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <eded8b50-14f1-c7b2-2176-12980fc70a71@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0214.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::9) To CH0PR12MB5346.namprd12.prod.outlook.com
 (2603:10b6:610:d5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5346:EE_|CH2PR12MB4183:EE_
X-MS-Office365-Filtering-Correlation-Id: e1726c8c-a3df-44ad-ae21-08dadcfa4613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtycmUPXzH9s4DXITLi5RUjJbJ8a6JQeAC0XWvC5mplbX/fsvUR+P0UP15HunZHThMvIeuEAfhOLO3K71DDzQhpsHA+K9ksHjN55h17HBfrciYslL3lk9jomBWyRVOqiuSPRYkgccrYq5cM5yEgLXAQextgqAsc449iu4GoNUtZLNxkhz7+LAya+8FunNNUV1KYsfZMAkeAcyQbADL8axGR7nZlFpvnhNYd5+x/+9aBJh3Jkw8/YgNGqhTPnaNDpQ+vsabGQSFaF2j2SGXerMz3we7AvnrhvdyAckwyU7m23VFiZD3HJRZsKmC3vBtFL1Hlc6oVuDzNgDaIpB1GCrseQLzIt/aVQCHNuyyLtvr1U5r9yJ4tB8qt0+QD6kwVUx6SmxiqylE5ewSthu5Zlzt0mx3vrK5plIWHtnHTJwBXxyetF7/Upe7loORvHHVK2fKaFxQvL0kTeXVPmmNvOFO4ea9HtJR8MOZsvWCVDRUG4nWA3Azb5xyXI+T8NfYqQUuLFcdvsiITD2JVwWkOaz+v9yxWescAd0HPLrH90TJfFQFhtLq67Wlm6C1+TbLYTdv0PAHLAn2NvWojB0BKCSyTwRzNaqvfThSeszMYNHodfhLjADfDtVaDzm4q+rWwwB3V3D4px34kysLIcQqefXWt4ZbM5w5ViD8KVY3/8hOTMRK5cuzMBuNTnQphLjzXm3ww7oq98gShopqR+84b7PJhdXWrn9GSc72PSdg7L5OchoEToctyZ/mTOo6SrGofS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5346.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199015)(66899015)(6486002)(478600001)(31686004)(6506007)(2906002)(86362001)(6666004)(53546011)(36756003)(31696002)(26005)(186003)(38100700002)(6512007)(921005)(2616005)(4326008)(83380400001)(110136005)(41300700001)(54906003)(30864003)(8936002)(5660300002)(66946007)(66476007)(8676002)(66556008)(316002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0ZHQWd0M00xVjRSeC8xMWxRZTZNVjkxRm5LZlBDaGVETXBwbnNCYjFZT3dJ?=
 =?utf-8?B?ZS9xRS9BRWhzZVZvVEEreGhSSklPdWhMVkc4UkpZdWF0NDJKSUNBekJOcjJF?=
 =?utf-8?B?dDRoRmtvVnc1RmY0Nlhua3lmYnE2S2kyeFlEVjBtSjdWRnZUV3FSa1h4VXl4?=
 =?utf-8?B?K1dHTWNIM2UyRjNNTlNjYWhsK2Qzek15T0dTdDhmMjlKek9iSlJmNzZTTXp0?=
 =?utf-8?B?R2JBMzFrUFg1L3piaUZ1NXgvc05mK2thTElpVmRXT0dTdWtPRmIrUURTbW5Q?=
 =?utf-8?B?ODI3RDA3ZnZYYWFHaWNtY1dQQ20xQllPL2tBYm1qQzRTR0Nla0dLdWI3b2V1?=
 =?utf-8?B?ODQwQnBBVEpwUUxHUlQxeEIzc1pGaTN3WVIzN0s5dk41QWJNV1haYWt3TGZV?=
 =?utf-8?B?WGNULzdaN3ZQZmcwbTNjaHdtN1U5Z0gxLytpakVxOXg5ZXBIMGllTXc2WWNn?=
 =?utf-8?B?R2JoVGJTbFFUUXlBeU9kTSs4YUpIaG1JeUVkSUNUbXRGY2VFY1gwcHpUQTNW?=
 =?utf-8?B?RURZTTRHaGZ2Z2c4bC9lVlZ0aDMzdVovVk5QWlFsdTJqdFJOcVZwaE5MRmI1?=
 =?utf-8?B?ZWdLcllicEd3Q0c2LzBRR3FkNnZuejFXQmY3NUhlMm5WdGovVTA1ZXd3Z0sy?=
 =?utf-8?B?S3BOVWprVDZqaEhYVE9vemJKclcvajhyeGYxb1ZsQUhWajV6V212bHJ1eW8w?=
 =?utf-8?B?N2FpNEFqRlJuSUlJVEVxSWhZNXJZTFN5eTVpa2I2TXdBZERWVlYwY01TL0NT?=
 =?utf-8?B?UHJ6QmFUeHBWKzQvdlB1QWUzR002dGxiNjhuOUkwYU1iemN5U2pFR1F1UXRJ?=
 =?utf-8?B?a2wvN3JCY2RFeHh6UFBWbG5vS1NWMWN6dllRNk44VjNGVDFDd0Z0Wk9DVGlB?=
 =?utf-8?B?MlpVbTdVZHF4c00rcWU1VkY3WVFLN1k2c0gzYlpzQjFISk5SUElBMzhHZ0w3?=
 =?utf-8?B?OGhCQWxUaDEyZk5ZMk5IOXBBTitBaUxDQ3FwUHFtSmt0dWVieE8xRlNBQWx0?=
 =?utf-8?B?UEpRODZEN1I5MHlOcnlia2w0NHEzclVsVndkRnRyelh2VEVlZTVGMUdoNFhG?=
 =?utf-8?B?T1NPOE5WcnR2c24zQmx5Z2txNm9nbEIyRGZyZW0vcjRBNEc0WTMzc1hJSW9X?=
 =?utf-8?B?TnJsRlV3NFpkb2JkY1VRNGVWeXZTRjJlSkpTakR6U0JhTWw2TmpzRFJaU2Jy?=
 =?utf-8?B?K0M2a2IxeDdyK0cySXY3RGFRVXhmdGcvbjJhTFlndmFKcURiVmEwRVg3WkYv?=
 =?utf-8?B?OFhGMU05TjE5RXducXhpaUlYcmh1OGR2bzgrby95eE8wZ0g3cytKeHREcXcv?=
 =?utf-8?B?bW9ZQjh0RFQva0dvMVVwK29yd2I0a3AzdGtuZkYyWHc3dnF0Zmx4NURJZ29S?=
 =?utf-8?B?WHNueHAxRm53Z1craVJiRU93NGY4SmFpYWdiVC9IdStBNTZKUWVjL3lDcWZN?=
 =?utf-8?B?V3paa0lYZnVXOFlWZFZnSUN2djZ3Y3BuT3oxSU5YaC9DZWM1d04vNW1rbTNO?=
 =?utf-8?B?a2crRVk1L1lvMlA4S1FKWUVEUlZTTC9LTGpoa3laSjd2TVphclVzMEZvYUEx?=
 =?utf-8?B?aUdUb3JjZURnTmxnV2VyMGV1Wms3OWpySmZrV0FqUmN4aDVSZTdrNGpDSEs4?=
 =?utf-8?B?OGMrOGxmR2NHQ1RWelZSL0dsWkh5VUhXMkNxYmV4R1JQYVptMU1RTzhnbnlm?=
 =?utf-8?B?bUVTYWtTc3MvL0MwVlFXL1hIRHRRcFdQL201bitxcWptMzU3bFl5N05iN0h0?=
 =?utf-8?B?UjlWcVdDdjg4L0ZwdnV1VjVlSEdobEVxc1JKd0I3YjBTeWx4WjZreE83ajFp?=
 =?utf-8?B?a0tCb2ZveXVkZ20wQk9SeU9LNHlUSUMwb2R1YXIwVU9pSHNWUENMUmlyUHN6?=
 =?utf-8?B?blBtM3Q1Mk9hTmxheTk4VzZqY00yTFZIOFlQaDFxMGZGVFIyczNFeXp2eTBL?=
 =?utf-8?B?aWJDYnArZXRHdktLNGlKc1JNT0JVeEVFdi9kM0dFd1hXUXFKWkx0dkRlN0NU?=
 =?utf-8?B?QlQ2OHg5Y0h2QzI3cFE4dUg0RkdPU2p6Rk9sTjBlT25MV2V6Y3lwTjlyWmZq?=
 =?utf-8?B?V1NLVFBud2FrTm5DTnIyL2JJb2ttYmxXSDF6czVlS2FXeHVHZTQ5N0RibDVw?=
 =?utf-8?Q?1bA7p4haoJFm4bR4YX8z2KrPN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1726c8c-a3df-44ad-ae21-08dadcfa4613
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5346.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 11:07:51.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxuaj1Lk0y5EOGGQuDwLdEFBD+XGKwOmZdZb2mXkS2eF/tueTmTkuVQrT+caL71BB2T3ZZvQl1DE8XMlTkL7UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4183
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/12/2022 9:13 PM, Tom Lendacky wrote:
> On 12/12/22 05:21, Rijo Thomas wrote:
>> On 12/10/2022 2:31 AM, Tom Lendacky wrote:
>>> On 12/6/22 06:30, Rijo Thomas wrote:
>>>> For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
>>>> ring buffer address sent by host to ASP must be a real physical
>>>> address and the pages must be physically contiguous.
>>>>
>>>> In a virtualized environment though, when the driver is running in a
>>>> guest VM, the pages allocated by __get_free_pages() may not be
>>>> contiguous in the host (or machine) physical address space. Guests
>>>> will see a guest (or pseudo) physical address and not the actual host
>>>> (or machine) physical address. The TEE running on ASP cannot decipher
>>>> pseudo physical addresses. It needs host or machine physical address.
>>>>
>>>> To resolve this problem, use DMA APIs for allocating buffers that must
>>>> be shared with TEE. This will ensure that the pages are contiguous in
>>>> host (or machine) address space. If the DMA handle is an IOVA,
>>>> translate it into a physical address before sending it to ASP.
>>>>
>>>> This patch also exports two APIs (one for buffer allocation and
>>>> another to free the buffer). This API can be used by AMD-TEE driver to
>>>> share buffers with TEE.
>>>>
>>>> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
>>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
>>>> Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>>>> Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>>>> Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>>>> ---
>>>>    drivers/crypto/ccp/psp-dev.c |   6 +-
>>>>    drivers/crypto/ccp/tee-dev.c | 116 ++++++++++++++++++++++-------------
>>>>    drivers/crypto/ccp/tee-dev.h |   9 +--
>>>>    include/linux/psp-tee.h      |  47 ++++++++++++++
>>>>    4 files changed, 127 insertions(+), 51 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>>>> index c9c741ac8442..2b86158d7435 100644
>>>> --- a/drivers/crypto/ccp/psp-dev.c
>>>> +++ b/drivers/crypto/ccp/psp-dev.c
>>>> @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
>>>>            goto e_err;
>>>>        }
>>>>    +    if (sp->set_psp_master_device)
>>>> +        sp->set_psp_master_device(sp);
>>>> +
>>>
>>> This worries me a bit...  if psp_init() fails, it may still be referenced as the master device. What's the reason for moving it?
>>
>> Hmm. Okay, I see your point.
>>
>> In psp_tee_alloc_dmabuf(), we call psp_get_master_device(). Without above change, psp_get_master_device() returns NULL.
>>
>> I think in psp_dev_init(), we can add below error handling:
>>
>> ret = psp_init(psp);
>>          if (ret)
>>                  goto e_init;
>>       ...
>>
>> e_init:
>>      if (sp->clear_psp_master_device)
>>          sp->clear_psp_master_device(sp);
>>
>> Will this help address your concern?
> 
> Yes, that works.
> 
>>
>>>
>>>>        ret = psp_init(psp);
>>>>        if (ret)
>>>>            goto e_irq;
>>>>    -    if (sp->set_psp_master_device)
>>>> -        sp->set_psp_master_device(sp);
>>>> -
>>>>        /* Enable interrupt */
>>>>        iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
>>>>    diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>>>> index 5c9d47f3be37..1631d9851e54 100644
>>>> --- a/drivers/crypto/ccp/tee-dev.c
>>>> +++ b/drivers/crypto/ccp/tee-dev.c
>>>> @@ -12,8 +12,9 @@
>>>>    #include <linux/mutex.h>
>>>>    #include <linux/delay.h>
>>>>    #include <linux/slab.h>
>>>> +#include <linux/dma-direct.h>
>>>> +#include <linux/iommu.h>
>>>>    #include <linux/gfp.h>
>>>> -#include <linux/psp-sev.h>
>>>>    #include <linux/psp-tee.h>
>>>>      #include "psp-dev.h"
>>>> @@ -21,25 +22,64 @@
>>>>      static bool psp_dead;
>>>>    +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>>>
>>> It looks like both calls to this use the same gfp_t values, you can probably eliminate from the call and just specify them in here.
>>>
>>
>> Okay, I will remove gfp_t flag from the function argument.
>>
>>>> +{
>>>> +    struct psp_device *psp = psp_get_master_device();
>>>> +    struct dma_buffer *dma_buf;
>>>> +    struct iommu_domain *dom;
>>>> +
>>>> +    if (!psp || !size)
>>>> +        return NULL;
>>>> +
>>>> +    dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
>>>> +    if (!dma_buf)
>>>> +        return NULL;
>>>> +
>>>> +    dma_buf->vaddr = dma_alloc_coherent(psp->dev, size, &dma_buf->dma, gfp);
>>>> +    if (!dma_buf->vaddr || !dma_buf->dma) {
>>>
>>> I don't think you can have one of these be NULL without both being NULL, but I guess it doesn't hurt to check.
>>>
>>
>> Okay, we will keep both checks for now.
>>
>>>> +        kfree(dma_buf);
>>>> +        return NULL;
>>>> +    }
>>>> +
>>>> +    dma_buf->size = size;
>>>> + > +    dom = iommu_get_domain_for_dev(psp->dev);
>>>> +    if (dom)
>>>
>>> You need a nice comment above this all explaining that. I guess you're using the presence of a domain to determine whether you're running on bare-metal vs within a hypervisor? I'm not sure what will happen if the guest ever gets an emulated IOMMU...
>>
>> Sure we will add a comment.
>>
>> We are not trying to determive bare-metal vs hypervisor here, but determine whether DMA handle returned by dma_alloc_coherent() is an IOVA or not.
>> If the address is an IOVA, we convert IOVA to physical address using iommu_iova_to_phys(). This was our intention.
> 
> Ok, but if a VM gets an emulated IOMMU and ends up with an IOVA, that IOVA points to a GPA - and if the size is over a page, then you aren't guaranteed to have contiguous physical memory.
> 
> Probably not a concern at the moment, but not sure about what happens in the future.
> 

We are not having a VM with an emulated IOMMU. We will have to handle it in case a need arises in future.

If iommu_iova_to_phys() returns a GPA, then this patch will not be functional.

We ran the VM as a paravirtualized guest. So, the guest allocations using dma_alloc_coherent() gave us memory that was contiguous in host or machine address space.

>>
>>>
>>>> +        dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
>>>
>>> If you're just looking to get the physical address, why not just to an __pa(dma_buf->vaddr)?
>>>
>>> Also, paddr might not be the best name, since it isn't always a physical address, but I can't really think of something right now.
>>>
>>
>> We can use __pa(dma_buf->vaddr) only on bare-metal. In hypervisor, __pa(dma_buf->vaddr) gives pseudo-physical address; pseudo-physical address cannot be understood by ASP.
>> ASP needs real physical address (aka machine address). Please see commit message.
>>
>> We chose the name paddr, since it's a (real) physical address that we want to send across to ASP. I am not sure, why you say - it isn't always a physical address.
> 
> Then a nice comment above this explaining all that and the fact that when there is no IOMMU the DMA address is actually the physical address, would be appropriate. A number of years from now, this will raise questions without thorough documentation.

Agreed. We will add proper comment. We will keep the name paddr for now.

Thanks,
Rijo

> 
> Thanks,
> Tom
> 
>>
>> Thanks,
>> Rijo
>>
>>> Thanks,
>>> Tom
>>>
>>>> +    else
>>>> +        dma_buf->paddr = dma_buf->dma;
>>>> +
>>>> +    return dma_buf;
>>>> +}
>>>> +EXPORT_SYMBOL(psp_tee_alloc_dmabuf);
>>>> +
>>>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buf)
>>>> +{
>>>> +    struct psp_device *psp = psp_get_master_device();
>>>> +
>>>> +    if (!psp || !dma_buf)
>>>> +        return;
>>>> +
>>>> +    dma_free_coherent(psp->dev, dma_buf->size,
>>>> +              dma_buf->vaddr, dma_buf->dma);
>>>> +
>>>> +    kfree(dma_buf);
>>>> +}
>>>> +EXPORT_SYMBOL(psp_tee_free_dmabuf);
>>>> +
>>>>    static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
>>>>    {
>>>>        struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>>>> -    void *start_addr;
>>>>          if (!ring_size)
>>>>            return -EINVAL;
>>>>    -    /* We need actual physical address instead of DMA address, since
>>>> -     * Trusted OS running on AMD Secure Processor will map this region
>>>> -     */
>>>> -    start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
>>>> -    if (!start_addr)
>>>> +    rb_mgr->ring_buf = psp_tee_alloc_dmabuf(ring_size,
>>>> +                        GFP_KERNEL | __GFP_ZERO);
>>>> +    if (!rb_mgr->ring_buf) {
>>>> +        dev_err(tee->dev, "ring allocation failed\n");
>>>>            return -ENOMEM;
>>>> -
>>>> -    memset(start_addr, 0x0, ring_size);
>>>> -    rb_mgr->ring_start = start_addr;
>>>> -    rb_mgr->ring_size = ring_size;
>>>> -    rb_mgr->ring_pa = __psp_pa(start_addr);
>>>> +    }
>>>>        mutex_init(&rb_mgr->mutex);
>>>>          return 0;
>>>> @@ -49,15 +89,8 @@ static void tee_free_ring(struct psp_tee_device *tee)
>>>>    {
>>>>        struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>>>>    -    if (!rb_mgr->ring_start)
>>>> -        return;
>>>> +    psp_tee_free_dmabuf(rb_mgr->ring_buf);
>>>>    -    free_pages((unsigned long)rb_mgr->ring_start,
>>>> -           get_order(rb_mgr->ring_size));
>>>> -
>>>> -    rb_mgr->ring_start = NULL;
>>>> -    rb_mgr->ring_size = 0;
>>>> -    rb_mgr->ring_pa = 0;
>>>>        mutex_destroy(&rb_mgr->mutex);
>>>>    }
>>>>    @@ -81,35 +114,36 @@ static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
>>>>        return -ETIMEDOUT;
>>>>    }
>>>>    -static
>>>> -struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>>>> +struct dma_buffer *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>>>>    {
>>>>        struct tee_init_ring_cmd *cmd;
>>>> +    struct dma_buffer *cmd_buffer;
>>>>    -    cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>>>> -    if (!cmd)
>>>> +    cmd_buffer = psp_tee_alloc_dmabuf(sizeof(*cmd),
>>>> +                      GFP_KERNEL | __GFP_ZERO);
>>>> +    if (!cmd_buffer)
>>>>            return NULL;
>>>>    -    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_pa);
>>>> -    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_pa);
>>>> -    cmd->size = tee->rb_mgr.ring_size;
>>>> +    cmd = (struct tee_init_ring_cmd *)cmd_buffer->vaddr;
>>>> +    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_buf->paddr);
>>>> +    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_buf->paddr);
>>>> +    cmd->size = tee->rb_mgr.ring_buf->size;
>>>>          dev_dbg(tee->dev, "tee: ring address: high = 0x%x low = 0x%x size = %u\n",
>>>>            cmd->hi_addr, cmd->low_addr, cmd->size);
>>>>    -    return cmd;
>>>> +    return cmd_buffer;
>>>>    }
>>>>    -static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
>>>> +static inline void tee_free_cmd_buffer(struct dma_buffer *cmd_buffer)
>>>>    {
>>>> -    kfree(cmd);
>>>> +    psp_tee_free_dmabuf(cmd_buffer);
>>>>    }
>>>>      static int tee_init_ring(struct psp_tee_device *tee)
>>>>    {
>>>>        int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>>>> -    struct tee_init_ring_cmd *cmd;
>>>> -    phys_addr_t cmd_buffer;
>>>> +    struct dma_buffer *cmd_buffer;
>>>>        unsigned int reg;
>>>>        int ret;
>>>>    @@ -123,21 +157,19 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>>>          tee->rb_mgr.wptr = 0;
>>>>    -    cmd = tee_alloc_cmd_buffer(tee);
>>>> -    if (!cmd) {
>>>> +    cmd_buffer = tee_alloc_cmd_buffer(tee);
>>>> +    if (!cmd_buffer) {
>>>>            tee_free_ring(tee);
>>>>            return -ENOMEM;
>>>>        }
>>>>    -    cmd_buffer = __psp_pa((void *)cmd);
>>>> -
>>>>        /* Send command buffer details to Trusted OS by writing to
>>>>         * CPU-PSP message registers
>>>>         */
>>>>    -    iowrite32(lower_32_bits(cmd_buffer),
>>>> +    iowrite32(lower_32_bits(cmd_buffer->paddr),
>>>>              tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
>>>> -    iowrite32(upper_32_bits(cmd_buffer),
>>>> +    iowrite32(upper_32_bits(cmd_buffer->paddr),
>>>>              tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
>>>>        iowrite32(TEE_RING_INIT_CMD,
>>>>              tee->io_regs + tee->vdata->cmdresp_reg);
>>>> @@ -157,7 +189,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>>>        }
>>>>      free_buf:
>>>> -    tee_free_cmd_buffer(cmd);
>>>> +    tee_free_cmd_buffer(cmd_buffer);
>>>>          return ret;
>>>>    }
>>>> @@ -167,7 +199,7 @@ static void tee_destroy_ring(struct psp_tee_device *tee)
>>>>        unsigned int reg;
>>>>        int ret;
>>>>    -    if (!tee->rb_mgr.ring_start)
>>>> +    if (!tee->rb_mgr.ring_buf->vaddr)
>>>>            return;
>>>>          if (psp_dead)
>>>> @@ -256,7 +288,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>>>        do {
>>>>            /* Get pointer to ring buffer command entry */
>>>>            cmd = (struct tee_ring_cmd *)
>>>> -            (tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
>>>> +            (tee->rb_mgr.ring_buf->vaddr + tee->rb_mgr.wptr);
>>>>              rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
>>>>    @@ -305,7 +337,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>>>          /* Update local copy of write pointer */
>>>>        tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
>>>> -    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
>>>> +    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_buf->size)
>>>>            tee->rb_mgr.wptr = 0;
>>>>          /* Trigger interrupt to Trusted OS */
>>>> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
>>>> index 49d26158b71e..9238487ee8bf 100644
>>>> --- a/drivers/crypto/ccp/tee-dev.h
>>>> +++ b/drivers/crypto/ccp/tee-dev.h
>>>> @@ -16,6 +16,7 @@
>>>>      #include <linux/device.h>
>>>>    #include <linux/mutex.h>
>>>> +#include <linux/psp-tee.h>
>>>>      #define TEE_DEFAULT_TIMEOUT        10
>>>>    #define MAX_BUFFER_SIZE            988
>>>> @@ -48,17 +49,13 @@ struct tee_init_ring_cmd {
>>>>      /**
>>>>     * struct ring_buf_manager - Helper structure to manage ring buffer.
>>>> - * @ring_start:  starting address of ring buffer
>>>> - * @ring_size:   size of ring buffer in bytes
>>>> - * @ring_pa:     physical address of ring buffer
>>>>     * @wptr:        index to the last written entry in ring buffer
>>>> + * @ring_buf:    ring buffer allocated using DMA api
>>>>     */
>>>>    struct ring_buf_manager {
>>>>        struct mutex mutex;    /* synchronizes access to ring buffer */
>>>> -    void *ring_start;
>>>> -    u32 ring_size;
>>>> -    phys_addr_t ring_pa;
>>>>        u32 wptr;
>>>> +    struct dma_buffer *ring_buf;
>>>>    };
>>>>      struct psp_tee_device {
>>>> diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
>>>> index cb0c95d6d76b..c0fa922f24d4 100644
>>>> --- a/include/linux/psp-tee.h
>>>> +++ b/include/linux/psp-tee.h
>>>> @@ -13,6 +13,7 @@
>>>>      #include <linux/types.h>
>>>>    #include <linux/errno.h>
>>>> +#include <linux/dma-mapping.h>
>>>>      /* This file defines the Trusted Execution Environment (TEE) interface commands
>>>>     * and the API exported by AMD Secure Processor driver to communicate with
>>>> @@ -40,6 +41,20 @@ enum tee_cmd_id {
>>>>        TEE_CMD_ID_UNMAP_SHARED_MEM,
>>>>    };
>>>>    +/**
>>>> + * struct dma_buffer - Structure for a DMA buffer.
>>>> + * @dma:    DMA buffer address
>>>> + * @paddr:  Physical address of DMA buffer
>>>> + * @vaddr:  CPU virtual address of DMA buffer
>>>> + * @size:   Size of DMA buffer in bytes
>>>> + */
>>>> +struct dma_buffer {
>>>> +    dma_addr_t dma;
>>>> +    phys_addr_t paddr;
>>>> +    void *vaddr;
>>>> +    unsigned long size;
>>>> +};
>>>> +
>>>>    #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>>>    /**
>>>>     * psp_tee_process_cmd() - Process command in Trusted Execution Environment
>>>> @@ -75,6 +90,28 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
>>>>     */
>>>>    int psp_check_tee_status(void);
>>>>    +/**
>>>> + * psp_tee_alloc_dmabuf() - Allocates memory of requested size and flags using
>>>> + * dma_alloc_coherent() API.
>>>> + *
>>>> + * This function can be used to allocate a shared memory region between the
>>>> + * host and PSP TEE.
>>>> + *
>>>> + * Returns:
>>>> + * non-NULL   a valid pointer to struct dma_buffer
>>>> + * NULL       on failure
>>>> + */
>>>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp);
>>>> +
>>>> +/**
>>>> + * psp_tee_free_dmabuf() - Deallocates memory using dma_free_coherent() API.
>>>> + *
>>>> + * This function can be used to release shared memory region between host
>>>> + * and PSP TEE.
>>>> + *
>>>> + */
>>>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer);
>>>> +
>>>>    #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>>>      static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
>>>> @@ -87,5 +124,15 @@ static inline int psp_check_tee_status(void)
>>>>    {
>>>>        return -ENODEV;
>>>>    }
>>>> +
>>>> +static inline
>>>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>>>> +{
>>>> +    return NULL;
>>>> +}
>>>> +
>>>> +static inline void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer)
>>>> +{
>>>> +}
>>>>    #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>>>>    #endif /* __PSP_TEE_H_ */
