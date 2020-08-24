Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA8250759
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHXSX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgHXSXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:23:55 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C1FC061573;
        Mon, 24 Aug 2020 11:23:55 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x9so5301482wmi.2;
        Mon, 24 Aug 2020 11:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RWt4HdLDDE3cWxWp14ftYZ+Ff9vvdCYJgVm+2n4jMk0=;
        b=QiSYkoWo6+sxPSh3nCgtbEpKl3GLoyehwM+22cwGTFHcJya9CyycE6Itv87bRJPk3j
         v9I6aZYCB+IE+ZdGk3iP25ymbh7BfnT9lSbW7dBiGTpn/eHa16Y8AkyEB2wCHyjSbE+g
         UCOkmnQgllkEhED10e+YnAcstwHyO04ClrqHock8KudzOiU/WzMu5gwGEvoaoSEAUxPG
         uHAFuGyrhhH21eNpmrGqyLjUttypNN1xgAn/Teh6IFQlv6Munft6kJ8gzGj7T+Nn0Adu
         go+n7QSoZHmpaz3vBnj6Ue01+GiesPwGZ3zZzKDH6nJUIFTEUBcklmHyTrH/0xsttsjB
         IRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RWt4HdLDDE3cWxWp14ftYZ+Ff9vvdCYJgVm+2n4jMk0=;
        b=PxOR4WOmQ3wTeXHiM0UL1OP/FjpwkI8UZqRG23snPijbXkdTt+cn9FLA2ODoRJYFwK
         vyMYeGJT9RD87jhtOZQ0YM//4DPHYK71cDoqRD6d5M+aCfY15fzN7KrSjh38Y7sFAwxr
         /YcTXIpC3EM6HD75GPVJTmLBAFQrPClaaB2K+XP3Kyf4GLnYwkX7bjzFiio+g8whWxB1
         TKYMldi4EXnl+rYzbiUybpQlG6aiA/1SGQSaKILQIihlIDGICkmstBOcL35I+/rbjoGW
         P++20O2p0FLlZbi4/aJEETlnrcxopvtMFs2G/z6sGZmCgSU6zZIWXurOBllyWl4SoG27
         KO3w==
X-Gm-Message-State: AOAM531zHG3okUa48chr6h0fmSDF1Hfji71YOO4fl3pSDvUJQxPxQh1r
        WH4u/x1BEFKBSDLGxcY0ew5J2SazWVv0HheldSk=
X-Google-Smtp-Source: ABdhPJzV3/zbrwXpoEPGTg1sHHiKvs4tr77eqoVjZcOGpQIpHr6awTnlu0abG4mFeyvWAKC8PhSVLwnMYAmPxPuzEv0=
X-Received: by 2002:a7b:c941:: with SMTP id i1mr487708wml.73.1598293433887;
 Mon, 24 Aug 2020 11:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200824163504.605538-1-sashal@kernel.org> <20200824163504.605538-52-sashal@kernel.org>
In-Reply-To: <20200824163504.605538-52-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 24 Aug 2020 14:23:42 -0400
Message-ID: <CADnq5_Osp+ePNgm1c5VxRzuymZzkTCF1Zps+Y0JjO8AJ66r+TQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.8 52/63] drm/amdgpu: disable gfxoff for navy_flounder
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

On Mon, Aug 24, 2020 at 12:36 PM Sasha Levin <sashal@kernel.org> wrote:
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

Support for this chip does not exist in 5.8 or any other older trees.
Please drop this.

Alex


> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index fac77a86c04b2..2c870ff7f8a45 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -3427,6 +3427,9 @@ static void gfx_v10_0_check_gfxoff_flag(struct amdgpu_device *adev)
>                 if (!gfx_v10_0_navi10_gfxoff_should_enable(adev))
>                         adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
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
