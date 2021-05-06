Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AC0374C97
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 03:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhEFBEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 21:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhEFBEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 21:04:42 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96046C06174A
        for <stable@vger.kernel.org>; Wed,  5 May 2021 18:03:44 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id h202so5165261ybg.11
        for <stable@vger.kernel.org>; Wed, 05 May 2021 18:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FBkp32GshYrkb603e1Upi0wbWnkjpZZV/bjtxuylxJM=;
        b=FXD+G87mcAUITwzWc/x5fMK+Tepos5bdZcDaDQJkD6dCVwmHUV5yYlIneVveaGvu4O
         TvzlpzWDj0PWBp/8zE4KriQK5C3V9onh+Y/fQrE3qeaYCPxGZWeAsMOkAwNyPMW2uSpG
         c+c/sMyisBPTzklndRIEqsUFWYfhT1yMhsHqX073NM38HMAGsUEEnjaHcCuYnzsBMCZF
         ofPyhXJ1iVbQLwnKm5LvuIlZBvT4jR+wv02+Ale51AVfYR7zHQy/5IFeEBvypQiko+Qx
         RVfLxVOwWsSEt8CQ/ECvSZKkDTkm6l4y5KN7bYaaBevKXSBPnAFPPYaabi7zGZ+tv+c1
         wEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FBkp32GshYrkb603e1Upi0wbWnkjpZZV/bjtxuylxJM=;
        b=EV5KisruimYr6qbJQzb0uBxRAppAKD4frIY508oq+tp3K3PXJmilnIMQUUiawTMmxT
         4r6ZA5vtYpv/A047YMR13jDZHIBUaXxU6wjB0L/axhYNqER/sc/Jd9jWU5fjMveRpRO5
         D6uML9GndNnSrx/NVQmlkEU8+Qw8DXHG3YhnkkHE09WuDksOkPF2BKfgntKkwgP1Y3QU
         a1S07M3+s+We8Mmp+9q1+sfg01Fm0TS3a5AImYEurQhlghVWvjh7EDGz4Pt8OBWnyFyN
         1HeoC6qIMHYP4PaGXHvnwOhXAUo9/ZPRibK/QDQ9IBeOSsBqdVNWY8D2s1c2IoUUrBEv
         bSUA==
X-Gm-Message-State: AOAM531EiMbOD/8v6kJNgkSzX9yOjxH4YVuIvTGbxx4lc+MQK1u/dAsH
        WYJG9mAdMN3PvU9B8LE/KeYAq3+2mEBHrh8cMcgHkQ==
X-Google-Smtp-Source: ABdhPJwjdKygNk0LDV699O9HlpKnDvAKBoL3zujK1SqTpzYP68cOzuvi/TvGfBcTziwe+Aw2FuHe6IcHj8kMYG9h7x0=
X-Received: by 2002:a25:c591:: with SMTP id v139mr2136670ybe.511.1620263023577;
 Wed, 05 May 2021 18:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210416203522.2397801-1-jiancai@google.com> <20210416232341.2421342-1-jiancai@google.com>
 <YJMJAiwMPqlWmr8Y@archlinux-ax161>
In-Reply-To: <YJMJAiwMPqlWmr8Y@archlinux-ax161>
From:   Jian Cai <jiancai@google.com>
Date:   Wed, 5 May 2021 18:03:32 -0700
Message-ID: <CA+SOCLLhEfy+VCASsexnKTvGVc5cwd46+DmrB-nk+X1zkLHG0Q@mail.gmail.com>
Subject: Re: [PATCH v3] arm64: vdso: remove commas between macro name and arguments
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nathan,

Please find my comments inlined.

Thanks,
Jian

On Wed, May 5, 2021 at 2:07 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi Jian,
>
> On Fri, Apr 16, 2021 at 04:23:41PM -0700, Jian Cai wrote:
> > LLVM's integrated assembler does not support using commas separating
> > the name and arguments in .macro. However, only spaces are used in the
> > manual page. This replaces commas between macro names and the subsequen=
t
> > arguments with space in calls to clock_gettime_return to make it
> > compatible with IAS.
> >
> > Link:
> > https://sourceware.org/binutils/docs/as/Macro.html#Macro
> > https://github.com/ClangBuiltLinux/linux/issues/1349
> >
> > Signed-off-by: Jian Cai <jiancai@google.com>
>
> The actual patch itself looks fine to me but there should be some more
> explanation in the commit message that this patch is for 4.19 only and
> why it is not applicable upstream. Additionally, I would recommend using
> the '--subject-prefix=3D' flag to 'git format-patch' to clarify that as
> well, something like '--subject-prefix=3D"PATCH 4.19 ONLY"'?
>
> My explanation would be something like (take bits and pieces as you feel
> necessary):
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> [PATCH 4.19 ONLY] arm64: vdso: remove commas between macro name and
> arguments
>
> LLVM's integrated assembler does not support using a comma to separate
> a macro name and its arguments when there is only one argument with a
> default value:
>
> arch/arm64/kernel/vdso/gettimeofday.S:230:24: error: too many positional
> arguments
>  clock_gettime_return, shift=3D1
>                        ^
> arch/arm64/kernel/vdso/gettimeofday.S:253:24: error: too many positional
> arguments
>  clock_gettime_return, shift=3D1
>                        ^
> arch/arm64/kernel/vdso/gettimeofday.S:274:24: error: too many positional
> arguments
>  clock_gettime_return, shift=3D1
>                        ^
>
> This error is not in mainline because commit 28b1a824a4f4 ("arm64: vdso:
> Substitute gettimeofday() with C implementation") rewrote this assembler
> file in C as part of a 25 patch series that is unsuitable for stable.
> Just remove the comma in the clock_gettime_return invocations in 4.19 so
> that GNU as and LLVM's integrated assembler work the same.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> I worded the first sentence the way that I did because correct me if I
> am wrong but it seems that the integrated assembler has no issues with
> the use of commas separating the arguments in a .macro definition as
> that is done everywhere in arch/arm64, just not when there is a single
> parameter with a default value because essentially what it is evaluating
> it to is "clock_gettime_return ,shift=3D1", which according to the GAS
> manual [1] means that "shift" is actually being set to 0 then there is an
> other parameter, when it expects only one.
>
> [1]: After the definition is complete, you can call the macro either as
> =E2=80=98reserve_str a,b=E2=80=99 (with =E2=80=98\p1=E2=80=99 evaluating =
to a and =E2=80=98\p2=E2=80=99 evaluating to
> b), or as =E2=80=98reserve_str ,b=E2=80=99 (with =E2=80=98\p1=E2=80=99 ev=
aluating as the default, in
> this case =E2=80=980=E2=80=99, and =E2=80=98\p2=E2=80=99 evaluating to b)=
.

Ah you are right! I played with IAS a little and it did not have
problem parsing commas between the name and its arguments in a macro
expansion. However, IAS appears to assume an argument with default
value is passed whenever it sees a comma right after the macro name.
It will be fine if the number of following arguments is one less than
the number of parameters specified in the macro definition. Otherwise,
it fails with the reporter error. This happens to macros with multiple
parameters as well. For example, the following code works

```
$ cat foo.s
.macro  foo arg1=3D2, arg2=3D4
        ldr r0, [r1, #\arg1]
        ldr r0, [r1, #\arg2]
.endm

foo, arg2=3D8

$ llvm-mc -triple=3Darmv7a -filetype=3Dobj foo.s -o ias.o
arm-linux-gnueabihf-objdump -dr ias.o

ias.o:     file format elf32-littlearm


Disassembly of section .text:

00000000 <.text>:
   0: e5910001 ldr r0, [r1, #2]
   4: e5910003 ldr r0, [r1, #8]
```

But the the following code fails,

```
$ cat foo.s
.macro  foo arg1=3D2, arg2=3D4
        ldr r0, [r1, #\arg1]
        ldr r0, [r1, #\arg2]
.endm

foo, arg1=3D2, arg2=3D8

$ llvm-mc -triple=3Darmv7a -filetype=3Dobj foo.s -o ias.o
foo.s:6:14: error: too many positional arguments
foo, arg1=3D2, arg2=3D8
```

I will update the commit message accordingly.


> Lastly, Will or Catalin should ack this as an explicitly out of mainline
> patch so that Greg or Sasha can take it. I would put them on the "To:"
> line in addition to Greg and Sasha.
>
> Hopefully this is helpful!

Thanks for the information!

>
> Cheers,
> Nathan
>
> > ---
> >
> > Changes v1 -> v2:
> >   Keep the comma in the macro definition to be consistent with other
> >   definitions.
> >
> > Changes v2 -> v3:
> >   Edit tags.
> >
> >  arch/arm64/kernel/vdso/gettimeofday.S | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/vdso/gettimeofday.S b/arch/arm64/kernel/=
vdso/gettimeofday.S
> > index 856fee6d3512..b6faf8b5d1fe 100644
> > --- a/arch/arm64/kernel/vdso/gettimeofday.S
> > +++ b/arch/arm64/kernel/vdso/gettimeofday.S
> > @@ -227,7 +227,7 @@ realtime:
> >       seqcnt_check fail=3Drealtime
> >       get_ts_realtime res_sec=3Dx10, res_nsec=3Dx11, \
> >               clock_nsec=3Dx15, xtime_sec=3Dx13, xtime_nsec=3Dx14, nsec=
_to_sec=3Dx9
> > -     clock_gettime_return, shift=3D1
> > +     clock_gettime_return shift=3D1
> >
> >       ALIGN
> >  monotonic:
> > @@ -250,7 +250,7 @@ monotonic:
> >               clock_nsec=3Dx15, xtime_sec=3Dx13, xtime_nsec=3Dx14, nsec=
_to_sec=3Dx9
> >
> >       add_ts sec=3Dx10, nsec=3Dx11, ts_sec=3Dx3, ts_nsec=3Dx4, nsec_to_=
sec=3Dx9
> > -     clock_gettime_return, shift=3D1
> > +     clock_gettime_return shift=3D1
> >
> >       ALIGN
> >  monotonic_raw:
> > @@ -271,7 +271,7 @@ monotonic_raw:
> >               clock_nsec=3Dx15, nsec_to_sec=3Dx9
> >
> >       add_ts sec=3Dx10, nsec=3Dx11, ts_sec=3Dx13, ts_nsec=3Dx14, nsec_t=
o_sec=3Dx9
> > -     clock_gettime_return, shift=3D1
> > +     clock_gettime_return shift=3D1
> >
> >       ALIGN
> >  realtime_coarse:
> > --
> > 2.31.1.368.gbe11c130af-goog
> >
