Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B5C40B872
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 21:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhINT7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 15:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhINT7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 15:59:22 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A789C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:58:04 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id r3so857573ljc.4
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=edx594esEetpbovYxJC0BKmrfmnFRZoGc83fmQOGtYU=;
        b=Ai5hcu7Lb33IoQQz7PYAvlBa5vu0YJnGQdY2K6Ya5ZxVajxC9hiSGS5AtFs/3zOcXR
         HxKE9r8vz0vWGEgG0dXg/BW0cXBZlaetKrVwvdj8Z4lnG7DZx0pLp24h0K2IgX4G45im
         TVleKsbcXnk247tzWLJYQ5Q4g3R/vIxeMhoWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=edx594esEetpbovYxJC0BKmrfmnFRZoGc83fmQOGtYU=;
        b=k5TVXnwp5rk5ckicdJl00JIO5VYWDgIpDmPXBpekE0ugJtpM3Th6/wVL4Cx21ReIYy
         fpPtRIaJCRpjZjUHNQgohdSMGJH7a2Vy/4/3XbT3OPnYE5OqTnj6xCzhLSYh5bq2Clm3
         BP8oTUF8C0Y9GHxA/cm3N7Vllg9zxzjcrZXSJ54oqTt2xVUzVv3x5XBaCXjrsu5c308b
         B+/EySDKAol3wmyx9++4rcEAu7HCVGbx51DU6mm7mgnqnn9N2BQ5HpdrsyKkIGJ/ZAAd
         BiWnbsbO1dhnfjXwBoxt1sAYj7D8GV/zFj1TRINKA8QM3GlOA1ClvQfmDO3qzkf4tZsT
         xQaQ==
X-Gm-Message-State: AOAM531ysgT5X/YWoFXwU+6KxQ/UVgDzM7UQkA85OfV5r29G61Ivo+FO
        yAdq31THTfeMzbZrgsngUVvUaJvr6aIaS+j/L9U=
X-Google-Smtp-Source: ABdhPJyzlImwPdPXkUf/lCTz7OsUH4DuWkB/y3muEfAHqfs0y0PSKW7aF2GsKIYHKAfZ7LUsN2oNqQ==
X-Received: by 2002:a2e:860e:: with SMTP id a14mr17249162lji.215.1631649481592;
        Tue, 14 Sep 2021 12:58:01 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id q5sm1006235lfo.225.2021.09.14.12.57.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 12:57:59 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id k13so942737lfv.2
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:57:59 -0700 (PDT)
X-Received: by 2002:a05:6512:3991:: with SMTP id j17mr3042014lfu.280.1631649479060;
 Tue, 14 Sep 2021 12:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
 <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
 <CAKwvOdkOHxtsRGjZ2Y8x84sBaqWy8t-U3F9UbMiR7h=3_+mtqA@mail.gmail.com>
 <CAHk-=wjUR7FwE5LsZNaoQxrKu2TS7T-=1j8XqZK2miQuEmqf3Q@mail.gmail.com>
 <CAHk-=wgPupayk3GpwSMtkV5_onFzmmK2g3WmBV1EbSCj+D0eqw@mail.gmail.com>
 <CAKwvOdkab9O5q=DNn643+7HRgTDdD1i201Qi_cSuXYbJbXf1qw@mail.gmail.com>
 <CAHk-=wjf6ABFwPdsbk2674DwSLQCH0jr7w-BYvG-f2nvRQDqtQ@mail.gmail.com> <CAKwvOdk9yqEMLTAxgZNmHgRSww0AnJ-x9qd7HK3v2Vepi1BdLw@mail.gmail.com>
In-Reply-To: <CAKwvOdk9yqEMLTAxgZNmHgRSww0AnJ-x9qd7HK3v2Vepi1BdLw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 12:57:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whmcqmpPJQrAw4vX-Z6ePjeydjw7s6tzqzvB=uBp0=6fw@mail.gmail.com>
Message-ID: <CAHk-=whmcqmpPJQrAw4vX-Z6ePjeydjw7s6tzqzvB=uBp0=6fw@mail.gmail.com>
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

On Tue, Sep 14, 2021 at 12:50 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Just making sure __ffs() works as expected should blksize > LONG_MAX
> on 32b targets.  I don't see the range check you're referring to.
> loff_t is a long long, yeah?

Christ Nick.

Stop wasting my time.

Read the patch:

        if (!blksize)
-               blksize = NBD_DEF_BLKSIZE;
+               blksize = 1u << NBD_DEF_BLKSIZE_BITS;
        if (blksize < 512 || blksize > PAGE_SIZE || !is_power_of_2(blksize))
                return -EINVAL;

        nbd->config->bytesize = bytesize;
-       nbd->config->blksize = blksize;
+       nbd->config->blksize_bits = __ffs(blksize);

See that range check?

Seriously, I've now replied several times to you just because you were
too damn lazy to just look three lines up from the __ffs() that you
reacted to, when I explicitly mentioned the range check several times,
including in the original submission, and when it was RIGHT THERE IN
THE PATCH IN THE ONLY PLACE THAT DID THAT __FFS.

(Ok, so the lower check of range was 512, not 1024, sue me).

It was all there in the diff all the time.

Don't email me again about this. At least not without spending the
FIVE SECONDS to look at what the hell you are emailing me about.

           Linus
