Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDF225076F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgHXSZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgHXSZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:25:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DEDC061573;
        Mon, 24 Aug 2020 11:25:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a5so9866824wrm.6;
        Mon, 24 Aug 2020 11:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YAIp8ZarRWu0DneCjynShSWStsctWj+flPeQS/fuk90=;
        b=ImIVgxc0O5olzfnTRLTN9/f5FqqUKOFbAjtbqVq5jBtfjjbeT+rd4I2gAXsX0v2qNs
         7Wyf1fQU68zeCq+HvLJBNqXm52IjBh9zQ198pexe3sGUjQ6ATcRO9Gl4q2A0PgRsQpi8
         NoZStLpCl2firUTTtspxaDxeYN8Y/Vso+j+Cm9+6lP7pC+0RVxUvzDRkNqRTRXMsjGCh
         wRaoR488quQursJ9PBFHXVrFSCjYdrzUAAFcqjkAXLQbmtN9fzI89KwgOGc2SUAvTQ2T
         iui6QTm2wPq8LdYEO34ITEvweK6WEudZEAe152gjpoOodkiuB4BmM58f6v/UugonIuuo
         57dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YAIp8ZarRWu0DneCjynShSWStsctWj+flPeQS/fuk90=;
        b=b0J2RPzPfAOItw8FihH1VqWQ5gzw+oo8FQQqVuaAZGMPhS+GnUAGckD2TghXOopJmh
         xPIO04fuImTYTppz+k1/I0NiLwx2faUOrPj0OKj+dJYrBJYlc2FOjJi8afyzJRbe7NlU
         uaXGHUZxe/Yc2gn4ZLvX+xBP+6Tbz5B47Z9QTupAIth9zbJ/ddtuXCcZsbRJEV5oNQ3o
         b5JEA8dxOjyKREHSPBhVThD30FeNjLRSooFE0sOwtlnS3OKFCv1zvYfkqz4FGFZZ1qO+
         uE/FXr0CG+yvdVGc3UONl4kf/rV6USLEIhwJV2OCTZB63ZX6UT2md+1pUhU2HjMLUGzC
         gzLA==
X-Gm-Message-State: AOAM530Wt/+k9rWtcvU4waLZkSiLIY3Yj0a9mZ1TwIt1047d/n7aM8Kn
        Oi2QAzOkQS4hePgZ+UA19W3FcZYtdzprlCTVCGg=
X-Google-Smtp-Source: ABdhPJzSKmSBY48GlofEmwpRYlP/Xg4nbwx0nfnoM1l2mMj5wUpD1EWeGKMwmT6iUWsh+bMCoVnfYFpnMPBQI1S/oxI=
X-Received: by 2002:a5d:494b:: with SMTP id r11mr7304310wrs.419.1598293524074;
 Mon, 24 Aug 2020 11:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200824163751.606577-1-sashal@kernel.org> <20200824163751.606577-34-sashal@kernel.org>
In-Reply-To: <20200824163751.606577-34-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 24 Aug 2020 14:25:13 -0400
Message-ID: <CADnq5_M6MvH2nB_C6j7NezKGPeCRbEFZ-9kXf-_j+d9OQV0h0A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 34/38] drm/amdgpu: disable gfxoff for navy_flounder
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>, Tao Zhou <tao.zhou1@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jiansong Chen <Jiansong.Chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 12:38 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Jiansong Chen <Jiansong.Chen@amd.com>
>
> [ Upstream commit 9c9b17a7d19a8e21db2e378784fff1128b46c9d3 ]
>
> gfxoff is temporarily disabled for navy_flounder,
> since at present the feature has broken some basic
> amdgpu test.
>
> Signed-off-by: Jiansong Chen <Jiansong.Chen@amd.com>
> Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Support for this chip does not exist in 5.4 or any other older trees.
Please drop this.

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index 64d96eb0a2337..3a5b4efa7a5e6 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -617,6 +617,9 @@ static void gfx_v10_0_check_gfxoff_flag(struct amdgpu_device *adev)
>         case CHIP_NAVI10:
>                 adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
>                 break;
> +       case CHIP_NAVY_FLOUNDER:
> +               adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
> +               break;
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
