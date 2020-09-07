Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A1D26072E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 01:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgIGXew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 19:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgIGXeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 19:34:50 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ACCC061573;
        Mon,  7 Sep 2020 16:34:50 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id p81so4237793ybc.12;
        Mon, 07 Sep 2020 16:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fN1I6SHp+yyKrFdwoEH2+iiRLtt4UeYbF3vg0IC+s0s=;
        b=hGvO3IpU8RMdEsRL22+GskEwjyCRabmdpO/bn2DOQwR1L4B0DVre9FE+mIvZ5vN2S8
         2lk6IS71V0Et7x8kW13n0fiTYcnKuMKc398WFXGbeVXYAmrYnjJJNLz8isysubAJy9hH
         0tx54sQLFi116ZQ3IKE+6C0d0I6jYoouQDkQGNY8ZBA/VgokFKjKO0/pYK+mjIdRFmSM
         i6nqn/woqVktnIdEyfBZwSKADq3Ii5uVFeRbx1iN2QB+ed1Zq5zcm55dDwVLrKWBt3X2
         SlMYKIW6mFDAmZrKVKU9hSZfn1zaeuC6sDHGEPBoKLGypjrFEPMw0LfUtmOCnvqi9Le/
         A4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fN1I6SHp+yyKrFdwoEH2+iiRLtt4UeYbF3vg0IC+s0s=;
        b=lRnmZAYg965tsHMDbMbQYvIMXwkNVUDAywzuB2iaYHFRBC2g7Pc1V8d17VlVMKjeOU
         v0JamMG7fxxEGMfnN1hnhdfWAEhxQt1+wYc5zS4YI5J8KLt3ad+HXttJgF6EaEcZh75k
         Dp78dTv0cZN6QYm3TXkFRGOc3pksNoMS3zZD+3Sled7AKh4lTkZvL/F4a/3pBBIA9TSE
         /DvFDsQ1qup1YyQ6D/D/gUScuPK6AeiU3qal9e90OMrXeo1EbOPldHSP4UtUfO1TGJ3X
         TztWJRn6Lkl2qA3ZYXJurvmD8vLDhh1L0n3fzh6K+3mOqmCj+Zumf1j4j//FQO9uDgf+
         PZmQ==
X-Gm-Message-State: AOAM531WvT1TYTfd41aXohA2BfWMJ8ROr7ABoay0MZQ6nndYPe7xT95v
        7W0Bw8E39DpfuQRQT7fuGrg6cz2U6393RVz2sS8=
X-Google-Smtp-Source: ABdhPJw3WLNX7QHF7YvBW7jxFP/63pL1HzshEVNrIGJe9EB3pZxYHrJNUMf69WjyZII4aEZiA+pXy8ACMkEc/Y8QAxs=
X-Received: by 2002:a25:c07:: with SMTP id 7mr20563467ybm.200.1599521689774;
 Mon, 07 Sep 2020 16:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200904202813.1260202-1-lyude@redhat.com>
In-Reply-To: <20200904202813.1260202-1-lyude@redhat.com>
From:   Ben Skeggs <skeggsb@gmail.com>
Date:   Tue, 8 Sep 2020 09:34:38 +1000
Message-ID: <CACAvsv6ptDgHGCyikmNABS8BQbuL4dsh1CczwDARBDbDpsDviQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v5 1/2] drm/nouveau/kms/nv50-: Program notifier
 offset before requesting disp caps
To:     Lyude Paul <lyude@redhat.com>
Cc:     ML nouveau <nouveau@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.aiemd@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 5 Sep 2020 at 06:28, Lyude Paul <lyude@redhat.com> wrote:
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
> v2:
> * Don't just program the DMA notifier offset, make sure to actually
>   perform an update
> v3:
> * Don't call UPDATE()
> * Actually read the correct notifier fields, as apparently the
>   CAPABILITIES_DONE field lives in a different location than the main
>   NV_DISP_CORE_NOTIFIER_1 field. As well, 907d+ use a different
>   CAPABILITIES_DONE field then pre-907d cards.
> v4:
> * Don't forget to check the return value of core507d_read_caps()
> v5:
> * Get rid of NV50_DISP_CAPS_NTFY[14], use NV50_DISP_CORE_NTFY
> * Disable notifier after calling GetCapabilities()
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP interlacing support")
> Cc: <stable@vger.kernel.org> # v5.8+
Thanks Lyude, looks good, and merged!

Ben.

> ---
>  drivers/gpu/drm/nouveau/dispnv50/core.h       |  2 +
>  drivers/gpu/drm/nouveau/dispnv50/core507d.c   | 41 ++++++++++++++++++-
>  drivers/gpu/drm/nouveau/dispnv50/core907d.c   | 36 +++++++++++++++-
>  drivers/gpu/drm/nouveau/dispnv50/core917d.c   |  2 +-
>  .../drm/nouveau/include/nvhw/class/cl507d.h   |  5 ++-
>  .../drm/nouveau/include/nvhw/class/cl907d.h   |  4 ++
>  6 files changed, 85 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/core.h b/drivers/gpu/drm/nouveau/dispnv50/core.h
> index 498622c0c670d..f75088186fba3 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/core.h
> +++ b/drivers/gpu/drm/nouveau/dispnv50/core.h
> @@ -44,6 +44,7 @@ int core507d_new_(const struct nv50_core_func *, struct nouveau_drm *, s32,
>                   struct nv50_core **);
>  int core507d_init(struct nv50_core *);
>  void core507d_ntfy_init(struct nouveau_bo *, u32);
> +int core507d_read_caps(struct nv50_disp *disp);
>  int core507d_caps_init(struct nouveau_drm *, struct nv50_disp *);
>  int core507d_ntfy_wait_done(struct nouveau_bo *, u32, struct nvif_device *);
>  int core507d_update(struct nv50_core *, u32 *, bool);
> @@ -55,6 +56,7 @@ extern const struct nv50_outp_func pior507d;
>  int core827d_new(struct nouveau_drm *, s32, struct nv50_core **);
>
>  int core907d_new(struct nouveau_drm *, s32, struct nv50_core **);
> +int core907d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp);
>  extern const struct nv50_outp_func dac907d;
>  extern const struct nv50_outp_func sor907d;
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/core507d.c b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> index 248edf69e1683..e6f16a7750f07 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
> @@ -78,18 +78,55 @@ core507d_ntfy_init(struct nouveau_bo *bo, u32 offset)
>  }
>
>  int
> -core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
> +core507d_read_caps(struct nv50_disp *disp)
>  {
>         struct nvif_push *push = disp->core->chan.push;
>         int ret;
>
> -       if ((ret = PUSH_WAIT(push, 2)))
> +       ret = PUSH_WAIT(push, 6);
> +       if (ret)
>                 return ret;
>
> +       PUSH_MTHD(push, NV507D, SET_NOTIFIER_CONTROL,
> +                 NVDEF(NV507D, SET_NOTIFIER_CONTROL, MODE, WRITE) |
> +                 NVVAL(NV507D, SET_NOTIFIER_CONTROL, OFFSET, NV50_DISP_CORE_NTFY >> 2) |
> +                 NVDEF(NV507D, SET_NOTIFIER_CONTROL, NOTIFY, ENABLE));
> +
>         PUSH_MTHD(push, NV507D, GET_CAPABILITIES, 0x00000000);
> +
> +       PUSH_MTHD(push, NV507D, SET_NOTIFIER_CONTROL,
> +                 NVDEF(NV507D, SET_NOTIFIER_CONTROL, NOTIFY, DISABLE));
> +
>         return PUSH_KICK(push);
>  }
>
> +int
> +core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
> +{
> +       struct nv50_core *core = disp->core;
> +       struct nouveau_bo *bo = disp->sync;
> +       s64 time;
> +       int ret;
> +
> +       NVBO_WR32(bo, NV50_DISP_CORE_NTFY, NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1,
> +                                    NVDEF(NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1, DONE, FALSE));
> +
> +       ret = core507d_read_caps(disp);
> +       if (ret < 0)
> +               return ret;
> +
> +       time = nvif_msec(core->chan.base.device, 2000ULL,
> +                        if (NVBO_TD32(bo, NV50_DISP_CORE_NTFY,
> +                                      NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1, DONE, ==, TRUE))
> +                                break;
> +                        usleep_range(1, 2);
> +                        );
> +       if (time < 0)
> +               NV_ERROR(drm, "core caps notifier timeout\n");
> +
> +       return 0;
> +}
> +
>  int
>  core507d_init(struct nv50_core *core)
>  {
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/core907d.c b/drivers/gpu/drm/nouveau/dispnv50/core907d.c
> index b17c03529c784..8564d4dffaff0 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/core907d.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/core907d.c
> @@ -22,11 +22,45 @@
>  #include "core.h"
>  #include "head.h"
>
> +#include <nvif/push507c.h>
> +#include <nvif/timer.h>
> +
> +#include <nvhw/class/cl907d.h>
> +
> +#include "nouveau_bo.h"
> +
> +int
> +core907d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
> +{
> +       struct nv50_core *core = disp->core;
> +       struct nouveau_bo *bo = disp->sync;
> +       s64 time;
> +       int ret;
> +
> +       NVBO_WR32(bo, NV50_DISP_CORE_NTFY, NV907D_CORE_NOTIFIER_3, CAPABILITIES_4,
> +                                    NVDEF(NV907D_CORE_NOTIFIER_3, CAPABILITIES_4, DONE, FALSE));
> +
> +       ret = core507d_read_caps(disp);
> +       if (ret < 0)
> +               return ret;
> +
> +       time = nvif_msec(core->chan.base.device, 2000ULL,
> +                        if (NVBO_TD32(bo, NV50_DISP_CORE_NTFY,
> +                                      NV907D_CORE_NOTIFIER_3, CAPABILITIES_4, DONE, ==, TRUE))
> +                                break;
> +                        usleep_range(1, 2);
> +                        );
> +       if (time < 0)
> +               NV_ERROR(drm, "core caps notifier timeout\n");
> +
> +       return 0;
> +}
> +
>  static const struct nv50_core_func
>  core907d = {
>         .init = core507d_init,
>         .ntfy_init = core507d_ntfy_init,
> -       .caps_init = core507d_caps_init,
> +       .caps_init = core907d_caps_init,
>         .ntfy_wait_done = core507d_ntfy_wait_done,
>         .update = core507d_update,
>         .head = &head907d,
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/core917d.c b/drivers/gpu/drm/nouveau/dispnv50/core917d.c
> index 66846f3720805..1cd3a2a35dfb7 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/core917d.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/core917d.c
> @@ -26,7 +26,7 @@ static const struct nv50_core_func
>  core917d = {
>         .init = core507d_init,
>         .ntfy_init = core507d_ntfy_init,
> -       .caps_init = core507d_caps_init,
> +       .caps_init = core907d_caps_init,
>         .ntfy_wait_done = core507d_ntfy_wait_done,
>         .update = core507d_update,
>         .head = &head917d,
> diff --git a/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h b/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h
> index 2e444bac701dd..6a463f308b64f 100644
> --- a/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h
> +++ b/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h
> @@ -32,7 +32,10 @@
>  #define NV_DISP_CORE_NOTIFIER_1_COMPLETION_0_DONE_TRUE                               0x00000001
>  #define NV_DISP_CORE_NOTIFIER_1_COMPLETION_0_R0                                      15:1
>  #define NV_DISP_CORE_NOTIFIER_1_COMPLETION_0_TIMESTAMP                               29:16
> -
> +#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1                                       0x00000001
> +#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1_DONE                                  0:0
> +#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1_DONE_FALSE                            0x00000000
> +#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1_DONE_TRUE                             0x00000001
>
>  // class methods
>  #define NV507D_UPDATE                                                           (0x00000080)
> diff --git a/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h b/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h
> index 34bc3eafac7d1..79aff6ff31385 100644
> --- a/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h
> +++ b/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h
> @@ -24,6 +24,10 @@
>  #ifndef _cl907d_h_
>  #define _cl907d_h_
>
> +#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4                                       0x00000004
> +#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4_DONE                                  0:0
> +#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4_DONE_FALSE                            0x00000000
> +#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4_DONE_TRUE                             0x00000001
>  #define NV907D_CORE_NOTIFIER_3_CAPABILITIES_CAP_SOR0_20                             0x00000014
>  #define NV907D_CORE_NOTIFIER_3_CAPABILITIES_CAP_SOR0_20_SINGLE_LVDS18               0:0
>  #define NV907D_CORE_NOTIFIER_3_CAPABILITIES_CAP_SOR0_20_SINGLE_LVDS18_FALSE         0x00000000
> --
> 2.26.2
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau
