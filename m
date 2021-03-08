Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3677F3313D0
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 17:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCHQu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 11:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhCHQuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 11:50:54 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18060C06175F
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 08:50:54 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id y124-20020a1c32820000b029010c93864955so4218864wmy.5
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 08:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=csdGRTC/fqgxsx3MqD2CY30jxKKY88IrwPuEZV8x6Ik=;
        b=DX98jyr5QLOmJ8E7yGn6bjv/PpieA9Cosj5ziznlKkeYgIlkJgCfrI0YrEgh0j8I6/
         twMC2UTSK3Z1ow3Kg345iexCRbOdFO2B/f8UzcxqaaKGs4kLepGlpue2mnXWMo5u89GI
         PKatd4km02S4zeQap6wAKbamucP7/ijFuuZGdlCDH4hzu8xcLT6nXY0yGS06xYW9QUOq
         7YRR+PERcI7f3pfmIEdEvU9zTB9TdYviHHQFYUId/RdzTCs0T5t29AdLqQWFQ1TyqbwT
         zJ43clxhaQ9Od+geafT84c4b1f+5fT395Ovnee2HEqyyO2cHO6waLoXu1/b/NjhC1NwJ
         iGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=csdGRTC/fqgxsx3MqD2CY30jxKKY88IrwPuEZV8x6Ik=;
        b=ZPAN9Tqcc/Aj7C9e930GI6yUKYcOBCGQ8KNpQD/f+X4yViz/9wuXr800+r/+TAt6b2
         mfj9u8ZUo7Br1bXUiaQA1Z1dr/X457NaOedmFOhVei2Pfheu5NX7laxZhGF26DqlGLWW
         IiImC+05ALtUfIAC07nmPJVo0PoQxD/MnKy8raHe0VOWLjrSiOFRWcNG6dj7y5/IyQbA
         BFOvbHw3ELMUSeeo5WC2IB9X84eqZUU7CD6yeLWird49BjCoc3+NRVfRl4I6EsYfiL3N
         iuJdKCPT9xUuRR3ns8iqcgjprkll9N0viYxyhBcn3gSOwHXi+7t1fnfnInsyS+O6gjuq
         W+Rg==
X-Gm-Message-State: AOAM532+KYhI7O1mYEHGg8X+yuDxJBAPkM8UOmZDkg9puJRTSb3Ypt2J
        QMFHRfVRovnKfri+oJpxn6M6yw==
X-Google-Smtp-Source: ABdhPJwiGAFh2Sq055ZPR+B0t2Vb4lvtPttu/FfPEwa5HdoRsCuHmy/uMDSJ943qk0DgZb+bSLnPhg==
X-Received: by 2002:a7b:c2aa:: with SMTP id c10mr22868798wmk.101.1615222252666;
        Mon, 08 Mar 2021 08:50:52 -0800 (PST)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id b15sm20536789wmd.41.2021.03.08.08.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 08:50:52 -0800 (PST)
Date:   Mon, 8 Mar 2021 16:50:50 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     nouveau@lists.freedesktop.org,
        "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" 
        <dri-devel@lists.freedesktop.org>, David Airlie <airlied@linux.ie>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        James Jones <jajones@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] drm/nouveau/kms/nve4-nv108: Limit cursors to 128x128
Message-ID: <20210308165050.qhhf5aqdcldet5p6@maple.lan>
References: <20210305015242.740590-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305015242.740590-1-lyude@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 08:52:41PM -0500, Lyude Paul wrote:
> While Kepler does technically support 256x256 cursors, it turns out that
> Kepler actually has some additional requirements for scanout surfaces that
> we're not enforcing correctly, which aren't present on Maxwell and later.
> Cursor surfaces must always use small pages (4K), and overlay surfaces must
> always use large pages (128K).
> 
> Fixing this correctly though will take a bit more work: as we'll need to
> add some code in prepare_fb() to move cursor FBs in large pages to small
> pages, and vice-versa for overlay FBs. So until we have the time to do
> that, just limit cursor surfaces to 128x128 - a size small enough to always
> default to small pages.
> 
> This means small ovlys are still broken on Kepler, but it is extremely
> unlikely anyone cares about those anyway :).
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: d3b2f0f7921c ("drm/nouveau/kms/nv50-: Report max cursor size to userspace")
> Cc: <stable@vger.kernel.org> # v5.11+

I was experiencing problems with the mouse cursor on my system in v5.11
and after a bisect to help me search the web I found my way to this
patch, which fixed the problem for me.

Mine is an Armv8 system but there is nothing particularly exotic from a
graphics card or software point of view: Debian bullseye/wayland
(gnome-shell 3.38.3, mesa-20.3.4) running on a GT-710.

However FWIW:
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>


Daniel.


> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> index 196612addfd6..1c9c0cdf85db 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -2693,9 +2693,20 @@ nv50_display_create(struct drm_device *dev)
>  	else
>  		nouveau_display(dev)->format_modifiers = disp50xx_modifiers;
>  
> -	if (disp->disp->object.oclass >= GK104_DISP) {
> +	/* FIXME: 256x256 cursors are supported on Kepler, however unlike Maxwell and later
> +	 * generations Kepler requires that we use small pages (4K) for cursor scanout surfaces. The
> +	 * proper fix for this is to teach nouveau to migrate fbs being used for the cursor plane to
> +	 * small page allocations in prepare_fb(). When this is implemented, we should also force
> +	 * large pages (128K) for ovly fbs in order to fix Kepler ovlys.
> +	 * But until then, just limit cursors to 128x128 - which is small enough to avoid ever using
> +	 * large pages.
> +	 */
> +	if (disp->disp->object.oclass >= GM107_DISP) {
>  		dev->mode_config.cursor_width = 256;
>  		dev->mode_config.cursor_height = 256;
> +	} else if (disp->disp->object.oclass >= GK104_DISP) {
> +		dev->mode_config.cursor_width = 128;
> +		dev->mode_config.cursor_height = 128;
>  	} else {
>  		dev->mode_config.cursor_width = 64;
>  		dev->mode_config.cursor_height = 64;
> -- 
> 2.29.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
