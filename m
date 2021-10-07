Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470EF4260D5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 02:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhJHACL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 20:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhJHACL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 20:02:11 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B0C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 17:00:16 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id s4so17150670ybs.8
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 17:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=525REZtEeK0PFXhhzxFmSB8FcMG0mIL99+Md9Sh4UyI=;
        b=DqOdOwDJqcLiF+La2Dg1kaSYIsThJfYHt2LFa1VQB0w9gkLXQhokJtJHWFs9t73bWJ
         fea3c/m79MMYnmyW2Of9Aq6uq730fKdC58YSS+1/M/g1ErZfid3pPx9juNi+kzUPm4cR
         99rKU82ARLFAlyKv/dOxu/oiSBCVbDzUdnwuSYtjQPul7N6UoPHiigCj2Q9tobEiEm/i
         NZ+hThm9NrfLxaZQywggKUcGbruAcdfGFG0UtAzzyHGQUCOLqP1w9HSZZg0NUPE2iIBm
         waJ+e+vAJVxvvp+TwDIw349XikDiY2N6xn95uMyTPYGfaMkQFLaFbWHJniNGvVY4CGAy
         wNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=525REZtEeK0PFXhhzxFmSB8FcMG0mIL99+Md9Sh4UyI=;
        b=6nEGTXMW8PwtdvtTKALjJPkI0+M28HCL9K2/V1vLgY/RlPnJatKLVucXGMnc2UENlZ
         8yl70P8Z/2EZYdmvTebK9oq0JJCY4SDgWiyzMfTMoZuHgmcHfS0o2+f2pnfaA9PoNuNo
         PBePxgCU2TgwJq+hL2Bdvid/tZoj9ztZRP0Hp4x4dCgpRiw1Ck8qdu+lv6exywZzMz9J
         BAfnLRrXbDRvsXU/Qn75WuQT84XbGLuCkhupl/jbUpXyQJwG4VtO6f28/fNsSAG6k7sv
         oFQW+92+cqTCGr2GjcIZxwjKQQ2C+ecvWzUmfMHqiQyKeh2BvDHgnWPwLVr/6E+j+rmL
         jADA==
X-Gm-Message-State: AOAM5319CGTTVa/M++Nw5hfrrHiIjRFUBV+tEKmoi1+oReESKVDl6C/S
        fHeWnSZSwXM4RM/iB9rQnC3OPd3imgx1SADy5KQ=
X-Google-Smtp-Source: ABdhPJxxm5SOn3w6dvn60Fm3ACaWzgy85Fy4Tbn0+YzDCnyr8cOPzcronUtgdAdVZYUPd+W8tWCocGA70ZXQDwQY8s0=
X-Received: by 2002:a25:9a81:: with SMTP id s1mr24781ybo.230.1633651210963;
 Thu, 07 Oct 2021 17:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211007214117.231472-1-marex@denx.de> <CACO55tsgmtR1CqdJOBMu9oQEEojfpnUwWNvab9gA7ZuZmyiSmA@mail.gmail.com>
In-Reply-To: <CACO55tsgmtR1CqdJOBMu9oQEEojfpnUwWNvab9gA7ZuZmyiSmA@mail.gmail.com>
From:   Ben Skeggs <skeggsb@gmail.com>
Date:   Fri, 8 Oct 2021 09:59:59 +1000
Message-ID: <CACAvsv54TiYbG1SFnkRdcbO0yiUR6wuHn=wWJFDGEr5shhQ5wQ@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/fifo: Reinstate the correct engine bit programming
To:     Karol Herbst <kherbst@redhat.com>
Cc:     Marek Vasut <marex@denx.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        nouveau <nouveau@lists.freedesktop.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 8 Oct 2021 at 07:46, Karol Herbst <kherbst@redhat.com> wrote:
>
> Reviewed-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>

>
> I haven't checked if other places need fixing up yet, and I still want
> to test this patch, but I won't get to it until Monday. But if
> everything is in place we can get this pushed next week so we can
> finally fix this annoying issue :) I was also seeing some minor
> graphical corruptions which would be cool if this patch fixes it as
> well.
>
> Thanks for the patch and poking us about the bug again.
>
> On Thu, Oct 7, 2021 at 11:41 PM Marek Vasut <marex@denx.de> wrote:
> >
> > Commit 64f7c698bea9 ("drm/nouveau/fifo: add engine_id hook") replaced
> > fifo/chang84.c g84_fifo_chan_engine() call with an indirect call of
> > fifo/g84.c g84_fifo_engine_id(). The G84_FIFO_ENGN_* values returned
> > from the later g84_fifo_engine_id() are incremented by 1 compared to
> > the previous g84_fifo_chan_engine() return values.
> >
> > This is fine either way for most of the code, except this one line
> > where an engine bit programmed into the hardware is derived from the
> > return value. Decrement the return value accordingly, otherwise the
> > wrong engine bit is programmed into the hardware and that leads to
> > the following failure:
> > nouveau 0000:01:00.0: gr: 00000030 [ILLEGAL_MTHD ILLEGAL_CLASS] ch 1 [003fbce000 DRM] subc 3 class 0000 mthd 085c data 00000420
> >
> > On the following hardware:
> > lspci -s 01:00.0
> > 01:00.0 VGA compatible controller: NVIDIA Corporation GT216GLM [Quadro FX 880M] (rev a2)
> > lspci -ns 01:00.0
> > 01:00.0 0300: 10de:0a3c (rev a2)
> >
> > Fixes: 64f7c698bea9 ("drm/nouveau/fifo: add engine_id hook")
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: <stable@vger.kernel.org> # 5.12+
> > Cc: Ben Skeggs <bskeggs@redhat.com>
> > Cc: Karol Herbst <kherbst@redhat.com>
> > Cc: Lyude Paul <lyude@redhat.com>
> > ---
> >  drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
> > index 353b77d9b3dc..3492c561f2cf 100644
> > --- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
> > +++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
> > @@ -82,7 +82,7 @@ g84_fifo_chan_engine_fini(struct nvkm_fifo_chan *base,
> >         if (offset < 0)
> >                 return 0;
> >
> > -       engn = fifo->base.func->engine_id(&fifo->base, engine);
> > +       engn = fifo->base.func->engine_id(&fifo->base, engine) - 1;
> >         save = nvkm_mask(device, 0x002520, 0x0000003f, 1 << engn);
> >         nvkm_wr32(device, 0x0032fc, chan->base.inst->addr >> 12);
> >         done = nvkm_msec(device, 2000,
> > --
> > 2.33.0
> >
>
