Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D731C3F6513
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhHXRKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237965AbhHXRH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 13:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629824832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M+EkvRCjisgW9/FJYFVpuRO5Po0oLsZ90ivwhF4hpSs=;
        b=WqwhzTcrTabulAfypw9VY8tAQJsLivhnGORGlFzRC8FtsomYGGIgFxEiSYmv8BK5JBZlYJ
        5GmeUs/VBz3y+OWMLUXsv57lOt3bDP8/Lut9ZNbCB4GTsi269C/LwxY+OV4lxsiZISIlBR
        smqL39Ydob+j7LmogF43nMgF62Ddt4E=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-uU3HLQHPOmGgsFLKCkD05w-1; Tue, 24 Aug 2021 13:07:10 -0400
X-MC-Unique: uU3HLQHPOmGgsFLKCkD05w-1
Received: by mail-qv1-f71.google.com with SMTP id bo13-20020a05621414adb029035561c68664so15383049qvb.1
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 10:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=M+EkvRCjisgW9/FJYFVpuRO5Po0oLsZ90ivwhF4hpSs=;
        b=AF1sGS6oKS0S5cHF/HdmdxVxav830sBki51+0+O77W0RQRAB+A/IinwAPuHu8B1kff
         AzbTZCMAyMt6KFMDSTEY63eR0DQkfKCsX0XrTKsqfFUVqHlb/g58SnEF/moMx5+y986x
         xjyNs1cx4ZF8bwnWe6uCKcM9Psjhvv4PT2FY/zVGfQuFUP4LkPrZzbASi8oX+Q1JEdah
         Kuo0LrqAs9nUHSWL5k1aCWvwvbyXxdIxJc8Al/ORcerq/D8IpRI/MApYIZJAo06yCJAv
         /4O0UyfXgIRM+RZSsKuNN4zvbKf4AH6sW5/gJ+vgXDQIJvE96+kUFsWT+CxaLIfkXfX7
         MAiA==
X-Gm-Message-State: AOAM532f6wMdWWIrqDeARFVMMFeLfTDtX6ufLmHaSudlq94NW3FfTfke
        5hpzRBTlw42lS3IFKxRgm4rigz6oh1d/oyjdZjWSpCr3yWH6zFamfwMaqjGlPIYsPnUGSLTjM++
        /MtKS755bQQ5iZVfd
X-Received: by 2002:a05:6214:621:: with SMTP id a1mr40120499qvx.12.1629824827956;
        Tue, 24 Aug 2021 10:07:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjEBLm63jRc4t/L6dw09TUKBT09yP3DkBvnII/qB+rct8Z9iqhYH6ZriYAEHIEzCukdlMCSA==
X-Received: by 2002:a05:6214:621:: with SMTP id a1mr40120476qvx.12.1629824827749;
        Tue, 24 Aug 2021 10:07:07 -0700 (PDT)
Received: from [192.168.8.104] (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id h6sm8211913qtb.44.2021.08.24.10.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 10:07:07 -0700 (PDT)
Message-ID: <1bd0bb90d6367307ad375d692563c6ba1fc43d50.camel@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.10 16/18] drm/nouveau/kms/nv50: workaround EFI
 GOP window channel format differences
From:   Lyude Paul <lyude@redhat.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Cc:     dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Date:   Tue, 24 Aug 2021 13:07:06 -0400
In-Reply-To: <20210824005432.631154-16-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
         <20210824005432.631154-16-sashal@kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ben, do we even have Ampere support in 5.10?

On Mon, 2021-08-23 at 20:54 -0400, Sasha Levin wrote:
> From: Ben Skeggs <bskeggs@redhat.com>
> 
> [ Upstream commit e78b1b545c6cfe9f87fc577128e00026fff230ba ]
> 
> Should fix some initial modeset failures on (at least) Ampere boards.
> 
> Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> Reviewed-by: Lyude Paul <lyude@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 27 +++++++++++++++++++++++++
>  drivers/gpu/drm/nouveau/dispnv50/head.c | 13 ++++++++----
>  drivers/gpu/drm/nouveau/dispnv50/head.h |  1 +
>  3 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> index 5b8cabb099eb..c2d34c91e840 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -2202,6 +2202,33 @@ nv50_disp_atomic_commit_tail(struct drm_atomic_state
> *state)
>                 interlock[NV50_DISP_INTERLOCK_CORE] = 0;
>         }
>  
> +       /* Finish updating head(s)...
> +        *
> +        * NVD is rather picky about both where window assignments can
> change,
> +        * *and* about certain core and window channel states matching.
> +        *
> +        * The EFI GOP driver on newer GPUs configures window channels with
> a
> +        * different output format to what we do, and the core channel
> update
> +        * in the assign_windows case above would result in a state
> mismatch.
> +        *
> +        * Delay some of the head update until after that point to
> workaround
> +        * the issue.  This only affects the initial modeset.
> +        *
> +        * TODO: handle this better when adding flexible window mapping
> +        */
> +       for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
> new_crtc_state, i) {
> +               struct nv50_head_atom *asyh =
> nv50_head_atom(new_crtc_state);
> +               struct nv50_head *head = nv50_head(crtc);
> +
> +               NV_ATOMIC(drm, "%s: set %04x (clr %04x)\n", crtc->name,
> +                         asyh->set.mask, asyh->clr.mask);
> +
> +               if (asyh->set.mask) {
> +                       nv50_head_flush_set_wndw(head, asyh);
> +                       interlock[NV50_DISP_INTERLOCK_CORE] = 1;
> +               }
> +       }
> +
>         /* Update plane(s). */
>         for_each_new_plane_in_state(state, plane, new_plane_state, i) {
>                 struct nv50_wndw_atom *asyw =
> nv50_wndw_atom(new_plane_state);
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c
> b/drivers/gpu/drm/nouveau/dispnv50/head.c
> index 841edfaf5b9d..61826cac3061 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/head.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
> @@ -49,11 +49,8 @@ nv50_head_flush_clr(struct nv50_head *head,
>  }
>  
>  void
> -nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
> +nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom
> *asyh)
>  {
> -       if (asyh->set.view   ) head->func->view    (head, asyh);
> -       if (asyh->set.mode   ) head->func->mode    (head, asyh);
> -       if (asyh->set.core   ) head->func->core_set(head, asyh);
>         if (asyh->set.olut   ) {
>                 asyh->olut.offset = nv50_lut_load(&head->olut,
>                                                   asyh->olut.buffer,
> @@ -61,6 +58,14 @@ nv50_head_flush_set(struct nv50_head *head, struct
> nv50_head_atom *asyh)
>                                                   asyh->olut.load);
>                 head->func->olut_set(head, asyh);
>         }
> +}
> +
> +void
> +nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
> +{
> +       if (asyh->set.view   ) head->func->view    (head, asyh);
> +       if (asyh->set.mode   ) head->func->mode    (head, asyh);
> +       if (asyh->set.core   ) head->func->core_set(head, asyh);
>         if (asyh->set.curs   ) head->func->curs_set(head, asyh);
>         if (asyh->set.base   ) head->func->base    (head, asyh);
>         if (asyh->set.ovly   ) head->func->ovly    (head, asyh);
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.h
> b/drivers/gpu/drm/nouveau/dispnv50/head.h
> index dae841dc05fd..0bac6be9ba34 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/head.h
> +++ b/drivers/gpu/drm/nouveau/dispnv50/head.h
> @@ -21,6 +21,7 @@ struct nv50_head {
>  
>  struct nv50_head *nv50_head_create(struct drm_device *, int index);
>  void nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom
> *asyh);
> +void nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom
> *asyh);
>  void nv50_head_flush_clr(struct nv50_head *head,
>                          struct nv50_head_atom *asyh, bool flush);
>  

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

