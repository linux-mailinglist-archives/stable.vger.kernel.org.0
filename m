Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28EB21C59D
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 20:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgGKSNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 14:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728507AbgGKSNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jul 2020 14:13:20 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C7FC08C5DD
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 11:13:20 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id t74so5051309lff.2
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 11:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOYGlWMMEU7tyKGZLlNjUtNxoe6S2h/oz0+oUhK+rOk=;
        b=VBBPUfpiOu0muHbqeP4r3/fUpKQexAHw4DwIqUVNkb43xD+nP+XZ31NsLPUx/vRkRa
         zzaUKWdXrUMfP1FaX3/iNfjqwE1q1Ok1Kix+hzrcv/inVzkMy6FKF046RABJFAJTQy8g
         /oNUGPpsZ3sEzfL5OAQbTJjbjvnkfKAkigYrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOYGlWMMEU7tyKGZLlNjUtNxoe6S2h/oz0+oUhK+rOk=;
        b=ewCz84qZYNX/+cjfDIOrZ1Ckkxqb2b88emToaBgtEO3DjzbR48MxnxvuPMPOEJ2imY
         vpnKy35KcOQnz8j6oOsMmt8VQOD/rfBNIkoEpuefLr6+hpiP+zhwcBM4nf81T8XOoyH3
         mcUdQ4LZRngG2lEBvzsmMcTqHavh9/g1wOpr8M+93qa3qUC154YxRfVhnFD70uQuwFAZ
         ljzpWEQ6+U/+DfhHq7YcMnkLIFHIKRx/JYd+ag4ls66IkDrNQbK3y0OcoMmssc9i7IFj
         gsgnddCSBp7hKy79p/YSE6EgGlMBgIHh95qzFjx31wQ/BYdWetOdShjWt92kBGlB64nx
         QNJw==
X-Gm-Message-State: AOAM532znDG9mZqzmsuIeavuWcv242nrQnHIxBavLT3mu/vwrs9iw2LC
        csNA361jfxZ3jNXMztyRNB05Wm7udyI=
X-Google-Smtp-Source: ABdhPJxn6t9X1tVCCVYn44tITx/PEZYDPkQdD5WbIuL52lQWFSAFyw2UpCgYg5eSimKZmB9jotRt8Q==
X-Received: by 2002:ac2:57c6:: with SMTP id k6mr47571755lfo.179.1594491197629;
        Sat, 11 Jul 2020 11:13:17 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id 11sm3317146lfz.78.2020.07.11.11.13.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 11:13:15 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id q7so10163709ljm.1
        for <stable@vger.kernel.org>; Sat, 11 Jul 2020 11:13:15 -0700 (PDT)
X-Received: by 2002:a2e:9b42:: with SMTP id o2mr42771907ljj.102.1594491195002;
 Sat, 11 Jul 2020 11:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
 <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com> <CA+G9fYusSSrc5G_pZV6Lc-LjjkzQcc3EsLMo+ejSzvyRcMgbqw@mail.gmail.com>
In-Reply-To: <CA+G9fYusSSrc5G_pZV6Lc-LjjkzQcc3EsLMo+ejSzvyRcMgbqw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Jul 2020 11:12:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
Message-ID: <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        William Kucharski <william.kucharski@oracle.com>,
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
        Sasha Levin <sashal@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 11, 2020 at 10:27 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> I have started bisecting this problem and found the first bad commit

Thanks for the effort. Bisection is often a great tool to figure out
what's wrong.

Sadly, in this case:

> commit 9f132f7e145506efc0744426cb338b18a54afc3b
> Author: Joel Fernandes (Google) <joel@joelfernandes.org>
> Date:   Thu Jan 3 15:28:41 2019 -0800
>
>     mm: select HAVE_MOVE_PMD on x86 for faster mremap

Yeah, that's just the commit that enables the code, not the commit
that introduces the fundamental problem.

That said, this is a prime example of why I absolutely detest patch
series that do this kind of thing, and are several patches that create
new functionality, followed by one patch to enable it.

If you can't get things working incrementally, maybe you shouldn't do
them at all. Doing a big series of "hidden work" and then enabling it
later is wrong.

In this case, though, the real patch that did the code isn't that kind
of "big series of hidden work" patch series, it's just the (single)
previous commit 2c91bd4a4e2e ("mm: speed up mremap by 20x on large
regions").

So your bisection is useful, it's just that it really points to that
previous commit, and it's where this code was introduced.

It's also worth noting that that commit doesn't really *break*
anything, since it just falls back to the old behavior when it warns.

So to "fix" your test-case, we could just remove the WARN_ON.

But the WARN_ON() is still worrisome, because the thing it tests for
really _should_ be true.

Now, we actually have a known bug in this area that is talked about
elsewhere: the way unmap does the pgtable_free() is

        /* Detach vmas from rbtree */
        detach_vmas_to_be_unmapped(mm, vma, prev, end);

        if (downgrade)
                mmap_write_downgrade(mm);

        unmap_region(mm, vma, prev, start, end);

(and unmap_region() is what does the pgtable_free() that should have
cleared the PMD).

And the problem with the "downgrade" is that another thread can change
the beginning of the next vma when it's a grow-down region (or the end
of the prev one if it's a grow-up).

See commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
munmap") for the source of that

But that requires an _actual_ "unmap()" system call (the others set
"downgrade" to false - I'm not entirely sure why), and it requires
another thread to be attached to that VM in order to actually do that
racy concurrent stack size change.

And neither of those two cases will be true for the execve() path.
It's a new VM, with just one thread attached, so no threaded munmap()
going on there.

The fact that it seems to happen with

    https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/mem/thp/thp01.c

makes me think it's somehow related to THP mappings, but I don't see
why those would matter. All the same pmd freeing should still have
happened, afaik.

And the printout I asked for a few days back for when it triggered
clearly showed a normal non-huge pmd ("val: 7d530067" is just
"accessed, dirty, rw, user and present", which is a perfectly normal
page directory entry for 4kB pages, and we could move the whole thing
and move 2MB (or 4MB) of aligned virtual memory in one go).

Some race with THP splitting and pgtable_free()? I can't see how
anything would race in execve(), or how anything would have touched
that address below the stack in the first place..

Kirill, Oleg, and reaction from this? Neither of you were on the
original email, I think, it's this one:

    https://lore.kernel.org/lkml/CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com/

and I really think it is harmless in that when the warning triggers,
we just go back to the page-by-page code, but while I think the
WARN_ON() should probably be downgraded to a WARN_ON_ONCE(), I do
think it's showing _something_.

I just can't see how this would trigger for execve(). That's just
about the _simplest_ case for us: single-threaded, mappings set up
purely by load_elf_binary() etc.

I'm clearly missing something.

               Linus
