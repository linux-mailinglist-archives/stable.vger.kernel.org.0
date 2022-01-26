Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF07849D1F4
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiAZSoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAZSoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:44:01 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6ABC06161C;
        Wed, 26 Jan 2022 10:44:00 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id j2so523465ejk.6;
        Wed, 26 Jan 2022 10:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xhMYYbSJZTw22nCa/vVztqO0cHAPZe/cx7Ub7sfyKHM=;
        b=OypkHNl/QZB3tAuPAy71GYYwokVZsZhgIQhWbQa4MyKDx9k8grUA4ckm+Ii68YAsMJ
         exTVYHl8HptKpwEDgkd6z+ULRg2sJFi2d7zy5hcfheW+ypaBk4rMxtunIvjZ5MipeX2J
         QJkIIgSZeq1v5vXlTY8z7sJ9LSvW5tfTYyd6cgVs1WAPFeuARaTD8eUy5zGk1tZYgotY
         PiIousOzS3Cj/ppcG9eClwrMwN76JsC2/eRkKNAowO65t/FYzOrRST5mUb8R2U5/LCcI
         e88gEsJC9+5DYo7s8KHhHncEFexu3Xy0tFqcoq8qFQKMtz7JtOoOhAzNu2e7jiFhBKUf
         XZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xhMYYbSJZTw22nCa/vVztqO0cHAPZe/cx7Ub7sfyKHM=;
        b=IbyelXgE3dYVJz7SaIWSiEdzotPAhcgWleg9GpRCqH4hlti+8qlWSDwrTFgrKACotw
         3UvkkkqvM6z8E0t64KS6ub3mRA3BawHddeaUF8WOnoKhoq3OUFVOA6+5GO4qKuXIYEPF
         LLm+0PVZJEZ6kkDziAkH6NHj2zQ4Ymk2hpmw5WAo+gqI6Sg/GVuk8JCL7MRDt2P+v2yx
         VEBys8n6b9A8zcSKLPsniwqTeIX2/rKEpTHzBJJJmwevGgjbYu0XwLDLXGASiD8W4VlD
         JDr28nd+Qfbi5whm0nxcJBm0PiR2kja/RftW+3Pn1slZXv4aEi9Zq/4P+KY+NnQVr7a5
         hGbQ==
X-Gm-Message-State: AOAM532tDJZhsxtEAVjKbRhFkQyoAkXW64Nl38L0fb7QUmijUOKQ4aHd
        Vj144JGLMSi6uIF7vfSRCMsGoG8ghHbaPdLNzkU=
X-Google-Smtp-Source: ABdhPJwjkwANIA7P2TAchz64JmzTOs7F9nutdH7UV5Cr94JxsU8lvCDSv3GQMoEe801HHkLVoT/aWn+tS2QpPzm9Ebo=
X-Received: by 2002:a17:907:6089:: with SMTP id ht9mr63061ejc.612.1643222639502;
 Wed, 26 Jan 2022 10:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20220120202805.3369-1-shy828301@gmail.com> <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
 <f7f82234-7599-9e39-1108-f8fbe2c1efc9@redhat.com> <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
 <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com> <CAHbLzkqLTkVJk+z8wpa03ponf7k30=Sx6qULwsGsvr5cq5d1aw@mail.gmail.com>
 <5a565d5a-0540-4041-ce63-a8fd5d1bb340@redhat.com>
In-Reply-To: <5a565d5a-0540-4041-ce63-a8fd5d1bb340@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 26 Jan 2022 10:43:47 -0800
Message-ID: <CAHbLzkqXy-W9sD5HFOK_rm_TR8uSP29b+RjKjA5zOZ+0dkqMbQ@mail.gmail.com>
Subject: Re: [v2 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     David Hildenbrand <david@redhat.com>
Cc:     Jann Horn <jannh@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 8:58 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 26.01.22 17:53, Yang Shi wrote:
> > On Wed, Jan 26, 2022 at 3:57 AM David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 26.01.22 12:48, Jann Horn wrote:
> >>> On Wed, Jan 26, 2022 at 12:38 PM David Hildenbrand <david@redhat.com> wrote:
> >>>> On 26.01.22 12:29, Jann Horn wrote:
> >>>>> On Wed, Jan 26, 2022 at 11:51 AM David Hildenbrand <david@redhat.com> wrote:
> >>>>>> On 20.01.22 21:28, Yang Shi wrote:
> >>>>>>> The syzbot reported the below BUG:
> >>>>>>>
> >>>>>>> kernel BUG at include/linux/page-flags.h:785!
> >>> [...]
> >>>>>>> RIP: 0010:PageDoubleMap include/linux/page-flags.h:785 [inline]
> >>>>>>> RIP: 0010:__page_mapcount+0x2d2/0x350 mm/util.c:744
> >>> [...]
> >>>>>> Does this point at the bigger issue that reading the mapcount without
> >>>>>> having the page locked is completely unstable?
> >>>>>
> >>>>> (See also https://lore.kernel.org/all/CAG48ez0M=iwJu=Q8yUQHD-+eZDg6ZF8QCF86Sb=CN1petP=Y0Q@mail.gmail.com/
> >>>>> for context.)
> >>>>
> >>>> Thanks for the pointer.
> >>>>
> >>>>>
> >>>>> I'm not sure what you mean by "unstable". Do you mean "the result is
> >>>>> not guaranteed to still be valid when the call returns", "the result
> >>>>> might not have ever been valid", or "the call might crash because the
> >>>>> page's state as a compound page is unstable"?
> >>>>
> >>>> A little bit of everything :)
> >>> [...]
> >>>>> In case you mean "the result might not have ever been valid":
> >>>>> Yes, even with this patch applied, in theory concurrent THP splits
> >>>>> could cause us to count some page mappings twice. Arguably that's not
> >>>>> entirely correct.
> >>>>
> >>>> Yes, the snapshot is not atomic and, thereby, unreliable. That what I
> >>>> mostly meant as "unstable".
> >>>>
> >>>>>
> >>>>> In case you mean "the call might crash because the page's state as a
> >>>>> compound page could concurrently change":
> >>>>
> >>>> I think that's just a side-product of the snapshot not being "correct",
> >>>> right?
> >>>
> >>> I guess you could see it that way? The way I look at it is that
> >>> page_mapcount() is designed to return a number that's at least as high
> >>> as the number of mappings (rarely higher due to races), and using
> >>> page_mapcount() on an unlocked page is legitimate if you're fine with
> >>> the rare double-counting of references. In my view, the problem here
> >>> is:
> >>>
> >>> There are different types of references to "struct page" - some of
> >>> them allow you to call page_mapcount(), some don't. And in particular,
> >>> get_page() doesn't give you a reference that can be used with
> >>> page_mapcount(), but locking a (real, non-migration) PTE pointing to
> >>> the page does give you such a reference.
> >>
> >> I assume the point is that as long as the page cannot be unmapped
> >> because you block it from getting unmapped (PT lock), the compound page
> >> cannot get split. As long as the page cannot get unmapped from that page
> >> table you should have at least a mapcount of 1.
> >
> > If you mean holding ptl could prevent THP from splitting, then it is
> > not true since you may be in the middle of THP split just exactly like
> > the race condition solved by this patch.
>
> While you hold the PT lock and discover a mapped page, unmap_page()
> cannot continue and unmap the page. That's what I meant "as long as the
> page cannot be unmapped".
>
> What doesn't work is if you hold the PT lock and discover a migration
> entry, because then you're already past unmap_page(). That's the issue
> you're fixing.

Yeah, it means you lose the race :-(

>
> >
> > Just page lock or elevated page refcount could serialize against THP
> > split AFAIK.
> >
> >>
> >> But yeah, using the mapcount of a page that is not even mapped
> >> (migration entry) is clearly wrong.
> >>
> >> To summarize: reading the mapcount on an unlocked page will easily
> >> return a wrong result and the result should not be relied upon. reading
> >> the mapcount of a migration entry is dangerous and certainly wrong.
> >
> > Depends on your usecase. Some just want to get a snapshot, just like
> > smaps, they don't care.
>
> Right, but as discussed, even the snapshot might be slightly wrong. That
> might be just fine for smaps (and I would have enjoyed a comment in the
> code stating that :) ).

I think that is documented already, see Documentation/filesystems/proc.rst:

Note: reading /proc/PID/maps or /proc/PID/smaps is inherently racy (consistent
output can be achieved only in the single read call).

Of course, if the extra note is preferred in the code, I could try to
add some in a separate patch.

>
>
> --
> Thanks,
>
> David / dhildenb
>
