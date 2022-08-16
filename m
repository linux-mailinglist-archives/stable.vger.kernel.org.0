Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD3959607E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiHPQmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiHPQmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:42:13 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5AF80B6E
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:42:12 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t5so14213797edc.11
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=08l0+3c88RLyjBCzBV+yKo0+Z/gNc2HQkPhw2wIPxWM=;
        b=J3rnkn5EuesoyajpYqKDI9XRMUmQSi5XjRu8ZpAahaIi7B4uy6ChuzK/pLcqUlJPpy
         mD6ehJVoK8yXUOJolOTet6MchgS5was5NEos4yrbVHlfF7O+oheJohdaD5QbA11k+svC
         N9dqrvr4CVI59jxgn0u8cGTGEdTNL1G5JURKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=08l0+3c88RLyjBCzBV+yKo0+Z/gNc2HQkPhw2wIPxWM=;
        b=U6QS+HQ0OwIksFY9uuOqQcQ3gEGgN2h/T8Hpq0O9f6+NsjY0FnP82zpEQF+1XdcG5f
         O6pFcys3QS5cwzenKHVVBrzTpxZTng+ejQp6rd7oqZ685BDxaBVcMsZwZlAThD+0ZOyY
         EPKORuNagR0iMJ+qQL4R1G3ivkkEfGViBUhK76DjCdp31q6azlPnO0wndhiVHsFhelMr
         BK09qTBG/+NJbY/Ej2shh8KlyefBx6xqV+Qoojy7AUvwAezS2fwqxwfiYK/F1gmwd77u
         ReKL/kyXbcnsYtq3cYH42WFU9JYvOY3NHIsDX2K6CsGSVAELmwE0ElvufrRLsLb/Ildj
         uTGA==
X-Gm-Message-State: ACgBeo1Or8Y/VhZ3XZfVNs0PZ/bIDaekN9VsLiNY+LNeqAuSbBBET8hf
        DztXxyDle0clYTsg5nybwiL0fXeUNsgCj5DI08Y=
X-Google-Smtp-Source: AA6agR4Iwt5njC5+3unNcO/vXIX8EioawkApzIWN8m7eaIsijL7fAnHZ5OPUKTcmpGh4o4O/ZCsUYQ==
X-Received: by 2002:aa7:dc0d:0:b0:443:e1ca:bdb1 with SMTP id b13-20020aa7dc0d000000b00443e1cabdb1mr7088663edu.62.1660668130917;
        Tue, 16 Aug 2022 09:42:10 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id y15-20020aa7cccf000000b0043e581c30eesm8712699edt.31.2022.08.16.09.42.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 09:42:09 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id d5so3206033wms.5
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:42:09 -0700 (PDT)
X-Received: by 2002:a7b:c399:0:b0:3a5:f3fb:85e0 with SMTP id
 s25-20020a7bc399000000b003a5f3fb85e0mr6857658wmj.38.1660668128792; Tue, 16
 Aug 2022 09:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <YvqaK3hxix9AaQBO@slm.duckdns.org> <YvsZ6vObgLaDeSZk@gondor.apana.org.au>
 <CAHk-=wgSNiT5qJX53RHtWECsUiFq6d6VWYNAvu71ViOEan07yw@mail.gmail.com> <20220816134156.GB11202@willie-the-truck>
In-Reply-To: <20220816134156.GB11202@willie-the-truck>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 16 Aug 2022 09:41:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgqvApXmXxk42eZK1u5T60aRWnBMeJOs7JwP-+qqLq6zQ@mail.gmail.com>
Message-ID: <CAHk-=wgqvApXmXxk42eZK1u5T60aRWnBMeJOs7JwP-+qqLq6zQ@mail.gmail.com>
Subject: Re: [PATCH] workqueue: Fix memory ordering race in queue_work*()
To:     Will Deacon <will@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Tejun Heo <tj@kernel.org>, marcan@marcan.st,
        peterz@infradead.org, jirislaby@kernel.org, maz@kernel.org,
        mark.rutland@arm.com, boqun.feng@gmail.com,
        catalin.marinas@arm.com, oneukum@suse.com,
        roman.penyaev@profitbricks.com, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 6:42 AM Will Deacon <will@kernel.org> wrote:
>
> > Will?
>
> Right, this looks like it's all my fault, so sorry about that.

It's interesting how this bug has existed for basically four years.

I suspect that the thing is fairly hard to hit in practice,
particularly on the kinds of devices most common (ie limited OoO
windows on most phone SoCs).

Together with phone loads probably not generally being all that
exciting from a kernel standpoint (a lot of driver work, probably not
a lot of workqueue stuff).

>   1. Upgrade test_and_{set,clear}_bit() to have a full memory barrier
>      regardless of the value which is read from memory. The lock/unlock
>      flavours can remain as-is.

I've applied Hector's "locking/atomic: Make test_and_*_bit() ordered
on failure".

>   2. Fix the documentation

That patch had a bit of a fix, but it is probably worth looking at more.

>   3. Figure out what to do about architectures building atomics out of
>      spinlocks (probably ok as lock+unlock == full barrier there?)

Yeah, I wonder how we should describe the memory ordering here. We've
always punted on it, saying it's a "memory barrier", but that has been
partly a "look, that's the traditional x86 model".

And the traditional x86 model really sees the locked RMW operations as
being one single operation - in ways that most other architectures
don't.

So on x86, it's more than "this implies a memory barrier" - it's also
that there is no visible load-modify-store sequence where you can
start asking "what about the ordering of the _load_ wrt the preceding
memory operations".

That makes the x86 behavior very easy to think about, but means that
when you have bitops implemented other ways, you have questions that
are much harder to answer.

So in a Lock+read+op+write+unlock sequence, you can have preceding
operations move into the locked region, and mix with the read+op+write
side.

>   4. Accept my sincerest apologies for the mess!

I don't think you were the source of the mess. The *source* of the
mess is that we've always had very messy rules about the bitops in
particular.

I think the *code* is fixed (at least wrt the generic implementation,
I think the other models are up for discussion), but I think the real
issue is how we should describe the requirements.

So I think we have at least three cases we need to deal with:

 (a) the people who just want atomics, and don't care about any
ordering. They are bound to exist.

 (b) the people who want "acquire"-like semantics. I think the
existing test_and_set_bit_lock() is fine

 (c) the people who want "release"-like semantics, where the
"test-and-set-bit" is for announcing "I'm done, was I the first one?".

 (d) the full barrier case

I think we currently actively have (b) and (d), but it's possible that
the workqueue case really is only (c).

And I think the spinlock implementation really most naturally has that
(c) semantics - you don't necessarily get some theoretical full memory
barrier, but you *do* get those "handover" semantics.

Maybe we never really want or need (d) at all?

So I get the feeling that we really shouldn't specify
"test_and_set_bit()" in terms of memory barriers at all. I *think* it
would be more natural to describe them in terms of "handover" (ie
acquire/release), and then the spinlock semantics are obviously fine.

So I htink the code problem is easy, I think the real problem here has
always been bad documentation, and it would be really good to clarify
that.

Comments?

              Linus
