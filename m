Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71EF2E7340
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 20:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgL2TnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 14:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL2TnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 14:43:24 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF430C0613D6
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 11:42:43 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id n9so13070793ili.0
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 11:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen.nl; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oekv1J5QG7HQ3jpbahBJYVPd5uN5IoF/8wAYXXEPdeY=;
        b=CA5qAg67Nub4Grsajvru4ROzGio57N4pcnmkQtFTyXsMiUXWKIWxKpPs1d9O3wLv3l
         WjzzPnSKAMWF1w06/8YA2KfhhgOn1k4gAoZWpa7GIdB/9++2cdXjs7tAeBWySlsX8uYR
         yNPlKs0f9DGDABxVTPD2t633C7tHnloPNgQoFvUBqty43qLmWHoL45kF8jVSyOTYeiSB
         VSaJtXwxgoOEf9dJtoP+5szcRjPrM8sEMUH9jpB00mGEGq3XMTAl7odRhTHrq9bLPXny
         IWJvYFrIC7ni+hNT6TuU3SUHO2MpTZny0vttTvgDrTUOi8r7FxcXUcwDKhjRjXPzHml5
         o6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oekv1J5QG7HQ3jpbahBJYVPd5uN5IoF/8wAYXXEPdeY=;
        b=lJ68iwBah/PmV3dX8lUox94DnVXNwzHs5gg719ghQ3r79WNtFGMIk6rMVri5jD/Exn
         MFqEe3WEc/gtz77feqRVsw32VozdZx/0O5676LBPBb4hXAI/UDylhr9GVwmyFphPB/t/
         yKkc2+kT9LhEJZEkOat5HZdD8pX7op63hecPZMeu+UAuD/vEPrVp+fJ394I1MY1g3fdq
         m+IxURu1HpctHb1Ei4od8PRftkh0+7U+wk5Q6LUP2MLK41QYPktL33cY9W3aKvL0G+Zv
         ndfv6uoBV3zquXUoMEbGhOR+ewW3AJfQZJWaFXSMMnZdOYQu6cpOfKNMt/aPkntyB3QK
         tJEg==
X-Gm-Message-State: AOAM533MQAtyCkk2u9Qumg0GToQ1aagWnPQBObEyFJPQ2W/o/yLARza2
        C6rV6sJynLIcp3XmqI2aKRf2M49dVGkmmFuJ/E5+ug==
X-Google-Smtp-Source: ABdhPJwWKk7L64dGy4mygYGkE3P97A14wHEdlYb5ivlJ8kyjewfcZc4ukTADMzFr5n6PwHgYQVbJUhcIylAumw3zc6s=
X-Received: by 2002:a05:6e02:ca5:: with SMTP id 5mr48244379ilg.40.1609270962974;
 Tue, 29 Dec 2020 11:42:42 -0800 (PST)
MIME-Version: 1.0
References: <20201228125020.963311703@linuxfoundation.org> <20201228125051.345050198@linuxfoundation.org>
In-Reply-To: <20201228125051.345050198@linuxfoundation.org>
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Date:   Tue, 29 Dec 2020 20:42:50 +0100
Message-ID: <CAP+8YyF+SeTpMDc_c4tFpBmmabwFJLymW7CByZwoYZD8UXGVVQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 635/717] drm/amd/display: Honor the offset for plane 0.
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Someone bisected a non-booting computer with 5.10.4-rc1 to this
commit. Would it be possible to back out of backporting this commit
(was backported to 5.4 and 5.10)? I suspect we may need
53f4cb8b5580a20d01449a7d8e1cbfdaed9ff6b6 to be picked too to avoid
regressing, but I'm not sure about process (e.g. timeline to confirm
things) here and a not booting computer is really bad.

Thanks,
Bas

On Mon, Dec 28, 2020 at 3:28 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>
> commit be7b9b327e79cd2db07b659af599867b629b2f66 upstream.
>
> With modifiers I'd like to support non-dedicated buffers for
> images.
>
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Cc: stable@vger.kernel.org # 5.1.0
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -3746,6 +3746,7 @@ fill_plane_dcc_attributes(struct amdgpu_
>         struct dc *dc = adev->dm.dc;
>         struct dc_dcc_surface_param input;
>         struct dc_surface_dcc_cap output;
> +       uint64_t plane_address = afb->address + afb->base.offsets[0];
>         uint32_t offset = AMDGPU_TILING_GET(info, DCC_OFFSET_256B);
>         uint32_t i64b = AMDGPU_TILING_GET(info, DCC_INDEPENDENT_64B) != 0;
>         uint64_t dcc_address;
> @@ -3789,7 +3790,7 @@ fill_plane_dcc_attributes(struct amdgpu_
>                 AMDGPU_TILING_GET(info, DCC_PITCH_MAX) + 1;
>         dcc->independent_64b_blks = i64b;
>
> -       dcc_address = get_dcc_address(afb->address, info);
> +       dcc_address = get_dcc_address(plane_address, info);
>         address->grph.meta_addr.low_part = lower_32_bits(dcc_address);
>         address->grph.meta_addr.high_part = upper_32_bits(dcc_address);
>
> @@ -3820,6 +3821,8 @@ fill_plane_buffer_attributes(struct amdg
>         address->tmz_surface = tmz_surface;
>
>         if (format < SURFACE_PIXEL_FORMAT_VIDEO_BEGIN) {
> +               uint64_t addr = afb->address + fb->offsets[0];
> +
>                 plane_size->surface_size.x = 0;
>                 plane_size->surface_size.y = 0;
>                 plane_size->surface_size.width = fb->width;
> @@ -3828,9 +3831,10 @@ fill_plane_buffer_attributes(struct amdg
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
> @@ -3851,9 +3855,9 @@ fill_plane_buffer_attributes(struct amdg
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
>
>
