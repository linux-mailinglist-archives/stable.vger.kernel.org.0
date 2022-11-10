Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A59624D55
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 22:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiKJVzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 16:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKJVzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 16:55:44 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2053.outbound.protection.outlook.com [40.107.100.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639B91DDE3
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 13:55:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8VGuOEWmP0V0KY2ZXbSRE10+Ey9QcKl0C/dbyeYuAa2Ks4B6a7LB+8uQQrCeokiB58QGVHS0vPCd5GwxX8juL19xe30XYDKlcWhiEByJz5nZN3MWhSh0170dEapawjPVBBQP5N4sWeyl8RaeRTSBMROC+KcALJ3WVgKyhDH4009pFoyHuq814g4Lp0RMQmXP8ebAumm8Q02xWqGXfAegndax2iiqi6GnoZMt5gnztHA1WP9Xb5zSfjLSil9Y9KvshpxNoURFJ5GA+hQM4z45UeHDgO/iWz/lSzRRnx8HvP+MY54Am4pmjPAN2VKsnWN+de3Mj+9PEKk/2KQgj7Xmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0WrLgp95Hz341IK3M2Fw3ggRprXX82+85Chfthajqc=;
 b=ocxYb1Ze8Y7HGo5LongLWa4uDVk7KqbD0xS7i5kT8hjozSVcis0YZ7niqym5F3hDcpZ50npLEBxoWmv7eXY7mttd5YOgzm991rKy9f6O472VajwtJkdWBHjuDtlziv5sJfDRLDzfiUkwTIHBs1pNFDTtoyQRB6yEFcSxIgVilGHhStIlVzMgBtpFV76fg8hGYEJuuKcosuRnCQAqh13zcIc9dQnLv7zK3yOn7Swh6Qrj78DqGABhNm3T16YCM8gPWjXl5W0ill6p+tVNPvFfl0OAojTGSdQ3NZMkuNt5xLQGzdh1ePy15kf3XXGvbbkahGRmWTlMzQDp0LyqjBOPTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0WrLgp95Hz341IK3M2Fw3ggRprXX82+85Chfthajqc=;
 b=Nsp+zA8U2USMfx9UZkIwuSLgQDTbk4w7bESovSJyYt1NrP+Tz9oGQDP2qZTgfQLLhCz1o+1JXHffVZdnt49bFAKhFLM4u18aKi6pYQxHg1zF6rI+Pw6tEng/xLnzz9zDjc19JeqAHMD+r+vM1iezZXc8BE5MWz3MOerKZ/8jahI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:55:40 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::5d8:f3f2:d940:5350]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::5d8:f3f2:d940:5350%3]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 21:55:40 +0000
Message-ID: <aa3a76c2-e5f3-8e15-717a-a90a1d9c516f@amd.com>
Date:   Thu, 10 Nov 2022 16:55:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/4] drm/amdgpu: fix userptr HMM range handling
Content-Language: en-US
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        Philip.Yang@amd.com, amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
References: <20221110130009.1835-1-christian.koenig@amd.com>
 <20221110130009.1835-2-christian.koenig@amd.com>
From:   Felix Kuehling <felix.kuehling@amd.com>
In-Reply-To: <20221110130009.1835-2-christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT1PR01CA0104.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::13) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|SA0PR12MB4557:EE_
X-MS-Office365-Filtering-Correlation-Id: 10120e4f-f89b-458a-5030-08dac3664e92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nf+Qp1jQ8lGnJ/FDehRS8HfqMt/FRgQaT412w4ofRuByJ5+G7w+QvewLZgShS3dCKrBHefrKvKAVeTyPXZgbbVAoXxBMFhOunp5u3pQ3QdOIupMAUSfa6T/CUnAifj61XzrgCTBWul7XW8/KwXpUYLGxM4mzlNoAC5DnoIgWOk94g907pHw1eNRCbBDRxyLP7R7ahpWTrdt9mlccPFVvP0cklmSydYABcq26V6P54VBD7riB6mLqgM2obU500X5la3dpJpywEndkCgX3+rhm59bTJ4KTSdftvNe3YHvN0D+LY1ToxvReFTvJIFsZ8AKuRjLQWI3KpOBEOSE5k8gDTh1PDFRjaq9isR5NuyrEnLxlzEuH13UTzIdq8HMUyGDnw664v6hAFmbI2o5LRM8az+F/+Pw+pNflJFZK5ob0LGMY2MKiPDS53jK8OW1nTbavkkVYAvGbgS6B2nKVstD6tg+qFmvaE2LXfYcD2GC6ZFbMnCfUNPNQe5Iz6AW1HtPljGMBuAkRVEsw/hAhfoCW9X5OrZe4UIy6NynwAvDGcUmfo/113HIiaIJED3Wke0N3kl+jDae7R/RnC1RKjiIyN+geQqyrOxTVE5GWKJdWmU6txFH8I9hI5RjVP3wkjlXgDirjs8jJ9bOLzGLZroW3nqkHu2kBeNXrgsZEs8IVvKSJ9PaGyi2PI9hdTFv+VizMsWEE4O4ITdw3DZ65UR6FGVFKgyiRYPy/fS4jTMgSi+KvW90+xGAtDPBPz8Ghv05BQfcdudBhLXSrn76UE9ZxZC+Pcl2Mv6i5JtwTXD51nj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(31686004)(6512007)(86362001)(6506007)(26005)(31696002)(478600001)(6486002)(41300700001)(2906002)(2616005)(8936002)(186003)(36756003)(83380400001)(66574015)(66946007)(30864003)(66476007)(38100700002)(5660300002)(4001150100001)(8676002)(66556008)(316002)(4326008)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUlYaFBxbHJGUVUxOWVWSTBmQ2VrUlJNcUVMQU5Sa1hTN3JscGtWS092KzY5?=
 =?utf-8?B?N05YbzVqMUkrZURLOXpXNzRNeElURDdVbE1wYk9sSFcrKzFrVVVLck9pMDF4?=
 =?utf-8?B?QzdKM2NPRkFBMHJHaHJXcDArM21SOW10R0l5aFkzMDJpSGQrRmF2OGI1aW85?=
 =?utf-8?B?Y29vSEVVWDFvRGRINFZxek5SZk5ReWxpK2VWSHhvR2FEc1NHWWFBY0dMdEZv?=
 =?utf-8?B?d1FGVzVNVmcxSnpFWmxOUkhtQm9xMnJ3RUR6Tk5MWmt6RlFZZ2VYckFtd2Za?=
 =?utf-8?B?VGJZTXZNN2QyL091LzdzVEkrNk9nZnBWc2dPVFJnTCtWbE5XRkt4cGFXdWh0?=
 =?utf-8?B?Z0xoL2pEOUo1enF2d2JPZGZ2ajRHcmozUDVHR2FQYUdsdmllbTcyZm1GUmpu?=
 =?utf-8?B?ZTB2VDkwc3N3U21Ddllxb0d4Yjc0U1pXSmJOY0JaWlIrRjZ5NmZ1Q3lYK1FM?=
 =?utf-8?B?NlR3R3gyWWZia1RXRW5IWmdOWTBOY3hFZ1FMSzdrZVFKMUhzY3NMTXlvdHBJ?=
 =?utf-8?B?akp4YTN1bUhnWmtncldqaVFrYWowQ1kzdjBsdC9Ya1JPTkhYS2tHU2MrMzJE?=
 =?utf-8?B?ZTlIY041dlFSTXNFN2dFMEQ5MmFaYVFwL2VvOE14UlRPd0R3Mnc5Znk4Qkhw?=
 =?utf-8?B?TVd2emRaQTVLYWJPb1kxTHFxOE9mYXRUQUVvQXZHM2xSeXpCRldpNnpPNmR6?=
 =?utf-8?B?WVVKOFJnRVRoOHlSaXAxZCthMFVmSEVXUDNKWTkvdXZFMkNHaFhUb3RYWlFC?=
 =?utf-8?B?UWQrcUszOHMyUmpuc28wSGpUYXlmLzN0YjNDTk8xb3lwNy9TcE9vSllBdDZx?=
 =?utf-8?B?My9kcCtiNHVOUnlFU2FzZUxhaXVlSSt0TlNGeVdMRU9tMS9rNXphTUdoRi94?=
 =?utf-8?B?VGpMRUkzSTR3S2RWTmZmRFp4VmJEVmJKb3NjM29sS0lRaURjS1I3NTJCOEpV?=
 =?utf-8?B?Q3Y5Titrd01sbWNrWjJCT0VVYVpLZTlOUmJTa25mU2gzemp2dHBmWTk2YU9C?=
 =?utf-8?B?UzVwNk0yVHFlb2lZbVcxSENWS3BaN3dUSFpucitSbW1SU29XVGFMV1N3K25M?=
 =?utf-8?B?WHYwRzZYOGFpay9QeHFaWDh6YmFETHF3UzlVMFhNK0xIbjFRaVdnanZuQVNs?=
 =?utf-8?B?SGpGNmxKa1krUXRpUGJvYm1GdXV2akdoMWY4OWJWRTFQTEIwMzlTZUdDeEpD?=
 =?utf-8?B?ejhLeFU4QVQ2cklFUEg1M3ZxVTh6YTdudjFPWHBnTHlRaEU5SEh2Z1R0SWtJ?=
 =?utf-8?B?U0FaOFRRL1lxbHA5eldoYklOdVFLT2ZmZkFhbkt6R1N6UEhiek9tWFp5Q0pn?=
 =?utf-8?B?Wk1RZjJ6NFlhUmVvbzd4U29qL2k1Vm1NU2lGY05vUFc2cDZsbW1pMitramo2?=
 =?utf-8?B?M2o3Y0JJR2phSTdwa2hvSW9YMVVpYXJ6Yjh2ZnhUOWFINmVyWk9JSG1Bc0FM?=
 =?utf-8?B?cUtGbzR6OWZ3amM1czlGUStXYjB0UDNJU1Y1bUI1eXk4NXN6MWd4eTlpbTJW?=
 =?utf-8?B?MERLTHU2TEJrd1dmeUdKcFFCdkUybG5DWmRWOTQ3MCs1cldacXJ4OEovcllF?=
 =?utf-8?B?MmMyaFlHUzlQbUFqaldCN00reElMaUhiU0ZudGo5QnV5OTRjajlNaUp1OTZ2?=
 =?utf-8?B?TWh4OTc2aXcxMEFHMCtJeVpZWHRmSU1ZQ2wwUVRLcUFuNU9xa1QvdTE1RmNO?=
 =?utf-8?B?S21XUnVObW0yLzgxZFVVZVl4eVRSb21zcVp2anZxMWZLUUlLTkRIT01HNjBy?=
 =?utf-8?B?WnZ3aHdXYUVhYzBRMkQxTnZFLzJ6N2wzb1AzQU9iVk9LNEpWWjVPTTRoMjJF?=
 =?utf-8?B?UWFMdnJSMWorTXRyeHlISjVYUjVnTzNHM0FZbFB6SmJVL0RmdkRYWkxXTndm?=
 =?utf-8?B?ekhsdDg2S2pDZlF4MmRwMXk0c3lqM0lFdVFoR2QvWEVUY3JtMitMQTVaUExN?=
 =?utf-8?B?akcwczRiNTRKS0pmNkNjNDQvMCtvYTZCVjM0NXlZdVA1d2FDQWhyblhZL0lp?=
 =?utf-8?B?VW5vK1c1QUZqcjhkaENkejVWWUdrRXNPSTNRVU1paFQ4QkVPMnByODlOOWY4?=
 =?utf-8?B?bUdPSkpGTUV3bSs4c2lPSVB1WUNZamdiS1p0YmZteUhiZkhlYXo2dWlHQWg3?=
 =?utf-8?Q?L7lSGidTh0br5pkVhEBMkFaGz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10120e4f-f89b-458a-5030-08dac3664e92
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:55:40.0044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyHLJVHLjhA7npmpgrZ3D5c8tNUXFvgFkD19ZtoZV4nUgvCe/n/gySS19oehCzmdL98xeSdzDA0WIfyQ3a/LOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Am 2022-11-10 um 08:00 schrieb Christian König:
> The basic problem here is that it's not allowed to page fault while
> holding the reservation lock.
>
> So it can happen that multiple processes try to validate an userptr
> at the same time.
>
> Work around that by putting the HMM range object into the mutex
> protected bo list for now.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> CC: stable@vger.kernel.org
> ---
>   .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 12 +++--
>   drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c   |  1 +
>   drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h   |  3 ++
>   drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c        |  8 +--
>   drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c       |  6 ++-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       | 50 +++++--------------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h       | 14 ++++--
>   7 files changed, 43 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> index c5c9bfa2772e..83659e6419a8 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> @@ -940,6 +940,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
>   	struct amdkfd_process_info *process_info = mem->process_info;
>   	struct amdgpu_bo *bo = mem->bo;
>   	struct ttm_operation_ctx ctx = { true, false };
> +	struct hmm_range *range;

I'd feel better if these local hmm_range pointers here and in 
update_invalid_user_pages and amdgpu_gem_userptr_ioctl were initialized 
to NULL. amdgpu_ttm_tt_get_user_pages leaves it uninitialized in case of 
errors and amdgpu_ttm_tt_get_user_pages_done checks for !range.

With that fixed, the patch is

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>


>   	int ret = 0;
>   
>   	mutex_lock(&process_info->lock);
> @@ -969,7 +970,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
>   		return 0;
>   	}
>   
> -	ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
> +	ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages, &range);
>   	if (ret) {
>   		pr_err("%s: Failed to get user pages: %d\n", __func__, ret);
>   		goto unregister_out;
> @@ -987,7 +988,7 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
>   	amdgpu_bo_unreserve(bo);
>   
>   release_out:
> -	amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
> +	amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
>   unregister_out:
>   	if (ret)
>   		amdgpu_mn_unregister(bo);
> @@ -2319,6 +2320,8 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
>   	/* Go through userptr_inval_list and update any invalid user_pages */
>   	list_for_each_entry(mem, &process_info->userptr_inval_list,
>   			    validate_list.head) {
> +		struct hmm_range *range;
> +
>   		invalid = atomic_read(&mem->invalid);
>   		if (!invalid)
>   			/* BO hasn't been invalidated since the last
> @@ -2329,7 +2332,8 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
>   		bo = mem->bo;
>   
>   		/* Get updated user pages */
> -		ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
> +		ret = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
> +						   &range);
>   		if (ret) {
>   			pr_debug("Failed %d to get user pages\n", ret);
>   
> @@ -2348,7 +2352,7 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
>   			 * FIXME: Cannot ignore the return code, must hold
>   			 * notifier_lock
>   			 */
> -			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
> +			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
>   		}
>   
>   		/* Mark the BO as valid unless it was invalidated
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
> index 2168163aad2d..252a876b0725 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
> @@ -209,6 +209,7 @@ void amdgpu_bo_list_get_list(struct amdgpu_bo_list *list,
>   			list_add_tail(&e->tv.head, &bucket[priority]);
>   
>   		e->user_pages = NULL;
> +		e->range = NULL;
>   	}
>   
>   	/* Connect the sorted buckets in the output list. */
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
> index 9caea1688fc3..e4d78491bcc7 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.h
> @@ -26,6 +26,8 @@
>   #include <drm/ttm/ttm_execbuf_util.h>
>   #include <drm/amdgpu_drm.h>
>   
> +struct hmm_range;
> +
>   struct amdgpu_device;
>   struct amdgpu_bo;
>   struct amdgpu_bo_va;
> @@ -36,6 +38,7 @@ struct amdgpu_bo_list_entry {
>   	struct amdgpu_bo_va		*bo_va;
>   	uint32_t			priority;
>   	struct page			**user_pages;
> +	struct hmm_range		*range;
>   	bool				user_invalidated;
>   };
>   
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
> index d371000a5727..7f9cedd8e157 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
> @@ -910,7 +910,7 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
>   			goto out_free_user_pages;
>   		}
>   
> -		r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages);
> +		r = amdgpu_ttm_tt_get_user_pages(bo, e->user_pages, &e->range);
>   		if (r) {
>   			kvfree(e->user_pages);
>   			e->user_pages = NULL;
> @@ -988,9 +988,10 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
>   
>   		if (!e->user_pages)
>   			continue;
> -		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
> +		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
>   		kvfree(e->user_pages);
>   		e->user_pages = NULL;
> +		e->range = NULL;
>   	}
>   	mutex_unlock(&p->bo_list->bo_list_mutex);
>   	return r;
> @@ -1265,7 +1266,8 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
>   	amdgpu_bo_list_for_each_userptr_entry(e, p->bo_list) {
>   		struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
>   
> -		r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
> +		r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
> +		e->range = NULL;
>   	}
>   	if (r) {
>   		r = -EAGAIN;
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> index 111484ceb47d..91571b1324f2 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> @@ -378,6 +378,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
>   	struct amdgpu_device *adev = drm_to_adev(dev);
>   	struct drm_amdgpu_gem_userptr *args = data;
>   	struct drm_gem_object *gobj;
> +	struct hmm_range *range;
>   	struct amdgpu_bo *bo;
>   	uint32_t handle;
>   	int r;
> @@ -418,7 +419,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
>   		goto release_object;
>   
>   	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
> -		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);
> +		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages,
> +						 &range);
>   		if (r)
>   			goto release_object;
>   
> @@ -441,7 +443,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
>   
>   user_pages_done:
>   	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE)
> -		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
> +		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, range);
>   
>   release_object:
>   	drm_gem_object_put(gobj);
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> index 76a8ebfc9e71..a56d28bd23be 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> @@ -642,9 +642,6 @@ struct amdgpu_ttm_tt {
>   	struct task_struct	*usertask;
>   	uint32_t		userflags;
>   	bool			bound;
> -#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
> -	struct hmm_range	*range;
> -#endif
>   };
>   
>   #define ttm_to_amdgpu_ttm_tt(ptr)	container_of(ptr, struct amdgpu_ttm_tt, ttm)
> @@ -657,7 +654,8 @@ struct amdgpu_ttm_tt {
>    * Calling function must call amdgpu_ttm_tt_userptr_range_done() once and only
>    * once afterwards to stop HMM tracking
>    */
> -int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
> +int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
> +				 struct hmm_range **range)
>   {
>   	struct ttm_tt *ttm = bo->tbo.ttm;
>   	struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
> @@ -673,10 +671,6 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
>   		return -EFAULT;
>   	}
>   
> -	/* Another get_user_pages is running at the same time?? */
> -	if (WARN_ON(gtt->range))
> -		return -EFAULT;
> -
>   	if (!mmget_not_zero(mm)) /* Happens during process shutdown */
>   		return -ESRCH;
>   
> @@ -694,7 +688,7 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
>   
>   	readonly = amdgpu_ttm_tt_is_readonly(ttm);
>   	r = amdgpu_hmm_range_get_pages(&bo->notifier, mm, pages, start,
> -				       ttm->num_pages, &gtt->range, readonly,
> +				       ttm->num_pages, range, readonly,
>   				       true, NULL);
>   out_unlock:
>   	mmap_read_unlock(mm);
> @@ -712,30 +706,24 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
>    *
>    * Returns: true if pages are still valid
>    */
> -bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm)
> +bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
> +				       struct hmm_range *range)
>   {
>   	struct amdgpu_ttm_tt *gtt = ttm_to_amdgpu_ttm_tt(ttm);
> -	bool r = false;
>   
> -	if (!gtt || !gtt->userptr)
> +	if (!gtt || !gtt->userptr || !range)
>   		return false;
>   
>   	DRM_DEBUG_DRIVER("user_pages_done 0x%llx pages 0x%x\n",
>   		gtt->userptr, ttm->num_pages);
>   
> -	WARN_ONCE(!gtt->range || !gtt->range->hmm_pfns,
> -		"No user pages to check\n");
> +	WARN_ONCE(!range->hmm_pfns, "No user pages to check\n");
>   
> -	if (gtt->range) {
> -		/*
> -		 * FIXME: Must always hold notifier_lock for this, and must
> -		 * not ignore the return code.
> -		 */
> -		r = amdgpu_hmm_range_get_pages_done(gtt->range);
> -		gtt->range = NULL;
> -	}
> -
> -	return !r;
> +	/*
> +	 * FIXME: Must always hold notifier_lock for this, and must
> +	 * not ignore the return code.
> +	 */
> +	return !amdgpu_hmm_range_get_pages_done(range);
>   }
>   #endif
>   
> @@ -812,20 +800,6 @@ static void amdgpu_ttm_tt_unpin_userptr(struct ttm_device *bdev,
>   	/* unmap the pages mapped to the device */
>   	dma_unmap_sgtable(adev->dev, ttm->sg, direction, 0);
>   	sg_free_table(ttm->sg);
> -
> -#if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
> -	if (gtt->range) {
> -		unsigned long i;
> -
> -		for (i = 0; i < ttm->num_pages; i++) {
> -			if (ttm->pages[i] !=
> -			    hmm_pfn_to_page(gtt->range->hmm_pfns[i]))
> -				break;
> -		}
> -
> -		WARN((i == ttm->num_pages), "Missing get_user_page_done\n");
> -	}
> -#endif
>   }
>   
>   static void amdgpu_ttm_gart_bind(struct amdgpu_device *adev,
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
> index 6a70818039dd..a37207011a69 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
> @@ -39,6 +39,8 @@
>   
>   #define AMDGPU_POISON	0xd0bed0be
>   
> +struct hmm_range;
> +
>   struct amdgpu_gtt_mgr {
>   	struct ttm_resource_manager manager;
>   	struct drm_mm mm;
> @@ -149,15 +151,19 @@ void amdgpu_ttm_recover_gart(struct ttm_buffer_object *tbo);
>   uint64_t amdgpu_ttm_domain_start(struct amdgpu_device *adev, uint32_t type);
>   
>   #if IS_ENABLED(CONFIG_DRM_AMDGPU_USERPTR)
> -int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages);
> -bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm);
> +int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
> +				 struct hmm_range **range);
> +bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
> +				       struct hmm_range *range);
>   #else
>   static inline int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo,
> -					       struct page **pages)
> +					       struct page **pages,
> +					       struct hmm_range **range)
>   {
>   	return -EPERM;
>   }
> -static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm)
> +static inline bool amdgpu_ttm_tt_get_user_pages_done(struct ttm_tt *ttm,
> +						     struct hmm_range *range)
>   {
>   	return false;
>   }
