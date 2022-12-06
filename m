Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9327F644347
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiLFMli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLFMlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:41:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B8520BDA;
        Tue,  6 Dec 2022 04:41:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCiugxuR9ESyBJXEBFKEGvaprdXakmTn+rp3uAHmOscom1hh34aRmhPKO1D26ep2GP8Gx6cNGPm+gvQITYIPy3R6dgB+oGHWJ7w1m2tZcGm45lQEQO1mU4cRSas8rUq2vy0+8ARGwWVn3jsseCu0sPh47h5dIq0ASUhJPVtzUYrQpR8+eAq6tkYLoaMBWLiPEvzO2qxWKaMVP++be1nBqCl9dwSZJi3M33o9rbxg/PvIIvFZkOjiXaypzHCirgn+xkyRv40KAAFU5Zju3g/KBfvI3AH5B4HXMgQP0GsC6IhLZ6Bi3dYafZ5PdFDIVPXdi4ISMfTA2SpGvjC7hrTZ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coBPA6Di1/t1eo8iyLBYtWPd8VUhxltt2JP94tQ52O8=;
 b=gOFhVLdxWAtBo23Vqf526mABJ9goOXDFx+sLuBOvj7qSwbcMf7+G19WJK/VBecHfiD0wY/xSuJuBV0JfnBGDYToGFe2spEgr/q0suLZ7c0DJTZAciHkVTyfwyBqxqXUmyIiYR+Qvrhs8DZxKREeJ8fDKz2i1mhuRGWwPkoimUgjzQWjsIhmRkRXiPVoHzVnTPL4qSDH45V/PoS/ICRpGJlLytlQosZ+WXnn8CUgTlRXyHSIWkw6LjWGMZAtc1Sj7vhji5MYJ6X4JTTX2Dt2jA21ATKIOJYv8qz5ODK2P5iKXa8K1qfpc1LvhUJwXWO6RZjSFBAFw/hDIKEo7u8pifQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coBPA6Di1/t1eo8iyLBYtWPd8VUhxltt2JP94tQ52O8=;
 b=d5TNAgx5LVOdH5UDms+pvfRePpdv95dvhTTeuFsub6PYb+lX0lKpwTfOdm45PyxhxkH/KDoFekciSo+7xmh6OD6UVS72U5/QgTeSrBhh8lV0LE32491DgfsmjXJb7CoiNy6FPgndxXrMD8gfZglwFxrBxghepwtIVSZodPwFX7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by SJ0PR12MB5636.namprd12.prod.outlook.com (2603:10b6:a03:42b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 12:41:32 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::7d43:3f30:4caf:7421%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 12:41:32 +0000
Message-ID: <78b23ccf-f50f-a793-ae6a-0a70faa2fb06@amd.com>
Date:   Tue, 6 Dec 2022 13:41:26 +0100
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
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <43568d5e6395fcab48262fa5b3d1a5112918fbe8.1669372199.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0122.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::6) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|SJ0PR12MB5636:EE_
X-MS-Office365-Filtering-Correlation-Id: d35067d3-5d7e-4441-fded-08dad787343d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1jGbA7t3Y2SVEtQH7AMckDROzD6BqQ63ohSw0xuMsqq5VQ9L0E81M6P+5VjXLUDKH4dCdygsZwpp1mex66I7FM3UpUecU6spY49mhpwZgeate25yaG4mZItX5CjigC3y+3U/oNQA+BBnuAK12Ky4Ju3KJZmDvkAElC4pUywp+gARl9MpJzHMMeGuGw33fva/lLUpqJbSGHaoXrNGXx9Etyzb+qTs1HVXU8rC5eU2BaKEaCFf1t4WBtAh8Chjjm0pO0I3Ht+l79SFcp2/7MTytKyhneaz+RHVKZjIOZQsQjS7oFf4ujNcThjflcCJIJPa+ZejqEVM/Ma5pj+4hPCYmrL8UHwuvTUOrWpsc9rnpqbr6UbGYgG6ultU0uqWbLXzSzDPtGVvPWfodfAgCgSCa+7ua96XgMjH42+1unkYmgYPU84sh2XldSjA5X7XngYrkGTL0zY9LauMfMYthj1Oqjebusg0CL4yP2yyRFvztgCReOfN3vRIiI6eKbtj19mCd4DWbLKeVBNchde+PYMwEHJBr3UEPwhTjozAZcWUOb2dAG0qIsrwyDogAW2JsQ7nPvFBzBUR9YSZJtl0wEp7aSaBxKOyJod7F/Ve7bNxH05Z0GspfAHRsJH3NXhF2bGwX8SdNI4IlYKB034nce2p1zE0iAmojDJQgBcrRwjnpiljzp/eqt4NSVvwxY2abf+9mNTGuVC5B1NHAswer6zdksfwvyYdsrtTgZoPnMKHPDSA14DPXwVgDDoO1AVeu2Ku
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199015)(478600001)(6486002)(66476007)(2906002)(66946007)(66556008)(110136005)(38100700002)(6666004)(54906003)(83380400001)(2616005)(6506007)(4326008)(8676002)(6512007)(86362001)(36756003)(31696002)(186003)(41300700001)(5660300002)(7416002)(66899015)(921005)(316002)(31686004)(30864003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blh3R1JWcExSU0kvMHRqVXBERnNhZHZzVkUwL0I4elFWUU9KS1R3aTJsNlFo?=
 =?utf-8?B?bWdqMzhhRjhIcDNiQS9jMFRPWUVwY0Z4VjRvZTAySHgrcHBvZmdCRmxwR3BE?=
 =?utf-8?B?MEdiTngrUkdsY2NhdUFZdG1JZS9QNllrb1lkV1ZtK0x6V05ZeHlKYmd6TW01?=
 =?utf-8?B?QU5ZRk1LV2FaSmF4U2dEcGRWYk44S2RJTG03dml4bFhhdFBXSHNFVW8yUHdX?=
 =?utf-8?B?a3BMRnVqZVA4SzYvM3ErbHdpQUx3OHIrZTROY0lRUzhwV0t0aXBmMXlZaWY5?=
 =?utf-8?B?cGV0aEZldXdOaktiRTNQMmJ5N2YyWXU3aUhKbWVoc040azBDd3NMYS95Nzc4?=
 =?utf-8?B?ejZhSEpTOTRqL0diWEFJM2gyQnBlVXdtSHJ6b1FXeWNZbDVQWU83SWptRDhV?=
 =?utf-8?B?emZWS1l4ZElRT2xrU1RjbzVHbVArTURCakMxdVJzK2pxZEpUMVZockIyTFdt?=
 =?utf-8?B?OFFqN21wR1NMNVFZV2dXTWZpYVRlbFR0SlAzaEZWK3RkSHZSTTdyc2ZXRHB2?=
 =?utf-8?B?aktBU1VZc2NnSGxxRE9laUFwcHRWdUhSZC9Pc3M4bmpKV2RHaHhMeGRadzR1?=
 =?utf-8?B?eDUxTzdscXI0MSsrQlpicWYvcDV3aWIzZk8wV2xFYlFBRE5zaUw5UGlRd2g0?=
 =?utf-8?B?TGUwUkNSM1QyL0FKUHZOYVo4NUFvZ0JmbUV1MjRSdHlOcTkzYjdtNGNqSzVB?=
 =?utf-8?B?RHFOYzBnOUFrOVdUTGkwd25Vb0c1ekU2Nno5L3dqeWJsb3JMcncyRXhkaGtH?=
 =?utf-8?B?VTFubXZkWWI5OEJnSWRERWl1bmszSU5rYkpoVzdFWGkvTW4yR0MwZ29GN2xz?=
 =?utf-8?B?L21SK3hOT2UwMEY4b1NiWE5YRTNhSWtPY0twc0Q4M09mMmNraVhMbDRyTEc1?=
 =?utf-8?B?VnI2TytmUC9yNFg2TmlJSWRJL2xaak1zUWVuTTdJeG9yY3lWMGcraWtBODFp?=
 =?utf-8?B?cVpPdXZoNGhLTTVqb2I1a0hmWXNOeWZ6V1k2WFdYYmpNZ1dZV2JmZTNNNUVn?=
 =?utf-8?B?RlZUbWZhMy9RSWxtY05SUlhVUmJoVGxyM0ZhWnZKRnlQdUt6ZC9odXp6dnhz?=
 =?utf-8?B?Sk9SWGZ0d3J3ckpFZjRUaGNxYTY5S05obmMwY0cwcmxwcUFWQktlaGdOR09r?=
 =?utf-8?B?S0dqSUVVdWo4TE03eW1HQ3pJSFFaRFRqTndJRXNmUytGaXRoTWlnZHIweW1l?=
 =?utf-8?B?Y2hGQkcwQUZ4ZG9qUWxzNGZsR1hIOWZIYW93aXhVcG45SkRXWHV1WlBlSU1r?=
 =?utf-8?B?T2RnTHd3bWljNE53c2hrNm5PUStua3BGNTlTVWNaa2Z6cVQranVVRndJOGRF?=
 =?utf-8?B?VGlkTFJEcS9MMDZaRnVQbjNhVFFEeTROd0NzNlVYUnBwbmFQKzNIWFJ0akdi?=
 =?utf-8?B?L1lIcjdVeEg2RE83ZVIyZXNEZHZ4TTFMVFFJcUxMTzJyTEU2KzBoYTg4aDVQ?=
 =?utf-8?B?VUtqUnhhbEo0WTM5OU9paStyTTNKZlJza3huUXlxRXI5M2c2RXlDdGhmRGI0?=
 =?utf-8?B?QWNlUDRCcWpTRnc5TVd2OTBybk4wNEZxS3ZFQllTSEU2d09xNXRUbHIwL1pn?=
 =?utf-8?B?TDF2MHo2K1ZhQUlNMEc5dUNPaHVUTERYSFJNUi9OUVZZTllQb3A1SERMUXJx?=
 =?utf-8?B?c0ZIRDY1b3FEVm5uTEZZbzNTbHhORUJXNE1zNUVGUXdnbFlTQkxqRmRIUmpL?=
 =?utf-8?B?Z3BZSHJpL1pIMmdxYWE0Ums4cnduMVM4T01xaVhSRUNxcm5iZHVNajJlbHhs?=
 =?utf-8?B?ck9lSVlvTzFDTVRpWURJL2k5aWN5UVBYa0ZZUDhTb0Y2ZUJ2VCt2ZVQxNmlt?=
 =?utf-8?B?VU5QVkZmQ2l3aFYrRTFCdTJWT0pEQ01SQUF3UjJnV2FGNGlsclFab1VXT1R2?=
 =?utf-8?B?eXRYTmgvYVRPQm9QbHFhVEpoNmlsTVJ6M1E1dnM4bDZSRm9hWlAraDY4ZHVz?=
 =?utf-8?B?QTR4SXREV3FHaXdvcHExVFg4QkNRTWlWaXlINkpBeHVaVXNKaGRvSXZHM3d4?=
 =?utf-8?B?cmVDV0VLamdYNVArRmkxdkphODVPcmt1TElnYVNPY0h1eXZ6VmV1cllJcHlL?=
 =?utf-8?B?bFQ5RDZUdGJCYUdyWmpsTzdTZjNkZElSV3dTbm5yTFdKUEIvUkNnaDNpcGZk?=
 =?utf-8?B?Rmo0aVFMNmJGelZTQ3duTHZTY2dHMmcxMDNmNHcyMDdRYnBweTVUZ0JuNEIr?=
 =?utf-8?Q?o002MyY6AKAgYntjqTtB4n8FXi5WtsxJlG2dgjbiJ0IK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35067d3-5d7e-4441-fded-08dad787343d
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 12:41:32.5881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zm+AsoB7dMFAzThlN+F9gMX20IQu7+9zjosxM/Qz/cGwz9FFIlJ5bPEZ9iHLvHy+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5636
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 06.12.22 um 13:30 schrieb Rijo Thomas:
> For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
> ring buffer address sent by host to ASP must be a real physical
> address and the pages must be physically contiguous.
>
> In a virtualized environment though, when the driver is running in a
> guest VM, the pages allocated by __get_free_pages() may not be
> contiguous in the host (or machine) physical address space. Guests
> will see a guest (or pseudo) physical address and not the actual host
> (or machine) physical address. The TEE running on ASP cannot decipher
> pseudo physical addresses. It needs host or machine physical address.
>
> To resolve this problem, use DMA APIs for allocating buffers that must
> be shared with TEE. This will ensure that the pages are contiguous in
> host (or machine) address space. If the DMA handle is an IOVA,
> translate it into a physical address before sending it to ASP.
>
> This patch also exports two APIs (one for buffer allocation and
> another to free the buffer). This API can be used by AMD-TEE driver to
> share buffers with TEE.

Maybe use some other name than dma_buffer for your structure, cause that 
is usually something completely different in the Linux kernel.

Regards,
Christian.

>
> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
> Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
> Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> ---
>   drivers/crypto/ccp/psp-dev.c |   6 +-
>   drivers/crypto/ccp/tee-dev.c | 116 ++++++++++++++++++++++-------------
>   drivers/crypto/ccp/tee-dev.h |   9 +--
>   include/linux/psp-tee.h      |  47 ++++++++++++++
>   4 files changed, 127 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index c9c741ac8442..2b86158d7435 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
>   		goto e_err;
>   	}
>   
> +	if (sp->set_psp_master_device)
> +		sp->set_psp_master_device(sp);
> +
>   	ret = psp_init(psp);
>   	if (ret)
>   		goto e_irq;
>   
> -	if (sp->set_psp_master_device)
> -		sp->set_psp_master_device(sp);
> -
>   	/* Enable interrupt */
>   	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
>   
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 5c9d47f3be37..1631d9851e54 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -12,8 +12,9 @@
>   #include <linux/mutex.h>
>   #include <linux/delay.h>
>   #include <linux/slab.h>
> +#include <linux/dma-direct.h>
> +#include <linux/iommu.h>
>   #include <linux/gfp.h>
> -#include <linux/psp-sev.h>
>   #include <linux/psp-tee.h>
>   
>   #include "psp-dev.h"
> @@ -21,25 +22,64 @@
>   
>   static bool psp_dead;
>   
> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
> +{
> +	struct psp_device *psp = psp_get_master_device();
> +	struct dma_buffer *dma_buf;
> +	struct iommu_domain *dom;
> +
> +	if (!psp || !size)
> +		return NULL;
> +
> +	dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
> +	if (!dma_buf)
> +		return NULL;
> +
> +	dma_buf->vaddr = dma_alloc_coherent(psp->dev, size, &dma_buf->dma, gfp);
> +	if (!dma_buf->vaddr || !dma_buf->dma) {
> +		kfree(dma_buf);
> +		return NULL;
> +	}
> +
> +	dma_buf->size = size;
> +
> +	dom = iommu_get_domain_for_dev(psp->dev);
> +	if (dom)
> +		dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
> +	else
> +		dma_buf->paddr = dma_buf->dma;
> +
> +	return dma_buf;
> +}
> +EXPORT_SYMBOL(psp_tee_alloc_dmabuf);
> +
> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buf)
> +{
> +	struct psp_device *psp = psp_get_master_device();
> +
> +	if (!psp || !dma_buf)
> +		return;
> +
> +	dma_free_coherent(psp->dev, dma_buf->size,
> +			  dma_buf->vaddr, dma_buf->dma);
> +
> +	kfree(dma_buf);
> +}
> +EXPORT_SYMBOL(psp_tee_free_dmabuf);
> +
>   static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
>   {
>   	struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
> -	void *start_addr;
>   
>   	if (!ring_size)
>   		return -EINVAL;
>   
> -	/* We need actual physical address instead of DMA address, since
> -	 * Trusted OS running on AMD Secure Processor will map this region
> -	 */
> -	start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
> -	if (!start_addr)
> +	rb_mgr->ring_buf = psp_tee_alloc_dmabuf(ring_size,
> +						GFP_KERNEL | __GFP_ZERO);
> +	if (!rb_mgr->ring_buf) {
> +		dev_err(tee->dev, "ring allocation failed\n");
>   		return -ENOMEM;
> -
> -	memset(start_addr, 0x0, ring_size);
> -	rb_mgr->ring_start = start_addr;
> -	rb_mgr->ring_size = ring_size;
> -	rb_mgr->ring_pa = __psp_pa(start_addr);
> +	}
>   	mutex_init(&rb_mgr->mutex);
>   
>   	return 0;
> @@ -49,15 +89,8 @@ static void tee_free_ring(struct psp_tee_device *tee)
>   {
>   	struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>   
> -	if (!rb_mgr->ring_start)
> -		return;
> +	psp_tee_free_dmabuf(rb_mgr->ring_buf);
>   
> -	free_pages((unsigned long)rb_mgr->ring_start,
> -		   get_order(rb_mgr->ring_size));
> -
> -	rb_mgr->ring_start = NULL;
> -	rb_mgr->ring_size = 0;
> -	rb_mgr->ring_pa = 0;
>   	mutex_destroy(&rb_mgr->mutex);
>   }
>   
> @@ -81,35 +114,36 @@ static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
>   	return -ETIMEDOUT;
>   }
>   
> -static
> -struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
> +struct dma_buffer *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>   {
>   	struct tee_init_ring_cmd *cmd;
> +	struct dma_buffer *cmd_buffer;
>   
> -	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> -	if (!cmd)
> +	cmd_buffer = psp_tee_alloc_dmabuf(sizeof(*cmd),
> +					  GFP_KERNEL | __GFP_ZERO);
> +	if (!cmd_buffer)
>   		return NULL;
>   
> -	cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_pa);
> -	cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_pa);
> -	cmd->size = tee->rb_mgr.ring_size;
> +	cmd = (struct tee_init_ring_cmd *)cmd_buffer->vaddr;
> +	cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_buf->paddr);
> +	cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_buf->paddr);
> +	cmd->size = tee->rb_mgr.ring_buf->size;
>   
>   	dev_dbg(tee->dev, "tee: ring address: high = 0x%x low = 0x%x size = %u\n",
>   		cmd->hi_addr, cmd->low_addr, cmd->size);
>   
> -	return cmd;
> +	return cmd_buffer;
>   }
>   
> -static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
> +static inline void tee_free_cmd_buffer(struct dma_buffer *cmd_buffer)
>   {
> -	kfree(cmd);
> +	psp_tee_free_dmabuf(cmd_buffer);
>   }
>   
>   static int tee_init_ring(struct psp_tee_device *tee)
>   {
>   	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
> -	struct tee_init_ring_cmd *cmd;
> -	phys_addr_t cmd_buffer;
> +	struct dma_buffer *cmd_buffer;
>   	unsigned int reg;
>   	int ret;
>   
> @@ -123,21 +157,19 @@ static int tee_init_ring(struct psp_tee_device *tee)
>   
>   	tee->rb_mgr.wptr = 0;
>   
> -	cmd = tee_alloc_cmd_buffer(tee);
> -	if (!cmd) {
> +	cmd_buffer = tee_alloc_cmd_buffer(tee);
> +	if (!cmd_buffer) {
>   		tee_free_ring(tee);
>   		return -ENOMEM;
>   	}
>   
> -	cmd_buffer = __psp_pa((void *)cmd);
> -
>   	/* Send command buffer details to Trusted OS by writing to
>   	 * CPU-PSP message registers
>   	 */
>   
> -	iowrite32(lower_32_bits(cmd_buffer),
> +	iowrite32(lower_32_bits(cmd_buffer->paddr),
>   		  tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
> -	iowrite32(upper_32_bits(cmd_buffer),
> +	iowrite32(upper_32_bits(cmd_buffer->paddr),
>   		  tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
>   	iowrite32(TEE_RING_INIT_CMD,
>   		  tee->io_regs + tee->vdata->cmdresp_reg);
> @@ -157,7 +189,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>   	}
>   
>   free_buf:
> -	tee_free_cmd_buffer(cmd);
> +	tee_free_cmd_buffer(cmd_buffer);
>   
>   	return ret;
>   }
> @@ -167,7 +199,7 @@ static void tee_destroy_ring(struct psp_tee_device *tee)
>   	unsigned int reg;
>   	int ret;
>   
> -	if (!tee->rb_mgr.ring_start)
> +	if (!tee->rb_mgr.ring_buf->vaddr)
>   		return;
>   
>   	if (psp_dead)
> @@ -256,7 +288,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>   	do {
>   		/* Get pointer to ring buffer command entry */
>   		cmd = (struct tee_ring_cmd *)
> -			(tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
> +			(tee->rb_mgr.ring_buf->vaddr + tee->rb_mgr.wptr);
>   
>   		rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
>   
> @@ -305,7 +337,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>   
>   	/* Update local copy of write pointer */
>   	tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
> -	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
> +	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_buf->size)
>   		tee->rb_mgr.wptr = 0;
>   
>   	/* Trigger interrupt to Trusted OS */
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index 49d26158b71e..9238487ee8bf 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -16,6 +16,7 @@
>   
>   #include <linux/device.h>
>   #include <linux/mutex.h>
> +#include <linux/psp-tee.h>
>   
>   #define TEE_DEFAULT_TIMEOUT		10
>   #define MAX_BUFFER_SIZE			988
> @@ -48,17 +49,13 @@ struct tee_init_ring_cmd {
>   
>   /**
>    * struct ring_buf_manager - Helper structure to manage ring buffer.
> - * @ring_start:  starting address of ring buffer
> - * @ring_size:   size of ring buffer in bytes
> - * @ring_pa:     physical address of ring buffer
>    * @wptr:        index to the last written entry in ring buffer
> + * @ring_buf:    ring buffer allocated using DMA api
>    */
>   struct ring_buf_manager {
>   	struct mutex mutex;	/* synchronizes access to ring buffer */
> -	void *ring_start;
> -	u32 ring_size;
> -	phys_addr_t ring_pa;
>   	u32 wptr;
> +	struct dma_buffer *ring_buf;
>   };
>   
>   struct psp_tee_device {
> diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
> index cb0c95d6d76b..c0fa922f24d4 100644
> --- a/include/linux/psp-tee.h
> +++ b/include/linux/psp-tee.h
> @@ -13,6 +13,7 @@
>   
>   #include <linux/types.h>
>   #include <linux/errno.h>
> +#include <linux/dma-mapping.h>
>   
>   /* This file defines the Trusted Execution Environment (TEE) interface commands
>    * and the API exported by AMD Secure Processor driver to communicate with
> @@ -40,6 +41,20 @@ enum tee_cmd_id {
>   	TEE_CMD_ID_UNMAP_SHARED_MEM,
>   };
>   
> +/**
> + * struct dma_buffer - Structure for a DMA buffer.
> + * @dma:    DMA buffer address
> + * @paddr:  Physical address of DMA buffer
> + * @vaddr:  CPU virtual address of DMA buffer
> + * @size:   Size of DMA buffer in bytes
> + */
> +struct dma_buffer {
> +	dma_addr_t dma;
> +	phys_addr_t paddr;
> +	void *vaddr;
> +	unsigned long size;
> +};
> +
>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>   /**
>    * psp_tee_process_cmd() - Process command in Trusted Execution Environment
> @@ -75,6 +90,28 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
>    */
>   int psp_check_tee_status(void);
>   
> +/**
> + * psp_tee_alloc_dmabuf() - Allocates memory of requested size and flags using
> + * dma_alloc_coherent() API.
> + *
> + * This function can be used to allocate a shared memory region between the
> + * host and PSP TEE.
> + *
> + * Returns:
> + * non-NULL   a valid pointer to struct dma_buffer
> + * NULL       on failure
> + */
> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp);
> +
> +/**
> + * psp_tee_free_dmabuf() - Deallocates memory using dma_free_coherent() API.
> + *
> + * This function can be used to release shared memory region between host
> + * and PSP TEE.
> + *
> + */
> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer);
> +
>   #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>   
>   static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
> @@ -87,5 +124,15 @@ static inline int psp_check_tee_status(void)
>   {
>   	return -ENODEV;
>   }
> +
> +static inline
> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
> +{
> +	return NULL;
> +}
> +
> +static inline void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer)
> +{
> +}
>   #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>   #endif /* __PSP_TEE_H_ */

