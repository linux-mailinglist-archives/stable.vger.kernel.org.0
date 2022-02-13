Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9224B3E5E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiBMXYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 18:24:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiBMXYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 18:24:21 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B7A51339;
        Sun, 13 Feb 2022 15:24:14 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id x4so5470231oic.9;
        Sun, 13 Feb 2022 15:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kk7Rmg8nqT4IcEIalup+DUtrBMcg7tfuC0IrV7wEnqk=;
        b=fOdFbIH0D7nEcaTmk+kknKW/VVNYGwb7oUjcWM0HpKuxkn2NQe91uopM1W7wPUXA65
         2laklQ86r0rgKAOY7ooERQ1dsd7SQ4hiKkMM2w6QOUuRS2riyYDK+EhVgZNfKYr4zsjp
         hlMmfQ2wCN+OVU2isjLc7+TUZkVYy/oRjZZCJihQUHcwoubQDA9ErR8aW25JL8Ir4ZA7
         9590C5iAlU074UgKWwYNTItP25owj/inU2WcfvuXoF+GPtApkmgbuf9vylSFFpseAtYp
         JcFfCljX3q7jsguBBEQ4EscWEtECbret7hJ8hQOSWR++LsZot7zOa3n5XmXXxfmndGiD
         r0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kk7Rmg8nqT4IcEIalup+DUtrBMcg7tfuC0IrV7wEnqk=;
        b=XtZ4nl75DxLa1WRnVBymVIZ5yioA5W/PGd4ls7OIq9yyYCt0fccufLJ8hyFXYJDQU9
         0MrP2S0bLozJ+9Js7WL7UICMlpytdJPLGYK2O6CNczi4OtTmWWwE9cprr/W83WmbMGmp
         RwY0W5JFIorWEeDzq33qHqRtZs8Ph7zEjB1nLWwlPscs74OyrlhQedfHfdz+ID3amcAN
         53RvAprmlOyyosFeh3Z1VSmjcfpkUqCiNskeNB8/PFsSb5PHRlPfCPilA0DN3l55vQyG
         Lbp17oG4sMfXqcqOWN4Eh7J8o6o69FplLCE39IgRCUjOYJxU1CUJByz4jYbprk52xStU
         iRlg==
X-Gm-Message-State: AOAM530hahjPhHO96woTt0lErxO/rstMOfCu16dlqRHWlX9o1W1UBEY7
        h7GV2/2jU6EO78cA/tBDYxiGFh82vwli2/LE+NjLIAWb
X-Google-Smtp-Source: ABdhPJyKaZCHj1DcYFNBWwetxaE4vgHgo50CiBIHKIzEpvAIA10tVYsCc/97NkZhqeozqxxmygdoR/UNkCGxboO7hHc=
X-Received: by 2002:a05:6808:a96:: with SMTP id q22mr4631276oij.276.1644794653926;
 Sun, 13 Feb 2022 15:24:13 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
 <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com> <CACRpkda=0=Hcyyote+AfwoLKPGak7RV6VFt6b0fMVWBe8veTwA@mail.gmail.com>
In-Reply-To: <CACRpkda=0=Hcyyote+AfwoLKPGak7RV6VFt6b0fMVWBe8veTwA@mail.gmail.com>
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Date:   Sun, 13 Feb 2022 20:23:47 -0300
Message-ID: <CACjc_5r7i3HJ466MtwR0iZD6jdVXEqq4km0Tn7XwRijGnsDz=Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
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

On Sat, Feb 12, 2022 at 1:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Fri, Feb 11, 2022 at 11:36 PM Marcelo Roberto Jimenez
> <marcelo.jimenez@gmail.com> wrote:
>
> > > Which devicetree or boardfile in the upstream Linux kernel is this system
> > > using?
> >
> > arch/arm/boot/dts/at91-ariettag25.dts
>
> So this system was added in 2015 which is the same year that
> we marked the GPIO sysfs ABI obsolete:
>
> commit fe95046e960b4b76e73dc1486955d93f47276134
> Author: Linus Walleij <linus.walleij@linaro.org>
> Date:   Thu Oct 22 09:58:34 2015 +0200
>
>     gpio: ABI: mark the sysfs ABI as obsolete
>
> Why is this system which was clearly developed while we deprecated
> the sysfs ABI so dependent on it?

The date when the device tree file was committed upstream is not the
same date when the product has been released. The product was
originally released in about January, 2014, as can be seen, e.g, from
a post here from January 30, 2014:
https://www.open-electronics.org/acme-system-launched-arietta-g25-a-new-micro-linux-board/
This is almost two years before the API has been marked obsolete.

The company that produces the board (which I am not affiliated to)
gave their users access to a different device tree file.

> I am curious about the usecases and how deeply you have built
> yourselves into this.

I don't know if I understand what you mean, sorry.

> > In any case, the upstream file should be enough to test the issue reported here.
>
> The thing is that upstream isn't super happy that you have been
> making yourselves dependent on features that we are actively
> discouraging and then demanding that we support these features.

Hum, demanding seems to be a strong word for what I am doing here.

Deprecated should not mean broken. My point is: the API seems to be
currently broken. User space apps got broken, that's a fact. I even
took the time to bisect the kernel and show you which commit broke it.
So, no, I am not demanding. More like reporting and providing a
temporary solution to those with a similar problem.

Maybe it is time to remove the API, but this is up to "upstream".
Leaving the API broken seems pointless and unproductive.

Sorry for the "not super happiness of upstream", but maybe upstream
got me wrong.

We are not "making ourselves dependent on features ...". The API was
there. We used it. Now it is deprecated, ok, we should move on. I got
the message.

> Anyway, what is wrong with using the GPIO character device and libgpiod
> on this system? What kind of userspace are you creating that
> absolutely requires that you use sysfs?

There is nothing wrong, except for a matter of causality that seems to
have been inverted here and has been explained above.

> I hope not one of these?
> https://docs.kernel.org/driver-api/gpio/drivers-on-gpio.html
>
> Here is some info about what we have been doing with the GPIO
> character device:
>
> https://docs.kernel.org/driver-api/gpio/using-gpio.html
> https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/tree/
>
> Here is Bartosz presenting it:
> https://www.youtube.com/watch?v=BK6gOLVRKuU

Please, don't get me wrong. I find the work done in GPIO amazing.

Thanks for all the valuable information, I sincerely appreciate it and
will read it all carefully.

And I will also tell the dev team that they must use the GPIO char dev
and libgpiod from now on and must port everything to it. And we will
likely have another group of people who are not super happy, but
that's life... :)

> Since I patched the kernel such that you cannot activate the sysfs
> ABI without also activating the character device I *know* that you
> have it on your system.

Smart move!

> Yours,
> Linus Walleij

Best regards,
Marcelo.
