Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F556489CD
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 22:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLIVBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 16:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLIVBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 16:01:45 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8727EAF4C5;
        Fri,  9 Dec 2022 13:01:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk7LZT10v52M8sLRaru2DKf5mBd2dX7zZCTcXLY2/eNo/qW32wDFsyg1jzgqyDblnffTcUN5SPaBgOvZmIGKwm6q4QePeY706qs/J9dvCooBaU8mCKlymXb6PgbSqZxKtQl7Anz5vk3W5O0SDOJmHzmjItmX+zhlOjYNc5eMhCb4IeiWLMET/IIOvn5KbrjAwAb8REg88wMOgkscPx2iQ1zQIm1xB0eaSWu6Ino089eTW4jwzgez+5pZZDBAMaUt4tIF/xavgGTiJz3Azdvw76KeIhdLESUqgG4/nmNiFxKd950ICsN9EdwOWYeWQXQ0ChxWe7omHd8cW5xwsm2oKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rENOVXMsHDu2AWGNsyKMqSPiXgByLFCdL1otX1NAWT0=;
 b=UZGsttADIHTVeyF6hM4a0I0RB0LrwK2JqHjgxw5Gu0XmjTcNerE84gYc5na7JQXZBNdXM+wI58VpyTRQgKAM3uuMi/Asq2UoQohkZt6JleDDfBok0B2NhzgD6Fu1H9u0r0Xr+k4vuwxQdk7lyMBvqfMhqARt2Srs18diKBOtm2qbfcvFivk+VI+TGOY3Gyi5il64Hu6x9ROVz2E5Yw5pKALJtXqXrZHWpBXs+1Ewo+nFGcD86whZuhObZ3yX/a4/ulwNpmgNE4h/VyR9ckvoK63dLDbHdIxaewrfKxdAxRN/f+uHo/8lSUkXKU6cxc+R0I2bjo9vfQgMEILyZ/+ypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rENOVXMsHDu2AWGNsyKMqSPiXgByLFCdL1otX1NAWT0=;
 b=mNrC6Oi1+hz+rqfsy+dbbSrjO+3ZuUbMfzHKL6E2Jb9C+9jD6wOR1lOt97quxcNfGZU60iRwKrxTQoZTUsGXwm3awdzbqhg2589ngANqGPNA4PdEdIe1i2J2qK+rAMZ71qML1O+gZNJ3NY128e3p9Pn/qKmDD5h8DiJnH5x/E58=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 21:01:40 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5880.017; Fri, 9 Dec 2022
 21:01:39 +0000
Message-ID: <7d4bca0d-2b31-26d5-26cd-655fd2b82107@amd.com>
Date:   Fri, 9 Dec 2022 15:01:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/1] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
Content-Language: en-US
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <43568d5e6395fcab48262fa5b3d1a5112918fbe8.1669372199.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::6) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c74222-7308-4846-2299-08dada28906e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2as8Pk2e7S/XKvZc7Na0yxIzDNN9rfo/ggnCXTTHnQ4tHWlIJHGOt5Evq2/hPbnaldAPSvqvopURBnKOlq/5IszITyTzdPHvhJ+UNAqRKMy4UE0sC9bHMLxdiGfsgPYCVxoIIgpI/6s5ivAbl+BhRQ0LrT+NBUsMUGNarEX9tXontOZCA6UmLkszweF1zLsyFVDHxd8S30Ko+Ydny7LOzn9gWJy7AlkX/dJdI+zbnJat04lPLMRnd1Sy9UHAEST12mstPsgiXA0xi4DW3Vjd6ViiUAXvgoPTN8FM0WbkJvEqHt8Y2AEblerh4h1rFnGzNJaamPa1SNRJvfxz/GLiTvfKKo2Misn4BI36/0ns7twzi4xF02J4nQa2VSmSc5g0J3Oxhugh/RCR65/b+hvyPU234Y5Zswhkg+CXLhKNLwVgKzesVJ3IP74k4EgH2Dy6DquRJ792oE17ymkWs9df1EMP4pURh9fvNkok4Z2EAKZfgacfNFd6daIDgSlv5ySFlAtFdgd6Jx0axWROqDY8oSRm4x3waeI87/TbAKDKhXmwFam5zG98X6ctqYqiF2yivrPQCI/kJQiEc0bHFfw58yO7hBJgfP5unE5sOn9304ewZydvtXEm4V8VewCfWMfsQpem00n/G2KA2Vb44dwlOQu5Py5LT9Il8Tt5GQRulhmpiHH1ectlBiNpDn/m/9F6p+XH9LHKJk1rWVv1ILfqXvwBNVIZEccV1JSyLf/Lbx2i7gwLlcgWB6GHPhhY81yY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(66899015)(31686004)(186003)(31696002)(6486002)(110136005)(478600001)(54906003)(6666004)(316002)(6512007)(36756003)(86362001)(921005)(38100700002)(2906002)(6506007)(53546011)(26005)(7416002)(2616005)(30864003)(66476007)(4326008)(83380400001)(66946007)(66556008)(8676002)(41300700001)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anRvZExNekFvQVQwOC95YS8zN3k4aS83NkdxMm1XR1ExL29zY0dVTm1Od21B?=
 =?utf-8?B?M3JUVFlheWFkNlErNUx3MXRZaDdNSE5NUkVwTDVYVTJpeUswYk40VXdQb3Js?=
 =?utf-8?B?KzhoRmNoRWJZcmZ4TGlBTTJ5elJ2T09RUFdiNDBEKzQ2UUtST29CYS9qK0dw?=
 =?utf-8?B?dFU5aittWWkxUjVyNFdRbFFMMFRjQTI5azhaSmE5WmtNZUg4T3h6cWFPRjRX?=
 =?utf-8?B?SUhGQzE4ZkVGWUhtc2x3R0VDL2QzTk9YdlhrbEQxQlVoa2Nka291eXJtV2Iv?=
 =?utf-8?B?bytESTlFUFRkdXhHa1RUeWdJZGI3YldJQUVnREthb2VFOEhyL1NSaktyYWgy?=
 =?utf-8?B?b2FqRnUyak9SY3QvRGpKV1VFTGhyYjdqWU5hZ0VhL3ViU0hqWXNRUkRrUnE5?=
 =?utf-8?B?L044djlZd08xMXMwNUZtbWQ2MDFZQkk1SndoUTU1cWVxY2V4aDYzdHJWQzB5?=
 =?utf-8?B?SjliWDYyWmxiamNLSml4MURETEdaTHZJMGNDTEJ3d1NzeDhYNnZvUEoxTnJw?=
 =?utf-8?B?djYwdnhETFZqUXFHNS93OEo3czdaYm01REF2dTRRNWlBVE5Rc0dnS1NaN3VH?=
 =?utf-8?B?cFRpVmM5Yjk3eE9mY2ZhN3Bqa2hxakU0WkNQci92MkFHL3A2Ky80ZENmNWRv?=
 =?utf-8?B?aXMwa3pWcU15VlhGZGFPTm84REp5d1RCMTBoK2Z4V2J4MTB0UTlQTHQwRWJW?=
 =?utf-8?B?Z2kxbW1RTmc0ckFMdkxUdDhGK0pxS3R2eDZLTUV4OWphbFJlenZ0YWM2Y2Zx?=
 =?utf-8?B?QTd6dWhvbGNGVFZ4a3huRlBISm5RV2hXTW9zcXNZR2RRQ1hobEUyUUF2RnQ2?=
 =?utf-8?B?NUtjWUk2dWpFaHRXQUo0Y0lIaEFLTi9QQ0JBSXJlSTlNMS9DSWZNMnBHQlN1?=
 =?utf-8?B?VmwvdVBFVUk4MTJybWJYeWNCRFpQdU52bnl3QU1jelNWeC91NzBveEl5VmlB?=
 =?utf-8?B?QkUyczN0cFRGZkR3ZkV1VXpHZk5EM0JWNVZ2NTZPcnpTWXhRYk4rK2JtOW5W?=
 =?utf-8?B?bmFaOFRIemlZYzdUQklqaE1uYjdTcnlocHROWUtqc05WUzc4OWp4Q2p6TEZL?=
 =?utf-8?B?NVBnanRtaGJvMzVtK3hWVnBLTFBFN0pZVTV6bDF5QjJMajRIYjQzVlg5ME5S?=
 =?utf-8?B?ZHhnUXBGMnZ0RndtbGM2SnI2SGpyOVRIN2p3Q1F3N2RxeTBxZHJlMGJPdWdi?=
 =?utf-8?B?QzJkdkZYREkrTkJKemp0UFVpTHRPUXFjZ0xEZDlrMDRLVW1TMVJMeWRYeGZD?=
 =?utf-8?B?eEozbFRINnRlWXgxckpJYmdraG9qc2tIdk0vbW5oeldONlZSR0tGaFVUb3lB?=
 =?utf-8?B?UTFnRTZhSDQxNkU5Y0JpZldaRktUUVcxUG9ZUEI0a2NlcXkzU0plWWFmb1hY?=
 =?utf-8?B?YVhOSGEvWlh5YmFxVUEzLy9rYnNhbHV3c2pUalBJRWt0b1BQc205TURzZ3Ur?=
 =?utf-8?B?VzVRbC9tVGc4VDR0dE5MekhzQkJneWp5eVl4QmZmTm9TUDdadXZhUVdYenVG?=
 =?utf-8?B?aDcvUHVXOERtQXhqZUp4d3RZOTBNRUo2eEpQdURRYTFoU245VVFYVE9WdUt2?=
 =?utf-8?B?SDBPcnBQVXdDSzIxdEc2TXE5blVQNjhxU09MMlMwTzlBL2xzT2JaODJEa0Yz?=
 =?utf-8?B?OVY2SUw3aFBQMXhkSG44M055bWhnSlVKQ0Q4UTY2YS9LMExkOFpPNzBNK2xs?=
 =?utf-8?B?TmpMbkw3TnhvcWhHTXRiMDhkRTN2U0Q5cHdFQ1AxZDg0TVNjQ3A1VWhtb2Fx?=
 =?utf-8?B?MXhzZnlrVXVFZ3RyWWNQNkpKTU5LTThSLzhDNXloWXJpc3dHdEZzZkV5VWlU?=
 =?utf-8?B?aHpVVnVNVmpvWW8yWGVtTlJxcThMMEJTcWV0UmtQdDlnb3BXN28vUm9ORUhn?=
 =?utf-8?B?U2VPdm5XNk4vcVlKMDNxUTc5dnA1aTMrd050STNVUkFwdzZGd3NTRFZSS2RL?=
 =?utf-8?B?cGQ0N1NYcXh5NE1xdjlzeDhLWWlpU3ZIOHdFTzZsRmFKUzZ1VUpqRjFVMTJV?=
 =?utf-8?B?YUhFTWozSm5KT2hxVUp0eEhMRml0VWVsS1BJM2JGNU1Md1JJN2Z1RGtOVTRm?=
 =?utf-8?B?TFE1cElGSE14VThwNmJpZUJtM3ZtZGZkZitaWHM3SnFUTnpLdjRRMk56OTl4?=
 =?utf-8?Q?BHbJIddup1fpb5Odh56LnI9AS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c74222-7308-4846-2299-08dada28906e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 21:01:39.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BPBa8+ENpCl0Dhc6+opAsXx6bvFywYB5bMLe1Y9ckJTR0rVMdShdLhuGQT077aHMII3Fvnkew+qJbU9fmNtfqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/22 06:30, Rijo Thomas wrote:
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

This worries me a bit...  if psp_init() fails, it may still be referenced 
as the master device. What's the reason for moving it?

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

It looks like both calls to this use the same gfp_t values, you can 
probably eliminate from the call and just specify them in here.

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

I don't think you can have one of these be NULL without both being NULL, 
but I guess it doesn't hurt to check.

> +		kfree(dma_buf);
> +		return NULL;
> +	}
> +
> +	dma_buf->size = size;
> + > +	dom = iommu_get_domain_for_dev(psp->dev);
> +	if (dom)

You need a nice comment above this all explaining that. I guess you're 
using the presence of a domain to determine whether you're running on 
bare-metal vs within a hypervisor? I'm not sure what will happen if the 
guest ever gets an emulated IOMMU...

> +		dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);

If you're just looking to get the physical address, why not just to an 
__pa(dma_buf->vaddr)?

Also, paddr might not be the best name, since it isn't always a physical 
address, but I can't really think of something right now.

Thanks,
Tom

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
