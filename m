Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993E7407BF9
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 07:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhILFmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 01:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhILFmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 01:42:05 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1709C061574;
        Sat, 11 Sep 2021 22:40:51 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id l11so13527421lfe.1;
        Sat, 11 Sep 2021 22:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vWXHoLtwCXxou79TaKe+VEmeu5Pja53twjNYiYPX82U=;
        b=nHP4t3ral8G2+UcD5kddjBNGdcd5PMlysXgfopVEpAW1/hVOWgFayNgLErYFIrJSW2
         V7ybemKdQbeKW+P08buAjygB4VT3VhcvFavav7kxBQfna0/4sKJKXXphEYuHBE2hnDQx
         IghQEw/fpZU2OisaBnUKfRJdwbXBzrF0bhSqZk6/X9Lw8xzzSoNibzUbsXWpR3w3vEVA
         pDSCVvTBtf1kmVZvOVdjfK+61sMh5NYMZzirT0DthO3hu7bSGQ/ahTGIZM/M82RQJMS0
         4qmh1/L0IDhk3hewx4PZahqoDpLxUUZQeUhZjbx3CHkBnvZWx4Ldu0bFoku1OZQs7XhL
         FLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vWXHoLtwCXxou79TaKe+VEmeu5Pja53twjNYiYPX82U=;
        b=YU1y31Isj+4i55wvN3Ty9g18fVw4/RwQuzS1fQGug+5rj54P6BRo0MN4ovCZOyBTqy
         kW5upsuKndMdyGLn3clnrWEtf61LHo8QZa+Gub4aDx1kZdPnzl9eoA4ZhDf9W1bRkh+A
         dXK0yW49YjR5va2bFgN13wg8CiIvugmDfDIqmDEeQPYzmoecZQNY50q208N5yuoJErP/
         HBIEWGDxPrhOYhaegpLAssVDaIPq2zq61GS3TF9/YmuOR8WGR7VyEt+g+bYECjgWpIdg
         lqmuTe3YHBIWFvYBkuG7ybDLv6h28E8UuWJgxU383IA9hnd8p6YzciybGHKkB5UdzLO+
         Ccyw==
X-Gm-Message-State: AOAM530cCXYIj2ugNzxOZ0B1rYLQxdVgNywHWoh1p2aaRoC5xDpVQWB3
        I5yHKwaHwm3J5PmgxpxFimIL1lfua9++7RjSm/Q=
X-Google-Smtp-Source: ABdhPJzJM9Uy+IoDBYFCbz4DDsBM8QkqOqql4QoMMmqoAzjGptYJy1lSBewasP2a5kjmy9liEW9el7e1eEGQJsZyZlE=
X-Received: by 2002:ac2:5e9c:: with SMTP id b28mr4363426lfq.405.1631425249222;
 Sat, 11 Sep 2021 22:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200624195811.435857-1-maz@kernel.org> <20200624195811.435857-8-maz@kernel.org>
 <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com>
 <875yv8d91b.wl-maz@kernel.org> <CAMuHMdV+ydPaXbGf1_O0S-juaPWk1gwBUOK+GeLZukZeoqtMGQ@mail.gmail.com>
 <CANqRtoTqV8sOpL=hdxeZ03tqr+5oeMcfwz+9ERqXv+hze_6Fsw@mail.gmail.com> <874kaqdi2z.wl-maz@kernel.org>
In-Reply-To: <874kaqdi2z.wl-maz@kernel.org>
From:   Magnus Damm <magnus.damm@gmail.com>
Date:   Sun, 12 Sep 2021 14:40:36 +0900
Message-ID: <CANqRtoTa8g2sw_DoD8+34HR0mcHc_tOWt+4R9KzDT2Eu3d7TTg@mail.gmail.com>
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
To:     Marc Zyngier <maz@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
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

Hi Marc,

On Sun, Sep 12, 2021 at 4:32 AM Marc Zyngier <maz@kernel.org> wrote:
> On Sat, 11 Sep 2021 03:49:20 +0100,
> Magnus Damm <magnus.damm@gmail.com> wrote:
> > On Fri, Sep 10, 2021 at 10:19 PM Geert Uytterhoeven
> > <geert@linux-m68k.org> wrote:
> > > On Fri, Sep 10, 2021 at 12:23 PM Marc Zyngier <maz@kernel.org> wrote:
> > > > On Thu, 09 Sep 2021 16:22:01 +0100,
> > > > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > >     GIC: enabling workaround for broken byte access
> >
> > Indeed, byte access is unsupported according to the EMEV2 documentation.
> >
> > The EMEV2 documentation R19UH0036EJ0600 Chapter 7 Interrupt Control on
> > page 97 says:
> > "Interrupt registers can be accessed via the APB bus, in 32-bit units"
> > "For details about register functions, see ARM Generic Interrupt
> > Controller Architecture Specification Architecture version 1.0"
> > The file  "R19UH0036EJ0600_1Chip.pdf" is the 6th edition version
> > published in 2010 and is not marked as confidential.
>
> This is as bad as it gets. Do you know if any other Renesas platform
> is affected by the same issue?

Next time we have a beer together I would be happy to show you some
legacy interrupt controller code. =)

EMEV2 and the Emma Mobile product line came from the NEC Electronics
side that got merged into Renesas Electronics in 2010. Historically
NEC Electronics mainly used MIPS I've been told, and the Emma Mobile
SoCs were one of the earlier Cortex-A9 adopters. That might have
something to do with the rather loose interpretation of the spec.

Renesas SoCs from a similar era:
AP4 (sh7372) AP4EVB (Cortex-A8 + INTCA/INTCS)
R-Mobile A1 (r8a7740) Armadillo-800-EVA (Cortex-A9 + INTCA/INTCS)
R-Car M1A (r8a7778) Bock-W (Cortex-A9 + GIC)
R-Car H1 (r8a7779) Marzen (4 x Cortex-A9 + GIC)
Emma Mobile EMEV2 KZM9D (2 x Cortex-A9 + GIC)
SH-Mobile AG5 (sh73a0) KZM9G (2 x Cortex-A9 + GIC)

The INTCA/INTCS interrupt controllers came from the SH architecture
but were phased out once SMP became the norm. I've got the majority of
the boards above hooked up for remote access if anyone wants to test
something.

> > From my basic research, "ARM Generic Interrupt Controller Architecture
> > Specification Architecture version 1.0" is documented in ARM IHI 0048A
> > from 2008 (Non-Confidential) which contains:
> > "All GIC registers are 32-bit wide." and "All registers support 32-bit
> > word access..."
> > "In addition, the following registers support byte accesses:"
> > "ICDIPR"
>
> Renamed to GICD_IPRIORITYRn in IHI0048B.
>
> > "ICDIPTR"
>
> Renamed to GICD_ITARGETRn in IHI0048B.
>
> See IHI0048B_b ("B.1 Alternative register names" and specifically
> table B-1) for the translation table between GICv1 and GICv2 names.

Thanks.

> > So the GICv1 documentation says byte access is partially supported
> > however EMEV2 documentation says 32-bit access is required.
>
> Which is definitely an integration bug. Both set of registers *must*
> support byte accesses. This isn't optional and left to the
> appreciation of the integrator. This breaks the programming model
> badly, and prevents standard software from running unmodified.

This reminds me that on SH we used to fix up I/O access alignment for
certain on-chip devices by trapping. The fast path worked well and the
special case worked but was slow.

> One of the few things the GIC architecture got right is the absence of
> locking requirements, as all the registers can be accessed
> concurrently by multiple CPUs as long as they operate on distinct
> interrupts. This is why the enable and pending registers have both set
> and clear accessors, that the priority and target registers are byte
> accessible, and that everything else happens in CPU-private registers
> (the CPU interface).

Yeah the GIC is quite nice IMO. The legacy INTC hardware often had
separate registers for setting and clearing, however priority probably
required read-modify-write. SMP wasn't an issue. =)

> This requirement has been there from day-1. Even the good old DIC (the
> GIC's ancestor) that was included with the 11MP-Core says: "All
> Interrupt Distributor Registers are byte accessible.", which is more
> than actually necessary for the GIC. See DDI 0360F for details. And
> yes, SW written for the GIC does work on the DIC.

Interesting. For some not so big reason this makes me think of Monty Python. =)

> >
> > > > +               .compatible     = "arm,pl390",
> > > > +               .init           = gic_enable_rmw_access,
> > > > +       },
> >
> > May I ask about a clarification about the EMEV2 DTS and DT binding
> > documentation in:
> > arch/arm/boot/dts/emev2.dts
> > Documentation/devicetree/bindings/interrupt-controller/arm,gic.yaml
> >
> > On EMEV2 the DT compatible string currently seems to be the rather
> > generic "arm,pl390". In the DT binding documentation GICv1 is listed
> > in an example as "arm,cortex-a9-gic". Is there any reason for not
> > using the GICv1 compatible string (and 32-bit access) for EMEV2? Just
> > curious.
>
> GICv1 is an architecture specification. PL390 is an implementation of
> GICv1. The so called "Cortex-A9 GIC" doesn't really exist. It is
> simply the amalgamation of the CPU interface implemented by the A9
> (with the prototype of the GICv2 virtualisation extensions) with a
> distributor (usually a PL390, but not necessarily). All of them
> require that the priority and target registers are byte accessible.

Makes sense.

> As for changing the compatibility string, I don't see the point. This
> will break existing setups, and doesn't change the core of the
> issue. As far as I can see, the EMEV2 DT is correct in the sense that
> it describes the actual implementation of the GIC used.

I'm all for not breaking existing setups, but EMEV2 is a pretty rare
case. So my line of thinking was that instead of punishing all GIC
platforms with this EMEV2-specific workaround it is completely fine
from my side to to special case it in DT if it makes the rest of the
code any cleaner. But it is really up to you guys.

Thanks,

/ magnus
