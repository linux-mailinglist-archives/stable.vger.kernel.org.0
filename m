Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D12F37BC23
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 13:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhELL7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 07:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhELL7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 07:59:02 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096EBC06175F
        for <stable@vger.kernel.org>; Wed, 12 May 2021 04:57:55 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 82so30365360yby.7
        for <stable@vger.kernel.org>; Wed, 12 May 2021 04:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JTFIrIiIiCWw2DizIDGGX4KiOJsOkJ0nyEyBMnURzyw=;
        b=tM5hpmiLnRMbFfnUBUzTD1fYfzVll4i5LqmZF8eVMSokXIJIQ0i3AicWS0KdrPEvlP
         +a3Q5XMgtBaOlGzm8eT0m2pjaifHdyQG8SQAbCRgapbJuzqaRIuAjtdDtP1tGJCZuF9b
         8olRh3E+OW5bvEHn7KAms4K49xV7UPR5Wpok7GJWTPOcWKgo0rjMmKNk9+JgQzSJbWpg
         4E+HEbixubIa5fzsO93E84cn1Li1UaE2IKKdsDQlKehaRpvDXccBJ4K69CxcxU+/mgai
         BOZEUB+E3fF7x0RnA2dPtJbHK9AJ89El+FcZqEqVGAuks3wfPorDz/Pj1xHD7ZUCCvuj
         e4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JTFIrIiIiCWw2DizIDGGX4KiOJsOkJ0nyEyBMnURzyw=;
        b=rigT9GQByK/CfMa+b+K6jnHF2zOfJAkMWOiPFohzrDSSpRiwYRextOn0x4RUxbRU+R
         C3wvWW1YWOiGk/iPbE0edql25ijfoL5Ks9Mf7Rf+dPLEvxPfGWuts23KudZn87oddzM/
         W4g8wy5217SLUcu/mcr7Nc5J2NKO4MFCVqi9nxTtRcQOiRh2iNuVkkCykRmWkXTPjJpT
         C9pw2gyH0/lXgJsEmKXqk+0dwaeYGVhv5vDlxSb730fDUNUuK6At5MwNt2kY7DXzUaK9
         kHCc97A+ooLHbbLoe5XEW51GGmqu3IXPTYsK5zTJuwauHpZsLNQhFeV9NeLaYk7pRt6N
         YkDQ==
X-Gm-Message-State: AOAM533ggjEfFfgDJoI8qasVVTqKkYBmDXbNAr/c1kJfyth/285NUaA4
        dsb2z/hETmkq1wNTC7vLxidV7lNvLOixwUYnk0pfaQ==
X-Google-Smtp-Source: ABdhPJy6XsMANIlpd9Kpw8oKwewls/90i39QKk0iIhIIA6xdY7fh3xF9LGttF39j5vgqXJEFltnKfF9g9wYGz8TRSQo=
X-Received: by 2002:a25:cb96:: with SMTP id b144mr41828468ybg.312.1620820674262;
 Wed, 12 May 2021 04:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210507103411.235206-1-jonathanh@nvidia.com>
In-Reply-To: <20210507103411.235206-1-jonathanh@nvidia.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Wed, 12 May 2021 13:57:43 +0200
Message-ID: <CAMpxmJVa-wfRSx8CC4ac705aHLR=fovX_E3QkOUSNoUwpc-_9A@mail.gmail.com>
Subject: Re: [PATCH] gpio: tegra186: Don't set parent IRQ affinity
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 7, 2021 at 12:34 PM Jon Hunter <jonathanh@nvidia.com> wrote:
>
> When hotplugging CPUs on Tegra186 and Tegra194 errors such as the
> following are seen ...
>
>  IRQ63: set affinity failed(-22).
>  IRQ65: set affinity failed(-22).
>  IRQ66: set affinity failed(-22).
>  IRQ67: set affinity failed(-22).
>
> Looking at the /proc/interrupts the above are all interrupts associated
> with GPIOs. The reason why these error messages occur is because there
> is no 'parent_data' associated with any of the GPIO interrupts and so
> tegra186_irq_set_affinity() simply returns -EINVAL.
>
> To understand why there is no 'parent_data' it is first necessary to
> understand that in addition to the GPIO interrupts being routed to the
> interrupt controller (GIC), the interrupts for some GPIOs are also
> routed to the Tegra Power Management Controller (PMC) to wake up the
> system from low power states. In order to configure GPIO events as
> wake events in the PMC, the PMC is configured as IRQ parent domain
> for the GPIO IRQ domain. Originally the GIC was the IRQ parent domain
> of the PMC and although this was working, this started causing issues
> once commit 64a267e9a41c ("irqchip/gic: Configure SGIs as standard
> interrupts") was added, because technically, the GIC is not a parent
> of the PMC. Commit c351ab7bf2a5 ("soc/tegra: pmc: Don't create fake
> interrupt hierarchy levels") fixed this by severing the IRQ domain
> hierarchy for the Tegra GPIOs and hence, there may be no IRQ parent
> domain for the GPIOs.
>
> The GPIO controllers on Tegra186 and Tegra194 have either one or six
> interrupt lines to the interrupt controller. For GPIO controllers with
> six interrupts, the mapping of the GPIO interrupt to the controller
> interrupt is configurable within the GPIO controller. Currently a
> default mapping is used, however, it could be possible to use the
> set affinity callback for the Tegra186 GPIO driver to do something a
> bit more interesting. Currently, because interrupts for all GPIOs are
> have the same mapping and any attempts to configure the affinity for
> a given GPIO can conflict with another that shares the same IRQ, for
> now it is simpler to just remove set affinity support and this avoids
> the above warnings being seen.
>
> Cc: <stable@vger.kernel.org>
> Fixes: c4e1f7d92cd6 ("gpio: tegra186: Set affinity callback to parent")
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  drivers/gpio/gpio-tegra186.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/drivers/gpio/gpio-tegra186.c b/drivers/gpio/gpio-tegra186.c
> index 1bd9e44df718..05974b760796 100644
> --- a/drivers/gpio/gpio-tegra186.c
> +++ b/drivers/gpio/gpio-tegra186.c
> @@ -444,16 +444,6 @@ static int tegra186_irq_set_wake(struct irq_data *data, unsigned int on)
>         return 0;
>  }
>
> -static int tegra186_irq_set_affinity(struct irq_data *data,
> -                                    const struct cpumask *dest,
> -                                    bool force)
> -{
> -       if (data->parent_data)
> -               return irq_chip_set_affinity_parent(data, dest, force);
> -
> -       return -EINVAL;
> -}
> -
>  static void tegra186_gpio_irq(struct irq_desc *desc)
>  {
>         struct tegra_gpio *gpio = irq_desc_get_handler_data(desc);
> @@ -700,7 +690,6 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
>         gpio->intc.irq_unmask = tegra186_irq_unmask;
>         gpio->intc.irq_set_type = tegra186_irq_set_type;
>         gpio->intc.irq_set_wake = tegra186_irq_set_wake;
> -       gpio->intc.irq_set_affinity = tegra186_irq_set_affinity;
>
>         irq = &gpio->gpio.irq;
>         irq->chip = &gpio->intc;
> --
> 2.17.1
>

Thanks for the very descriptive commit message!

Patch applied.

Bart
