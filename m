Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0799D40B696
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhINSPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhINSPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:15:41 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5C8C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:14:23 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id f2so376771ljn.1
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tB+lkmxk3tKI/MJRPQRK4BJvhar4Pog83c0dLCo4qBc=;
        b=APWO50Tu6+F3lchlef1OPW7JWa4s1zf7krPq8+7nfdu8nKvODuqNVZDvNLujK7FWZq
         o+NUizJa6v0F8H516YXhrwdzC/iOXgR9NjarcW/mIVbqdNIfTb/g5I93Ir+JMv3CiWdS
         /+N7QpVFPcfT0W8QgAL8/SJEjEHNyXtFVLpfw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tB+lkmxk3tKI/MJRPQRK4BJvhar4Pog83c0dLCo4qBc=;
        b=aKr4iPx2V46ZNkRt6BLkAh8GJWtF8YGrqmxsSCIb8qa0vXWGUIW5QBsO4+ZSZkuBPK
         6/h9AxziXSnK9hcfQHM/y40qLBfKplvHf0BHstDyq4E0a2qRHsbJv6houHznyRxFeLO/
         lElXRZkkwftn1gg285AayQtp1Vb2Fq4/W0w8hwMam2Wl3l8MzkxrgCMppbCsec+CmHe4
         sAf0BETHrvKmdQ2W1dF1sw3EJ41v9tPcnjcPkimcFJqKHw1IX1F8ca7qnWmUbHEI2EyN
         Gvxk5l9iy/ith8ym2OlqIMJCdXfwOuMiMD2ELfQYg91L7ef3w3HoeARJ8fvo3d9vpZOD
         Z/4A==
X-Gm-Message-State: AOAM5302t6VMyGEOBL9rmeNjqz7H1aopPc2i5hn35VBURLik6ctGuI13
        Ly+2oShvsmfqsUve3omF3rgX9HI+eM1zHyBjc9A=
X-Google-Smtp-Source: ABdhPJxndtLqtO1LpapA0NjTp+nevHlRAV7v0idFbeEDTqMiGPQkPX+XZ1aRZugnm+JMabNqzpCKdg==
X-Received: by 2002:a2e:b88a:: with SMTP id r10mr16604107ljp.362.1631643260483;
        Tue, 14 Sep 2021 11:14:20 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id z25sm1267954lfh.200.2021.09.14.11.14.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:14:18 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id g14so338810ljk.5
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:14:17 -0700 (PDT)
X-Received: by 2002:a2e:96c7:: with SMTP id d7mr16810179ljj.191.1631643257587;
 Tue, 14 Sep 2021 11:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
In-Reply-To: <202109141031.AEFD06F03F@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 11:14:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
Message-ID: <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Kees Cook <keescook@chromium.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
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

On Tue, Sep 14, 2021 at 10:32 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Sep 13, 2021 at 11:05:02PM +0200, Rasmus Villemoes wrote:
> > So, I'd sleep a little better if we got the 64 bit tests commented back
> > in in test_overflow.c, and [assuming that the above would actually make
> > that file build with gcc 4.9] that patch also backported to 5.10, so we
> > had some confidence that the whole house of cards is actually solid.
>
> Yeah, I'm all for that too.

Hmm.

Another thing that might be worth doing is to just say "don't do that".

IOW, don't do silly overflow checks with 64-bit things on 32-bit architectures.

Apparently the first and only use case of this is the ndb code, and
the fact is, that ndb code is just being truly horrendously stupid.

That 'blksize' thing shouldn't be a blocksize, it should be a
blockshift instead. The code to set blksize already expressly verifies
that it's a power-of-2, and less or equial to PAGE_SIZE so this:

        loff_t blksize;

is just plain silly. Doubly silly. Why is it a 'loff_t'? It should
never have been a loff_t in the first place, and honestly, it really
should have been a shift count that fits in a few bits.

All this pain could have been trivially avoided with just people
writing better code, knowing that multiplies and divides are
expensive, and that shift counts are small and cheap.

               Linus
