Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D4C2961BC
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368659AbgJVPg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 11:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368658AbgJVPgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 11:36:25 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6025C0613CE
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 08:36:24 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l15so2782297wmi.3
        for <stable@vger.kernel.org>; Thu, 22 Oct 2020 08:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrreVJl3/iBumAL6z8lLKkGOkw/StiamIps+ryVt3+4=;
        b=HwZycMuBV77o/VutGHIL0MRWfGFoCVQmIC2zJDD+E46Trj4tdbLbMcH3JsVtmEJ3Kc
         SGUBd5jG18O41F4wyw80dD3JBnnVgDOaXEmtci+EtpwJC0foln1RZNT4TqUPPbnMXTSw
         HI5kIhMtA5O3jE6dxSdVeINcm6kKlw1TbnxADClmSeeqB8/ImIMNSa8vjfmYijA1nYpJ
         /TixVoTcxOiUa7sUueAJ/0ENK6EU7GSnpzKIkCzqPXiSiTQbV/MjyKasOPjsXwBKV2tQ
         Bt6sA5MVg3H65aYDlK4RZBPNJoQeHRW3Wjd52pPPoJMf4jmjEE7z1cNlI6nl1lcXl7F6
         sOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrreVJl3/iBumAL6z8lLKkGOkw/StiamIps+ryVt3+4=;
        b=VJIi3a9I+xgJEXWyTlKrwM2SzrqmqG97FSyw5LXKnFdV0vx0QuLiXynubRE3QMoKEL
         NcEordV8zlV8uDQ/G6kLtYFBCMxuC1/OlVuVGhymqMe/QkHYzwP5gLE5Sc7oEZzujkFr
         Puror4KTFCdx0AQCqVpYKvdl0/DEZue8MYCdfFvK0D8dwLLMOppK/YoqKTitimj8qWkJ
         /gvuztneo2H1lSQRXCRIU3kDPxSl4KNGrjXfW8HEwR2Dau7MNrfbm6d+IPF2cPtGccGK
         e2X7VEukj32gJI1euEtaQZoB233l4l+dWiKopPkT9vGEpGhT0XOs2oYg36DveL3VMh1J
         cPzg==
X-Gm-Message-State: AOAM530zXlix1BmDrU2JmZGqOjX2FIO1Mzl93Lux2MdWXSnqsYR+EjRJ
        +rdQi0+xXgMRtn7nzZdlte7ZfHphjFMc+yzX80E=
X-Google-Smtp-Source: ABdhPJwZOOriV4DCDPfkQUcTs/26ae61TdmKmffKBOk4l2Z/XuPB8k706JMyDHQ/s9HMnB9UFr1Z5EYaxtsn+xd7zW8=
X-Received: by 2002:a1c:c915:: with SMTP id f21mr3091644wmb.73.1603380983697;
 Thu, 22 Oct 2020 08:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201021233130.874615-1-bas@basnieuwenhuizen.nl> <20201021233130.874615-4-bas@basnieuwenhuizen.nl>
In-Reply-To: <20201021233130.874615-4-bas@basnieuwenhuizen.nl>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 22 Oct 2020 11:36:12 -0400
Message-ID: <CADnq5_OuXhN-2Raie9V452KrG4ChaguY1q6+Gk19mR86A=Fkog@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] drm/amd/display: Honor the offset for plane 0.
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Wentland, Harry" <harry.wentland@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Marek Olsak <maraeo@gmail.com>,
        "Kazlauskas, Nicholas" <nicholas.kazlauskas@amd.com>,
        "Leo (Sunpeng) Li" <sunpeng.li@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 21, 2020 at 7:31 PM Bas Nieuwenhuizen
<bas@basnieuwenhuizen.nl> wrote:
>
> With modifiers I'd like to support non-dedicated buffers for
> images.
>
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Cc: stable@vger.kernel.org # 5.1.0

I think you need # 5.1.x- for it to be applied to all stable kernels
since 5.1 otherwise it will just apply to 5.1.x

Alex

> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 73987fdb6a09..833887b9b0ad 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -3894,6 +3894,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
>         struct dc *dc = adev->dm.dc;
>         struct dc_dcc_surface_param input;
>         struct dc_surface_dcc_cap output;
> +       uint64_t plane_address = afb->address + afb->base.offsets[0];
>         uint32_t offset = AMDGPU_TILING_GET(info, DCC_OFFSET_256B);
>         uint32_t i64b = AMDGPU_TILING_GET(info, DCC_INDEPENDENT_64B) != 0;
>         uint64_t dcc_address;
> @@ -3937,7 +3938,7 @@ fill_plane_dcc_attributes(struct amdgpu_device *adev,
>                 AMDGPU_TILING_GET(info, DCC_PITCH_MAX) + 1;
>         dcc->independent_64b_blks = i64b;
>
> -       dcc_address = get_dcc_address(afb->address, info);
> +       dcc_address = get_dcc_address(plane_address, info);
>         address->grph.meta_addr.low_part = lower_32_bits(dcc_address);
>         address->grph.meta_addr.high_part = upper_32_bits(dcc_address);
>
> @@ -3968,6 +3969,8 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
>         address->tmz_surface = tmz_surface;
>
>         if (format < SURFACE_PIXEL_FORMAT_VIDEO_BEGIN) {
> +               uint64_t addr = afb->address + fb->offsets[0];
> +
>                 plane_size->surface_size.x = 0;
>                 plane_size->surface_size.y = 0;
>                 plane_size->surface_size.width = fb->width;
> @@ -3976,9 +3979,10 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
>                         fb->pitches[0] / fb->format->cpp[0];
>
>                 address->type = PLN_ADDR_TYPE_GRAPHICS;
> -               address->grph.addr.low_part = lower_32_bits(afb->address);
> -               address->grph.addr.high_part = upper_32_bits(afb->address);
> +               address->grph.addr.low_part = lower_32_bits(addr);
> +               address->grph.addr.high_part = upper_32_bits(addr);
>         } else if (format < SURFACE_PIXEL_FORMAT_INVALID) {
> +               uint64_t luma_addr = afb->address + fb->offsets[0];
>                 uint64_t chroma_addr = afb->address + fb->offsets[1];
>
>                 plane_size->surface_size.x = 0;
> @@ -3999,9 +4003,9 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
>
>                 address->type = PLN_ADDR_TYPE_VIDEO_PROGRESSIVE;
>                 address->video_progressive.luma_addr.low_part =
> -                       lower_32_bits(afb->address);
> +                       lower_32_bits(luma_addr);
>                 address->video_progressive.luma_addr.high_part =
> -                       upper_32_bits(afb->address);
> +                       upper_32_bits(luma_addr);
>                 address->video_progressive.chroma_addr.low_part =
>                         lower_32_bits(chroma_addr);
>                 address->video_progressive.chroma_addr.high_part =
> --
> 2.28.0
>
