Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB06A250BA8
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 00:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgHXW3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 18:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgHXW3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 18:29:08 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4BCC061574;
        Mon, 24 Aug 2020 15:29:08 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e14so6054127ybf.4;
        Mon, 24 Aug 2020 15:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3qOJ3NzWfJ9sWmSZflRe5Z/SiLVOjHtScl8TXItrV3A=;
        b=l+ltexb5PPukV4iJ9LAIkMPnqWOS/KfO3eQhMs5uqymC9AarAqrzL4DZ55+LKrNKSz
         91zotAMJ+IBsnRBYfMbQH0xs+OdbmoP1up23cYmATdKMc/zXwQSpUTTHABL/n3opXon+
         HE/Fq/cAu5BJU4ImGNv+HhWYQNgGH+PP9yH2BMw349IfG6r3haeeQANG55nAS4FG/HeO
         NaxgdyRtxv6hwQUz9Sr8jRak8zKTXBwlzmdT/1qpVEczfvPzB09TFH4x2FhExHHvpZLE
         e/ucPg/YKPJOPgfgV3cqPS7dPwu7mJ7VD1kWkeGncoG7+i/tF0ozMTgIkVhXZBG13v2C
         Zh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3qOJ3NzWfJ9sWmSZflRe5Z/SiLVOjHtScl8TXItrV3A=;
        b=JJ+CgDgaPRrfgnfEwBzZNcR9wy7LO4EmEAH6i5LQi0RkBxDhKgUWfCZw0vY46SA8ow
         d2JyQJ0ybyJhv4SpBTpwm1b0KY3DUtEPpbEhqdw1blOaoovTtenvuh5CGJaNpIHxczJl
         uGSAVq15M7TF2JRqLch7T2vWB4VtnLvxKQia/wU12B4QpaN6GXJqmOHeJmHBkEmBJ+Vd
         MJjM5GGAICP2jzos/nafmh53V+j34V46pE8nmgb20CZMad4h9ebNgBUBlXVtS21WIX+U
         tiJdEKgCmtUQFQ4eCFw1UCXSGgwa5rMZiL8q1W+8MRV8FBcyvqSCGosz3Z8VXzl4yo4D
         X5MA==
X-Gm-Message-State: AOAM5329UvBjDctHJtrARSdMDUwapGSHOHItSRlKIMuKMyxmpF5mV9UM
        jUu3FmmYK4f59LLcw0vzkYTvA9MPQRVSEwRxx+g=
X-Google-Smtp-Source: ABdhPJwYgl3FJMdku6i+4HiglRO8zsQRW9BAP3I/BEAqKMIf1RRP+xNfrrsy4rPjxTHUVwO6XaFN+jSnZyngLiRiyAU=
X-Received: by 2002:a25:8447:: with SMTP id r7mr9673141ybm.147.1598308147950;
 Mon, 24 Aug 2020 15:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200824183253.826343-1-lyude@redhat.com> <20200824183253.826343-2-lyude@redhat.com>
In-Reply-To: <20200824183253.826343-2-lyude@redhat.com>
From:   Ben Skeggs <skeggsb@gmail.com>
Date:   Tue, 25 Aug 2020 08:28:56 +1000
Message-ID: <CACAvsv6hymdcGkEcigL3fWACZ_1POpB+aefq9d9ChnYv_dHnVg@mail.gmail.com>
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

On Tue, 25 Aug 2020 at 04:33, Lyude Paul <lyude@redhat.com> wrote:
>
> Not entirely sure why this never came up when I originally tested this
> (maybe some BIOSes already have this setup?) but the ->caps_init vfunc
> appears to cause the display engine to throw an exception on driver
> init, at least on my ThinkPad P72:
>
> nouveau 0000:01:00.0: disp: chid 0 mthd 008c data 00000000 0000508c 0000102b
>
> This is magic nvidia speak for "You need to have the DMA notifier offset
> programmed before you can call NV507D_GET_CAPABILITIES." So, let's fix
> this by doing that, and also perform an update afterwards to prevent
> racing with the GPU when reading capabilities.
>
> Changes since v1:
> * Don't just program the DMA notifier offset, make sure to actually
>   perform an update
I'm not sure there's a need to send an Update() method here, I believe
GetCapabilities() is an action method on its own right?

Ben.

>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP interlacing support")
> Cc: <stable@vger.kernel.org> # v5.8+
> ---
>  drivers/gpu/drm/nouveau/dispnv50/core507d.c | 25 ++++++++++++++++-----
>  1 file changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/core507d.c b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> index e341f572c2696..5e86feec3b720 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> @@ -65,13 +65,26 @@ core507d_ntfy_init(struct nouveau_bo *bo, u32 offset)
>  int
>  core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
>  {
> -       u32 *push = evo_wait(&disp->core->chan, 2);
> +       struct nv50_core *core = disp->core;
> +       u32 interlock[NV50_DISP_INTERLOCK__SIZE] = {0};
> +       u32 *push;
>
> -       if (push) {
> -               evo_mthd(push, 0x008c, 1);
> -               evo_data(push, 0x0);
> -               evo_kick(push, &disp->core->chan);
> -       }
> +       core->func->ntfy_init(disp->sync, NV50_DISP_CORE_NTFY);
> +
> +       push = evo_wait(&core->chan, 4);
> +       if (!push)
> +               return 0;
> +
> +       evo_mthd(push, 0x0084, 1);
> +       evo_data(push, 0x80000000 | NV50_DISP_CORE_NTFY);
> +       evo_mthd(push, 0x008c, 1);
> +       evo_data(push, 0x0);
> +       evo_kick(push, &core->chan);
> +
> +       core->func->update(core, interlock, false);
> +       if (core->func->ntfy_wait_done(disp->sync, NV50_DISP_CORE_NTFY,
> +                                      core->chan.base.device))
> +               NV_ERROR(drm, "core notifier timeout\n");
>
>         return 0;
>  }
> --
> 2.26.2
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau
