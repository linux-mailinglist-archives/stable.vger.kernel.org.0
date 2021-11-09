Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3539F44AC40
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 12:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245625AbhKILI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 06:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245361AbhKILIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 06:08:17 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30B9C061764;
        Tue,  9 Nov 2021 03:05:31 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id az37so37698946uab.13;
        Tue, 09 Nov 2021 03:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CoQT9kQLphfD9DfsdxFujSLcLIfRF8KjIvTD4VNrVpE=;
        b=KbT0Tgxi1kj/NmOdlKO/Zk/kGaKxM1iB0Pi2WiP6HsLBVLY1bynZDkU7TKvC5OpQBv
         aS801D5Gmvqm821jj5oe5X4UpYUO6xA5jZm5NegV6DTQ6JWSQ6Dy6cZIrbs4dD3VaN+Y
         o0LDxyYEQxLB4bZN+K8rBbt4zi1qIoc+u1G1cgjH9bgSaL8bgVjDMDWBfSs3DDNsC8uq
         mRwFgTZGDMgK5VpYl6sGpURuo+Gjx8i3rLasx85PNWiVo/IkQlUJ5DMRwPzkQx8+Bzvb
         nt4tu14K8EmjLjkjotSfL8c+sNyAn6haBT8PzsXMo6IVsnrdyw2rt1o7LTbdTulTXgRF
         yrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CoQT9kQLphfD9DfsdxFujSLcLIfRF8KjIvTD4VNrVpE=;
        b=IcdCdnrFZOQRcEdrwgCvf7EZjFL3theB/2nrtmxgiouHA8sbSxbGCiX8KwB2Tp8a66
         GehDfKitK8DB6n7uSUJUnNYstbxu1iTKOE/jvxJLUoBKXPfWg+tOIF3LBTsCUZzGu2ri
         sGQh7wpyjq2Y3/Cn8If9mOqIjJwk5hLYLQT2Jls5Fd5iGFV1XZKLzZ7e09vLSitEFtal
         FabeLQAGUPa/PlxHndcg/z3/lMht0cFuqEyoz5JvJ5n8/uRprenzG+evUKcBv8yRTBx+
         vHmAOEtmXafc9JcwUV40enymSn1dWPZBv2nzbpKF4+QKKKicXYv8pkoAMAWMcq7bYsRZ
         Fbvg==
X-Gm-Message-State: AOAM532CILxbVxjJh6NJIZ+cTBxnykwggnrf33c2QNVNjSqQ+l2gKo20
        mtuBd/Wvhc2jEm7LHZf7mVriwrLnrM4Jnc2kXwrFJ6lG
X-Google-Smtp-Source: ABdhPJzMtJQIuxeFYMZVay2vSxrz8kcX1Rm+1v/20mRoFiUhEjoDI8sX4o+NtbJFxThcwKV2AGJLiiSIxTfihE+32b0=
X-Received: by 2002:ab0:5925:: with SMTP id n34mr9021345uad.46.1636455930857;
 Tue, 09 Nov 2021 03:05:30 -0800 (PST)
MIME-Version: 1.0
References: <20211031064046.13533-1-sergio.paracuellos@gmail.com> <CACRpkdb7eVgSvU=1GoYEHFpo7jSO-OAY3i9=Ld2gn-oC=q3Tow@mail.gmail.com>
In-Reply-To: <CACRpkdb7eVgSvU=1GoYEHFpo7jSO-OAY3i9=Ld2gn-oC=q3Tow@mail.gmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Tue, 9 Nov 2021 12:05:19 +0100
Message-ID: <CAMhs-H8JTs4kfsE4m95tQwKL7dth7ezETEeLgBy4Ufc6nfOzCw@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: ralink: include 'ralink_regs.h' in 'pinctrl-mt7620.c'
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 9, 2021 at 12:00 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Sun, Oct 31, 2021 at 7:40 AM Sergio Paracuellos
> <sergio.paracuellos@gmail.com> wrote:
>
> > mt7620.h, included by pinctrl-mt7620.c, mentions MT762X_SOC_MT7628AN
> > declared in ralink_regs.h.
> >
> > Fixes: 745ec436de72 ("pinctrl: ralink: move MT7620 SoC pinmux config into a new 'pinctrl-mt7620.c' file")
> > Cc: stable@vger.kernel.org
> > Cc: linus.walleij@linaro.org
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
> > ---
> > Changes in v2:
> >  - Original patch from Luiz.
> >  - I have added Fixes tag and CC Linus Walleij and stable and sent v2.
>
> Fixed up headers and applied for fixes.

Thanks!

Best regards,
    Sergio Paracuellos
>
> Yours,
> Linus Walleij
