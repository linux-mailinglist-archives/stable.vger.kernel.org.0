Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B056250764
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHXSYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHXSYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:24:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D07C061573;
        Mon, 24 Aug 2020 11:24:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r15so9814099wrp.13;
        Mon, 24 Aug 2020 11:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RgeYevYFJkRsy/wt1R2pKTfZS0NBDKpEJa8zajXw8ac=;
        b=KqFvPL7VMN/GSvmvfCrrHRanmwj0lqKxg4c5DCpYub9P26eDjouQHTYjwpPVNcZH+m
         Seb6shEAHcF3hoBMjDEbugGOuIyc4wUGwKmQJOpLtVNnm4SYJAZ7wqNP7/ob6eJ3kt9O
         6Zdp2vx7XY9FFfdj/3/cBOcenb8cTbqcRjiMdBW5n0u0F+A9Q+nNVK3xUrNOYoBCUaVj
         rpEvlhFDV5NywcPMDUe+nSz7d0xr160dMWEH3B9AcDjj+OYMe9emfPeqmXgrv2ZAME5k
         KCgvi79N8KUy29LH67NO1CcVjl9PikWmSLqRvTQWci8hvBqqvbkyslaXVOaAiHkjOLFh
         BDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RgeYevYFJkRsy/wt1R2pKTfZS0NBDKpEJa8zajXw8ac=;
        b=NnCgza7+/VaHttaAcmZRqrDTN9yLDtoVFnUvXTN55eAzSpkHbSN/sWDSP+120gA4zn
         rH2VIlqYYPqk1xQx46Tp4j9SN9wE+FTkeV/7qJk8OP2a8LbfnrC8DlBWpMtGt7IBw2dN
         9HI0Ip0vNxsYolFcyJzHq/VAQHyM5tL4ZtUDzAzmq4n8XHMwPWW7dZf0bzPkSD+LsmFf
         xqw6tGp8A94wwslQjZUsS35GqL/WrxgFspaDZv7XUl6/bhZ8dgrKS1vc0roNh2/nf6RH
         RBKYpQHGvsiKmFiz5ABREq/gp8w01E76Zo/7UyVf9Q3+3Myy61TaL5kjzT5em/zJblEK
         3kIg==
X-Gm-Message-State: AOAM530d6mVzUqp+HDunh9JhdPGf+CZ5PJYy78tAnYB/WbepK+8ua0f7
        fOuetcZQ0jN9Hj0C0LpiPJ+Wcz7Au2kgVIHPAf4=
X-Google-Smtp-Source: ABdhPJyuF/fDWq/fdHFH0aq435FTW94C96Ef+TTcRnpGK5whZbKTalhbivwAxq+d+nSqI4G2Yz/ONM856Ch+QDE6Yhg=
X-Received: by 2002:adf:edca:: with SMTP id v10mr3890039wro.124.1598293477120;
 Mon, 24 Aug 2020 11:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200824163634.606093-1-sashal@kernel.org> <20200824163634.606093-46-sashal@kernel.org>
In-Reply-To: <20200824163634.606093-46-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 24 Aug 2020 14:24:26 -0400
Message-ID: <CADnq5_M3RJbhL8e3dwOZFUucngDjTcW-8YRuC6XHdfiD5JqQaA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.7 46/54] drm/amdgpu: disable gfxoff for navy_flounder
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

On Mon, Aug 24, 2020 at 12:37 PM Sasha Levin <sashal@kernel.org> wrote:
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

Support for this chip does not exist in 5.7 or any other older trees.
Please drop this.

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index ff94f756978d5..8ee94f4b9b20f 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -681,6 +681,9 @@ static void gfx_v10_0_check_gfxoff_flag(struct amdgpu_device *adev)
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
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
