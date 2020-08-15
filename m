Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4743824543C
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgHOWRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgHOWRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 18:17:51 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A71C061786
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 15:17:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y10so4133145plr.11
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 15:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cyp9kIv6qMIcFE2qdHMexk3h45R1hTJMbabxmKvKOOQ=;
        b=M9w7CiNQ1Eaom7klg4evZ/xHtzZQe125/dTYvruGKA/lL0RG1wT6rCxfZzBp/nqh5E
         CkJrHaBeNb+eJ4uQH9UZ3sk1gHz5gcsAJy7NSS/YIfjbRn/DAL+ubvqOj99Kp2veZBSG
         XFLZ20wlxoTvaqCKtmZP8PgkNSJ4WBLz7p/LAlAT7gp8TKC0u5bqlDc+p5H5FDqNg+/0
         n2I01hp1TQGcKgyYfuoM9rlzlNUrsQEYwyqr1y0sryQXuiiWPzIyQ8x9cAUd0ih7/hvU
         5t8NaFqV/vB29T3ru9Vte4G0HQSuOY+oElz7iH9Re2OTMmYK7FxHo3lez/tVbImogNfD
         y4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cyp9kIv6qMIcFE2qdHMexk3h45R1hTJMbabxmKvKOOQ=;
        b=HS8j5PLd0DFfKnSoyWfskhxf6Eb1qv5Z4OAG67gKk2UBhQxA43zx0ubTiWIlXNH109
         Gf1Qn9xcp+2n0zImuN4CLRNkzLOLTZMd6ThmUG20g0RPjfXj3HXSm9lzjg4jOKndfnMt
         eq2p1YVdcSZLrz/IBnB7PPB/XtLuoi67iRagtnN/ca+dDKPAEV4KuVKx98v654am8PY0
         OlsE3Ct53GR2XBoawt9SliHxiK5YCMMu+5CBgOqq1azWBIkZyJ9TKDF1HXRanORRa6hu
         ieTq3fi5g20h2KBGC1r+GhT8szEcAgpwK/5boQE/oiE5CdzAuKs8HIPR+IHgtrmbjR0k
         ecrQ==
X-Gm-Message-State: AOAM533hOBetll7eexYlO+x64trtDPkj971qP1RQ52ukRsnShh0UAJEd
        UzGGCsT2kpXCpJwWj5YgbyuaT6GVaPglAwQ1FMmhrg==
X-Google-Smtp-Source: ABdhPJzpmka1iHTSqa9O2mnCopmvu/YpiL1ZLiQX8vmMR5O11xwQ7jo5L3YKa7CaRoOxtLbe4SqOotUUyWWVnbIr44E=
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr7177172pjp.32.1597529870544;
 Sat, 15 Aug 2020 15:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200815014006.GB99152@rani.riverdale.lan> <20200815020946.1538085-1-ndesaulniers@google.com>
 <202008150921.B70721A359@keescook> <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com> <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
In-Reply-To: <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Sat, 15 Aug 2020 15:17:39 -0700
Message-ID: <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
To:     Joe Perches <joe@perches.com>
Cc:     Kees Cook <keescook@chromium.org>,
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

On Sat, Aug 15, 2020 at 2:31 PM Joe Perches <joe@perches.com> wrote:
>
> On Sat, 2020-08-15 at 14:28 -0700, Nick Desaulniers wrote:
> > On Sat, Aug 15, 2020 at 2:24 PM Joe Perches <joe@perches.com> wrote:
> > > On Sat, 2020-08-15 at 13:47 -0700, Nick Desaulniers wrote:
> > > > On Sat, Aug 15, 2020 at 9:34 AM Kees Cook <keescook@chromium.org> wrote:
> > > > > On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
> > > > > > LLVM implemented a recent "libcall optimization" that lowers calls to
> > > > > > `sprintf(dest, "%s", str)` where the return value is used to
> > > > > > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> > > > > > in parsing format strings.  Calling `sprintf` with overlapping arguments
> > > > > > was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
> > > > > >
> > > > > > `stpcpy` is just like `strcpy` except it returns the pointer to the new
> > > > > > tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
> > > > > > one statement.
> > > > >
> > > > > O_O What?
> > > > >
> > > > > No; this is a _terrible_ API: there is no bounds checking, there are no
> > > > > buffer sizes. Anything using the example sprintf() pattern is _already_
> > > > > wrong and must be removed from the kernel. (Yes, I realize that the
> > > > > kernel is *filled* with this bad assumption that "I'll never write more
> > > > > than PAGE_SIZE bytes to this buffer", but that's both theoretically
> > > > > wrong ("640k is enough for anybody") and has been known to be wrong in
> > > > > practice too (e.g. when suddenly your writing routine is reachable by
> > > > > splice(2) and you may not have a PAGE_SIZE buffer).
> > > > >
> > > > > But we cannot _add_ another dangerous string API. We're already in a
> > > > > terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. This
> > > > > needs to be addressed up by removing the unbounded sprintf() uses. (And
> > > > > to do so without introducing bugs related to using snprintf() when
> > > > > scnprintf() is expected[4].)
> > > >
> > > > Well, everything (-next, mainline, stable) is broken right now (with
> > > > ToT Clang) without providing this symbol.  I'm not going to go clean
> > > > the entire kernel's use of sprintf to get our CI back to being green.
> > >
> > > Maybe this should get place in compiler-clang.h so it isn't
> > > generic and public.
> >
> > https://bugs.llvm.org/show_bug.cgi?id=47162#c7 and
> > https://bugs.llvm.org/show_bug.cgi?id=47144
> > Seem to imply that Clang is not the only compiler that can lower a
> > sequence of libcalls to stpcpy.  Do we want to wait until we have a
> > fire drill w/ GCC to move such an implementation from
> > include/linux/compiler-clang.h back in to lib/string.c?
>
> My guess is yes, wait until gcc, if ever, needs it.

The suggestion to use static inline doesn't even make sense. The
compiler is lowering calls to other library routines; `stpcpy` isn't
being explicitly called.  Even if it was, not sure we want it being
inlined.  No symbol definition will be emitted; problem not solved.
And I refuse to add any more code using `extern inline`.  Putting the
definition in lib/string.c is the most straightforward and avoids
revisiting this issue in the future for other toolchains.  I'll limit
access by removing the declaration, and adding a comment to avoid its
use.  But if you're going to use a gnu target triple without using
-ffreestanding because you *want* libcall optimizations, then you have
to provide symbols for all possible library routines!
-- 
Thanks,
~Nick Desaulniers
