Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB81F9B30
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbgFOO7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730629AbgFOO7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:59:46 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DD0C061A0E;
        Mon, 15 Jun 2020 07:59:45 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id k11so17776302ejr.9;
        Mon, 15 Jun 2020 07:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QoZq+ReLXchiw7LYSzZo84zmyZwrWU3yCXnArJEC3ik=;
        b=TWHvBItRY4XgOfbULNlCfXBRexrhuYmPJ4YWP3qSUFi88BprBD7quxMVD3JbCjQout
         nijewoKytD63bEA+oTEb5yCfjl70v4c1tqeRexUVXtJRrKLwitpOpIoHTf1RlsJvyH4v
         OQRAesyP5JD/TPmljx8FEGic2mR/MgbP1iaEOFy+MGmMU6bKvEfTSun7+x6+T7haj9/h
         mFdwQueeOixyGdG350LqbDvyf9sQI/+IMcn2VUfDszMVySRkEq4qjKk5lETVpAfTZdRU
         DVZXCoUJwZSZGp1Fmgof0RUHiBEWmOkskrWNAx5XenPy26U7VFvA7mgloLXpOLE+Ef4W
         NRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QoZq+ReLXchiw7LYSzZo84zmyZwrWU3yCXnArJEC3ik=;
        b=PtAKuxmeQCzBD60/+A9ORjjNjwc9lRZ5qeQIyA6KpZlxymSjCvBl4FOAmkW4UdC+D7
         Fe0k02JNrU+Y8s9EmkSAo6XySqMk/0caYdHHRSPTfhrROpdoLlwM3pbkUrm8kJUu+yJq
         558aZ+F3hXGOokYjcs+805DWvfYUGDg3X03XnIMAxMiecKCZPie3uLZD8S5cbCa431c/
         +mwvt8rydmOLbBBH4Ks6On2n5D9hR1gIA/jD9a1g0OfuEJRbDgvYIzCgz5gQpYzoofdn
         kZ06ON+YSoqgVDj6japSVR8GUTqAiyuIS7KdIaoc9Tz8p5KBoBUdm8pZKwMJRQjLUCEc
         0gxA==
X-Gm-Message-State: AOAM532necJ4FCKh12pHQcWcb2Tf6hYm8rIulVw93J1V0oXnn1Yu4cEL
        mcwqiXSUubQvwKvN6ClnvQVqzacinL3o1/2eAhI=
X-Google-Smtp-Source: ABdhPJypISDwXgnNOtwGZREX6IZdu7H6KoLGxzFM5qMiLEcP1jxFqCwrVFfAwV3YIFjT81CN+/qsQyICu4e3vzlikJE=
X-Received: by 2002:a17:906:198d:: with SMTP id g13mr13284509ejd.281.1592233184564;
 Mon, 15 Jun 2020 07:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de> <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131006.GR4447@sirena.org.uk> <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
 <20200615134119.GB3321@kozik-lap> <CA+h21hp29i=AdZB_fBQ4mwAh=3Oovopwz3ruzzJqiKpRpZYzhg@mail.gmail.com>
 <20200615145711.GA24927@kozik-lap>
In-Reply-To: <20200615145711.GA24927@kozik-lap>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 17:59:33 +0300
Message-ID: <CA+h21hoQtsbLCZ9UNGYbuf5JN8WVvjSiVbo7qTnTNYQNswt=TA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 at 17:57, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Jun 15, 2020 at 05:23:28PM +0300, Vladimir Oltean wrote:
> > On Mon, 15 Jun 2020 at 16:41, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> > > On Mon, Jun 15, 2020 at 04:12:28PM +0300, Vladimir Oltean wrote:
> > > > On Mon, 15 Jun 2020 at 16:10, Mark Brown <broonie@kernel.org> wrote:
> > > >
> > > > >
> > > > > It's a bit unusual to need to actually free the IRQ over suspend -
> > > > > what's driving that requirement here?
> > > >
> > > > clk_disable_unprepare(dspi->clk); is driving the requirement - same as
> > > > in dspi_remove case, the module will fault when its registers are
> > > > accessed without a clock.
> > >
> > > In few cases when I have shared interrupt in different drivers, they
> > > were just disabling it during suspend. Why it has to be freed?
> > >
> > > Best regards,
> > > Krzysztof
> > >
> >
> > Not saying it _has_ to be freed, just to be prevented from running
> > concurrently with us disabling the clock.
> > But if we can get away in dspi_suspend with just disable_irq, can't we
> > also get away in dspi_remove with just devm_free_irq?
>
> One reason why they have to be different could be following scenario:
> 1. Device could be unbound any time and disabling IRQ in remove() would
>    effectively disable the IRQ also for other devices using this shared
>    line. First disable_irq() really disables it, the latter just
>    increases the counter.
> 2. However during system suspend, it is expected that all drivers in
>    their suspend (and later resume) callbacks will do the same - disable
>    the shared IRQ line. And finally the system disables interrupts
>    globally so the line will be balanced.
>
> Freeing IRQ solves the case #1 without causing any imbalance between
> enables/disables or requests/frees.  Disabling IRQ solves the #2, also
> without any imbalance.
>
> Best regards,
> Krzysztof
>
>
>

So the answer to my question is 'yes', right?
