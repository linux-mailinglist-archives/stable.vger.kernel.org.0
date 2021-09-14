Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB340B862
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 21:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhINTyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 15:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhINTyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 15:54:32 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29EAC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:53:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i4so887127lfv.4
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NsfMakvm6dEq+Cti5zZelRli/c6A7AeM6scLzui7Vp0=;
        b=LMiC5mr77Ib3kevM4tzIw7m0cxPHVYtImzQwWdMLxEBNVD6phrFTFeqCHKc9Tyue2j
         ey4J8B56JusAnYzICZVuSWmglbclrLHPDpLqXE/z9m1cdK5q6CxRU3fAZ2FswDveEu+f
         EEFiowGpCzsyiSjJrDQsu44xeGIkRjCofjvf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NsfMakvm6dEq+Cti5zZelRli/c6A7AeM6scLzui7Vp0=;
        b=UIvW8uI2AzwEunyBy7OcwB2HDIlNMGY+MUGBygQuNNCqlZKoFWDYdZmm1rOHjQIKzy
         RvGcKDQodgHnwEGFmNrY5iTrEHwEbuzzqSTMqOErjL6Rw5sAKHu/Fq1NOjTdYPsVwze7
         PlVy4UNi+mYcge/HdwCvIh6WnsmQilTg/uirMOBiXvpoKYACPbTVTHkOoPmgv2LUyDwt
         x9Gc0I9sY3ukcQFYtIsP2ZWu8u1KHPFOBaTX62D/GVsitziZp1PNJdCgQ/YYxmodYi+V
         FQaVUyJpWGnS9/A5cZnhHDzl9c5+eJACLkJ8kHiiv68p6mHT3WcpfqCcd7XFe834tL5N
         5q/A==
X-Gm-Message-State: AOAM532ZjHR62yKpxqNE2wALQ6EPt0T+doVAB24OM+iVOtT+6M4sldFj
        BSvCUt6O4lK4/hfmlktW3FlLMRJL9l+ORtkUoaM=
X-Google-Smtp-Source: ABdhPJwj5LiCNfWP4g/KtyptJzN8mVmK8lBFielDw3gEpnerxSaxp7f9ztv5l1xRpEhx2OULON1S1A==
X-Received: by 2002:a05:6512:e89:: with SMTP id bi9mr13978822lfb.95.1631649192733;
        Tue, 14 Sep 2021 12:53:12 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id c5sm1415723lji.67.2021.09.14.12.53.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 12:53:12 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id bq5so825964lfb.9
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:53:12 -0700 (PDT)
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr14829293lfg.150.1631649191772;
 Tue, 14 Sep 2021 12:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
 <202109141144.1AE2DDB@keescook> <CAHk-=whU_p489R+ZYPh_AehJRQJKp_0oJ3zB73wgCtB_k3vwvA@mail.gmail.com>
 <CAKwvOdnYdhkiYZdRvJSzAA78bMD3aS9oayc4SeeANddgxUsMLQ@mail.gmail.com>
In-Reply-To: <CAKwvOdnYdhkiYZdRvJSzAA78bMD3aS9oayc4SeeANddgxUsMLQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 12:52:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiydA=Oay+NB2m2ewCHpPEcoU51qPFrzsekFoPu7QPtuw@mail.gmail.com>
Message-ID: <CAHk-=wiydA=Oay+NB2m2ewCHpPEcoU51qPFrzsekFoPu7QPtuw@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 12:12 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Tue, Sep 14, 2021 at 11:55 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Btw, these kinds of issues is exactly why I've been hardnosed about
> > 64-bit divides for decades. 64-bit divides on 32-bit machines are
> > *expensive*. It's why I don't like saying "just use '/' and we'll pick
> > up the routines from libgcc".
>
> I was going to ask about the history there; not to derail the thread
> further, but this is a question whose answer is important to me.
>
> Are the helpers from libgcc insufficient?  W

No. The helpers from libgcc are *overly* sufficient.

The reason we strive to avoid libgcc on any relevant architectures is
not because it's not sufficient, it's because it hides problems.

libgcc has all these helpers for things that the kernel simply shouldn't do.

So _not_ linking against it is the thing that traditionally helps us
find problems, because you get things like

  undefined symbol '__udivdi3'

or whatever.

In other words, avoiding libgcc is what protects us from people doing
(some) stupid things.

          Linus
