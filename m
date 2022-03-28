Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9044EA260
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 23:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiC1VWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 17:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiC1VWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 17:22:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF2DEE995D
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 14:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648502447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ovb2abZLdPXIpDXoFNTL/ZfMzAu8x+Cb7oB/ww9JfYA=;
        b=ecq0PvVO0RAP99Yt34F39JvvJBsJQ1wrxS/gwv9DDDUQqxO2C9jSQHine+o/JXqlLgmETY
        MgiYq/t1beXK7Hj3O8/nZmIj6YsfRJyTUn1V86Hoec6Oya1HDvoF5nHATBy2pDnO2tPrPX
        cGSG2UdWQi1Lj0dhUABZ0yCxo9vNsgE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-P44U0OmRPOG-s3SN6jRZUg-1; Mon, 28 Mar 2022 17:20:43 -0400
X-MC-Unique: P44U0OmRPOG-s3SN6jRZUg-1
Received: by mail-qv1-f70.google.com with SMTP id h18-20020a05621402f200b00440cedaa9a2so12261327qvu.17
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 14:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=Ovb2abZLdPXIpDXoFNTL/ZfMzAu8x+Cb7oB/ww9JfYA=;
        b=z17u1fKjRkNR84yzmOs4GYoY4TzffjVCk/lbGloHoovdBfqIRpq7sG9gTiOzf6Fdr8
         Fd754SGT2pVh+MH/jyVufO2h8pLIQtmC2gMHS2TUw4BvgRkFNACkrwKyomf1+NtBbMT1
         +PUJkHk3BzRrI9zQ/9CZ66WzoqfOOYRLzJjTX7/RnoSFZoGuHqOHI/W3LaXO2vv8Hwtf
         o3Bdz80wEchSWHqzk/eu6V+hjSp40GutsAIK5PiHO/T/CzeZXT4CP/Z98xGofBwN2HtW
         BMzryonGdKEpEsXi1crZ6kWNVEOsNZ3g7zBlvVVqMhETFfSdHpKE6olLJMXQMTizfE74
         gBIA==
X-Gm-Message-State: AOAM533QUOB3evqtTrMUoO0lyGFdqGwjIhNk7xHhhC2tcXAW1cNrfK3G
        X15r38oGgQV5E8DsaxJh26jvig/9j5dstXwqARiPXJrrniqnD9JewcVI3Mc8kWlzOmbZX5vAdbR
        LIzgsOU+dvFmCZFaQ
X-Received: by 2002:ac8:7d84:0:b0:2e2:1ef6:94bb with SMTP id c4-20020ac87d84000000b002e21ef694bbmr24837160qtd.348.1648502442442;
        Mon, 28 Mar 2022 14:20:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxr/xaDRnoX5KQggdrvWhRc+vYS5yUpsvIM+b2oehs7B0Lt4/tR1Ebdv6ok0NtajQHNvYUffQ==
X-Received: by 2002:ac8:7d84:0:b0:2e2:1ef6:94bb with SMTP id c4-20020ac87d84000000b002e21ef694bbmr24837135qtd.348.1648502442222;
        Mon, 28 Mar 2022 14:20:42 -0700 (PDT)
Received: from [192.168.8.138] (pool-71-126-244-162.bstnma.fios.verizon.net. [71.126.244.162])
        by smtp.gmail.com with ESMTPSA id w17-20020ac857d1000000b002e19feda592sm13392465qta.85.2022.03.28.14.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 14:20:41 -0700 (PDT)
Message-ID: <30057caf791dd789fe715715d1c1973994a91953.camel@redhat.com>
Subject: Re: [PATCH] dispnv50: atom: fix an incorrect NULL check on list
 iterator
From:   Lyude Paul <lyude@redhat.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, bskeggs@redhat.com,
        kherbst@redhat.com, airlied@linux.ie, daniel@ffwll.ch
Cc:     yangyingliang@huawei.com, contact@emersion.fr, airlied@gmail.com,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 28 Mar 2022 17:20:40 -0400
In-Reply-To: <20220327073925.11121-1-xiam0nd.tong@gmail.com>
References: <20220327073925.11121-1-xiam0nd.tong@gmail.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.DarkModeFix.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

Will push this to the appropriate repository shortly.

On Sun, 2022-03-27 at 15:39 +0800, Xiaomeng Tong wrote:
> The bug is here:
>         return encoder;
> 
> The list iterator value 'encoder' will *always* be set and non-NULL
> by drm_for_each_encoder_mask(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element found.
> Otherwise it will bypass some NULL checks and lead to invalid memory
> access passing the check.
> 
> To fix this bug, just return 'encoder' when found, otherwise return
> NULL.
> 
> Cc: stable@vger.kernel.org
> Fixes: 12885ecbfe62d ("drm/nouveau/kms/nvd9-: Add CRC support")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/dispnv50/atom.h |  6 +++---
>  drivers/gpu/drm/nouveau/dispnv50/crc.c  | 27 ++++++++++++++++++++-----
>  2 files changed, 25 insertions(+), 8 deletions(-)
> (also 
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/atom.h
> b/drivers/gpu/drm/nouveau/dispnv50/atom.h
> index 3d82b3c67dec..93f8f4f64578 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/atom.h
> +++ b/drivers/gpu/drm/nouveau/dispnv50/atom.h
> @@ -160,14 +160,14 @@ nv50_head_atom_get(struct drm_atomic_state *state,
> struct drm_crtc *crtc)
>  static inline struct drm_encoder *
>  nv50_head_atom_get_encoder(struct nv50_head_atom *atom)
>  {
> -       struct drm_encoder *encoder = NULL;
> +       struct drm_encoder *encoder;
>  
>         /* We only ever have a single encoder */
>         drm_for_each_encoder_mask(encoder, atom->state.crtc->dev,
>                                   atom->state.encoder_mask)
> -               break;
> +               return encoder;
>  
> -       return encoder;
> +       return NULL;
>  }
>  
>  #define nv50_wndw_atom(p) container_of((p), struct nv50_wndw_atom, state)
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/crc.c
> b/drivers/gpu/drm/nouveau/dispnv50/crc.c
> index 29428e770f14..b834e8a9ae77 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/crc.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/crc.c
> @@ -390,9 +390,18 @@ void nv50_crc_atomic_check_outp(struct nv50_atom *atom)
>                 struct nv50_head_atom *armh =
> nv50_head_atom(old_crtc_state);
>                 struct nv50_head_atom *asyh =
> nv50_head_atom(new_crtc_state);
>                 struct nv50_outp_atom *outp_atom;
> -               struct nouveau_encoder *outp =
> -                       nv50_real_outp(nv50_head_atom_get_encoder(armh));
> -               struct drm_encoder *encoder = &outp->base.base;
> +               struct nouveau_encoder *outp;
> +               struct drm_encoder *encoder, *enc;
> +
> +               enc = nv50_head_atom_get_encoder(armh);
> +               if (!enc)
> +                       continue;
> +
> +               outp = nv50_real_outp(enc);
> +               if (!outp)
> +                       continue;
> +
> +               encoder = &outp->base.base;
>  
>                 if (!asyh->clr.crc)
>                         continue;
> @@ -443,8 +452,16 @@ void nv50_crc_atomic_set(struct nv50_head *head,
>         struct drm_device *dev = crtc->dev;
>         struct nv50_crc *crc = &head->crc;
>         const struct nv50_crc_func *func = nv50_disp(dev)->core->func->crc;
> -       struct nouveau_encoder *outp =
> -               nv50_real_outp(nv50_head_atom_get_encoder(asyh));
> +       struct nouveau_encoder *outp;
> +       struct drm_encoder *encoder;
> +
> +       encoder = nv50_head_atom_get_encoder(asyh);
> +       if (!encoder)
> +               return;
> +
> +       outp = nv50_real_outp(encoder);
> +       if (!outp)
> +               return;
>  
>         func->set_src(head, outp->or, nv50_crc_source_type(outp, asyh-
> >crc.src),
>                       &crc->ctx[crc->ctx_idx]);

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

