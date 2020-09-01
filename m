Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB925A026
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 22:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIAUoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 16:44:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbgIAUoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 16:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598993042;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gPCf4u3EyicebY387YkKs2a22jsTBC/ti3P+b5RanuE=;
        b=KsQl7KtARyWulmDy/YfyTH7bA6jmK9sOL5EJH3IQzfRtWmTGAPonElvRfwJpraa88AusVK
        HUciAEQcXsaFicnaZ8PZ/u3dPMrJbG8S+Dxyc6Ijlh3t7jlEgEH47RvKDE6aqrhSRWIUYl
        LYxaajXLKkidanimP1LachrtcPitcOM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-6Z7v6GblPRKazFacM6N9KQ-1; Tue, 01 Sep 2020 16:43:58 -0400
X-MC-Unique: 6Z7v6GblPRKazFacM6N9KQ-1
Received: by mail-qk1-f199.google.com with SMTP id t1so1827973qkh.13
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 13:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=gPCf4u3EyicebY387YkKs2a22jsTBC/ti3P+b5RanuE=;
        b=l5XPZd3nHx4YXORaDCPK6Ln3GOVoY0uEnpGPAf70AEO3g2mzR86Wm3sNCVSUwNK+ds
         R1wYB5F1OQMAsLDweqQSlvdMxgvOgtNihdixWIPdAxk9zdytUO0VMXrZ2CLnOYH9fL90
         9k7/RFJW+14r8jBnErHO/BgkLJXW4GEH7TwgrmtWPUKwH7QgNZfG+mxsrbXjEnkwBIez
         WcFQMSuJ0HYkSgbqKwF+XOUUkdrYEd4JdPe/TN/kC01RfQk8VZRXokWU1WSLiuVS8xSN
         WOYeoQfxoUdWrLcQ5Pzz9kTiXsoZijl05SLptvH7OqYgbq0SWw7N5gX4yF4619h8umST
         U1vQ==
X-Gm-Message-State: AOAM533HHCUgKP1gM38iRdIzj6udmWKf/7FvzZD+JhrsCGlbMhYD0kdI
        3IhBMPNUB5nP3OIfXCLZoPsCrslI8sWGl9DPBckm3chd6OHkibCqm6fC/nQrkzh2qaRP7MUwKn1
        MqnGfKNgwIQ5yf2TE
X-Received: by 2002:a0c:b2d4:: with SMTP id d20mr3919070qvf.1.1598993038179;
        Tue, 01 Sep 2020 13:43:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMmHa3fHP8NY/dodaToFLVXTDFVn0f07O4xVQ5hfDgEZxkOry+RenIOt4w6jJJl7+Ml1CEdA==
X-Received: by 2002:a0c:b2d4:: with SMTP id d20mr3919050qvf.1.1598993037914;
        Tue, 01 Sep 2020 13:43:57 -0700 (PDT)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id g37sm2892530qtk.76.2020.09.01.13.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 13:43:57 -0700 (PDT)
Message-ID: <c099dc05ff80ea43033c72a52de51165d9b0f6ab.camel@redhat.com>
Subject: Re: [Nouveau] [PATCH 1/2] drm/nouveau/kms/nv50-: Program notifier
 offset before requesting disp caps
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Ben Skeggs <skeggsb@gmail.com>
Cc:     ML nouveau <nouveau@lists.freedesktop.org>,
        Sasha Levin <sashal@kernel.org>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" 
        <dri-devel@lists.freedesktop.org>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Date:   Tue, 01 Sep 2020 16:43:56 -0400
In-Reply-To: <CACAvsv6GKeX=u4Jn0VVJk1qgnPcnPCW6exukqjvfrfmm2mwSUg@mail.gmail.com>
References: <20200824183253.826343-1-lyude@redhat.com>
         <20200824183253.826343-2-lyude@redhat.com>
         <CACAvsv6hymdcGkEcigL3fWACZ_1POpB+aefq9d9ChnYv_dHnVg@mail.gmail.com>
         <76392bff28359a88fbdf0857f011e0ed9f666dc4.camel@redhat.com>
         <CACAvsv6GKeX=u4Jn0VVJk1qgnPcnPCW6exukqjvfrfmm2mwSUg@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-08-31 at 14:26 +1000, Ben Skeggs wrote:
> On Wed, 26 Aug 2020 at 02:52, Lyude Paul <lyude@redhat.com> wrote:
> > On Tue, 2020-08-25 at 08:28 +1000, Ben Skeggs wrote:
> > > On Tue, 25 Aug 2020 at 04:33, Lyude Paul <lyude@redhat.com> wrote:
> > > > Not entirely sure why this never came up when I originally tested this
> > > > (maybe some BIOSes already have this setup?) but the ->caps_init vfunc
> > > > appears to cause the display engine to throw an exception on driver
> > > > init, at least on my ThinkPad P72:
> > > > 
> > > > nouveau 0000:01:00.0: disp: chid 0 mthd 008c data 00000000 0000508c
> > > > 0000102b
> > > > 
> > > > This is magic nvidia speak for "You need to have the DMA notifier offset
> > > > programmed before you can call NV507D_GET_CAPABILITIES." So, let's fix
> > > > this by doing that, and also perform an update afterwards to prevent
> > > > racing with the GPU when reading capabilities.
> > > > 
> > > > Changes since v1:
> > > > * Don't just program the DMA notifier offset, make sure to actually
> > > >   perform an update
> > > I'm not sure there's a need to send an Update() method here, I believe
> > > GetCapabilities() is an action method on its own right?
> > > 
> > 
> > I'm not entirely sure about this part tbh. I do know that we need to call
> > GetCapabilities() _after_ the DMA notifier offset is programmed. But, my
> > assumption was that if GetCapabilities() requires a DMA notifier offset to
> > store
> > its results in, we'd probably want to fire an update or something to make
> > sure
> > that we're not reading before it finishes writing capabilities?
> We definitely want to *wait* on GetCapabilities() finishing, I believe
> it should also update the notifier the same (or similar) way Update()
> does.  But I don't think we want to send an Update() here, it'll
> actually trigger a modeset (which, on earlier HW, will tear down the
> boot mode.  Not sure about current HW, it might preserve state), and
> we may not want that to happen there.

I'm not so sure about that, as it seems like the notifier times out without the
update:

[    5.142033] nouveau 0000:1f:00.0: DRM: [DRM/00000000:kmsChanPush] 00000000: 00040088 mthd 0x0088 size 1 - core507d_init
[    5.142037] nouveau 0000:1f:00.0: DRM: [DRM/00000000:kmsChanPush] 00000004: f0000000-> NV507D_SET_CONTEXT_DMA_NOTIFIER
[    5.142041] nouveau 0000:1f:00.0: DRM: [DRM/00000000:kmsChanPush] 00000008: 00040084 mthd 0x0084 size 1 - core507d_caps_init
[    5.142044] nouveau 0000:1f:00.0: DRM: [DRM/00000000:kmsChanPush] 0000000c: 80000000-> NV507D_SET_NOTIFIER_CONTROL
[    5.142047] nouveau 0000:1f:00.0: DRM: [DRM/00000000:kmsChanPush] 00000010: 0004008c mthd 0x008c size 1 - core507d_caps_init
[    5.142050] nouveau 0000:1f:00.0: DRM: [DRM/00000000:kmsChanPush] 00000014: 00000000-> NV507D_GET_CAPABILITIES
[    7.142026] nouveau 0000:1f:00.0: DRM: core notifier timeout
[    7.142700] nouveau 0000:1f:00.0: DRM: sor-0002-0fc1 caps: dp_interlace=0
[    7.142708] nouveau 0000:1f:00.0: DRM: sor-0002-0fc4 caps: dp_interlace=0
[    7.142715] nouveau 0000:1f:00.0: DRM: sor-0002-0f42 caps: dp_interlace=0
[    7.142829] nouveau 0000:1f:00.0: DRM: sor-0006-0f82 caps: dp_interlace=0
[    7.142842] nouveau 0000:1f:00.0: DRM: sor-0002-0f82 caps: dp_interlace=0
[    7.142849] nouveau 0000:1f:00.0: DRM: failed to create encoder 1/8/0: -19
[    7.142851] nouveau 0000:1f:00.0: DRM: Virtual-1 has no encoders, removing

Any other alternatives to UPDATE we might want to try?

> 
> Ben.
> 
> > > Ben.
> > > 
> > > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > > > Fixes: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for
> > > > DP
> > > > interlacing support")
> > > > Cc: <stable@vger.kernel.org> # v5.8+
> > > > ---
> > > >  drivers/gpu/drm/nouveau/dispnv50/core507d.c | 25 ++++++++++++++++-----
> > > >  1 file changed, 19 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > > b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > > index e341f572c2696..5e86feec3b720 100644
> > > > --- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > > +++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > > > @@ -65,13 +65,26 @@ core507d_ntfy_init(struct nouveau_bo *bo, u32
> > > > offset)
> > > >  int
> > > >  core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
> > > >  {
> > > > -       u32 *push = evo_wait(&disp->core->chan, 2);
> > > > +       struct nv50_core *core = disp->core;
> > > > +       u32 interlock[NV50_DISP_INTERLOCK__SIZE] = {0};
> > > > +       u32 *push;
> > > > 
> > > > -       if (push) {
> > > > -               evo_mthd(push, 0x008c, 1);
> > > > -               evo_data(push, 0x0);
> > > > -               evo_kick(push, &disp->core->chan);
> > > > -       }
> > > > +       core->func->ntfy_init(disp->sync, NV50_DISP_CORE_NTFY);
> > > > +
> > > > +       push = evo_wait(&core->chan, 4);
> > > > +       if (!push)
> > > > +               return 0;
> > > > +
> > > > +       evo_mthd(push, 0x0084, 1);
> > > > +       evo_data(push, 0x80000000 | NV50_DISP_CORE_NTFY);
> > > > +       evo_mthd(push, 0x008c, 1);
> > > > +       evo_data(push, 0x0);
> > > > +       evo_kick(push, &core->chan);
> > > > +
> > > > +       core->func->update(core, interlock, false);
> > > > +       if (core->func->ntfy_wait_done(disp->sync, NV50_DISP_CORE_NTFY,
> > > > +                                      core->chan.base.device))
> > > > +               NV_ERROR(drm, "core notifier timeout\n");
> > > > 
> > > >         return 0;
> > > >  }
> > > > --
> > > > 2.26.2
> > > > 
> > > > _______________________________________________
> > > > Nouveau mailing list
> > > > Nouveau@lists.freedesktop.org
> > > > https://lists.freedesktop.org/mailman/listinfo/nouveau
> > --
> > Sincerely,
> >       Lyude Paul (she/her)
> >       Software Engineer at Red Hat
> > 
-- 
Sincerely,
      Lyude Paul (she/her)
      Software Engineer at Red Hat

