Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EF629C04
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390021AbfEXQUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 12:20:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39962 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389588AbfEXQUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 12:20:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id t4so2334921wrx.7
        for <stable@vger.kernel.org>; Fri, 24 May 2019 09:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=slvLGGxwcA81n+66TTX5xYFuTZXUqGR9443CdaEPwK4=;
        b=OYICc3CYj7vrTLFXf+o5oXN3Bf/ybIgXilu9A55qOLv3w42VsNrNI2HeY4E6LVxLja
         4lDBASlUIzyYmb1X0qeoOPrsKt2Byqu3WXTrSq24/jXSKSaCD4wzHfpDbYJwKcDX6xYk
         Z/TMtelz2/90UOB/lcGl5mofxOc3nTx0OD+8qyHVj4c1aijYSsq+lMg8BXNx4ika+TYK
         ORXy+RQ1EXpCVDGce4KkQ1TLqsHxorare3QRIaPQzqpzy7qbgOoJOizzORd0bDxM3v+7
         gMwFxQPjGPnbaFVLlYrii33M93hUCGi6Owdy81SVvI30DS3MmjTYZDu3CvF6VMKfulIK
         yuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=slvLGGxwcA81n+66TTX5xYFuTZXUqGR9443CdaEPwK4=;
        b=AlZAV0+mwPzarp6thOkIVmwLTt9zZHiSWsks4BlGPJsZ3EVpnOrm6PdC5IgISMVnUW
         C+yf3vK9tOYsT8Gd4kZzY15TorC7kvMoRDRfensVk7c3KcQOLVmy4dGE/1nTMrh4RDki
         MjojOXdUyVyyXjb0tK5IomeUOvTQlU1A09XJ5ctAYIvB2Sq3b6B6Qiw8UGCMHaankTmd
         KCXjBPwIJV0kMLjOgVUZoB1DTxv/2RM8Xax/8Qix+d0SYpnJD2b3J1ink7AgosTPXD0F
         nSyLgpEKLemIEMhwpp99Sud71Q/Pxvx3Qivg8Wo1WF8KpdDl7Ztot1mdAmqsplXPnb9f
         QUlQ==
X-Gm-Message-State: APjAAAWIm+Pd/sMy7X/n7KVTNMv+v50DhzXQK/AgkpN8kJpvHHdkxtUM
        b4R3Uv8xaPuSDLYwL07H8D7Kb2cxkGqHtDSRR30=
X-Google-Smtp-Source: APXvYqwFH64g6tZSGi0ay6VppV4n/FyzBcnoSfBuzJE8F2UqMd2ap+XRXjnoO0Aw2arRQVkzeBkJ9KVpYg4nQMFbxxQ=
X-Received: by 2002:a5d:4d46:: with SMTP id a6mr4608660wru.142.1558714815298;
 Fri, 24 May 2019 09:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190524153410.19402-1-alexander.deucher@amd.com> <CAHbf0-FPr8EZoZeDJKpGp3=wF38JeG7fY-Ayq96jSqq3hMNM+g@mail.gmail.com>
In-Reply-To: <CAHbf0-FPr8EZoZeDJKpGp3=wF38JeG7fY-Ayq96jSqq3hMNM+g@mail.gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 24 May 2019 12:20:03 -0400
Message-ID: <CADnq5_OGKUHGCSyFFQhmk5w1j+x5LQahh6KPbDfR2xnREdR3EA@mail.gmail.com>
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

On Fri, May 24, 2019 at 12:09 PM Mike Lothian <mike@fireburn.co.uk> wrote:
>
> Hi
>
> Curious to know what this means for folk that have newer Raven1 boards
> that didn't have issues loading the firmware

You won't get ABM I think.  ABM is the automatic backlight management.

Alex

>
> Cheers
>
> Mike
>
> On Fri, 24 May 2019 at 16:34, Alex Deucher <alexdeucher@gmail.com> wrote:
> >
> > From: Harry Wentland <harry.wentland@amd.com>
> >
> > [WHY]
> > Some early Raven boards had a bad SBIOS that doesn't play nicely with
> > the DMCU FW. We thought the issues were fixed by ignoring errors on DMCU
> > load but that doesn't seem to be the case. We've still seen reports of
> > users unable to boot their systems at all.
> >
> > [HOW]
> > Disable DMCU load on Raven 1. Only load it for Raven 2 and Picasso.
> >
> > v2: Fix ifdef (Alex)
> >
> > Signed-off-by: Harry Wentland <harry.wentland@amd.com>
> > Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > index 995f9df66142..bcb1a93c0b4c 100644
> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > @@ -29,6 +29,7 @@
> >  #include "dm_services_types.h"
> >  #include "dc.h"
> >  #include "dc/inc/core_types.h"
> > +#include "dal_asic_id.h"
> >
> >  #include "vid.h"
> >  #include "amdgpu.h"
> > @@ -640,7 +641,7 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
> >
> >  static int load_dmcu_fw(struct amdgpu_device *adev)
> >  {
> > -       const char *fw_name_dmcu;
> > +       const char *fw_name_dmcu = NULL;
> >         int r;
> >         const struct dmcu_firmware_header_v1_0 *hdr;
> >
> > @@ -663,7 +664,14 @@ static int load_dmcu_fw(struct amdgpu_device *adev)
> >         case CHIP_VEGA20:
> >                 return 0;
> >         case CHIP_RAVEN:
> > -               fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > +#if defined(CONFIG_DRM_AMD_DC_DCN1_01)
> > +               if (ASICREV_IS_PICASSO(adev->external_rev_id))
> > +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > +               else if (ASICREV_IS_RAVEN2(adev->external_rev_id))
> > +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > +               else
> > +#endif
> > +                       return 0;
> >                 break;
> >         default:
> >                 DRM_ERROR("Unsupported ASIC type: 0x%X\n", adev->asic_type);
> > --
> > 2.20.1
> >
> > _______________________________________________
> > amd-gfx mailing list
> > amd-gfx@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/amd-gfx
