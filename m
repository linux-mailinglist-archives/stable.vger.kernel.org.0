Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4D9440EB5
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 14:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhJaNpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 09:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhJaNpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Oct 2021 09:45:15 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D089FC061570;
        Sun, 31 Oct 2021 06:42:43 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id f4so27222901uad.4;
        Sun, 31 Oct 2021 06:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3+xpO8fzkCeapzFiUJk1K6GTL67bNhShj+Jer91ixc=;
        b=mJ0BM64NWeKIOPWHlNc/Mo12h+HHptaAmoNePbIWVVj2F/rs0KMgi2bZdYqTEAEMeA
         ASIAQO0fbHwSZzBFyj+yJEfFGCRI3iO0a8RatcZJPJe9Pw1rxaYiaY6g3l1S7p5vbL5C
         L+yQIYkV9zJy5jT5SUxLbqDcNYU3rBrfki3hgTlCdZNMh0oF+vKYaGsd3lT6k/yNsaeN
         e/CF9+sRT6BSSvyOGQiymkk/a+C9Y+LCmQqBILDL8rPKQkf5Myeb6PK/BGRL73pyJ463
         AICR9jpxk2h4ALlIEhpgfjWf7RhGpKstiNpFoyS0VF8F6Vb0So6uKsUxLXcEpBfPLbX7
         goQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3+xpO8fzkCeapzFiUJk1K6GTL67bNhShj+Jer91ixc=;
        b=GmgkWZCsned0/ubMM0sW8YP53BlLugIj5VJ+4kBaCQOSDz5RY926HlfUGJjVIfUD0U
         I2iOf1GkFqhL45QyT03iolsre/i0dAbsowdufW2w2HbSH6P0yDUUyBG+ASCYum5VJdUJ
         /5drU5qx8DK7k5Ohc3nOyv85h3n9c7uu++fUZVamidjAJfWTLgmhQ7QY5sFXLxu3KVa4
         XbUuQwoOoDEQAW5v16BYlIwZzN22SL8oJ+jPyVu7AfaDJGobeTnMzEl7G1PeOIV/V+3/
         s8SkbZQk/xj+RysZdKxmI7yT2Ck9J9aCV3O3s03JAiSjOguwHglqDHWWAAlHtZ44BQ5Z
         0RUQ==
X-Gm-Message-State: AOAM532oUsGUMmytnETCL2LL6LbjLwuxYlTZxOFGcMy3+TyctnMg8w7d
        qGFYO5omERjGApErFS+AwK2C1EgLkfHj+gjnGFU=
X-Google-Smtp-Source: ABdhPJyJuH9EIbc35OuuE+cCZvI8jo6ujqJHu00hWa4W9C/uJyBEpl5h9HTCnqa8cNWV4INZp9aC8LRg20/l4g6El0Y=
X-Received: by 2002:ab0:5925:: with SMTP id n34mr23689101uad.46.1635687762790;
 Sun, 31 Oct 2021 06:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211031064046.13533-1-sergio.paracuellos@gmail.com> <CAHp75Vf3TninFNRdz453sdqrQpu-2sqaiFd-rCqOFeo-kMCniw@mail.gmail.com>
In-Reply-To: <CAHp75Vf3TninFNRdz453sdqrQpu-2sqaiFd-rCqOFeo-kMCniw@mail.gmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Sun, 31 Oct 2021 14:42:31 +0100
Message-ID: <CAMhs-H-r2rUdhO3+-GfrOy+d7dXOBaN283Aqf3q5FqugLPpeMQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: ralink: include 'ralink_regs.h' in 'pinctrl-mt7620.c'
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andy,

On Sun, Oct 31, 2021 at 2:08 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Sun, Oct 31, 2021 at 8:41 AM Sergio Paracuellos
> <sergio.paracuellos@gmail.com> wrote:
> >
> > mt7620.h, included by pinctrl-mt7620.c, mentions MT762X_SOC_MT7628AN
> > declared in ralink_regs.h.
> >
> > Fixes: 745ec436de72 ("pinctrl: ralink: move MT7620 SoC pinmux config into a new 'pinctrl-mt7620.c' file")
> > Cc: stable@vger.kernel.org
> > Cc: linus.walleij@linaro.org
> >
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
>
> Tag blocks mustn't have blank lines.

Ok, thanks for letting me know.

>
> ...
>
> > +#include <asm/mach-ralink/ralink_regs.h>
> >  #include <asm/mach-ralink/mt7620.h>
> >  #include <linux/module.h>
> >  #include <linux/platform_device.h>
>
> Actually the rule of thumb is to start from more generic definitions /
> inclusions to more particular. Thus, asm/* usually goes after linux/*.
> Any Specific reason why here is not the case?

I just respect the order that was already in the files, I guess when I
moved all of this from arch/mips into drivers/pinctrl. All files
inside follows the same order.

Best regards,
    Sergio Paracuellos
>
> --
> With Best Regards,
> Andy Shevchenko
