Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A241047B47F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 21:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhLTUmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 15:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhLTUmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 15:42:09 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28877C061574;
        Mon, 20 Dec 2021 12:42:09 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id w5-20020a4a2745000000b002c2649b8d5fso3413323oow.10;
        Mon, 20 Dec 2021 12:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86q6mGPUW4i0Ae9W5pTbC5IqFkYxCsVwOjM880qisKg=;
        b=om8J+juci05U81DBgVnGqUJ2oUdCRZjDGd+lGjYueYFIttOeh20S3wNcK0h9moIAzk
         IQxo/eyZJEFIB+q/HWK+qCJWRdWnVgsvqSrrgM5qExdMz63vG4tKPwWAboM/THwOTMGc
         OPsWv6mJ2uXWixt3ujBgcjIXew/hxKA/u2qMU7Z/QvDg5E9YO8fyPF+hixeZ1pFjYT0x
         egwkZiyzedSrtqeweQvnXlzg25nksNIyUH475e7v2L0c+PjfwRjuEhZPuGw47rtCCLc6
         db4NOM5sK/A1RS0eDlZqXteuu8ayFKmc5mQ7bwmqgFl5JKIC2mmzRfT4RgYtGs4UFvyo
         mDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86q6mGPUW4i0Ae9W5pTbC5IqFkYxCsVwOjM880qisKg=;
        b=DRnd1WYgoKIxPO2CCfhWjca9vn238OJ75recMEagKIUzMOwnjmU8wr0vXkKZuhF2AC
         E4xzpKSd15B7MS7EwTtbPuu8TKZp3f0AxZU19H+/j+H2TxVmX6L4hfXbVzxdnpJVd5EG
         PSD3A/4gDCpIHwNAIBkBOYMAzMDQc/LfGplQb4r3qYF1oWR2KlffHqr5gKgm8S4w+S7Z
         lf2bllg/sqmnZtboXYxgbUZEPHGdyTDNRRhpooKdFO3oryEVVIZNyCkRxqNKrWo6wN2E
         I0jeTHPDyJi6yD/Qf7qYNedPGk0NnwRxVRNuAmVmyFohnjnHY4l59SsEWPW4nXfuzt64
         qDUQ==
X-Gm-Message-State: AOAM53251CwgLRSGV4HL7fEBKKSLUDMtaCKQkEYH+nzO8mRlwrZoZDpk
        HT77+AJCRoZp1zHFYAQZuvam29H4lqSQxHfS+oU=
X-Google-Smtp-Source: ABdhPJyqqffSkXvODMEsCx/EpSsjjcIv17gUSuEsOTyhqF1IRS3Rg2WkKFZFauMLFilHPkk/OwChKQe91ycOPT/7fcg=
X-Received: by 2002:a4a:9406:: with SMTP id h6mr11394881ooi.80.1640032928320;
 Mon, 20 Dec 2021 12:42:08 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info> <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
 <CAMuHMdVp621B0DywkW6sx6wNcPFez9=3-=cfSo7UoRttJ6QXCg@mail.gmail.com> <CABYd82b2i4Uuyi5+zLoTgiC-QMS1y=VkwmMznZqxLca0iP9qTQ@mail.gmail.com>
In-Reply-To: <CABYd82b2i4Uuyi5+zLoTgiC-QMS1y=VkwmMznZqxLca0iP9qTQ@mail.gmail.com>
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Date:   Mon, 20 Dec 2021 17:41:42 -0300
Message-ID: <CACjc_5qQv_vWawtbA8O01EaiY6GqSXQYs0jgC8XLAGYuwtnUUg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Will McVicker <willmcvicker@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will,

On Mon, Dec 20, 2021 at 4:25 PM Will McVicker <willmcvicker@google.com> wrote:
>
> On Mon, Dec 20, 2021 at 7:14 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >
> > On Mon, Dec 20, 2021 at 3:57 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
> > > <regressions@leemhuis.info> wrote:
> > > > [TLDR: I'm adding this regression to regzbot, the Linux kernel
> > > > regression tracking bot; most text you find below is compiled from a few
> > > > templates paragraphs some of you might have seen already.]
> > > >
> > > > On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
> > > > > Some GPIO lines have stopped working after the patch
> > > > > commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
> > > > >
> > > > > And this has supposedly been fixed in the following patches
> > > > > commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> > > > > commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
> > > >
> > > > There seems to be a backstory here. Are there any entries and bug
> > > > trackers or earlier discussions everyone that looks into this should be
> > > > aware of?
> > > >
> > >
> > > Agreed with Thorsten. I'd like to first try to determine what's wrong
> > > before reverting those, as they are correct in theory but maybe the
> > > implementation missed something.
> > >
> > > Have you tried tracing the execution on your platform in order to see
> > > what the driver is doing?
> >
> > Looking at commits that have related Fixes tags:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bf781869e5cf3e4ec1a47dad69b6f0df97629cbd
> > https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git/commit/?id=e8f24c58d1b69ecf410a673c22f546dc732bb879
> >
> > Gr{oetje,eeting}s,
> >
> >                         Geert
> >
> > --
> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> >
> > In personal conversations with technical people, I call myself a hacker. But
> > when I'm talking to journalists I just say "programmer" or something like that.
> >                                 -- Linus Torvalds
>
> Hi Marcelo,
>
> Thanks for reporting this issue. I can give you a little context on
> why commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not
> defined") was created. We were seeing a refcounting issue on Pixel 6.
> In our kernel CONFIG_PINCTRL is defined. Basically, the camera kernel
> module requests for a GPIO on sensor enable (when the camera sensor is
> turned on) and releases that GPIO on sensor disable (when the camera
> sensor is turned off). Before commit 6dbbf84603961, if we constantly
> switched between the front and back camera eventually we would hit the
> below error in drivers/pinctrl/pinmux.c:pin_request():
>
>     E samsung-pinctrl 10840000.pinctrl: could not increase module
> refcount for pin 134
>
> In our kernel the sensor GPIOs don't have pin_ranges defined. So you
> would get these call stacks:
>
> Sensor Enable:
>   gpiochip_generic_request()
>   -> return 0
>
> Sensor Disable:
>   gpiochip_generic_free()
>   -> pinctrl_gpio_free()
>
> This led to an imbalance of request vs free calls leading to the
> refcounting error. When we added commit 6dbbf84603961 ("gpiolib: Don't
> free if pin ranges are not defined"), this issue was resolved. My
> recommendation would be to drill down into your driver to figure out
> what happens in these functions to see why you're getting the results
> you reported.

Thanks for your reply.

Commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not
defined") is perfectly fine in the context and fixes a serious issue.
But to revert the original patch we need to revert this patch too, for
the same reason, i.e., in order to not generate a *_free() imbalance.

In my case the imbalance causes problems as soon as the test script is
run a second time.

>
> --Will

Regards,
Marcelo.
