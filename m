Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6133B2E054B
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 05:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgLVERM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 23:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVERM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 23:17:12 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB09BC0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 20:16:31 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id o17so28895181lfg.4
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 20:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C/IyHJco45Qv6BHyymqm5fsLF1iVOYE2Rc667l3brbw=;
        b=IR0T55DmJ9mkOAt5PW8Gqr31ryut37JKHFwkKEKNUnz84Mk9NwhsAQe1HxZsHQ7zmB
         MdR95VrHiV3LKUGcBK3v6VgHVBsa/aLcrgAlzNjpqqiV6O7hKjnM4BwDsBhDCmFtduFt
         aGec+wYY5jH8H2b3n90B1OMSiOJSvUAF62wS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/IyHJco45Qv6BHyymqm5fsLF1iVOYE2Rc667l3brbw=;
        b=mwisor20//RyTwRSDxlgp+puAxgwI+vsk26NohUDGIWmgRrCSxG0VgE5P17SX1zyHI
         c9HMnH81xiRgQxMchlsYkwf2Wc6+24SBayzlbePu1twtNxwEL6Z1EL+nqKaec6A/M6+u
         PQsRd1Z809AzA5LRMOhGfF0hTPzgZ2DFdbF1qD7mellYsjY6qLKSqfS/XFF22R3Mo5ep
         tqvNkkwE90VmWXpWUfDX5ezkeJC8sylsumMAVkjeZqfcnL23X/HFyTRQ+bnJPyNjChWc
         DcONHEn7oJZB2PA6uQnDLhT4jZ0WuzZGIQZLs4n/3JgCXL6U12947QEk9HMWWH8MOR2K
         0tog==
X-Gm-Message-State: AOAM530MKqx4xSc/k3tXvHhoH9o3dJEDYlkjrhZ0lN8ihMaYYlVbzqtN
        AjmXx5Z2ar+Qu3PrhtcaSptKzk5aE7zzuA==
X-Google-Smtp-Source: ABdhPJylvP81PK4aRu/oVTVtHT3KXRO96ylGj72ujes15syJukVQosRVrwwENoa4oIXDALBYGn6zqg==
X-Received: by 2002:a05:6512:3048:: with SMTP id b8mr8274706lfb.421.1608610589336;
        Mon, 21 Dec 2020 20:16:29 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id h6sm2171244lfj.285.2020.12.21.20.16.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 20:16:28 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id y19so28727668lfa.13
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 20:16:27 -0800 (PST)
X-Received: by 2002:a2e:b4af:: with SMTP id q15mr8557233ljm.507.1608610587583;
 Mon, 21 Dec 2020 20:16:27 -0800 (PST)
MIME-Version: 1.0
References: <X97pprdcRXusLGnq@google.com> <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1> <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com> <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com> <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
In-Reply-To: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 20:16:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
Message-ID: <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
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

On Mon, Dec 21, 2020 at 7:19 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> Ugh, this is unpleasantly complicated.

I probably should have phrased it differently, because the case you
quote is actually a good one:

>  I will admit that any API that
> takes an address and more-or-less-blindly marks it RO makes me quite
> nervous even assuming all the relevant locks are held.  At least
> userfaultfd refuses to operate on VM_SHARED VMAs, but we have another
> instance of this (with mmap_sem held for write) in x86:
> mark_screen_rdonly().  Dare I ask how broken this is?  We could likely
> get away with deleting it entirely.

So I think the basic rule is that "if you hold mmap_sem for writing,
you're always safe". And that really should be considered the
"default" locking.

ANY time you make a modification to the VM layer, you should basically
always treat it as a write operation, and get the mmap_sem for
writing.

Yeah, yeah, that's a bit simplified, and it ignores various special
cases (and the hardware page table walkers that obviously take no
locks at all), but if you hold the mmap_sem for writing you won't
really race with anything else - not page faults, and not other
"modify this VM".

So mark_screen_rdonly() looks trivially fine to me. I don't think it
really necessarily matters any more, and it's a legacy thing for a
legacy hardware issue, but I don't think there's any reason at all to
remove it either.

To a first approximation, everybody that changes the VM should take
the mmap_sem for writing, and the readers should just be just about
page fault handling (and I count GUP as "page fault handling" too -
it's kind of the same "look up page" rather than "modify vm" kind of
operation).

And there are just a _lot_ more page faults than there are things that
modify the page tables and the vma's.

So having that mental model of "lookup of pages in a VM take mmap_semn
for reading, any modification of the VM uses it for writing" makes
sense both from a performance angle and a logical standpoint. It's the
correct model.

And it's worth noting that COW is still "lookup of pages", even though
it might modify the page tables in the process. The same way lookup
can modify the page tables to mark things accessed or dirty.

So COW is still a lookup operation, in ways that "change the
writabiility of this range" very much is not. COW is "lookup for
write", and the magic we do to copy to make that write valid is still
all about the lookup of the page.

Which brings up another mental mistake I saw earlier in this thread:
you should not think "mmap_sem is for vma, and the page table lock is
for the page table changes".

mmap_sem is the primary lock for any modifications to the VM layout,
whether it be in the vma's or in the page tables.

Now, the page table lock does exist _in_addition_to_ the mmap_sem, but
it is partly because

 (a) we have things that historically walked the page tables _without_
walking the vma's (notably the virtual memory scanning)

 (b) we do allow concurrent page faults, so we then need a lower-level
lock to serialize the parallelism we _do_ have.

And yes, we have ended up allowing some of those "modify the VM state"
to then take the mmap_sem for reading, just because their
modifications are slight enough that we can then say "ok, this is a
write modification, but the writes it does are protected by the page
table lock, we'll just get the mmap_sem for reading". It's an
optimization, but it should be considered exactly that: not
fundamental, but just a clever trick and an optimization.

It's why I went "userfaultfd is buggy" immediately when I noticed. It
basically became clear that "oh, that's an optimization, but it's an
*invalid* one", in that it didn't actually work and give the same end
result.

So when I said:

> Anything that changes RW->RO - like fork(), for example - needs to
> take the mmap_lock.

I didn't mean that we should consider that RW->RO change to be this
complex semantic marker that we should honor and say "ok, because it's
a RW->RO change, we need to hold the mmap_sem".

I phrased it really badly, in other words.

What I *should* have said is that *because* userfaultfd is changing
the VM layout, it should always act as if it had to take the mmap_sem
for writing, and that the RW->RO change is an example of when
downgrading that write-lock to a read lock is simply not valid -
because it basically breaks the rules about what a lookup (ie a read)
can do.

A lookup can never turn a writable page non-writable. A lookup -
through COW - _can_ turn a read-only page writable. So that's why
"RO->RW" can be ok under the read lock, but RW->RO is not.

Does that clarify the situation when I phrase it that way instead?

             Linus
