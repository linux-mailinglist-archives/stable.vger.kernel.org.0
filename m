Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F88B245846
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 17:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbgHPPCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Aug 2020 11:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgHPPC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Aug 2020 11:02:26 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D614C061786;
        Sun, 16 Aug 2020 08:02:24 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id s23so10585960qtq.12;
        Sun, 16 Aug 2020 08:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yw1Hg3YiuW4Axw2+s5MR8uBtZOL99Paku5YKL39/E/o=;
        b=NITocUg8oj4ejdwrruQJ4mfW1DZ1QiFs/Yz+46KBlUt+O6tvhntiizyyB1n5OLAyHY
         t4DJS/Fae4SBnSkTvQu1Ysx0/H16JZ9XNVRrr4eWsBJclP/d4wvX5h0hOQkiEqDPShS7
         Gq/HA4slswlSYEtZ0HdOn2ZxZLdoNQbaMwxiXM8UQWD0i9G1u7BtMECDFrY0hiMXQ55q
         vHWd7Ne3pBSM+bRiE0bbn5MKOGoJuGi4sXPqenIHwYknr8hNvWtmmLk20Ibiv+A48D7Z
         X2E7mWPFptqKiV7qlD2h7HMsyau/N9oHA3YwPeWI52aQV2f1mstqkLtdi3AJhS7cU/lx
         0JUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yw1Hg3YiuW4Axw2+s5MR8uBtZOL99Paku5YKL39/E/o=;
        b=JWblACco42zDWNafe3Xb2Ix8FEI0TmBlFFnZjWZI+02STBDDr7Lc84WS8kcgZMZ/c6
         3llMTsF5AT+vbTbruXq4h2X2cdTJ8LrjeAFDsPy0TM3aO0ca9l3VGpQ9LR1Q7D/VMiHS
         vYmKG/IB1/iftaSS0MO0OZg4jTbzky4TbjDB8rH56Dgk49ig0YUxYiTDj6tD9L5eZnvE
         jj6pmw6ofuwvrYmgWn8nI4M9FNLSsoYLN+MxRBT/rjPHZqb3Q2mr5rdFdGNPujozXowF
         6p1v8XZo/zGi+OgRl7CF9hnnqRA/kwdcFgxzYNRc5P2jQe47LSmESuVIix2128eBn5D6
         AR+Q==
X-Gm-Message-State: AOAM531pL2kJcZw9ukCkHz/7B5QsSdYgDut2PdBNXSnKAPRNLHnugSRc
        eJYR2PowqH4uOYY+sr8/8eE=
X-Google-Smtp-Source: ABdhPJyi1Ths8h43k7ohyjY5Iuz56G1sd5h6PQeosLI12oHRimut945jhqVOnG1fAI+JG7INAhAAsQ==
X-Received: by 2002:ac8:454b:: with SMTP id z11mr10193757qtn.350.1597590140648;
        Sun, 16 Aug 2020 08:02:20 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id g3sm15663502qtq.70.2020.08.16.08.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 08:02:19 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sun, 16 Aug 2020 11:02:17 -0400
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
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
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Message-ID: <20200816150217.GA1306483@rani.riverdale.lan>
References: <20200815014006.GB99152@rani.riverdale.lan>
 <20200815020946.1538085-1-ndesaulniers@google.com>
 <202008150921.B70721A359@keescook>
 <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
 <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
 <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
 <20200816001917.4krsnrik7hxxfqfm@google.com>
 <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 16, 2020 at 07:22:35AM +0200, Sedat Dilek wrote:
> On Sun, Aug 16, 2020 at 2:19 AM 'Fangrui Song' via Clang Built Linux
> <clang-built-linux@googlegroups.com> wrote:
> >
> > Adding a definition without a declaration for stpcpy looks good.
> > Clang LTO will work.
> >
> > (If the kernel does not want to provide these routines,
> > is http://git.kernel.org/linus/6edfba1b33c701108717f4e036320fc39abe1912
> > probably wrong? (why remove -ffreestanding from the main Makefile) )
> >
> 
> We had some many issues in arch/x86 where *FLAGS were removed or used
> differently and had to re-add them :-(.
> 
> So if -ffreestanding is used in arch/x86 and was! used in top-level
> Makefile - it makes sense to re-add it back?
> ( I cannot speak for archs other than x86. )
> 
> - Sedat -

-ffreestanding disables _all_ builtins and libcall optimizations, which
is probably not desirable. If we added it back, we'd need to also go
back to #define various string functions to the __builtin versions.

Though I don't understand the original issue, with -ffreestanding,
sprintf shouldn't have been turned into strcpy in the first place.

32-bit still has -ffreestanding -- I wonder if that's actually necessary
any more?

Why does -fno-builtin-stpcpy not work with clang LTO? Isn't that a
compiler bug?

Thanks.
