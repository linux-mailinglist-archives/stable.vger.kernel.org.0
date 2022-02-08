Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30B04AD8D3
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 14:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239597AbiBHNQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 08:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354536AbiBHMVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 07:21:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 259A6C03FEC0
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 04:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Mdb5Ebivxr6jzHOzSN/tIiK6XfSCOdpNYf9wIWORf4=;
        b=WuW6p77VAqLuteBfFWAbrbaAHkECQ9ZGu1LuSNak8lrZbeWxXynP/gazhd2ZBkCRNDvVzY
        /Ct+593wp4eD9S7l874zPtWm7xfWCv1KsNmAIXunyiy+oXh7D+8vrsNO5kfZjtFow1rAhr
        LhsV8nT0YqB0egt8k1UikwHTtNdMDws=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-uAPX-ho2MCS3GKuWQEEZkw-1; Tue, 08 Feb 2022 07:21:32 -0500
X-MC-Unique: uAPX-ho2MCS3GKuWQEEZkw-1
Received: by mail-wr1-f71.google.com with SMTP id i19-20020adfa513000000b001e33749ed31so912440wrb.8
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 04:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Mdb5Ebivxr6jzHOzSN/tIiK6XfSCOdpNYf9wIWORf4=;
        b=WtW12YnNgqFjicGp/xL+NSCivAiB61Me5Gt8+N8QSsbwd/sjM3sL/K7bLeB+lsJN4c
         WyaSba5qpYjp2bmKcc539tmqW1WskuSxSvCKOF2wDfzPN6V8HJwUnlaTvvEWVCnMhIMD
         FXTgfdPb+5vfYteSGCXfgU5BwUeESBJ/DPixeD23QpxbBXY8cAWwPOoGVIK9ID3cLPrj
         5nj5I3zi58VCvhhsIVl6iXzVqQvjUYg2edXMHPoQh+4ARdP6wX9ssRR1ZuozIb1jaqFN
         x7+kkZw9nISEQhAZuTYMuL0HHsAqyvkqH6vl0J76eEe7jseL0eqi18xFCPFTZf4HihR0
         +Tvg==
X-Gm-Message-State: AOAM533a36mF5XfJnxNhzykdvPlCJe3KSu5KHb5wWDkW78AZjFdWHTQK
        I+Ar0yQy8Sn+dDI+jEIR+ycH7X6Ownow/CfQwwMrYQGPo0jwlitbzqCWMRJdMtfBU2WJWPvkSUU
        lnNnMMkMQq3VfbHL6dQJwb7LZIbclO2gf
X-Received: by 2002:adf:e281:: with SMTP id v1mr3333548wri.308.1644322890908;
        Tue, 08 Feb 2022 04:21:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLlALWJQvkTxajX4mY5wFPC0i9Cbyibc6vh+dA8xRid1wKDVpfMqtwnuSqGnDZsRaAsQEg1IKxzDseghgHQVU=
X-Received: by 2002:adf:e281:: with SMTP id v1mr3333537wri.308.1644322890725;
 Tue, 08 Feb 2022 04:21:30 -0800 (PST)
MIME-Version: 1.0
References: <20220204180504.328999-1-lyude@redhat.com>
In-Reply-To: <20220204180504.328999-1-lyude@redhat.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Tue, 8 Feb 2022 13:21:12 +0100
Message-ID: <CACO55ttjtNW9Gx6pJegGD+r37j53Do+jc5xoyTFf8aXaBt5y-g@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/backlight: Fix LVDS backlight detection on
 some laptops
To:     Lyude Paul <lyude@redhat.com>
Cc:     nouveau <nouveau@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
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

On Fri, Feb 4, 2022 at 7:05 PM Lyude Paul <lyude@redhat.com> wrote:
>
> It seems that some laptops will report having both an eDP and LVDS
> connector, even though only the LVDS connector is actually hooked up. This
> can lead to issues with backlight registration if the eDP connector ends up
> getting registered before the LVDS connector, as the backlight device will
> then be registered to the eDP connector instead of the LVDS connector.
>
> So, fix this by only registering the backlight on connectors that are
> reported as being connected.
>

I think the patch might risk breaking muxed systems where we have two
GPUs, but.. the systems I know of have different ways of controlling
the backlight anyway. So unless there is something I missed this is

Reviewed-by: Karol Herbst <kherbst@redhat.com>

> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 6eca310e8924 ("drm/nouveau/kms/nv50-: Add basic DPCD backlight support for nouveau")
> Bugzilla: https://gitlab.freedesktop.org/drm/nouveau/-/issues/137
> Cc: <stable@vger.kernel.org> # v5.15+
> ---
>  drivers/gpu/drm/nouveau/nouveau_backlight.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> index ae2f2abc8f5a..6af12dc99d7f 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> @@ -294,7 +294,8 @@ nv50_backlight_init(struct nouveau_backlight *bl,
>         struct nouveau_drm *drm = nouveau_drm(nv_encoder->base.base.dev);
>         struct nvif_object *device = &drm->client.device.object;
>
> -       if (!nvif_rd32(device, NV50_PDISP_SOR_PWM_CTL(ffs(nv_encoder->dcb->or) - 1)))
> +       if (!nvif_rd32(device, NV50_PDISP_SOR_PWM_CTL(ffs(nv_encoder->dcb->or) - 1)) ||
> +           nv_conn->base.status != connector_status_connected)
>                 return -ENODEV;
>
>         if (nv_conn->type == DCB_CONNECTOR_eDP) {
> --
> 2.34.1
>

