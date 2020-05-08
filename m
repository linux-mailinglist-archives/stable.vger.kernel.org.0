Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED421CB5BC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 19:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgEHRWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 13:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgEHRWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 13:22:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8023C061A0C
        for <stable@vger.kernel.org>; Fri,  8 May 2020 10:22:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so4609094pjh.2
        for <stable@vger.kernel.org>; Fri, 08 May 2020 10:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDmOxQMCuaw5F6/Weoldmrv8lAutINkccOcvV//08Lo=;
        b=uz6CQxh4gx44MIkOb4uoPsulQcoadM4lvLN8PW4twq6GXEyiBPwb4BpfSqGisSWHU8
         KgUz23Sy4OHg4McVtDGkn1shgfffYfuSoTyYAp3cSjJqjMzB/uChi69dqKS3z0+CIhSX
         DpqZWBMvLuY6Yy9OqKHgQOFn+0nNEXzJKOl4XRO+5kH9YpeoVN2u+KziL+wT3kg7kobt
         8HspgqpP3STPysPB9h+RHLEusRGic/V2t62HNpOYC6ZiqEU3ZLZp0oRdcKkmTrdWrNjD
         yEU6b7VACRfdgG7SsFhLBl9kmiNt3HJy5MaLxj3VP16jk5qCLTutzRyTzSlcDNAOnAEQ
         qndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDmOxQMCuaw5F6/Weoldmrv8lAutINkccOcvV//08Lo=;
        b=PvavZ+Panl1TvtMH5EOEbBwtjhwf8OZ1sz01QCOZF/WhmIa3r4tAXBaWvj7O7Pjn65
         /DqCxpnBPj11ZLenbPFt46m3ugv1H1k/Sl2t/3EI1YB20gcPX9ne9Sp1x/VwRnDrPgHd
         gnPV4dq9Ha1dFFuKa4ucZjupNpX486+R3KWMWRmhUWVkOsX4qNn3UoceAsN+iTGjAvQe
         tN1Wvcur0n159uffgAcVMqYDq3pmbpZ0RGJJPuoPC1AjvuH2VNemM4lxZaiUsGwwkFY7
         I3nulZGVKGQ7oUgQzdpRMPyxGNR2bqxL8APz2ZfrufB0hTaPsEMOwzRTQQTUdpKFhPrY
         chDQ==
X-Gm-Message-State: AGi0PuYBKuiBpoSXbUu6vPxjqpFvoYe79ZivvRf0Wfq7J1dYKgZHb4bd
        x1ibWiUa7TNeBN1sYMAZnQglFcRqaUL3YdD0G+pTgA==
X-Google-Smtp-Source: APiQypISgtnD5NDGHv3g6yn5klP9hv3kXnvW9OyaSiLskvc+++YwjPnOVL60aWHLauimVX8osi0SRQ8ElmR15zyuNn0=
X-Received: by 2002:a17:90b:2302:: with SMTP id mt2mr3301097pjb.25.1588958519887;
 Fri, 08 May 2020 10:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com> <20200507113422.GA3762@hirez.programming.kicks-ass.net>
 <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com>
 <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com>
 <CAKwvOd=Ogbp0oVgmF2B9cePjyWnvLLFRSp2EnaonA-ZFN3K7Dg@mail.gmail.com> <CAMzpN2gu4stkRKTsMTVxyzckO3SMhfA+dmCnSu6-aMg5QAA_JQ@mail.gmail.com>
In-Reply-To: <CAMzpN2gu4stkRKTsMTVxyzckO3SMhfA+dmCnSu6-aMg5QAA_JQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 8 May 2020 10:21:48 -0700
Message-ID: <CAKwvOd=hVKrFU+imSGeX+MEKMpW97gE7bzn1C637qdns9KSnUA@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Brian Gerst <brgerst@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 7, 2020 at 6:57 PM Brian Gerst <brgerst@gmail.com> wrote:
>
> On Thu, May 7, 2020 at 6:29 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Thu, May 7, 2020 at 12:19 PM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > >
> > > On Thu, May 7, 2020 at 7:00 AM Brian Gerst <brgerst@gmail.com> wrote:
> > > >
> > > > This change will make sparse happy and allow these cleanups:
> > > > #define CONST_MASK(nr)                 ((u8)1 << ((nr) & 7))
> > >
> > > yep, this is more elegant, IMO.  Will send a v3 later with this
> > > change.  Looking at the uses of CONST_MASK, I noticed
> > > arch_change_bit() currently has the (u8) cast from commit
> > > 838e8bb71dc0c ("x86: Implement change_bit with immediate operand as
> > > "lock xorb""), so that instance can get cleaned up with the above
> > > suggestion.
> >
> > Oh, we need the cast to be the final operation.  The binary AND and
> > XOR in 2 of the 3 uses of CONST_MASK implicitly promote the operands
> > of the binary operand to int, so the type of the evaluated
> > subexpression is int.
> > https://wiki.sei.cmu.edu/confluence/display/c/EXP14-C.+Beware+of+integer+promotion+when+performing+bitwise+operations+on+integer+types+smaller+than+int
> > So I think this version (v2) is most precise fix, and would be better
> > than defining more macros or (worse) using metaprogramming.
>
> One last suggestion.  Add the "b" modifier to the mask operand: "orb
> %b1, %0".  That forces the compiler to use the 8-bit register name
> instead of trying to deduce the width from the input.

Ah right: https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#x86Operandmodifiers

Looks like that works for both compilers.  In that case, we can likely
drop the `& 0xff`, too.  Let me play with that, then I'll hopefully
send a v3 today.
-- 
Thanks,
~Nick Desaulniers
