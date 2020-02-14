Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118F215E3B0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406824AbgBNQbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:31:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54683 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406548AbgBNQbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:31:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so10556871wmh.4;
        Fri, 14 Feb 2020 08:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eAPiyJCQWJAYuCQbg5vLQMsHB0XHMIF5EmjZS4cVVMc=;
        b=U/MyHARiUoYbmegGISDczV0sWnxf/CnBisvcw2jP8Q2HgYSyL06jv5gfeTBP2p4i3D
         QhuS8B+4XAy9CwyDawix1OFxAgYhQpFMMsmC94tYIm2qmJnfyh55YEg0pWY1pHMg+ocI
         manMWCwf4ahuziuNMS3zGbJONPoQWeeIR3zEGrreA3w7fmh8XdV/8B78hr80zPWdC2LT
         cVlEtA0td92IIYlzvtt2X0tnS9sXkgKV/dqnFWYcWfP6BnqJjk5hQc+N90kscu4bfQXt
         FkBvGcZCIWjwRCYqPZxbptIimSIJ9le4M94WzYU5Og0VLFp9HC3MZoCehWOIBKHr6K6o
         HyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eAPiyJCQWJAYuCQbg5vLQMsHB0XHMIF5EmjZS4cVVMc=;
        b=ikZ1Iu3zCpnrDIpDMbRTIChci9UEZq2p8zvEu7cCwQucbuXs2TPQRLy2ise+Kglf2/
         db3bcZNvSYN2uIC8iqPTKObVPyJSQ9m+YPtHBCL6XIpO30G0b1T2graVmj9N0k0o/J5v
         fsUt5iRwwGaRkIiVPcfG4CXwE9seogkpGzD3SyX4yMyMejJS5QjnlXLH3+cHHNlOgqlo
         jtrr0vETLHlkq3L0v/w9+5hOZkI2kS2STdbawZ22tFY/eDrT2cSSP7Y+AyNAMa3V0gZi
         zIHC/aA5OUl2dRatU9kQClHCCb7i8S11HZjjqm/K6xdagQnf55OICZdZUio81NcMiVip
         kgdw==
X-Gm-Message-State: APjAAAWyOnxfs1rIvM1rQuXAMJaRw+OltZoXvx7k/a73x2NJHI349w0S
        y0WI1lxkizsANNl9BRCruVo6vAsgGIU4oSiwKxs=
X-Google-Smtp-Source: APXvYqzlHaboZa+02wB3RWO97MuTp7IBVGo1BoTiJj/H1xoW7PoNMQhdrNk38Zh5PiWw6BYvdcF+waGi/AJsrdjus7I=
X-Received: by 2002:a05:600c:2c53:: with SMTP id r19mr5496620wmg.39.1581697902657;
 Fri, 14 Feb 2020 08:31:42 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-530-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-530-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 14 Feb 2020 11:31:31 -0500
Message-ID: <CADnq5_Oq-6VYYMWgvSbTcs5S6+DHP1K+ambo3Cd_BBkYFQk8HQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 530/542] drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 11:00 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Alex Deucher <alexander.deucher@amd.com>
>
> [ Upstream commit 1064ad4aeef94f51ca230ac639a9e996fb7867a0 ]
>
> Cull out 0 clocks to avoid a warning in DC.
>
> Bug: https://gitlab.freedesktop.org/drm/amd/issues/963

All of the upstream commits that reference this bug need to be applied
or this patch set will be broken.  Please either apply them all or
drop them.

Alex

> Reviewed-by: Evan Quan <evan.quan@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
> index 627a42e8fd318..fed3fc4bb57a9 100644
> --- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
> +++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
> @@ -1080,9 +1080,11 @@ static int smu10_get_clock_by_type_with_voltage(struct pp_hwmgr *hwmgr,
>
>         clocks->num_levels = 0;
>         for (i = 0; i < pclk_vol_table->count; i++) {
> -               clocks->data[i].clocks_in_khz = pclk_vol_table->entries[i].clk  * 10;
> -               clocks->data[i].voltage_in_mv = pclk_vol_table->entries[i].vol;
> -               clocks->num_levels++;
> +               if (pclk_vol_table->entries[i].clk) {
> +                       clocks->data[clocks->num_levels].clocks_in_khz = pclk_vol_table->entries[i].clk  * 10;
> +                       clocks->data[clocks->num_levels].voltage_in_mv = pclk_vol_table->entries[i].vol;
> +                       clocks->num_levels++;
> +               }
>         }
>
>         return 0;
> --
> 2.20.1
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
