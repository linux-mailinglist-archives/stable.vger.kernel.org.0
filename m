Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE2E6E4C55
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjDQPDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjDQPDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:03:51 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D2710D1;
        Mon, 17 Apr 2023 08:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJGcWhaXe0/nWaRNmTrGhZr8DY+A5r12yAGpsteAR3CijWDzKEME0dM1A5tVbiS5/uJTHdIyY6nPlQ10ZCmj59C1pp5RMmzNe7KqVGdzIJb5uD7mMpjN7bzehMsyM46B3voFya41TRsU210e3siasJf22cVeFADQF8rLjwvuRLa5/ZXi3CIqp4ihjma+Igdod3LMoi6INorAikMbUIJ5lrZF5s4u2RrCScjjC6hWV+2lHd23HuVF4h9yGPQGCkXyZJcxZV938e5eOI/7P5Ip6ny+PW5v1foqdgrsNFMTsaMBpR3HzuBJvOf2aVjNQtP5Ki8t102g2mZ7yxJJ/xSe9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wu7HjSxtXrkK2pHfeB1SR5VtxUZcv3Npym/w9RlFkSc=;
 b=RnCk2ar3VNGXAmifOn9NAVzOgu7KYn1oHAvSozqFTnvlv3AfcsSRHd0NZ3gPIIh9HA9y6edXgsRWtsgyta0NVUVwOTNxjgcuV+d7uUa9ixVz8XmP4P3Fdw2aY9EQ1dW8a4x0NwLmlUJrcj8jZUR6fDhVw4PlWJWA5kNOL3XO0pJfS+k0V2s7s5z6rLMOyOotVPNz2FzBaaTBl38g6E4Xn8G0pqXaBFBnTlCnk8j3RVBfM628p55cIiN30kki+5qzvUQhIj8bb3I0asGM48EXuX0XwlXr8F1wxhR/qQTw6OCF2yEM2A4ZEkjDL6Wgf+vjS/ShoqaY977sEpTb/hjV4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wu7HjSxtXrkK2pHfeB1SR5VtxUZcv3Npym/w9RlFkSc=;
 b=iMKO3ytldDY138GZJLze1geISfAa9dDwpy4EljvU8fqrRFiBLc2KVSGgMKOuHJEA4wU74sNhblLgxtCODFdld0sQRvKjDlw+i5tAf3XU/Snr/pg4mjKOPJkNDJygp7geUVe+1X8LzbRrbFaTsx89LC+3xXMnGzN7QAGBg45Es+E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by SA1PR12MB8860.namprd12.prod.outlook.com (2603:10b6:806:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 15:03:41 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed%3]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 15:03:41 +0000
Message-ID: <d9fd286d-7f06-be80-7b81-b2aa2c074f1f@amd.com>
Date:   Mon, 17 Apr 2023 17:03:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
Content-Language: en-US
To:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230414193331.199598-1-hamza.mahfooz@amd.com>
 <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
 <23ebe744-bd4b-c411-99f1-c4ae9dc132f7@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <23ebe744-bd4b-c411-99f1-c4ae9dc132f7@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0029.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::16) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|SA1PR12MB8860:EE_
X-MS-Office365-Filtering-Correlation-Id: bc48c982-db76-4b19-c07e-08db3f54ee41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBY15VSWtGe/Sewee8A8WYrf2Za69Fga9sctutbOTAlcN71o4BPC6ndD4cEOquvcXMa2u7l44N02jjDffgD4bdxLlJOm14fqVX9BfmKsFjJeZpB583AKXefdRb5H9gF7R6kTDDFnTCaizHQQm7QzHUPA/fDmxtusMCGocJ8l1RO3KWN5CzrJbqWM+rpjULc3yceUHrI+F28v84zKtXbHAbSNNziJ1YaJWylGAj2T8xTDPe0yxquxYv9S6iMdyl2mcBHQPC20i7KrbW2kdRF744M4cgDX8bPHHU13+0iNwKCgcIHGn8EvFRSyXi4weAF3l/9+70ogEAIIyopDlNk/iFYuy1+LMt1jJJ35nKllIJyywujA0EKw6MKMKyPH6hTDCQlLLIL/FdfIXeVV8xmmTQBpBHbphyoz11OPXf/fw3IdHu0O1qREGRTsGJH2d+Y7KN0iD+TqZ11nHZitiFKEC3efz/X5IJeGYcrEl2zgtTusRt7TpxJBUowPeTVWrwINVL9DAv8u0zOL0GRQJob759Did1vthGrl1pETReRw0GQNbMPY8bHb8sHJlCRiIcKF7EfwosiLB1vUkkvjhbOImBdwayv6BMAEBZaBRTybIzRvcf5FR7ckOveS/TSyfTM7gumVvG85yjCQfQa1euy2tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199021)(36756003)(54906003)(4326008)(316002)(66556008)(66946007)(66476007)(6486002)(478600001)(6666004)(5660300002)(8936002)(8676002)(41300700001)(2906002)(86362001)(31696002)(38100700002)(2616005)(6512007)(6506007)(186003)(53546011)(83380400001)(66574015)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1JWUWd6RVVVeTJqS1hlajZmMkNGd0kzS3pPKy9odUVHQ2c0YzY2VHBESWMw?=
 =?utf-8?B?UWQ3ZlhjVmpJNnRlbCsrbFg2cFkzdjlXNlF1YjA4Q1pQRUgxQVg0SE4zVHBa?=
 =?utf-8?B?M01FMnYwOGlVUFJISjYzTUd4a2VUVWlyK0dER2lJblV6KzUrUUhpdFI3L0F3?=
 =?utf-8?B?dERxUzBReEx0VENKQzFJaFc1MHZkc0E5dVA4VXVqTzh5REUzSndWZ3hieHl5?=
 =?utf-8?B?N0c4UTRGT25id1RobUcvQ09CRnI3QXpoeHpYY1lOb05hODdySG5Xc092UERC?=
 =?utf-8?B?QWhYTE0xQmJsU3VmVnZFeGJVckZoY0RSSDZId1hpdEZlQ2s2bmFRWSs3c0F2?=
 =?utf-8?B?S04rN1pGcU9vNC9objBtbGduY3NMSi9laTcyb1lMSVFJejYwRWdjZkN2Y1Z0?=
 =?utf-8?B?MkdadWtCU0cwVWVyUEkzTXF6RHVkbk1jdFVCQ1dGK2k1T29jZlBzR0JiajZs?=
 =?utf-8?B?R0hSVWtDRGt5MUFMdWZYOTJJakdSd0xBQTk2Q2NveHhqVmhCeVlZV1FSNFJN?=
 =?utf-8?B?QzZmUndLMXdZL0ExcGV2bU5lRU1ZRUJmdTdiajMwTFdFbHVaR0lMdVg5elpr?=
 =?utf-8?B?aUI4YmxVZWVqS3F5T1I2T1BPT3RFTm4wdmQrVUZJRTJGK2xXd2YyVkNBSFF4?=
 =?utf-8?B?TUFEbkczTjJIeHlJdVZkZ2JLQU8vYS8yelBiTWRnRStleG83U0lnYjNsOUxv?=
 =?utf-8?B?U0liMGhlcVdEbmhicUl6dy9xVzRMNkVwdGh1U2tQb3VZdm45cGVFdlMxQnlm?=
 =?utf-8?B?MHU0RnAzbUd0VzZ1RGdBM0hWVUdxbVFUcnJON3hYZndwOUNTU0pnZGVjc2tJ?=
 =?utf-8?B?SnBnalBTYzlObmJSZ1BGY2ZMUTRZMUUrSnpjT0ptMzRFUDlGbDhMOE0rNjBQ?=
 =?utf-8?B?RXB3REJPRlJCZWk2TGNXUWlTR0lYQUk3em1HTU96QlZiY0MrTkxFNHJNTGtL?=
 =?utf-8?B?c29FUU14NVJONFVoSkRTRmpPOHBiaHZPR3BqZ1JjOUpBTmRLQ0RUVXZXUllP?=
 =?utf-8?B?SldoZHlSRG10NU01OVdyNVRxbUxlZ3dKZHVoTUZXZUlNQ2R2K1dTVWk1dC93?=
 =?utf-8?B?Q1NvcmpCRm9zU3krTUdlcnVFNFh3NWQ0NmdsQWJlTzZGUGpYdWg0QVhXcXZl?=
 =?utf-8?B?VmtxSVN4enpqYTJrL3dSaXptd0lTVE1Ta2FVVkEwVmxiNjZUbUc4Y1pvTlU1?=
 =?utf-8?B?UzdLRnlqRlEyTnkvZFRtVmFlWVFSa0I2bEE5MDUxLzlsL285ekJ4Z0UvLzZG?=
 =?utf-8?B?T2pyZ2k3a3JQSytyZUg3QXUzbWFoTG04MG9tbllkVEZ1R0U0VHBVNjhJaFFi?=
 =?utf-8?B?aVBSNlR2K3R4RlVkcVRXMW1BeUFOdk5oMm5Dd3pGUVZ0cEkwNTBtOTJJaVl6?=
 =?utf-8?B?VTFmREJGWDBZSWFvZ2JEVTA5RHRTZ2NieDlhdllFSHZ0WW9zRzRQdzNaMkZZ?=
 =?utf-8?B?NFROTmJveGtlc1c4SEVFQ3A3cFpNRFRjbU1OKytvZ1pEVnR5RVBQTUdSRUV3?=
 =?utf-8?B?Mi9OUUZMN2xXSlFPMWs1dm9lT2Z0TFc2NXEreEl0T1V2NkpselpJS3FvZGdT?=
 =?utf-8?B?SXVXSEhhemx5WWhydXBEY0pJV2NPVXBlSFFsaVF2RDJmY3FCWFVENUV1ZHpU?=
 =?utf-8?B?dCtUbXlIZjZtT25GVjVzdFVVdFlzK0VDQ0hZZU9TOXNZbDhKOWRmK0VGUmNN?=
 =?utf-8?B?YUphWkMweG9jZFUydllnV2VsYWJYWjlCb25JelpIT3krSUNNYnZETzVZbXAw?=
 =?utf-8?B?dWZwelhpYVhwRE1iMVRNYWRoNVVFRWFnR3hHKyttelc0emFraXNUeU41c2Ra?=
 =?utf-8?B?SlZ5WkZrN09oU1l0eVFGWTkzUjQrbFdSQlNlQ3htMWZzWTBXcGt5SFlTenlo?=
 =?utf-8?B?MzBUZm04Y05vK05GcWVsUlM5UGNYK3hKckg0VW9vOTRVYnJ3WjBVMXZ2UEd5?=
 =?utf-8?B?OWxJR29VaW0zdW9HU2JrT2ZYTVdZclc0WXEvY3hKTnI5UGxEOU1EcFVsNWRV?=
 =?utf-8?B?eE5aUzlSNUR0cTZsaEw4QmQyMjc0VmUvOXhSMlo4STI1V3BWS2lkWXkwR2Rl?=
 =?utf-8?B?MFhobm9iNXBhY044bmFLNjk4WkFXTmxYNFl1YVEyMFpDSko1dFlQby9Yc1cr?=
 =?utf-8?B?TS91VCttWHlrWE5BaWFFZitOVUxYZ0tUekpPR05ueW80bkRlTC9CYk1xcWQv?=
 =?utf-8?Q?T2ljvxqridgw3PqhMNkVTTMVuhSeP5eQPoaDQT/nc4JQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc48c982-db76-4b19-c07e-08db3f54ee41
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 15:03:41.2819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETYVTlHReDbwvrlKpZpEPH5SpPmEeOQ7nkMkgvQDbAfIHuwoPrDJNivhK5n46/Ao
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8860
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 17.04.23 um 16:51 schrieb Hamza Mahfooz:
>
> On 4/17/23 01:59, Christian König wrote:
>> Am 14.04.23 um 21:33 schrieb Hamza Mahfooz:
>>> Currently, we allow the framebuffer for a given plane to move between
>>> memory domains, however when that happens it causes the screen to
>>> flicker, it is even possible for the framebuffer to change memory
>>> domains on every plane update (causing a continuous flicker effect). 
>>> So,
>>> to fix this, don't perform an immediate flip in the aforementioned 
>>> case.
>>
>> That sounds strongly like you just forget to wait for the move to 
>> finish!
>>
>> What is the order of things done here? E.g. who calls amdgpu_bo_pin() 
>> and who waits for fences for finish signaling? Is that maybe just in 
>> the wrong order?
>
> The pinning logic is in dm_plane_helper_prepare_fb(). Also, it seems
> like we wait for the fences in amdgpu_dm_atomic_commit_tail(), using
> drm_atomic_helper_wait_for_fences(). The ordering should be fine as
> well, since prepare_fb() is always called before atomic_commit_tail().

Ok, then why is there any flickering?

BTW reserving a fence slot is completely unnecessary. That looks like 
you copy&pasted the code from somewhere else without checking what it 
actually does.

Regards,
Christian.

>
>>
>> Regards,
>> Christian.
>>
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible 
>>> (v2)")
>>> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
>>> ---
>>>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41 
>>> ++++++++++++++++++-
>>>   1 file changed, 39 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c 
>>> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>> index da3045fdcb6d..9a4e7408384a 100644
>>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>> @@ -7897,6 +7897,34 @@ static void amdgpu_dm_commit_cursors(struct 
>>> drm_atomic_state *state)
>>>               amdgpu_dm_plane_handle_cursor_update(plane, 
>>> old_plane_state);
>>>   }
>>> +static inline uint32_t get_mem_type(struct amdgpu_device *adev,
>>> +                    struct drm_gem_object *obj,
>>> +                    bool check_domain)
>>> +{
>>> +    struct amdgpu_bo *abo = gem_to_amdgpu_bo(obj);
>>> +    uint32_t mem_type;
>>> +
>>> +    if (unlikely(amdgpu_bo_reserve(abo, true)))
>>> +        return 0;
>>> +
>>> +    if (unlikely(dma_resv_reserve_fences(abo->tbo.base.resv, 1)))
>>> +        goto err;
>>> +
>>> +    if (check_domain &&
>>> +        amdgpu_display_supported_domains(adev, abo->flags) !=
>>> +        (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT))
>>> +        goto err;
>>> +
>>> +    mem_type = abo->tbo.resource->mem_type;
>>> +    amdgpu_bo_unreserve(abo);
>>> +
>>> +    return mem_type;
>>> +
>>> +err:
>>> +    amdgpu_bo_unreserve(abo);
>>> +    return 0;
>>> +}
>>> +
>>>   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>>>                       struct dc_state *dc_state,
>>>                       struct drm_device *dev,
>>> @@ -7916,6 +7944,7 @@ static void amdgpu_dm_commit_planes(struct 
>>> drm_atomic_state *state,
>>> to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
>>>       int planes_count = 0, vpos, hpos;
>>>       unsigned long flags;
>>> +    uint32_t mem_type;
>>>       u32 target_vblank, last_flip_vblank;
>>>       bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
>>>       bool cursor_update = false;
>>> @@ -8035,13 +8064,21 @@ static void amdgpu_dm_commit_planes(struct 
>>> drm_atomic_state *state,
>>>               }
>>>           }
>>> +        mem_type = get_mem_type(dm->adev, old_plane_state->fb->obj[0],
>>> +                    true);
>>> +
>>>           /*
>>>            * Only allow immediate flips for fast updates that don't
>>> -         * change FB pitch, DCC state, rotation or mirroing.
>>> +         * change memory domain, FB pitch, DCC state, rotation or
>>> +         * mirroring.
>>>            */
>>>           bundle->flip_addrs[planes_count].flip_immediate =
>>>               crtc->state->async_flip &&
>>> -            acrtc_state->update_type == UPDATE_TYPE_FAST;
>>> +            acrtc_state->update_type == UPDATE_TYPE_FAST &&
>>> +            (!mem_type || (mem_type && get_mem_type(dm->adev,
>>> +                                fb->obj[0],
>>> +                                false) ==
>>> +                       mem_type));
>>>           timestamp_ns = ktime_get_ns();
>>> bundle->flip_addrs[planes_count].flip_timestamp_in_us = 
>>> div_u64(timestamp_ns, 1000);
>>

