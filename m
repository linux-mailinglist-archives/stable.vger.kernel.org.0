Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041A837FE5B
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 21:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhEMTmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 15:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhEMTmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 15:42:52 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52404C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 12:41:41 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w22so12485039oiw.9
        for <stable@vger.kernel.org>; Thu, 13 May 2021 12:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SfD5LHKp9dFknS19QWR+aKvcw9cYHWivh+Q7/tU2Qo=;
        b=jaJcHbwaIrH1cFE6Z5wYB4Z4xhFYkngYqKTofBcKg+VKZLpepIg2e5eRuS0nmskmaQ
         2fndaNBWP07Ee19QEQIF1XfZ0HozOm+MipSrpzS5eAPKWfu3bpRhn+S0H3h3AIXbqbj5
         Tb/a3Mc6PpUkaj1eEiYNRChM0OqcTPNxVZTtcJV/4kBzl2Ichwo+9xEg75r95oAxmO0i
         k/QPJ3pg0LxaBRStT3Y2e9FpYLN9Zf58CVYNH8wm/mRmHNtPAYPUvjFMmXd+JvY8AYuM
         ETnpkABXdwkn+ZwTAtWLHeuLJ02hFDhlZ6S4TcBiPuIix1Q5+Ldbf//WxcVCFZ382VhB
         ZZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SfD5LHKp9dFknS19QWR+aKvcw9cYHWivh+Q7/tU2Qo=;
        b=Sl8UuQSbjA1mbpsSgS4xF9j4etLXU2YeGO2WtlqOWIMoTcWXUF1wbtpydZtwep2EqZ
         YWG8Dnw+btxVbfqUc0UEyFTNux2zqiJY+4id5KwgNEwTM5MKWynbq7GNaAazKECuyhI4
         tWodoGpiHolcMpv7jYPTVNXfuvUv67OYcHDv0t0yYS3IkFctfkAE5TJgVHynYgGUgXUy
         5VgSAyOgk5ikKDJ8EdXh+IWoPOhDFiz+y+PFg5rtpJSsfR4gukhW6XhkAij/P6celSLA
         gf29TtpOLHHugNHV9r4Dxr0JeJLk2/mk/xJQx7i51TZ/Rzhbicamo7CGeWJmhmc4g4Eo
         5AQA==
X-Gm-Message-State: AOAM531ctDci3411yZ/q+LU/dCTQT45Xmtjjje2V3C20oy0OlpEC0gkX
        sHkwgJy8tsFKLJd8jqHbLShzsJLHtKkij3pPi2WFnU9Y
X-Google-Smtp-Source: ABdhPJxuR/ZL0So7GW1dC1byZz7flnHlwONX6AVxyk7asxASo1MI8e1WkEhmdGEJzid9rTTjmtxEamH0IwFd6nUCp/Q=
X-Received: by 2002:a05:6808:68a:: with SMTP id k10mr30960450oig.120.1620934900581;
 Thu, 13 May 2021 12:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR12MB448837F2FFA7B74AD3345C10F7529@MN2PR12MB4488.namprd12.prod.outlook.com>
 <20210513053233.116683-1-luben.tuikov@amd.com>
In-Reply-To: <20210513053233.116683-1-luben.tuikov@amd.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 13 May 2021 15:41:29 -0400
Message-ID: <CADnq5_OqBOafkMfUAzs7tiXsrjuNPKd=hLWUFCWPh5cah_Sp4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
To:     Luben Tuikov <luben.tuikov@amd.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 1:32 AM Luben Tuikov <luben.tuikov@amd.com> wrote:
>
> On QUERY2 IOCTL don't query counts of correctable
> and uncorrectable errors, since when RAS is
> enabled and supported on Vega20 server boards,
> this takes insurmountably long time, in O(n^3),
> which slows the system down to the point of it
> being unusable when we have GUI up.
>
> Fixes: ae363a212b14 ("drm/amdgpu: Add a new flag to AMDGPU_CTX_OP_QUERY_STATE2")
> Cc: Alexander Deucher <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 16 ----------------
>  1 file changed, 16 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> index 01fe60fedcbe..e1557020c49d 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
> @@ -337,7 +337,6 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
>  {
>         struct amdgpu_ctx *ctx;
>         struct amdgpu_ctx_mgr *mgr;
> -       unsigned long ras_counter;
>
>         if (!fpriv)
>                 return -EINVAL;
> @@ -362,21 +361,6 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
>         if (atomic_read(&ctx->guilty))
>                 out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
>
> -       /*query ue count*/
> -       ras_counter = amdgpu_ras_query_error_count(adev, false);
> -       /*ras counter is monotonic increasing*/
> -       if (ras_counter != ctx->ras_counter_ue) {
> -               out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
> -               ctx->ras_counter_ue = ras_counter;
> -       }
> -
> -       /*query ce count*/
> -       ras_counter = amdgpu_ras_query_error_count(adev, true);
> -       if (ras_counter != ctx->ras_counter_ce) {
> -               out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
> -               ctx->ras_counter_ce = ras_counter;
> -       }
> -
>         mutex_unlock(&mgr->lock);
>         return 0;
>  }
> --
> 2.31.1.527.g2d677e5b15
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
