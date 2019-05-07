Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB159167EC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfEGQbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:31:24 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:55237 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGQbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:31:23 -0400
Received: by mail-it1-f196.google.com with SMTP id a190so27486972ite.4;
        Tue, 07 May 2019 09:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HdcDag0bf4IjXr3oQ80U5L8vdpfE6vzh4djKOZUTxxI=;
        b=d8zBwAnCH7wUVI7KmuH2Dm4GeSJ2CVS2J6feMijMY7bNAvSwrLtdbQcnx15Y2PAB84
         Q5wC8rvpIXPCIzvd1IB6Me7cHeiof/G4YASOOq/9MiQ65X3Hx4qa0MoBesKx/BfdbD5n
         8Pq1jscYgeQias7h0sbJwGEa2g/xeC1/YuY9zoVZ0YCgQr9obvTKYBZBYuJ7FFEj3Z4z
         IgYfRyQ/+7uZzuFUBPA5Ndpx4ZDAqoTC8/IxfAgZEWe8xTrpTOFwnLsT2Cb4iDHn0pnO
         zqxXN1aXggULxJT+BowYgXgFb02kS3sMAYDfhtqx10xgQ+d+zF95W0lEx6123zZ5eLa2
         LU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HdcDag0bf4IjXr3oQ80U5L8vdpfE6vzh4djKOZUTxxI=;
        b=GDRErti9bO5xIXdpBYG6zuXaICRC6PuL95bpn5Gzl780yIqjcVKmjqm1QnGlvwpplx
         YhqX+D7YTGPV0NdWfNoifCyA6skmhwgX8NeG++A6mXiyb6rdISWa1IUBFgydE10xaI8t
         XDvfqRUWwptVtSq2kmfQZgwmMSAGC5st761AfoDmMXOX37Hd6PorDbuik6fuFb9IIOcn
         btQ9ALNAw1NA/jmoXPhBqumLxF388FYiQGUqvt7mjT4G1Tn1r9BMguGDKq+T6/ezFBtS
         zLbVpPQdF4DDTOwQfj+SSv+q1vCZe3VDtW9+eYnKNSLINWNiui4OOFGHicUvPiFaA9Sk
         fSeQ==
X-Gm-Message-State: APjAAAWZc6ye5r7qpCFx3tswYEYyZMJfmbeSBfSd/BhNGllnqYtMtR9O
        GziqweAIS3ZhrM5tTeDPX/pPg73uMlamLYxq3uY=
X-Google-Smtp-Source: APXvYqwrRhM2NXqqo7rGUDDdcwtaybqL1I98pu0GXC1TCViomXKy36uHt5drGc+qF4QiXVZZU7eohpNYuOZJy0GKpgs=
X-Received: by 2002:a24:b04:: with SMTP id 4mr19257328itd.6.1557246682072;
 Tue, 07 May 2019 09:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190507053826.31622-1-sashal@kernel.org> <20190507053826.31622-62-sashal@kernel.org>
In-Reply-To: <20190507053826.31622-62-sashal@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 7 May 2019 09:31:10 -0700
Message-ID: <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 6, 2019 at 10:40 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
>
> [ Upstream commit 2830bf6f05fb3e05bc4743274b806c821807a684 ]
>
> If memory end is not aligned with the sparse memory section boundary,
> the mapping of such a section is only partly initialized.  This may lead
> to VM_BUG_ON due to uninitialized struct page access from
> is_mem_section_removable() or test_pages_in_a_zone() function triggered
> by memory_hotplug sysfs handlers:
>
> Here are the the panic examples:
>  CONFIG_DEBUG_VM=y
>  CONFIG_DEBUG_VM_PGFLAGS=y
>
>  kernel parameter mem=2050M
>  --------------------------
>  page:000003d082008000 is uninitialized and poisoned
>  page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
>  Call Trace:
>  ( test_pages_in_a_zone+0xde/0x160)
>    show_valid_zones+0x5c/0x190
>    dev_attr_show+0x34/0x70
>    sysfs_kf_seq_show+0xc8/0x148
>    seq_read+0x204/0x480
>    __vfs_read+0x32/0x178
>    vfs_read+0x82/0x138
>    ksys_read+0x5a/0xb0
>    system_call+0xdc/0x2d8
>  Last Breaking-Event-Address:
>    test_pages_in_a_zone+0xde/0x160
>  Kernel panic - not syncing: Fatal exception: panic_on_oops
>
>  kernel parameter mem=3075M
>  --------------------------
>  page:000003d08300c000 is uninitialized and poisoned
>  page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
>  Call Trace:
>  ( is_mem_section_removable+0xb4/0x190)
>    show_mem_removable+0x9a/0xd8
>    dev_attr_show+0x34/0x70
>    sysfs_kf_seq_show+0xc8/0x148
>    seq_read+0x204/0x480
>    __vfs_read+0x32/0x178
>    vfs_read+0x82/0x138
>    ksys_read+0x5a/0xb0
>    system_call+0xdc/0x2d8
>  Last Breaking-Event-Address:
>    is_mem_section_removable+0xb4/0x190
>  Kernel panic - not syncing: Fatal exception: panic_on_oops
>
> Fix the problem by initializing the last memory section of each zone in
> memmap_init_zone() till the very end, even if it goes beyond the zone end.
>
> Michal said:
>
> : This has alwways been problem AFAIU.  It just went unnoticed because we
> : have zeroed memmaps during allocation before f7f99100d8d9 ("mm: stop
> : zeroing memory during allocation in vmemmap") and so the above test
> : would simply skip these ranges as belonging to zone 0 or provided a
> : garbage.
> :
> : So I guess we do care for post f7f99100d8d9 kernels mostly and
> : therefore Fixes: f7f99100d8d9 ("mm: stop zeroing memory during
> : allocation in vmemmap")
>
> Link: http://lkml.kernel.org/r/20181212172712.34019-2-zaslonko@linux.ibm.com
> Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")
> Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Suggested-by: Michal Hocko <mhocko@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Cc: Pasha Tatashin <Pavel.Tatashin@microsoft.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
> ---
>  mm/page_alloc.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Wasn't this patch reverted in Linus's tree for causing a regression on
some platforms? If so I'm not sure we should pull this in as a
candidate for stable should we, or am I missing something?
