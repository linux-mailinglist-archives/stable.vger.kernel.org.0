Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28178250772
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHXSZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgHXSZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:25:41 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B520C061573;
        Mon, 24 Aug 2020 11:25:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so9843624wrl.4;
        Mon, 24 Aug 2020 11:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bq5hRh6dg9CMA08TsyveabYMk5mqrcCNLEtAUVdySnw=;
        b=daV5NP6KOQoVdPhRTGodqQ1JzkNkgZDMhtCfKtrZere0DfYHigFpCO3yp7egRNWQ0H
         /MtuQ1mXghrxISQDgOLetOnRz7TuPJz+sCIcUlnTrR1dG21Tb8F5Sl1zqzguMFMTuF3u
         7mG4P5obRsoI0OmXWg2XsMjrlxxbOSY8qSnP7vc+F7unlZa8DUJcQMZ+6AaOB/Ca1GTq
         o8limkjqvpNJK0ga98DoiGCLFrsUsovgBPL2eiFyIqsmjZV+vGEHl3/c3giTnwJyivZc
         1kUug3HpHJBLiAW4H3Omvg0DjWkXnQDeOGf5ImqqvF7vTgH27KqTlvit8K4ZgH5bRedm
         jl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bq5hRh6dg9CMA08TsyveabYMk5mqrcCNLEtAUVdySnw=;
        b=BWpk6t4RKCKIl4Au2xuqg2SNafJ1muvJXBDlHHOY3OMKG+jqqmrMmPbK3vJzbUjO+O
         FMIjCurs+ee/GTTIEqbeIobPUecEj0lxZ2Qho8/DjeNh+HK0iZADUd/7Mb7fMo3G+PK0
         r3hQ72BKC7W5xKzFU9rCM14bMAQtk2g2s/YgPqtWatgb/Fei2ZTq14ok/7mhDGqJxcTN
         DI/pKFRRhSLs/5/+EwiyY+BmQZKADbqEs4TpDMY8LBhh38ZXNoSjyru8/khhLnHZLULY
         E2VClKBK6JvdFnodW28L1n6eclM99T7vOdtNYyPMOXhnJfhhyAespssC8ojn9wKt4hQz
         m9QA==
X-Gm-Message-State: AOAM531X+mZy3PDPR8ARxaaGWf4KPkzv36+9aR7jeyJ5YYy9UxoDR9Tx
        PtjV7clDkTsNwMwe2pQfeshn7/mqzQvEhWBvKqs=
X-Google-Smtp-Source: ABdhPJyfe2oCjJZx3F1PpVwy8oM7f8wrIEpDwj0rmv3wnnbE2x01swwhENf8HW/Y5/48gXRk7Fq6pyaNCGKpuT2dGTw=
X-Received: by 2002:adf:edca:: with SMTP id v10mr3893592wro.124.1598293540053;
 Mon, 24 Aug 2020 11:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200824163751.606577-1-sashal@kernel.org> <20200824163751.606577-35-sashal@kernel.org>
In-Reply-To: <20200824163751.606577-35-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 24 Aug 2020 14:25:29 -0400
Message-ID: <CADnq5_OouGpkpOeW+6=vhLOba-jWDDw_TDuzcTzKtcJ1T0U=yw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 35/38] Revert "drm/amdgpu: disable gfxoff for navy_flounder"
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>, Tao Zhou <tao.zhou1@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Jiansong Chen <Jiansong.Chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 12:38 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Jiansong Chen <Jiansong.Chen@amd.com>
>
> [ Upstream commit da2446b66b5e2c7f3ab63912c8d999810e35e8b3 ]
>
> This reverts commit 9c9b17a7d19a8e21db2e378784fff1128b46c9d3.
> Newly released sdma fw (51.52) provides a fix for the issue.
>
> Signed-off-by: Jiansong Chen <Jiansong.Chen@amd.com>
> Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
> Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Support for this chip does not exist in 5.4 or any other older trees.
Please drop this.

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index 3a5b4efa7a5e6..64d96eb0a2337 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -617,9 +617,6 @@ static void gfx_v10_0_check_gfxoff_flag(struct amdgpu_device *adev)
>         case CHIP_NAVI10:
>                 adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
>                 break;
> -       case CHIP_NAVY_FLOUNDER:
> -               adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
> -               break;
>         default:
>                 break;
>         }
> --
> 2.25.1
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
