Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48A32E10C1
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 01:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgLWAVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 19:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLWAVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 19:21:48 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E34FC0613D3
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:21:07 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id l11so36171266lfg.0
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DLFc43+zWZaHz7DJE5w0IA8m/d3/STNRHdNjNBYY/r8=;
        b=Kv96F1RjqhLKNH4Di/XoAkh4fGcFanJF/35mBeZg8s5yZd6emVuhDTmAbKdCOPjTHy
         2Flkg4YAHNfaKVQVpWzaowFcfIsg0qWnCHYScg1wPkWTGMP48AsbRBDUDmFxjUz6rUTh
         Xoab7E7PwRF0MbFD3jGQK+ux0O7RWJxy/Q1DA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DLFc43+zWZaHz7DJE5w0IA8m/d3/STNRHdNjNBYY/r8=;
        b=j9k7Hlo7AfNpI5c/ZPShSUbR+GfoyG2oCfjsodE+c0sl+2zmUrBF7CQJEPaXFAKGC+
         Yl2VMlpQq5D3TMNcL0cgfjDuSLRucxIfBRRgtqe+ySFUF4T4TL6fawByGuatqRq3XZjD
         iioWegdK4xiM3yk+y95Rw3+rih/AQ2qxYC6XUsF8XmcRfM+eWU0JWFkDIfugZLR9p9uy
         ii5xTn8ieZjht4jcmB1CXNRKiHj+yCh+UOlpjsEweqTfP51NP6rKZGbKauu8IUXGRQ59
         M/uolGHiYdgldOvSwrkBVTQpV09u48PfMuZEWB2N0m1M7yCE/6Msp0zg4EQ0qzc1iW4n
         vsKQ==
X-Gm-Message-State: AOAM532rtgwiuKZ/ikF47e3yqoQJ277oBmFXdgqCuzim+FArXuA8LlRR
        Xt0VpdchZBepEhUa1cU6nslbo4NK2gCDnw==
X-Google-Smtp-Source: ABdhPJyslDqKpcfcyafX37hoGm+AWZemJ1GAEztsUbJICpHQAaPxST4MZ/YT41ri42O3sU65Xo0Zlg==
X-Received: by 2002:ac2:431a:: with SMTP id l26mr10503236lfh.196.1608682865290;
        Tue, 22 Dec 2020 16:21:05 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id q15sm3158110ljh.136.2020.12.22.16.21.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 16:21:04 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id s26so36044231lfc.8
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:21:03 -0800 (PST)
X-Received: by 2002:a05:6512:338f:: with SMTP id h15mr9238858lfg.40.1608682863624;
 Tue, 22 Dec 2020 16:21:03 -0800 (PST)
MIME-Version: 1.0
References: <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com> <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com> <X+KDwu1PRQ93E2LK@google.com> <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Dec 2020 16:20:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjNedWcjAfPW7pdPTM0-gSXABsv9AA+wCebXbh3tuRTRQ@mail.gmail.com>
Message-ID: <CAHk-=wjNedWcjAfPW7pdPTM0-gSXABsv9AA+wCebXbh3tuRTRQ@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 3:50 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The rule is that the TLB flush has to be done before the page table
> lock is released.

I take that back. I guess it's ok as long as the mmap_sem is held for
writing. Then the TLB flush can be delayed until just before releasing
the mmap_sem. I think.

The stale TLB entries still mean that somebody else can write through
them in another thread, but as long as anybody who actually unmaps the
page (and frees it - think rmap etc) is being careful, mprotect()
itself can probably afford to be a bit laissez-faire.

So mprotect() itself should be ok, I think, because it takes things for writing.

Even with the mmap_sem held for writing, truncate and friends can see
the read-only page table entries (because they can look things up
using the file i_mmap thing instead), but then they rely on the page
table lock and they'll also be careful if they then change that PTE
and will force their own TLB flushes.

So I think a pending TLB flush outside the page table lock is fine -
but once again only if you hold the mmap_sem for writing. Not for
reading, because then the page tables need to be synchronized with the
TLB so that other readers don't see the not-yet-synchronized state.

It once again looks like it's just userfaultfd that would trigger this
due to the read-lock on the mmap_sem. And mprotect() itself is fine.

Am I missing something?

But apparently Nadav sees problems even with that lock changed to a
write lock. Navad?

           Linus
