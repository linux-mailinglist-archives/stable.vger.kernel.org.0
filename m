Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A69649D78
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiLLLWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiLLLWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:22:19 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2076.outbound.protection.outlook.com [40.107.100.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFDA102;
        Mon, 12 Dec 2022 03:21:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3pHvjodsjPujJfNWJW3UYus01Iu7dYXcEEGCz7Jjnlv5ra/iNOY6WtwQEPQu3ztHx4KuHdg+prjpQ1wRF/nYijBKQUxKaMQNoh54CoNeQi+dco1e3HcAUkEtG+7fHCYvZzzGK0uGM4R6aIe2MbqtHqh4VceTDWdGKM1Zl6TxQVFoAhkxdn/HyB/7TyLE57ZtG7KRjDtKSIS9w5rBf9ZW6FXz2rXIVRdyaprE/1dNDOfMuqDfeO6s7OSFywHfuVxbFNIOvoDBa9hKdCTb49077GfI6+PdyQw2gomZxpbYCJ+qSKFu5vGhlyKyrG6V5/mou1ycyw+QzFeRNAE+OFYyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1NRni8fjMTtrbcRkFk+tcktEpeK0X9dhgSbuyFGbPA=;
 b=hcYsXETpaV756tlT7befECYAf0rR3hvdWL1XExUE6m7oKH10rMfXSaRNmatxWL5edix798r4fln1YGP9wTxR9IlhMAJuCG4voolg5WelPGLROFX0f3O1W0FXDUokcoA1GRCzQC3H/ukrfp/67WitlGzBnSAX6iDjyOmxsPtZI1hQ3IoPadwz/inE2nZ0F+IKLCFn/Ip6H40Gmg3ujsrWpM+pu5r9GPyON1nNBYtjXou5e2fYDW0CkGiA5ySylSNVDq0uQZj1nYiluLen4cuTP78RtYL+v3HR21kCHx2pH7SQc/dxmrZM6Fqfk4tcLCOYtoklWSQp0l9jdBWfv3gmaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1NRni8fjMTtrbcRkFk+tcktEpeK0X9dhgSbuyFGbPA=;
 b=AS4Zw8g4/6BXA1Ikc2KSVGrJ2YvDgmsPhz3CeyRBtzv8YRGfAjbS76fqAjTVRQ0Q6UZawYVUA5f7dzZVjRboWkQ4leEu5U67x8ARmvrlIuuUqYcMvbBV64PbgGN3bzTJZhlQIjVvAUwEd51tDTw+AQ58iDhCpALdgIJKdfUMlmQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 11:21:31 +0000
Received: from CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4]) by CH0PR12MB5346.namprd12.prod.outlook.com
 ([fe80::64c4:4997:5e9d:2cd4%6]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 11:21:31 +0000
Message-ID: <aec3a8a8-e64e-c53a-a7fd-825d3ac4001e@amd.com>
Date:   Mon, 12 Dec 2022 16:51:18 +0530
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
Content-Language: en-US
From:   Rijo Thomas <Rijo-john.Thomas@amd.com>
In-Reply-To: <7d4bca0d-2b31-26d5-26cd-655fd2b82107@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0137.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::22) To CH0PR12MB5346.namprd12.prod.outlook.com
 (2603:10b6:610:d5::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5346:EE_|BL1PR12MB5256:EE_
X-MS-Office365-Filtering-Correlation-Id: a63fb856-9f37-4cee-08d3-08dadc3304e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z2OHiVemcAPRTsYoIGiixQ6A2zsG2eVxGHvKNrfayG04pLsdfuU+PvUIKTz3vzjzTfDvg4BmPg98krDVcejGMQrN395FpXp3v6rU0v22ryu09nlK5wh3jt7RgJqIryFmG44TC4cNpC0XqDxjIpaFUuyYMsnEH6yMFFP0vA9FK0KW3O8AzH+gsemjpCgudddwKGXrUEf6A0klJtoHy/9zmaflwunritfP7iFIbX4IWmgFGAA8ToYTbYisvRmhKT5Mg+9E5QfwoFTD09oDh2JmP+AHF8Ak30VdWnF2u1pI5yBp4qcfyVM+EBYTHd9V9xL9C/ADxKO3pmutqO54OiBkoZVh4MNw13hptwaKvJhYWg88W44hcsPLBeGc8A2Opz+SfOY73nXyKVtClG37X1bVOyGNYbiLgocsOd0XAj33K4H17fKO+s9iWT8F9mneTUaGcBSd0Ja98t0PRhCXTlbvgTLlJtHfTRKBSf3Y3Ng043IFmt0mB9eRPOAiQqabw+gXGI0QnCqalmb5ruJ5vBsv2axjTqZ/UOtY7DLIZFopCSHZ+QkNV55G7J1F8QeQ/wlb5mm1Hb/632xBellERDWbE5RPqCsuGyNuUdCgnCIViGox004qYRoOeGiaYnKgZoFK+5pwR7aeDxFOlFC/+m9RLlfxRiIbFHcF08/SO+BWxAuI+NFcd6hevQpskcnOIHRCeraCx0GNBA6IDgv/4Hrp0n4EqXAzLbBGVBhqLa/CIgfm+K6f4AhG7k2JMAevx9sw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5346.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199015)(54906003)(110136005)(316002)(2906002)(921005)(6486002)(6666004)(83380400001)(36756003)(478600001)(6506007)(31696002)(86362001)(2616005)(186003)(53546011)(6512007)(26005)(66899015)(66946007)(38100700002)(8936002)(31686004)(41300700001)(30864003)(66556008)(8676002)(7416002)(66476007)(4326008)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWV2bG5aSHY5MUxZYjRUZGp3anZQMlp5UjZRMkh3R0RGbHYycWJBdEtkQmVE?=
 =?utf-8?B?WUxudmJEL3NvWDRpRnNzZlRiS2ZtckxOSHlobFlXa3lDZ2l0NmhVVHlsdkpT?=
 =?utf-8?B?SElMbUE0QkE0WUgvQ0FvWnc2WStRaEZ5ZUlCSUdjaDhndzNkcEsrY3JOUnZK?=
 =?utf-8?B?emVLU0NacjFpU0tMbE1IVjR3bytMQ3hiV0lWdm51eU5yNmNZK1ZpU1VvRkVK?=
 =?utf-8?B?S0l1d29nL1c5aERpeFNDV2ZodkNXd1ZhRVVQUVZVQ05zWnJNR0FqckUxVjFk?=
 =?utf-8?B?MSsrc2ZzSGM0NWd4UHlHcktTTERlTVZ5cU5EVjlNYlRTQWYrNThyWXRpNnAy?=
 =?utf-8?B?RkVRNmVyeXUramtvODZiaXM4TG9JK2c1U1FkNjN0ZlZHSHB5TlVjV2xaTnUv?=
 =?utf-8?B?SkV4NGVrM1o1ZDRGeU96YS9haDJRSi9yem42Rlp3ODRHcm5mOGFrMGw2UnFO?=
 =?utf-8?B?WGR4azJKeENScjhaSTNYVmdQaWJnZnVZeW5QZHg3N0MrMkFxK0FzS3l4TjM2?=
 =?utf-8?B?UXVGeStMTzJQNVBkRlkvaXBobi9oclZjbjJGRWtDbDNEd21Ia29KUEVSY0RK?=
 =?utf-8?B?V1ZneWhnbnJyMnB6SnoranB0dmViNGRIUytBNlAyRmpZTmg4d1pyUkNIbldK?=
 =?utf-8?B?T2huR2NpNnJyd3pvYTdNdHk3ZjlUTWt5Wk4wbDY1YmtwYm1TRDZUVUpyQjRO?=
 =?utf-8?B?V05MKyt5TlJ3cWMrTzExbXlqZGdNbktYYkQ1am95cFFQRVlONTRYWWJiRGtI?=
 =?utf-8?B?OUhseU53ZHgySUN3TFFFQUJPSXhxbmlzZGM3RjhoNWpUa25pY25odUtKOTMr?=
 =?utf-8?B?MU1mVGxoUVhWYjEwMVUvK1hXKzdUTnhiOWsrZ0R5cFBIOEdtRlpCeVlseU16?=
 =?utf-8?B?Mk8zSGN5bXZ2aTR2NHRmbjhsN2trcW1kaGZPTGw5cTFJR3VrZWNHVThXWnRv?=
 =?utf-8?B?T05TWE4rTXJsTlQwWmRob2M2a0ZWaFc1WndiQ1F1VThtdG96Qkx1UlJ2UlVh?=
 =?utf-8?B?TlZuU3FJZ2MyNTgya3BhMk83UHg5TXB1bFZWSVBNa2xMaEpoYitoREMwWkpj?=
 =?utf-8?B?elhyVjFaUTc0Wi9VRnYvR0NKQ1VTdDdnYk1nRURTSGJhTTlzbjFwbVgxSDlo?=
 =?utf-8?B?aWNJMzFpL21ZL2VFbWdGSEZZQkhQazd5RlFRZ2JGaUlvc1NaNitQOWpBdUJ1?=
 =?utf-8?B?VEFGUUc5UzJhWjN4TjJJNHpuT0YwMUdrMUdVV241cmlVaUhtbmtsQVAydWdr?=
 =?utf-8?B?OE9RV1lVQjJuTjQ5ZDdlMzZBZEg1bVdXVkFXNHdBSlBjNEhVc3R6VFdDV1A1?=
 =?utf-8?B?MEFlL3RTZnhoSjRNeWhmOUI3QWlWY3dHOHNqTWZTa0JVd0VhR3VsY3Z0djVP?=
 =?utf-8?B?L3FFYjcyMy82b0psQ1NhaDhPZyswYmVCd3J4WWk4citYb1AzTlUzRnZSNUFW?=
 =?utf-8?B?a1NJOEFhZWhDYklyOFZiU3dzRFJZSXdtRzlOMWtoRVV0MGxuR2pDQ3hFWDkx?=
 =?utf-8?B?cEtYL05qZWJCdlZPVHhUOTdjQjVMT0NXZnpYSitNRitpTnN0Yy9VcDE0RmNM?=
 =?utf-8?B?ZDRuL1UrcFpqQmo2YmVkZE9yNW9IdWZXdVNrVFJRSXRDWnZwWTltRzdBL2tR?=
 =?utf-8?B?U2dVc1FnYlhvUmJUMU42aExBSkZLNDA5VllUdE1EdS8yeDdoYzg2NHFraTV4?=
 =?utf-8?B?Ni9ScFI1eC9udzNIRHpFZmhDbDNTRm9NTWJaamdybkZnV2QvNU5HTldDUXNh?=
 =?utf-8?B?SHlSTWFzSFNvdFRLYWRNc01NSTJCWGh6d0RhTS9ZWkZMd1JBQzBBcVh1aDJv?=
 =?utf-8?B?RUxiWC9mS1BZdDdneXNLQk83amQvUDN1MEN6a3NtaEZ5dW91QkxTa0VOb1lR?=
 =?utf-8?B?TXhxZDdhN2E0V2M1Q2ROajRQRU5mQk9mLzZiOUlhOTd4NzNMSVArN1paNU03?=
 =?utf-8?B?eC8xMG4xcmJPYlFLY1hldm9lTHRHb3hPSlhobUkwS2FOUWprNElIV2FLaVZC?=
 =?utf-8?B?bWlBdG9mVWRpUnNIRWpqbnpDZjlDM0dnaStoZVNFTmhzc0kyTExLYUlNYTNi?=
 =?utf-8?B?andTclRsbDIwc1licTRMcEp4VHFZQ3lhOEV1bk0vQnhGL09oRUpTMnRFam1R?=
 =?utf-8?Q?OuYet3+HJ/5MIqiNRm5Mnicl4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a63fb856-9f37-4cee-08d3-08dadc3304e8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5346.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 11:21:31.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKJZ4NqQ7en7A716qqVE9JlR0JKlrIWa7zR3qAqsg63FJi/KQOzDuKXHECmLhLZlss6bJ9h3sp1dedwncx3rfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/10/2022 2:31 AM, Tom Lendacky wrote:
> On 12/6/22 06:30, Rijo Thomas wrote:
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
> 
> This worries me a bit...  if psp_init() fails, it may still be referenced as the master device. What's the reason for moving it?

Hmm. Okay, I see your point.

In psp_tee_alloc_dmabuf(), we call psp_get_master_device(). Without above change, psp_get_master_device() returns NULL.

I think in psp_dev_init(), we can add below error handling:

ret = psp_init(psp);
        if (ret)
                goto e_init;
     ...

e_init:
    if (sp->clear_psp_master_device)
        sp->clear_psp_master_device(sp);

Will this help address your concern?

> 
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
> 
> It looks like both calls to this use the same gfp_t values, you can probably eliminate from the call and just specify them in here.
> 

Okay, I will remove gfp_t flag from the function argument.

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
> 
> I don't think you can have one of these be NULL without both being NULL, but I guess it doesn't hurt to check.
> 

Okay, we will keep both checks for now.

>> +        kfree(dma_buf);
>> +        return NULL;
>> +    }
>> +
>> +    dma_buf->size = size;
>> + > +    dom = iommu_get_domain_for_dev(psp->dev);
>> +    if (dom)
> 
> You need a nice comment above this all explaining that. I guess you're using the presence of a domain to determine whether you're running on bare-metal vs within a hypervisor? I'm not sure what will happen if the guest ever gets an emulated IOMMU...

Sure we will add a comment.

We are not trying to determive bare-metal vs hypervisor here, but determine whether DMA handle returned by dma_alloc_coherent() is an IOVA or not.
If the address is an IOVA, we convert IOVA to physical address using iommu_iova_to_phys(). This was our intention.

> 
>> +        dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
> 
> If you're just looking to get the physical address, why not just to an __pa(dma_buf->vaddr)?
> 
> Also, paddr might not be the best name, since it isn't always a physical address, but I can't really think of something right now.
> 

We can use __pa(dma_buf->vaddr) only on bare-metal. In hypervisor, __pa(dma_buf->vaddr) gives pseudo-physical address; pseudo-physical address cannot be understood by ASP.
ASP needs real physical address (aka machine address). Please see commit message.

We chose the name paddr, since it's a (real) physical address that we want to send across to ASP. I am not sure, why you say - it isn't always a physical address.

Thanks,
Rijo

> Thanks,
> Tom
> 
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
