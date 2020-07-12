Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA4621CBFC
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 01:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgGLXGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 19:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLXGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 19:06:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441A6C061794
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 16:06:40 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so13312159ejq.6
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 16:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yo0Mnk4z2ZKKeclS9nj/V3zBsAaD+8xk/39wn8faHH8=;
        b=JgbUYhmWzr+3//UqU1Ua64whjD+TQo14a7RmhB8c633RX/QOiKcCQbsyY/hFuqiEZ5
         BvLqBjYYHepAIfQNocZKo+mB3oyrODeGszIw3KMFLfUKLJ4N1S+uGMefleAq+uA7OUg5
         DLKYfe4ZuClUyfP06Vewwx33e/+3F2kX7EtpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yo0Mnk4z2ZKKeclS9nj/V3zBsAaD+8xk/39wn8faHH8=;
        b=EwdFTOnHEOk9dH8B7+hrUWX3Oa/wPVFxmjiAlQyo6Vn8tdHzmtjO/ye2laQg+ETdGQ
         OLNmLIZp/1EM2wUT3+JNmhIqNUykEvv5bd66dLSolIgcoVbGMzDLKUUBOkNQyU6eAton
         Nc/yrIxNOdJPj4YEJDdozzvJE2mEOt4MLorYpvRKJ6tjZskFubg4UzRg8zZXyNtYhgkZ
         LkBb7Nkrge+p+FWss1lm1Jqvo7gq5/vkZ2QaLckuiNFX7gc9axb6YJjEWFUtcTY4OFS0
         pLIfj0tLlG4R7LvIonFgGKVuloJnwQKQMQrJrAYsdcC2gW441/j7wEry2fn7vrwA+30F
         96jg==
X-Gm-Message-State: AOAM532FFRioRiIftezc5cDzGWNPgRS+CoYISe50KWFEmm6EMJj51qF7
        ipSpc1Japi1UcNv3IBM7yMfi3q9/GQ8=
X-Google-Smtp-Source: ABdhPJw2vO7+8auiOQBCwOivywlCPDVyZZCeKLQ1jU0uTMVhuDe3ZD/fJ++bn9CRf2YIlewqQrJjyQ==
X-Received: by 2002:a17:906:1a16:: with SMTP id i22mr53616270ejf.439.1594595198441;
        Sun, 12 Jul 2020 16:06:38 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id fi29sm8306022ejb.83.2020.07.12.16.06.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 16:06:38 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id d16so10344889edz.12
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 16:06:37 -0700 (PDT)
X-Received: by 2002:a2e:9c92:: with SMTP id x18mr40507440lji.70.1594594702310;
 Sun, 12 Jul 2020 15:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com> <20200712215041.GA3644504@google.com>
In-Reply-To: <20200712215041.GA3644504@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 12 Jul 2020 15:58:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
Message-ID: <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 12, 2020 at 2:50 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> I reproduced Naresh's issue on a 32-bit x86 machine and the below patch fixes it.
> The issue is solely within execve() itself and the way it allocates/copies the
> temporary stack.
>
> It is actually indeed an overlapping case because the length of the
> stack is big enough to cause overlap. The VMA grows quite a bit because of
> all the page faults that happen due to the copy of the args/env. Then during
> the move of overlapped region, it finds that a PMD is already allocated.

Oh, ok, I think I see.

So the issue is that while move_normal_pmd() _itself_ will be clearing
the old pmd entries when it copies them, the 4kB copies that happened
_before_ this time will not have cleared the old pmd that they were
in.

So we've had a deeper stack, and we've already copied some of it one
page at a time, and we're done with those 4kB entries, but now we hit
a 2MB-aligned case and want to move that down. But when it does that,
it hits the (by now hopefully empty) pmd that used to contain the 4kB
entries we copied earlier.

So we've cleared the page table, but we've simply never called
pgtable_clear() here, because the page table got cleared in
move_ptes() when it did that

                pte = ptep_get_and_clear(mm, old_addr, old_pte);

on the previous old pte entries.

That makes sense to me. Does that match what you see? Because when I
said it wasn't overlapped, I was really talking about that one single
pmd move itself not being overlapped.

> The below patch fixes it and is not warning anymore in 30 minutes of testing
> so far.

So I'm not hugely happy with the patch, I have to admit.

Why?

Because:

> +       /* Ensure the temporary stack is shifted by atleast its size */
> +       if (stack_shift < (vma->vm_end - vma->vm_start))
> +               stack_shift = (vma->vm_end - vma->vm_start);

This basically overrides the random stack shift done by arch_align_stack().

Yeah, yeah, arch_align_stack() is kind of misnamed. It _used_ to do
what the name implies it does, which on x86 is to just give the
minimum ABI-specified 16-byte stack alignment.

But these days, what it really does is say "align the stack pointer,
but also shift it down by a random amount within 8kB so that the start
of the stack isn't some repeatable thing that an attacker can
trivially control with the right argv/envp size.."

I don't think it works right anyway because we then PAGE_ALIGN() it,
but whatever.

But it looks like what you're doing means that now the size of the
stack will override that shift, and that means that now the
randomization is entirely undone. No?

Plus you do it after we've also checked that we haven't grown the
stack down to below mmap_min_addr().

But maybe I misread that patch.

But I do feel like you figured out why the bug happened, now we're
just discussing whether the patch is the right thing to do.

Maybe saying "doing the pmd copies for the initial stack isn't
important, so let's just note this as a special case and get rid of
the WARN_ON()" might be an alternative solution.

The reason I worried was that I felt like we didn't understand why the
WARN_ON() happened. Now that I do, I think we could just say "ok,
don't warn, we know that this can happen, and it's harmless".

Anybody else have any opinions?

               Linus
