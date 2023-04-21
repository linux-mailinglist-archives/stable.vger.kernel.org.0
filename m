Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C656EA751
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 11:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjDUJmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 05:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDUJmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 05:42:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDB9A26F
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 02:42:02 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94ed7e49541so190312466b.1
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 02:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682070121; x=1684662121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HX575BlXr8Tc9OCPZPcQdraI0YKNu7CPcg2XL81p1LU=;
        b=JX9GuLNj5GD5HPFWg84C+7Al12pUBzhVr4TzUcyS1zmDXjijCDORk/EHxHsGe3/UjH
         3pxYHHXAWX6rRpPcbj3+1u8w37dfcbVZeZcB/5JwjiOeDgSLcuv2XxBYTf2G19eCrAH9
         1UyET+18hyWdl+6dEMovXrTIK56+JVlDsOwo5PyjcVXdLe9AdGoDSuCV4N2S+Z8yhbs2
         9GmfyU+5xx0m2qYnaM/NO0eFhH5KQ/uWl4x9vgFFgYIiUZjruxMTlj7SgW71wcPAUxhQ
         iHXnFYh3kWZsZx3BH9xbMUwbpJS//Mb2u1Wuu7um33CrJ7IOhy7/NpC4H0tbjNlGql7D
         gRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070121; x=1684662121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HX575BlXr8Tc9OCPZPcQdraI0YKNu7CPcg2XL81p1LU=;
        b=K3W9EIWw6x+NTPOrMHxw2Sqv+1c0y6hoGHlmtkyiU8SaRzWg17HZ2etfq76dv44/vf
         n6RT4tX6ii9y8K4USrwMA8S2XP9u34LJEDoAy3zQ6BGeOW91jdnYZBBob/p6L3SLl77d
         PhP2FHiOuKuok1u14WIfIbLGcyRjO8VAsPNr+KVo8STlpPVgcLmL7EZRhlJ5Od8Fr0u3
         KctRi6VIxdWb1NRiowULi+tcQ1e/mA4BSdzgaKCcnUcLxz9CcN/xf4EOp8liPMusAwSn
         1iRrgFJwNGFLqKgiJwdgnKuTq5yMqWkXkouUzmfuSm6ezgurDj8zEfyAm/s92QdR7bPg
         BHxQ==
X-Gm-Message-State: AAQBX9eXlscOLafaByIDhjHVA/1iYvW5zXiKAEufz9H7NlqShYaAGj3k
        Th1RC9niBLN79w12Wk3x9ts=
X-Google-Smtp-Source: AKy350aWnkLdINoW4PZXnZKiYeedp342XceoGXuMkHDy+l8aNbDe05eQYMuENtzNTCLrbWfjgHQ2oQ==
X-Received: by 2002:a17:907:ca29:b0:94a:7b2c:205e with SMTP id uk41-20020a170907ca2900b0094a7b2c205emr1363232ejc.72.1682070121183;
        Fri, 21 Apr 2023 02:42:01 -0700 (PDT)
Received: from ?IPV6:2a02:908:1256:79a0:b9f1:4015:2594:f62d? ([2a02:908:1256:79a0:b9f1:4015:2594:f62d])
        by smtp.gmail.com with ESMTPSA id sd22-20020a1709076e1600b009572bd99281sm335833ejc.224.2023.04.21.02.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 02:42:00 -0700 (PDT)
Message-ID: <a0594b09-8a6f-1778-cfdd-f2595d314a12@gmail.com>
Date:   Fri, 21 Apr 2023 11:41:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4] drm/amd/display: fix flickering caused by S/G mode
Content-Language: en-US
To:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>
References: <20230420160036.130360-1-hamza.mahfooz@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <20230420160036.130360-1-hamza.mahfooz@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 20.04.23 um 18:00 schrieb Hamza Mahfooz:
> Currently, on a handful of ASICs. We allow the framebuffer for a given
> plane to exist in either VRAM or GTT. However, if the plane's new
> framebuffer is in a different memory domain than it's previous
> framebuffer, flipping between them can cause the screen to flicker. So,
> to fix this, don't perform an immediate flip in the aforementioned case.
>
> Cc: stable@vger.kernel.org
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2354
> Reviewed-by: Roman Li <Roman.Li@amd.com>
> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)")
> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
> v2: make a number of clarifications to the commit message and drop
>      locking.
> v3: use a stronger check
> v4: drop mem_type
> ---
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index dfcb9815b5a8..76a776fd8437 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -7900,6 +7900,13 @@ static void amdgpu_dm_commit_cursors(struct drm_atomic_state *state)
>   			amdgpu_dm_plane_handle_cursor_update(plane, old_plane_state);
>   }
>   
> +static inline uint32_t get_mem_type(struct drm_framebuffer *fb)
> +{
> +	struct amdgpu_bo *abo = gem_to_amdgpu_bo(fb->obj[0]);
> +
> +	return abo->tbo.resource ? abo->tbo.resource->mem_type : 0;
> +}
> +
>   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   				    struct dc_state *dc_state,
>   				    struct drm_device *dev,
> @@ -8042,11 +8049,13 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>   
>   		/*
>   		 * Only allow immediate flips for fast updates that don't
> -		 * change FB pitch, DCC state, rotation or mirroing.
> +		 * change memory domain, FB pitch, DCC state, rotation or
> +		 * mirroring.
>   		 */
>   		bundle->flip_addrs[planes_count].flip_immediate =
>   			crtc->state->async_flip &&
> -			acrtc_state->update_type == UPDATE_TYPE_FAST;
> +			acrtc_state->update_type == UPDATE_TYPE_FAST &&
> +			get_mem_type(old_plane_state->fb) == get_mem_type(fb);
>   
>   		timestamp_ns = ktime_get_ns();
>   		bundle->flip_addrs[planes_count].flip_timestamp_in_us = div_u64(timestamp_ns, 1000);

