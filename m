Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C9240B85C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhINTwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 15:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhINTwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 15:52:16 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A1BC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:50:58 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id y6so840788lje.2
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mjBgBxRxl/B/hgYFAVarmXVL7ZSA1rZQ3YIq9oI18JM=;
        b=Kn42sJ9l9FIqoh4GcSXKNdcHPoD8Jqpuz5Fnqohi8xHbpuSD99fZUHwP3QS8Dn0Bka
         P0BV6CpM9U4cxDculERycnenh9YOSOfjc15otl8kqabCgLHGT/OWSWvLe0aQtdZLgR1U
         idK2j7QeTsCwgIq+x62xLfEwjOsZzxV55eygusC/1mwPlIFKRDFtnF37CnRw/lDAqL27
         DYISJYGmkw0PE1au34CVh3K0Z0Q/AjCw/dXTUqivi5jdlwdwwXnnICOQNFNv0q6DikNP
         EfaRoM7UEbYFf7Uq7DjGa4WDIIYIAIJ0qvvJuyoBrQDsgUxI6F7jqsbFKLzyjnKZvpoH
         mxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mjBgBxRxl/B/hgYFAVarmXVL7ZSA1rZQ3YIq9oI18JM=;
        b=SvbZoC8d98WC8my1uSUWi0Rn6HwzL2oPYrqTuz572Au9hE2q25jKw8U/Ejw2GhxJax
         vjB/tQxIgLT8vl90quRkYMiWqJAZkeKqaHCT5VG/8kXeDgl1AsJA7tWSHicQwsunbEcp
         ZnvojxY3IQhydBbucd6fXp1u/y4dtZeB7aP0Rf2t1qoPyBkNu+44d9qDAYEniWI7yD19
         EfDjX8Cd9CvhgMhDYLAbsFtrYZ58zwi28zLmmTE7qiWsJHQu5Q7oRvXpEvkWmqeV2KzA
         +NiKjdkfDQ0z1vifOFz7/Q3tAV2L3kyRicd4ncd0oAlnZoDLJO45asRPW71R4ralYqRN
         QVvg==
X-Gm-Message-State: AOAM5330lIzTnLOLL70PuXrlM1CaAfKzaSJek4XKI7yNShPqLtXrz7sB
        6YSL3K6PcVd0gy4DL9PpSbMaQml/V1tIVZNJ/vDp6w==
X-Google-Smtp-Source: ABdhPJxhH+tmzuG796EvukmBg5vtEhNFKWWJvy5/vh8LPGcCc7e9x1k3s9OiQK1nlQm6b3bsL+DQ5G+Ggr37350nA18=
X-Received: by 2002:a2e:750e:: with SMTP id q14mr16729757ljc.338.1631649055525;
 Tue, 14 Sep 2021 12:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
 <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com>
 <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com>
 <CAHk-=wgPupayk3GpwSMtkV5_onFzmmK2g3WmBV1EbSCj+D0eqw@mail.gmail.com>
 <CAKwvOdkab9O5q=DNn643+7HRgTDdD1i201Qi_cSuXYbJbXf1qw@mail.gmail.com> <CAHk-=wjf6ABFwPdsbk2674DwSLQCH0jr7w-BYvG-f2nvRQDqtQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjf6ABFwPdsbk2674DwSLQCH0jr7w-BYvG-f2nvRQDqtQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 14 Sep 2021 12:50:44 -0700
Message-ID: <CAKwvOdk9yqEMLTAxgZNmHgRSww0AnJ-x9qd7HK3v2Vepi1BdLw@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
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

On Tue, Sep 14, 2021 at 12:46 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Sep 14, 2021 at 12:10 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > Isn't the parameter `blksize` of `nbd_set_size` declared as `loff_t`?
>
> So?
>
> I'm not seeing your point.
>
> We've checked the range of it - in loff_t.
>
> So the *value* is already checked, and most definitely fits in 'unsigned long'.
>
> So __ffs() is perfectly fine. It will truncate that loff_t to a sane type.
>
> What is the problem you're trying to solve?

Just making sure __ffs() works as expected should blksize > LONG_MAX
on 32b targets.  I don't see the range check you're referring to.
loff_t is a long long, yeah?
-- 
Thanks,
~Nick Desaulniers
