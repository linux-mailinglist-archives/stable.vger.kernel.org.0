Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8525076C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHXSZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHXSZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:25:00 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3362C061573;
        Mon, 24 Aug 2020 11:24:59 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s20so4489958wmj.1;
        Mon, 24 Aug 2020 11:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hiwcUAldWOxLPE0QEt1TJzuP3uTlNIL1ayfloIyJuE=;
        b=LX/pMc4tuxueVTZUNFnEsqWcy/297seMKrnwAiVYQcKPOmF2Y1f4IIB7TaywBV7vTb
         T4cPctqVmDKBXCc31bqo8ASLY2V6Ghpdedgw9cJGO234jXsM6qPZ7KzkrDrdLlGV6lRf
         9XaQ+F2xWgJXIFDsqlITYEdx7XJbpXqUMiAsLVvFk0AbsKHHOenzgUqYydrEJvNoamgu
         AouV+TiKwhRHVUMYw4jxz9p/zq+ZPIkoCGuY15YTrtTGRlbCOtx2Oi0SXObl7R2pHkMR
         fp9fJwuph0dUIsQy4B7vo8mZzCKj5jy4hrFRvmqAV0uVp1oKZMvLLBn0IMdqUw15+1jx
         0k5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2hiwcUAldWOxLPE0QEt1TJzuP3uTlNIL1ayfloIyJuE=;
        b=oB3ff/opxp8ANyufqUSgXt/CpUeUym8QH/BwFAs2r+th0n2I8LH5ooBWXYaYknMjS8
         URf+2x7vmSAVPcIEw7WXjxia78IFwzNVtkOz8PYWxMC6WawOHidfonPpRHsONZrivULd
         z5pnfbg7ot2vresIkyNhy3T5oFSDV8YtUFZMC1XGbCNcz2ukDUeYrCBM3nBR5zB/ZTul
         NTfA5w8lhDcoFn2PMj7kproXZfwJFQx0ejmYWy7HNashkGzqeB1yi872JMVSzJsbe75L
         kdJGMKXN8ziUrCCchfe89ihNcaIiC88a0wAEc/2mW0C+krq8aGjcJtUQBueOBUGF5OvW
         lKNg==
X-Gm-Message-State: AOAM5330gtP6vHKE1ZpandK0T9vRWVekhZruSdOKeiHrvxwq8klnVLq9
        Z+7MQ2hjB9+K3n8+GRGyRXHy3p57SYQHd4MYj2E=
X-Google-Smtp-Source: ABdhPJy2iosbPkPwCaUj/E5XZyiLNj8lBukGOpjOjIZVDCrhZKhqjF3puLnKJGIISOuatmrsNB/X/OLJWaU6nNHkUyI=
X-Received: by 2002:a7b:cb17:: with SMTP id u23mr506433wmj.79.1598293498317;
 Mon, 24 Aug 2020 11:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200824163634.606093-1-sashal@kernel.org> <20200824163634.606093-49-sashal@kernel.org>
In-Reply-To: <20200824163634.606093-49-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 24 Aug 2020 14:24:47 -0400
Message-ID: <CADnq5_POu=q3LzKc3_77QNRZwYjO83c=WFHL1uj9rTHSj7j-ow@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.7 49/54] Revert "drm/amdgpu: disable gfxoff for navy_flounder"
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

On Mon, Aug 24, 2020 at 12:37 PM Sasha Levin <sashal@kernel.org> wrote:
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

Support for this chip does not exist in 5.7 or any other older trees.
Please drop this.

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index 8ee94f4b9b20f..ff94f756978d5 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -681,9 +681,6 @@ static void gfx_v10_0_check_gfxoff_flag(struct amdgpu_device *adev)
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
