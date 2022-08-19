Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098825993FE
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 06:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346062AbiHSEQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 00:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiHSEQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 00:16:17 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78738DA3C8;
        Thu, 18 Aug 2022 21:16:16 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id i14so6688596ejg.6;
        Thu, 18 Aug 2022 21:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vq1yZ0EE5iMuU3VXtaQDcy0x0rnS5PWC/88eh+empEo=;
        b=NzNdQOgCrCIL0I2Xc0Dm59Sa6UUlWHOuEF95rHuCDjE/E440pppYQd44fnia0iqGtc
         bwrQsf4YpQyO/n/cdcFwf/dYenrPlNLBnso/zOeK05h0izgq2sP8+b8Ys27UMzxR2Pzs
         OtR0kJbOqNbMTjefPUPKHWoqtFAhKe7dmjRla7jlQrTff7D/4gK+ZY+1zL/xHtoV6iNC
         0hsPBixC4WGZjgzRpoZy6nXKaPZMJ9PkfJOIazDqbFC+NbZLxcwJvhRVt3AZgADfKj9E
         c2NBWcW3wO/FFXerQkEgthOmPvXInrhsgroOCxn1oWrDPI4lv6mUhBEi2mn4rSG7vLh5
         TU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vq1yZ0EE5iMuU3VXtaQDcy0x0rnS5PWC/88eh+empEo=;
        b=f2o408t5e7sUt4jgKvK/+uZiZMwNtx+3KlqTsS7nYP8pSDJDQsdLqVSltabBqUBxB6
         CSwnUG7NHuU2x2b055oizsk3N5n3X4+/lIPcaqPzPF95y1ldWNXbvL/c30nvzr3l84SK
         UGQC8a/xAfAqcqpIHLmMPBT5nAEDFOy2bs8J5tSL1E1I0DbypRbCBxtQxxj8yiHyESox
         +7qgzEwd11YkROWciP+UtuQdnPcQ/hRUJshmaVRlAGgQkZpfnIAU8v4hWTVgTraCo9fN
         4tFcAt4trPTL6SSTf2cN44D1D6KNbgYp4jufCvZt+HIb89tpZnXZqMSScqxg3GBMqGiP
         B6gA==
X-Gm-Message-State: ACgBeo21403EaXFATk5ex7ZfEhfpHjZl+d8CKJpu0gyUykFexc647XQR
        i6ptboJzmxjpLRs29MCIJu5Q+0CELz0=
X-Google-Smtp-Source: AA6agR4u+xoL53tF8jTeclefhfqlSHhBWjqPkJU0U4z6pxBmppCwnNGc/weUdHGATmCfPOiVyXK0rw==
X-Received: by 2002:a17:907:60c7:b0:731:2be4:f72d with SMTP id hv7-20020a17090760c700b007312be4f72dmr3597074ejc.639.1660882575071;
        Thu, 18 Aug 2022 21:16:15 -0700 (PDT)
Received: from jernej-laptop.localnet (82-149-1-172.dynamic.telemach.net. [82.149.1.172])
        by smtp.gmail.com with ESMTPSA id h22-20020a1709070b1600b0073087f7dfe2sm1703723ejl.125.2022.08.18.21.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 21:16:14 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc:     kernel@collabora.com,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] media: cedrus: Fix endless loop in cedrus_h265_skip_bits()
Date:   Fri, 19 Aug 2022 06:16:12 +0200
Message-ID: <5849126.lOV4Wx5bFT@jernej-laptop>
In-Reply-To: <20220818203308.439043-4-nicolas.dufresne@collabora.com>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com> <20220818203308.439043-4-nicolas.dufresne@collabora.com>
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

Dne =C4=8Detrtek, 18. avgust 2022 ob 22:33:08 CEST je Nicolas Dufresne napi=
sal(a):
> From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
>=20
> The busy status bit may never de-assert if number of programmed skip
> bits is incorrect, resulting in a kernel hang because the bit is polled
> endlessly in the code. Fix it by adding timeout for the bit-polling.
> This problem is reproducible by setting the data_bit_offset field of
> the HEVC slice params to a wrong value by userspace.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

=46ixes tag would be nice.

> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_h265.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c index
> f703c585d91c5..f0bc118021b0a 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> @@ -227,6 +227,7 @@ static void cedrus_h265_pred_weight_write(struct
> cedrus_dev *dev, static void cedrus_h265_skip_bits(struct cedrus_dev *dev,
> int num) {
>  	int count =3D 0;
> +	u32 reg;
>=20
>  	while (count < num) {
>  		int tmp =3D min(num - count, 32);
> @@ -234,8 +235,9 @@ static void cedrus_h265_skip_bits(struct cedrus_dev
> *dev, int num) cedrus_write(dev, VE_DEC_H265_TRIGGER,
>  			     VE_DEC_H265_TRIGGER_FLUSH_BITS |
>  			     VE_DEC_H265_TRIGGER_TYPE_N_BITS(tmp));
> -		while (cedrus_read(dev, VE_DEC_H265_STATUS) &
> VE_DEC_H265_STATUS_VLD_BUSY) -			udelay(1);
> +
> +		if (cedrus_wait_for(dev, VE_DEC_H265_STATUS,
> VE_DEC_H265_STATUS_VLD_BUSY)) +		=09
dev_err_ratelimited(dev->dev, "timed out
> waiting to skip bits\n");

Reporting issue is nice, but better would be to propagate error, since ther=
e=20
is no way to properly decode this slice if above code block fails.

Best regards,
Jernej

>=20
>  		count +=3D tmp;
>  	}




