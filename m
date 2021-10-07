Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6F6425F7E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 23:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhJGVso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 17:48:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234061AbhJGVso (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 17:48:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633643209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UPSqvOGCu+GJcDa90zr7X1MG9KfGKC/5VQJKgH+ViDk=;
        b=hahvo5/WENvK5Yss5aK/RHhDFVNEnuNjX31LD6dbUcEF6a0j20Z7cmS5KCHoYjWlbypCp1
        KpYzvSEwye34YGikV8UZVrAUADWGRE16O0OzcAdTNhbB2idBnZj0oKC/yqOweQvMGmKmt9
        PtfEieHYSKmj5o8197sUw0zPqEvNbhk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-OWbOG8yeNUu_ZL28hkGK4A-1; Thu, 07 Oct 2021 17:46:48 -0400
X-MC-Unique: OWbOG8yeNUu_ZL28hkGK4A-1
Received: by mail-wr1-f72.google.com with SMTP id o2-20020a5d4a82000000b00160c6b7622aso5636978wrq.12
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 14:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UPSqvOGCu+GJcDa90zr7X1MG9KfGKC/5VQJKgH+ViDk=;
        b=CSpOKw1qwebYdUq3WNiHjqOU6CgoGUq0oowbi1KfFXSsNKJ61997DES8EGoxFWp3YB
         ZzI+FkiS4DrxaD+fxms2U0EDc3JTtcOfFXVot3vHm7Pr9k05UOiYNT1BDgWJ89zNyWbI
         RE2Rkh6uG0j60ofjbHQYtux5o3fE4FtfL1HL2gflWS0VIe2KwkC7YNHOdAxnku5eWdE/
         RsHthEO3c617Jq9tKG1nUqVIUbkD/IrBrcw++YRdXhUA3N8yRQwSqk5VpALRUV+GLFkj
         hahzXSGXyS/6ETwW6ds3qwMIHsIs6cxcX0o3HR9jM6nWOhsEX5PbLblhzHXJMIgM83YY
         ck6A==
X-Gm-Message-State: AOAM530N+1PKefxr8FCalHqB4QRZV/4DatDJviPpx1KLkpuLd+IngNoW
        /218cIRWPoSsVWy7vD0ITo4MsgPXB7TX27SdhBOHrKXN9YphL1bOVphZ5OYi0cRLvtQuQnjFWAT
        +uVHwKp5IKl62f+dq3/v+Yb1F99dA6YqL
X-Received: by 2002:adf:8bdd:: with SMTP id w29mr8423688wra.49.1633643207401;
        Thu, 07 Oct 2021 14:46:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqAKo0aK9SLNTCPUFBer0OSZTRHIE2Hyrqtsw01LVQXzy+cOws4WYmJCdoRH/WN4MFlYIehJPJYTXoJ/WR+4Y=
X-Received: by 2002:adf:8bdd:: with SMTP id w29mr8423659wra.49.1633643207147;
 Thu, 07 Oct 2021 14:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211007214117.231472-1-marex@denx.de>
In-Reply-To: <20211007214117.231472-1-marex@denx.de>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Thu, 7 Oct 2021 23:46:36 +0200
Message-ID: <CACO55tsgmtR1CqdJOBMu9oQEEojfpnUwWNvab9gA7ZuZmyiSmA@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/fifo: Reinstate the correct engine bit programming
To:     Marek Vasut <marex@denx.de>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        nouveau <nouveau@lists.freedesktop.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Karol Herbst <kherbst@redhat.com>

I haven't checked if other places need fixing up yet, and I still want
to test this patch, but I won't get to it until Monday. But if
everything is in place we can get this pushed next week so we can
finally fix this annoying issue :) I was also seeing some minor
graphical corruptions which would be cool if this patch fixes it as
well.

Thanks for the patch and poking us about the bug again.

On Thu, Oct 7, 2021 at 11:41 PM Marek Vasut <marex@denx.de> wrote:
>
> Commit 64f7c698bea9 ("drm/nouveau/fifo: add engine_id hook") replaced
> fifo/chang84.c g84_fifo_chan_engine() call with an indirect call of
> fifo/g84.c g84_fifo_engine_id(). The G84_FIFO_ENGN_* values returned
> from the later g84_fifo_engine_id() are incremented by 1 compared to
> the previous g84_fifo_chan_engine() return values.
>
> This is fine either way for most of the code, except this one line
> where an engine bit programmed into the hardware is derived from the
> return value. Decrement the return value accordingly, otherwise the
> wrong engine bit is programmed into the hardware and that leads to
> the following failure:
> nouveau 0000:01:00.0: gr: 00000030 [ILLEGAL_MTHD ILLEGAL_CLASS] ch 1 [003fbce000 DRM] subc 3 class 0000 mthd 085c data 00000420
>
> On the following hardware:
> lspci -s 01:00.0
> 01:00.0 VGA compatible controller: NVIDIA Corporation GT216GLM [Quadro FX 880M] (rev a2)
> lspci -ns 01:00.0
> 01:00.0 0300: 10de:0a3c (rev a2)
>
> Fixes: 64f7c698bea9 ("drm/nouveau/fifo: add engine_id hook")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: <stable@vger.kernel.org> # 5.12+
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: Lyude Paul <lyude@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
> index 353b77d9b3dc..3492c561f2cf 100644
> --- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
> +++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c
> @@ -82,7 +82,7 @@ g84_fifo_chan_engine_fini(struct nvkm_fifo_chan *base,
>         if (offset < 0)
>                 return 0;
>
> -       engn = fifo->base.func->engine_id(&fifo->base, engine);
> +       engn = fifo->base.func->engine_id(&fifo->base, engine) - 1;
>         save = nvkm_mask(device, 0x002520, 0x0000003f, 1 << engn);
>         nvkm_wr32(device, 0x0032fc, chan->base.inst->addr >> 12);
>         done = nvkm_msec(device, 2000,
> --
> 2.33.0
>

