Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1AA15EC48
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390523AbgBNR0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:26:13 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45448 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391006AbgBNQIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:08:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id g3so11486230wrs.12;
        Fri, 14 Feb 2020 08:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OM4TKjOm/yvAxQq7WYJdaCFUt3NS+HnL9lwT1oddEAo=;
        b=GFhQJ+hJtV9xr6fa/iyNIspJNHMimG7PEECD3+yLw7/n8ay5/opd+1Z3uIoV7jcnlm
         aQalqIHo/dDiwbZ/2VlYyWDSipThQj7QFyvjBotYy0UnWB+nOhuLnRaUq0rzJZJgpF5F
         0v1Oq1tFtiDw1Dk/AA0omx4tECTuhufNUjNOslNL5zilNVEuN5ynaQfrdgUDwIpwCxVH
         pSVRqlFfnYgyKmiHgUrG/naK1ydATRHxkAMfs/45/+XDLIhQu71LogLuHbZB94yyuStY
         PFgUDob3KQnGx8goIU9DrX/qc0ty2E8rbI+DWzEozG3Xw7K/64dW1ElXY5hcR1eBz1Qy
         XSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OM4TKjOm/yvAxQq7WYJdaCFUt3NS+HnL9lwT1oddEAo=;
        b=N81s8UtGSKvnGyL/3D2SbS0votsaAeXl9Yz2V+9T/OyLqx6NZiTqm/q3Z7kbQd7HEc
         Q3LNLu5eTF4C2jJ+/8JAv0HjFUdV0aTaOt9XdL1Srdt65HAItks7odTr6ScN3eeUzyXg
         MCjFZO63AqnwU9HngBwfTIgoiOopIviQ681bDti5Qp1ANy5lTO1z6mz78JX/ysPlYNH3
         UhB6tUVzfG88Ne5sUMUy/Zkwr4eDN3zFt7m1ow7eveVN5GAqPjN4pMGDdrDBOTW3yk74
         BK4Y4o4C+Bdu2TuoQR0OexeiGfTEaG32wL4VLyEAcpwbYuElG3xVjy7K0ojDc/0kc/Nh
         88Gg==
X-Gm-Message-State: APjAAAVjpq9VzPBs7vYso92iA+za3tT+XVK0xy64qNXmjnCnpgMA0IxE
        +okbYgfqat4Z1+5QbO4GZSHRxA9C/EOBP8Tw1hY=
X-Google-Smtp-Source: APXvYqycEObI3GuA97O29Uko4AYNY69SACij6kVruVhitwPSRHXHFvmF3LOmMBqyGsePRr9hcwAdn5JYY0iru+ql/OE=
X-Received: by 2002:adf:8b59:: with SMTP id v25mr4891241wra.419.1581696516592;
 Fri, 14 Feb 2020 08:08:36 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 14 Feb 2020 11:08:24 -0500
Message-ID: <CADnq5_O1wBfVsjj1_hNqtaugw334i0X4NgPLopE4Rb-to8riLA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 001/542] drm/amdgpu: remove set but not used
 variable 'mc_shared_chmap' from 'gfx_v6_0.c' and 'gfx_v7_0.c'
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        yu kuai <yukuai3@huawei.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:48 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: yu kuai <yukuai3@huawei.com>
>
> [ Upstream commit 747a397d394fac0001e4b3c03d7dce3a118af567 ]
>
> Fixes gcc '-Wunused-but-set-variable' warning:

There are a bunch of patches that remove set but unused variables in
this series of stable patches.  They shouldn't hurt anything, but they
are not really bug fixes per se.  I don't know if there is a general
opinion for how to deal with patches like this in stable.

Alex

>
> drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c: In function
> =E2=80=98gfx_v6_0_constants_init=E2=80=99:
> drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c:1579:6: warning: variable
> =E2=80=98mc_shared_chmap=E2=80=99 set but not used [-Wunused-but-set-vari=
able]
>
> drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c: In function
> =E2=80=98gfx_v7_0_gpu_early_init=E2=80=99:
> drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c:4262:6: warning: variable
> =E2=80=98mc_shared_chmap=E2=80=99 set but not used [-Wunused-but-set-vari=
able]
>
> Fixes: 2cd46ad22383 ("drm/amdgpu: add graphic pipeline implementation for=
 si v8")
> Fixes: d93f3ca706b8 ("drm/amdgpu/gfx7: rework gpu_init()")
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 3 +--
>  drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/=
amdgpu/gfx_v6_0.c
> index 7f0a63628c43a..31f44d05e606d 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
> @@ -1576,7 +1576,7 @@ static void gfx_v6_0_config_init(struct amdgpu_devi=
ce *adev)
>  static void gfx_v6_0_constants_init(struct amdgpu_device *adev)
>  {
>         u32 gb_addr_config =3D 0;
> -       u32 mc_shared_chmap, mc_arb_ramcfg;
> +       u32 mc_arb_ramcfg;
>         u32 sx_debug_1;
>         u32 hdp_host_path_cntl;
>         u32 tmp;
> @@ -1678,7 +1678,6 @@ static void gfx_v6_0_constants_init(struct amdgpu_d=
evice *adev)
>
>         WREG32(mmBIF_FB_EN, BIF_FB_EN__FB_READ_EN_MASK | BIF_FB_EN__FB_WR=
ITE_EN_MASK);
>
> -       mc_shared_chmap =3D RREG32(mmMC_SHARED_CHMAP);
>         adev->gfx.config.mc_arb_ramcfg =3D RREG32(mmMC_ARB_RAMCFG);
>         mc_arb_ramcfg =3D adev->gfx.config.mc_arb_ramcfg;
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c b/drivers/gpu/drm/amd/=
amdgpu/gfx_v7_0.c
> index d92e92e5d50b7..8f20a5dd44fe7 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
> @@ -4258,7 +4258,7 @@ static int gfx_v7_0_late_init(void *handle)
>  static void gfx_v7_0_gpu_early_init(struct amdgpu_device *adev)
>  {
>         u32 gb_addr_config;
> -       u32 mc_shared_chmap, mc_arb_ramcfg;
> +       u32 mc_arb_ramcfg;
>         u32 dimm00_addr_map, dimm01_addr_map, dimm10_addr_map, dimm11_add=
r_map;
>         u32 tmp;
>
> @@ -4335,7 +4335,6 @@ static void gfx_v7_0_gpu_early_init(struct amdgpu_d=
evice *adev)
>                 break;
>         }
>
> -       mc_shared_chmap =3D RREG32(mmMC_SHARED_CHMAP);
>         adev->gfx.config.mc_arb_ramcfg =3D RREG32(mmMC_ARB_RAMCFG);
>         mc_arb_ramcfg =3D adev->gfx.config.mc_arb_ramcfg;
>
> --
> 2.20.1
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
