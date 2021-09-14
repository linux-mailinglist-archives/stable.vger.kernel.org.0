Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2901A40B744
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhINS42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhINS41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:56:27 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2A6C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:55:09 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p29so452940lfa.11
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HAWRHOZnhfc5sJQwmFRR3wNRJqZ8RPcCxQgHb6VmErs=;
        b=MDR8/f38E4BJxRXds0pk7dS579DaATHlNEbmBac6+WXoidZawjqzTuSaacwxz8PEL0
         y7SqugNLK79gw2t3EWNtKI4Q1nSea4QNZPtNeZ18JMI4cqi4zbtBwwMHkOVksXbtLN7T
         +XmrLAa8eReVIxeTPcUXSg8VZa1XN2hq+GeqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HAWRHOZnhfc5sJQwmFRR3wNRJqZ8RPcCxQgHb6VmErs=;
        b=mFeNPE/ZlAK5XYH64LBgPJujbyVryAgG08SMLzeeQnw0+rRRnFtA/Bl7/ytp6p1eLY
         llonseviQMjPN9OI86RJ6O7ifKwBumE3h7rxKlY98tgrQSYlEPIruNPGgavXpm5fEavk
         s0hjHDJ7aR+ELeTHgLI4R6KzXR5/PVGpIflxX0Kw9jV5wpL1nF9MHX9SFZQKwMjes/BK
         CQwwXka+fHaQzOiaZGvPPz8zkvhSvGMmzCbG0elLYiozRbzEvaOadz0ryDfeibs9M7d1
         DQG8YiFSm4iaFXIS8zxMyp/59M6Md4Sxes9NU0VUGXdPWGIxw+T3zOUUp9cg4SbE7XET
         ws5g==
X-Gm-Message-State: AOAM533IEe5Y9KhMoDbDdYy+WY3qIKdYt5ktaYiU3xZpk1Yob6lycozF
        bxzEXINVJ6owPuD4f6jJE9ATU2n178xfthKY36Q=
X-Google-Smtp-Source: ABdhPJwzcv62qqW7S4NgOMtvLiajuoX30DzwFD84h5EWPXy3gzfgE3TfJJAbHT7F1O10SVL6hikuiQ==
X-Received: by 2002:a05:6512:15a1:: with SMTP id bp33mr13772269lfb.122.1631645708031;
        Tue, 14 Sep 2021 11:55:08 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id n4sm1189598lfq.98.2021.09.14.11.55.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:55:07 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id y6so572159lje.2
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:55:07 -0700 (PDT)
X-Received: by 2002:a2e:96c7:: with SMTP id d7mr16954865ljj.191.1631645707082;
 Tue, 14 Sep 2021 11:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com> <202109141144.1AE2DDB@keescook>
In-Reply-To: <202109141144.1AE2DDB@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 11:54:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=whU_p489R+ZYPh_AehJRQJKp_0oJ3zB73wgCtB_k3vwvA@mail.gmail.com>
Message-ID: <CAHk-=whU_p489R+ZYPh_AehJRQJKp_0oJ3zB73wgCtB_k3vwvA@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Kees Cook <keescook@chromium.org>
Cc:     Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nick Desaulniers <ndesaulniers@google.com>,
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

On Tue, Sep 14, 2021 at 11:48 AM Kees Cook <keescook@chromium.org> wrote:
>
> FWIW, it's probably better to avoid open-coding the check. There are
> helpers for shift-left too. :)

I actually looked for them.

But I only did so with a grep for "check_shift_overflow".

Which didn't find anything.

I didn't think anybody would call a shift overflow function "shl",
since a right-shift by definition cannot overflow.

But no complaints about using the oddly named overflow function,
though - it makes it more obvious that the patch is purely about
changing 'blksize' to use a bit count.

Btw, these kinds of issues is exactly why I've been hardnosed about
64-bit divides for decades. 64-bit divides on 32-bit machines are
*expensive*. It's why I don't like saying "just use '/' and we'll pick
up the routines from libgcc".

In almost all real-life cases - at least in a kernel - the full divide
is unnecessary. It's almost always people being silly and lazy, and
the very expensive operation can be avoided entirely (or at least
minimized to something like 64/32).

           Linus
