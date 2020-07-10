Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C97E21BC8D
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGJRsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 13:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJRsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 13:48:18 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF0BC08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 10:48:17 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id g139so3670795lfd.10
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 10:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGH/1ehoZFwfhkJOgaIaTubnPetz+f4biA6QGk/2Uyo=;
        b=c7JFXD/A4EOhJwcLKu31TlBZ9abJajqaRKQlVWu/avrgpYDKmq8FSwvFK0J5HLnvNj
         Qp7Uz4blgJRqRqgOUAc3ruSqMZJRakazZjRrjHpru1thFep0tt+PjNMVb0JiBOzDfdjQ
         SuqVlOh3YkcyPvVxX1f0dOPQTLXNyaVDx5KQopfd2MKsDPz40FavPXF/hmuRMZO3jAGB
         vGbPXs71UGM5Kmg+G/NYtoVmh6Bu8+1CDVAlE/XIEnXprO6B2cVS4F/Ym2a9WvYAQELb
         0EYa1Xo7BZCpJDCcnQgtSMyut2weoOJrX99Q1Xm2rhAz9w0bQeFMaPeCc4CaPDFP0wOc
         N9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGH/1ehoZFwfhkJOgaIaTubnPetz+f4biA6QGk/2Uyo=;
        b=KCNVw8ro9jvl9ZG+pzRva9YjdDWlvBuOL1kaJLWuKHI4qjvLI1B6OSNJYMq/iUaMz4
         J9KYKAlLUncDd5Js1xFNGUTKSmJ06OSPQl3oH5qiknVoavvbAWEECvKIc/b+BNfRCvZo
         sF/TmrXF4gD1yg5Tm2j7QAai9mhsZmXw+/m6dUHf9nW2sWXPCEZzErfnGTmci8CeB7NT
         QpBTFP5ROgeaofaAFz8fFRMd8ISTrIhCSKC1jAGE0GyNyo6/tMUY/3FAGUPWSVgRUk8Z
         6EohyZDIsJHXW2KY4jIux6jxDREQ0AcUded/ukFmYkqZEcMr3qH4F/se/eBjgLaJV7cO
         0Tug==
X-Gm-Message-State: AOAM532DV8ZSDWcXh76JQVdFclOiJlInE2jF7DMYQQ2nyI9rbknLMIpc
        Sl+fR+ySSFKbJ4CXi/ZjwNcCk784a9P5o6ab+2dlMw==
X-Google-Smtp-Source: ABdhPJyCpqQFIy3eX/eFjtB9ld/zDOw4OnCM+wpMSQlR21gzdFLeVumVkGcJ/4fP4kY2YEfNFw8cH/ItJI+rohXmENc=
X-Received: by 2002:a19:4285:: with SMTP id p127mr42097847lfa.74.1594403295614;
 Fri, 10 Jul 2020 10:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com> <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
In-Reply-To: <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 10 Jul 2020 23:18:03 +0530
Message-ID: <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux- stable <stable@vger.kernel.org>,
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
        Joel Fernandes <joel@joelfernandes.org>,
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

On Fri, 10 Jul 2020 at 10:55, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Jul 9, 2020 at 9:29 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > Your patch applied and re-tested.
> > warning triggered 10 times.
> >
> > old: bfe00000-c0000000 new: bfa00000 (val: 7d530067)
>
> Hmm.. It's not even the overlapping case, it's literally just "move
> exactly 2MB of page tables exactly one pmd down". Which should be the
> nice efficient case where we can do it without modifying the lower
> page tables at all, we just move the PMD entry.
>
> There shouldn't be anything in the new address space from bfa00000-bfdfffff.
>
> That PMD value obviously says differently, but it looks like a nice
> normal PMD value, nothing bad there.
>
> I'm starting to think that the issue might be that this is because the
> stack segment is special. Not only does it have the growsdown flag,
> but that whole thing has the magic guard page logic.
>
> So I wonder if we have installed a guard page _just_ below the old
> stack, so that we have populated that pmd because of that.
>
> We used to have an _actual_ guard page and then play nasty games with
> vm_start logic. We've gotten rid of that, though, and now we have that
> "stack_guard_gap" logic that _should_ mean that vm_start is always
> exact and proper (and that pgtbales_free() should have emptied it, but
> maybe we have some case we forgot about.
>
> > [  741.511684] WARNING: CPU: 1 PID: 15173 at mm/mremap.c:211 move_page_tables.cold+0x0/0x2b
> > [  741.598159] Call Trace:
> > [  741.600694]  setup_arg_pages+0x22b/0x310
> > [  741.621687]  load_elf_binary+0x31e/0x10f0
> > [  741.633839]  __do_execve_file+0x5a8/0xbf0
> > [  741.637893]  __ia32_sys_execve+0x2a/0x40
> > [  741.641875]  do_syscall_32_irqs_on+0x3d/0x2c0
> > [  741.657660]  do_fast_syscall_32+0x60/0xf0
> > [  741.661691]  do_SYSENTER_32+0x15/0x20
> > [  741.665373]  entry_SYSENTER_32+0x9f/0xf2
> > [  741.734151]  old: bfe00000-c0000000 new: bfa00000 (val: 7d530067)
>
> Nothing looks bad, and the ELF loading phase memory map should be
> really quite simple.
>
> The only half-way unusual thing is that you have basically exactly 2MB
> of stack at execve time (easy enough to tune by just setting argv/env
> right), and it's moved down by exactly 2MB.
>
> And that latter thing is just due to randomization, see
> arch_align_stack() in arch/x86/kernel/process.c.
>
> So that would explain why it doesn't happen every time.
>
> What happens if you apply the attached patch to *always* force the 2MB
> shift (rather than moving the stack by a random amount), and then run
> the other program (t.c -> compiled to "a.out").

I have applied your patch and test started in a loop for a million times
but the test ran for 35 times. Seems like the test got a timeout after 1 hour.
kernel messages printed while testing a.out

a.out (480) used greatest stack depth: 4872 bytes left

On other device
kworker/dying (172) used greatest stack depth: 5044 bytes left

Re-running test with long timeouts 4 hours and will share findings.

ref:
https://lkft.validation.linaro.org/scheduler/job/1555132#L1515

- Naresh
