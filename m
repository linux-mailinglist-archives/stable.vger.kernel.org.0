Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8621D24C53A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 20:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHTSWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 14:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgHTSWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 14:22:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F32C061386
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 11:22:05 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m22so3169005ljj.5
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6bpH/rDSoFxQjF9Z+G+y55sWHGzEFzdoVgsBQvNI7v4=;
        b=MS1ngaMH/qq1mDlfneEQX0J3/fOBeD1iB0e+t4YZKZ9mgCOjLIUkL6iCaoR9YMDwAB
         clFSxGt92ljoPzFGrNPh11R1a5/cRMzoNd9Kd6lSAIz/jO3LxlrSWTBy4+sLcIgBVMhj
         rDdmzdByP/J58lYF2ajvQH1ClC/RglRFgs7Hw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6bpH/rDSoFxQjF9Z+G+y55sWHGzEFzdoVgsBQvNI7v4=;
        b=fYZJs7C8NWWZ2zyimEbNoO+sRYiLv1LrBB8mR7+0soDEjtV9ll0e4fUPmEepqxbC1E
         xvjzLBEKgYt1HYW7jk3u4AA6iv+zSQ3/M2vLNQq25QHDHBeeLDEGyB1fC30XbxkE7l4C
         ZqYVWc7Y5xxKezWWX6EYVs4OxzlWXT63R3iuud3rQ0hHifWKts8Le8K8D02Q8fVxBZSB
         Br45HdeeZ89Ki6r9DvILdy9khVYinp7itVeeN2IyLmujMA1e9q+wt6sx5YZjDu0Frysg
         v7cyIaYe14+YWrjuw8bW8aRpqJM9VsqBaMdhj/3jpMz8UbIhtorvKDA4eNEKy5j44YYt
         oj2g==
X-Gm-Message-State: AOAM533VUMCk7p3e8KBFGTV7s5FW+5QDVOpGuca5L9icBQl2jzYQrq8c
        aEY1tzj5fhnr5TZO6pve3ujXZBPC5rkoNg==
X-Google-Smtp-Source: ABdhPJwdL4uAG5XV7tuystpOaeud84j8wpGDBKZrvKylwasv0LpstmHyMw7vNFacGIM+iLrgjJdycQ==
X-Received: by 2002:a2e:b8cb:: with SMTP id s11mr2327314ljp.110.1597947723217;
        Thu, 20 Aug 2020 11:22:03 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id a2sm585805ljj.40.2020.08.20.11.22.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 11:22:02 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id t6so3149579ljk.9
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 11:22:02 -0700 (PDT)
X-Received: by 2002:a05:651c:1b4:: with SMTP id c20mr2064657ljn.432.1597947721521;
 Thu, 20 Aug 2020 11:22:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200814213842.31151-1-ashok.raj@intel.com> <CAE=gft6fQ7cLQO025TDYNF-d6xxMeGkOHVieMZDq6wAZ84NsGQ@mail.gmail.com>
 <20200817183322.GA11486@araj-mobl1.jf.intel.com>
In-Reply-To: <20200817183322.GA11486@araj-mobl1.jf.intel.com>
From:   Evan Green <evgreen@chromium.org>
Date:   Thu, 20 Aug 2020 11:21:24 -0700
X-Gmail-Original-Message-ID: <CAE=gft6D_1NWVczfO3JFhwCGeYBKsUUtt03TrtgWVViOVgP=4w@mail.gmail.com>
Message-ID: <CAE=gft6D_1NWVczfO3JFhwCGeYBKsUUtt03TrtgWVViOVgP=4w@mail.gmail.com>
Subject: Re: [PATCH] x86/hotplug: Silence APIC only after all irq's are migrated
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 11:33 AM Raj, Ashok <ashok.raj@intel.com> wrote:
>
> Hi Evan
>
> Some details below,
>
> On Mon, Aug 17, 2020 at 11:12:17AM -0700, Evan Green wrote:
> > Hi Ashok,
> > Thank you, Srikanth, and Sukumar for some very impressive debugging here.
> >
> > On Fri, Aug 14, 2020 at 2:38 PM Ashok Raj <ashok.raj@intel.com> wrote:
> > >
> > > When offlining CPU's, fixup_irqs() migrates all interrupts away from the
> > > outgoing CPU to an online CPU. Its always possible the device sent an
> > > interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> > > lapic identifies such interrupts. apic_soft_disable() will not capture any
> > > new interrupts in IRR. This causes interrupts from device to be lost during
> > > cpu offline. The issue was found when explicitly setting MSI affinity to a
> > > CPU and immediately offlining it. It was simple to recreate with a USB
> > > ethernet device and doing I/O to it while the CPU is offlined. Lost
> > > interrupts happen even when Interrupt Remapping is enabled.
> > >
> > > Current code does apic_soft_disable() before migrating interrupts.
> > >
> > > native_cpu_disable()
> > > {
> > >         ...
> > >         apic_soft_disable();
> > >         cpu_disable_common();
> > >           --> fixup_irqs(); // Too late to capture anything in IRR.
> > > }
> > >
> > > Just fliping the above call sequence seems to hit the IRR checks
> > > and the lost interrupt is fixed for both legacy MSI and when
> > > interrupt remapping is enabled.
> > >
> > >
> > > Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
> > > Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
> > > Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> > >
> > > To: linux-kernel@vger.kernel.org
> > > To: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Sukumar Ghorai <sukumar.ghorai@intel.com>
> > > Cc: Srikanth Nandamuri <srikanth.nandamuri@intel.com>
> > > Cc: Evan Green <evgreen@chromium.org>
> > > Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  arch/x86/kernel/smpboot.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > > index ffbd9a3d78d8..278cc9f92f2f 100644
> > > --- a/arch/x86/kernel/smpboot.c
> > > +++ b/arch/x86/kernel/smpboot.c
> > > @@ -1603,13 +1603,20 @@ int native_cpu_disable(void)
> > >         if (ret)
> > >                 return ret;
> > >
> > > +       cpu_disable_common();
> > >         /*
> > >          * Disable the local APIC. Otherwise IPI broadcasts will reach
> > >          * it. It still responds normally to INIT, NMI, SMI, and SIPI
> > > -        * messages.
> >
> > I'm slightly unclear about whether interrupts are disabled at the core
> > by this point or not. I followed native_cpu_disable() up to
> > __cpu_disable(), up to take_cpu_down(). This is passed into a call to
> > stop_machine_cpuslocked(), where interrupts get disabled at the core.
> > So unless there's another path, it seems like interrupts are always
> > disabled at the core by this point.
>
> local_irq_disable() just does cli() which allows interrupts to trickle
> in to the IRR bits, and once you do sti() things would flow back for
> normal interrupt processing.
>
>
> >
> > If interrupts are always disabled, then the comment above is a little
>
> Disable interrupts is different from disabling LAPIC. Once you do the
> apic_soft_disable(), there is nothing flowing into the LAPIC except
> for INIT, NMI, SMI and SIPI messages.
>
> This turns off the pipe for all other interrupts to enter LAPIC. Which
> is different from doing a cli().

I understand the distinction. I was mostly musing on the difference in
behavior your change causes if this function is entered with
interrupts enabled at the core (ie sti()). But I think it never is, so
that thought is moot.

I could never repro the issue reliably on comet lake after Thomas'
original fix. But I can still repro it easily on jasper lake. And this
patch fixes the issue for me on that platform. Thanks for the fix.

Reviewed-by: Evan Green <evgreen@chromium.org>
Tested-by: Evan Green <evgreen@chromium.org>
