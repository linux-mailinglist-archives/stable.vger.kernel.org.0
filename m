Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8D686B8
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 11:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfGOJ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 05:58:34 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37147 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbfGOJ6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 05:58:34 -0400
Received: by mail-io1-f68.google.com with SMTP id q22so33098105iog.4
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 02:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p/gHZTm5E1jRrM1Q0YzsIPwWIMyzzrdFihto25L6y0Q=;
        b=vLuu+xnlAvrfnOPZ7Ws5ws81JJMxeS9DSqYkxD8kNS0Pnkr6SLk6GPGSPxY227zlB8
         FkYxdfzwU/ROjnPQQrnaGae8Gu8yzjfq4AqNjVO/H+c3HGr2eXFLdTFGqG/qFnsTWv76
         oRX2204Ft/Ho08qetqCvZ02zeKydaxg97GPwD2zDskglidipT8/U9LdY6o79e6oWlX3G
         ajXqHI696+18e2GxHxN/7A5KjampTMEe+UvlIYxhFr4yJJDeu03Y35PdYLA+5Unku/Ti
         nn7hC+UUcIJXt+8b7+PhdgFVsVQq8fGGD6u6zVIoFvi11HLw3AU9sWmgfzcatsRnziE3
         PDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p/gHZTm5E1jRrM1Q0YzsIPwWIMyzzrdFihto25L6y0Q=;
        b=VGTDv0j5BoLWOtAjyO/qtt67xnYD4dHd/79AWLGlxIltmUwYb9TQIU2pogo1RTkuo9
         jQGVSmP6QAoiWmV7Zn6/mfgKwJuK4Ag9eYFQIjcVYblUtdcwfEBgaMGiABAgxBallmPF
         2hVWuyOOUh48zPD91tLuSUTevrlOsYiGyugU/sP9G26uKfC+NVyIcrca+eOS1eHJQUq9
         ogS1qEIyKXGNCTR7HWTPkTwrmAhLiKBO8fmq6gMK3rpuHnsnrDcKetaLiyNzq0CM05Np
         GhOuPaUjYx+30mV0m0XxihEI5avvyr4nb99UCGX+0G1QrxpjjTFigsGnHB0M7fsF5UZ2
         D8Vg==
X-Gm-Message-State: APjAAAV+FHeIj/kLop2bhPZSNGgu/G7cl5L+gOOe6LPe2RWlauEySpYu
        xaGPghFYkW1Uqbm7o0K7FfuC4b5TOyZqnqVpVv0=
X-Google-Smtp-Source: APXvYqz8XA8SyBauZiqhPQcHgICCCe4cjZsBXQ40JhwvG2PORL6EtWr3AMfb1j++pGaSUYkkBZ4yqtBGa+WKT1X4QHA=
X-Received: by 2002:a6b:f80b:: with SMTP id o11mr17231256ioh.40.1563184713317;
 Mon, 15 Jul 2019 02:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190711082936.8706-1-brgl@bgdev.pl> <CAMuHMdWzEOVLUZM_rFfMKqF_G_gZXBpV7TC-OXmN8YKw6_occQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWzEOVLUZM_rFfMKqF_G_gZXBpV7TC-OXmN8YKw6_occQ@mail.gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 15 Jul 2019 11:58:22 +0200
Message-ID: <CAMRc=MdD=JPerECFAeXW+FG=gsRLLR8X3AxfyCxfqFeOATQA9w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: em: remove the gpiochip before removing the
 irq domain
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Phil Reid <preid@electromag.com.au>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

czw., 11 lip 2019 o 10:47 Geert Uytterhoeven <geert@linux-m68k.org> napisa=
=C5=82(a):
>
> CC Niklas, who has the hardware
>
> On Thu, Jul 11, 2019 at 10:29 AM Bartosz Golaszewski <brgl@bgdev.pl> wrot=
e:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > In commit 8764c4ca5049 ("gpio: em: use the managed version of
> > gpiochip_add_data()") we implicitly altered the ordering of resource
> > freeing: since gpiochip_remove() calls gpiochip_irqchip_remove()
> > internally, we now can potentially use the irq_domain after it was
> > destroyed in the remove() callback (as devm resources are freed after
> > remove() has returned).
> >
> > Use devm_add_action_or_reset() to keep the ordering right and entirely
> > kill the remove() callback in the driver.
> >
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Fixes: 8764c4ca5049 ("gpio: em: use the managed version of gpiochip_add=
_data()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds

Patch applied.
