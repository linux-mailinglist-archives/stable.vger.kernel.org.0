Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C923254FB7
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 22:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgH0UGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 16:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgH0UF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 16:05:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04715C061264;
        Thu, 27 Aug 2020 13:05:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t9so4338172pfq.8;
        Thu, 27 Aug 2020 13:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ub0Bu40C+ajnp8gPyXN/uxHJUWCLLoo1qQzKb0q6mUo=;
        b=A0KhOfe6ikHXNKVmF6lIQ21Vr37zlOWg3aJOtOhEDEo6Afmow90W6VhvEQ246rByz1
         y/3WXUJLwyDBM9x/eKFpZq+w4O17qd48DFV5KTy1jNjHYH92aqqc84/DoziTrnuVcbZo
         m1dTyWzLvcGox/SwHFhNjGYEnpWtl7TumXpk7lH+lfccVn6ya3kwniERvCTG2Squ/UKK
         9y+x7UvskPqvGgH+DD1SCDXezncIvGqpsrXC++y2CJ1onyCbGMBs0Gl+dUYAyYVYLZhK
         qaAcbXL0GzbtEEvx9E0qeE0rRxiPdDF8l2gctpM5MDe1F6glwLSagFVinkisblldgAF0
         RFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ub0Bu40C+ajnp8gPyXN/uxHJUWCLLoo1qQzKb0q6mUo=;
        b=FtqCPHw0acVIrydtJv7EmdCW2wuvngF3MrdoGef+DowlksMXp/Wel4AWBeInrJrikz
         1rcWpyfmxiNH0JlPE2eQ72LGlewqI8HdPj/IuAzR4WrTYirzvfGlIpxy6+GwhNLWP2Ui
         z8zJp8sjVbcTDvN7JdftkjxwY378YsEFbf/qrCA2JSjLvc3kwAPCcqjgh136NLQqYzgG
         iT1BdTirS128E8kylWPN9smP0JN2aCMUwGsQ+F1IJVxpDpsKIDFkk/9UBwbVXJoLuYTn
         GuNCI45eQRv7mj6qf3sWUS33DbYFwKEzQKc88pVXhJAdssiY5fCXyM2eTKITBzZq05rd
         9SFg==
X-Gm-Message-State: AOAM531sCIT1sMZZzUF7yAYDtCbJ1X5qDRgJENF2aki7fgc9NSC27MDF
        hUYkUAFcKn86hSwnzrE6zyvCka/ZVmQfS9/HHv0=
X-Google-Smtp-Source: ABdhPJwpZ2my+v3HNXdDre9rqJ54hiQyrUbuh9IJNNSssBnk+K4yPU2m2kaStY5UFduoxsH0N867X40yZKjlIcjhcoY=
X-Received: by 2002:a63:c543:: with SMTP id g3mr8431840pgd.203.1598558758497;
 Thu, 27 Aug 2020 13:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com>
 <202008261627.7B2B02A@keescook> <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
 <202008271126.2C397BF6D@keescook>
In-Reply-To: <202008271126.2C397BF6D@keescook>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 27 Aug 2020 23:05:42 +0300
Message-ID: <CAHp75VeA6asim81CwxPD7LKc--DEvOWH9fwgQ9Bbb1Xf55OYKw@mail.gmail.com>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
To:     Kees Cook <keescook@chromium.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 9:30 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Aug 27, 2020 at 11:59:24AM +0300, Andy Shevchenko wrote:
> > strcpy() is not a bad API for the cases when you know what you are
> > doing. A problem that most of the developers do not know what they are
> > doing.
> > No need to split everything to bad and good by its name or semantics,
> > each API has its own pros and cons and programmers must use their
> > brains.
>
> I equate "unsafe" or "fragile" with "bad". There's no reason to use our
> brains for remembering what's safe or not when we can just remove unsafe
> things from the available APIs, and/or lean on the compiler to help
> (e.g. CONFIG_FORTIFY_SOURCE).
>
> Most of the uses of strcpy() in the kernel are just copying between two
> known-at-compile-time NUL-terminated character arrays. We had wanted to
> introduce stracpy() for this, but Linus objected to yet more string
> functions. So for now, I'm aimed at removing strlcpy() completely first,
> then look at strcpy() -> strscpy() for cases where target size is NOT
> compile-time known, and then to convert the kernel's strcpy() into
> _requiring_ that source/dest lengths are known at compile time.
>
> And then tackle strncpy(), which is a mess.

In general it's better to have a robust API, but what may go wrong
with the interface where we have no length of  the buffer passed, but
we all know that it's PAGE_SIZE?
So, what's wrong with doing something like
strcpy(buf, "Yes, we know we won't overflow here\n");
?


-- 
With Best Regards,
Andy Shevchenko
