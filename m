Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CBA1F935C
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 11:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgFOJ0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 05:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbgFOJ0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 05:26:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4ABC05BD43;
        Mon, 15 Jun 2020 02:26:49 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so16614224ejd.13;
        Mon, 15 Jun 2020 02:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRB46svp3cKLTLHsZXPNPHUSuyqFTSAjZCb+UaO0soU=;
        b=A/GNw0tzhhu1S73BaJJ9tSD/edwR2eWXIHoaGyKD9n9qXCpz36cRpzAYxoUKS+pWLy
         mUjx9ZLfMeQf+C9QpYfUspvNFvAkbmjuf0MQUk9opVbvqiatri6or/6KJKXdGfToxfvk
         r7UPkAXMT3lYYOUrmIL9uZr7oQBi3dxU2Dyn3bgsRjw5hu+36Wu4BfxE9VNRJQIhRkWG
         MwCzmUtADezv7K4KdGiq3dqUayt6+5ote2iYlDnO+AkDDfaQ8YC+3G+EWMS6+XfeTqUc
         WDE7O7xsnfLk96NpIMfQuW8PnnihlZ/dyFC3McnXQVxE86rt/dn300eF1zVLJrsOe/y1
         wdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRB46svp3cKLTLHsZXPNPHUSuyqFTSAjZCb+UaO0soU=;
        b=pvk5+ZZ/7wa8Cq5vmna+AjjwZuBb8KvX5TDqawNLm8x3rjsOpiBQYB+a8zxiXk7Fe3
         EIAGO9Nu2bW/aUPL0LHv8aQ49PrVCucCbPEGnbJDcYeiWTSoSgWPLD0ZZ3bQtryJ7Qd7
         N7HklwE7TpS1k9gh17J1uUPZd4uCfCE/9oY+WfM2IEW37WpSu5Kvsq1Gsdmrw6ic44MC
         G7jkMq5kUpA+qlKhXghqaHiyFn+weNVPFP2Ok2qzB4ARZz+wsgZPWtZmB11qMbvnQ6uo
         Tgn3EMANNOWfk9vWO7fo32OKXlMzRJ7f30vX5U7GZAuVfup1ENPSxIthUV7Keu6jgaJn
         n4+A==
X-Gm-Message-State: AOAM531hHtCdp56kB2Xum0ti/k3MTs9ahBu6qDkid+hC3x4xLEBOqM4R
        wOYjo7bvbn9qmH1a823/a95CgUXb9rPf2rupk58=
X-Google-Smtp-Source: ABdhPJz1zDIjLAD7bTpcOHlGZppWwiRhHMaUlb7JNcmoOEYuKKt+W0cF3kHt77LjyfAkyIdB0xsSGpaWjD5F00uohKA=
X-Received: by 2002:a17:906:1149:: with SMTP id i9mr25938500eja.100.1592213208629;
 Mon, 15 Jun 2020 02:26:48 -0700 (PDT)
MIME-Version: 1.0
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org> <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
 <20200614111829.GA9694@kozik-lap> <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
 <CA+h21hoVjJkGyxTEnh2Bixjoqxb12k-KK37U4Xy-27ntZz8aTw@mail.gmail.com>
 <20200614151247.GA2494@kozik-lap> <CA+h21hotvdXUgUzMaVfb_6EM-9kcoHvvnT4r+EHx7m6z4R0pxg@mail.gmail.com>
 <20200615070858.GA20941@kozik-lap>
In-Reply-To: <20200615070858.GA20941@kozik-lap>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 12:26:37 +0300
Message-ID: <CA+h21hoLq59R2p=+f4jZFmd5OSQ3590FeRB+oHBKLKDHq5knRg@mail.gmail.com>
Subject: Re: [PATCH 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 at 10:09, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Sun, Jun 14, 2020 at 06:34:33PM +0300, Vladimir Oltean wrote:
> > On Sun, 14 Jun 2020 at 18:12, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> > > On Sun, Jun 14, 2020 at 04:43:28PM +0300, Vladimir Oltean wrote:
> > > > On Sun, 14 Jun 2020 at 16:39, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > >
> > > > > On Sun, 14 Jun 2020 at 14:18, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > > >
> > > > > > On Sun, Jun 14, 2020 at 02:14:15PM +0300, Vladimir Oltean wrote:
> > > > > > > On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > > > > >
> > > > > > > > If interrupt fires early, the dspi_interrupt() could complete
> > > > > > > > (dspi->xfer_done) before its initialization happens.
> > > > > > > >
> > > > > > > > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> > > >
> > > > Also please note that this patch merely replaced an
> > > > init_waitqueue_head with init_completion. But the "bug" (if we can
> > > > call it that) originates from even before.
> > >
> > > Yeah, I know, the Fixes is not accurate. Backport to earlier kernels
> > > would be manual so I am not sure if accurate Fixes matter.
> > >
> > > >
> > > > > > > > Cc: <stable@vger.kernel.org>
> > > > > > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > > > > > ---
> > > > > > >
> > > > > > > Why would an interrupt fire before spi_register_controller, therefore
> > > > > > > before dspi_transfer_one_message could get called?
> > > > > > > Is this master or slave mode?
> > > > > >
> > > > > > I guess practically it won't fire.  It's more of a matter of logical
> > > > > > order and:
> > > > > > 1. Someone might fix the CONFIG_DEBUG_SHIRQ_FIXME one day,
> > > > >
> > > > > And what if CONFIG_DEBUG_SHIRQ_FIXME gets fixed? I uncommented it, and
> > > > > still no issues. dspi_interrupt checks the status bit of the hw, sees
> > > > > there's nothing to do, and returns IRQ_NONE.
> > >
> > > Indeed, still the logical way of initializing is to do it before any
> > > possible use.
> > >
> > > > >
> > > > > > 2. The hardware is actually initialized before and someone could attach
> > > > > >    to SPI bus some weird device.
> > > > > >
> > > > >
> > > > > Some weird device that does what?
> > >
> > > You never know what people will connect to a SoM :).
> > >
> > > Wolfram made actually much better point - bootloaders are known to
> > > initialize some things and leaving them in whatever state, assuming that
> > > Linux kernel will redo any initialization properly.
> > >
> > > Best regards,
> > > Krzysztof
> > >
> >
> > I don't buy the argument.
> > So ok, maybe some broken bootloader leaves a SPI_SR interrupt pending
> > (do you have any example of that?). But the driver clears interrupts
> > by writing SPI_SR_CLEAR in dspi_init (called _before_ requesting the
> > IRQ). It clears 10 bits from the status register. There are 2 points
> > to be made here:
> > - The dspi_interrupt only handles data availability interrupt
> > (SPI_SR_EOQF | SPI_SR_CMDTCF). Only then does it matter whether the
> > completion was already initialized or not. But these interrupts _are_
> > cleared. But assume they weren't. What would Linux even do with a SPI
> > transfer initiated by the previously running software environment? Why
> > would it be a smart thing to handle that data in the first place?
> > - The 10 bits from the status register are all the bits that can be
> > cleared. The rest of the register, if you look at it, contains the TX
> > FIFO Counter, the Transmit Next Pointer, the RX FIFO Counter, and the
> > Pop Next Pointer.
> > So, unless there's something I'm missing, I don't actually see how
> > this broken bootloader can do any harm to us.
>
> Let's rephrase it: you think therefore that completion should be
> initialzed *after* requesting shared interrupts? You think that exactly
> that order shall be used in the source code?
>
> Best regards,
> Krzysztof
>
>

I think that completion should be initialized before it is used, just
like any other variable. So far you have not proven any code path
through which it can be used uninitialized, therefore I don't see why
this should be accepted as a bug fix. Cleanup, cosmetic refactoring,
design patterns, whatever, sure.

Thanks,
-Vladimir
