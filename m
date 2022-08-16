Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3063596289
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 20:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiHPSgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 14:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiHPSgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 14:36:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945E37AC07
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660674994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ATLTNrU7GYz0luvrW4anz32ZvPvWjx6FLjAwIXa1ryQ=;
        b=JaEM4dCsujBGlIowU71zVaF8COc2TzZkh6T86wnOksj5qroFTdC8zHtr0Bc3SKVPgjYBiA
        0curIOPf6hMzcZ+vOLdQ8NI1C04QlgRiWPsM0ggDw87KZCWw9mbS1TcSnQnIKE/63pYiZk
        xO6Iq6HerTwuBjpR9WLf5GXNu2jvWYY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-d2ZYcc16Mv6yY2rse2d3sA-1; Tue, 16 Aug 2022 14:36:33 -0400
X-MC-Unique: d2ZYcc16Mv6yY2rse2d3sA-1
Received: by mail-qk1-f199.google.com with SMTP id de4-20020a05620a370400b006a9711bd9f8so9828383qkb.9
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 11:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ATLTNrU7GYz0luvrW4anz32ZvPvWjx6FLjAwIXa1ryQ=;
        b=z/y8AvovL9QFwwWWly1Pg7g4cYab0BDr6/TByM+eo47miXIzJal5WXC7ZzYiCBxa5w
         6SZ/MnbWgFJT+5tGIlQxPVKNiNC4FsNErfm6K2MLhYHyYJwJhR3/HJ36aULshrVIjsjU
         h8URbI0BkTtnc0R6ml3ZKZgNwswcu1U9mADuGBGXYS2iMXTR2P7iaXrxIms8VmnOewdK
         MUb+DYkfOn4lq9pyUSvUE7UYTXzMt5C3jJhdsbgNphvViSCN7Ps+FaD65QjM5g99Cc4U
         Ar7Byukffa31JlKaKaDJcLWI5q/fLOIY92QBI+409SkkfQ0VJNT4DI3CKL6qs2jxlnuV
         64OA==
X-Gm-Message-State: ACgBeo094/5quYIx+KQSzUZBgNk87ojvo8sH7Ub/BZ1lTcT2Z6pHB88h
        kmgtFXvMuOCkNfXvT7KTQeOwgNBYKMZGToN7hwwuq6lqrEzEDicWwpCIUTEHOhGcB9yrlvqfa49
        5+N8mFQDPIK4Bsc5LjRrQFnWCqoYAKrqQ
X-Received: by 2002:a05:622a:53:b0:344:6f46:9b16 with SMTP id y19-20020a05622a005300b003446f469b16mr4523478qtw.664.1660674993003;
        Tue, 16 Aug 2022 11:36:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4uzqnNt/HXR/q6B/lqjN5qSDiPZY/PY86apwP8teYfRNvnblpR+HCXfIUeJjTQ/VgoEgoyP1yH48Iodoy+LVI=
X-Received: by 2002:a05:622a:53:b0:344:6f46:9b16 with SMTP id
 y19-20020a05622a005300b003446f469b16mr4523466qtw.664.1660674992830; Tue, 16
 Aug 2022 11:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220816180436.156310-1-lyude@redhat.com>
In-Reply-To: <20220816180436.156310-1-lyude@redhat.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Tue, 16 Aug 2022 20:36:22 +0200
Message-ID: <CACO55tvoDZMTr6my2LvhWWz7h3L6u2938n5dwvjvLANpvwxhjA@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/kms/nv140-: Disable interlacing
To:     Lyude Paul <lyude@redhat.com>
Cc:     nouveau@lists.freedesktop.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 8:04 PM Lyude Paul <lyude@redhat.com> wrote:
>
> As it turns out: while Nvidia does actually have interlacing knobs on their
> GPU still pretty much no current GPUs since Volta actually support it.
> Trying interlacing on these GPUs will result in NVDisplay being quite
> unhappy like so:
>
> nouveau 0000:1f:00.0: disp: chid 0 stat 00004802 reason 4 [INVALID_ARG] mthd 2008 data 00000001 code 00080000
> nouveau 0000:1f:00.0: disp: chid 0 stat 10005080 reason 5 [INVALID_STATE] mthd 0200 data 00000001 code 00000001
>
> So let's fix this by following the same behavior Nvidia's driver does and
> disable interlacing entirely.
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/nouveau/nouveau_connector.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
> index 43a9d1e1cf71..8100c75ee731 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_connector.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
> @@ -504,7 +504,8 @@ nouveau_connector_set_encoder(struct drm_connector *connector,
>                         connector->interlace_allowed =
>                                 nv_encoder->caps.dp_interlace;
>                 else
> -                       connector->interlace_allowed = true;
> +                       connector->interlace_allowed =
> +                               drm->client.device.info.family < NV_DEVICE_INFO_V0_VOLTA;
>                 connector->doublescan_allowed = true;
>         } else
>         if (nv_encoder->dcb->type == DCB_OUTPUT_LVDS ||
> --
> 2.37.1
>

Reviewed-by: Karol Herbst <kherbst@redhat.com>

