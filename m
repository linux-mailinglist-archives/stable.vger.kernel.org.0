Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4277B40BE39
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 05:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhIODac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 23:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhIODac (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 23:30:32 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87EBC061574;
        Tue, 14 Sep 2021 20:29:13 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id p29so3012227lfa.11;
        Tue, 14 Sep 2021 20:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xjPe0L3/nKX+cxkcdx6J3H8tI9DskxplI0rZEOeSfEI=;
        b=cItu3tzlIDDd7Y1hg8IJ917JedA08BLloCM/HgDzINxwBv20gae3/2mnvIen/26P63
         cGIFNnmZp7wbtI8qMriLggtFBUk2+Zvk77SM29S6z/AGp56JT2vMTaUDQ9uBaoUFHkfx
         F4gUfx3urNci+GoBWnAh6/iVx13KAt7XYF26lRCkn3yZIWrQeHps+Sw0gHckX9Bi1fhs
         Z7rFQXcr8CF6cMt815lk9ti8IZ5zQlWie6bvy8a2lcVrpQWvqkozqg6INqoNU5PgKYpY
         dvewlFLqvkOBlKDccqTsQ/0+lES85p0o0G6gQZTUwV5NnxkOhGEBfNCbgiaAVk5Gic0f
         UDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xjPe0L3/nKX+cxkcdx6J3H8tI9DskxplI0rZEOeSfEI=;
        b=uCuxaBhY5FCNXg1QRpl3WDoHNFdGMLNajXfvvUV63VJUvUbZZUoHwMRrYXxfGA1JHy
         f/ICQTpKli8QotWi8u4Mjgb8fUSbhhbhh4MSqsWfTfywGKLq7GGOA5Az07p3atFgw5Bt
         ImpAWjm/KRV6MbbEb/EafjRx10OhycdHJYJIOCog4hzlLsPHSF0HgyhWjrqX68hctAyO
         F2wioUVcTeCBmVL4ID0ZV1+McWbawIjy7XKnUUqNMTvktd/L00K4HPS7SxGIppUXc6Bk
         NTk626M5OyVEhO+56ujmxvWHoOner86dRymjvWdaeMIOw//2T56vr4IoTrpn2FtsbqPz
         2fQg==
X-Gm-Message-State: AOAM530qsqcuJFEzjR/4TYS4GYXN3ptWx1EysAALG5WmEXDu9qRkG1jy
        Tz1r06otRhJjQDkeA+wVRBTss9OSawanyg7ufcS5pwpq
X-Google-Smtp-Source: ABdhPJyXnY5xw1lixcYCeqp6mFmyw+KSA3GBfEYzlY7tBbUhvQE+FUVohBSaD8cqbi6xH8IjWGRq/6rRlVXN1Gc1sWs=
X-Received: by 2002:a19:c512:: with SMTP id w18mr14982680lfe.182.1631676552185;
 Tue, 14 Sep 2021 20:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200624195811.435857-1-maz@kernel.org> <20200624195811.435857-8-maz@kernel.org>
 <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com>
 <875yv8d91b.wl-maz@kernel.org> <CAMuHMdV+ydPaXbGf1_O0S-juaPWk1gwBUOK+GeLZukZeoqtMGQ@mail.gmail.com>
 <CANqRtoTqV8sOpL=hdxeZ03tqr+5oeMcfwz+9ERqXv+hze_6Fsw@mail.gmail.com>
 <874kaqdi2z.wl-maz@kernel.org> <CANqRtoTa8g2sw_DoD8+34HR0mcHc_tOWt+4R9KzDT2Eu3d7TTg@mail.gmail.com>
 <CAMuHMdX3Vf8Mxuz3=Aoi1hwMS7BtyYCH178QvVS-GAHDpeMvxg@mail.gmail.com>
In-Reply-To: <CAMuHMdX3Vf8Mxuz3=Aoi1hwMS7BtyYCH178QvVS-GAHDpeMvxg@mail.gmail.com>
From:   Magnus Damm <magnus.damm@gmail.com>
Date:   Wed, 15 Sep 2021 12:28:59 +0900
Message-ID: <CANqRtoQb1p1X+dOaQjh1atokDAR-oS4NB6m-UrHpO031SZ0hew@mail.gmail.com>
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>,
        Magnus Damm <damm+renesas@opensource.se>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Geert, everyone,

On Mon, Sep 13, 2021 at 5:05 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Magnus,
>
> On Sun, Sep 12, 2021 at 7:40 AM Magnus Damm <magnus.damm@gmail.com> wrote:
> > On Sun, Sep 12, 2021 at 4:32 AM Marc Zyngier <maz@kernel.org> wrote:
> > > On Sat, 11 Sep 2021 03:49:20 +0100,
> > > Magnus Damm <magnus.damm@gmail.com> wrote:
> > > > On Fri, Sep 10, 2021 at 10:19 PM Geert Uytterhoeven
> > > > <geert@linux-m68k.org> wrote:
> > > > > On Fri, Sep 10, 2021 at 12:23 PM Marc Zyngier <maz@kernel.org> wrote:
> > > > > > On Thu, 09 Sep 2021 16:22:01 +0100,
> > > > > > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > >     GIC: enabling workaround for broken byte access
> > > >
> > > > Indeed, byte access is unsupported according to the EMEV2 documentation.
> > > >
> > > > The EMEV2 documentation R19UH0036EJ0600 Chapter 7 Interrupt Control on
> > > > page 97 says:
> > > > "Interrupt registers can be accessed via the APB bus, in 32-bit units"
> > > > "For details about register functions, see ARM Generic Interrupt
> > > > Controller Architecture Specification Architecture version 1.0"
> > > > The file  "R19UH0036EJ0600_1Chip.pdf" is the 6th edition version
> > > > published in 2010 and is not marked as confidential.
> > >
> > > This is as bad as it gets. Do you know if any other Renesas platform
> > > is affected by the same issue?
> >
> > Next time we have a beer together I would be happy to show you some
> > legacy interrupt controller code. =)
> >
> > EMEV2 and the Emma Mobile product line came from the NEC Electronics
> > side that got merged into Renesas Electronics in 2010. Historically
> > NEC Electronics mainly used MIPS I've been told, and the Emma Mobile
> > SoCs were one of the earlier Cortex-A9 adopters. That might have
> > something to do with the rather loose interpretation of the spec.
>
> Indeed.  I used to work on products using EMMA1 and EMMA2, and they
> were MIPS-based (vr4120A for EMMA2, IIRC).  Later variants (EMMA2H
> and EMMA3?) did include a small ARM core for standby control.

Thanks for sharing some more background!

> > Renesas SoCs from a similar era:
> > AP4 (sh7372) AP4EVB (Cortex-A8 + INTCA/INTCS)
>
> This is no longer supported upstream (and not affected, as no GIC).

Right. I might mix it up with the AP4.5 chip that I used for SMP
prototyping back then. It had 4 x CA9 and obviously a GIC.

> > R-Mobile A1 (r8a7740) Armadillo-800-EVA (Cortex-A9 + INTCA/INTCS)
>
> R-Mobile A1 has GIC (PL390), too, and is not affected.
>
> > R-Car M1A (r8a7778) Bock-W (Cortex-A9 + GIC)
> > R-Car H1 (r8a7779) Marzen (4 x Cortex-A9 + GIC)
> > Emma Mobile EMEV2 KZM9D (2 x Cortex-A9 + GIC)
> > SH-Mobile AG5 (sh73a0) KZM9G (2 x Cortex-A9 + GIC)
>
> All of these (except for EMEV2) are fine, too.

Thanks for checking!

Cheers,

/ magnus
