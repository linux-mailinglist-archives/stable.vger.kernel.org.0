Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54594B36A0
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 17:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiBLQzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 11:55:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiBLQzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 11:55:05 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094C62409F
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 08:55:01 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id e140so14714997ybh.9
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 08:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=biysQ3IsY2w+NMb+t1WSQWW4AmDXHDFl1wRiCvR4z4A=;
        b=Mz/hHNUOtjKmsHGh20Qo0guG/Qg2wiAB4AvUgN+QYwQlsg/MI+Gk1tdkNMVhkz7FvF
         uLUlG6rpT/QCxyF24eGIFwno1CC0xAft6LNiQuINyo4fUf71zRpz5OZMNwxjg+C3kWbl
         kBmd9gngoENaGRXCIMowhfp3a0hSjrETIBQAcr/yZidmjucqfrUExAjhb1g/bRr8k4H2
         2NeuWZrgGZipVP0AVBBafdQ+G0lKITdtiyw1in/MoS0XBe1dxm7NavR4O8t5YNxfka4G
         vjGjPYHYgCemAYBBS/Q6VUSUVq2b0FTVHhcwjcctT0TNO7x3G3bMtzbCQaB6swrbAP2Z
         Uuyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=biysQ3IsY2w+NMb+t1WSQWW4AmDXHDFl1wRiCvR4z4A=;
        b=OE/R+ogrdJ/iRr7nS9wNTXa45O466GYPiCfxBeeXC6hNONqxfmkrWYebZBtggGbCmE
         pIH4J3I7mssqhDu8lNMI/ACTNJ1xqAoRIRBWtXVk7aiziJBu4nEqa4b8tv0KAWby9xxC
         raSaa1l2P3nqeshp7Rhkg3sOY4a/UkhCE5P5hbLpimSJHdink/PFrEH7QZ/JpoRYaoMh
         lqslxz0sJ+cEiBy0TNjK3cdg8sV9nkuFVpYwCCXnK12uTUgBhhZmPeP2L3qZwq5m0XbM
         AowqyVwdHJQdfG8JNlLYw6plzGR7SiImXHTA180JXv1wUUcrdj7f9kz4eFO2yNphHM3p
         a2vg==
X-Gm-Message-State: AOAM531G6PbuG6gOnU8hFg7XeiF5Ja3eoSqaezb5xpUXmCHvBjHy6RKX
        567wgFVAcIZ0HSno8vcRrU4CXsp+O7OqyukS/FTjDw==
X-Google-Smtp-Source: ABdhPJxY7wL1B0Tp9SS789YZZRkRDCVX/nCvjhJ9T1/d7umwF8iHCoCHKWI/kl7Ai8sZPm2pZ8xwp5LVQvKKElkeXTw=
X-Received: by 2002:a5b:f4b:: with SMTP id y11mr5781546ybr.634.1644684900080;
 Sat, 12 Feb 2022 08:55:00 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com> <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com>
In-Reply-To: <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 12 Feb 2022 17:54:48 +0100
Message-ID: <CACRpkda=0=Hcyyote+AfwoLKPGak7RV6VFt6b0fMVWBe8veTwA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 11, 2022 at 11:36 PM Marcelo Roberto Jimenez
<marcelo.jimenez@gmail.com> wrote:

> > Which devicetree or boardfile in the upstream Linux kernel is this system
> > using?
>
> arch/arm/boot/dts/at91-ariettag25.dts

So this system was added in 2015 which is the same year that
we marked the GPIO sysfs ABI obsolete:

commit fe95046e960b4b76e73dc1486955d93f47276134
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Thu Oct 22 09:58:34 2015 +0200

    gpio: ABI: mark the sysfs ABI as obsolete

Why is this system which was clearly developed while we deprecated
the sysfs ABI so dependent on it?

I am curious about the usecases and how deeply you have built
yourselves into this.

> In any case, the upstream file should be enough to test the issue reported here.

The thing is that upstream isn't super happy that you have been
making yourselves dependent on features that we are actively
discouraging and then demanding that we support these features.

Anyway, what is wrong with using the GPIO character device and libgpiod
on this system? What kind of userspace are you creating that
absolutely requires that you use sysfs?

I hope not one of these?
https://docs.kernel.org/driver-api/gpio/drivers-on-gpio.html

Here is some info about what we have been doing with the GPIO
character device:

https://docs.kernel.org/driver-api/gpio/using-gpio.html
https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/tree/

Here is Bartosz presenting it:
https://www.youtube.com/watch?v=BK6gOLVRKuU

Since I patched the kernel such that you cannot activate the sysfs
ABI without also activating the character device I *know* that you
have it on your system.

Yours,
Linus Walleij
