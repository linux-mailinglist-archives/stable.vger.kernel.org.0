Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837EA64438B
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiLFMzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiLFMza (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:55:30 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB772A70A;
        Tue,  6 Dec 2022 04:54:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPZ2m42TmN9j6ZKTK6idzWQd96eRZckNeOZd6yrF8m/PCTSeABwKQqUg9V2+4jDYIYQgG/qE+vC0bQaLF0xwdhH/YusIzKq3+gy9LWbHi+tvys9I9L3mPMV5PGAuc0hOuLBMqYWBKPYb/Xg/9HN9Utfugf7DC4ydbj6LE7HHAO3ZDAtNPeprin7SRpGfsk21R0D3k9NYTegXV1GSqyl1/iF7EuUDtZT5rmbzM4CkDYyb3ir4t+8O91zC9sRoUm33ADK/gcPDinhkwkNxt0OzeTqjy/jIn1wr/Xpil9sg0F9sZAAHzgslX4H8JGjcwr1p8iws9HlhX7+S9RrG8XUpeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZuPr2gPGNGv6YrTG/LAh956YDILnHMyFZGj+SBlLyc=;
 b=lFRjtIhw5q9+6MvcLx7fGjev/p+bcly7aIYa5FZVt5TMhd+DNhq3RgEcBLGp+h/6ADPYLtI8rvcbKsSG4XKRsTQDQOni/56teAMQdG4x4iolD+bObkmlNigSKrnq1fnh3YylIiRVK5B2koPiAEvPJp2FDxMk2V3MBYBM3x7F8jLjNma7K9a7Ju53m8c6WO12LJpsaXJorrZr6uJAdlvzSbUdK6+qTfeQVWilDCCWkO92KI8i/zPMEVrgADdAKB3lKO/TJmpzx1Z2HF5qmOG6KfievK49fUD/L1B3qkUDG8q5JE0XdwmG1joL3ZpHenQ3mcJinQhx67V8ifskpb54og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZuPr2gPGNGv6YrTG/LAh956YDILnHMyFZGj+SBlLyc=;
 b=tgQDXgwBWE6hxywCfhloxF2jRLpajll7JZmlFLvQzhuyPx8GxoiqIa5Hf5BOcFtsmBoDIYCKTVlrVhEq33NX7iJcjhJgdnQpXCILRHY6Aw1KQo9Ikoy9SFygO/N5sig/BKe7SoepBbOjb1cl0tUNEuQ/Xbz1Qrx7ANgHoQS4BxM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24)
 by MW3PR12MB4348.namprd12.prod.outlook.com (2603:10b6:303:5f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 12:54:55 +0000
Received: from CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4]) by CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 12:54:55 +0000
Message-ID: <f551325a-2033-bd9c-e863-a7e57993349a@amd.com>
Date:   Tue, 6 Dec 2022 18:24:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/1] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
Content-Language: en-US
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
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <78b23ccf-f50f-a793-ae6a-0a70faa2fb06@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0127.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::12) To CH0PR12MB5346.namprd12.prod.outlook.com
 (2603:10b6:610:d5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5346:EE_|MW3PR12MB4348:EE_
X-MS-Office365-Filtering-Correlation-Id: c0c63c35-0d0d-47c0-bae4-08dad78911c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZE55tCbbK1fFazUYa0YARKl/y1mp8umn4ItYUvSQIe4u9Fsb9YujDkg/+yZIFXOFVzgRmLHbnrwxa58z2QT1DW39g4qv7765WB8rCP2F/ViskMNXYNm86B2vWuTD+dH62n4/P/Fn6yxJa8Htny5/8uitElw5o8dsM2hXDwUPwvP+P21/j7xH+yYY5R3e1M85WvLGHESmy2//dQrntGjdtGNrmyL1o5Oga2o5gpb2wXgwClaXz5gGSUHedLoeD2rWo0Mg6Y6H4n4+Lb/r5QCb6sfIvl3r+iqvCU3SQt7K8kkC2vY4VDAViiH8fAqcSsOGnSur7XXtVqsQFxPrM+imOPD6YjWh8gBmRsHtyjczcjOSlAj8c4CZmQYFcOOdtkzZlzPTke9j1RUo3sJbfAJ3dNX64zrx8RXRLS21R47tmRUgrvJaVDD4WJOm+ixnS366SZK4QZsYPNWCAcLytIwuj/j4cvoAY8oFTWQeO1u4u7g2KTkeeWDRBpDN9jr6M9jm5hL2BsIqItmnQRA/tPUTTDihd8+wBisAJkyw5ONQlGf9pufECWF+/gyyN6aj0mjlzsgvEZEfy7Z3dfwzAix4E3UsHIWUiV0mvgIiixqnx+Eha+QfHDM3wxJEXvY2ICaWZnN1Mq+Nn6P530878qP4oqg2yCiodmrv52eaERbmAohBtWr/DKUjwesEEbTTlbruPQskmNxqOCqlEGMWtFUlgan+FUkHXE23xCTlWJYwjnbUGfUROfrQdBqYgcSYicWe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5346.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(66574015)(66899015)(31686004)(6506007)(31696002)(86362001)(478600001)(6486002)(53546011)(921005)(36756003)(26005)(38100700002)(83380400001)(2616005)(186003)(8676002)(30864003)(5660300002)(41300700001)(6512007)(8936002)(7416002)(4326008)(6666004)(66946007)(66476007)(66556008)(2906002)(316002)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGVOZnhxSUI0VlNiSEJjaVkrZE5BMmtuVklZUjFiby9EemUwd281RVh6ODlH?=
 =?utf-8?B?ZmZwWFBwNENYT3RhbThVOGFZbk5BRGw1Um9tUm10VnBvS3FIdFRKZktSMnZr?=
 =?utf-8?B?N3pnWDJ0ZWhnZmhGZkFMa0gzMnVaSHNkUkkxeXlxVk9PdzFzV1p0dW1iRkRT?=
 =?utf-8?B?SE04VXdZYUhod3NOdUQyblFXbzZCcm5qNWQvNG1VbE9RaDVOU2xsSFhVUlNC?=
 =?utf-8?B?c2RwQWNKZEE5b1Uyd2lDZkpWNEs0U1pIdmdGRWhxY1gzUjJHTUQ1UHloeHQ2?=
 =?utf-8?B?cklja3d2UVhkTzI0MGNQK3o5VVBLSm9PNXMwME9zM3d6cGs2Yys0UFF1YW9I?=
 =?utf-8?B?S2h0R1hFSzhDNm5UeEk1c3ZBMXBVeE03dEpmRTMvdlh3c3Z3Z290SmlOOFRx?=
 =?utf-8?B?MnlRL0F5aWRpd1diNGVMYURqNTJvdEJzTjVZUnpVSlVWTG51WnJGKzdvbjlY?=
 =?utf-8?B?UmN6bmw4Q3JITDB4T21xaW4rdUptNHhia2xrSG50eW50YzJ2VnlkbHhZc0VG?=
 =?utf-8?B?aUMzcVp2MXVoajNpYXNNTUJ3RlB6aHRRb0ZBMHNoZ0tmWDc5ZTJxaHAzV2x6?=
 =?utf-8?B?T3B6TmdSRmYrcjltcnVod3NzU2FYTEFoNnRYVEpiME1sbDRhRnVhUGR6K0ww?=
 =?utf-8?B?YUNYZVNhZGQ4bmE4ZnI1M1o1K2l5T3RadmJ4U0FhQmtnK2Q0VGpDMzdaQTZ3?=
 =?utf-8?B?R3dWTGkvbDVXcTdUQnhFT3NQRUZnSlR4bXJ3TmZaWkNSZG9WSFdzYmwzMTc2?=
 =?utf-8?B?QkV0QXQ3Z3QxVGhoSWpiTHEySmNCV3ZVWFdkcGU2RFM2TDhRcHFqeHhBNFpl?=
 =?utf-8?B?OXcvdnJKYkFvY0c0TGpNQXR0SDJkcE9XZXA4aVFYVUNkeUUvSWNsbWFqNnp2?=
 =?utf-8?B?SWRTSWFtam9xMzJTWjdnSWY3YVVMdlgzZFA0SHhDR2owRkwyQ25CNDl0SWNt?=
 =?utf-8?B?Y0RZcVd2SE1sR2RsV2RyRmpyREE4RVp2OVF3cmdOaWRwZVowN1gwWEVvQmhO?=
 =?utf-8?B?SHlwMHFJM0lmVXJtTDBYTmdIV3p4amtDZE1UUFpRbGFHVk1YVGhrc2FFSXJC?=
 =?utf-8?B?NkhZYmVWQmtjZFpQUDZnekJzaTZKNy9TM0gySkhTYXJtTDJ2aFFTZlVjUG9D?=
 =?utf-8?B?WXoyQVRSbWpac2JPNkU1Nnh3c1JvNXJFQU5kdEdpa1BxYllSOExwb093NUNC?=
 =?utf-8?B?TVd4a1I3alo3T0s5ZlBySW44UGF3dUx4bjBlUmZwZFRBSVkyZXZ4TEhWblRO?=
 =?utf-8?B?N3VtSFMyK0pIN0xJRHZhN00rU0VaeWRlQjBJOFptTEErWEdFQVBQSFliV2Z5?=
 =?utf-8?B?Um5VaGVQTlg0OURmZkxDTWd6aWd3MEsrUDBHKzBhOFMrOWRzdDlWUG9OdGpT?=
 =?utf-8?B?ZkVQSEhRY0JHTmNMWnRybmM4YjR4ZGl6V1g5Sko2TUkzTDQ4NjE3MXRXTzQw?=
 =?utf-8?B?ZlZyWHIyZE5RcEdHSkFmVVo3VzhEVHlGZUtZMFJMYXY2U2JMS1FUYWxpNUtE?=
 =?utf-8?B?cjRtdVhlVW0rcEdtMVVkS0ViUzRUWWtULzNqcXVEM0h5bUNIZ1V6TG1ZamZY?=
 =?utf-8?B?RlZoSFM1aDl5NHpVT1Z1OXJoeUptRFZjbG93Uis4V1ZiZFB5WFRSQ2FoT3hG?=
 =?utf-8?B?bkNKMTFTK0EySFNCWVNUMWdJRzBoVnEvb21ncTJRL3pZRXBaY3FTWU9BT2pr?=
 =?utf-8?B?Z2Z2U3FGdCtzRkwvMk94ejhhbU15aVZnV2FQQStxTng2L1hWQzJuTXdLU0hz?=
 =?utf-8?B?QU5VVGM3QmQ1VFFVcWNEZ0lmck5QUjY3N3VTdlIvOW1QMk1oenpRc2FYakFZ?=
 =?utf-8?B?blRWeDd5UEV5VWJzUnhMQVZtaERKT0V3WXFseXVTRS9XVjhYTVJHeXJDQnpo?=
 =?utf-8?B?UU5NNmNVdnRCWDAxckFsN1RKRmFwUnBJakIrc29uTlNSWU5uUVZ3d3FpaHQv?=
 =?utf-8?B?UzZlelU4enBDcXU2bTF0NWVXM1VDUFp2MnA4dnhqdHhkR3k2anEvakRoZFhU?=
 =?utf-8?B?VUFOSG9GZC9Hd0FkczZsWEsxVlFLMjlkcmpEckpQTUdqT013eUhMNkR2Zklp?=
 =?utf-8?B?Sm9xSmRGZnNDT1hNRko0TytrTGFBZ1Evc1V0N0NSUDVQWlpqRWFpQXZIeWxF?=
 =?utf-8?Q?LiASBPJ2ITStaY7o8Fkku5dLX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c63c35-0d0d-47c0-bae4-08dad78911c5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5346.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 12:54:55.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AurzElwom0ccfQtxU2KP+669NL14sQPtUoZkAx5QRH/OiRs61cLFR04kS/ndBYKezNzetQ9BMfmTvH+8FusyJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4348
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/6/2022 6:11 PM, Christian König wrote:
> Am 06.12.22 um 13:30 schrieb Rijo Thomas:
>> For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
>> ring buffer address sent by host to ASP must be a real physical
>> address and the pages must be physically contiguous.
>>
>> In a virtualized environment though, when the driver is running in a
>> guest VM, the pages allocated by __get_free_pages() may not be
>> contiguous in the host (or machine) physical address space. Guests
>> will see a guest (or pseudo) physical address and not the actual host
>> (or machine) physical address. The TEE running on ASP cannot decipher
>> pseudo physical addresses. It needs host or machine physical address.
>>
>> To resolve this problem, use DMA APIs for allocating buffers that must
>> be shared with TEE. This will ensure that the pages are contiguous in
>> host (or machine) address space. If the DMA handle is an IOVA,
>> translate it into a physical address before sending it to ASP.
>>
>> This patch also exports two APIs (one for buffer allocation and
>> another to free the buffer). This API can be used by AMD-TEE driver to
>> share buffers with TEE.
> 
> Maybe use some other name than dma_buffer for your structure, cause that is usually something completely different in the Linux kernel.
> 

Sure Christian. I shall rename "struct dma_buffer" to "struct shm_buffer" (Shared Memory Buffer) in the file include/linux/psp-tee.h
The functions psp_tee_alloc_dmabuf() and psp_tee_free_dmabuf() shall be renamed to psp_tee_alloc_shmbuf() and psp_tee_free_shmbuf(), respectively.
I shall do correction in next patch revision. I will wait for others to review as well before I post update.

Thanks,
Rijo

> Regards,
> Christian.
> 
>>
>> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
>> Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>> Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>> Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>> ---
>>   drivers/crypto/ccp/psp-dev.c |   6 +-
>>   drivers/crypto/ccp/tee-dev.c | 116 ++++++++++++++++++++++-------------
>>   drivers/crypto/ccp/tee-dev.h |   9 +--
>>   include/linux/psp-tee.h      |  47 ++++++++++++++
>>   4 files changed, 127 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>> index c9c741ac8442..2b86158d7435 100644
>> --- a/drivers/crypto/ccp/psp-dev.c
>> +++ b/drivers/crypto/ccp/psp-dev.c
>> @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
>>           goto e_err;
>>       }
>>   +    if (sp->set_psp_master_device)
>> +        sp->set_psp_master_device(sp);
>> +
>>       ret = psp_init(psp);
>>       if (ret)
>>           goto e_irq;
>>   -    if (sp->set_psp_master_device)
>> -        sp->set_psp_master_device(sp);
>> -
>>       /* Enable interrupt */
>>       iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
>>   diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>> index 5c9d47f3be37..1631d9851e54 100644
>> --- a/drivers/crypto/ccp/tee-dev.c
>> +++ b/drivers/crypto/ccp/tee-dev.c
>> @@ -12,8 +12,9 @@
>>   #include <linux/mutex.h>
>>   #include <linux/delay.h>
>>   #include <linux/slab.h>
>> +#include <linux/dma-direct.h>
>> +#include <linux/iommu.h>
>>   #include <linux/gfp.h>
>> -#include <linux/psp-sev.h>
>>   #include <linux/psp-tee.h>
>>     #include "psp-dev.h"
>> @@ -21,25 +22,64 @@
>>     static bool psp_dead;
>>   +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>> +{
>> +    struct psp_device *psp = psp_get_master_device();
>> +    struct dma_buffer *dma_buf;
>> +    struct iommu_domain *dom;
>> +
>> +    if (!psp || !size)
>> +        return NULL;
>> +
>> +    dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
>> +    if (!dma_buf)
>> +        return NULL;
>> +
>> +    dma_buf->vaddr = dma_alloc_coherent(psp->dev, size, &dma_buf->dma, gfp);
>> +    if (!dma_buf->vaddr || !dma_buf->dma) {
>> +        kfree(dma_buf);
>> +        return NULL;
>> +    }
>> +
>> +    dma_buf->size = size;
>> +
>> +    dom = iommu_get_domain_for_dev(psp->dev);
>> +    if (dom)
>> +        dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
>> +    else
>> +        dma_buf->paddr = dma_buf->dma;
>> +
>> +    return dma_buf;
>> +}
>> +EXPORT_SYMBOL(psp_tee_alloc_dmabuf);
>> +
>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buf)
>> +{
>> +    struct psp_device *psp = psp_get_master_device();
>> +
>> +    if (!psp || !dma_buf)
>> +        return;
>> +
>> +    dma_free_coherent(psp->dev, dma_buf->size,
>> +              dma_buf->vaddr, dma_buf->dma);
>> +
>> +    kfree(dma_buf);
>> +}
>> +EXPORT_SYMBOL(psp_tee_free_dmabuf);
>> +
>>   static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
>>   {
>>       struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>> -    void *start_addr;
>>         if (!ring_size)
>>           return -EINVAL;
>>   -    /* We need actual physical address instead of DMA address, since
>> -     * Trusted OS running on AMD Secure Processor will map this region
>> -     */
>> -    start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
>> -    if (!start_addr)
>> +    rb_mgr->ring_buf = psp_tee_alloc_dmabuf(ring_size,
>> +                        GFP_KERNEL | __GFP_ZERO);
>> +    if (!rb_mgr->ring_buf) {
>> +        dev_err(tee->dev, "ring allocation failed\n");
>>           return -ENOMEM;
>> -
>> -    memset(start_addr, 0x0, ring_size);
>> -    rb_mgr->ring_start = start_addr;
>> -    rb_mgr->ring_size = ring_size;
>> -    rb_mgr->ring_pa = __psp_pa(start_addr);
>> +    }
>>       mutex_init(&rb_mgr->mutex);
>>         return 0;
>> @@ -49,15 +89,8 @@ static void tee_free_ring(struct psp_tee_device *tee)
>>   {
>>       struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>>   -    if (!rb_mgr->ring_start)
>> -        return;
>> +    psp_tee_free_dmabuf(rb_mgr->ring_buf);
>>   -    free_pages((unsigned long)rb_mgr->ring_start,
>> -           get_order(rb_mgr->ring_size));
>> -
>> -    rb_mgr->ring_start = NULL;
>> -    rb_mgr->ring_size = 0;
>> -    rb_mgr->ring_pa = 0;
>>       mutex_destroy(&rb_mgr->mutex);
>>   }
>>   @@ -81,35 +114,36 @@ static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
>>       return -ETIMEDOUT;
>>   }
>>   -static
>> -struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>> +struct dma_buffer *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>>   {
>>       struct tee_init_ring_cmd *cmd;
>> +    struct dma_buffer *cmd_buffer;
>>   -    cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>> -    if (!cmd)
>> +    cmd_buffer = psp_tee_alloc_dmabuf(sizeof(*cmd),
>> +                      GFP_KERNEL | __GFP_ZERO);
>> +    if (!cmd_buffer)
>>           return NULL;
>>   -    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_pa);
>> -    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_pa);
>> -    cmd->size = tee->rb_mgr.ring_size;
>> +    cmd = (struct tee_init_ring_cmd *)cmd_buffer->vaddr;
>> +    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_buf->paddr);
>> +    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_buf->paddr);
>> +    cmd->size = tee->rb_mgr.ring_buf->size;
>>         dev_dbg(tee->dev, "tee: ring address: high = 0x%x low = 0x%x size = %u\n",
>>           cmd->hi_addr, cmd->low_addr, cmd->size);
>>   -    return cmd;
>> +    return cmd_buffer;
>>   }
>>   -static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
>> +static inline void tee_free_cmd_buffer(struct dma_buffer *cmd_buffer)
>>   {
>> -    kfree(cmd);
>> +    psp_tee_free_dmabuf(cmd_buffer);
>>   }
>>     static int tee_init_ring(struct psp_tee_device *tee)
>>   {
>>       int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>> -    struct tee_init_ring_cmd *cmd;
>> -    phys_addr_t cmd_buffer;
>> +    struct dma_buffer *cmd_buffer;
>>       unsigned int reg;
>>       int ret;
>>   @@ -123,21 +157,19 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>         tee->rb_mgr.wptr = 0;
>>   -    cmd = tee_alloc_cmd_buffer(tee);
>> -    if (!cmd) {
>> +    cmd_buffer = tee_alloc_cmd_buffer(tee);
>> +    if (!cmd_buffer) {
>>           tee_free_ring(tee);
>>           return -ENOMEM;
>>       }
>>   -    cmd_buffer = __psp_pa((void *)cmd);
>> -
>>       /* Send command buffer details to Trusted OS by writing to
>>        * CPU-PSP message registers
>>        */
>>   -    iowrite32(lower_32_bits(cmd_buffer),
>> +    iowrite32(lower_32_bits(cmd_buffer->paddr),
>>             tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
>> -    iowrite32(upper_32_bits(cmd_buffer),
>> +    iowrite32(upper_32_bits(cmd_buffer->paddr),
>>             tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
>>       iowrite32(TEE_RING_INIT_CMD,
>>             tee->io_regs + tee->vdata->cmdresp_reg);
>> @@ -157,7 +189,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>       }
>>     free_buf:
>> -    tee_free_cmd_buffer(cmd);
>> +    tee_free_cmd_buffer(cmd_buffer);
>>         return ret;
>>   }
>> @@ -167,7 +199,7 @@ static void tee_destroy_ring(struct psp_tee_device *tee)
>>       unsigned int reg;
>>       int ret;
>>   -    if (!tee->rb_mgr.ring_start)
>> +    if (!tee->rb_mgr.ring_buf->vaddr)
>>           return;
>>         if (psp_dead)
>> @@ -256,7 +288,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>       do {
>>           /* Get pointer to ring buffer command entry */
>>           cmd = (struct tee_ring_cmd *)
>> -            (tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
>> +            (tee->rb_mgr.ring_buf->vaddr + tee->rb_mgr.wptr);
>>             rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
>>   @@ -305,7 +337,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>         /* Update local copy of write pointer */
>>       tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
>> -    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
>> +    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_buf->size)
>>           tee->rb_mgr.wptr = 0;
>>         /* Trigger interrupt to Trusted OS */
>> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
>> index 49d26158b71e..9238487ee8bf 100644
>> --- a/drivers/crypto/ccp/tee-dev.h
>> +++ b/drivers/crypto/ccp/tee-dev.h
>> @@ -16,6 +16,7 @@
>>     #include <linux/device.h>
>>   #include <linux/mutex.h>
>> +#include <linux/psp-tee.h>
>>     #define TEE_DEFAULT_TIMEOUT        10
>>   #define MAX_BUFFER_SIZE            988
>> @@ -48,17 +49,13 @@ struct tee_init_ring_cmd {
>>     /**
>>    * struct ring_buf_manager - Helper structure to manage ring buffer.
>> - * @ring_start:  starting address of ring buffer
>> - * @ring_size:   size of ring buffer in bytes
>> - * @ring_pa:     physical address of ring buffer
>>    * @wptr:        index to the last written entry in ring buffer
>> + * @ring_buf:    ring buffer allocated using DMA api
>>    */
>>   struct ring_buf_manager {
>>       struct mutex mutex;    /* synchronizes access to ring buffer */
>> -    void *ring_start;
>> -    u32 ring_size;
>> -    phys_addr_t ring_pa;
>>       u32 wptr;
>> +    struct dma_buffer *ring_buf;
>>   };
>>     struct psp_tee_device {
>> diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
>> index cb0c95d6d76b..c0fa922f24d4 100644
>> --- a/include/linux/psp-tee.h
>> +++ b/include/linux/psp-tee.h
>> @@ -13,6 +13,7 @@
>>     #include <linux/types.h>
>>   #include <linux/errno.h>
>> +#include <linux/dma-mapping.h>
>>     /* This file defines the Trusted Execution Environment (TEE) interface commands
>>    * and the API exported by AMD Secure Processor driver to communicate with
>> @@ -40,6 +41,20 @@ enum tee_cmd_id {
>>       TEE_CMD_ID_UNMAP_SHARED_MEM,
>>   };
>>   +/**
>> + * struct dma_buffer - Structure for a DMA buffer.
>> + * @dma:    DMA buffer address
>> + * @paddr:  Physical address of DMA buffer
>> + * @vaddr:  CPU virtual address of DMA buffer
>> + * @size:   Size of DMA buffer in bytes
>> + */
>> +struct dma_buffer {
>> +    dma_addr_t dma;
>> +    phys_addr_t paddr;
>> +    void *vaddr;
>> +    unsigned long size;
>> +};
>> +
>>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>   /**
>>    * psp_tee_process_cmd() - Process command in Trusted Execution Environment
>> @@ -75,6 +90,28 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
>>    */
>>   int psp_check_tee_status(void);
>>   +/**
>> + * psp_tee_alloc_dmabuf() - Allocates memory of requested size and flags using
>> + * dma_alloc_coherent() API.
>> + *
>> + * This function can be used to allocate a shared memory region between the
>> + * host and PSP TEE.
>> + *
>> + * Returns:
>> + * non-NULL   a valid pointer to struct dma_buffer
>> + * NULL       on failure
>> + */
>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp);
>> +
>> +/**
>> + * psp_tee_free_dmabuf() - Deallocates memory using dma_free_coherent() API.
>> + *
>> + * This function can be used to release shared memory region between host
>> + * and PSP TEE.
>> + *
>> + */
>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer);
>> +
>>   #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>     static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
>> @@ -87,5 +124,15 @@ static inline int psp_check_tee_status(void)
>>   {
>>       return -ENODEV;
>>   }
>> +
>> +static inline
>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>> +{
>> +    return NULL;
>> +}
>> +
>> +static inline void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer)
>> +{
>> +}
>>   #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>>   #endif /* __PSP_TEE_H_ */
> 
