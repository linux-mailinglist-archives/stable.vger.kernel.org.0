Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF791CA064
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 03:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgEHB5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 21:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726701AbgEHB5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 21:57:19 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89957C05BD43;
        Thu,  7 May 2020 18:57:19 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f82so7228095ilh.8;
        Thu, 07 May 2020 18:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+69UJCHoe33EYwKtcLPJBKj4jo21jYdcKYJIlnvd2X8=;
        b=HxLwCwC8TRx/pKBzQSsc2fiNwMwDc9+bgoY7gJqpJTyWUYCEYxLSNXjYBMU1WlMMU1
         109Uro6fOh3DUUSImAi1lOYUPpmgHp20jHMZKrX/FmKUO1+CkjNUtV7Ju/1BOvwEJTR2
         Evsp+jKx8u/4qxSbQncZ0RtkPFVJ1E0wdtsRYjaXhh0HHuNs0aL0bL0G/Inace3dcL3C
         MH4xy3WeTngVzK7YrwKUf9d1WT6IEhsHHJ2GYtQUZE1noaxK8YyVi6A168uohdV5b6/t
         UadQyk5VJ4yeGpXeDkjHfgnfhAnkkavDKvHRTJvXmv9RA/R0POqqu+hSmbX3yHjMHf5w
         6RvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+69UJCHoe33EYwKtcLPJBKj4jo21jYdcKYJIlnvd2X8=;
        b=Fc3sdkmC4eor9G1jJrCGnn5Jd9MIOf8FhVwa/ECFKlzc+FUFovyw5jywiZvuFwph8i
         sLzhzW773SI8ARdwZkNoVbNuMcHKCC8AMs8sxWB9MsydEjTCZ3i/hOy75cbZUAB938Dr
         39lcNtJDedTZ9uJ4Q57kx2sRPhNU+OYN+tBjE06hE+Lwn4kZfgYGB4HEGJXiBbNDPS8m
         80Sd1mDTPfC6RMB6qoQVAj9B7OhE2ZCoW72yNtc1FzhqUQ3zw0YQWoeN7oLo1gWyUF70
         K6w+8oKg2DD1ow5UdlLqTmO+wYrabHutOgxsZBkclpmBdCJjrng9XsVPgyz1vuTr3AA2
         NzAQ==
X-Gm-Message-State: AGi0PuY6nZpzGRcaj/BU0JHJ+LIiySa+MF3iXe9bI3fbP1gmUslJajCh
        rklpZlnPJlvI4LH2wdVmTqV3ARVJ+NlDhI9J0Q==
X-Google-Smtp-Source: APiQypJWgXolt6buxgHn27fREaAUO11sgbKKU6WxrPa7V4fVSJ37lIGvSJS8RzOTTePKUgZ+xK4d0el86IGIGtmBvx8=
X-Received: by 2002:a05:6e02:d0c:: with SMTP id g12mr245188ilj.27.1588903038948;
 Thu, 07 May 2020 18:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com> <20200507113422.GA3762@hirez.programming.kicks-ass.net>
 <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com>
 <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com> <CAKwvOd=Ogbp0oVgmF2B9cePjyWnvLLFRSp2EnaonA-ZFN3K7Dg@mail.gmail.com>
In-Reply-To: <CAKwvOd=Ogbp0oVgmF2B9cePjyWnvLLFRSp2EnaonA-ZFN3K7Dg@mail.gmail.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Thu, 7 May 2020 21:57:07 -0400
Message-ID: <CAMzpN2gu4stkRKTsMTVxyzckO3SMhfA+dmCnSu6-aMg5QAA_JQ@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Nick Desaulniers <ndesaulniers@google.com>
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

On Thu, May 7, 2020 at 6:29 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Thu, May 7, 2020 at 12:19 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Thu, May 7, 2020 at 7:00 AM Brian Gerst <brgerst@gmail.com> wrote:
> > >
> > > This change will make sparse happy and allow these cleanups:
> > > #define CONST_MASK(nr)                 ((u8)1 << ((nr) & 7))
> >
> > yep, this is more elegant, IMO.  Will send a v3 later with this
> > change.  Looking at the uses of CONST_MASK, I noticed
> > arch_change_bit() currently has the (u8) cast from commit
> > 838e8bb71dc0c ("x86: Implement change_bit with immediate operand as
> > "lock xorb""), so that instance can get cleaned up with the above
> > suggestion.
>
> Oh, we need the cast to be the final operation.  The binary AND and
> XOR in 2 of the 3 uses of CONST_MASK implicitly promote the operands
> of the binary operand to int, so the type of the evaluated
> subexpression is int.
> https://wiki.sei.cmu.edu/confluence/display/c/EXP14-C.+Beware+of+integer+promotion+when+performing+bitwise+operations+on+integer+types+smaller+than+int
> So I think this version (v2) is most precise fix, and would be better
> than defining more macros or (worse) using metaprogramming.

One last suggestion.  Add the "b" modifier to the mask operand: "orb
%b1, %0".  That forces the compiler to use the 8-bit register name
instead of trying to deduce the width from the input.

--
Brian Gerst
