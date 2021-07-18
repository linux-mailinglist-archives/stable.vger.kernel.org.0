Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A359D3CC932
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 14:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhGRM4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 08:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbhGRM4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 08:56:20 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CB3C061765
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 05:53:21 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id b13so23058735ybk.4
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 05:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ot3x9A+QM97mDVvcXkVBRBSDikDCHSFweeQqLAuQYRE=;
        b=i0Dgr+5XSFqFjaFWpj1aY0gLIBeJs6hYn9X1Uq2cXBST2RiP2cy3qAYr2Eiutu3Ths
         uP7aEee5iQDo7LxlqOh2sY3DeafUdN7hVcD2zNlk/Sicp4/TSbsVCQu9KpjUWBaIIrci
         MW89mob8mwp+wm1m6ov0RCRMYbeFzPNssFBekFIdzA23ywQovtH75EvbwdK0/GdJAKjl
         VdqxNn/67qOUu9Fgoq6mQjD2RAiMawYNgYhjspXWslw6DqZFkszCJkhG1UOwZI3T0sWY
         oyFMiVqaKDzLFi8fC0M8W8nnf3TiApMF4er97XTg6ZrSHtEw8N6anI5WMLzvW10fErFw
         RbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ot3x9A+QM97mDVvcXkVBRBSDikDCHSFweeQqLAuQYRE=;
        b=H2dario4c//8ddNphJnMvccv2ykMt87gcFbMUXRrae7+ejJayH/NVyVDCpDs46FQsS
         w2WooHh73onLe0Fk0eKLvNK948itpZ4jUesEuntvJ7D0v8um5Fxx8264t8xpJB4SZDUc
         p9GRh0GNhvcVsUZ2wu5yXxznDrGHQzFJMpcnCtMykxmO9jyQLRhFsN3QDZP65RsTO+mS
         8tYUixiX5QaZNNRhQZupZq7LWZhvUOSxpR0/vJKzP7MP1tFB3e02QwRUMIRulLDVfLiU
         V9N3XTbqZhrqNVwlEn6qNK0udCYK0dSwKWbK5DhP66aTuY/4Ie0LHGgfopQAGjd+3Dpl
         z6ig==
X-Gm-Message-State: AOAM531CosdiPpW/7/Alw9d2BJGiXgbdCyQEDh0fh4Qt//cvCyYFiCSp
        rxcy/B6jAq5AdlfZwnkVT1QB5JtJWF6TMdjScDnpwMOzADc=
X-Google-Smtp-Source: ABdhPJzCJzVpAuBh1eXxB04z9eJ2uKhVE74rrp28KmYF1XrEhVyuZZhjXsiKoxD0Oc+R5FpSpoQ+B1ciYWYT730Ysog=
X-Received: by 2002:a25:ad95:: with SMTP id z21mr25056929ybi.25.1626612800425;
 Sun, 18 Jul 2021 05:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210702133712.128611-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20210702133712.128611-1-linux@rasmusvillemoes.dk>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Sun, 18 Jul 2021 14:53:09 +0200
Message-ID: <CAMpxmJWrmVNb2jYs8e585kDnE+Xv8yNiFpABh3RwDUFg1KAWqA@mail.gmail.com>
Subject: Re: [PATCH] Revert "gpio: mpc8xxx: change the gpio interrupt flags."
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Song Hui <hui.song_1@nxp.com>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 2, 2021 at 3:37 PM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> This reverts commit 3d5bfbd9716318b1ca5c38488aa69f64d38a9aa5.
>
> When booting with threadirqs, it causes a splat
>
>   WARNING: CPU: 0 PID: 29 at kernel/irq/handle.c:159 __handle_irq_event_percpu+0x1ec/0x27c
>   irq 66 handler irq_default_primary_handler+0x0/0x1c enabled interrupts
>
> That splat later went away with commit 81e2073c175b ("genirq: Disable
> interrupts for force threaded handlers"), which got backported to
> -stable. However, when running an -rt kernel, the splat still
> exists. Moreover, quoting Thomas Gleixner [1]
>
>   But 3d5bfbd97163 ("gpio: mpc8xxx: change the gpio interrupt flags.")
>   has nothing to do with that:
>
>       "Delete the interrupt IRQF_NO_THREAD flags in order to gpio interrupts
>        can be threaded to allow high-priority processes to preempt."
>
>   This changelog is blatantly wrong. In mainline forced irq threads
>   have always been invoked with softirqs disabled, which obviously
>   makes them non-preemptible.
>
> So the patch didn't even do what its commit log said.
>
> [1] https://lore.kernel.org/lkml/871r8zey88.ffs@nanos.tec.linutronix.de/
>
> Cc: stable@vger.kernel.org # v5.9+
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---

Applied for fixes, thanks!

Bartosz
