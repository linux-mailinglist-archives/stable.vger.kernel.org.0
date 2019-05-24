Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B0429C82
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391041AbfEXQtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 12:49:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33791 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390346AbfEXQtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 12:49:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id d9so10705101wrx.0
        for <stable@vger.kernel.org>; Fri, 24 May 2019 09:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sad9UpfHJ5sdXzTlwQdywQcHgqAyjq3tv2YnvpOkuAU=;
        b=Zuagl5Op4aTTiGFH4ijpjh5xhLnvU10ZjZST3gg+CW5fzknUbGDlfMQ0SynMNvGBtd
         RneXrFfLxqGY3LalCqUN4loZBm2JI3I22IFg20e4Wlj7c0cDQOpubtlacf41I3Ro4pqL
         ehLeIfHCFqv/ZAWKoSCjikLe0gmqgIztpCgXh85cgn+O7X+Qxq2aAdpfDb9tjs8qHw9h
         63Ji+wfZIrG3zq2we4eF+kS5Pv/bHiY+MwcXqBv/jjKmrS/A2cSrJGp6Zt9huePKpA+n
         GPqgtqMM1iqXKIHwnadqtAl3hTrOwk6al4i8ti6A8NnU7xp9KEQXCafqWO7TcKphLj1o
         O5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sad9UpfHJ5sdXzTlwQdywQcHgqAyjq3tv2YnvpOkuAU=;
        b=Hx0s6cYq3kV3q8/bZ7q1XVpD5UQ+kJgWJ3iDvpY+8FYgP6Ue5NGp4OSUPAEqPVDH+E
         pK00ogq+UzCAbrbWvYuBJrspCxUmhxFZhtT1o6tNuySz9yqQgsPRLxFZaUMPpzvpp0/R
         jm2ZYtNWibIKSKd5EVO+mqvp/BcCgSvn6AeafkMaM32NupHDw5DVmal52Q0cr3sPyxXI
         dbx2sfqduCeiu7ywbjZwbfTm0XTZlD7VHkVH2wZqEg3HuVa/nupar5iRktNuK0bwN8Et
         lRyZ1Qx3UXDCyWndnGJ4awh7wRGzrgqMSPiau8G/CF9sb/hghDm/UT4ixSWU55JV+0It
         uNOA==
X-Gm-Message-State: APjAAAXZGPZEiqDBXkIfP51X+vKKPg5Hp3kxJ6UxQ7TBcVqcTylLgtn6
        nOLgDmp13f9pSE3mJiDTe0LglDMe6OJjL3+rvvw=
X-Google-Smtp-Source: APXvYqwZ1Jupf4nzh4giK/K7tUXKf4/KkODs0l91yOUoyoodzJg/m4oK4AGkqJuUW+t/tPN/1tXUuebiAlP1rX9peu8=
X-Received: by 2002:adf:b6a5:: with SMTP id j37mr60560521wre.4.1558716579769;
 Fri, 24 May 2019 09:49:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190524153410.19402-1-alexander.deucher@amd.com>
 <CAHbf0-FPr8EZoZeDJKpGp3=wF38JeG7fY-Ayq96jSqq3hMNM+g@mail.gmail.com>
 <CADnq5_OGKUHGCSyFFQhmk5w1j+x5LQahh6KPbDfR2xnREdR3EA@mail.gmail.com> <CAHbf0-EYvnaVmqB068CA9hi3Wt7U2a387n6SCUdw8sUjouayZQ@mail.gmail.com>
In-Reply-To: <CAHbf0-EYvnaVmqB068CA9hi3Wt7U2a387n6SCUdw8sUjouayZQ@mail.gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 24 May 2019 12:49:27 -0400
Message-ID: <CADnq5_N48x5Zas_HWTN1JdEgUUmFadsSiu5_1uZmRgaDw+qraw@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Don't load DMCU for Raven 1 (v2)
To:     Mike Lothian <mike@fireburn.co.uk>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 12:32 PM Mike Lothian <mike@fireburn.co.uk> wrote:
>
> I realise you don't want to enable this as it's breaking some people's
> systems, but could we add a new boot parameter to force it for working
> systems? Or check against a black list maybe?

We could probably add a whitelist.  I'm not sure what the best way to
id the working systems are though.

Alex

>
> On Fri, 24 May 2019 at 17:20, Alex Deucher <alexdeucher@gmail.com> wrote:
> >
> > On Fri, May 24, 2019 at 12:09 PM Mike Lothian <mike@fireburn.co.uk> wrote:
> > >
> > > Hi
> > >
> > > Curious to know what this means for folk that have newer Raven1 boards
> > > that didn't have issues loading the firmware
> >
> > You won't get ABM I think.  ABM is the automatic backlight management.
> >
> > Alex
> >
> > >
> > > Cheers
> > >
> > > Mike
> > >
> > > On Fri, 24 May 2019 at 16:34, Alex Deucher <alexdeucher@gmail.com> wrote:
> > > >
> > > > From: Harry Wentland <harry.wentland@amd.com>
> > > >
> > > > [WHY]
> > > > Some early Raven boards had a bad SBIOS that doesn't play nicely with
> > > > the DMCU FW. We thought the issues were fixed by ignoring errors on DMCU
> > > > load but that doesn't seem to be the case. We've still seen reports of
> > > > users unable to boot their systems at all.
> > > >
> > > > [HOW]
> > > > Disable DMCU load on Raven 1. Only load it for Raven 2 and Picasso.
> > > >
> > > > v2: Fix ifdef (Alex)
> > > >
> > > > Signed-off-by: Harry Wentland <harry.wentland@amd.com>
> > > > Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++++++--
> > > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > > index 995f9df66142..bcb1a93c0b4c 100644
> > > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > > @@ -29,6 +29,7 @@
> > > >  #include "dm_services_types.h"
> > > >  #include "dc.h"
> > > >  #include "dc/inc/core_types.h"
> > > > +#include "dal_asic_id.h"
> > > >
> > > >  #include "vid.h"
> > > >  #include "amdgpu.h"
> > > > @@ -640,7 +641,7 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
> > > >
> > > >  static int load_dmcu_fw(struct amdgpu_device *adev)
> > > >  {
> > > > -       const char *fw_name_dmcu;
> > > > +       const char *fw_name_dmcu = NULL;
> > > >         int r;
> > > >         const struct dmcu_firmware_header_v1_0 *hdr;
> > > >
> > > > @@ -663,7 +664,14 @@ static int load_dmcu_fw(struct amdgpu_device *adev)
> > > >         case CHIP_VEGA20:
> > > >                 return 0;
> > > >         case CHIP_RAVEN:
> > > > -               fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > > > +#if defined(CONFIG_DRM_AMD_DC_DCN1_01)
> > > > +               if (ASICREV_IS_PICASSO(adev->external_rev_id))
> > > > +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > > > +               else if (ASICREV_IS_RAVEN2(adev->external_rev_id))
> > > > +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > > > +               else
> > > > +#endif
> > > > +                       return 0;
> > > >                 break;
> > > >         default:
> > > >                 DRM_ERROR("Unsupported ASIC type: 0x%X\n", adev->asic_type);
> > > > --
> > > > 2.20.1
> > > >
> > > > _______________________________________________
> > > > amd-gfx mailing list
> > > > amd-gfx@lists.freedesktop.org
> > > > https://lists.freedesktop.org/mailman/listinfo/amd-gfx
