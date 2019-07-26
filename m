Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9541E76B06
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfGZOFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:05:15 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43712 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbfGZOFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 10:05:15 -0400
Received: by mail-lf1-f68.google.com with SMTP id c19so37167040lfm.10
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 07:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XRsk0iEI3zTElR2u2jt3WIaXl85qXr9Noy6MPl/LLlU=;
        b=OX77yu642sxgg1HWdyQx9x41cx1WuDT18/aO9UX6rY4u4nAODv+wC6yhBaw3+9QX5T
         dBV1+B9FKTO/C+WlDI5n+NiBhKRsKNedmV8BCjk0uTgaB5MapIid4HUVGa8JaZKYD3yD
         nlg5wjSYvBF7Gf8MnPUS+JftzW8zigSkaenRy2Uw5jyAdHFjkJIQ8Oe3qzzp0Jl3BdRY
         UvCzsbkTsgl3SeExNSjo80CItXkQUHBePxaN2g7ANgbH7nPjhp5EV5EQ5W5GwhhAT7za
         mYlEKOBBkzDnZNJeVptuM4S9BVNtUQrKp6ObQSUIgCqUFZn3URJCZvD2air0iweLKLrk
         Y+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XRsk0iEI3zTElR2u2jt3WIaXl85qXr9Noy6MPl/LLlU=;
        b=tqESiVya4Dzem/tnhO/qkHur5jLTADzyZoELN3MUvITwXkAeJXxJGqjRlGsJd87c5m
         nJzkLqXrtQ9Nwyb0j9esoKnIOtZaqeiJJslPkUhR9L9J4H7CFZyi07mxb/MT9V4NE1wz
         DLm3BfwFf2c3XHUmAbv8I/s+besQwz+wzMdVYdIUfq4frBUcIKW3xnF2jLctk/qjHl8P
         PZ31kJy2j1ZNT02ANi6aN3fY+H4yS+YnEwfV2Ovy/aJmWUHXPzIfy8W18Tm2GcSiff+7
         RfJjDXlaJ3DHxUDrPtlNNfeITXDoVB/WF0Qx3MhJD5Hw3mUpVM9wA1IRJnBBPlFDvGB9
         xl3g==
X-Gm-Message-State: APjAAAW+e2pNm+4Y3VnwRu6bfHM1OyKMQiyYQI/8XawMLpDoN6dFyjiU
        ymbDoVVlmxwt3++00mvzrt65wmsFB2RLjwJaboekpw==
X-Google-Smtp-Source: APXvYqwa4920tCYVHHu9I4QKSrBmf0RTIQ5b6Q2RM0JOBEekZMUOdfpLbKuHuoNm3VkGJHdz7S50cU4xJ9G0jxWt3ec=
X-Received: by 2002:ac2:44b1:: with SMTP id c17mr33687690lfm.87.1564149912518;
 Fri, 26 Jul 2019 07:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190726112705.19000-1-anders.roxell@linaro.org> <86ef2dnfkb.wl-marc.zyngier@arm.com>
In-Reply-To: <86ef2dnfkb.wl-marc.zyngier@arm.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 26 Jul 2019 16:05:01 +0200
Message-ID: <CADYN=9+RpC1xkBwvjUO=Figy5VSw-LFxazEE32fx9eLoPPMjRA@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: KVM: regmap: Mark expected switch fall-through
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Jul 2019 at 14:30, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> Hi Anders,
>
> On Fri, 26 Jul 2019 12:27:05 +0100,
> Anders Roxell <anders.roxell@linaro.org> wrote:
> >
> > When fall-through warnings was enabled by default, commit d93512ef0f0e
> > ("Makefile: Globally enable fall-through warning"), the following
> > warnings was starting to show up:
> >
> > In file included from ../arch/arm64/include/asm/kvm_emulate.h:19,
> >                  from ../arch/arm64/kvm/regmap.c:13:
> > ../arch/arm64/kvm/regmap.c: In function =E2=80=98vcpu_write_spsr32=E2=
=80=99:
> > ../arch/arm64/include/asm/kvm_hyp.h:31:3: warning: this statement may f=
all
> >  through [-Wimplicit-fallthrough=3D]
> >    asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"), \
> >    ^~~
> > ../arch/arm64/include/asm/kvm_hyp.h:46:31: note: in expansion of macro =
=E2=80=98write_sysreg_elx=E2=80=99
> >  #define write_sysreg_el1(v,r) write_sysreg_elx(v, r, _EL1, _EL12)
> >                                ^~~~~~~~~~~~~~~~
> > ../arch/arm64/kvm/regmap.c:180:3: note: in expansion of macro =E2=80=98=
write_sysreg_el1=E2=80=99
> >    write_sysreg_el1(v, SYS_SPSR);
> >    ^~~~~~~~~~~~~~~~
> > ../arch/arm64/kvm/regmap.c:181:2: note: here
> >   case KVM_SPSR_ABT:
> >   ^~~~
> > In file included from ../arch/arm64/include/asm/cputype.h:132,
> >                  from ../arch/arm64/include/asm/cache.h:8,
> >                  from ../include/linux/cache.h:6,
> >                  from ../include/linux/printk.h:9,
> >                  from ../include/linux/kernel.h:15,
> >                  from ../include/asm-generic/bug.h:18,
> >                  from ../arch/arm64/include/asm/bug.h:26,
> >                  from ../include/linux/bug.h:5,
> >                  from ../include/linux/mmdebug.h:5,
> >                  from ../include/linux/mm.h:9,
> >                  from ../arch/arm64/kvm/regmap.c:11:
> > ../arch/arm64/include/asm/sysreg.h:837:2: warning: this statement may f=
all
> >  through [-Wimplicit-fallthrough=3D]
> >   asm volatile("msr " __stringify(r) ", %x0"  \
> >   ^~~
> > ../arch/arm64/kvm/regmap.c:182:3: note: in expansion of macro =E2=80=98=
write_sysreg=E2=80=99
> >    write_sysreg(v, spsr_abt);
> >    ^~~~~~~~~~~~
> > ../arch/arm64/kvm/regmap.c:183:2: note: here
> >   case KVM_SPSR_UND:
> >   ^~~~
> >
> > Rework to add a 'break;' in the swich-case since it didn't have that.
> > That also made the compiler happy and didn't warn about fall-through.
> >
> > Cc: stable@vger.kernel.org # v3.16+
>
> Erm... Are you sure about that?

I made two mistakes.
1. saying 3.x instead of 4.x
2. I said the same kernel that 'git describe' showed and not the later one.

I did not know about '--match=3D'.

> Here's what I have:
>
> $ git describe --contains  a892819560c4
> kvm-arm-for-v4.17~44
> $ git describe --contains --match=3D'v*' a892819560c4
> v4.17-rc1~72^2~36^2~44

That's correct.

>
>
> > Fixes: a892819560c4 ("KVM: arm64: Prepare to handle deferred save/resto=
re of 32-bit registers")
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >  arch/arm64/kvm/regmap.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
> > index 0d60e4f0af66..a900181e3867 100644
> > --- a/arch/arm64/kvm/regmap.c
> > +++ b/arch/arm64/kvm/regmap.c
> > @@ -178,13 +178,18 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, uns=
igned long v)
> >       switch (spsr_idx) {
> >       case KVM_SPSR_SVC:
> >               write_sysreg_el1(v, SYS_SPSR);
> > +             break;
> >       case KVM_SPSR_ABT:
> >               write_sysreg(v, spsr_abt);
> > +             break;
> >       case KVM_SPSR_UND:
> >               write_sysreg(v, spsr_und);
> > +             break;
> >       case KVM_SPSR_IRQ:
> >               write_sysreg(v, spsr_irq);
> > +             break;
> >       case KVM_SPSR_FIQ:
> >               write_sysreg(v, spsr_fiq);
> > +             break;
> >       }
> >  }
>
> Otherwise looks like the right fix to me. Let me know what you think
> about the Fixes: tag (no need to resend for that).

It should be v4.17+.

Cheers,
Anders
