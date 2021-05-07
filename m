Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1374376405
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 12:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhEGKmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 06:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhEGKmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 06:42:45 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4D1C061761
        for <stable@vger.kernel.org>; Fri,  7 May 2021 03:41:45 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x20so12135957lfu.6
        for <stable@vger.kernel.org>; Fri, 07 May 2021 03:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdHKVRisuyzHyiaj1K/2HRdEDtTSd1DdvI1cav5pE+g=;
        b=ZbqvDmUfqqlDuGUPGgc/CY7CANPuWafAM4rn48+iOueNg8ZXUrexDg+bgt9ytJRPi/
         GANQibnKcztAAXp8SgcjLRfUDMsSdwibRVdUlnqAh2vqBcxx0PRapos0LAoIoV+oMkEf
         m6E82G+dEyARaJB1cQgFc8glTtK7GPbWOYou2w/Zo90lLUsO5cqPfOE6dKB6OgTBl4MU
         LoyaB1qwR4ZQzQy4CQ8lWfp9QRUIqmSOWEAqsEExhwrbXWetvwUkYZywOfp7XtE1Y+HK
         RufU/rs5M4m1XmfYk1T7YmyuMNIcEsDCwxZXz1SljqmHiBC5/leGl2Nag6rLIf2UHp7g
         SKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdHKVRisuyzHyiaj1K/2HRdEDtTSd1DdvI1cav5pE+g=;
        b=XbvYxdIjxzPBBNNosDnj2omSu5smYlUZEzKGTTeZVsx4c1N5nduCdT4CGlyCpD16ng
         9eqeQUNqfD78/zxDuP5zSf4CE/IalB6hsi4XXutmK2rNWXIkt5LAZMlbXWAik7oX/+ar
         pc/G1x9qsyIzd3+A/y5+XdVbO++R5sOXDZzdYe+QFo2z1uYW+eVHchkkGVPTi8Kwh6yj
         tJLPcWRlBRXdJCxlmmnz8z8OCMd4ECRua2b+MtVBxJ6W0Y2lbLM0nx1UGmN9F1YcNITH
         6GXgti1v2KbTjG1p6YQ9UD9aPTNZJD6NiW+88cFK1Mz/J+DTfcqktgtXUysR2sszdEl6
         gfPA==
X-Gm-Message-State: AOAM533YP7m1blKG/2uRYU5nWDOlzdAiRoIeUK6Ar52YqCuA+eL2BpdO
        wpB3oaPr9q30PF93Ddp0DOywGiCVeMRI5etxB9sPJA==
X-Google-Smtp-Source: ABdhPJyOrtV0Xard5f15ovtgdAyjYWLZHx+54S5ITDFUkiZ6T+kUiegImwR2Luawc8EFtQfwhsCSxpGGWaHJOMGOZkQ=
X-Received: by 2002:ac2:544f:: with SMTP id d15mr5903313lfn.465.1620384103765;
 Fri, 07 May 2021 03:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210507103411.235206-1-jonathanh@nvidia.com>
In-Reply-To: <20210507103411.235206-1-jonathanh@nvidia.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 7 May 2021 12:41:33 +0200
Message-ID: <CACRpkdZZHh390cUxi+7cD6D9Gvfbh5KyxjSdHYUDoRXEMAZHOw@mail.gmail.com>
Subject: Re: [PATCH] gpio: tegra186: Don't set parent IRQ affinity
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jon,

On Fri, May 7, 2021 at 12:34 PM Jon Hunter <jonathanh@nvidia.com> wrote:

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

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
and sorry for the mess.

I don't know if it would be possible to take some inspiration from
the Qualcomm pin control driver:
drivers/pinctrl/qcom/pinctrl-msm.c

This has quite elaborate handling of this especially marking the
lines that can be used for sleeping and IIUC are reparented to
the PDC (power domain controller) that Qcom is using and
which I guess is similar to your PMC.

Yours,
Linus Walleij
