Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160C9219467
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 01:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgGHXiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 19:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGHXiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 19:38:04 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD401C061A0B;
        Wed,  8 Jul 2020 16:38:03 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id v8so440311iox.2;
        Wed, 08 Jul 2020 16:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f47scpZOxXSsY6W8L1L6Au8DwYsSbegHA1p5rzFY5es=;
        b=IC9IIO6b9s4jTGz6cJvwph0OOL71V+85KCI4BlHzOmA0GHrC/bzIQAc3lUl9myLgH0
         t59XZeW20Fsm9OR/sD5Pu1fo0yXoqxYOyF6FevUwwJjxYW9p8oxZDu4UJuEusgcgEufv
         sAqvsvs37LtebjkQm3YNCA1gulO2SvDOARUJpc9EHu85jP1VwMZuxBN/IHj+6K90lNZf
         png/ccGLJ0IYEJMeCXL9pBgj2Ssgrf1ehPFa3FvROy38XPMEttMIycaD6yOjNbYuUNby
         ZiLHHXeehCwF2Sflaj8LG+kfYlcj8o/2C8Fw9xwIYCs9LHxPT0ut+ClzzP/Uf7Rr+JWE
         ERmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f47scpZOxXSsY6W8L1L6Au8DwYsSbegHA1p5rzFY5es=;
        b=Spfle+r1aLZIPnUFR0q/SarM0LG5IyjZ717OYG3xPrI7SqAEOj+aI+JRgzFidtUQIB
         66/PDEUnIBVUk+BQP23C8QBorpyCRbfT2jHbTy18oX65pGYgQMdqzo/krAw8HKNTOc/P
         dWWts3MjmvT/OO4qe24ScNjKnVQ3et3XJ0d0MhvSSABmsaj56DhkUS6e+J0luaIdsdLG
         K9SZFUE6aWAUefuExH+ZDjeJV6xwIymdzSvN8YQPn22UJH/EPYhBYYTBrie0VlGt9lDD
         XsSjWt1EugSvjwlB79atyjjzhUYd5tzbd87WlpdQa4OUlIUOwmguvBvCW9LCuVEwxlym
         nDYg==
X-Gm-Message-State: AOAM531sD7JQUgwHeZKrRtWh1HxG2YoQifqKOuaWkmlEKbShn6FLdXsG
        Tvs3CaJ+c8MD3JMe3IlJqctuY5b5ClMXH08MI4k=
X-Google-Smtp-Source: ABdhPJw1145gDWa1GO1furMPD1GHeDogxFjouwIcAVYJAllovviWaduyt1BA8w7sLVgNcF+nTP7j6IvLTJe0gKa2Rqc=
X-Received: by 2002:a6b:f618:: with SMTP id n24mr14872406ioh.35.1594251483074;
 Wed, 08 Jul 2020 16:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200630182636.439015-1-aford173@gmail.com> <b9052a12-af5a-c1b9-5b86-907eac470cf8@ti.com>
 <20200703193648.GA373653@ravnborg.org> <bda1606f-b12c-3356-15ce-489fc2441737@ti.com>
 <CAHCN7xJdg8uUDaghFftze2K6t2pnyZg_JYpdmA=UU-shmk0Xgw@mail.gmail.com>
In-Reply-To: <CAHCN7xJdg8uUDaghFftze2K6t2pnyZg_JYpdmA=UU-shmk0Xgw@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Wed, 8 Jul 2020 18:37:51 -0500
Message-ID: <CAHCN7xLGAWEO5CPDOsHoy4B0FjD+1GHhHYgihmVg=mhjUFjSTQ@mail.gmail.com>
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 6, 2020 at 6:18 AM Adam Ford <aford173@gmail.com> wrote:
>
> On Mon, Jul 6, 2020 at 1:02 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> >
> > Hi,
> >
> > On 03/07/2020 22:36, Sam Ravnborg wrote:
> > > Hi Tomi.
> > >
> > > On Fri, Jul 03, 2020 at 10:17:29AM +0300, Tomi Valkeinen wrote:
> > >> On 30/06/2020 21:26, Adam Ford wrote:
> > >>> The drm/omap driver was fixed to correct an issue where using a
> > >>> divider of 32 breaks the DSS despite the TRM stating 32 is a valid
> > >>> number.  Through experimentation, it appears that 31 works, and
> > >>> it is consistent with the value used by the drm/omap driver.
> > >>>
> > >>> This patch fixes the divider for fbdev driver instead of the drm.
> > >>>
> > >>> Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> > >>>
> > >>> Cc: <stable@vger.kernel.org> #4.9+
> > >>> Signed-off-by: Adam Ford <aford173@gmail.com>
> > >>> ---
> > >>> Linux 4.4 will need a similar patch, but it doesn't apply cleanly.
> > >>>
> > >>> The DRM version of this same fix is:
> > >>> e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")
> > >>>
> > >>>
> > >>> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > >>> index 7252d22dd117..bfc5c4c5a26a 100644
> > >>> --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > >>> +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> > >>> @@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
> > >>>    };
> > >>>    static const struct dss_features omap3630_dss_feats = {
> > >>> -   .fck_div_max            =       32,
> > >>> +   .fck_div_max            =       31,
> > >>>     .dss_fck_multiplier     =       1,
> > >>>     .parent_clk_name        =       "dpll4_ck",
> > >>>     .dpi_select_source      =       &dss_dpi_select_source_omap2_omap3,
> > >>>
> > >>
> > >> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > Will you apply to drm-misc?
> >
> > This is for fbdev, so I presume Bartlomiej will pick this one.
> >
> > > Note  following output from "dim fixes":
> > > $ dim fixes f76ee892a99e
> > > Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> > > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > Cc: Dave Airlie <airlied@gmail.com>
> > > Cc: Rob Clark <robdclark@gmail.com>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Sam Ravnborg <sam@ravnborg.org>
> > > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Cc: Jason Yan <yanaijie@huawei.com>
> > > Cc: "Andrew F. Davis" <afd@ti.com>
> > > Cc: YueHaibing <yuehaibing@huawei.com>
> > > Cc: <stable@vger.kernel.org> # v4.5+
> > >
> > > Here it says the fix is valid from v4.5 onwards.
> >
> > Hmm... Adam, you marked the fix to apply to v4.9+, and then you said
> > v4.4 needs a new patch (that's before the big copy/rename). Did you
> > check the versions between 4.4 and 4.9? I would guess this one applies
> > to v4.5+.
>
> I only tried 4.9 because it's listed as an LTS kernel.  The stuff
> between 4.4 and 4.9 were EOL, so I didn't go back further.    The 4.5+
> is probably more accurate.  I would like to do the same thing for the
> 4.4 kernel, but I am not sure the proper way to do that.

What is the correct protocol for patching 4.4?  I'd like to do that,
but the patch would be unique to the 4.4.  Should I just submit the
patch directly to stable and cc Tomi?

adam
>
> adam
> >
> >   Tomi
> >
> > --
> > Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> > Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
