Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76535A1AC6
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 23:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbiHYVCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 17:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243575AbiHYVCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 17:02:40 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAECB14F1;
        Thu, 25 Aug 2022 14:02:39 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso3356025wmh.5;
        Thu, 25 Aug 2022 14:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=oLKhkirV3w4L2ZpLtqGDyVCrVsxu0uPLz0/+c0FrP44=;
        b=cvHGeIXHYzFMNUpkQTBDkSniG2v59mghDuSFV0tkUtvEoW+OcczMmvv9OQ5xC4rS56
         fr2ynukpR+2LGPbaDEjzEZi1uCf2uyrHgIHbfOYpNuZ7oiHMCIRUNzgucdgHA6fHxZ75
         OvITw0Knx5/j+DXdZtiM+w9cHWUZmGCZpf7Lw3pkX7ATiUElQsCDQnhIGsmbZqIadcT5
         tsLiGmdYSrgbcJVNXPDbFTdmF/dqFqQMjKpug6IPbzHNnoohsn0YNGM3Nfo9huB1ECeS
         DmYZ5NBmjiEO12CdKSnS+AjHjxSojhdbWVQbCelhDnlNafwUSVCCIRSsvkDkmq2m3b3W
         Ndjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=oLKhkirV3w4L2ZpLtqGDyVCrVsxu0uPLz0/+c0FrP44=;
        b=KaVRAAO2QJ0tpe00u1tr6eV4S5rvsc2EPkcr5MD+WpJLNJEC1jCgBxjwh33R98X2OW
         w6gc7Zy1drmgaEMI0UUL13u1o65YiRMZEufTiMsrsQ9aBB16qyKl5uF8IPA4oraNfT9U
         CL0mr2YjguO7rogfxHrZximx+T07ArclEa4C9j9F0i1lm+H3Q7AD+KH4YKEUIeQIUm83
         dNqgkYCz493Km6gA6HP6RtBfqUG2FSsEnln4/XLyeMmY5vFDjQ2NsBffcJqV6fw3+Si/
         dJrWa/K48ULrTYtrIGHf9dtNiyOzPhv9pV5F+tJ+1ZqXtEuWQJfyej1U/rNLrZUxyHXl
         yxGA==
X-Gm-Message-State: ACgBeo3cBwqtIqUVLBlkD8buXef2MhM3e+79Ay8vK4tnd0mVujd4uYeB
        m8kRi2j3PrjhyR0veXAmlcvNgykUErkH/A==
X-Google-Smtp-Source: AA6agR613VB97nXMu5ne+PQ1UsaX69bwQs2+kN0UuMNISDwePR0opBgEMh3oUBCIfifoMUUEFOAF2Q==
X-Received: by 2002:a05:600c:a09:b0:3a6:8900:c651 with SMTP id z9-20020a05600c0a0900b003a68900c651mr3343962wmp.145.1661461358339;
        Thu, 25 Aug 2022 14:02:38 -0700 (PDT)
Received: from kista.localnet (82-149-1-172.dynamic.telemach.net. [82.149.1.172])
        by smtp.gmail.com with ESMTPSA id ib6-20020a05600ca14600b003a62400724bsm534290wmb.0.2022.08.25.14.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:02:37 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc:     kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] media: cedrus: Fix watchdog race condition
Date:   Thu, 25 Aug 2022 23:02:36 +0200
Message-ID: <7418676.EvYhyI6sBW@kista>
In-Reply-To: <20220818203308.439043-2-nicolas.dufresne@collabora.com>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com> <20220818203308.439043-2-nicolas.dufresne@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dne =C4=8Detrtek, 18. avgust 2022 ob 22:33:06 CEST je Nicolas Dufresne napi=
sal(a):
> The watchdog needs to be schedule before we trigger the decode
> operation, otherwise there is a risk that the decoder IRQ will be
> called before we have schedule the watchdog. As a side effect, the
> watchdog would never be cancelled and its function would be called
> at an inappropriate time.
>=20
> This was observed while running Fluster with GStreamer as a backend.
> Some programming error would cause the decoder IRQ to be call very
> quickly after the trigger. Later calls into the driver would deadlock
> due to the unbalanced state.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 7c38a551bda1 ("media: cedrus: Add watchdog for job completion")
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej

> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c index
> 3b6aa78a2985f..e7f7602a5ab40 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> @@ -106,11 +106,11 @@ void cedrus_device_run(void *priv)
>=20
>  	/* Trigger decoding if setup went well, bail out otherwise. */
>  	if (!error) {
> -		dev->dec_ops[ctx->current_codec]->trigger(ctx);
> -
>  		/* Start the watchdog timer. */
>  		schedule_delayed_work(&dev->watchdog_work,
>  				      msecs_to_jiffies(2000));
> +
> +		dev->dec_ops[ctx->current_codec]->trigger(ctx);
>  	} else {
>  		v4l2_m2m_buf_done_and_job_finish(ctx->dev->m2m_dev,
>  						 ctx-
>fh.m2m_ctx,
> --
> 2.37.2


