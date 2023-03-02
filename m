Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6026A8885
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 19:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCBS3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 13:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCBS3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 13:29:44 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B541689F
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 10:29:43 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y140so11057iof.6
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 10:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xpWolHBTfv1e/s85d7Nor58l6lqGaWFhdL+nTiGGVic=;
        b=QI7gz/LeygpGxrmWN08W2VKhqopzlDmPIMqoxGEz9VFAjmlDg199kMccbeLiAyrhdi
         H/Yvc2c5UwqTGdwX9DOSblo6pvnc5iN/NV+8j+BuYzA7+Utu8lpFc+rE87A9QqEFCqbj
         glnz67pYLBz+umPSkDBuPlZ+iiqngAtoKnn7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpWolHBTfv1e/s85d7Nor58l6lqGaWFhdL+nTiGGVic=;
        b=GGc6kKLmhpBy3rb2fXrMIaPvrjRbvrOcAlAb6B4CPQStXeiNHdisP3Hsi+BSIJLa1b
         wWdf9Iudey1yHCYP3IHxbLQiyuaHtbXDsbDFGPNkXZh5c+0c999rlAkwtx1hC2k4PdPm
         JFqRTl3Z8lRne1sUfP9D9PhPxm5DNuQGBnwjID+NV0x3MXXe4G+yvBtjp6RGgZfgILO+
         l7eVJFXlo66dRbVQYAAjt7rlpA5Ddq4mj7GB3PXqOp7sGlc8xqT/5dqSsLihH+iUrIrF
         lNGaf+WpgV/hn8jIH2sHz2BeUhvamDryMQIUvCtymLKpC5zjvvB9gnNdBzD+I33AuJ96
         xpZQ==
X-Gm-Message-State: AO0yUKUDZRrqmL+uHMaF9/dZ65oCiRh9jm2HyWfrCaqrgw+No7TWVpKJ
        MzpLTMGPTV8TBVSnDl/jSbRvcB9sY6wZeR6/
X-Google-Smtp-Source: AK7set9spD7AIP2I8/gxwIkPHxfWV4ltOFeAVd59Hkmb+fEXtUX3kZ5ohDeNAO1vdUly5qsasoWYtw==
X-Received: by 2002:a5d:841a:0:b0:74c:da4b:c4e4 with SMTP id i26-20020a5d841a000000b0074cda4bc4e4mr7162817ion.3.1677781782107;
        Thu, 02 Mar 2023 10:29:42 -0800 (PST)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com. [209.85.166.49])
        by smtp.gmail.com with ESMTPSA id f23-20020a6be817000000b007437276ae6dsm64449ioh.3.2023.03.02.10.29.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 10:29:41 -0800 (PST)
Received: by mail-io1-f49.google.com with SMTP id b5so37463iow.0
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 10:29:41 -0800 (PST)
X-Received: by 2002:a02:8545:0:b0:3e5:a7d9:27db with SMTP id
 g63-20020a028545000000b003e5a7d927dbmr4740334jai.6.1677781780914; Thu, 02 Mar
 2023 10:29:40 -0800 (PST)
MIME-Version: 1.0
References: <20230302074704.11371-1-johan+linaro@kernel.org>
In-Reply-To: <20230302074704.11371-1-johan+linaro@kernel.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 2 Mar 2023 10:29:29 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WK2yxWqAro6k4N2kr-HeNZLNxi6tuq=_uL0tbSjGVEAg@mail.gmail.com>
Message-ID: <CAD=FV=WK2yxWqAro6k4N2kr-HeNZLNxi6tuq=_uL0tbSjGVEAg@mail.gmail.com>
Subject: Re: [PATCH] drm/edid: fix info leak when failing to get panel id
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Mar 1, 2023 at 11:49=E2=80=AFPM Johan Hovold <johan+linaro@kernel.o=
rg> wrote:
>
> Make sure to clear the transfer buffer before fetching the EDID to
> avoid leaking slab data to the logs on errors that leave the buffer
> unchanged.
>
> Fixes: 69c7717c20cc ("drm/edid: Dump the EDID when drm_edid_get_panel_id(=
) has an error")
> Cc: stable@vger.kernel.org      # 6.2
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/gpu/drm/drm_edid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 3841aba17abd..8707fe72a028 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -2797,7 +2797,7 @@ u32 drm_edid_get_panel_id(struct i2c_adapter *adapt=
er)
>          * the EDID then we'll just return 0.
>          */
>
> -       base_block =3D kmalloc(EDID_LENGTH, GFP_KERNEL);
> +       base_block =3D kzalloc(EDID_LENGTH, GFP_KERNEL);

Good catch! I'm landing this to drm-misc-fixes right away.

4d8457fe0eb9 drm/edid: fix info leak when failing to get panel id

I'm sure I copied the kmalloc() from _drm_do_get_edid(), but it looks
like in _that_ case if the read fails we never print the buffer so
that one is OK.

-Doug
