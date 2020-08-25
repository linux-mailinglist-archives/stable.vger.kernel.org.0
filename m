Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E2E251D85
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHYQwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 12:52:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29669 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726090AbgHYQwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 12:52:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598374334;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GH3XQPFWbt0lqGRNQZepy/lyen7L04oI1NtwwdbRf3c=;
        b=B6eS8pI+3N0P9P4IQ/kyd2rw2dPv7Edy3t1nd8ykX6uw8Ev3GRXYuegvKvj+RZrHVRkZt8
        aT7WApemEIFaPkAXueh03OLvf14oJMr28hMpvF7nI6+WKegDxIKUTHXYx5sSXXLlaY4zp2
        0fPfknXf9/DoBNLcS0bP13RCVGKfBIY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-PCADvxsXO_qcZQCcv4wwVw-1; Tue, 25 Aug 2020 12:52:08 -0400
X-MC-Unique: PCADvxsXO_qcZQCcv4wwVw-1
Received: by mail-qk1-f200.google.com with SMTP id b76so3885477qkg.8
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 09:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=GH3XQPFWbt0lqGRNQZepy/lyen7L04oI1NtwwdbRf3c=;
        b=HPv75NwKepszuOaWQBkc5NEW7K1ZLeYz9Oth1qxZLQJhNR/ocRHnCWiAtI68jE/x/X
         MM2wenG1NwoMrARTNnMKH7TD7pFv5EodomDEGVOi6yVpEsyi8v5v392rPvRxzsBYxPkj
         sa84nw42kuz9JeLJQGNs2b8kPLQABrySepjGIRlZvoFLBPKHaLeIrEOmEQbI1h3Ii/sl
         l0LWoJP/fUbG+d5EIjh5vMkim5o27f1bhsAcQGwdqle8XmI3fy0HGrz8PwnCU/i7nxGC
         Kxv3R1vO9v2yg91G4HrezwAAVuR+B3PFmz/IJbiR/xoXhQYw/Ab9oRukXTE71xy6+eiu
         gV5Q==
X-Gm-Message-State: AOAM533vVFTtEMbOCK0rawsB7yRX7Dl4h4wsBKgOvC7OEWY50lQC+uzy
        t5Aln44Fpe0ooT0b9RSjYovzFtlDd5fy1mgYLyZtQ2Z5AvrseLswWcWwxZFRH3QF/ljinJ0MNaX
        IGCUzGrUEYNlEV6/Q
X-Received: by 2002:ac8:1773:: with SMTP id u48mr9877467qtk.259.1598374327296;
        Tue, 25 Aug 2020 09:52:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPR44U8niNebYvUrKITYg+kbJjP80i+hSedazIwkyueDHLFtKe3ByC0Rxwfw2DlIYaJ18R6g==
X-Received: by 2002:ac8:1773:: with SMTP id u48mr9877443qtk.259.1598374326949;
        Tue, 25 Aug 2020 09:52:06 -0700 (PDT)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id k3sm12047360qkb.95.2020.08.25.09.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 09:52:06 -0700 (PDT)
Message-ID: <76392bff28359a88fbdf0857f011e0ed9f666dc4.camel@redhat.com>
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
Date:   Tue, 25 Aug 2020 12:52:05 -0400
In-Reply-To: <CACAvsv6hymdcGkEcigL3fWACZ_1POpB+aefq9d9ChnYv_dHnVg@mail.gmail.com>
References: <20200824183253.826343-1-lyude@redhat.com>
         <20200824183253.826343-2-lyude@redhat.com>
         <CACAvsv6hymdcGkEcigL3fWACZ_1POpB+aefq9d9ChnYv_dHnVg@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-08-25 at 08:28 +1000, Ben Skeggs wrote:
> On Tue, 25 Aug 2020 at 04:33, Lyude Paul <lyude@redhat.com> wrote:
> > Not entirely sure why this never came up when I originally tested this
> > (maybe some BIOSes already have this setup?) but the ->caps_init vfunc
> > appears to cause the display engine to throw an exception on driver
> > init, at least on my ThinkPad P72:
> > 
> > nouveau 0000:01:00.0: disp: chid 0 mthd 008c data 00000000 0000508c 0000102b
> > 
> > This is magic nvidia speak for "You need to have the DMA notifier offset
> > programmed before you can call NV507D_GET_CAPABILITIES." So, let's fix
> > this by doing that, and also perform an update afterwards to prevent
> > racing with the GPU when reading capabilities.
> > 
> > Changes since v1:
> > * Don't just program the DMA notifier offset, make sure to actually
> >   perform an update
> I'm not sure there's a need to send an Update() method here, I believe
> GetCapabilities() is an action method on its own right?
> 

I'm not entirely sure about this part tbh. I do know that we need to call
GetCapabilities() _after_ the DMA notifier offset is programmed. But, my
assumption was that if GetCapabilities() requires a DMA notifier offset to store
its results in, we'd probably want to fire an update or something to make sure
that we're not reading before it finishes writing capabilities?

> Ben.
> 
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > Fixes: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP
> > interlacing support")
> > Cc: <stable@vger.kernel.org> # v5.8+
> > ---
> >  drivers/gpu/drm/nouveau/dispnv50/core507d.c | 25 ++++++++++++++++-----
> >  1 file changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > index e341f572c2696..5e86feec3b720 100644
> > --- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > +++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> > @@ -65,13 +65,26 @@ core507d_ntfy_init(struct nouveau_bo *bo, u32 offset)
> >  int
> >  core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
> >  {
> > -       u32 *push = evo_wait(&disp->core->chan, 2);
> > +       struct nv50_core *core = disp->core;
> > +       u32 interlock[NV50_DISP_INTERLOCK__SIZE] = {0};
> > +       u32 *push;
> > 
> > -       if (push) {
> > -               evo_mthd(push, 0x008c, 1);
> > -               evo_data(push, 0x0);
> > -               evo_kick(push, &disp->core->chan);
> > -       }
> > +       core->func->ntfy_init(disp->sync, NV50_DISP_CORE_NTFY);
> > +
> > +       push = evo_wait(&core->chan, 4);
> > +       if (!push)
> > +               return 0;
> > +
> > +       evo_mthd(push, 0x0084, 1);
> > +       evo_data(push, 0x80000000 | NV50_DISP_CORE_NTFY);
> > +       evo_mthd(push, 0x008c, 1);
> > +       evo_data(push, 0x0);
> > +       evo_kick(push, &core->chan);
> > +
> > +       core->func->update(core, interlock, false);
> > +       if (core->func->ntfy_wait_done(disp->sync, NV50_DISP_CORE_NTFY,
> > +                                      core->chan.base.device))
> > +               NV_ERROR(drm, "core notifier timeout\n");
> > 
> >         return 0;
> >  }
> > --
> > 2.26.2
> > 
> > _______________________________________________
> > Nouveau mailing list
> > Nouveau@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/nouveau
-- 
Sincerely,
      Lyude Paul (she/her)
      Software Engineer at Red Hat

