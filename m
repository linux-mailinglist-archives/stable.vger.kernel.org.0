Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F442E00D6
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 20:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgLUTRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 14:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgLUTRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 14:17:07 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44482C0613D6
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:16:27 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id w18so9868031iot.0
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=L3Gs6WqmH8kL8ZhxKYgFmuIwY0FVCfgjiIRrG/rLCoQ=;
        b=XR1oBnHY+FNDw8Pofg87UATPJwTQibIHCH0Wtd8KJvWHmSPCZRxXSfyyWDthuOtjpz
         eUEwuy4LEK+L7MORftyvnd3nSvXZM4VTd15C+RXRfz2XUWlMdOaGDfdHfR1QXaUseVO6
         gIBis0u7qXKe8TzrNEGpL0BxU2h7AAGZihNGcDMktPLtjZdjlYJNnvs3klod/1dOfcFu
         wvZd7rZZOO926AziaTBTKvMeVO+b7cG1etMxlCrwvNLpR7qsCUovMewcZtn+4rKqWvOW
         0Q+LAbozXG3rhB6WbprSCV/ddPOXiHpgoQKrJt+vGt6bjMu0c0Im9Ncl8ob9qQXnFcnq
         UYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=L3Gs6WqmH8kL8ZhxKYgFmuIwY0FVCfgjiIRrG/rLCoQ=;
        b=NyPDBsVgZxrcT/kuRapKij6wAIPFz6si4LhqrnhqCo1MA4MaSUxxdBGyIoNWSrBfKM
         eIFyClU5mMbnReefX8dIG0mPpC1ej4mrzEwINomBbspf0jdCiJEXuictNQuPdvtEp7wD
         cWUKO5pJ8vy8b9BUYcj9B/r6AvSBUyw2ehnrbtDWonCFH93Ocy6Lp67H44BxtkkhaVlO
         5sZWMTOV/Px/z2n8TORsNklQGBf2g7gXVceDpuEHDP5fdMAOh1AonyS2fCyboU9j7NPt
         3Ah84A/+pL0d5dSDe+/RZ0efNMxq1QTWG0KgA4ZlBg9img8XDBSQ5czyzAIrE+9qw7oc
         NZPA==
X-Gm-Message-State: AOAM533LrL5ftT2hDRCB5JZaq/EDDHN2O9Ih/UzJ1sL7oAO6pUi696jj
        zUIItL7xNqIeAkQrwXISmocWOQ==
X-Google-Smtp-Source: ABdhPJwOsREO3Cv01bkG3byoUcuKvOsFEAK5JGQ1eGqIHRODacDApA3vawIoWmAz77JL8ZnCmtxJhA==
X-Received: by 2002:a5e:9b06:: with SMTP id j6mr15203388iok.171.1608578186432;
        Mon, 21 Dec 2020 11:16:26 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id o10sm14812859ili.82.2020.12.21.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:16:25 -0800 (PST)
Date:   Mon, 21 Dec 2020 12:16:21 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+D0hTZCrWS3P5Pi@google.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 10:31:57AM -0800, Nadav Amit wrote:
> > On Dec 21, 2020, at 9:27 AM, Peter Xu <peterx@redhat.com> wrote:
> > 
> > Hi, Nadav,
> > 
> > On Sun, Dec 20, 2020 at 12:06:38AM -0800, Nadav Amit wrote:
> > 
> > [...]
> > 
> >> So to correct myself, I think that what I really encountered was actually
> >> during MM_CP_UFFD_WP_RESOLVE (i.e., when the protection is removed). The
> >> problem was that in this case the “write”-bit was removed during unprotect.
> >> Sorry for the strange formatting to fit within 80 columns:
> > 
> > I assume I can ignore the race mentioned in the commit message but only refer
> > to this one below.  However I'm still confused.  Please see below.
> > 
> >> [ Start: PTE is writable ]
> >> 
> >> cpu0				cpu1			cpu2
> >> ----				----			----
> >> 							[ Writable PTE 
> >> 							  cached in TLB ]
> > 
> > Here cpu2 got writable pte in tlb.  But why?
> > 
> > If below is an unprotect, it means it must have been protected once by
> > userfaultfd, right?  If so, the previous change_protection_range() which did
> > the wr-protect should have done a tlb flush already before it returns (since
> > pages>0 - we protected one pte at least).  Then I can't see why cpu2 tlb has
> > stall data.
> 
> Thanks, Peter. Just as you can munprotect() a region which was not protected
> before, you can ufff-unprotect a region that was not protected before. It
> might be that the user tried to unprotect a large region, which was
> partially protected and partially unprotected.
> 
> The selftest obviously blindly unprotect some regions to check for bugs.
> 
> So to your question - it was not write-protected (think about initial copy
> without write-protecting).
> 
> > If I assume cpu2 doesn't have that cached tlb, then "write to old page" won't
> > happen either, because cpu1/cpu2 will all go through the cow path and pgtable
> > lock should serialize them.
> > 
> >> userfaultfd_writeprotect()				
> >> [ write-*unprotect* ]
> >> mwriteprotect_range()
> >> mmap_read_lock()
> >> change_protection()
> >> 
> >> change_protection_range()
> >> ...
> >> change_pte_range()
> >> [ *clear* “write”-bit ]
> >> [ defer TLB flushes]
> >> 				[ page-fault ]
> >> 				…
> >> 				wp_page_copy()
> >> 				 cow_user_page()
> >> 				  [ copy page ]
> >> 							[ write to old
> >> 							  page ]
> >> 				…
> >> 				 set_pte_at_notify()
> >> 
> >> [ End: cpu2 write not copied form old to new page. ]
> > 
> > Could you share how to reproduce the problem?  I would be glad to give it a
> > shot as well.
> 
> You can run the selftests/userfaultfd with my small patch [1]. I ran it with
> the following parameters: “ ./userfaultfd anon 100 100 “. I think that it is
> more easily reproducible with “mitigations=off idle=poll” as kernel
> parameters.
> 
> [1] https://lore.kernel.org/patchwork/patch/1346386/

Hi Linus,

Nadav Amit found memory corruptions when running userfaultfd test above.
It seems to me the problem is related to commit 09854ba94c6a ("mm:
do_wp_page() simplification"). Can you please take a look? Thanks.

TL;DR: it may not safe to make copies of singly mapped (non-COW) pages
when it's locked or has additional ref count because concurrent
clear_soft_dirty or change_pte_range may have removed pte_write but yet
to flush tlb.
