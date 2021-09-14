Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85340B725
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhINStz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhINSty (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:49:54 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C8C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:48:36 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id i28so430478ljm.7
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cvy/3cks7+AuDHThaVCr3UhYuSpZtaPh/ikUmHeeXhY=;
        b=hocWtyfAC0qLzU9IRZfRW2zgutMT4k840BOcq6knAFFTggyPI4Hd9Vo/+WPPFiIy9p
         9fgdgt1g1ltDXstVcb+3kXtEig6vMf2rEOBNAeGcrPZGjZGH5zACgRKuFKfpA+otOkk1
         y60/ZvGQqUnSPr9zmPRfACmbfXbAzSWSuIUks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cvy/3cks7+AuDHThaVCr3UhYuSpZtaPh/ikUmHeeXhY=;
        b=YIJ0NyG/ZgBa0Nh9NvmSE8IXj2qk7+YirhU2gHN+1BTc2k0WGAi7cL3kz30UxZ3hIu
         x+XXJNlZQaGSatB14PUryYbLA6jUojSpon4KABjN9gdqdCZ/2u8bfto0gpYAnD6UQp6u
         JeF9qAXKJTGJomiiJ2B9B5gvK7G5TCc3n2g1e16nmbDg9prJDXE3VKFXroipt6tx01Iv
         mT9i2QcWusdKMsa8ceY0/DJVulhHFDnBxPfDYR1XCT3GXgg7LpGEaQFdOJUcJvP7mC1o
         P9FRIs+mSRw43H8xV9f3I6IkOcljOXNKqMOoWwQP+HalMO3Y86yuPO/CZU1BvqaR6Bgs
         7lgA==
X-Gm-Message-State: AOAM5318EA/1yLpH+JIEIatzh7XX22cQCuWsItwWIDyn6oaB/B9QRAOy
        xcDCf/5kc5QwhurgUZxx/uOmieT6pIHIvo5Lric=
X-Google-Smtp-Source: ABdhPJwzLBt6PvUDKROmAKD2fiYaXoUF1zNePk+JF97u+4dehajZDLUCdU9K+o2BemDIx60JISyQ3Q==
X-Received: by 2002:a2e:9cc2:: with SMTP id g2mr15989999ljj.491.1631645315141;
        Tue, 14 Sep 2021 11:48:35 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id b19sm1179669lfb.135.2021.09.14.11.48.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:48:35 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id k4so469249lfj.7
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:48:34 -0700 (PDT)
X-Received: by 2002:a05:6512:3991:: with SMTP id j17mr2829477lfu.280.1631645314444;
 Tue, 14 Sep 2021 11:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com> <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com>
In-Reply-To: <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 11:48:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com>
Message-ID: <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Nick Desaulniers <ndesaulniers@google.com>
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

On Tue, Sep 14, 2021 at 11:45 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Any issues passing an loff_t (aka long long) to __ffs which expects an
> unsigned long for ilp32 targets?

No.

We literally _just_ checked that the value is a power-of-two, and that
it's in the range [1024, PAGE_SIZE].

There was never anything "loff_t" about bitmask at any point.

> Any issues modifying the sysfs interface? Perhaps something in
> userspace relies on parsing those strings?

See my comment about how it could use DEFINE_SHOW_ATTRIBUTE() to
always show the bits as a value.

But it's not even sysfs. It's debugfs. So nobody _should_ have relied
on any of this anyway.

Of course, "should have" is just a dream world - but the point is that
if somebody complains, it's very fixable.

           Linus
