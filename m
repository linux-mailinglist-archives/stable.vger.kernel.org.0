Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5A88189F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 13:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfHEL6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 07:58:33 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:35889 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728513AbfHEL6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 07:58:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id BD0F91E2C;
        Mon,  5 Aug 2019 07:58:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 07:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=CpP+jXyBTmqGd87EE+i6YMktL/+
        9k4HJgd3+6RNm4e0=; b=YSU/9sxglEDrFB83JMjF5GYy1tJNN+/Hz/W4eHE00/3
        BS634k/o0H3PihhmK1Zb32wPagLscjViaodRihFhCD4D1Xr/N7OuTcCbHdp+yp2b
        hAxUeUDzLDmXF6HHzXkoD5FwVLNdoR9yahMQJK8k07kLoC38wxuUmJsIv3RETAn+
        H9QPWEjzDXwKE3COFk/KG/iAldsp5igbzyKEg5WxbXcX8X5kFuvu/PL1xdmtAQVA
        k6/bZwVVJezhner1ToP4BbOK8i5i1v19niZKf2QroMLgRxOyNX5VHVmN+VG4udYN
        7snOYX6wZ0gPnEWBvZRAPYH8AoyXgXEdMrsCW5X4p7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CpP+jX
        yBTmqGd87EE+i6YMktL/+9k4HJgd3+6RNm4e0=; b=J/m9KWk/b9cprwIDZ0LVHU
        NSpbZFZBe5Go/FrtVsGyrgXG4cyu/FpCCSn0H0cnNVddaTcdkJ5VHSHSj79LwoZI
        QeRBGmt5qreO1w4HRZ2nIbCfdobl49bQU6qEPYCbFYf/otoStAv03MgCbIZq5mHu
        hpFVmSMg9ic0ilmBUA4sh7VwrzNm+ZkLi9sOZaoNUcVPLCmnRYB6DQ6mOXaNXV3A
        SVichjeuqWc/c9yS0TaGcnxpCMmJ0rhZjUxAdUFTPjxnG+eRpsZewbibfn3sqCU9
        w/BHCyj93gOjODAS4jPgj4VMdzqA6jGvmjVkOn+7XYXDYuJslR7QzaQ0pKJ4xSfg
        ==
X-ME-Sender: <xms:5hlIXcqMVKi6zxTmzvvHuT1PJZQtmmC1XN_iAqPr-G63OXDCke2BOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:5hlIXSMFXTiUORDQChenY9N-xpSnU5cxldhyvUmIPpbStCHRo9JFyw>
    <xmx:5hlIXXry_Fd0KQl8H9WVBkIZjErtgxBhonRW_5eSpbJc85k93DemqQ>
    <xmx:5hlIXTeo0I6vFJ6Ck8XI_Ghi8pANBVVwSRh-EE8pdL-O_Kz3V7axuQ>
    <xmx:5xlIXaPeOx7_ugFSNGIfd6OSrqrUuuHKHqwJUnqN-H8Y3UCQ9ojxlw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B723E80060;
        Mon,  5 Aug 2019 07:58:29 -0400 (EDT)
Date:   Mon, 5 Aug 2019 13:58:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, Jann Horn <jannh@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        xen-devel@lists.xenproject.org, Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH STABLE 4.9] x86, mm, gup: prevent get_page() race with
 munmap in paravirt guest
Message-ID: <20190805115824.GC8189@kroah.com>
References: <20190802160614.8089-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802160614.8089-1-vbabka@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 06:06:14PM +0200, Vlastimil Babka wrote:
> The x86 version of get_user_pages_fast() relies on disabled interrupts to
> synchronize gup_pte_range() between gup_get_pte(ptep); and get_page() against
> a parallel munmap. The munmap side nulls the pte, then flushes TLBs, then
> releases the page. As TLB flush is done synchronously via IPI disabling
> interrupts blocks the page release, and get_page(), which assumes existing
> reference on page, is thus safe.
> However when TLB flush is done by a hypercall, e.g. in a Xen PV guest, there is
> no blocking thanks to disabled interrupts, and get_page() can succeed on a page
> that was already freed or even reused.
> 
> We have recently seen this happen with our 4.4 and 4.12 based kernels, with
> userspace (java) that exits a thread, where mm_release() performs a futex_wake()
> on tsk->clear_child_tid, and another thread in parallel unmaps the page where
> tsk->clear_child_tid points to. The spurious get_page() succeeds, but futex code
> immediately releases the page again, while it's already on a freelist. Symptoms
> include a bad page state warning, general protection faults acessing a poisoned
> list prev/next pointer in the freelist, or free page pcplists of two cpus joined
> together in a single list. Oscar has also reproduced this scenario, with a
> patch inserting delays before the get_page() to make the race window larger.
> 
> Fix this by removing the dependency on TLB flush interrupts the same way as the
> generic get_user_pages_fast() code by using page_cache_add_speculative() and
> revalidating the PTE contents after pinning the page. Mainline is safe since
> 4.13 where the x86 gup code was removed in favor of the common code. Accessing
> the page table itself safely also relies on disabled interrupts and TLB flush
> IPIs that don't happen with hypercalls, which was acknowledged in commit
> 9e52fc2b50de ("x86/mm: Enable RCU based page table freeing
> (CONFIG_HAVE_RCU_TABLE_FREE=y)"). That commit with follups should also be
> backported for full safety, although our reproducer didn't hit a problem
> without that backport.
> 
> Reproduced-by: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> ---
> 
> Hi, I'm sending this stable-only patch for consideration because it's probably
> unrealistic to backport the 4.13 switch to generic GUP. I can look at 4.4 and
> 3.16 if accepted. The RCU page table freeing could be also considered.
> Note the patch also includes page refcount protection. I found out that
> 8fde12ca79af ("mm: prevent get_user_pages() from overflowing page refcount")
> backport to 4.9 missed the arch-specific gup implementations:
> https://lore.kernel.org/lkml/6650323f-dbc9-f069-000b-f6b0f941a065@suse.cz/

This looks sane to me, thank you for the backport.  I've queued it up
now, and if anyone has any objections, please let me know.

thanks,

greg k-h
