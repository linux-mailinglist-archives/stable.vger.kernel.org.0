Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D24029BD4
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 18:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389831AbfEXQJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 12:09:55 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43814 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389588AbfEXQJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 12:09:55 -0400
Received: by mail-qk1-f194.google.com with SMTP id z6so8284854qkl.10
        for <stable@vger.kernel.org>; Fri, 24 May 2019 09:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pPF5M4T7jfmbO2sVZIkEKDwqwLFdt6EeO4Jbgz9qlDY=;
        b=rH6cGslaVWHT0aa/YZuPXDCwP99w50DKTprXZMxeMX1TZblUZ9vF/q7jsRzDeA/teu
         b62fT+NZUqP22nBG1cvT8mWl1BygRwaK+GhpHewvg/6UL8m7I4O7oOtdWvas+Gr6QbD3
         uAPaqrC8tZI11IYWZB/aMgHKwT47IFP+/HMJng/oVUuyFuM8HrISNTZjWA5wIfbBnySK
         EkRezVarH/ftHCjXpK+vTaJxSC3FRzASY/l4+zq9axZs8zuINwrqH6+k3baVlrKisxym
         0qF0kbbZ0cuzlimeooFKeUb7Wvnqr0bm1Dz48N8glqQJBw+GmOETr8ykWh2oDlS8LqpA
         Ma3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pPF5M4T7jfmbO2sVZIkEKDwqwLFdt6EeO4Jbgz9qlDY=;
        b=SkCTaluv2aU/qfdj13yrukvhPhKXyc5nORxy1efS6Zkduzkpw60OU1YKVqR02RX3Yf
         Wj5yBNs6mz9pshuYP/HShMkD86pq0Rx2rEt0Y5AakJip7VtPkYxZWr+3m1H3NzNVdPcB
         m1bl/MNrFyF9VIcKf1yiFXBA05xchSZNJ6cM1elsR5uEvCukzHGPZ5EZbHANUdowZ7X7
         Obis8keL0RhvZ8pnb9slN6b+Z8DvnJkMu1OAqyFwAFH3761FcXTZEF9yewM8/PsbgN0y
         pjhte4M5Srbu8KDdLOgVQdGTqQQq2zYc+nK789+MkZ89I/Ei4Bk0zzZRr3CPJSxMZml8
         nLIQ==
X-Gm-Message-State: APjAAAWoxoGE/I96pZqkvi/LQcEiHfkbZWRomi3My8QOXxU6URiKYIYl
        4dYpkQbF+VJmtQGmQSDyTVJlmOpvxZJQc7B7gUpipA==
X-Google-Smtp-Source: APXvYqwyPs/NisfCviyk+3rm00xHBAhpPgsgde1Fq32DbbDSzEQvbR0DD4WjalzMX4+O17NvmxwSVb1oRIhJTu8Xxt0=
X-Received: by 2002:a37:b7c6:: with SMTP id h189mr1868586qkf.347.1558714193671;
 Fri, 24 May 2019 09:09:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190524153410.19402-1-alexander.deucher@amd.com>
In-Reply-To: <20190524153410.19402-1-alexander.deucher@amd.com>
From:   Mike Lothian <mike@fireburn.co.uk>
Date:   Fri, 24 May 2019 17:09:41 +0100
Message-ID: <CAHbf0-FPr8EZoZeDJKpGp3=wF38JeG7fY-Ayq96jSqq3hMNM+g@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Don't load DMCU for Raven 1 (v2)
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Curious to know what this means for folk that have newer Raven1 boards
that didn't have issues loading the firmware

Cheers

Mike

On Fri, 24 May 2019 at 16:34, Alex Deucher <alexdeucher@gmail.com> wrote:
>
> From: Harry Wentland <harry.wentland@amd.com>
>
> [WHY]
> Some early Raven boards had a bad SBIOS that doesn't play nicely with
> the DMCU FW. We thought the issues were fixed by ignoring errors on DMCU
> load but that doesn't seem to be the case. We've still seen reports of
> users unable to boot their systems at all.
>
> [HOW]
> Disable DMCU load on Raven 1. Only load it for Raven 2 and Picasso.
>
> v2: Fix ifdef (Alex)
>
> Signed-off-by: Harry Wentland <harry.wentland@amd.com>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 995f9df66142..bcb1a93c0b4c 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -29,6 +29,7 @@
>  #include "dm_services_types.h"
>  #include "dc.h"
>  #include "dc/inc/core_types.h"
> +#include "dal_asic_id.h"
>
>  #include "vid.h"
>  #include "amdgpu.h"
> @@ -640,7 +641,7 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
>
>  static int load_dmcu_fw(struct amdgpu_device *adev)
>  {
> -       const char *fw_name_dmcu;
> +       const char *fw_name_dmcu = NULL;
>         int r;
>         const struct dmcu_firmware_header_v1_0 *hdr;
>
> @@ -663,7 +664,14 @@ static int load_dmcu_fw(struct amdgpu_device *adev)
>         case CHIP_VEGA20:
>                 return 0;
>         case CHIP_RAVEN:
> -               fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> +#if defined(CONFIG_DRM_AMD_DC_DCN1_01)
> +               if (ASICREV_IS_PICASSO(adev->external_rev_id))
> +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> +               else if (ASICREV_IS_RAVEN2(adev->external_rev_id))
> +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> +               else
> +#endif
> +                       return 0;
>                 break;
>         default:
>                 DRM_ERROR("Unsupported ASIC type: 0x%X\n", adev->asic_type);
> --
> 2.20.1
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
