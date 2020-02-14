Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9633C15E6B5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgBNQtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:49:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37067 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405286AbgBNQtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:49:33 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so11655203wru.4;
        Fri, 14 Feb 2020 08:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YOBa47sfB4zGlt/eSqmdr7tVajGz1eh8XyouzGHZTXA=;
        b=FNX3ZTo7L6hK1EJbxDuzGg93cWg/xmbLJWlVdWTgc+1FogMSsT6a3vu4ssxq3MWWlH
         0a85jSPJgIvWWMN8lE+lwL26e5plRyOKGXvgnvRUQYWI0/wJK3e2xgcMk3AZHCaylqBj
         0yMjs8bunFNhHd2Fgz42dKJpQsT+408waOxwEsPW9meV0VehP/pd47mu+14+FgL1Hy1i
         adQ2f/QyVYC9hiEI/meR0ac89wfrF1j2RxOg2NJME6FOOi7Es5ZRAa5+ri68X6DvlHDH
         UkZEVxgRf5OMUn/Rxtncg9oD4fexwzdHWGj/VdY26yA/T0gk4KeZlwuAGvLM6yg/X96R
         qkcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YOBa47sfB4zGlt/eSqmdr7tVajGz1eh8XyouzGHZTXA=;
        b=Dkx/SELrte0bkqjc19AXPaLeZgSM555swUMiIhmxsE2yc1ZACr6JQIpZtfrGUuuhD9
         ccCfjTaRcZExTDPjof153Z58Eh3EuV1I6FbR5+tfgLRSHFtTW8317sJRjww42aim8Hyj
         q+OFmZ0MXxhaFpW0pOf/qGAF2unoi8j9gTWwu3AaOeJ+p4QaShcL1lJp8EZw92HlW0EC
         LVXzwLeGP+i9Fr4nUgRkruPUUQEg5QPaD87D3Y4GyXMVqoAm5lzi5Kz3nb5V3wBku6V9
         jIljDE3hpjixxTUMGsEHbnhleF2RwcZt+ogtOEsudhFOm59i1fD0FMI3kk/l6eokFt/o
         IKRg==
X-Gm-Message-State: APjAAAVuJCdFnECMCHSsfqJkQ38JkGhbeqtT+47F/xFMnmqnLDZLJ3cT
        DmpHyg7RVSxtz45oQnJrnPpmaKJPoZFI1QRfKVc=
X-Google-Smtp-Source: APXvYqxKeiQx6w2kj07XUMKdeqQDJA9gMVv/ylGoEkmKSG2AofVbH9t2OsP5D5vsIQzNmIOPHSPfc1T6F3njsJwzMKQ=
X-Received: by 2002:adf:b254:: with SMTP id y20mr4851957wra.362.1581698971153;
 Fri, 14 Feb 2020 08:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20200214161147.15842-1-sashal@kernel.org> <20200214161147.15842-246-sashal@kernel.org>
In-Reply-To: <20200214161147.15842-246-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 14 Feb 2020 11:49:20 -0500
Message-ID: <CADnq5_O500gd2yFfF0VuyAt5CCirAwb+HzLcpSwM5C3VBC660w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 246/252] drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage
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

On Fri, Feb 14, 2020 at 11:17 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Alex Deucher <alexander.deucher@amd.com>
>
> [ Upstream commit 1064ad4aeef94f51ca230ac639a9e996fb7867a0 ]
>
> Cull out 0 clocks to avoid a warning in DC.
>
> Bug: https://gitlab.freedesktop.org/drm/amd/issues/963

Same comment as for 5.5.  All of the upstream patches that reference
that bug need to be applied or they all need to be dropped.

Alex

> Reviewed-by: Evan Quan <evan.quan@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
> index 3fa6e8123b8eb..48e31711bc68f 100644
> --- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
> +++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
> @@ -1048,9 +1048,11 @@ static int smu10_get_clock_by_type_with_voltage(struct pp_hwmgr *hwmgr,
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
