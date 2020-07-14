Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EF621EF3A
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 13:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGNL1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 07:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgGNL1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 07:27:40 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129C8C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 04:27:40 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h22so22041501lji.9
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 04:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRuLFKvQDaw1sZL3IQ7c0WjQdAQsHCg8KMZ60fQDX3s=;
        b=IvWTr1G8MbRGNvmmF3GY36Q3iShIoAcmF57XjtqSMlX+UjsveepMcNyeYiicFU+3E+
         bOSSCqYtoFqjo48izwzZCRfWncfuq8FFX4ZqMpjYPlN0DXZQAn/uvQY+8tWFxBm4nQam
         biWrkcFebp86rk2x+UCbWrFkPpCtZl4Om/XQnX76mubHorOPHg8ALbs3ZdV2Tqtt4CDU
         xB74Epl7L2Ddpc9UFfC+3qdjiFaxKde5OlQzlkOvvSfKv62WKARQGEf135nJb1Pg2Mo1
         23YiVG67fLpJQ5Q/2V5JmibKAzCtpBzjkEqkCL73RuAwhHw6ElJUCyx+wzJlEMs++D6D
         jxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRuLFKvQDaw1sZL3IQ7c0WjQdAQsHCg8KMZ60fQDX3s=;
        b=bn2QQkLNjtHsQEwI9A3uKMFSDZzLwYSs+7MJSiak6WNSd9etCbGodTx8KLVmsW+ObE
         epcrKWKNhLuQ5F1nQE3RceC1aOZZ6nYKpp1+8zHkJppkdPLRrHTXNL1XsRM7FSYgJfKo
         fKf6Mn3ctsxnroKII7rh5/avcqL9xpJsy7f12rh7Ikg47+rhyvT2IAFQFvAUMWCHqyOX
         Vm0lIDW+av6JkPZZylofc6QFJJm+ADk04OgGUJuXNYzmOsIpKOJGidl1uwIaS2MdwGc/
         NL7S1DOO3cr7fXG6hpBl/NOAOn0PCMO4j+5VQn90G13+xv3b6VwAG9NLtrubTaLwXiOz
         qwnA==
X-Gm-Message-State: AOAM532hyG5kKo8FNWwWytlSGfppEWHNsTrh7cAoZK/4VD7pTa51i8v7
        HdhyR7IfyVv9o8Kna30bNeIjN/ezUn+2uWFtIZ7ZRA==
X-Google-Smtp-Source: ABdhPJy5qZDrujqexb2KWuHgK/pg2E8r3sHYRhykgzZdB+4AhkS8Ejrdf1ttrfztmNGMOeYDytwHysJ8zfNi+ujHmGY=
X-Received: by 2002:a2e:9089:: with SMTP id l9mr2090256ljg.431.1594726058377;
 Tue, 14 Jul 2020 04:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <20200712215041.GA3644504@google.com> <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
 <20200714073306.kq4zikkphqje2yzb@box>
In-Reply-To: <20200714073306.kq4zikkphqje2yzb@box>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jul 2020 16:57:26 +0530
Message-ID: <CA+G9fYsqdHR=ty2hKj44zQ=SrHuWwu-eN0odp72AGCiNkFVUog@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
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

On Tue, 14 Jul 2020 at 13:03, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Sun, Jul 12, 2020 at 03:58:06PM -0700, Linus Torvalds wrote:
> > Anybody else have any opinions?
>
> Maybe we just shouldn't allow move_normal_pmd() if ranges overlap?
>
> Other option: pass 'overlaps' down to move_normal_pmd() and only WARN() if
> see establised PMD without overlaps being true.
>
> Untested patch:

This patch applied on top of Linus mainline tree and tested on i386.
The reported warning did not happen while testing LTP mm [1].


>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 5dd572d57ca9..e33fcee541fe 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -245,6 +245,18 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
>         unsigned long extent, next, old_end;
>         struct mmu_notifier_range range;
>         pmd_t *old_pmd, *new_pmd;
> +       bool overlaps;
> +
> +       /*
> +        * shift_arg_pages() can call move_page_tables() on overlapping ranges.
> +        * In this case we cannot use move_normal_pmd() because destination pmd
> +        * might be established page table: move_ptes() doesn't free page
> +        * table.
> +        */
> +       if (old_addr > new_addr)
> +               overlaps = old_addr - new_addr < len;
> +       else
> +               overlaps = new_addr - old_addr < len;
>
>         old_end = old_addr + len;
>         flush_cache_range(vma, old_addr, old_end);
> @@ -282,7 +294,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
>                         split_huge_pmd(vma, old_pmd, old_addr);
>                         if (pmd_trans_unstable(old_pmd))
>                                 continue;
> -               } else if (extent == PMD_SIZE) {
> +               } else if (!overlaps && extent == PMD_SIZE) {
>  #ifdef CONFIG_HAVE_MOVE_PMD
>                         /*
>                          * If the extent is PMD-sized, try to speed the move by
> --
>  Kirill A. Shutemov

ref:
https://lkft.validation.linaro.org/scheduler/job/1561734#L1598

- Naresh
