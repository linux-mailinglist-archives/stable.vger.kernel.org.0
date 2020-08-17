Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E89E246DD2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389539AbgHQRPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389501AbgHQRO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 13:14:56 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088EDC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 10:14:56 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id jp10so18670846ejb.0
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 10:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3HRH4wla07jht+Skbj8wFO6vqCAFqpa7H6BM6x87yVg=;
        b=dqDBE4cR++KAZZ5hLmGT6aqmpeeGLsderydI/lunO905KBRozODliRGNiJIhHiF5h0
         F9m8FoKTci5UAxC4rCkJJja5uT4Tz1VvH6G528LJ75HmWo3ozbnCZ3un5IO0DXA50eVM
         zf5syXmgrNl5UuZLcxear/pdEnGpWozETr/QN/cUlj66AqeR/1+NM0IVrrbDx8CloZ6Z
         PVgtO0sGyR2rXkCu9mJvuaI8+7F/AxmsSGnQ5j4zcYpk+9TNvq88ZM4mVEZwTsBCcIet
         z82hsl+acS9ITMvrQt7bY0NM4JT4vrTZSKsMgpfRaDyRu+ghuNDgJmWVTty+OvQ4MFy3
         OfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3HRH4wla07jht+Skbj8wFO6vqCAFqpa7H6BM6x87yVg=;
        b=DnYFgrnPSWvTgYEFOoRbXF6+cxhSig+Eht0tyI+9CWnLLV64VWLvkmQDgEV+aSDq6a
         6e7CqEAyMNzyA3jKtu2K6/ogmi/Pp9bIQITNBnauM825dAHG/JiBjtnR/1qlSYYy3ExD
         gytWy2lIyPKqCoC9SvcQNfa9gsWRwT9gmDbl1myWYtyWqbIKR+dnzHTIRYe2qMmxL6Pi
         vIXJJi9IjYan+BOb34MQw0sjPAe1E9bFQcwsggxGl6EPcjj4YwqZU1mb6QrTpqy2CjGZ
         GaKaRD5C31yl0Ut7znRhOppn6qIze3k5nSrwz1pGuuRU2idKK9Ydg7Pf8Qh26PaMDf0x
         D2ZQ==
X-Gm-Message-State: AOAM530bmW+e0Onw1FoVUJ5b/xUGkgKcnNJECybW4klKAhdVHWiMNV89
        9RRMCWeqw/nA2a7K6SoKxhDQtRF5laNIZkD4YJz5Rw==
X-Google-Smtp-Source: ABdhPJyKHR5Mdvurt/PpCfpAL7T67WQ33FTGWP0iLP80KXwPMohlRdvQKDLY5ncwnlLyNJlKI+K/D519Z8mHnFX111w=
X-Received: by 2002:a17:906:2356:: with SMTP id m22mr15726038eja.124.1597684494511;
 Mon, 17 Aug 2020 10:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200815014006.GB99152@rani.riverdale.lan> <20200815020946.1538085-1-ndesaulniers@google.com>
 <202008150921.B70721A359@keescook> <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
 <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
 <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
 <20200816001917.4krsnrik7hxxfqfm@google.com> <CA+icZUW=rQ-e=mmYWsgVns8jDoQ=FJ7kdem1fWnW_i5jx-6JzQ@mail.gmail.com>
 <20200816150217.GA1306483@rani.riverdale.lan>
In-Reply-To: <20200816150217.GA1306483@rani.riverdale.lan>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Mon, 17 Aug 2020 10:14:43 -0700
Message-ID: <CABCJKucsXufD6rmv7qQZ=9kLC7XrngCJkKA_WzGOAn-KfcObeA@mail.gmail.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
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

On Sun, Aug 16, 2020 at 8:02 AM Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Sun, Aug 16, 2020 at 07:22:35AM +0200, Sedat Dilek wrote:
> > On Sun, Aug 16, 2020 at 2:19 AM 'Fangrui Song' via Clang Built Linux
> > <clang-built-linux@googlegroups.com> wrote:
> > >
> > > Adding a definition without a declaration for stpcpy looks good.
> > > Clang LTO will work.
> > >
> > > (If the kernel does not want to provide these routines,
> > > is http://git.kernel.org/linus/6edfba1b33c701108717f4e036320fc39abe1912
> > > probably wrong? (why remove -ffreestanding from the main Makefile) )
> > >
> >
> > We had some many issues in arch/x86 where *FLAGS were removed or used
> > differently and had to re-add them :-(.
> >
> > So if -ffreestanding is used in arch/x86 and was! used in top-level
> > Makefile - it makes sense to re-add it back?
> > ( I cannot speak for archs other than x86. )
> >
> > - Sedat -
>
> -ffreestanding disables _all_ builtins and libcall optimizations, which
> is probably not desirable. If we added it back, we'd need to also go
> back to #define various string functions to the __builtin versions.
>
> Though I don't understand the original issue, with -ffreestanding,
> sprintf shouldn't have been turned into strcpy in the first place.
>
> 32-bit still has -ffreestanding -- I wonder if that's actually necessary
> any more?
>
> Why does -fno-builtin-stpcpy not work with clang LTO? Isn't that a
> compiler bug?

I just confirmed that adding -fno-builtin-stpcpy to KBUILD_CFLAGS does
work with LTO as well.

Sami
