Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B675B644467
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 14:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiLFNQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 08:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFNQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 08:16:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62202CE38;
        Tue,  6 Dec 2022 05:15:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqMBKJIzOoUZmKPEvSPDV+zx7bPDIYoQ+rot5I4JtamvIK4CyM0gnWPS6nHAIcI7HEAdLe/ldxBk4upuDcAmxiwpFmZQgrJ9tGN2v8g9mfd/T2q9Nzp7/1jma4F88PmxjrfZio4ugkQTjmFIHCCtIJQF3iC/BKPULMgnmWYsWJ6q5DOqI6+RIRjmam6hTzQRh384ezc3zwgo6ovfhYRNue1n/b+jKJAeGxkgSElujHOR9d/zKPGdIkyqw/+lA+1AEMV4JVetGF9FywMfLva44dDW/Uicg1imo//jGoF6+g0qvtHeD8beOUJbnkqrwXIh4pgLQIqBRjnximRPeZsi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lupi0vywCMGz4l+7xWo0DbQpUW1Fd7gq9CGETcmJ6D8=;
 b=QZ+arzxIqRIAGM2sMBylQovHaKd0wJULn8zOfwXtK2RO319ZAYl7mGJI+vDbFxFLQXRvI3bmd3t2iD4Kf+NA3EDgom34bU/XcKdDMjrwbWLqQa7HRmjVDv7bJ2R5e/MnJXfn0dYc3y9KOAt9i+5dtzYH3LYS1a3A+eLpWy06+9GUz60n5LVw1S19pfC5F276iaFOQKX7FDTnXgx54gY0B4fHQlnvxlLg2luDoGf88LbuiG5ksSHyS8jIR33byaz7vAQ/qy5qwzLeuaugnA17TFBFXx/xEgYgppPg7LjleFgedTr0tAJnbAOQFua93E0hpgaaRN35vjFkCOyTZjSRNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lupi0vywCMGz4l+7xWo0DbQpUW1Fd7gq9CGETcmJ6D8=;
 b=qQiVLooNn+B+b3H/dc2g66jzaPHHsmnhb82YtiPq5tQyjPD5N3q6RHE4WYe+Hg+SY+ZaZFWChzMi1zqRA+eWQiRS2G8HwpWdtkXvyzqQdmefANbFon+5r5LyguygbHUdSTElJDRk/vSQOMFe88VZPDFJPMx/jUMpXXoHDIn8z+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24)
 by CY8PR12MB7340.namprd12.prod.outlook.com (2603:10b6:930:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Tue, 6 Dec
 2022 13:15:39 +0000
Received: from CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4]) by CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 13:15:39 +0000
Message-ID: <5e0d26ac-4164-9c16-f7ea-54811ea56fc0@amd.com>
Date:   Tue, 6 Dec 2022 18:45:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/1] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Cc:     Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>
References: <43568d5e6395fcab48262fa5b3d1a5112918fbe8.1669372199.git.Rijo-john.Thomas@amd.com>
 <78b23ccf-f50f-a793-ae6a-0a70faa2fb06@amd.com>
 <f551325a-2033-bd9c-e863-a7e57993349a@amd.com>
 <56917e3c-45c1-1930-9f55-22fdd536c16c@amd.com>
Content-Language: en-US
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <56917e3c-45c1-1930-9f55-22fdd536c16c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0039.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::15) To CH0PR12MB5346.namprd12.prod.outlook.com
 (2603:10b6:610:d5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5346:EE_|CY8PR12MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: e888fada-883e-4b67-3b61-08dad78bf81b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pONngUvAFwoq14PftfZVxqiBhWz+Czmon73LHRr0GF8rnH2xKZmnyksmDn1kEsKSJiWjxMGPHQZ1lKeMNTskeXIJ2GyEWSaZsA+BGueI1FuIWtiR1vu5FhmhYpe/ty6sCgvyUhNjR7EQ3Ll4XBkd4oh5N2byGWAiemJA9ffGSDgE0RLur8ERv5ZKJ2twruR7dmoqLm/ECwFrhKxLLhbReLA/Hptq3kp5ou0PNKQ8aLHV/uiyzmLsqFn6Swer8vgsZ9GDYWuYJ/srUVLNcLavcf4tKOc2f+NzvGY89kpAuD7SlQJbwRQYp47B+t/WxYDPw12YjUalpvmqqDVQid/gW1BAZ4YQa6/AMEp8Omf8NPYHIXtpU0hnwoPmOk06uFuYVer7bB8bSZMynG7Tx8TOi4Du/RgITQ8tbPxqHBs3BvuEFrYFjZ/LZg3Sc9ViSubrHvIE6jg3awMcECiBWQlhMt9Eg52Je5/tFcE6153SBdVgpOpCgLDhJRHrBPkrTGEpX/t2dGL0QlEW4U+a7rvLgbLf1vmOn6YFK47RYzfWgPEoyxVkI6mO7Ke3CPaJKRmPAbWItFP2LjD7OuWcbVnr27jJl372OXgRM1m/eDwDEUDjc3SJydobQYmMLoVPwO3keBh1XN3syx/QLmyNLuTyvcMWL5IqqPfN5kS5Ra6qrioUeQ7SndTczEdthLG3VUpZsyAd4iYoBLytsn/2dskPOntVegIcSCJf1lWQBozBxkVQzidnbeAjW9TxS3UfJzOw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5346.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199015)(30864003)(41300700001)(83380400001)(31686004)(66556008)(4326008)(8676002)(66946007)(66476007)(36756003)(186003)(2616005)(66574015)(31696002)(66899015)(86362001)(54906003)(110136005)(5660300002)(6506007)(2906002)(53546011)(6512007)(8936002)(7416002)(478600001)(26005)(6666004)(921005)(316002)(38100700002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L216WFJJU0dUUzAvRFh5M05qaGQyUnBzaitFWmNSOGN2OHIwVDUySFJDb3dy?=
 =?utf-8?B?Z2dOTWpHQTh6T09YRExjREo3clV3RjA2aW8rYllHa1dZTHB1ZnBYQTRTOHh6?=
 =?utf-8?B?YW44UWFidXdnZTd3SnFPbWZtMXZCd09Yak94NHU1bmVQYjFFUmN3dW5Da2hx?=
 =?utf-8?B?Y0Mxc3BaYjBkL0FCVGZyOWRFNG1YVGFxelNadmpmbHNnT2xFVXhLNzRUMk5z?=
 =?utf-8?B?MzU0SldLbVkreHhpald6WUZUZlRQdkczNUdHUyt2S0dRSkJsY3RDRnlmRDVJ?=
 =?utf-8?B?aVo4QUdFSkd5TGUrMmRCc1BWSlpmK2RzclJGU1lrRlJpSjkyWExuajZlTU5h?=
 =?utf-8?B?VWNWQVhDVEt2S2FVOVFzYUxsbEhwSTdkNVIwdS9EdklEemZyYVp5ejFJNTla?=
 =?utf-8?B?MGtMUEl4eVF5ckp4YWpaNnlUVnVoVDV4aTllWEJEOHVkVDdRM0lmWCtZaWRG?=
 =?utf-8?B?QnBrd3hRT2k3OEFwRkpSd2VVMXhxRVZUdXNIYWI2MlVjMFJzVWdBTGhHdXFL?=
 =?utf-8?B?ZVB5U3RFL2lkOG56SHlKYVdQZjhIQis5TitNOWduT0ZPUTVKV1dOcGkweGp4?=
 =?utf-8?B?NXE3OStzMVFaRU1TMDZRNjdwbzFqVmRGb2VOWEdSUFpoK1U2bko5YXJYZHBJ?=
 =?utf-8?B?WXBYVmNSbE1lM2pOUHp0QlhHdE85WWhhakU3dnRNaWloMCtYRmtHMmhDQzR3?=
 =?utf-8?B?RVhBclVlQzlXdHlDR3BYTmVWMjRyOG1mMXdJNFFOQVUwR3NLaUthandkcXBT?=
 =?utf-8?B?RW5uSXY3UnBSd1k2OGNKeFlWajd4VjJQamd6SzQrV1l0MGdjVnNONG04QW9q?=
 =?utf-8?B?d0RGZEFqK1NmY2h6RVhjTkdKVXB1aHpWL2JKbnY3V1BoVHRId1N6TXFpZmg3?=
 =?utf-8?B?V05tb2ZaNEJBVDFmeVQzVk9LOFdDeStWWmx2YUhuK2s3dXlvL29qNTN1Zkds?=
 =?utf-8?B?WnI2ejdZODRCQnlBcG52V2ZtL1ltV053bXlvc2pjQ1pLM3VrRk9jOWJqVHNj?=
 =?utf-8?B?N3hndG5nbEN1bXUrQVkydndEWDFWdXN5TlNTVDE5L2dLckUyRkcrS1VreENX?=
 =?utf-8?B?VWFFb01YaTd5SzA4MExoUkNCRjBIbXIxNzBPVHROdHpTTldlL2ZVQ2U5aVVm?=
 =?utf-8?B?RzBwNlVRektYMVVZVERqZ0plb3R4bGZHVHZxMlhESXRJMzhERjdnOEgwMnhT?=
 =?utf-8?B?aGFxUElBQXkwZVVzdHJlTThqOHNaeFdXWHVXNlJ3bHNnS3RSVVI0NnR1US9L?=
 =?utf-8?B?WlJQa0NraGlIRTgyQ1ZkOWUrbmJrVGMxMCthVjJqRjZZUiszY0NXZkxlOVIv?=
 =?utf-8?B?SkxSOFVrbi9TL0Z6dVVwM3RCK1BQMFV6QlVTb0tQcWNzbkpldkJwLzNrQ0tY?=
 =?utf-8?B?cjRQdjdQZDBmUVBUVXpmTnJCaHpYMUc5SzNTbkxMem5UalV5SmlQVkM0SDVS?=
 =?utf-8?B?UVg4MGhvMFdyV1NiOGVlM0hzdzFmMjNKTGRQUzNjd0tqczJIODk5S3lEZTl5?=
 =?utf-8?B?dFRqeXVHV2x2bXdMWW5sL0VWMmFWVElFR29XYUdMTjg3RmRwYktyWGM3b0ZS?=
 =?utf-8?B?QkNVR1FlVjlHSXVudFBrZm9scmJDbVRYZEFaVWxrYzh1eVN1bk9rcnBkSFR6?=
 =?utf-8?B?TlhWNGQ5c2djS0R6SC9aS0xWcXZwMlB1b0xWNEwxQmdOZWM0UWFjOXFXM1FS?=
 =?utf-8?B?ZGR6TEVML2l3QU5mcS94ZXVoQXlITzIxaDdxZVQ0K0s2a2JpQ2RPWXFyNnVw?=
 =?utf-8?B?WjlVVm1pcnBoU3Nvdjc0eGRjbStLZjZxUnI0K09WTGtrSnptK0FmVFo0NVZx?=
 =?utf-8?B?WFZIRFZkd1oxSzdYSksyZ2dsTGJJaDRmV1AyT0FVSlpha0hOU1pDSUVHaFFm?=
 =?utf-8?B?V2t6L1VEYkZSRXQ0d2NFVjVCS3V2aEUxOWlPOENvZlpZc0NXQ3NpNG5weWR6?=
 =?utf-8?B?cmJSS1RTOEVTdldZWjl3bDUyWFdMak5wQkVNeStpTE0zbFFHVzhVTkdmOWZM?=
 =?utf-8?B?VkFxZ3U5clZYV3NqOHRrb0NBWUEwUjRUUGFySXZNZ2VHS0dxc1p2eUVzT21C?=
 =?utf-8?B?aDg1Mmc2djBLaEExNmo4K3kwSXZvZlBsb2pZa2N1Tm81T3N4cDA2d0xHdVlI?=
 =?utf-8?Q?RV0u/uA3jKEv6NZAndSQM4ago?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e888fada-883e-4b67-3b61-08dad78bf81b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5346.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 13:15:39.2743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92KwIqoaXmpI6qlU5qlDndpeMOjce+M/S24Ew8wgIITatE8IoPoGZWhnWW1StNsVzlhAy3EWzPyrNoxILs/T7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7340
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/6/2022 6:26 PM, Christian König wrote:
> Am 06.12.22 um 13:54 schrieb Rijo Thomas:
>>
>> On 12/6/2022 6:11 PM, Christian König wrote:
>>> Am 06.12.22 um 13:30 schrieb Rijo Thomas:
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
>>> Maybe use some other name than dma_buffer for your structure, cause that is usually something completely different in the Linux kernel.
>>>
>> Sure Christian. I shall rename "struct dma_buffer" to "struct shm_buffer" (Shared Memory Buffer) in the file include/linux/psp-tee.h
>> The functions psp_tee_alloc_dmabuf() and psp_tee_free_dmabuf() shall be renamed to psp_tee_alloc_shmbuf() and psp_tee_free_shmbuf(), respectively.
>> I shall do correction in next patch revision. I will wait for others to review as well before I post update.
> 
> I strongly suggest to use the name psp_buffer or something similar because shm_buffer is usually used for something else as well.

I see that the TEE subsystem defines "struct tee_shm".

Okay, I will name the newly added structure as "struct psp_tee_buffer" and the APIs as psp_tee_alloc_buffer() and psp_tee_free_buffer().

Complete function prototype:

struct psp_tee_buffer *psp_tee_alloc_buffer(unsigned long size, gfp_t gfp);

void psp_tee_free_buffer(struct psp_tee_buffer *buffer);

Does this look okay?

Thanks,
Rijo

> 
> Regards,
> Christian.
> 
>>
>> Thanks,
>> Rijo
>>
>>> Regards,
>>> Christian.
>>>
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
>>>> +        kfree(dma_buf);
>>>> +        return NULL;
>>>> +    }
>>>> +
>>>> +    dma_buf->size = size;
>>>> +
>>>> +    dom = iommu_get_domain_for_dev(psp->dev);
>>>> +    if (dom)
>>>> +        dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
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
> 
