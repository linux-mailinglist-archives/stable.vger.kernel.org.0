Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67831CE973
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 02:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgELAFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 20:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726077AbgELAFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 20:05:17 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297FBC061A0E
        for <stable@vger.kernel.org>; Mon, 11 May 2020 17:05:17 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f18so11548768lja.13
        for <stable@vger.kernel.org>; Mon, 11 May 2020 17:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5Vj2zQnFxzww1DFlagDjlY/ke7T1Z1ZZyehhz3heRw=;
        b=hcCGC2Hjo9nph3jrRydschmaR9AWBPPm9PAXs2M7D48jJzPcQ/KQADnqlDpnbnJWU2
         FMk/VAczA3dIzQWm/k5t7DbIXUsXBEjJ+AkRztrSEyQksG0iw5ouUugZlBp6wOhhj8E8
         Qjh8V3jCkhFfic+LUce/yQLpldSBlnv4B00B0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g5Vj2zQnFxzww1DFlagDjlY/ke7T1Z1ZZyehhz3heRw=;
        b=FZF/aGj72xhYhFgLkgvXfO+O/vOHM+W73HF+6bMloYQ3tTwl4KL7ONg9J65K7Llbq6
         jsYgotlNad3sXNuS3YHoXfOXyk5LgFH15Ubl9q9k7LApXoLLJK4tCRUKY9rjtUeXPT4s
         gyN9lIyJu3Y8QuwWB163Vt3FSoi03O7QbVNL+1EyXArpFsMT6NDEIL1mVicFqgK4+0HS
         pUx4+Y8ZF+BUFcWEt3piLXcTWhRDY/4U1kQXNVVAivJBiOXVgGiIHZGLIpwyy8D43dSw
         SQySy0QFSnXB3yw2F5Xi7Mi4M5ahXejcdQdAYnczSD5NujfmMasQZXSZCvaiGdOfoAT0
         arFA==
X-Gm-Message-State: AOAM532BGADe52jpT7dtkwxhnNV14mrimKiyYf1odskbAWct8Memh4b4
        evxcHONtvUd1IeofkCxWMYHmQwZ0bf4=
X-Google-Smtp-Source: ABdhPJxgQ86/paLVEtk62jj0s2RLt7SXszQGkD8mgqjg1STQ9Yrg1/gH7FFUtW1cTmm2YpvHm7O8HQ==
X-Received: by 2002:a05:651c:1025:: with SMTP id w5mr2076769ljm.113.1589241914009;
        Mon, 11 May 2020 17:05:14 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id c12sm12247895lfc.92.2020.05.11.17.05.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 17:05:12 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id z22so9065269lfd.0
        for <stable@vger.kernel.org>; Mon, 11 May 2020 17:05:12 -0700 (PDT)
X-Received: by 2002:ac2:5df9:: with SMTP id z25mr12792137lfq.125.1589241912072;
 Mon, 11 May 2020 17:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200508090202.7s3kcqpvpxx32syu@butterfly.localdomain> <20200511215720.303181-1-Jason@zx2c4.com>
In-Reply-To: <20200511215720.303181-1-Jason@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 11 May 2020 17:04:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
Message-ID: <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
Subject: Re: [PATCH v2] Kconfig: default to CC_OPTIMIZE_FOR_PERFORMANCE_O3 for
 gcc >= 10
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 2:57 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> GCC 10 appears to have changed -O2 in order to make compilation time
> faster when using -flto, seemingly at the expense of performance, in
> particular with regards to how the inliner works. Since -O3 these days
> shouldn't have the same set of bugs as 10 years ago, this commit
> defaults new kernel compiles to -O3 when using gcc >= 10.

I'm not convinced this is sensible.

-O3 historically does bad things with gcc. Including bad things for
performance. It traditionally makes code larger and often SLOWER.

And I don't mean slower to compile (although that's an issue). I mean
actually generating slower code.

Things like trying to unroll loops etc makes very little sense in the
kernel, where we very seldom have high loop counts for pretty much
anything.

There's a reason -O3 isn't even offered as an option.

Maybe things have changed, and maybe they've improved. But I'd like to
see actual numbers for something like this.

Not inlining as aggressively is not necessarily a bad thing. It can
be, of course. But I've actually also done gcc bugreports about gcc
inlining too much, and generating _worse_ code as a result (ie
inlinging things that were behind an "if (unlikely())" test, and
causing the likely path to grow a stack fram and stack spills as a
result).

So just "O3 inlines more" is not a valid argument.

              Linus
