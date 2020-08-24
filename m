Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7135C25075D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHXSYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgHXSYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:24:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D016C061573;
        Mon, 24 Aug 2020 11:24:15 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z9so370585wmk.1;
        Mon, 24 Aug 2020 11:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6IMhsacwEGlvqh63CK0QsU6TXKj2+AaqerE7CsDvPC4=;
        b=cuzflAC3uciy+SFo7niw4FCDuAb3fCMO86nc63jHSysfsEyKhWd27QFpqF3n6w/xWC
         1obfY0eXN+qO+RLagG+MeQ4XvM0NUv+JIgPW4xc1THskPm97mmyvg5JVnf3kzU3FdnXu
         3h1lMyO0QB608NMom1x7NB0/tDOiorIbSDvrSm2jkcjMYdaM8feWuZPFXXiqU0q5Q5W3
         CJKsyzaiWPieLyXFvRh0832RE97WLGEe6B/Iqb1j690i5oH9R4IdOAGRpb9ag2czWN7a
         e+SdM2jyKEtg8NmTygqUmA7yaZ9Heq2GjDfWJBfZh5JvQPnEJjyKfgQ/km678L3PLXBK
         GtqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6IMhsacwEGlvqh63CK0QsU6TXKj2+AaqerE7CsDvPC4=;
        b=S4QVYrafYIxjCTc6E0cjyJV341rsNTQjH1k57kWI85R93t2gt2Aw5HtX0nm9Xm2RmC
         LbHY6fYQBt/XskrAdpmgm46hRNxr1RXMQCqp/j/XsYxHOaocrTtxCo1ewErcQqm/8BVy
         YpaLGCK9OB3NZuBbAf4+wXvb0WFkqtozU+9AuVChnzYhw3oCWOeS2lkbpqXS/Rt5P/ef
         H8RvpTYLfN9+Eg2INtzcbD7Mcksm777mMUhCAR/rBS4cchiLiEeR8eu8jCLPfnfBe3Cv
         Z/uGgRBHmokHieC0yzTXE2aWoVdLu7qElhUaJNessq9SyQLAZ/QzH/+GuD6BiOV2bgtm
         xIMQ==
X-Gm-Message-State: AOAM532/Z/cq0mdueVNne05rvw7yfLdf5IdrzGmbj3npPIFgVP8uM7Sp
        LsXZe8/Pe0WkMhTeM4EFd6i1t3ufhepzUP9frYQ=
X-Google-Smtp-Source: ABdhPJz0DDJ2oIV/MrKaC4i0wH55w26Pka4uWviJmB8OafYTOputc9WZ6fiTJY/yEvVjFSK0bLyEE/F5rQPjGysMQBE=
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr495773wmh.39.1598293453989;
 Mon, 24 Aug 2020 11:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200824163504.605538-1-sashal@kernel.org> <20200824163504.605538-58-sashal@kernel.org>
In-Reply-To: <20200824163504.605538-58-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 24 Aug 2020 14:24:02 -0400
Message-ID: <CADnq5_P7CMeUof2G99jMFCq95VsSCb8CAWMOFL=PujmZs=0QcQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.8 58/63] Revert "drm/amdgpu: disable gfxoff for navy_flounder"
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

On Mon, Aug 24, 2020 at 12:36 PM Sasha Levin <sashal@kernel.org> wrote:
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

Support for this chip does not exist in 5.8 or any other older trees.
Please drop this.

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index 2c870ff7f8a45..fac77a86c04b2 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -3427,9 +3427,6 @@ static void gfx_v10_0_check_gfxoff_flag(struct amdgpu_device *adev)
>                 if (!gfx_v10_0_navi10_gfxoff_should_enable(adev))
>                         adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
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
