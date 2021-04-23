Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9602736947E
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 16:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhDWOTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 10:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDWOTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 10:19:21 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DFFC061574
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 07:18:44 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a5so18883790ljk.0
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 07:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=TXbI5Oo0zfyl69DvKxAj2fO3Hm2ZEiDPMmXNP4VrOPU=;
        b=pY7koaVpQIsKa+eB7gEdCusqOZK96k5XYCs1vxIQM6Vjhet2WFwVHaP6uQ3ZVQ1aVE
         frt+HUmI0s17pQLY/IoNMaU/pK1WTsJdImy/cN7fNYv2ljfi0UwAKCMOrINEug9Rutw2
         ICWdWDT/E/OexhF66an8Zuznqe98ACNM1EHXq9lX/RvCJd30LmMDJ0Hx/w53l4uXhr3Y
         O71SW50Gt+jiJRkCRwc7XXCLLXRNJqAhvszyFOcSLgg0OIKVb8MZg2rGUh5NlIuLmUI2
         rFLUmTfxdv+8FJ9GAEsc4GNyGny+TAY9p2dvvTFgfb6AOIczhM0L52XFgV6+Sggn2vJ2
         roDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TXbI5Oo0zfyl69DvKxAj2fO3Hm2ZEiDPMmXNP4VrOPU=;
        b=nQg601QhzvXc6prdUj3H9n1Q02/0Dy3ht9129fx3bH4uDAzoZGPDEX402R9h0pedoO
         u5WgzkMly871yO5MBgWCqVrla5dqiOQuGCRM1RY3p7FP11Hk5cgCTSbZLxacx4TwqL7x
         jlZwcYb29sx7phJk4nfCE77GvoVRMISRpNI+ZWgID9bd3sJgqRYttNk7AxnNExHfVJoX
         v1atoHJHRtlrByHdnYHCtl69azVfu5swsHzNUieyffvUqVv3E9gTAOD2EM8fSGj4Uqr1
         EWTFDGMzHsG0oBTrpBnzg3C8QeTst5LxXYYG4hJvYO1mpiC+B5+vMGL31dKQnXJ1+F71
         Z2+A==
X-Gm-Message-State: AOAM531/XkXKekoIFHxtVZY53u7RW74dAlfrGYaZZ2XPKQX7EluMb0A5
        zh4LCphNdOkyv8BzZ7O2fSc=
X-Google-Smtp-Source: ABdhPJyrX7sILEuzZmAB+wkSCMGYjvxpNPiBhLWXoKFFVBYYgjTbjw5v4OGz6zFyp6MYhN17XCx0DA==
X-Received: by 2002:a2e:a379:: with SMTP id i25mr2971485ljn.344.1619187522816;
        Fri, 23 Apr 2021 07:18:42 -0700 (PDT)
Received: from ?IPv6:2a02:908:1252:fb60:88a3:b9e2:1bf9:4d38? ([2a02:908:1252:fb60:88a3:b9e2:1bf9:4d38])
        by smtp.gmail.com with ESMTPSA id s7sm557795ljg.31.2021.04.23.07.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 07:18:42 -0700 (PDT)
Subject: Re: [PATCH v2] drm/amd/display: Reject non-zero src_y and src_x for
 video planes
To:     Harry Wentland <harry.wentland@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     danny.wang@amd.com, Roman.Li@amd.com, stable@vger.kernel.org,
        hersenxs.wu@amd.com, alexander.deucher@amd.com,
        nicholas.kazlauskas@amd.com
References: <20210423140958.25205-1-harry.wentland@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <49d21b75-eaf7-5e24-7a16-480698e1498c@gmail.com>
Date:   Fri, 23 Apr 2021 16:18:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210423140958.25205-1-harry.wentland@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good that this has been found. Just a curious guess, but have you guys 
checked if the src_x and src_y are a multiple of 2?

Might cause problems to try to access a subsampled surface if the 
coordinates doesn't make much sense.

Anyway patch is Acked-by: Christian König <christian.koenig@amd.com>

Regards,
Christian.

Am 23.04.21 um 16:09 schrieb Harry Wentland:
> [Why]
> This hasn't been well tested and leads to complete system hangs on DCN1
> based systems, possibly others.
>
> The system hang can be reproduced by gesturing the video on the YouTube
> Android app on ChromeOS into full screen.
>
> [How]
> Reject atomic commits with non-zero drm_plane_state.src_x or src_y values.
>
> v2:
>   - Add code comment describing the reason we're rejecting non-zero
>     src_x and src_y
>   - Drop gerrit Change-Id
>   - Add stable CC
>   - Based on amd-staging-drm-next
>
> Signed-off-by: Harry Wentland <harry.wentland@amd.com>
> Cc: stable@vger.kernel.org
> Cc: nicholas.kazlauskas@amd.com
> Cc: amd-gfx@lists.freedesktop.org
> Cc: alexander.deucher@amd.com
> Cc: Roman.Li@amd.com
> Cc: hersenxs.wu@amd.com
> Cc: danny.wang@amd.com
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> ---
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index be1769d29742..b12469043e6b 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -4089,6 +4089,23 @@ static int fill_dc_scaling_info(const struct drm_plane_state *state,
>   	scaling_info->src_rect.x = state->src_x >> 16;
>   	scaling_info->src_rect.y = state->src_y >> 16;
>   
> +	/*
> +	 * For reasons we don't (yet) fully understand a non-zero
> +	 * src_y coordinate into an NV12 buffer can cause a
> +	 * system hang. To avoid hangs (and maybe be overly cautious)
> +	 * let's reject both non-zero src_x and src_y.
> +	 *
> +	 * We currently know of only one use-case to reproduce a
> +	 * scenario with non-zero src_x and src_y for NV12, which
> +	 * is to gesture the YouTube Android app into full screen
> +	 * on ChromeOS.
> +	 */
> +	if (state->fb &&
> +	    state->fb->format->format == DRM_FORMAT_NV12 &&
> +	    (scaling_info->src_rect.x != 0 ||
> +	     scaling_info->src_rect.y != 0))
> +		return -EINVAL;
> +
>   	scaling_info->src_rect.width = state->src_w >> 16;
>   	if (scaling_info->src_rect.width == 0)
>   		return -EINVAL;

