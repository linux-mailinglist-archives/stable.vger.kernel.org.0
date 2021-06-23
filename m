Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DAE3B1EEA
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 18:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhFWQqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWQqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 12:46:48 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E328C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 09:44:29 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id fq1so1258615qvb.1
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 09:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=mkjTFinAd2KQ8rpaS8UK0KpRfcjqya9+oT4gEHjpyOo=;
        b=fY/xQjghRBA/YGhNHesj0lDvA1RxiWkWYjXEMm3e8QjginWpnBJZF8AU4ih9Gida9S
         7xOCRakJz/qF1bzjUrN0Mnthope/fJEJwXpev1RRBQpLwMz9zfF6AeorB772QvVEiso3
         W5OS8G+b9BP/HwsgrmBkFensXO0c375zyYE9lI/QLJ+2Ser/3Fal5H5E5eKv3po4aUCd
         pUtI8KjygJT6ljk5YDJ++WgtUp/ccLwWxZjAX3MRzpXgZgN5PNlY/MzFADtu1ttjQktm
         L46WX7vM8lnyuCtImq0zH7nXrlhL/vrMkXP+zAgVWotzGvU1jK28BVYMud1Z7I8OOyJd
         pqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=mkjTFinAd2KQ8rpaS8UK0KpRfcjqya9+oT4gEHjpyOo=;
        b=C5rU0Vd3cTj52D/kyMl6JZF3LGZgHSCWPuA92YbNVaIGIh+Qsgl6ty8Nx55UAIAPth
         FdcYLwCP4uiBM8/rskqZtINH47w6EObZPii+Akqn52a1OWBstianNtcq7POg+vKGDv0j
         B7lbGLQK/wQ2oxM+dU0A3OZYIy90UZCw+blCOaU8p8wIzZYB/Bq5ROZFwKE+pcNvWQlw
         Cqxh6qI7Ex46BeulEk3NgHdXc9NATUCHnkEGpwAo9wqbgflSmKWm+VIkBff3pPsZYp74
         d06O64bo/lKxtQHap4lSWAyPfGXNv/O6GsD2wFGXZZl3ewn4EeTYpJG7rpgddqIIxQNi
         llVw==
X-Gm-Message-State: AOAM531h7FU2hukgnbQpclnrtpbzHtqj3mJ4DE0IuZNLhZSGLi7aaXCs
        8MqgywCtaNETfUQm9b8xj3wK3Q==
X-Google-Smtp-Source: ABdhPJwvCoD8wnpS5bEK9yMvPkyGeRj/NF41oem+5aD8wCzEymWelfo2qqjMFo6HbEDhdicVzmxk3Q==
X-Received: by 2002:a05:6214:10c8:: with SMTP id r8mr511764qvs.28.1624466668402;
        Wed, 23 Jun 2021 09:44:28 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id t11sm303285qta.8.2021.06.23.09.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:44:27 -0700 (PDT)
Date:   Wed, 23 Jun 2021 09:44:14 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
In-Reply-To: <YNNMGjoMajhPNyiK@kroah.com>
Message-ID: <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com> <YMrU4FRkrQ7AVo5d@kroah.com> <YNNMGjoMajhPNyiK@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Jun 2021, Greg Kroah-Hartman wrote:
> On Thu, Jun 17, 2021 at 06:51:44AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 16, 2021 at 04:02:32PM -0700, Hugh Dickins wrote:
> > > Hi Greg,
> > > 
> > > Linus has taken in a group of mm/thp commits Cc stable today:
> > > 
> > > 504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
> > > 22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
> > > 31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
> > > 494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
> > > 732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
> > > 3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
> > > 99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
> > > ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()
> > > 
> > > and I expect some more to follow in a few days time (thanks Andrew).
> > > 
> > > No problem with the commits themselves, but I'm aware that some of them
> > > have dependencies on other commits not yet in stable, which I have to
> > > sort out for you now.
> > > 
> > > I'd prefer to avoid a deluge of "does not apply" messages, so ask you
> > > please to hold off trying to merge these into stable trees for a few days:
> > > I'll get back to you with what's needed for them to apply.
> > 
> > Not a problem, thanks for the heads up, I'll restrain from running my
> > scripts on the above patches until you say it's safe to :)
> 
> Any word on this?

I have a "matrix" of what's needed ready, but I'm still waiting on
"I expect some more to follow in a few days time (thanks Andrew)":
I believe akpm does still intend to send them in to Linus for 5.13
this week, but they've not gone yet.

So eleven don't yet have SHA1s (of SignOffs by Linus) to include.
Ten of them (I'm calling pvmw1 through pvmw10) are progressive
mods to one function page_vma_mapped_walk(), which were split off
from the previous patches to help review.  Those ones are easy:
they all apply cleanly to all releases in which they are needed,
so no special backports from me required.

But there's a final futex-pgoff one, which does not apply cleanly
to 5.4 or 4.9: so that one I do have to send you variants of, and
cannot until it's in Linus's tree.

You could proceed with just the first eight already in the tree;
but it's all (bar the last) part of the same collection of fixes.
I think better to keep them together - unless Andrew or Linus
prefers to hold the eleven back until 5.14-rc.

Here's the "matrix" and notes I assembled for your delectation
(and I verified yesterday that your latest releases do not add any
complications); but I'm not yet attaching the tarball of variants,
which I expect to update for futex-pgoff when it goes in.

5.12.12         5.10.45      5.4.127      4.19.195     4.14.237     4.9.273
                                                       4.14/0001    << chpick
                5.10/0001    << chpick    << chpick    << chpick    << chpick
                5.10/0002    << chpick    << chpick    << chpick
                5.10/0003    << chpick    << chpick    << chpick
ffc90cbb2970    << chpick    << chpick
99fa8a48203d    5.10/0005    << chpick    << chpick
3b77e8c8cde5    << chpick    << chpick    << chpick
732ed55823fc    << chpick    5.04/0007    << chpick    << chpick
494334e43c16    << chpick    5.04/0008    4.19/0007    << chpick
31657170deaf    << chpick    << chpick    << chpick    << chpick
22061a1ffabd    5.10/0010    5.04/0010    << chpick
504e070dc08f    5.10/0011    5.04/0011    4.19/0010    4.14/0008   4.09/0003
pvmw1-pvmw10    << chpick    << chpick    << chpick    << chpick
futex-pgoff     << chpick    5.04/0022    << chpick    << chpick   4.09/0004

Already in 5.13-rc7:
ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()
99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

Expected in 5.13 final:
pvmw1        mm: page_vma_mapped_walk(): use page for pvmw->page
pvmw2        mm: page_vma_mapped_walk(): settle PageHuge on entry
pvmw3        mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
pvmw4        mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
pvmw5        mm: page_vma_mapped_walk(): crossing page table boundary
pvmw6        mm: page_vma_mapped_walk(): add a level of indentation
pvmw7        mm: page_vma_mapped_walk(): use goto instead of while (1)
pvmw8        mm: page_vma_mapped_walk(): get vma_address_end() earlier
pvmw9        mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
pvmw10       mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
futex-pgoff  mm, futex: fix shared futex pgoff on shmem huge page

Antecedents which get added into some older kernels:
4.14/0001 91241681c62a include/linux/mmdebug.h: make VM_WARN* non-rvals
5.10/0001 a4055888629b (part) mm: add VM_WARN_ON_ONCE_PAGE() macro
5.10/0002 e0af87ff7afc mm/rmap: remove unneeded semicolon in page_not_mapped()
5.10/0003 b7e188ec98b1 mm/rmap: use page_not_mapped in try_to_unmap()

Nothing special for 5.12.12: all 19 can be cherry-picked cleanly.

Antecedents and fixedups for 5.10.45 and older:
5.10/0001-mm-add-VM_WARN_ON_ONCE_PAGE-macro.patch
5.10/0002-mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
5.10/0003-mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
5.10/0005-mm-thp-fix-__split_huge_pmd_locked-on-shmem-migratio.patch
5.10/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
5.10/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch

Fixedups for 5.4.127 and older:
5.04/0007-mm-thp-try_to_unmap-use-TTU_SYNC-for-safe-splitting.patch
5.04/0008-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
5.04/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
5.04/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
5.04/0022-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch

Fixedups for 4.19.195 and older:
4.19/0007-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
4.19/0010-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch

(Why does matrix say not to port ffc90cbb2970 "use head page" to 4.19
and older?  It is correct, and would apply to them: but they do not
have put_and_wait_on_page_locked(), so it may behave worse on them.)

Antecedent and fixedup for 4.14.237 and older:
4.14/0001-include-linux-mmdebug.h-make-VM_WARN-non-rvals.patch
4.14/0008-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch

Fixedups for 4.9.273:
4.09/0003-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
4.09/0004-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch

No backports to 4.4.273: it's too old and different for these.

Does that make sense to you?

Hugh
