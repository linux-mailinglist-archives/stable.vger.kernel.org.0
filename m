Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3318C62B7B2
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 11:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbiKPKVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 05:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiKPKUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 05:20:39 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007672AC73
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 02:20:19 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v1so29085446wrt.11
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 02:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fJd/kPZe8tht3PZNMtoqvoX2LQTRKzrqogvzeSuaPoU=;
        b=SBp78Dq4y2Emnd3ISqctjtnMRJC2dVxDfD1AQzTcZlXz89qzlXS7YvUGOHMr6zm8O7
         agSp9ywJ6qu9XmPz1raO4hSEV5iiLNIecA9UlT8nEx/gfoGBon884wIK6GssuXvIRtog
         iUbdWVb+piIyyR+/8imI7W4Ksn/mvFpVff13RzIhYLsnj29mqn8c2RW+SVTJ7ec5/lPh
         dM9eMhpjHy/bXkjIgrJp5kvSqECu0ixUqYmh8pw+hZRHcGBG4qbHvy9Ct3ia3YBM3wnj
         Z82g28B16IOcHnCegm7LJhmEoSNfixt9g0PhUsgKyQ6J6o32+BlO/OgUIAjh13dq9lng
         bn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJd/kPZe8tht3PZNMtoqvoX2LQTRKzrqogvzeSuaPoU=;
        b=QBEDXpI5fXFUfO79V3Q5e7ryuPYmFg2V8Amxdq9J6gIBX3I/1nYhj2dCyDt6WAAtRr
         20285U5V2f7h+grYn+En3bCgMslxT+Efjg7pHXdYTVdZbGxfutzL9SlYdhjPM8tmIpe8
         zfSb9iGXfn/MKlM6xoRzODMs7Lk6oV0Itfd/wXNSqEAFZj/2bxcsbkwm5QKLKmVArqb/
         xJxDE2GTR2sdhPmpytzC7yOrOoP/HMTdXyKxbM6i1E8i3LUSZicf76ZzeG0HR+xpWd8x
         rPcT6ei75InJw3Xr/KsvvCn1AoVI6rrFOLW5vP6wi19wU0vKLQucfEJeUcW0nAty5qhW
         LJTQ==
X-Gm-Message-State: ANoB5pkIHjW+hx6uXK08JDyGkeQN4gp2oPLu7TUHxDnj4jIDVaRBY3k+
        0O7Fun1TyiBpB9NsgF9WnQS6dojsqUk=
X-Google-Smtp-Source: AA0mqf6OcAlxfXV2/jDR+SQqtVt1cCRHsawBBL/P9JrtRlIYIfoo0OLHfK5G9ByODJUvBW6clfkqzw==
X-Received: by 2002:a5d:590c:0:b0:22e:3c69:f587 with SMTP id v12-20020a5d590c000000b0022e3c69f587mr13756212wrd.670.1668594018452;
        Wed, 16 Nov 2022 02:20:18 -0800 (PST)
Received: from ?IPV6:2a02:908:1256:79a0:a719:712a:c9e4:718d? ([2a02:908:1256:79a0:a719:712a:c9e4:718d])
        by smtp.gmail.com with ESMTPSA id bj19-20020a0560001e1300b0022cdb687bf9sm18304829wrb.0.2022.11.16.02.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 02:20:17 -0800 (PST)
Message-ID: <269dd660-2d81-169e-3a20-5bd648a62271@gmail.com>
Date:   Wed, 16 Nov 2022 11:20:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2] drm/amdgpu: Fix VRAM BO evicition issue on resume
Content-Language: en-US
To:     Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
        amd-gfx@lists.freedesktop.org, christian.koenig@amd.com,
        alexander.deucher@amd.com, gpiccoli@igalia.com
Cc:     Mario.Limonciello@amd.com, stable@vger.kernel.org
References: <20221116054721.1008253-1-Arunpravin.PaneerSelvam@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <20221116054721.1008253-1-Arunpravin.PaneerSelvam@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 16.11.22 um 06:47 schrieb Arunpravin Paneer Selvam:
> This patch fixes the VRAM BO eviction issue during resume when
> playing the steam game cuphead.
>
> During psp resume, it requests a VRAM buffer of size 10240 KiB for
> the trusted memory region, as part of this memory allocation we are
> trying to evict few user buffers from VRAM to SYSTEM domain, the
> eviction process fails as the selected resource doesn't have contiguous
> blocks. Hence, the TMR memory request fails and the system stuck at
> resume process.
>
> This change will skip the resource which has non-contiguous blocks and
> goes to the next available resource until it finds the contiguous blocks
> resource and moves the resource from VRAM to SYSTEM domain and proceed
> for the successful TMR allocation in VRAM and thus system comes out of
> resume process.

Well quite a big NAK to this.

Eviction of not contiguous allocations is perfectly possible, it's just 
not supposed to happen during resume when the DMA which is supposed to 
do that is not available.

The fundamental problem is that the PSP code frees and re-allocates the 
TMR during suspend/resume. This is absolutely not supposed to happen.

I'm going to propose a WARN_ON() to prevent subsystems from doing that. 
And I strongly suggest to fix the PSP code instead.

Regards,
Christian.

>
> v2:
>    - Added issue link and fixes tag.
>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2213
> Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")
> Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
> Cc: stable@vger.kernel.org #6.0
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> index aea8d26b1724..1964de6ac997 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> @@ -1369,6 +1369,10 @@ static bool amdgpu_ttm_bo_eviction_valuable(struct ttm_buffer_object *bo,
>   	    amdgpu_bo_encrypted(ttm_to_amdgpu_bo(bo)))
>   		return false;
>   
> +	if (bo->resource->mem_type == TTM_PL_VRAM &&
> +	    !(bo->resource->placement & TTM_PL_FLAG_CONTIGUOUS))
> +		return false;
> +
>   	return ttm_bo_eviction_valuable(bo, place);
>   }
>   

