Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CCF2572D1
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 06:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgHaE0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 00:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgHaE0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 00:26:32 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7302BC061573;
        Sun, 30 Aug 2020 21:26:32 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 145so2150241ybd.0;
        Sun, 30 Aug 2020 21:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PX06aBk627NQ1JeMegFd6B64tEFsLtmyNkqRlailfm0=;
        b=IC5nDs49gJJNp2v81GvqILFp/15eYtDl2QXUOSAriKrk+Im/ZtF0wapcjFhYD1Aee2
         jvbpHrmUBKZXPH50RHisaYAu6eL3nQMi8tqIbaQ0/GVrplidaSlxi0XkF9MZl9ZISJUy
         4R6NeoUFpvYWgz/AVuuJruEx6FpoghNJLz+43yhjUyTFi+RgQA0FMEjf7VmO0Gn4rpOp
         K/qD0gy4DvulktUJNfw234A3UgA/n0f5FM+/q+PywIVycMRHERMlSkWhhpulpNbrvxve
         NZ2SJEQXzdPfvLg/ZZLsNRwFLSf7nvcbLvCRacQlOO83T58wRYi8uvtv/ICk4aX+fulv
         i55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PX06aBk627NQ1JeMegFd6B64tEFsLtmyNkqRlailfm0=;
        b=jrTbdNG/7rPlno8AW8yHDtug7LCwv+y6m0FR9rcFGDwrXwHklOeQN0CkteKwgbxVpY
         MqlfmaCSCGNeKwnrndVM4aYVvUHMvxr4EGc9sHAXfTy2tzVVmgnmU894N/8ikwCI+KZ0
         UDNBs7aPQSQQKtIZO1srBZUuo5UoxL4k7BSjw8CE1VXp9FvHr1GBkRvv4S1Am9Fi9AUz
         sgiFnEn8hY/qqLsfKHTaNVCgzlvr2PRu8gaEqbnudzlsAQEbbkHCHkGy8BwgJKBQPrfO
         oATnsqPFLlfYptl9zFPiaGYMa3fOvs6kBY3bzhN52Cu/kh+Kp+5KR3TS3oawJFDw/ZnS
         gtLw==
X-Gm-Message-State: AOAM532faJvNngQjAgMzCQhdAOXU0WIiYn3Ono+mPf+CJ7gfVE/lJwe3
        JzU2vGf0Jl9izXD6A/kpsrAz9iSUU5rQkyr9xQ6LcCw1G+M=
X-Google-Smtp-Source: ABdhPJy+0rEbq+GkNgtCw3GXB22ZHNHLhDwqJ7psgye+ciyrN8LcA9ntQoXdSFcOYdxLiOIsyTwz2cd2MlTJH1iqhGY=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr16615125ybf.162.1598847990436;
 Sun, 30 Aug 2020 21:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200824183253.826343-1-lyude@redhat.com> <20200824183253.826343-2-lyude@redhat.com>
 <CACAvsv6hymdcGkEcigL3fWACZ_1POpB+aefq9d9ChnYv_dHnVg@mail.gmail.com> <76392bff28359a88fbdf0857f011e0ed9f666dc4.camel@redhat.com>
In-Reply-To: <76392bff28359a88fbdf0857f011e0ed9f666dc4.camel@redhat.com>
From:   Ben Skeggs <skeggsb@gmail.com>
Date:   Mon, 31 Aug 2020 14:26:19 +1000
Message-ID: <CACAvsv6GKeX=u4Jn0VVJk1qgnPcnPCW6exukqjvfrfmm2mwSUg@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 1/2] drm/nouveau/kms/nv50-: Program notifier
 offset before requesting disp caps
To:     Lyude Paul <lyude@redhat.com>
Cc:     ML nouveau <nouveau@lists.freedesktop.org>,
        Sasha Levin <sashal@kernel.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" 
        <dri-devel@lists.freedesktop.org>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 02:52, Lyude Paul <lyude@redhat.com> wrote:
>
> On Tue, 2020-08-25 at 08:28 +1000, Ben Skeggs wrote:
> > On Tue, 25 Aug 2020 at 04:33, Lyude Paul <lyude@redhat.com> wrote:
> > > Not entirely sure why this never came up when I originally tested this
> > > (maybe some BIOSes already have this setup?) but the ->caps_init vfunc
> > > appears to cause the display engine to throw an exception on driver
> > > init, at least on my ThinkPad P72:
> > >
> > > nouveau 0000:01:00.0: disp: chid 0 mthd 008c data 00000000 0000508c 0000102b
> > >
> > > This is magic nvidia speak for "You need to have the DMA notifier offset
> > > programmed before you can call NV507D_GET_CAPABILITIES." So, let's fix
> > > this by doing that, and also perform an update afterwards to prevent
> > > racing with the GPU when reading capabilities.
> > >
> > > Changes since v1:
> > > * Don't just program the DMA notifier offset, make sure to actually
> > >   perform an update
> > I'm not sure there's a need to send an Update() method here, I believe
> > GetCapabilities() is an action method on its own right?
> >
>
> I'm not entirely sure about this part tbh. I do know that we need to call
> GetCapabilities() _after_ the DMA notifier offset is programmed. But, my
> assumption was that if GetCapabilities() requires a DMA notifier offset to store
> its results in, we'd probably want to fire an update or something to make sure
> that we're not reading before it finishes writing capabilities?
We definitely want to *wait* on GetCapabilities() finishing, I believe
it should also update the notifier the same (or similar) way Update()
does.  But I don't think we want to send an Update() here, it'll
actually trigger a modeset (which, on earlier HW, will tear down the
boot mode.  Not sure about current HW, it might preserve state), and
we may not want that to happen there.

Ben.

>
> > Ben.
> >
> > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > > Fixes: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP
> > > interlacing support")
> > > Cc: <stable@vger.kernel.org> # v5.8+
> > > ---
> > >  drivers/gpu/drm/nouveau/dispnv50/core507d.c | 25 ++++++++++++++++-----
> > >  1 file changed, 19 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > index e341f572c2696..5e86feec3b720 100644
> > > --- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > +++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > @@ -65,13 +65,26 @@ core507d_ntfy_init(struct nouveau_bo *bo, u32 offset)
> > >  int
> > >  core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
> > >  {
> > > -       u32 *push = evo_wait(&disp->core->chan, 2);
> > > +       struct nv50_core *core = disp->core;
> > > +       u32 interlock[NV50_DISP_INTERLOCK__SIZE] = {0};
> > > +       u32 *push;
> > >
> > > -       if (push) {
> > > -               evo_mthd(push, 0x008c, 1);
> > > -               evo_data(push, 0x0);
> > > -               evo_kick(push, &disp->core->chan);
> > > -       }
> > > +       core->func->ntfy_init(disp->sync, NV50_DISP_CORE_NTFY);
> > > +
> > > +       push = evo_wait(&core->chan, 4);
> > > +       if (!push)
> > > +               return 0;
> > > +
> > > +       evo_mthd(push, 0x0084, 1);
> > > +       evo_data(push, 0x80000000 | NV50_DISP_CORE_NTFY);
> > > +       evo_mthd(push, 0x008c, 1);
> > > +       evo_data(push, 0x0);
> > > +       evo_kick(push, &core->chan);
> > > +
> > > +       core->func->update(core, interlock, false);
> > > +       if (core->func->ntfy_wait_done(disp->sync, NV50_DISP_CORE_NTFY,
> > > +                                      core->chan.base.device))
> > > +               NV_ERROR(drm, "core notifier timeout\n");
> > >
> > >         return 0;
> > >  }
> > > --
> > > 2.26.2
> > >
> > > _______________________________________________
> > > Nouveau mailing list
> > > Nouveau@lists.freedesktop.org
> > > https://lists.freedesktop.org/mailman/listinfo/nouveau
> --
> Sincerely,
>       Lyude Paul (she/her)
>       Software Engineer at Red Hat
>
