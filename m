Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623E4D662B
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 17:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbfJNPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 11:34:00 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45129 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbfJNPeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 11:34:00 -0400
Received: by mail-oi1-f193.google.com with SMTP id o205so14072148oib.12
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 08:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NeW2ccx5mLemVRdMTg/xri0iMxzTOWpGd70S1pvnHfA=;
        b=d+9/hiWTz5kS18fWHihUnn3GvJA+wo+Xn4DlTVFAME3zlaQcgSH6mUIfsuJaAed6op
         C/jaC8KGeO4D3G96jcn1n9d8uVAtusS6zBMMkXkpNzFqb5QbeHSOrTmPFCcknCeXOWCx
         4YM0th2V/njLYVNE0Y8UiXn/vPSdGxQdaHzg3LmEh6aOgwPQNF05cWjtH1sQuOmY1bdp
         0phtFcib5HwDWk60dheRYn0HK6wYKZ49sZRtGDldute4GHKKJMd1QyQFP6PQVZIv6dQD
         zSyz42CZvKM11uurtwnO7jItQ4cNbe16W727my/UA/Yv3AbBWplr91oaOd58Ergx9x26
         cZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NeW2ccx5mLemVRdMTg/xri0iMxzTOWpGd70S1pvnHfA=;
        b=PBuVpAZqTkNzjVPx8pswCyMdNCYz7C91eCAMaTe53DN4SwKetTEEn2O1AD5mAzI5I9
         FGfPI5Au1oj1m3o88uUBhZbwk5w7mnvP3wj8cVJR95nuWvUFjcVYd6fKfJ6li96ct8CH
         siAnCeE3bBCeSf8nsf92aY6Dy0d53ln0EqnhO7bMhSAbXTp1V6bEVuEQRx6OeRaEc6ge
         Eoh0EBfEqlIv/bv/UJQdKBPsARCZX3KWX99hN9s3IFxcq5TMEm/dp1j6W5ZVhWxxbEy5
         u2rK7u/jDqeluy6Ux8SedeKyn3AhJdukB5cCo2ntb+UX68bHXxSLh403gQ531kMxZcqT
         u+Bw==
X-Gm-Message-State: APjAAAVzB7YnG+5AYs+bjaVG5kLnjwI9WXmeJxBG4Y/r0z1O1l2VDlou
        FStmOulsq+RlV4ali2+FbPEx8OzP/vuePZX166nQxQ==
X-Google-Smtp-Source: APXvYqwHL4vWIFngOFesGaxj/cVK8awyo0pbYN6/FkPPexCCET4FGz+zFW+GV1EIg90Qi0wZLxZaBOyiV41VV0RScXY=
X-Received: by 2002:aca:5c06:: with SMTP id q6mr25307104oib.175.1571067239611;
 Mon, 14 Oct 2019 08:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <15710650933218@kroah.com>
In-Reply-To: <15710650933218@kroah.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Mon, 14 Oct 2019 17:33:48 +0200
Message-ID: <CAMpxmJVNs=+sSox8j-e=zGfpsiOF1zP9ARcbp5SAidOAgZ6eew@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] gpio: fix getting nonexclusive gpiods from
 DT" failed to apply to 5.3-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pon., 14 pa=C5=BA 2019 o 16:58 <gregkh@linuxfoundation.org> napisa=C5=82(a)=
:
>
>
> The patch below does not apply to the 5.3-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From be7ae45cfea97e787234e00e1a9eb341acacd84e Mon Sep 17 00:00:00 2001
> From: Marco Felsch <m.felsch@pengutronix.de>
> Date: Tue, 1 Oct 2019 11:49:21 +0200
> Subject: [PATCH] gpio: fix getting nonexclusive gpiods from DT
>
> Since commit ec757001c818 ("gpio: Enable nonexclusive gpiods from DT
> nodes") we are able to get GPIOD_FLAGS_BIT_NONEXCLUSIVE marked gpios.
> Currently the gpiolib uses the wrong flags variable for the check. We
> need to check the gpiod_flags instead of the of_gpio_flags else we
> return -EBUSY for GPIOD_FLAGS_BIT_NONEXCLUSIVE marked and requested
> gpiod's.
>
> Fixes: ec757001c818 gpio: Enable nonexclusive gpiods from DT nodes
> Cc: stable@vger.kernel.org
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> [Bartosz: the function was moved to gpiolib-of.c so updated the patch]
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index 1eea2c6c2e1d..80ea49f570f4 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -317,7 +317,7 @@ struct gpio_desc *gpiod_get_from_of_node(struct devic=
e_node *node,
>         transitory =3D flags & OF_GPIO_TRANSITORY;
>
>         ret =3D gpiod_request(desc, label);
> -       if (ret =3D=3D -EBUSY && (flags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
> +       if (ret =3D=3D -EBUSY && (dflags & GPIOD_FLAGS_BIT_NONEXCLUSIVE))
>                 return desc;
>         if (ret)
>                 return ERR_PTR(ret);
>

Hi Greg,

this and other GPIO patches can't be applied because the relevant code
has been moved a lot during the merge window. I'll send backports
shortly.

Bart
