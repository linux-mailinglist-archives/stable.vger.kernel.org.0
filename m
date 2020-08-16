Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841A9245614
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 07:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgHPFWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Aug 2020 01:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgHPFWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Aug 2020 01:22:48 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E65C061786;
        Sat, 15 Aug 2020 22:22:48 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id g1so2767795oop.11;
        Sat, 15 Aug 2020 22:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=PAteESxJKccFpDFj8kKtK40KfGMPkFYwzSmBJNjdRqM=;
        b=pO7oKfEA3vIZbET8ZwFEO8ajqZVw6svyI2G96Q44zR1niQuye4K4ICeGjJ4hAGdZkY
         6S2EXXSelaXw/GvnRdxe4Xn7KMq7a0BWcE5RDNhI24p1bBPb6hr4Mo+ibUbeRDIUvYEq
         qaOJcjkulLHeLJO3hnuRaf8Y1yjfRVq5s4zMc3z1N22EpAhnPOtpAIG7NPV/6P16ESgD
         vDvJJL2aJurL7ge3T4EE3Ip7IHKkAORcihTagKpc8GfIkCtqZcTrnhsXk9S2OJnAXFZ2
         QlQ8DfPWQlMIM/r0fQ2BDrkMJlnyZWeWknmm2cVRoObE54JqVUPWywlbFZBVjTFpgfI2
         Vpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=PAteESxJKccFpDFj8kKtK40KfGMPkFYwzSmBJNjdRqM=;
        b=M2yJtNOWNoHm0FZXh3XRjWm386MJTD5e1o5NYjJ4GpUWBKAa25zcABMvIPR2bIA/cs
         lg9IfUvuh4NilanFnUHkLu9wk1uNVVpgfMCIJjkW3ibdUBBVVreJT72882piubJkHDlG
         gKkj44sw1X53abMucRgzR6ysx8p7H7d+g6+Drj8RCBV/xZW6DcFAZ9tVKAS4jfgdw90n
         /ATVOTq7Odfd9y+eKC556KGj1fcQE25mhleq+TFQB9qVsyyL/anEwH3iyQd2QcCdPsgR
         d8BuWLlRyYZCrKhqwSg8bFT58v70yX8inSRKqbbyqOBX3XuBobAa2cwDhadqI0JwLvSG
         m9RQ==
X-Gm-Message-State: AOAM5320mV1EIczPIlIhXIEkJcOqkZkk2wOYfR3QRoMy6KEJ4vN54Nz6
        WZCG4us4c3zOZ4OaiKfX5i5JeYNY6/tQRAHXkQc=
X-Google-Smtp-Source: ABdhPJwRkt+zx1Zpfx1bwc74WVWvV4ORKtR4reQCPv+pcbDozTUqfeZrHV3MeZ5nRCFXYkZol+fn5b/WrYNX19LMGoA=
X-Received: by 2002:a4a:7b4b:: with SMTP id l72mr7081937ooc.74.1597555366947;
 Sat, 15 Aug 2020 22:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200815014006.GB99152@rani.riverdale.lan> <20200815020946.1538085-1-ndesaulniers@google.com>
 <202008150921.B70721A359@keescook> <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
 <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
 <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com> <20200816001917.4krsnrik7hxxfqfm@google.com>
In-Reply-To: <20200816001917.4krsnrik7hxxfqfm@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 16 Aug 2020 07:22:35 +0200
Message-ID: <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
To:     Fangrui Song <maskray@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 16, 2020 at 2:19 AM 'Fangrui Song' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> On 2020-08-15, 'Nick Desaulniers' via Clang Built Linux wrote:
> >On Sat, Aug 15, 2020 at 2:31 PM Joe Perches <joe@perches.com> wrote:
> >>
> >> On Sat, 2020-08-15 at 14:28 -0700, Nick Desaulniers wrote:
> >> > On Sat, Aug 15, 2020 at 2:24 PM Joe Perches <joe@perches.com> wrote:
> >> > > On Sat, 2020-08-15 at 13:47 -0700, Nick Desaulniers wrote:
> >> > > > On Sat, Aug 15, 2020 at 9:34 AM Kees Cook <keescook@chromium.org> wrote:
> >> > > > > On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
> >> > > > > > LLVM implemented a recent "libcall optimization" that lowers calls to
> >> > > > > > `sprintf(dest, "%s", str)` where the return value is used to
> >> > > > > > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> >> > > > > > in parsing format strings.  Calling `sprintf` with overlapping arguments
> >> > > > > > was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
> >> > > > > >
> >> > > > > > `stpcpy` is just like `strcpy` except it returns the pointer to the new
> >> > > > > > tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
> >> > > > > > one statement.
> >> > > > >
> >> > > > > O_O What?
> >> > > > >
> >> > > > > No; this is a _terrible_ API: there is no bounds checking, there are no
> >> > > > > buffer sizes. Anything using the example sprintf() pattern is _already_
> >> > > > > wrong and must be removed from the kernel. (Yes, I realize that the
> >> > > > > kernel is *filled* with this bad assumption that "I'll never write more
> >> > > > > than PAGE_SIZE bytes to this buffer", but that's both theoretically
> >> > > > > wrong ("640k is enough for anybody") and has been known to be wrong in
> >> > > > > practice too (e.g. when suddenly your writing routine is reachable by
> >> > > > > splice(2) and you may not have a PAGE_SIZE buffer).
> >> > > > >
> >> > > > > But we cannot _add_ another dangerous string API. We're already in a
> >> > > > > terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. This
> >> > > > > needs to be addressed up by removing the unbounded sprintf() uses. (And
> >> > > > > to do so without introducing bugs related to using snprintf() when
> >> > > > > scnprintf() is expected[4].)
> >> > > >
> >> > > > Well, everything (-next, mainline, stable) is broken right now (with
> >> > > > ToT Clang) without providing this symbol.  I'm not going to go clean
> >> > > > the entire kernel's use of sprintf to get our CI back to being green.
> >> > >
> >> > > Maybe this should get place in compiler-clang.h so it isn't
> >> > > generic and public.
> >> >
> >> > https://bugs.llvm.org/show_bug.cgi?id=47162#c7 and
> >> > https://bugs.llvm.org/show_bug.cgi?id=47144
> >> > Seem to imply that Clang is not the only compiler that can lower a
> >> > sequence of libcalls to stpcpy.  Do we want to wait until we have a
> >> > fire drill w/ GCC to move such an implementation from
> >> > include/linux/compiler-clang.h back in to lib/string.c?
> >>
> >> My guess is yes, wait until gcc, if ever, needs it.
> >
> >The suggestion to use static inline doesn't even make sense. The
> >compiler is lowering calls to other library routines; `stpcpy` isn't
> >being explicitly called.  Even if it was, not sure we want it being
> >inlined.  No symbol definition will be emitted; problem not solved.
> >And I refuse to add any more code using `extern inline`.  Putting the
> >definition in lib/string.c is the most straightforward and avoids
> >revisiting this issue in the future for other toolchains.  I'll limit
> >access by removing the declaration, and adding a comment to avoid its
> >use.  But if you're going to use a gnu target triple without using
> >-ffreestanding because you *want* libcall optimizations, then you have
> >to provide symbols for all possible library routines!
>
> Adding a definition without a declaration for stpcpy looks good.
> Clang LTO will work.
>
> (If the kernel does not want to provide these routines,
> is http://git.kernel.org/linus/6edfba1b33c701108717f4e036320fc39abe1912
> probably wrong? (why remove -ffreestanding from the main Makefile) )
>

We had some many issues in arch/x86 where *FLAGS were removed or used
differently and had to re-add them :-(.

So if -ffreestanding is used in arch/x86 and was! used in top-level
Makefile - it makes sense to re-add it back?
( I cannot speak for archs other than x86. )

- Sedat -
