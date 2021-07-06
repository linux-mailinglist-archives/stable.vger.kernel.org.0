Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2164C3BDF18
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 23:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGFVrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 17:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhGFVrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 17:47:24 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3D8C061574;
        Tue,  6 Jul 2021 14:44:44 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id m3so936352oig.10;
        Tue, 06 Jul 2021 14:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=02NGKANC6bWRviktL9XwvAT8xDpibT4kcz5eISh/RS0=;
        b=Jr+EhbKVszQ7Dl4PYYZKnvaWVb/MSuomxwnEc1wXFqNiUUwIJFdeGCuVKV0BoTFVe4
         1gMXZ43NFBElK2Bha/35aW1zVuwUI40RpETpyPXISezds6jPxZWW/J8zKIp8e8hr0gL6
         gL3cBQ/kKYoRm43yP4kbMfwKEeuH8FuwohI1spoXtreMogVoacJv1LzcN+CT8ckhg4Fp
         W38vLGaVD/csV/Ob6zAgCn0UOORtuej0EzXjMSW1A+MEsZ2ukim95KMkJgBVPLzBXi9g
         l1ApVUqcP62AgYMPkRVI+E1NWiEOPg87QHTDjfnuNFgJq4GuUrOnUHQiT1sPgcgZC7QE
         Tw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=02NGKANC6bWRviktL9XwvAT8xDpibT4kcz5eISh/RS0=;
        b=V1gNQVHAYtIHvn4XZQ/Le9aJSShsprqAWcaIJAoAberra0PaOBG3LMQ/sSD+dbtOtv
         pbynHH7Pr0JWtuLEfYhgFNLo1xHbCeP+y6XVa6jw0cG/1NxjcesOXSymq+Nrk2Gr28jx
         HYMh389UfypHZweI/YH7jGRt17o+I0I5/PzEldS+BiGs5PDNAo6xLvUrkbLn5Qpr+sla
         T9HcZxL7C/KTQwytFKZt0X/jIU2LX8TUy3swTAX5ugmTbAcRP1V1Z4Z2V39H7JU0LcTz
         IGveOlLg8edzQY3I4I5056yk4vwPPiDkIIl9rFFvKlrqsQrTf4ToesLtmi6iJXdnLwDe
         4tvA==
X-Gm-Message-State: AOAM530vbLxBe63a+SLK18CU4ZuJ/ks8BmAMug5tUIg97XfG9iO8ynrg
        kBKTgUlYSAytQ1fvka6bkKYZ0xlq1y7AjEaYSYM=
X-Google-Smtp-Source: ABdhPJyJt9TJEJerAMmCKYsbved+w6V/cNsXV68GF6PloP4xXpQNkMpmSAMYxKqeYYk3SHLvNpM8HdrL6BTx20w4ZxY=
X-Received: by 2002:aca:ac15:: with SMTP id v21mr2045269oie.5.1625607883766;
 Tue, 06 Jul 2021 14:44:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210706111409.2058071-1-sashal@kernel.org> <20210706111409.2058071-113-sashal@kernel.org>
In-Reply-To: <20210706111409.2058071-113-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 6 Jul 2021 17:44:32 -0400
Message-ID: <CADnq5_ObmVRjwUB5Lw0bLZLL-+=CqvGkJZ+2DY5ZDh+uN-oo0g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.13 113/189] drm/amdgpu/gfx9: fix the doorbell
 missing when in CGPG issue.
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 6, 2021 at 7:16 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Yifan Zhang <yifan1.zhang@amd.com>
>
> [ Upstream commit 631003101c516ea29a74aee59666708857b9a805 ]
>
> If GC has entered CGPG, ringing doorbell > first page doesn't wakeup GC.
> Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround this issue.
>
> Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This should be dropped.  It was already reverted.

Alex


> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> index 516467e962b7..c09225d065c2 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> @@ -3673,8 +3673,12 @@ static int gfx_v9_0_kiq_init_register(struct amdgpu_ring *ring)
>         if (ring->use_doorbell) {
>                 WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
>                                         (adev->doorbell_index.kiq * 2) << 2);
> +               /* If GC has entered CGPG, ringing doorbell > first page doesn't
> +                * wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround
> +                * this issue.
> +                */
>                 WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
> -                                       (adev->doorbell_index.userqueue_end * 2) << 2);
> +                                       (adev->doorbell.size - 4));
>         }
>
>         WREG32_SOC15_RLC(GC, 0, mmCP_HQD_PQ_DOORBELL_CONTROL,
> --
> 2.30.2
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
