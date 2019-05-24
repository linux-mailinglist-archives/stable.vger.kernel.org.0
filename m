Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12BF729C5A
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390210AbfEXQc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 12:32:56 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45397 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390021AbfEXQc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 12:32:56 -0400
Received: by mail-qk1-f195.google.com with SMTP id j1so8397713qkk.12
        for <stable@vger.kernel.org>; Fri, 24 May 2019 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7JEiTdPVCIFQdDUK8gYkULbjQdi6LzSI19f3jsOolXA=;
        b=JWWY34bf57x5nejLM6ABDjAsfbAefju5JNa2pbQTKUh3PwauoxTcPsqtzEUAjC9wBU
         5A6TTXmHEb8+8R25UPRarpwSkZRG7EhfRdA2RGp49IjKIDDIc5wowc7USygz2s7aisxP
         +1LuUwKrgU+W3jkszuFAgCRDh6tAzG7VVXvcq3QamKZjQ+ssJQezf2YY4iU8iFFn2eRM
         k81NPiECRSr0feJvT0n4OL7N9QAGtpR2hF6pvto0xKYHKDm7r2CVVbeiCQ7o8+x8lT60
         RoJONSUGQkP0i9qcTBm+5oZ1lcuAuLkj/vHK91HDK9UxnH1nsZcpJrTVFBn6ZdirPD07
         7NsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7JEiTdPVCIFQdDUK8gYkULbjQdi6LzSI19f3jsOolXA=;
        b=o54kl/jqHIqFtuJwSWS8OjC3qbXvPW2SjEGlufkwY4dTcIKMt2DFbM5cKpTmUcHTTV
         c52fS3hAPDGVELHWy1pdZ5byLzHlnFH7JPBmjYUsS2PdcLJDZOTCoG6wVu/g8cwFsJzr
         bBdaDUaESJHtZlGXA/m6spfbwRUStjy/L/EvNUX+v1muu+tT74bNCV9VmKS4rs2OXh3w
         Vf7rTwxJesn4E20RhickBAxMEroZioIwufMvh/fvOZsYvUsXF9/XldhbJ3XKuosA+xn7
         iUFd4eaOY4i9XBvi8h7BnDWvwWh4J8Hw+PBbiTyPb7d+4N1bpJSRDrfyvLBIhLsfllhP
         xf9g==
X-Gm-Message-State: APjAAAVwQvGeFbQBemuu0A9+7c8iO3a2YJISMmfinvKbc6b+ijXJTgs0
        i1ROS0t+6vY2fnOuqTAZh0hCio2xTK4O1vNlayST/w==
X-Google-Smtp-Source: APXvYqxYdKVV/8Z7jqxrd4PGccsInkiA4fhiupq8gF3tQUXKiZbIhhfTAbiz8YkdFjqcsNHfo+Q2OjRtYmk5x+I2d9g=
X-Received: by 2002:ac8:534d:: with SMTP id d13mr47604011qto.217.1558715574951;
 Fri, 24 May 2019 09:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190524153410.19402-1-alexander.deucher@amd.com>
 <CAHbf0-FPr8EZoZeDJKpGp3=wF38JeG7fY-Ayq96jSqq3hMNM+g@mail.gmail.com> <CADnq5_OGKUHGCSyFFQhmk5w1j+x5LQahh6KPbDfR2xnREdR3EA@mail.gmail.com>
In-Reply-To: <CADnq5_OGKUHGCSyFFQhmk5w1j+x5LQahh6KPbDfR2xnREdR3EA@mail.gmail.com>
From:   Mike Lothian <mike@fireburn.co.uk>
Date:   Fri, 24 May 2019 17:32:42 +0100
Message-ID: <CAHbf0-EYvnaVmqB068CA9hi3Wt7U2a387n6SCUdw8sUjouayZQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Don't load DMCU for Raven 1 (v2)
To:     Alex Deucher <alexdeucher@gmail.com>
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

I realise you don't want to enable this as it's breaking some people's
systems, but could we add a new boot parameter to force it for working
systems? Or check against a black list maybe?

On Fri, 24 May 2019 at 17:20, Alex Deucher <alexdeucher@gmail.com> wrote:
>
> On Fri, May 24, 2019 at 12:09 PM Mike Lothian <mike@fireburn.co.uk> wrote:
> >
> > Hi
> >
> > Curious to know what this means for folk that have newer Raven1 boards
> > that didn't have issues loading the firmware
>
> You won't get ABM I think.  ABM is the automatic backlight management.
>
> Alex
>
> >
> > Cheers
> >
> > Mike
> >
> > On Fri, 24 May 2019 at 16:34, Alex Deucher <alexdeucher@gmail.com> wrote:
> > >
> > > From: Harry Wentland <harry.wentland@amd.com>
> > >
> > > [WHY]
> > > Some early Raven boards had a bad SBIOS that doesn't play nicely with
> > > the DMCU FW. We thought the issues were fixed by ignoring errors on DMCU
> > > load but that doesn't seem to be the case. We've still seen reports of
> > > users unable to boot their systems at all.
> > >
> > > [HOW]
> > > Disable DMCU load on Raven 1. Only load it for Raven 2 and Picasso.
> > >
> > > v2: Fix ifdef (Alex)
> > >
> > > Signed-off-by: Harry Wentland <harry.wentland@amd.com>
> > > Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > index 995f9df66142..bcb1a93c0b4c 100644
> > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > > @@ -29,6 +29,7 @@
> > >  #include "dm_services_types.h"
> > >  #include "dc.h"
> > >  #include "dc/inc/core_types.h"
> > > +#include "dal_asic_id.h"
> > >
> > >  #include "vid.h"
> > >  #include "amdgpu.h"
> > > @@ -640,7 +641,7 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
> > >
> > >  static int load_dmcu_fw(struct amdgpu_device *adev)
> > >  {
> > > -       const char *fw_name_dmcu;
> > > +       const char *fw_name_dmcu = NULL;
> > >         int r;
> > >         const struct dmcu_firmware_header_v1_0 *hdr;
> > >
> > > @@ -663,7 +664,14 @@ static int load_dmcu_fw(struct amdgpu_device *adev)
> > >         case CHIP_VEGA20:
> > >                 return 0;
> > >         case CHIP_RAVEN:
> > > -               fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > > +#if defined(CONFIG_DRM_AMD_DC_DCN1_01)
> > > +               if (ASICREV_IS_PICASSO(adev->external_rev_id))
> > > +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > > +               else if (ASICREV_IS_RAVEN2(adev->external_rev_id))
> > > +                       fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
> > > +               else
> > > +#endif
> > > +                       return 0;
> > >                 break;
> > >         default:
> > >                 DRM_ERROR("Unsupported ASIC type: 0x%X\n", adev->asic_type);
> > > --
> > > 2.20.1
> > >
> > > _______________________________________________
> > > amd-gfx mailing list
> > > amd-gfx@lists.freedesktop.org
> > > https://lists.freedesktop.org/mailman/listinfo/amd-gfx
