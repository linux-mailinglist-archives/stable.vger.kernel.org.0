Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E75A1ACB
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 23:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbiHYVE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 17:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiHYVEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 17:04:55 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC5BB1DA;
        Thu, 25 Aug 2022 14:04:53 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so3338525wmk.1;
        Thu, 25 Aug 2022 14:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=DXT4YXU5YfePq29aQAo5O8wvrpSNVuJynC49Ki0/9po=;
        b=dnkzm9sreAWheeae/qavwTiTCcN31riVCLaNVZYSSD1GGVEZnwz1BhpuBtRgKU54Zn
         0+YPXV17eAtXDi2KkDDv5Lpeu/woF/E2S4Qpe8ABN4hVfKg1CDipFSqB931vxnt0kvlW
         Gh9vFaT7+ifcNaltOzHZN8pAxzpVmxErxUp5lDw+axFvYo6l6KkUNYnXJfIdjsvybvZ7
         Lg35te6K++gUfFuGwGKZmlda99s6Cisu4Mw3BCNIHrPMhxie6ghNMNRASr3EHhaAPa8F
         BGz4hbsyj3EkWNuLUL6MIrfLl7kWFfXzSDHUjjyrCwthX97uLLutzQyPjnSaT9g51JBb
         zJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DXT4YXU5YfePq29aQAo5O8wvrpSNVuJynC49Ki0/9po=;
        b=26hJL2GjK8Zjnkl6f/YKPdHuNPl/Tu3vqayB6gOEKZ/M9oUIMYbS+K2jBrRgfEnmV3
         LlPkDZ8wSIdxQ+cI3S4kgh1IkiFqSfcukcbVmFrnOAlugOEFaU9jRg5mamN5Svgn1C+2
         ZS87NENjNUR/cWJQC1a8laqAtNqahguC9YPWnV2xNW7yWcYcCtL5QGBE/IMt6bi2q0kx
         45AvdNvzWlpfmGzZrtCKWULomnaCGUK5iNE3kYd4g/X2D7eScphRr+jQRjK+w2vEHoDg
         NnnGHRGo1I+AZmPhiTnogRTUJwATzh9DmMAtSKP3isHd/agVXLUqepmOe/SCM0AEKuSZ
         Vnaw==
X-Gm-Message-State: ACgBeo1yjD4vty2G19EsgBeoszfmehbJ/Fx/lyTiveBo1TEc13enQoY+
        z/4IDdvK6dPEJFqqvoGYvHmr5XjyR19Xbg==
X-Google-Smtp-Source: AA6agR658ImtefvvuTP/XJnEPoCYnK8MprT9hIM2YBI4TLajSd2guvSYFKVYG1p+cLPRyDFtXSvgUQ==
X-Received: by 2002:a05:600c:2e47:b0:3a6:75fe:82a9 with SMTP id q7-20020a05600c2e4700b003a675fe82a9mr3412937wmf.189.1661461492119;
        Thu, 25 Aug 2022 14:04:52 -0700 (PDT)
Received: from kista.localnet (82-149-1-172.dynamic.telemach.net. [82.149.1.172])
        by smtp.gmail.com with ESMTPSA id i14-20020a05600c354e00b003a4f08495b7sm6953492wmq.34.2022.08.25.14.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:04:51 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc:     kernel@collabora.com, stable@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v1 2/3] media: cedrus: Set the platform driver data earlier
Date:   Thu, 25 Aug 2022 23:04:50 +0200
Message-ID: <3448453.iIbC2pHGDl@kista>
In-Reply-To: <6a8f2555-1bd4-ac81-390e-b597e3c886f6@collabora.com>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com> <4733096.GXAFRqVoOG@jernej-laptop> <6a8f2555-1bd4-ac81-390e-b597e3c886f6@collabora.com>
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

Dne nedelja, 21. avgust 2022 ob 22:40:21 CEST je Dmitry Osipenko napisal(a):
> On 8/20/22 11:25, Jernej =C5=A0krabec wrote:
> > Dne petek, 19. avgust 2022 ob 17:37:20 CEST je Nicolas Dufresne=20
napisal(a):
> >> Le vendredi 19 ao=C3=BBt 2022 =C3=A0 06:17 +0200, Jernej =C5=A0krabec =
a =C3=A9crit :
> >>> Dne =C4=8Detrtek, 18. avgust 2022 ob 22:33:07 CEST je Nicolas Dufresne
> >=20
> > napisal(a):
> >>>> From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> >>>>=20
> >>>> The cedrus_hw_resume() crashes with NULL deference on driver probe if
> >>>> runtime PM is disabled because it uses platform data that hasn't been
> >>>> set up yet. Fix this by setting the platform data earlier during pro=
be.
> >>>=20
> >>> Does it even work without PM? Maybe it would be better if Cedrus would
> >>> select PM in Kconfig.
> >>=20
> >> I cannot comment myself on this, but it does not seem to invalidate th=
is
> >> Dmitry's fix.
> >=20
> > If NULL pointer dereference happens only when PM is disabled, then it
> > does. I have PM always enabled and I never experienced above issue.
>=20
> Originally this fix was needed when I changed cedrus_hw_probe() to do
> the rpm-resume while was debugging the hang issue and then also noticed
> that the !PM should be broken. It's a good common practice for all
> drivers to have the drv data set early to avoid such problems, hence it
> won't hurt to make this change anyways.

Ok, as others pointed out, this is still a good thing, so:

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>


>=20
> In practice nobody disables PM other than for debugging purposes and !PM
> handling is often broken in drivers. I assume that it might be even
> better to enable PM for all Allwiner SoCs and remove !PM handling from
> all the affected drivers, like it was done for Tegra some time ago.
>=20

Maybe in the future :)

Best regards,
Jernej

> --
> Best regards,
> Dmitry



