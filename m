Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66D163E9F1
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 07:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLAGjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 01:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiLAGjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 01:39:42 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76C566C83
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 22:39:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlCohbzywjsuu52hlLw1dWop1/CgpTksPGWKZlHua9MDiVsOIkD5kJ2Q7wDYyhwjbrwXDt0ncFRFFgJqvIzDzP8nbYdQFTdm3bf6ScTGsU68O/LOE1jztpT4d0+1GxLkBz5+Y1OD4LGlnj95gFQu2QkjiXbu99xO3V5LFcRdEGfRfplKj3wxUu6d1AaD9aBtv3GRvUHiU8YPTxnBVxdnYwF0thX3KIz9Ikoc5KLYWna+6dsdrSMSAStVLCK61tw7CEMmOeI0cIJZmtxPLSranUd6u3XZgIINnC+vkMHP2ruS8QuD6v+o3vkjogyBUOK3fE+WQ8CSibB2WV5kg3UYqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2XnOdePSgtZXXERsPH/fo9pDtzgfQlSMXp5WhjiQXQ=;
 b=nc/S9AJU5UzpZodzZXccPZ4RklRJqj8VR/bapAYWzZTX95SOupiPJKP7QhNXmlY0xigjmX9l26hWgvCQynqPocZZcdjqaQa/HxfQO2AEevrATLAumRaL9vn/7w60jepyOvS7Ih5nsBhwGbiFl66UaAPWOQmhYCy9vflyR3eMjAsce8c6w7TEVh0fJnE89dZyvNLjS6RpIiE+H/YR9EQBOpQSYj5qav05/fH2vop8vvcHxEBPnzYdbcwNbkGVuOnst55KlWxBwHB5oGhwYMQOJtlANhI6V0UfKlCgMazqpdQ7BpR+851cG5veIq+LxPKl0Iew4fEtiYRqqxlup1XQ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2XnOdePSgtZXXERsPH/fo9pDtzgfQlSMXp5WhjiQXQ=;
 b=sR64lR0qbhDjkPW+s1obqtWOXbsF6fo+2yndRvAnblS90JDoZp2wgfdQCuRW2Z92OIwcrztI357fn7k54bWSsl8uBdd97clepUjb2nXy7O7x/v5zNOmgFvTT5KsdUWgb9j8qFiYCJNcSUIrczge40qEi2NbMFA+Uhp+PO37qvBs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 06:39:40 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::bc0:e01b:6da0:9f24]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::bc0:e01b:6da0:9f24%4]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 06:39:39 +0000
Message-ID: <3a683d79-5526-6b3a-d770-5fa34592b940@amd.com>
Date:   Thu, 1 Dec 2022 12:09:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the
 s2idle suspend
Content-Language: en-US
To:     Prike Liang <Prike.Liang@amd.com>, amd-gfx@lists.freedesktop.org
Cc:     Alexander.Deucher@amd.com, Mario.Limonciello@amd.com,
        stable@vger.kernel.org
References: <20221201062242.979864-1-Prike.Liang@amd.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <20221201062242.979864-1-Prike.Liang@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0161.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::16) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4614:EE_|DM4PR12MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: 21a6ce8b-1680-4052-c5c3-08dad366d25c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z1tKjNA81/+Lziw8SaWt+4JD/LmthoJs39yfLiNgKLjviWXM3aGQMQ+8LqjvocfLEAlopdXxyphOOopIygwT04iShL0o7/Nd5OJ9EVTFma6v5vU1/2hP5f9m+1lFkc0Q7vlt2Lmn0GA5c1QEiMnOUOflsAJpqd1FgyZqaoEWI1loVflpFI/QIkapxozken9HNhQMHF8tMY5Q+XVpQ6vGbYblWPELQrkcv7AhVkkhU/n1zmdYfLH+IkhyJ1fvIflPbgXaZMsUI1gsiZXFgTt7PCDWjYX+Fu6EtiKj0QfSziWB4f99Yw6OwQNHPcxv2+8zgqwsfZJyM/lhlmO/TSO0pD3cqH94zhlwifcdQ598PkYoFsUY7gqvcYP8awwfWj1L572Jd4tbJh5lSEHX1cW6FiPi+3/kXLXXgbbWPb9smgyR05LIgluPi4wRbxoaGBEXm508HHIgI+URy2TmcmXOZEFdeQo83oT5xJ/8N1j3HMyGFrUIRcIGiUCvQ3j05bloggIzBF1AiL9hTUV8pfGbd4QGiAUj+5zDIvpJEGg4AzaGrfHR+FmUZsUl9k5pidxESBtCoc/NSlUepZnckjeFpCjAtvB/XHbvr0M0qxUgzyLNIXe0z4Fj4Zjts+l2v0pQij+Laq+zi4ot7ttIkEXmnRgw5w4bRdrByyh/VhnteKs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199015)(36756003)(86362001)(31696002)(966005)(6486002)(6506007)(478600001)(53546011)(6512007)(26005)(6666004)(5660300002)(41300700001)(8936002)(4326008)(2906002)(316002)(66556008)(66946007)(66476007)(8676002)(38100700002)(186003)(2616005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1M4WnBGSWFtRThKYTkvelNKa3RYcllaYzBmb1c2YW5TcWkvRlVTUnAyYzJ6?=
 =?utf-8?B?dVpsdmdxbEh5NUYrM1lSNE9iL2dFd3o2YmdpWVp0dzdzM2w3WDhJdW5xT1FZ?=
 =?utf-8?B?b1huRUJTUVJlREUxYU03Z0JmRlZEa3loUzZpU1J1b0U4TjZ5QjR4WENQdm43?=
 =?utf-8?B?Z1N2cjVJT2pwZzBHMzNRSGhHczhUcGxPWGt4TDBUZWhpYnprZE0zdHZ4K3VB?=
 =?utf-8?B?MmVSdXVXcDdCNlQ2bExQRmFWUnVFeHBGb2tWd1RQY244WWZ6NGF3cTcvNVg3?=
 =?utf-8?B?QjVIdjhEVHNOZnNXdXVpKzBKbU4vUkNuTG80QzZZM2daYXBxdm4wN2lYNmFv?=
 =?utf-8?B?NVNQVm1ZSEhuVzYyZXRDNFZKa0hZeVVzMTQ0L3RuRWNSaGRNblhaUE92R2xj?=
 =?utf-8?B?M25UaCtqK2xuVXczM0x5TVIxeHpubEpmdWhEYkNuQklraDJRdmgxTmhtcFFz?=
 =?utf-8?B?L2dDWnNYNGFFcWZlQzl6N2ZUdTlnNkJySzVtWDhZM2dYR2taZjcvN2FQNXAv?=
 =?utf-8?B?S0FaS3pPbGI5YktaYXFmSU1kQlVtRjc2d2JBNlZJVHBsd0hXREVHenlvUUFa?=
 =?utf-8?B?Q1NCdTVvQWZLS0VQK1RHbWIvUEovTTMzMy8wZ3JDaVh3bHAyREJleXJDYTht?=
 =?utf-8?B?TzJrbjBZWENqVUtURnBPcEJob3ZLZGlaYVo4S3l1djg0SW94Y1liL3l3ajdz?=
 =?utf-8?B?YVVQdTI4MHp2SWY3dTdBT3JGUCtjYnJKeWJCYWM3Qk91Y2xjZEtyYWNaRlc2?=
 =?utf-8?B?MkgyNVJkTXBrTUpVejhITzFjZmdnOU1XZHpSRjU0WXdGNFJ1NlRoOXVIUXVr?=
 =?utf-8?B?dXFRaGNESW5xWHQwdzlUTVFQOGxqdjc5c3c4U09RMSt1RmlZd0ROVlNlSFFo?=
 =?utf-8?B?TCtlSyt5S01Kbll4aG5leWxHRWJHbmxIakJ1enZIWUVKREpJWHp6NkxsSUhk?=
 =?utf-8?B?UHovcDhIVlpWYWFqWWZoQTRpTWdac1ZFeTNsbmJMUW1JQ0l2Qy9OVnNsMnl5?=
 =?utf-8?B?cXhwZi9mUE1HdnNpMWtwSnM5TmNrUzIxcnVnV25PZ1JaK0Y1ZFBLS0Z2RmEy?=
 =?utf-8?B?aDRuQzNXTVRCSVhpbEhRRG1vdGg2YnRoN2I5amxZTTZNQm5ad3Y2Q1dHOWZN?=
 =?utf-8?B?TGxKTGZrQmpkQ3Z1K29aNFVCVWw2Tmk0TStOYU5sSkNoVCthN21zZFNXdjds?=
 =?utf-8?B?RnhWaG8wK1hxN1kvWnpkV243YmFFNGxvaDRWTGoyVC9NL3U3Uy9qWDJ1SXZk?=
 =?utf-8?B?V0d4ZStUSDJjdVc5Wlk1a1dNaWY3OGdLTzlncWVITU5uVGFncUY2ZEsrNVI5?=
 =?utf-8?B?aHJEUURCRjNKakovSHd4eCtSQURCUThxQlNUU2N2SnVzSDI4S2VYUmphcHBW?=
 =?utf-8?B?aS8rZWRTNHZpbXlrUWtIRmhOMUorb3lvakJsRXhJVVhpR2lRTG96WEJJRWkz?=
 =?utf-8?B?d1lRd0pwZkszdlI2WkJLc0MxM25OS3YvMnowRHMrd0d0OHZYSkxmM01QeHJS?=
 =?utf-8?B?bW85djZxU0FCL0ZrL3lkeUJrUnh3ajhGQStEUWVUVkw2N2tqdVZJcmNOMkgr?=
 =?utf-8?B?cUdPcERsSkpXRE1yQ3VkOTZ1bGpBc0llU29DSmhEUUJDckZQL01ZUFErWGFI?=
 =?utf-8?B?bVNPUlpWSkVKU3JrK2ptcmVNZmlLdmlHZjBmNURJSGVnZmphTnJGM3lYcmtH?=
 =?utf-8?B?UVlEQlgxVy9EcHliRWVFV0dVdmJOajVtZklBa3B1SWxmaCtFSCtqRE9mcHJ6?=
 =?utf-8?B?Q2lOMlVaYVZSNEtVS3k3T1hueUtSWXFndHN4UEc4TmtZTWhrNXlJY1l1V0Nn?=
 =?utf-8?B?UnY0QVp3akQ3MXVtZDl1VUNXQzllR1lPWVkxL2RKTmN2VmF0ZEZrMUhJYXlO?=
 =?utf-8?B?TUMvWStkakdMY2E0L1BhNE9zL0dmS1FyRWJHTDFkM3BMVlNLdUZuMFJ3T3R6?=
 =?utf-8?B?Z0YwdVR1ekRCYVZ6Y0I1NHJsd1o5ZEMySXhzR2xsMHlrWTVNR1N2S2JIZzZv?=
 =?utf-8?B?NnZOL2IxYkVjUVhaUEVzV3pBYzVacnN2MW03MVg2Vkc1TDRzbUh6U09aRHhk?=
 =?utf-8?B?dUxWaU1ucmJsYXRNYTdBQ2QyL0VjeG0ydEVoejFYbHZoMkl2VmhDbWxjU0pR?=
 =?utf-8?Q?iY0fMrkplsU8dtJ4e9181nbhu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21a6ce8b-1680-4052-c5c3-08dad366d25c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 06:39:39.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzchyfl40EVqfbQxn95PLx+zzFl/jqHx2w9SflSYCrD7pn3T0dBzzLesqaC6Fnlv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/1/2022 11:52 AM, Prike Liang wrote:
> In the SDMA s0ix save process requires to turn off SDMA ring buffer for
> avoiding the SDMA in-flight request, otherwise will suffer from SDMA page
> fault which causes by page request from in-flight SDMA ring accessing at
> SDMA restore phase.
> 
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2248
> Cc: stable@vger.kernel.org # 6.0
> Fixes: f8f4e2a51834 ("drm/amdgpu: skipping SDMA hw_init and hw_fini for S0ix.")
> 
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> ---
>   drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> index 1122bd4eae98..2b9fe9f00343 100644
> --- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
> @@ -913,7 +913,7 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
>    *
>    * Stop the gfx async dma ring buffers (VEGA10).
>    */
> -static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
> +static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev, bool stop)

Better to rename as sdma_v4_0_gfx_enable(struct amdgpu_device *adev, 
bool enable).

Thanks,
Lijo

>   {
>   	u32 rb_cntl, ib_cntl;
>   	int i;
> @@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
>   
>   	for (i = 0; i < adev->sdma.num_instances; i++) {
>   		rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
> -		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
> +		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, stop ? 0 : 1);
>   		WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
>   		ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
> -		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
> +		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, stop ? 0 : 1);
>   		WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
>   	}
>   }
> @@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
>   	int i;
>   
>   	if (!enable) {
> -		sdma_v4_0_gfx_stop(adev);
> +		sdma_v4_0_gfx_stop(adev, true);
>   		sdma_v4_0_rlc_stop(adev);
>   		if (adev->sdma.has_page_queue)
>   			sdma_v4_0_page_stop(adev);
> @@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
>   	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>   
>   	/* SMU saves SDMA state for us */
> -	if (adev->in_s0ix)
> +	if (adev->in_s0ix) {
> +		sdma_v4_0_gfx_stop(adev, true);
>   		return 0;
> +	}
>   
>   	return sdma_v4_0_hw_fini(adev);
>   }
> @@ -1971,8 +1973,12 @@ static int sdma_v4_0_resume(void *handle)
>   	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
>   
>   	/* SMU restores SDMA state for us */
> -	if (adev->in_s0ix)
> +	if (adev->in_s0ix) {
> +		sdma_v4_0_enable(adev, true);
> +		sdma_v4_0_gfx_stop(adev, false);
> +		amdgpu_ttm_set_buffer_funcs_status(adev, true);
>   		return 0;
> +	}
>   
>   	return sdma_v4_0_hw_init(adev);
>   }
