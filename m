Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B473B5DD2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 14:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhF1MUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 08:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232923AbhF1MUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 08:20:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A0F161C49;
        Mon, 28 Jun 2021 12:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624882655;
        bh=Kj+R5V2Nkn1SRKAjIFi5vSG1AkIj6UM+aey8EdhOdwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VXALXumKpGErkqmF1jBZ7qfZzITgFEoK1Uu83pjkmQJ9hVSikb2xEs/6ZazyxehDS
         HN2M7hWKp1xLXSpWQ4vm7q2WnGC2KB/nWspb5p+ax2Mif9KcWdLRq8EPyOPQnPFJEU
         inabAyC7c81wvQ9fIdsuiXy6de7MwoYplr4E5PiA=
Date:   Mon, 28 Jun 2021 14:17:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, Alex Shi <alexs@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
Message-ID: <YNm93fkIPrqMwHzd@kroah.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com>
 <YMrU4FRkrQ7AVo5d@kroah.com>
 <YNNMGjoMajhPNyiK@kroah.com>
 <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
 <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org>
 <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
 <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 25, 2021 at 05:38:01PM -0700, Hugh Dickins wrote:
> On Wed, 23 Jun 2021, Hugh Dickins wrote:
> > On Wed, 23 Jun 2021, Andrew Morton wrote:
> > > On Wed, 23 Jun 2021 09:44:14 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > > 
> > > > > Any word on this?
> > > > 
> > > > I have a "matrix" of what's needed ready, but I'm still waiting on
> > > > "I expect some more to follow in a few days time (thanks Andrew)":
> > > > I believe akpm does still intend to send them in to Linus for 5.13
> > > > this week, but they've not gone yet.
> > > 
> > > Linuswards tomorrow.  Is that OK?
> > 
> > That's great, thanks Andrew.  Then when they appear in Linus's tree,
> > I'll complete my notes and tarball, and mail GregKH in reply here.
> 
> All in now, thanks: so attached is a tarball of the variants,
> and here the finalized summary of what each stable needs.
> 
> 5.12.13         5.10.46      5.4.128      4.19.195     4.14.237     4.9.273
>                                                        4.14/0001    << chpick
>                 5.10/0001    << chpick    << chpick    << chpick    << chpick
>                 5.10/0002    << chpick    << chpick    << chpick
>                 5.10/0003    << chpick    << chpick    << chpick
> ffc90cbb2970    << chpick    << chpick
> 99fa8a48203d    5.10/0005    << chpick    << chpick
> 3b77e8c8cde5    << chpick    << chpick    << chpick
> 732ed55823fc    << chpick    5.04/0007    << chpick    << chpick
> 494334e43c16    << chpick    5.04/0008    4.19/0007    << chpick
> 31657170deaf    << chpick    << chpick    << chpick    << chpick
> 22061a1ffabd    5.10/0010    5.04/0010    << chpick
> 504e070dc08f    5.10/0011    5.04/0011    4.19/0010    4.14/0008   4.09/0003
> f003c03^..a7a69d8  chpick    << chpick    << chpick    << chpick
> fe19bd3dae3d    << chpick    5.04/0022    << chpick    << chpick   4.09/0004
> 
> 19 recent THP-related upstream commits for 5.13:
> ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()
> 99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
> 3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
> 732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
> 494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
> 31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
> 22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
> 504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
> f003c03bd29e mm: page_vma_mapped_walk(): use page for pvmw->page
> 6d0fd5987657 mm: page_vma_mapped_walk(): settle PageHuge on entry
> 3306d3119cea mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
> e2e1d4076c77 mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
> 448282487483 mm: page_vma_mapped_walk(): crossing page table boundary
> b3807a91aca7 mm: page_vma_mapped_walk(): add a level of indentation
> 474466301dfd mm: page_vma_mapped_walk(): use goto instead of while (1)
> a765c417d876 mm: page_vma_mapped_walk(): get vma_address_end() earlier
> a9a7504d9bea mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
> a7a69d8ba88d mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
> fe19bd3dae3d mm, futex: fix shared futex pgoff on shmem huge page
> 
> Antecedents which get added into some older kernels:
> 4.14/0001 91241681c62a include/linux/mmdebug.h: make VM_WARN* non-rvals
> 5.10/0001 a4055888629b (part) mm: add VM_WARN_ON_ONCE_PAGE() macro
> 5.10/0002 e0af87ff7afc mm/rmap: remove unneeded semicolon in page_not_mapped()
> 5.10/0003 b7e188ec98b1 mm/rmap: use page_not_mapped in try_to_unmap()
> 
> Nothing special for 5.12.13: all 19 can be cherry-picked cleanly.
> 
> Antecedents and fixedups for 5.10.46 and older:
> 5.10/0001-mm-add-VM_WARN_ON_ONCE_PAGE-macro.patch
> 5.10/0002-mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
> 5.10/0003-mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
> 5.10/0005-mm-thp-fix-__split_huge_pmd_locked-on-shmem-migratio.patch
> 5.10/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
> 5.10/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 
> Fixedups for 5.4.128 and older:
> 5.04/0007-mm-thp-try_to_unmap-use-TTU_SYNC-for-safe-splitting.patch
> 5.04/0008-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
> 5.04/0010-mm-thp-unmap_mapping_page-to-fix-THP-truncate_cleanu.patch
> 5.04/0011-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 5.04/0022-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
> 
> Fixedups for 4.19.195 and older:
> 4.19/0007-mm-thp-fix-vma_address-if-virtual-address-below-file.patch
> 4.19/0010-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 
> (Why does matrix say not to port ffc90cbb2970 "use head page" to 4.19
> and older?  It is correct, and would apply to them: but they do not
> have put_and_wait_on_page_locked(), so it may behave worse on them.)
> 
> Antecedent and fixedup for 4.14.237 and older:
> 4.14/0001-include-linux-mmdebug.h-make-VM_WARN-non-rvals.patch
> 4.14/0008-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 
> Fixedups for 4.9.273:
> 4.09/0003-mm-thp-replace-DEBUG_VM-BUG-with-VM_WARN-when-unmap-.patch
> 4.09/0004-mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
> 
> No backports to 4.4.273: it's too old and different for these.

Thanks so much for this, and I was able to follow the above directions
for 5.12, 5.10, and 5.4.

But things fell apart for 4.19.y, when doing the backport of the longer
series:
> f003c03^..a7a69d8  chpick    << chpick    << chpick    << chpick

That just did not work.

So could you just send a mbox of patches (or tarball), for the 4.19,
4.14, and 4.9 trees?  That would make it much easier to ensure I got
them all correct.

thanks again,

greg k-h
