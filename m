Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AEE40B851
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 21:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhINTr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 15:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhINTr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 15:47:28 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D58C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:46:10 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id p15so802816ljn.3
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x8yJeL9IaeMJNKciVPbI0B3y4VivrodBAJBKdlNt/EY=;
        b=MvIPaYviMa6bUaahGefLg7MqZeyl5u9ob4BwphzBuC0SpT6uFW4ChNga/yMrclrhbR
         rizIHwOMPweM98hVjXEg812jsnx3bpEmMfuQ0N7W1frLnYXSqcUNqsYp4i89XnWBwzpD
         FryiWj7xnM1ptXmRAWwqgMTw8fmKM1jCqbJ8o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x8yJeL9IaeMJNKciVPbI0B3y4VivrodBAJBKdlNt/EY=;
        b=JFtHJZ+l4jVF47aQosn4zGlNPeSO53oNCZKYYL9duAbq4WFB6zVfppIr/jRlZSPoeN
         vRxuUzyArUzD95jKqfZTi9NHmnsv1PsphQOlehXZw6GxHQhcsGew/w4jg8/eHITq1muW
         wFDscJc5zghTgXfI2gaCbqJY3u8mg/UYNB/0fzkjmS/pBjrdfcke08WLcCTcGXtA0Duo
         /CwOzCIsYeK7Ws9ZWiaqdSC4gs7F3zg0XEm3ulO741OWocd8/mS0ToI4eaxnENrr6ZTV
         oOZyMCuhN8VjL+oslY8maJPS01vSfsDoCQLZLnW1TZuvQmNaEVQqb9QOQjkrHy9sM5cf
         cvKw==
X-Gm-Message-State: AOAM532dahPBuWtFsDP6OG/J9VBziLNizReFhuusGA5eUYCTxyuxR6Mb
        IPc1uZVWHgiehjJMgRKkx6elF/Bns6t4kG1XBeY=
X-Google-Smtp-Source: ABdhPJwN4S2lpsR8h1utfxVY0FxFtRrz0tIw/rrCB6Yoeg9bzi020H7LK++KCkXdyv2NnkouH/rgig==
X-Received: by 2002:a05:651c:382:: with SMTP id e2mr17188706ljp.401.1631648767144;
        Tue, 14 Sep 2021 12:46:07 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id x20sm1193152lfu.242.2021.09.14.12.46.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 12:46:06 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id o11so694199ljp.8
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:46:05 -0700 (PDT)
X-Received: by 2002:a2e:96c7:: with SMTP id d7mr17124610ljj.191.1631648765005;
 Tue, 14 Sep 2021 12:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
 <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com>
 <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com>
 <CAHk-=wgPupayk3GpwSMtkV5_onFzmmK2g3WmBV1EbSCj+D0eqw@mail.gmail.com> <CAKwvOdkab9O5q=DNn643+7HRgTDdD1i201Qi_cSuXYbJbXf1qw@mail.gmail.com>
In-Reply-To: <CAKwvOdkab9O5q=DNn643+7HRgTDdD1i201Qi_cSuXYbJbXf1qw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 12:45:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjf6ABFwPdsbk2674DwSLQCH0jr7w-BYvG-f2nvRQDqtQ@mail.gmail.com>
Message-ID: <CAHk-=wjf6ABFwPdsbk2674DwSLQCH0jr7w-BYvG-f2nvRQDqtQ@mail.gmail.com>
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

On Tue, Sep 14, 2021 at 12:10 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Isn't the parameter `blksize` of `nbd_set_size` declared as `loff_t`?

So?

I'm not seeing your point.

We've checked the range of it - in loff_t.

So the *value* is already checked, and most definitely fits in 'unsigned long'.

So __ffs() is perfectly fine. It will truncate that loff_t to a sane type.

What is the problem you're trying to solve?

         Linus
