Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1F4254159
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgH0I7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 04:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0I7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 04:59:41 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CDAC061264;
        Thu, 27 Aug 2020 01:59:40 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kx11so2254402pjb.5;
        Thu, 27 Aug 2020 01:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knuyGrcnDNfBLfuI860cvzWQlaN7tR5tqLC2/Iy3p5w=;
        b=ofPoQ+whIY+/DjQfkemlCBdXvPWQTU8raav3CrNeAYExt1VYUk8aJd7ejP4zzCnby6
         WPGWGLCLXDHdgRtNIeX2XQyzu2ocY3HPjwKeWiIKZPAEsMpb3hRNbkTcKUPnUQTejHCV
         8yXMt2AyxvGM68hd9YLpKpp784mQKMsZmOeovBLluEuFc3tgk3jmNvB4GYZZfvBdQ6NM
         WTJ0PI2d+CGvc9ZHTbWsmnMJkEzRhSpOsSBpGbsaism1CIH10jOwTjGsHFjgaEwXHSeT
         dSbyjFfSK+Hh1j5QqgjcOSKOVX0MXsdNul+VEHCSHejecYs9bKwQsouQvpGg0yDp047G
         hSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knuyGrcnDNfBLfuI860cvzWQlaN7tR5tqLC2/Iy3p5w=;
        b=ZMdKw6rGLdR/oogvgPdl0tf1Ki433QPEX0NOOz7fMIS/HjOt1ye66LeVFBLGuvaNND
         MfW1jtm0pDocEzI9azC/inXMTzEAmSz79Y6mw8eKot/LOUVbsiQqDfy6wDXnoKrwku0N
         +y4uePck2jHcr5iqSSlLiXzTDQgDs4BASkZEdsophU65EZsRN9362sPLZq5cO8m4khMM
         TH3tXzcV7jL2lieDT5EDC9llcRqz7iO6cb6+BxI0Wf45tlxzx7W/MbRuBEWXCJxi7kP3
         F0uLDFR0Gaaw6jSkOZWk3Tl5AbiWJdzPHD4cGHNgNMsIwzxYYNyLJZD7euVsKi84LLln
         q8eA==
X-Gm-Message-State: AOAM531cZKXujFOtLz3/jycXvhR3AHih5gs4MdmobpLfaPKBRm8t10/E
        daNkGdPBhxtKQCCB4kekW2OgtmvMN6C+99xCEPY=
X-Google-Smtp-Source: ABdhPJy7h7WBhdI26SwG260T0djY4/8Ef5iftULOB0OMZ64TrwMD0uf7c3K2CJDKKTZF6Bc2Ow1XW8d5cUdgagiDZh8=
X-Received: by 2002:a17:90b:509:: with SMTP id r9mr10116299pjz.228.1598518780491;
 Thu, 27 Aug 2020 01:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200825135838.2938771-1-ndesaulniers@google.com>
 <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
 <d56bf7b93f7a28c4a90e4e16fd412e6934704346.camel@perches.com>
 <CAKwvOd=YrVtPsB7HYPO0N=K7QJm9KstayqqeYQERSaGtGy2Bjg@mail.gmail.com>
 <CAK7LNAQKwOo=Oas+7Du9+neSm=Ev6pxdPV7ges7eEEpW+jh8Ug@mail.gmail.com> <202008261627.7B2B02A@keescook>
In-Reply-To: <202008261627.7B2B02A@keescook>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 27 Aug 2020 11:59:24 +0300
Message-ID: <CAHp75VfniSw3AFTyyDk2OoAChGx7S6wF7sZKpJXNHmk97BoRXA@mail.gmail.com>
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

On Thu, Aug 27, 2020 at 2:40 AM Kees Cook <keescook@chromium.org> wrote:
> On Thu, Aug 27, 2020 at 07:59:45AM +0900, Masahiro Yamada wrote:
> > On Thu, Aug 27, 2020 at 1:58 AM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > > On Wed, Aug 26, 2020 at 9:57 AM Joe Perches <joe@perches.com> wrote:
> > > > On Thu, 2020-08-27 at 01:49 +0900, Masahiro Yamada wrote:
> > > > > I do not have time to keep track of the discussion fully,
> > > > > but could you give me a little more context why
> > > > > the usage of stpcpy() is not recommended ?
> > > > >
> > > > > The implementation of strcpy() is almost the same.
> > > > > It is unclear to me what makes stpcpy() unsafe..
> > >
> > > https://lore.kernel.org/lkml/202008150921.B70721A359@keescook/
> > >
> > > >
> > > > It's the same thing that makes strcpy unsafe:
> > > >
> > > > Unchecked buffer lengths with no guarantee src is terminated.
> > >
> >
> >
> > OK, then stpcpy(), strcpy() and sprintf()
> > have the same level of unsafety.
>
> Yes. And even snprintf() is dangerous because its return value is how
> much it WOULD have written, which when (commonly) used as an offset for
> further pointer writes, causes OOB writes too. :(
> https://github.com/KSPP/linux/issues/105
>
> > strcpy() is used everywhere.
>
> Yes. It's very frustrating, but it's not an excuse to continue
> using it nor introducing more bad APIs.

strcpy() is not a bad API for the cases when you know what you are
doing. A problem that most of the developers do not know what they are
doing.
No need to split everything to bad and good by its name or semantics,
each API has its own pros and cons and programmers must use their
brains.

>
> $ git grep '\bstrcpy\b' | wc -l
> 2212
> $ git grep '\bstrncpy\b' | wc -l
> 751
> $ git grep '\bstrlcpy\b' | wc -l
> 1712
>
> $ git grep '\bstrscpy\b' | wc -l
> 1066
>
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy
> https://github.com/KSPP/linux/issues/88
>
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> https://github.com/KSPP/linux/issues/89
>
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> https://github.com/KSPP/linux/issues/90
>
> We have no way right now to block the addition of deprecated API usage,
> which makes ever catching up on this replacement very challenging. The
> only way we caught up with VLA removal was because of -Wvla on sfr's
> -next builds.
>
> I guess we could set up a robot to just watch -next commits and yell
> about new instances, but patches come and go -- I worry it'd be noisy...
>
> > I am not convinced why only stpcpy() should be hidden.
>
> Because nothing uses it right now. It's only the compiler suddenly now
> trying to use it directly...
>
> --
> Kees Cook



-- 
With Best Regards,
Andy Shevchenko
