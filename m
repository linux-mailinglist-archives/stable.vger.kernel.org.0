Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CF42E2415
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 04:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgLXDeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 22:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbgLXDeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 22:34:46 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA07C061794
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 19:34:06 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id q1so943580ilt.6
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 19:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=c5fNsg2UwF5UocytYwq0XQNimIsx8M/0x2kcxXnzw6s=;
        b=PgNEDPhRRco6MUm+b35ScL9j7jTW2b7WyA5+rPGX4xjQrF6SUP/6+x/45YJPtKsHtG
         +pw2Aig8V5nQJ2pMAor1ZD3H9qsk2OPqg+BJ6NRonx+8A5Ph3TLfa+3BEvoH+W65zwHs
         52a2XnIgl0IVSgJZPRgMOO/G/7vAYwyW1rBkk2Lb4b/aJuqeHYZ05wrVsjliA/IcAfoC
         mJ1cmIuuNuZ0I1Jx9dM1iGTfOwJU4ubp6ZkIf1Q48WGSVqulGu+na8E+JuA2Plv4CrFD
         MTVZlotsa8kip62TOCTXmoqLGNdIL65SxXUH1gTe9J7QfqcxmGdBBVDoXUU8FIcr45Ns
         sysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=c5fNsg2UwF5UocytYwq0XQNimIsx8M/0x2kcxXnzw6s=;
        b=t88MG9O+lK4vsbiYtdtL+hEnc0F1Ivnw5qk3MrmL+Tg4IySBMbkAlC7c9/KBm0K+zn
         gtjchCN/+UhGSyaHRr1blnpM1giXjPpeZEW3LQSrD4/KZMiorYV2p3ji1Ag0CQxMoNtu
         PH7IC38+9eMAPac503zQmK5L4VlB/dDepd/Fy9lCNq2XMy5hM2XSgu413LGvhz4Lk6pF
         19pJt5HZi+5TYSF7M83VPa6W/IhQd2PRNHRXGC0eNVTAi4XQbGdUFaAdY35ruDjYiGBF
         OTCbpw7ykW9lGh2UKp/cX6cbHJM/BI6H98Aa9wygWz83Tk8A20C2ZWKEgbsTrxO1M07n
         Jgjg==
X-Gm-Message-State: AOAM530lKM80YiWP3u8AmfPyCQhyvN1Tx51bktbd7I7mZcVJeckC9Gbl
        3WQZsQb8V/9ew5nGo/eCcgER1g==
X-Google-Smtp-Source: ABdhPJwlSb2HJ2fXreVypNQMIQPBK3ZPIqIThkVchlUswu3+TbmFlW0XsYozNSC0nOOqS5dkRor2sg==
X-Received: by 2002:a92:ca91:: with SMTP id t17mr27317300ilo.67.1608780845418;
        Wed, 23 Dec 2020 19:34:05 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id e9sm18039843ils.14.2020.12.23.19.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 19:34:04 -0800 (PST)
Date:   Wed, 23 Dec 2020 20:34:00 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+QMKC7jPEeThjB1@google.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
 <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 07:09:10PM -0800, Nadav Amit wrote:
> > On Dec 23, 2020, at 6:00 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > 
> > On Wed, Dec 23, 2020 at 05:21:43PM -0800, Andy Lutomirski wrote:
> >> I don’t love this as a long term fix. AFAICT we can have mm_tlb_flush_pending set for quite a while — mprotect seems like it can wait in IO while splitting a huge page, for example. That gives us a window in which every write fault turns into a TLB flush.
> > 
> > mprotect can't run concurrently with a page fault in the first place.
> > 
> > One other near zero cost improvement easy to add if this would be "if
> > (vma->vm_flags & (VM_SOFTDIRTY|VM_UFFD_WP))" and it could be made
> > conditional to the two config options too.
> > 
> > Still I don't mind doing it in some other way, uffd-wp has much easier
> > time doing it in another way in fact.
> > 
> > Whatever performs better is fine, but queuing up pending invalidate
> > ranges don't look very attractive since it'd be a fixed cost that we'd
> > always have to pay even when there's no fault (and there can't be any
> > fault at least for mprotect).
> 
> I think there are other cases in which Andy’s concern is relevant
> (MADV_PAGEOUT).

That patch only demonstrate a rough idea and I should have been
elaborate: if we ever decide to go that direction, we only need to
worry about "jumping through hoops", because the final patch (set)
I have in mind would not only have the build time optimization Andrea
suggested but also include runtime optimizations like skipping
do_swap_page() path and (!PageAnon() || page_mapcount > 1). Rest
assured, the performance impact on do_wp_page() from occasionally an
additional TLB flush on top of a page copy is negligible.

> Perhaps holding some small bitmap based on part of the deferred flushed
> pages (e.g., bits 12-17 of the address or some other kind of a single
> hash-function bloom-filter) would be more performant to avoid (most)
> unnecessary TLB flushes. It will be cleared before a TLB flush and set while
> holding the PTL.
> 
> Checking if a flush is needed, under the PTL, would require a single memory
> access (although potentially cache miss). It will however require one atomic
> operation for each page-table whose PTEs’ flushes are deferred - in contrast
> to the current scheme which requires two atomic operations for the *entire*
> operation.
> 
