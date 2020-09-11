Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E1B265CA9
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 11:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgIKJlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 05:41:03 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:44980 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgIKJlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 05:41:02 -0400
Received: by mail-il1-f194.google.com with SMTP id h11so8400166ilj.11;
        Fri, 11 Sep 2020 02:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pmVjM/dy1qrndSGo1jnx31Vj3jjPiwVS7vEoYuKJKtg=;
        b=ctH0NyJjOC2GKa2BIqZ4vLkq6U+k7/rHEqsat38ldJFgbTKg4boAhLtZFPic4WS1xP
         hFE97Rt6uTklJnXiAqlSWmPBZwnJDmKeBV41zzVKyefc9Kgsis8mo8VzAAbqQUNdoK1n
         GBMjW6vxfo6fF+KnHQF3/kJ/Q3TkyTuX3CDsKXj7aqPxvnvkfKQ8F1VcxF+E+5EuyUuE
         szy+G20G+vMhHVwPiry+MOZ1TkphnMg5lii65CYoi+soRvRUUASQO/h/I7p3tFvISiHq
         6V4SfEXMBOh+Eqg7H1CzTC2TXK4gJQJ2m8GjVQXirRrwIwQz36H7tdv4OThe0nStK0h2
         /2PA==
X-Gm-Message-State: AOAM532g2ujS21+ApKDFcFfrQWX0g6z4Dki0zAMmrnVxj2+yTMPSqUzS
        3MwYkAIvAIW5+48hS6tJvaYFcb5DIy45TtSprgNWO6MjdnU=
X-Google-Smtp-Source: ABdhPJzPFiXGuXSXhXigH5NRrwttFOoJ6hjP0lxUK7FDJEAn6EZHxecOXmH3Zeo6x0Y4DdCsDToPckic8fuoMlvVIKY=
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr1063485ilq.287.1599817260807;
 Fri, 11 Sep 2020 02:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <894f35a7883451c4c2bf91b6181376fb@kernel.org> <CAAhV-H401y6_9++CStCH=RrfoRw6-hZBWquEAGtGecbTGbVO1Q@mail.gmail.com>
 <efab39a121918316564168c07cf88539@kernel.org> <CAAhV-H4wHO12HVaA307GJX-WnkddT5w+YWgFMGuk0ov-f7Sm8A@mail.gmail.com>
 <88b8ce9eaf6c866d47685d8608fe5a49@kernel.org> <CAAhV-H5ZF6=xj9=mP5r6FudFjy9N-TjzZaoVhkuevVKE50LE1A@mail.gmail.com>
 <fe22abfaa37590c794d7f792dc3b4af7@kernel.org>
In-Reply-To: <fe22abfaa37590c794d7f792dc3b4af7@kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 17:40:49 +0800
Message-ID: <CAAhV-H7YvCsFnxyLbP0wy19Q0kBz4LUasEwUwL4MxSox-770Mw@mail.gmail.com>
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

On Fri, Sep 11, 2020 at 5:23 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-09-11 10:14, Huacai Chen wrote:
> > Hi, Marc,
> >
> > On Fri, Sep 11, 2020 at 5:03 PM Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> On 2020-09-11 09:43, Huacai Chen wrote:
> >> > Hi, Marc,
> >> >
> >> > On Fri, Sep 11, 2020 at 3:45 PM Marc Zyngier <maz@kernel.org> wrote:
> >> >>
> >> >> On 2020-09-11 04:24, Huacai Chen wrote:
> >> >> > Hi, Marc,
> >> >> >
> >> >> > On Thu, Sep 10, 2020 at 6:10 PM Marc Zyngier <maz@kernel.org> wrote:
> >> >> >>
> >> >> >> On 2020-09-09 05:09, Huacai Chen wrote:
> >> >> >> > Modernized Loongson64 uses a hierarchical organization for interrupt
> >> >> >> > controllers (INTCs), all INTC nodes (not only leaf nodes) need some IRQ
> >> >> >> > numbers. This means 280 (i.e., NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> >> >> >> > is not enough to represent all interrupts, so let's increase NR_IRQS to
> >> >> >> > 320.
> >> >> >> >
> >> >> >> > Cc: stable@vger.kernel.org
> >> >> >> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> >> >> >> > ---
> >> >> >> >  arch/mips/include/asm/mach-loongson64/irq.h | 2 +-
> >> >> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >> >> >
> >> >> >> > diff --git a/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> >> > b/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> >> > index f5e362f7..0da3017 100644
> >> >> >> > --- a/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> >> > +++ b/arch/mips/include/asm/mach-loongson64/irq.h
> >> >> >> > @@ -7,7 +7,7 @@
> >> >> >> >  /* cpu core interrupt numbers */
> >> >> >> >  #define NR_IRQS_LEGACY               16
> >> >> >> >  #define NR_MIPS_CPU_IRQS     8
> >> >> >> > -#define NR_IRQS                      (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
> >> >> >> > +#define NR_IRQS                      320
> >> >> >> >
> >> >> >> >  #define MIPS_CPU_IRQ_BASE    NR_IRQS_LEGACY
> >> >> >>
> >> >> >> Why are you hardcoding a random value instead of bumping the constant
> >> >> >> in NR_IRQS?
> >> >> > Because INTCs can organized in many kinds of hierarchy, we cannot use
> >> >> > constants to define a accurate value, but 320 is big enough.
> >> >>
> >> >> You're not answering my question. You have a parameterized NR_IRQS,
> >> >> and
> >> >> you're turning it into an absolute constant. Why? I.e:
> >> >>
> >> >> #define NR_IRQS        (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 296)
> >> >>
> >> >> And why 320? Why not 512? or 2^15?
> >> > OK, I know, I will define a NR_MAX_MIDDLE_IRQS and then define NR_IRQS
> >> > as  (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + NR_MAX_MIDDLE_IRQS + 256)
> >>
> >> What does MIDDLE_IRQS mean? Please name it to something that actually
> >> relates to its usage...
> > INTCs are organized as a tree, MIDDLE_IRQS means those IRQS used by
>
> Tell me something I don't know...
>
> > middle nodes (not leaf nodes and not root node), midde nodes is not
> > directed by devices, but they consumes irq numbers.
>
> Then name the #define something that represents its use. "middle"
> doesn't
> describe anything. Call it "chained", or "cascade", or something at
> actually
> reflects the topology of these systems.
I choose "chained".

>
> >
> >>
> >> >>
> >> >> As for a "modernized" setup, the fact that you are not using
> >> >> SPARSE_IRQ
> >> >> is pretty backward.
> >> > I have discussed this with Jiaxun, and he said that there are some
> >> > difficulties to use SPARSE_IRQ.
> >>
> >> It'd be worth considering putting some efforts there...
> > Yes, but that is another topic.
>
> It really is the same topic. You keep bumping this NR_IRQS up in
> arbitrary ways,
> which would be avoided if you brought MIPS into the 21st century.
Jiaxun, please explain why you don't use SPARSE_IRQ?

Huacai
>
>          M.
> --
> Jazz is not dead. It just smells funny...
