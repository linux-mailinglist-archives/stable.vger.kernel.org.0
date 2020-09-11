Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2055E265758
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 05:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgIKDYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 23:24:54 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39216 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgIKDYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 23:24:53 -0400
Received: by mail-io1-f66.google.com with SMTP id b6so9543369iof.6;
        Thu, 10 Sep 2020 20:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGBoBmGAtB2vcBBsx9k1EM9PouHaew/fLnFa1nNdlDM=;
        b=lOYon75hM3rc1v8++DQ0zme1a9rDnktIki34+jdYcpxBsHxJgN1zIl19Tdsh/PgoO6
         TBrgwWVvza2B2jEeA5GyQjylYaTDAb1WyGzU9jVwveDe9WuCIdYFO1SWlXMTYxVJWOvg
         1B0DpA2N1hNt6pEF0cTF/j8/uVyrL0jGQriJ9Hi/NTCbAgudcpGWN2mMxbnUQgZpTSmT
         grTxzM+B9I6Gto2JEva/gh/ht49kDa2gNoYnikGGqkHMcOW3SM8yqofya3WeQtXZ1fgU
         7bMr9dDkqvSxaRP+fGR/6RUQY/kdJlCyjqQ7BLTjqfZjeD5ko+3IGYJvVrbIhm2+K8z5
         weXA==
X-Gm-Message-State: AOAM533WWK8A4oPRrvvG1tany3MN0Q3XCDjWogsxjVgPNn7w7GkXKDa+
        yjJqlAVvUElCAzkVnToHe1IxzkQBPitNaeU05l4=
X-Google-Smtp-Source: ABdhPJyhMxtOK1kT1gtKdIjuikcvqZaGTWG9MBcuG/GizwxIqTMk+kwjjr4v6F3S8YJ7Y+WRQGEgtTE12OA4gRIdjf8=
X-Received: by 2002:a6b:6016:: with SMTP id r22mr214533iog.42.1599794692495;
 Thu, 10 Sep 2020 20:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com> <894f35a7883451c4c2bf91b6181376fb@kernel.org>
In-Reply-To: <894f35a7883451c4c2bf91b6181376fb@kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 11:24:41 +0800
Message-ID: <CAAhV-H401y6_9++CStCH=RrfoRw6-hZBWquEAGtGecbTGbVO1Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] MIPS: Loongson64: Increase NR_IRQS to 320
To:     Marc Zyngier <maz@kernel.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Marc,

On Thu, Sep 10, 2020 at 6:10 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-09-09 05:09, Huacai Chen wrote:
> > Modernized Loongson64 uses a hierarchical organization for interrupt
> > controllers (INTCs), all INTC nodes (not only leaf nodes) need some IRQ
> > numbers. This means 280 (i.e., NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> > is not enough to represent all interrupts, so let's increase NR_IRQS to
> > 320.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  arch/mips/include/asm/mach-loongson64/irq.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/mips/include/asm/mach-loongson64/irq.h
> > b/arch/mips/include/asm/mach-loongson64/irq.h
> > index f5e362f7..0da3017 100644
> > --- a/arch/mips/include/asm/mach-loongson64/irq.h
> > +++ b/arch/mips/include/asm/mach-loongson64/irq.h
> > @@ -7,7 +7,7 @@
> >  /* cpu core interrupt numbers */
> >  #define NR_IRQS_LEGACY               16
> >  #define NR_MIPS_CPU_IRQS     8
> > -#define NR_IRQS                      (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> > +#define NR_IRQS                      320
> >
> >  #define MIPS_CPU_IRQ_BASE    NR_IRQS_LEGACY
>
> Why are you hardcoding a random value instead of bumping the constant
> in NR_IRQS?
Because INTCs can organized in many kinds of hierarchy, we cannot use
constants to define a accurate value, but 320 is big enough.

Huacai
>
>          M.
> --
> Jazz is not dead. It just smells funny...
