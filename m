Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6046443B5
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiLFM5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiLFM5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:57:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D3926ADF;
        Tue,  6 Dec 2022 04:57:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsfGIsOPLYmxfk7RdwvCwuhHkEgQlGaVRDm2ZdbBevbziC+/Npf+suS2ok9a22NjUVFyI5BJCmPkac4UXzbdr19QTwNw/7GkyrL66I4QPB14KnCE0vDLKzzrHSNWDNad3eyru1FiSrHvGJl7M9ey+6lYtxGxCX1jLusUEo7RW6iT954o+B48buT3CM3QV6DAN2qL+SxbVCFcXU8fL+nbx2yKYGyC3LkrF5gtfoelUIGvDPR1GVDmE+V+nfqP+Wp5XuZxcmE2K7JIcwcdqj91bBEEMwx3TQG60nBq0K3vs8sqYBh9UoHAOx+DyMkjG/ABYnV/WwsMjbUa5dcBKangLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdD27WltWuPzxOXRe/Uzi6tdxbzvw2B1YHATQ2ie7nk=;
 b=VvY1qQGJdi6+3jjKUqaeEx0PpgDbikXVq/tLQgSbztf8JTfziQhLHJ722mEO+EFB2SaF2XBRej+kI1rXTsquBKZlFV+9uiDSAUFCIRKG42xSMUQ3SudEE1z3+ncBttGd85OViiF8ICZnrJ96WV67m5M4up5vHEMlxE0USB1tUU+1J7ldjfY5je3sSsi5lou8FuhSNqXz66dGgoCOO4GTd+Qx4L7Kgw8Spnlp/fskSPEFghixTnxLuRLdkau5Ba+i6eVBRBjz+jNmbFgyHATcD92rxkxCp48opZBC48IB+chyLQakrIrkl837Wa/1QIFl/xW4RyqDOAEQzOJ4FbVTcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdD27WltWuPzxOXRe/Uzi6tdxbzvw2B1YHATQ2ie7nk=;
 b=XWB0FH30rzgXad4PbKJ8asxT7AL7mGdqGCYWcFb7Wmpk3ZNpYth6L8OC4GUi9f9BwOvQ27dqX93WBbPvNE2+z0RnZo5k+lUskV0W79y1H03FrUzQ/XMWVfFLydK+SXVtFTqXBoz0WHg0FQUgV9PxqHJ47JU3R4WSDzquK1obuZ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by SJ0PR12MB8139.namprd12.prod.outlook.com (2603:10b6:a03:4e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 12:56:58 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 12:56:58 +0000
Message-ID: <56917e3c-45c1-1930-9f55-22fdd536c16c@amd.com>
Date:   Tue, 6 Dec 2022 13:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/1] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
Content-Language: en-US
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
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
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <f551325a-2033-bd9c-e863-a7e57993349a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0085.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::9) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|SJ0PR12MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: b29fc1d1-548c-4e9b-7e57-08dad7895c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wOoUgi7mTGxYh5xhg/Y2bxiq1H8q68ixBRBMG+6eVAWw40aWR+YbjmEijfr0UPNPymnCpg0q4M9s1kvLM7FLaA+2yP0sZUi3ir/TGxnYpv/QD1RadnvS1x6743lT4RQ3tRLknjKumThvB24Xox/Dux47dfgDzMO5jGsMveKNVT4U1okcjlLsfHGlg460PF6bDgAeX0vkcB/TShcmThA2j28R/Bqwg+OQnMU4xGgcvpo3WXix1Fog3WNsM0+GkTEyF6Y/9idLSx6DXF6bH3RyRy5GiTT4n7L/fGgKJSlZ67CfwwK3PeNCBdZVGI+LKmjIedhILmoocJVMLh1F4gS/LgdwjcS5UC9G1vy2lfLg7ZWpfFtLrfCmd7VcalHQ1Dx9UFc/6+iLaoR+6TkuI/jtoqTgsCfqfDwP+OEY96OUuy9y1sNf7CviMe9z01umgjZ9qzMIeLAQp7EYMIauOrvbo5fSUUBsOeDoKw+3TFDi/KNmNUS6grzGPv76Z84HrIW1KyPisoi9CmN9oAmH2ooC1nuDLUU+xcjQqOQHg+Fmuk03+LTf7WBspWeZoagSLLoruO84OL2ZKf0lgO7/bDrBboaMs713QkQ25MU9Hh6VfTed5CiPEkQrdH4PPtqHi2PkKnVu01+CTsfbgU/VFm7Blj0dt2c5HZ2H0kPWBvSXuteCagi2/KVzv/hR1swqGbjnpy+rTQRrBnywSjfYckZwSrVsfEO3FlRyS5fAOVqAlJjDOGrj/JWMnBxiXGwS6yxv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199015)(2906002)(83380400001)(66899015)(31686004)(36756003)(66946007)(41300700001)(186003)(31696002)(86362001)(66556008)(38100700002)(110136005)(6512007)(7416002)(2616005)(4326008)(8936002)(66476007)(30864003)(66574015)(8676002)(921005)(478600001)(316002)(6666004)(54906003)(6486002)(6506007)(5660300002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akNyMTV1aHMyeFVnODlMYXcvZm9aR3U4R01TUjJ3NmNaTTFaTnhlV3lvbHhR?=
 =?utf-8?B?VGUyYjdSbkovaTFjTVBka2xWR0Rvc2lKRlFWL0ZXL2NJQTN0bDdyQ3BPaUho?=
 =?utf-8?B?M3RZaWNvMXdES3JqdjFrMG9vdlJrc2ZZaW5XN045UUdwZWVDdHpuSEhpdjBR?=
 =?utf-8?B?UnU0MUYwTTl5STNFMzBGZkJNNjlRbGVxaklxZWg2c3JTelN3emx6ZW56VThl?=
 =?utf-8?B?MTZHN1NzMHRCR3V1akxRQktXUXFpTEpXVm5uYlEvVXUzaFJwUkt5OWQ3QXhK?=
 =?utf-8?B?NnpMbzdwTTdQK0lGdU0rUlBDYnZucGQwemU4SFBzMHNIbFpMb21Icks4Q0t5?=
 =?utf-8?B?czl1ZnRRa2NUdVpuYUE4MDFnK2xkTWVySXRwejVxK2JRM1huSUdwU05idkll?=
 =?utf-8?B?R3VqS003cE1KUmNWQmVuY1BCSmtHSGxXeituR2o5QkFCOC9XZ2QxQXoxTlF0?=
 =?utf-8?B?OVkvdXhMQ3pKSjIvSXdXSzVYQTRMMCt0eTBQaW1ockhqU1N0WDBDU05vVnhT?=
 =?utf-8?B?VkhMQzF6eVVtb1YxQjN2SDNVZlhOcWZrNEJ5Z3kxVjQ5dllYeDhXZy82NWxZ?=
 =?utf-8?B?OVBEM25VREV1N0U2OFUzYi82UXNzSDNmSmY5bDlWc2IvbGwreVhBeEUxOVZU?=
 =?utf-8?B?M1VMMEtMRExEcGdmb1dyOUMwZHQ3Yis2UG9FVFhPbGtheDJrZXgxbEE5NUxR?=
 =?utf-8?B?dWJCTGhwaERPd1lwNnZYcFNUSCsrd0dWS3lRVk1CV0hqbCtKWVd2QVZEQXYw?=
 =?utf-8?B?akRZVDlIK3NKZTVTRE45NU5icExuMUc4SElNUnFKekZ0Y1h3THR3REV0ZjBR?=
 =?utf-8?B?MzliMUJSRGo4STBFSE55cnZoRS91NWczMkVESlRXalRQamRQWFVvbUdyYy9O?=
 =?utf-8?B?ajNkaUNJVU5mRzhIbUpHWXdOdy96OE00VDZ4VVUyTmxmbjJMYjdEYXdmZk5P?=
 =?utf-8?B?c3UzT1NlQ2ZWOVpVL1JHUTU3WFJQRUNzdnVxS2FlN1pEdlVrWFB1MEQ5ZFlK?=
 =?utf-8?B?QWRSWjZxaTNDSGVDWmFRTGxaRmpsVklFcVVCa1QyVmtLeURIbFkwelcrb1FY?=
 =?utf-8?B?MVQyRllvUVdoWHFxcHNjUjVJZTZrclhoeDVSclprMVc5U1BPaTdRekk0TSti?=
 =?utf-8?B?SXFLL1B3VENkS0k0SVVSekVGTGNER0xYRXRYcHNrd3NSU1ZIQmxMS3JTczVP?=
 =?utf-8?B?RWR4Q3pzRUhmMCt6OE5VVDBKRW1xUXB3VjVXY1F4T0E1MThhUFNxdWtuYXE4?=
 =?utf-8?B?bjhuTEx0NTRNL1ZVODFsWGhDeWZsMm92cUpCVVB6Nk4rd0x3RXU1YWptOWpL?=
 =?utf-8?B?eDV5VW5wanJxL2pkYlp6bVdXZHhPWXFzeUJ0bnlnY1lqM2k3a3hYMXd0UnE0?=
 =?utf-8?B?Z08wWDJUZFFaWjEycmp2aVRRNUczRUdjZUg3eXJQVmV2aVl6c29sTHVWYkdK?=
 =?utf-8?B?SzlpeDdGbnBqbnBPRFUwL215ODVjNXZRbTNBb1dXcUtqcVBtcjVjZnFMSlBJ?=
 =?utf-8?B?VnVPazBOdk1uRGFvVFBWb0YybEpZekxIR0FiQzR4RHRoZXN5MXoyNTdkc2RR?=
 =?utf-8?B?K1lQMU55VE5zQ043SUVFSEp2RG80YzE1dEtpeXhvMzN0ZE4vWWdGbUFKQkll?=
 =?utf-8?B?L2VMdmxMaWdzVTR2dG1uZ3pZYWgyV0JCMU5BSXdIVnZuUFJIYnI4V3NjNGU3?=
 =?utf-8?B?aXcwYlRYeVdGcDdaMEZEQUpaMjl3cURPTVFkTEJ1L1dwVWxuVmhYMlg5NEdO?=
 =?utf-8?B?SUVQVzJLQnJVUktKM3Y3Sy96SE5PNUxyazdieGNNNTBrZkN2Q0x2YjhZZEx4?=
 =?utf-8?B?YkJZVjJNQTJrcnpmOHpzMlk2RXBsR0lkdkNneHIycTdIOTJkQlIwZkhwRWkx?=
 =?utf-8?B?ZE9WK0Q0MkhZb01mdy8xbWxXRXFRT2JBN3ZKSFczL3d0a1dEQW9xVmcwblVF?=
 =?utf-8?B?dTFaVTJNYVV5dUpIY0E3YndFT211VVdZcmpKUG5wUFNDeFJaWXIrMGVFTm5T?=
 =?utf-8?B?dllYV3dWM0I0UDJtTGVDQWcvanFKOG5pYzlSTUlRcjhVSmlxS2tCTW9uOUZT?=
 =?utf-8?B?NmRSWGlWazNTYVhLUVE2N050MEh3NWhmVlMzQWF6RkpkenF2UDAzcklQS2Jo?=
 =?utf-8?B?bVEwM2tRYjJnWWkzWGdzQ2hoMGhvU3RHeFplam5EYU5DUlRaZnlUckRlaXR3?=
 =?utf-8?Q?N5O2nZeOC3+7ie2OKbsN6Sl61euFjdpTon3JxNAFtHHn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b29fc1d1-548c-4e9b-7e57-08dad7895c24
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 12:56:58.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jk36osdogqZxrz6r1lLA6XZs2p90BY4muzMYB5Ob/COd9YvN/I+5kmT7FWIGI8hC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8139
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 06.12.22 um 13:54 schrieb Rijo Thomas:
>
> On 12/6/2022 6:11 PM, Christian König wrote:
>> Am 06.12.22 um 13:30 schrieb Rijo Thomas:
>>> For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
>>> ring buffer address sent by host to ASP must be a real physical
>>> address and the pages must be physically contiguous.
>>>
>>> In a virtualized environment though, when the driver is running in a
>>> guest VM, the pages allocated by __get_free_pages() may not be
>>> contiguous in the host (or machine) physical address space. Guests
>>> will see a guest (or pseudo) physical address and not the actual host
>>> (or machine) physical address. The TEE running on ASP cannot decipher
>>> pseudo physical addresses. It needs host or machine physical address.
>>>
>>> To resolve this problem, use DMA APIs for allocating buffers that must
>>> be shared with TEE. This will ensure that the pages are contiguous in
>>> host (or machine) address space. If the DMA handle is an IOVA,
>>> translate it into a physical address before sending it to ASP.
>>>
>>> This patch also exports two APIs (one for buffer allocation and
>>> another to free the buffer). This API can be used by AMD-TEE driver to
>>> share buffers with TEE.
>> Maybe use some other name than dma_buffer for your structure, cause that is usually something completely different in the Linux kernel.
>>
> Sure Christian. I shall rename "struct dma_buffer" to "struct shm_buffer" (Shared Memory Buffer) in the file include/linux/psp-tee.h
> The functions psp_tee_alloc_dmabuf() and psp_tee_free_dmabuf() shall be renamed to psp_tee_alloc_shmbuf() and psp_tee_free_shmbuf(), respectively.
> I shall do correction in next patch revision. I will wait for others to review as well before I post update.

I strongly suggest to use the name psp_buffer or something similar 
because shm_buffer is usually used for something else as well.

Regards,
Christian.

>
> Thanks,
> Rijo
>
>> Regards,
>> Christian.
>>
>>> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
>>> Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>>> Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>>> Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>>> ---
>>>    drivers/crypto/ccp/psp-dev.c |   6 +-
>>>    drivers/crypto/ccp/tee-dev.c | 116 ++++++++++++++++++++++-------------
>>>    drivers/crypto/ccp/tee-dev.h |   9 +--
>>>    include/linux/psp-tee.h      |  47 ++++++++++++++
>>>    4 files changed, 127 insertions(+), 51 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>>> index c9c741ac8442..2b86158d7435 100644
>>> --- a/drivers/crypto/ccp/psp-dev.c
>>> +++ b/drivers/crypto/ccp/psp-dev.c
>>> @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
>>>            goto e_err;
>>>        }
>>>    +    if (sp->set_psp_master_device)
>>> +        sp->set_psp_master_device(sp);
>>> +
>>>        ret = psp_init(psp);
>>>        if (ret)
>>>            goto e_irq;
>>>    -    if (sp->set_psp_master_device)
>>> -        sp->set_psp_master_device(sp);
>>> -
>>>        /* Enable interrupt */
>>>        iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
>>>    diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>>> index 5c9d47f3be37..1631d9851e54 100644
>>> --- a/drivers/crypto/ccp/tee-dev.c
>>> +++ b/drivers/crypto/ccp/tee-dev.c
>>> @@ -12,8 +12,9 @@
>>>    #include <linux/mutex.h>
>>>    #include <linux/delay.h>
>>>    #include <linux/slab.h>
>>> +#include <linux/dma-direct.h>
>>> +#include <linux/iommu.h>
>>>    #include <linux/gfp.h>
>>> -#include <linux/psp-sev.h>
>>>    #include <linux/psp-tee.h>
>>>      #include "psp-dev.h"
>>> @@ -21,25 +22,64 @@
>>>      static bool psp_dead;
>>>    +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>>> +{
>>> +    struct psp_device *psp = psp_get_master_device();
>>> +    struct dma_buffer *dma_buf;
>>> +    struct iommu_domain *dom;
>>> +
>>> +    if (!psp || !size)
>>> +        return NULL;
>>> +
>>> +    dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
>>> +    if (!dma_buf)
>>> +        return NULL;
>>> +
>>> +    dma_buf->vaddr = dma_alloc_coherent(psp->dev, size, &dma_buf->dma, gfp);
>>> +    if (!dma_buf->vaddr || !dma_buf->dma) {
>>> +        kfree(dma_buf);
>>> +        return NULL;
>>> +    }
>>> +
>>> +    dma_buf->size = size;
>>> +
>>> +    dom = iommu_get_domain_for_dev(psp->dev);
>>> +    if (dom)
>>> +        dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
>>> +    else
>>> +        dma_buf->paddr = dma_buf->dma;
>>> +
>>> +    return dma_buf;
>>> +}
>>> +EXPORT_SYMBOL(psp_tee_alloc_dmabuf);
>>> +
>>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buf)
>>> +{
>>> +    struct psp_device *psp = psp_get_master_device();
>>> +
>>> +    if (!psp || !dma_buf)
>>> +        return;
>>> +
>>> +    dma_free_coherent(psp->dev, dma_buf->size,
>>> +              dma_buf->vaddr, dma_buf->dma);
>>> +
>>> +    kfree(dma_buf);
>>> +}
>>> +EXPORT_SYMBOL(psp_tee_free_dmabuf);
>>> +
>>>    static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
>>>    {
>>>        struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>>> -    void *start_addr;
>>>          if (!ring_size)
>>>            return -EINVAL;
>>>    -    /* We need actual physical address instead of DMA address, since
>>> -     * Trusted OS running on AMD Secure Processor will map this region
>>> -     */
>>> -    start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
>>> -    if (!start_addr)
>>> +    rb_mgr->ring_buf = psp_tee_alloc_dmabuf(ring_size,
>>> +                        GFP_KERNEL | __GFP_ZERO);
>>> +    if (!rb_mgr->ring_buf) {
>>> +        dev_err(tee->dev, "ring allocation failed\n");
>>>            return -ENOMEM;
>>> -
>>> -    memset(start_addr, 0x0, ring_size);
>>> -    rb_mgr->ring_start = start_addr;
>>> -    rb_mgr->ring_size = ring_size;
>>> -    rb_mgr->ring_pa = __psp_pa(start_addr);
>>> +    }
>>>        mutex_init(&rb_mgr->mutex);
>>>          return 0;
>>> @@ -49,15 +89,8 @@ static void tee_free_ring(struct psp_tee_device *tee)
>>>    {
>>>        struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>>>    -    if (!rb_mgr->ring_start)
>>> -        return;
>>> +    psp_tee_free_dmabuf(rb_mgr->ring_buf);
>>>    -    free_pages((unsigned long)rb_mgr->ring_start,
>>> -           get_order(rb_mgr->ring_size));
>>> -
>>> -    rb_mgr->ring_start = NULL;
>>> -    rb_mgr->ring_size = 0;
>>> -    rb_mgr->ring_pa = 0;
>>>        mutex_destroy(&rb_mgr->mutex);
>>>    }
>>>    @@ -81,35 +114,36 @@ static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
>>>        return -ETIMEDOUT;
>>>    }
>>>    -static
>>> -struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>>> +struct dma_buffer *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>>>    {
>>>        struct tee_init_ring_cmd *cmd;
>>> +    struct dma_buffer *cmd_buffer;
>>>    -    cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>>> -    if (!cmd)
>>> +    cmd_buffer = psp_tee_alloc_dmabuf(sizeof(*cmd),
>>> +                      GFP_KERNEL | __GFP_ZERO);
>>> +    if (!cmd_buffer)
>>>            return NULL;
>>>    -    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_pa);
>>> -    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_pa);
>>> -    cmd->size = tee->rb_mgr.ring_size;
>>> +    cmd = (struct tee_init_ring_cmd *)cmd_buffer->vaddr;
>>> +    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_buf->paddr);
>>> +    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_buf->paddr);
>>> +    cmd->size = tee->rb_mgr.ring_buf->size;
>>>          dev_dbg(tee->dev, "tee: ring address: high = 0x%x low = 0x%x size = %u\n",
>>>            cmd->hi_addr, cmd->low_addr, cmd->size);
>>>    -    return cmd;
>>> +    return cmd_buffer;
>>>    }
>>>    -static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
>>> +static inline void tee_free_cmd_buffer(struct dma_buffer *cmd_buffer)
>>>    {
>>> -    kfree(cmd);
>>> +    psp_tee_free_dmabuf(cmd_buffer);
>>>    }
>>>      static int tee_init_ring(struct psp_tee_device *tee)
>>>    {
>>>        int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>>> -    struct tee_init_ring_cmd *cmd;
>>> -    phys_addr_t cmd_buffer;
>>> +    struct dma_buffer *cmd_buffer;
>>>        unsigned int reg;
>>>        int ret;
>>>    @@ -123,21 +157,19 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>>          tee->rb_mgr.wptr = 0;
>>>    -    cmd = tee_alloc_cmd_buffer(tee);
>>> -    if (!cmd) {
>>> +    cmd_buffer = tee_alloc_cmd_buffer(tee);
>>> +    if (!cmd_buffer) {
>>>            tee_free_ring(tee);
>>>            return -ENOMEM;
>>>        }
>>>    -    cmd_buffer = __psp_pa((void *)cmd);
>>> -
>>>        /* Send command buffer details to Trusted OS by writing to
>>>         * CPU-PSP message registers
>>>         */
>>>    -    iowrite32(lower_32_bits(cmd_buffer),
>>> +    iowrite32(lower_32_bits(cmd_buffer->paddr),
>>>              tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
>>> -    iowrite32(upper_32_bits(cmd_buffer),
>>> +    iowrite32(upper_32_bits(cmd_buffer->paddr),
>>>              tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
>>>        iowrite32(TEE_RING_INIT_CMD,
>>>              tee->io_regs + tee->vdata->cmdresp_reg);
>>> @@ -157,7 +189,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>>        }
>>>      free_buf:
>>> -    tee_free_cmd_buffer(cmd);
>>> +    tee_free_cmd_buffer(cmd_buffer);
>>>          return ret;
>>>    }
>>> @@ -167,7 +199,7 @@ static void tee_destroy_ring(struct psp_tee_device *tee)
>>>        unsigned int reg;
>>>        int ret;
>>>    -    if (!tee->rb_mgr.ring_start)
>>> +    if (!tee->rb_mgr.ring_buf->vaddr)
>>>            return;
>>>          if (psp_dead)
>>> @@ -256,7 +288,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>>        do {
>>>            /* Get pointer to ring buffer command entry */
>>>            cmd = (struct tee_ring_cmd *)
>>> -            (tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
>>> +            (tee->rb_mgr.ring_buf->vaddr + tee->rb_mgr.wptr);
>>>              rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
>>>    @@ -305,7 +337,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>>          /* Update local copy of write pointer */
>>>        tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
>>> -    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
>>> +    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_buf->size)
>>>            tee->rb_mgr.wptr = 0;
>>>          /* Trigger interrupt to Trusted OS */
>>> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
>>> index 49d26158b71e..9238487ee8bf 100644
>>> --- a/drivers/crypto/ccp/tee-dev.h
>>> +++ b/drivers/crypto/ccp/tee-dev.h
>>> @@ -16,6 +16,7 @@
>>>      #include <linux/device.h>
>>>    #include <linux/mutex.h>
>>> +#include <linux/psp-tee.h>
>>>      #define TEE_DEFAULT_TIMEOUT        10
>>>    #define MAX_BUFFER_SIZE            988
>>> @@ -48,17 +49,13 @@ struct tee_init_ring_cmd {
>>>      /**
>>>     * struct ring_buf_manager - Helper structure to manage ring buffer.
>>> - * @ring_start:  starting address of ring buffer
>>> - * @ring_size:   size of ring buffer in bytes
>>> - * @ring_pa:     physical address of ring buffer
>>>     * @wptr:        index to the last written entry in ring buffer
>>> + * @ring_buf:    ring buffer allocated using DMA api
>>>     */
>>>    struct ring_buf_manager {
>>>        struct mutex mutex;    /* synchronizes access to ring buffer */
>>> -    void *ring_start;
>>> -    u32 ring_size;
>>> -    phys_addr_t ring_pa;
>>>        u32 wptr;
>>> +    struct dma_buffer *ring_buf;
>>>    };
>>>      struct psp_tee_device {
>>> diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
>>> index cb0c95d6d76b..c0fa922f24d4 100644
>>> --- a/include/linux/psp-tee.h
>>> +++ b/include/linux/psp-tee.h
>>> @@ -13,6 +13,7 @@
>>>      #include <linux/types.h>
>>>    #include <linux/errno.h>
>>> +#include <linux/dma-mapping.h>
>>>      /* This file defines the Trusted Execution Environment (TEE) interface commands
>>>     * and the API exported by AMD Secure Processor driver to communicate with
>>> @@ -40,6 +41,20 @@ enum tee_cmd_id {
>>>        TEE_CMD_ID_UNMAP_SHARED_MEM,
>>>    };
>>>    +/**
>>> + * struct dma_buffer - Structure for a DMA buffer.
>>> + * @dma:    DMA buffer address
>>> + * @paddr:  Physical address of DMA buffer
>>> + * @vaddr:  CPU virtual address of DMA buffer
>>> + * @size:   Size of DMA buffer in bytes
>>> + */
>>> +struct dma_buffer {
>>> +    dma_addr_t dma;
>>> +    phys_addr_t paddr;
>>> +    void *vaddr;
>>> +    unsigned long size;
>>> +};
>>> +
>>>    #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>>    /**
>>>     * psp_tee_process_cmd() - Process command in Trusted Execution Environment
>>> @@ -75,6 +90,28 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
>>>     */
>>>    int psp_check_tee_status(void);
>>>    +/**
>>> + * psp_tee_alloc_dmabuf() - Allocates memory of requested size and flags using
>>> + * dma_alloc_coherent() API.
>>> + *
>>> + * This function can be used to allocate a shared memory region between the
>>> + * host and PSP TEE.
>>> + *
>>> + * Returns:
>>> + * non-NULL   a valid pointer to struct dma_buffer
>>> + * NULL       on failure
>>> + */
>>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp);
>>> +
>>> +/**
>>> + * psp_tee_free_dmabuf() - Deallocates memory using dma_free_coherent() API.
>>> + *
>>> + * This function can be used to release shared memory region between host
>>> + * and PSP TEE.
>>> + *
>>> + */
>>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer);
>>> +
>>>    #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>>      static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
>>> @@ -87,5 +124,15 @@ static inline int psp_check_tee_status(void)
>>>    {
>>>        return -ENODEV;
>>>    }
>>> +
>>> +static inline
>>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>>> +{
>>> +    return NULL;
>>> +}
>>> +
>>> +static inline void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer)
>>> +{
>>> +}
>>>    #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>>>    #endif /* __PSP_TEE_H_ */

