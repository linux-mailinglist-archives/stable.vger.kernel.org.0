Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644FA48BBA1
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 01:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiALAJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 19:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiALAJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 19:09:42 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCCAC06173F;
        Tue, 11 Jan 2022 16:09:42 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id s9so1259209oib.11;
        Tue, 11 Jan 2022 16:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JIiBa3d/XU61HwFG/5Ee2z5JDQeSGFwdxSEibxBFHek=;
        b=AVKgkN1csZnBIKaPBfpyldh9JJao0/nxQC0hwm0jjvQ+WfSGp0BRw2J4Kg/gg1zMrK
         QIxvVsNLpmuUFDmtzIwA7m0WjeIcBj+gddq4Wlb4VTyx/dYa5kiYK5S1c+J8xvoryZ3A
         P5txgAcIYZY+KJ/Ecg5XWFeibXeiyEjXJ9ELVi9wfnB1QTF9cykgsqrAw6QVAIoi7CKE
         um78sTwxWGaPvlVMMExjK/HtdUdT2VfbN7+xVae+T4TZH3qEdimOQAW1xHbaUpH91/9S
         K2+jdNfE0Cp1lACQGq+ct8iwZw+1V1vVWbhDvmMzVgBIm4RsETbpe5Cn71/LyagHM4Wn
         wp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JIiBa3d/XU61HwFG/5Ee2z5JDQeSGFwdxSEibxBFHek=;
        b=taMOvULlZQUtq9WyUT6pHCYHoqygLE50477Bc9ca70CP21SCi8xVFGHRBK3SvvnX3B
         MtIlstoaQRcTGd89pAxUG1S2JPVHM//q9mTSUrzyoX+xHeMP35fUV6zXakM2K2ilvXJS
         sc9qj8F3TB+uVzsbOvfiyZyMS78iTkP7t6iJkq4mb4DVsazlgQpzKsfR6h8LTi0GqLYu
         Fuqp6DP+tiCLX0BzTGIO1CbT7XDM0HmKI+YG6IYyVThdFBAoKh4/E178isXVtNmbZAAh
         KI+l/tKx/sX43NQ4T+c4ftg2FmAVIwqJAnT8vJveKvjpLJDxqD13Sm42MLaosrmQvlRf
         Vpgw==
X-Gm-Message-State: AOAM530bFwMGe29ogEHM+sMuGJ2BdmNq3NhnluujcOD4dGdFAcfr4lM9
        tdEqCQwmTQdvYl8v9TdbzKXui0iIWFX7di7iMq4=
X-Google-Smtp-Source: ABdhPJzX8HJ9cLVm6PTV1jKCm43us6x0lj6KlVMiF3NvBpl1JmmNkMv3thGhTYty+4UUICPS3wUA7/oo8/sE0bZTqxY=
X-Received: by 2002:a05:6808:1a13:: with SMTP id bk19mr3551651oib.52.1641946181612;
 Tue, 11 Jan 2022 16:09:41 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info> <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
 <CACjc_5puGpg85XseEjKxnwE2R_XoH8EWvdwp4g2WKNBmW7pX+w@mail.gmail.com> <37d074c7-b264-acac-4bf6-65caa4dbab1a@leemhuis.info>
In-Reply-To: <37d074c7-b264-acac-4bf6-65caa4dbab1a@leemhuis.info>
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Date:   Tue, 11 Jan 2022 21:09:15 -0300
Message-ID: <CACjc_5o4n9CNXoER5Va6u0fQhuE9osnUSUwSbHPx0K1yiPUj8g@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Jan 10, 2022 at 4:02 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> Hi, this is your Linux kernel regression tracker speaking.
>
> On 20.12.21 21:41, Marcelo Roberto Jimenez wrote:
> > On Mon, Dec 20, 2021 at 11:57 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> >> On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
> >> <regressions@leemhuis.info> wrote:
> >>>
> >>> [TLDR: I'm adding this regression to regzbot, the Linux kernel
> >>> regression tracking bot; most text you find below is compiled from a few
> >>> templates paragraphs some of you might have seen already.]
> >>>
> >>> On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
> >>>> Some GPIO lines have stopped working after the patch
> >>>> commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
> >>>>
> >>>> And this has supposedly been fixed in the following patches
> >>>> commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> >>>> commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
> >>>
> >>> There seems to be a backstory here. Are there any entries and bug
> >>> trackers or earlier discussions everyone that looks into this should be
> >>> aware of?
> >>
> >> Agreed with Thorsten. I'd like to first try to determine what's wrong
> >> before reverting those, as they are correct in theory but maybe the
> >> implementation missed something.
> >>
> >> Have you tried tracing the execution on your platform in order to see
> >> what the driver is doing?
> >
> > Yes. The problem is that there is no list defined for the sysfs-gpio
> > interface. The driver will not perform pinctrl_gpio_request() and will
> > return zero (failure).
> >
> > I don't know if this is the case to add something to a global DTD or
> > to fix it in the sysfs-gpio code.
>
> Out of interest, has any progress been made on this front?
>
> BTW, there was a last-minute commit for 5.16 yesterday that referenced
> the culprit Marcelo specified:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=master&id=c8013355ead68dce152cf426686f8a5f80d88b40
>
> This was for a BCM283x and BCM2711 devices, so I assume it won't help.
> Wild guess (I don't know anything about this area of the kernel):
> Marcelo, do the dts files for your hardware maybe need a similar fix?

I have tried to add "gpio-ranges" to the gpio-controllers in
at91sam9x5.dtsi, but the system deadlocks, because in pinctrl-at91.c,
function at91_pinctrl_probe() we have:

/*
* We need all the GPIO drivers to probe FIRST, or we will not be able
* to obtain references to the struct gpio_chip * for them, and we
* need this to proceed.
*/
for (i = 0; i < gpio_banks; i++)
        if (gpio_chips[i])
                ngpio_chips_enabled++;

        if (ngpio_chips_enabled < info->nactive_banks) {
                dev_warn(&pdev->dev,
                      "All GPIO chips are not registered yet (%d/%d)\n",
                      ngpio_chips_enabled, info->nactive_banks);
               devm_kfree(&pdev->dev, info);
                return -EPROBE_DEFER;
        }

On the other hand, in gpiolib-of.c, function
of_gpiochip_add_pin_range() we have:

if (!pctldev)
        return -EPROBE_DEFER;

In other words, the pinctrl needs all the gpio-controllers, and the
gpio-controllers need the pinctrl. Each returns -EPROBE_DEFER and the
system deadlocks.

>
> Ciao, Thorsten
>
> P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
> on my table. I can only look briefly into most of them. Unfortunately
> therefore I sometimes will get things wrong or miss something important.
> I hope that's not the case here; if you think it is, don't hesitate to
> tell me about it in a public reply, that's in everyone's interest.
>
> BTW, I have no personal interest in this issue, which is tracked using
> regzbot, my Linux kernel regression tracking bot
> (https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
> this mail to get things rolling again and hence don't need to be CC on
> all further activities wrt to this regression.
>
> #regzbot poke
>

Regards,
Marcelo.
