Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A055B14864E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 14:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgAXNoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 08:44:34 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45977 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387812AbgAXNoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 08:44:34 -0500
Received: by mail-lj1-f195.google.com with SMTP id j26so2505264ljc.12
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 05:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=681bijGOIP3KrNVYlf7XkoIYiFDmMZfImCEes87J83I=;
        b=oTcjbOvt2QwnfWqSnATqp2zVWdsVZ51rbeM+d8pbBnSkiApH3bYFOZfKDfEGx6FO+G
         mYlAloxHhhNRQLah4UBHVhUU8AUEtv6XcIMrmUNfdNZv9jNAInESI50YFUDcNPtV4Xi4
         OrgSU86GukM3ULzXtbjrowjwViPZPvgdp2BcL7Sal2VT2Q/TUe4IzctfY6v96i/Z3Xud
         aDD+QXEDSr/lSx3qX0m8X8QpYaUmYiPHRagsJcSywkEWK2Af2J71+4t9zaDJd2SFwYLd
         k9CvtH08twDnbKGbr8i2Cu0QrC1GH2/3X7geYSu6YV5vLj944gzlZKt0cLgo2xtF9ydD
         o1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=681bijGOIP3KrNVYlf7XkoIYiFDmMZfImCEes87J83I=;
        b=jFX5H8x1p18wrPQnkg3k27B7qon4YmbBo7TgHXgxSIMHsiKMd0u2VplYpnKaYpqu4K
         mfnDgyx+tmRMh1vAiOEkcVQs3jNC/yK9lBPx02Dre4QOFXUGIa290a3BBwmc3LE1MEFU
         YmJUBbYobVQEVMHbSUbTwqvqNZEq/GU/d/JpuSu9ckqjTfVwyyEbu8W/4c+pgrdxMl89
         Wm3aX/jN1j/7HZFZl1QDSw+KenqPUuJLJFu0dDQ0N/YIFS3/OJCeR1xYgJNoRINo/a7R
         3J0POWIXTVh6+X4QGTSmxgWcXA9ruH3Wlk2dPPRZxSU5P8nIeFAtaJZlsLZAvT83z8Kt
         2JWQ==
X-Gm-Message-State: APjAAAWuKm4HH/PeZrgRWdJtUWEFdd7HqVJrP+zaSOVwoZb5D8Zl1LYL
        oSz0wJ5X34xvbnnFAqpHkJWv1evf+rXsb9ozf2XXiw==
X-Google-Smtp-Source: APXvYqxKj+jQyHTEX8XdhkCaTtOQNA+Qsr+/i1PQ2T9UmGbxGq6uGQ3G6xTY/FfpoQZjMCnID8Y5fSCr4cghZiVQSA0=
X-Received: by 2002:a05:651c:2c7:: with SMTP id f7mr2254281ljo.125.1579873471268;
 Fri, 24 Jan 2020 05:44:31 -0800 (PST)
MIME-Version: 1.0
References: <5e2ad951.1c69fb81.6d762.dd8e@mx.google.com> <0ed4668a-fb29-fca8-558e-385ef118d432@collabora.com>
 <20200124131821.GA4918@sirena.org.uk>
In-Reply-To: <20200124131821.GA4918@sirena.org.uk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 24 Jan 2020 14:44:19 +0100
Message-ID: <CACRpkdYdX-k+YT5wmyRzDnvaziwEDhYe82r3V2WOW6tyvNomFg@mail.gmail.com>
Subject: Re: stable-rc/linux-4.19.y bisection: baseline.login on sun8i-h3-libretech-all-h3-cc
To:     Mark Brown <broonie@kernel.org>
Cc:     Guillaume Tucker <guillaume.tucker@collabora.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        mgalka@collabora.com,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 2:18 PM Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jan 24, 2020 at 12:58:32PM +0000, Guillaume Tucker wrote:
>
> > Please see the bisection report below about a boot failure, it
> > looks legit as this commit was made today:
>
> > >     Fix it by ignoring the config in the device tree for now: the
> > >     later patches in the series will push all inversion handling
> > >     over to the gpiolib core and set it up properly in the
> > >     boardfiles for legacy devices, but I did not finish that
> > >     for this kernel cycle.

So here the patch clearly says it is for "this kernel cycle"
which I feel implies that it is NOT for any previous kernels
stable or not...

I'm sorry if I missed the "look at this thing that we will
apply to stable soon" mail, sadly there are just too many
of these for me to handle sometimes. (Maybe it means I
am making too many mistakes to begin with, mea culpa.)

> > >     Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
> > >     Reported-by: Fabio Estevam <festevam@gmail.com>
> > >     Reported-by: John Stultz <john.stultz@linaro.org>
> > >     Reported-by: Anders Roxell <anders.roxell@linaro.org>
> > >     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > >     Tested-by: John Stultz <john.stultz@linaro.org>
> > >     Signed-off-by: Mark Brown <broonie@kernel.org>
> > >     Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> Oh dear, this is another bot backported commit which I suspect is
> lacking some context or other from all the other work that was done with
> GPIO enables :(

This AI seems a bit confused :/
Maybe it is the prolific use of the word "fix" that triggers it?

Yours,
Linus Walleij
