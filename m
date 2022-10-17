Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C70160064B
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 07:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJQF3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 01:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJQF3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 01:29:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFA965DF
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 22:29:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONVbW1ub4vtPgWmcYLJOW3mU+9bL+RJwTce1wwC6xu8fq+775aW8oeduX4c1tHKan/+GLd3Pk7/E6qCvqKfvC/zjSPOg9NuT3KSeQFbzMWdQxz6jiGhdspv6Yw3N7tGH9kFVmJWOlTIrY32xKeyfybCU/Pg4fVixqZhVMl9P+BDk/rde1yVI2P5a/MkDq+XkzA//XR/N9bzw77iw4GD5NCOv1SQoJyuLzv9V7dBbzkRD91wrwSpDCYHr8sHwoAvlsajPglCFsHQhr1R+OjSjTtijE0/irKR3qXiEXHGy6qlm2jX3+BAB8fOZbq5nmciGy77q2P9u15/tS08xp51CTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTIKth8+JGg6scxeJIUhchYkOv9EEHw3Pifrysk+iMg=;
 b=QuKvHP7mApBFxn5s4qnalEA2pq6r9wLravevkl+LYj/hAXE6Cm36IUrIeT8RL+zHa0KURSwKYbCuU12Rc1HdSLtxbQxfjRF0BGs+e28da4KG4/pdpxDP5EgHjWmjy5KEK3JYEpEtdvoRYReMIgqJa6NTKtBQD4wAIaGprFn/n3quNpmxxLphndokURG9AjxgBny2Lq31GPRCub+TM8XWGVKs+VdUnLiWSIcUodD8zJyWa0NY9O7aFd7o4y410v3kUkPQdG3klNR16qzHY+dxn3w3a82q3T3fEY2se9+s4YNU63fsYR7+dmROpehl0AY36FT4UjpLAPZ/l+Ay1Sq3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTIKth8+JGg6scxeJIUhchYkOv9EEHw3Pifrysk+iMg=;
 b=Gf+hj545xtBSI0b9I2p82WMEhIjoYm2oX5EAtjf0m7Yz3EqVmn+MpgJ71syzCJDXsNZQhVo+YL/WylkvAbmHKGh9JCK7DkKLETxEgbB8oK4tMLa2CReyJCmct6UTlDBKwZt2nNXcQoNkLXrnBNcwrewN9Ld6qjOkb+r/q0YBUd0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) by
 DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Mon, 17 Oct 2022 05:29:32 +0000
Received: from DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425]) by DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425%7]) with mapi id 15.20.5723.026; Mon, 17 Oct 2022
 05:29:32 +0000
Message-ID: <fd55eef9-1ce1-3f4c-d6ff-a5a230828b8e@amd.com>
Date:   Mon, 17 Oct 2022 01:29:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 2/2] drm/amdgpu: use DRM_SCHED_FENCE_DONT_PIPELINE for VM
 updates
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
References: <20221014081553.114899-1-christian.koenig@amd.com>
 <20221014081553.114899-2-christian.koenig@amd.com>
Content-Language: en-CA
From:   Luben Tuikov <luben.tuikov@amd.com>
In-Reply-To: <20221014081553.114899-2-christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT1PR01CA0042.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::11) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|DM6PR12MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: cddf67d1-d235-4493-00b6-08dab00091f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+ik2bjmWC0QjOdPecfGtsgsTu/OFi3KTk+Vg1KCNyHLZsPKAfp4TJ0pE6W8kiMxmq3NB5nS8HjcqoHa+b0091pDSxIlt2e/ruEHhg1f57pg2Y6URz2f3X39gf7V9wAMU1OgjPZRjJXEatgggqZoSi/c92u+F3B/p5CkLDGC8a5WRJn6sZCaliLS0bmA4pZp3ya/fzkOLQfcjmYTtLVDLoqlR2unNS0IEsrdeaxpcINAshCc/sregDm5ojAPWfZCEF4Q3rX2oIanrY1qL9OZy/7XyKziA2zXWlK1/ZOK26gVa+AtgZWMxXoM5UofINKWU9rjXVeT5AQQyN40Jch2ukPLBjnvYjAbZAIulLosIEUp7awJ4YrirhlUmGMvm8keGc10lGtvOVeT4abZ0MG5rwjy1OXoYl+GfolizCc54DLz6TlZMIIf/LJQ4AeiAjxnf0wNIrwiiq/z26DWDkEwUSxeIj21Consf+iRswhUonun7SyWb2tzrbGizLbN1s9U6+et59uXCEC1cLeQsXL+XjDYmToV5ST4y1KNIq/KXK5aTIgr78GW6y1b4aQnhv3FofT3co0BsypMw5PpaOqGgroee+TxTiP5FD+egIIJsnD1/a81y27BXzVwn1eVbcUn6HhN5ZIGOjgQMElT/f/qOFLLhfRtn8ctNFEldrNKR+EoOAuqqHsTSR0EcqwLO7dUWxco04r6KM4WvGaUSSUGEZ/86YU4k78ArwiGVLrSDZcJFozPWg+LTg3d4RPW2cnt0XIsEzWJEKYq9Sn9Ab3jfnwgzsyb3b41THNi7ZJXl+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(31686004)(38100700002)(8936002)(5660300002)(44832011)(66574015)(83380400001)(31696002)(86362001)(26005)(6512007)(6666004)(186003)(2616005)(478600001)(6486002)(316002)(4326008)(66946007)(66556008)(66476007)(53546011)(41300700001)(8676002)(6506007)(2906002)(4001150100001)(15650500001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVF6b3E2UnBYTVpNd1FtRlRJc21ZdENlRDNMVTRmNUJtaXM0MGNEa0xOeGJ0?=
 =?utf-8?B?QkhQb21Ecy82bUFDRFRXZGR5c25xMk1WR0JTZ0N6ZHo0OFRKUzBrRE5WbWRv?=
 =?utf-8?B?U2NEQWNLZXgzRmZIaEdMYkJWanNJUStkWkl4YWlweXM1MElONnJ1SW5xNmcz?=
 =?utf-8?B?ZjdyUktVaGFPYXVLb3d6WTJ4WDBIb0tsWXN1YXpEdTl1aVh0STJvaWloU3hX?=
 =?utf-8?B?ZlhyMENyR2wrWi9yci9UakhQcnlwVEFnZk5mN2JKMndZODl3dFZjWkRsbFVE?=
 =?utf-8?B?VXVSNDdlWDJWdFJzZjY3WmMyUXpXZkJHR29NQnN0N3hZTEtWU1VPVmwwSTQ1?=
 =?utf-8?B?bGFnaktOQUhIRmc4UEVtU0JjZGREVU9aSm53b1hIM3IwMXF6S0VHYjdEdkZU?=
 =?utf-8?B?UGU2cGtvRTlQd2NzV0hybVlCcVFJekpEbHN5K0lub2tJb1Jpd1pxaFVuZE96?=
 =?utf-8?B?alBmQXBvL1QrMEg1VUxXQXlxcENFZ0F3NkZiWWJSQzRFQXFVbTJnUWF5K2FI?=
 =?utf-8?B?WEh6bU4wRmFJSUM1VlBZN2M2bysvbnV4bWE1aTdiVVZqQnphNVh2bzc5N2ll?=
 =?utf-8?B?YnloTUN5b01WbTJZRmJ3UzRBMlZEVThpNlNDdWo1aFk4bFhMS2lTek1xaDhN?=
 =?utf-8?B?cWNHVVhGSHVoRFhaSmNIamJGcnd6OC9YMTFCZ3VrWkV2ZmhLOGFHdVdtVko1?=
 =?utf-8?B?UERuN0hqU3hiYnNRZG5oOE5DeE5uQ0x5Sno5UGJnTTdmM3lMcDRwcjROc29I?=
 =?utf-8?B?Z0hUQWdzWmJmZnlXbkgrOS9TdUFvaVk1NGhuamU4TEV2VUpya3psakZSS1Vn?=
 =?utf-8?B?b2pDMUV2TkVabk1nMVZlMzRBZWxxdlFrcTl4QmRXVE1VUjY3VkRNWmthRnFK?=
 =?utf-8?B?RFhRVVZSaGpJKzhvcDNUeDFMVEppOXg2V3ZnSG8xTG8xME9kWjY5Vk5sOGNi?=
 =?utf-8?B?YTBsdkUxYzV4b0ZBSGZvKzMvQi9INlNRRzBRKytIWXJLTjdmZzFCendCVC9p?=
 =?utf-8?B?NFQ0bEdUMHRUZ2x4ZGFWTEdlbXQyVDZsVmJkUEh1dllxTmZSMVhWdUFLZmsv?=
 =?utf-8?B?Y3pWYzNUcEFDZjhwZXhzOUpXQU1MTEkzZjlxdjBpTXdYYUNZM0dtSktVdHhr?=
 =?utf-8?B?VXp0R1E3ZDNrMTkzL1dyaDhZN3EyZ0Y3M3R0WG5ycjVYRjBsRTl2TnVpbTRq?=
 =?utf-8?B?QkYwYVUydkJmWkFsd29BR1lVMVd1VFowNStocy9zdVZNLzZOQ2kxWFh5WXZL?=
 =?utf-8?B?aU4vRkVQOWZCMmJGSXJmNVR2Y1NhaFJqRnUrTXNjek5DSlpBOTR0V3BqK0VC?=
 =?utf-8?B?TnFUYVpLKzgxTVpuWVBCcWdEV0VBRTlzVXc1K0RoaUJjMGdyT2xaUE0xdVRq?=
 =?utf-8?B?VVd6cUViWVpsSUVoa3NVVHVZWVN2Wk1yUmZ6SGVWSGg1L2RMQitNYU41cWhx?=
 =?utf-8?B?ZWI2TGNCdWtnWDlJNHYweEpiZlJYa01ua0dYbU5oOXNLVE0vQ0dhbi9SRm5t?=
 =?utf-8?B?bUgxMHU0ankyTTY4Zk9Qd3VFL1JJM2NwUittazB5TmowM1g0ME9UdkpDV2RE?=
 =?utf-8?B?bno0aUhVK0taNzZlQ0JuRWxvYURpYjl6MFFkMzBYeVdUeFE4SmFLQTNjbXZ4?=
 =?utf-8?B?NTk0aGZQUzBjWVV0a3dHS1VRRUdqcWcvWEhZSjg0MFdiMk9WWjhiOXFtN2F4?=
 =?utf-8?B?ZzRINFlRcEoyKzFrOUd3Qjl4UHoxMFAzM0dtOXhyTWJ6aFM3ZFVDNzJQajN1?=
 =?utf-8?B?UThNQWhKUmtVQ2NGZ3h0d1pvWk1na1BOKzRQL0MvK01mbzZLbmdqZCt0d3dt?=
 =?utf-8?B?T1Y2LzNWWXFmL050clRSM0pBOXFkZWFDL2l2WDErT3hDRGlXMDM1SGlLUUx3?=
 =?utf-8?B?eWpERjlDVXlxbzZkcTZPcnU4Qkh0SSt4VDB4OENuUDg0UXI2bjN2WTlScHFQ?=
 =?utf-8?B?VkM1Q1VqdVZwekF0WEZOT25BVHFnRnUwenlWOVdqQXFTNmRQb3hKV2o5RkFU?=
 =?utf-8?B?SzF0VVNMRDFjQzluNVR5VkFoTHM5aC9YQURMZVM4NStNTDViQXAvR0F4MjM2?=
 =?utf-8?B?Yys2Znora3kzdXByUmFkOWJHZzMxaDlVV1VsZFNjNUxVbGhFeURvU1phcDBM?=
 =?utf-8?Q?msMLj4yVBsqrG5TUv7C/kuxKf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddf67d1-d235-4493-00b6-08dab00091f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 05:29:32.3865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WN1YjMsIEOdJo7FX+m6jjDtB0IaxO38UZMvgkMhIaw/heROp+tHPqoGTHmWBc0fK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christian,

On 2022-10-14 04:15, Christian König wrote:
> Make sure that we always have a CPU round trip to let the submission
> code correctly decide if a TLB flush is necessary or not.
> 
> Signed-off-by: Christian König <christian.koenig@amd.com>
> CC: stable@vger.kernel.org # 5.19+
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
> index 2b0669c464f6..69e105fa41f6 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
> @@ -116,8 +116,15 @@ static int amdgpu_vm_sdma_commit(struct amdgpu_vm_update_params *p,
>  				   DMA_RESV_USAGE_BOOKKEEP);
>  	}
>  
> -	if (fence && !p->immediate)
> +	if (fence && !p->immediate) {
> +		/*
> +		 * Most hw generations now have a separate queue for page table
> +		 * updates, but when the queue is shared with userspace we need
> +		 * the extra CPU round trip to correctly flush the TLB.
> +		 */
> +		set_bit(DRM_SCHED_FENCE_DONT_PIPELINE, &f->flags);
>  		swap(*fence, f);
> +	}

Do you ever turn that bit off?

Regards
Luben

>  	dma_fence_put(f);
>  	return 0;
>  
