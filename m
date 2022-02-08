Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99984AD8CE
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343608AbiBHNP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 08:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243018AbiBHMWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 07:22:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80E1DC03FEC0
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 04:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mt0hncQ/RRm0riihXr626lJBH3pbgbYhHyz5dtgoOAs=;
        b=gYZfm7tRUihBv3TJhA7MI1tSCAWqmzAY4kOOMNTLo0R5gdMi3S7b2e4Kzs/B7JA5dXh042
        8lP5EOK3LKB3O1Ob2w/vZ3BX2u1mLT4DXBaNDdyxD/Hab/e8VDLIJwU0yMacyia2v8TaFB
        5oRiFcKRkdEW+1S+wppTxZ/cZBZHHOE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132--pcMfD6gMsaKv4p7LoaaRA-1; Tue, 08 Feb 2022 07:22:14 -0500
X-MC-Unique: -pcMfD6gMsaKv4p7LoaaRA-1
Received: by mail-wm1-f70.google.com with SMTP id a8-20020a7bc1c8000000b0037bc4c62e97so471766wmj.0
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 04:22:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mt0hncQ/RRm0riihXr626lJBH3pbgbYhHyz5dtgoOAs=;
        b=3UtYmFBpJib5uAGmXTLcZ2Bc63ou62pKOsb6NWdUJL6jdXNYo1AwP1o1rgpgk+q73Y
         jRgxgJnPn6mJI0+BdXA4zqNYrhTuqBkCckwB9BqydjYqT02Q/SjQcxCj+KlStTRPsYV8
         qaqC84yy1xLKXZNJjQbDJBInD0MbZQQg+kv0WDVbmaMMWkr/hkZyXW5+ScElCTUyVcBw
         9tG5MW/mBQHpLlgzMdWAyLsUMoiX3uFuk+VALtvqz0846e2G9dsZK6BiKAnwEAZ94LWA
         QVZaQOvv8xeoBypSeKlNJHFimIiuZOKUCBeUIWZnd9h2yl7AGbHZ1YK5HF5kfgTPt6HF
         qFVQ==
X-Gm-Message-State: AOAM5320DuZkvhfXETjCd8pt/g5pnfWt710LUvOnnhNR5+PY8i+76iLA
        plnIjVH2rPOvIhbKM7Nnw7wZf/a5kSX3pHscWkl0OKsoo26lhkZ+6zply8U7/JcYRFI0gFz6HFQ
        CEJ0DFzmZegNj4dd79i9QvZ2sGvqCyDaD
X-Received: by 2002:a7b:c21a:: with SMTP id x26mr938667wmi.74.1644322933134;
        Tue, 08 Feb 2022 04:22:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw05S2FM4hb+eMcua2vq2VzpKE6qzOqTT3pzSCAKpcyucQY5qglNO8kSljUgpASBmw4liJar8UCAeaCMl7/oQ0=
X-Received: by 2002:a7b:c21a:: with SMTP id x26mr938337wmi.74.1644322927980;
 Tue, 08 Feb 2022 04:22:07 -0800 (PST)
MIME-Version: 1.0
References: <20220204193319.451119-1-lyude@redhat.com>
In-Reply-To: <20220204193319.451119-1-lyude@redhat.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Tue, 8 Feb 2022 13:21:57 +0100
Message-ID: <CACO55tv1yFYeboJsdV9sg1KWqWhs3WfJVmHuBKjAV6FUi6BLSA@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/backlight: Just set all backlight types as RAW
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Karol Herbst <kherbst@redhat.com>

On Fri, Feb 4, 2022 at 8:33 PM Lyude Paul <lyude@redhat.com> wrote:
>
> Currently we can get a warning on systems with eDP backlights like so:
>
>   nv_backlight: invalid backlight type
>   WARNING: CPU: 4 PID: 454 at drivers/video/backlight/backlight.c:420
>     backlight_device_register+0x226/0x250
>
> This happens as a result of us not filling out props.type for the eDP
> backlight, even though we do it for all other backlight types.
>
> Since nothing in our driver uses anything but BACKLIGHT_RAW, let's take the
> props\.type assignments out of the codepaths for individual backlight types
> and just set it unconditionally to prevent this from happening again.
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 6eca310e8924 ("drm/nouveau/kms/nv50-: Add basic DPCD backlight support for nouveau")
> Cc: <stable@vger.kernel.org> # v5.15+
> ---
>  drivers/gpu/drm/nouveau/nouveau_backlight.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> index 6af12dc99d7f..daf9f87477ba 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> @@ -101,7 +101,6 @@ nv40_backlight_init(struct nouveau_encoder *encoder,
>         if (!(nvif_rd32(device, NV40_PMC_BACKLIGHT) & NV40_PMC_BACKLIGHT_MASK))
>                 return -ENODEV;
>
> -       props->type = BACKLIGHT_RAW;
>         props->max_brightness = 31;
>         *ops = &nv40_bl_ops;
>         return 0;
> @@ -343,7 +342,6 @@ nv50_backlight_init(struct nouveau_backlight *bl,
>         else
>                 *ops = &nva3_bl_ops;
>
> -       props->type = BACKLIGHT_RAW;
>         props->max_brightness = 100;
>
>         return 0;
> @@ -411,6 +409,7 @@ nouveau_backlight_init(struct drm_connector *connector)
>                 goto fail_alloc;
>         }
>
> +       props.type = BACKLIGHT_RAW;
>         bl->dev = backlight_device_register(backlight_name, connector->kdev,
>                                             nv_encoder, ops, &props);
>         if (IS_ERR(bl->dev)) {
> --
> 2.34.1
>

