Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47463265AAF
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 09:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgIKHow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 03:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgIKHov (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 03:44:51 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25DA9214F1;
        Fri, 11 Sep 2020 07:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599810290;
        bh=2SvjM3wyWRinDmfWSZWn8mWwjteNXOXQUxYQxPMk0NY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lSYhYhdreUzwBmoUffYyOyHCw/DZO58XxteXwRg9moPDiZxGxLR9vkTubmO8RWW+B
         1tNkOG0vjmlw1sWunTJukHwnqkvHwaudYEejFqr4aY45yyDDyeYnhj7KQf+o0UvpWQ
         4S0fb1FCRNnXkgOhuveE+iZzXoQJ0I8+cqF2X81k=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kGdjk-00Avb7-3c; Fri, 11 Sep 2020 08:44:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Sep 2020 08:44:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] MIPS: Loongson64: Increase NR_IRQS to 320
In-Reply-To: <CAAhV-H401y6_9++CStCH=RrfoRw6-hZBWquEAGtGecbTGbVO1Q@mail.gmail.com>
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <894f35a7883451c4c2bf91b6181376fb@kernel.org>
 <CAAhV-H401y6_9++CStCH=RrfoRw6-hZBWquEAGtGecbTGbVO1Q@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <efab39a121918316564168c07cf88539@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: chenhc@lemote.com, tsbogend@alpha.franken.de, tglx@linutronix.de, jason@lakedaemon.net, linux-mips@vger.kernel.org, zhangfx@lemote.com, jiaxun.yang@flygoat.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-11 04:24, Huacai Chen wrote:
> Hi, Marc,
> 
> On Thu, Sep 10, 2020 at 6:10 PM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On 2020-09-09 05:09, Huacai Chen wrote:
>> > Modernized Loongson64 uses a hierarchical organization for interrupt
>> > controllers (INTCs), all INTC nodes (not only leaf nodes) need some IRQ
>> > numbers. This means 280 (i.e., NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
>> > is not enough to represent all interrupts, so let's increase NR_IRQS to
>> > 320.
>> >
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> > ---
>> >  arch/mips/include/asm/mach-loongson64/irq.h | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/mips/include/asm/mach-loongson64/irq.h
>> > b/arch/mips/include/asm/mach-loongson64/irq.h
>> > index f5e362f7..0da3017 100644
>> > --- a/arch/mips/include/asm/mach-loongson64/irq.h
>> > +++ b/arch/mips/include/asm/mach-loongson64/irq.h
>> > @@ -7,7 +7,7 @@
>> >  /* cpu core interrupt numbers */
>> >  #define NR_IRQS_LEGACY               16
>> >  #define NR_MIPS_CPU_IRQS     8
>> > -#define NR_IRQS                      (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 256)
>> > +#define NR_IRQS                      320
>> >
>> >  #define MIPS_CPU_IRQ_BASE    NR_IRQS_LEGACY
>> 
>> Why are you hardcoding a random value instead of bumping the constant
>> in NR_IRQS?
> Because INTCs can organized in many kinds of hierarchy, we cannot use
> constants to define a accurate value, but 320 is big enough.

You're not answering my question. You have a parameterized NR_IRQS, and
you're turning it into an absolute constant. Why? I.e:

#define NR_IRQS        (NR_IRQS_LEGACY + NR_MIPS_CPU_IRQS + 296)

And why 320? Why not 512? or 2^15?

As for a "modernized" setup, the fact that you are not using SPARSE_IRQ
is pretty backward.

         M.
-- 
Jazz is not dead. It just smells funny...
