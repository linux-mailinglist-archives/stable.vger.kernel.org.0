Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF921A960C
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 10:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635787AbgDOIR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635783AbgDOIR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 04:17:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24DAC061A0E
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 01:17:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w20so16227162iob.2
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 01:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rAypnYUnXisby7UlcQ7L0AAFJ3z67DBgCY5ZgoNKK8Q=;
        b=FQwPhsPU/y150kdNSN7l6yoOpQ678zrX/Vm1csBZe4kOE6eyD0/0i1NYn9Ki4MWCHE
         t1h6P4Nn7LZCfH81dMhvQP19MY7wAv/Ab1eHefzFb5CrbhPJ0S5TPYITtjJm5mmkvy8o
         uk5rlfw0unadsJJiFEKCvgBYkz2Qnfo9pWC/fl3NSK2kAQ4mQ7eSExWwdYf11mER8MzD
         AUwmXhQzBlCTgY9x7HBtTYXO8WJYVUuoYV1ON1ykJKtwShWzg7E+tQvYK9LWP6fQwBSH
         mnEJm1+V7nQJyBRtWt6Cm30UFQV61hNeCZquyDgNrS6fICsZJ5wbV0fNNw6jllBa/9jD
         uQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAypnYUnXisby7UlcQ7L0AAFJ3z67DBgCY5ZgoNKK8Q=;
        b=P9jvgxrLyKulC2Et1e1cBpEOut5F9j57FQn69OvksNeVJM+z40YOpQhyQTnCvUbq8M
         HrOrDOTGgs25DMQXNaaXCIS30ZGqYc/LEdzv6Gxic8WS3yF4xb+Topiy6K1aOkcouTDI
         zQS5AOe9RHp4BO+lDfrHl6+mXyEvuhNj2dGPmpUX3EToBnHDRxcXnrU/6EszrsslpNgv
         0NGq9JKq/iKvQeQc8XikkNK743bSivylqeDrtX/f97j5fq8E6hfXHCAzBq9SQMq4nrCc
         zNPvIZ155HPn1If5Ne0KmtqoZg8pOsDdUTNOeJARUMDeu5e+CRWM5lF86Ide4bv/3Ot0
         urwA==
X-Gm-Message-State: AGi0PuYR3YknlnnBCILNg1bIx61va6T69LqLRja7omrqn1AsvzMgi1Fc
        TOzrigXP5C7Xr7ukK8zSH3OGNNmYhMQNLC3TyqD5mg==
X-Google-Smtp-Source: APiQypLwRH2La++nsaPlDKXdOv+A6GfmbGXRRtF1yYRthvSDrDZUF5J/vfGtymisXsd11i0Iubq2lLPvgRAbELtheNw=
X-Received: by 2002:a02:cca3:: with SMTP id t3mr16773558jap.3.1586938646282;
 Wed, 15 Apr 2020 01:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200415015410.glIzXqR5d%akpm@linux-foundation.org> <49e65ca7-03a2-9a82-9e1a-cf997320bcfd@virtuozzo.com>
In-Reply-To: <49e65ca7-03a2-9a82-9e1a-cf997320bcfd@virtuozzo.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Wed, 15 Apr 2020 16:16:50 +0800
Message-ID: <CAMZfGtWwE_9uSH9Vw+W2yJJhMo4BfWHx_PME+HD5h3r+A3zXeg@mail.gmail.com>
Subject: Re: [External] Re: + mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
 added to -mm tree
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        Xiongchun duan <duanxiongchun@bytedance.com>, hughd@google.com,
        imbrenda@linux.vnet.ibm.com,
        Markus Elfring <Markus.Elfring@web.de>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        yang.shi@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 3:44 PM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
>
> On 15.04.2020 04:54, Andrew Morton wrote:
> >
> > The patch titled
> >      Subject: mm/ksm: fix NULL pointer dereference when KSM zero page is enabled
> > has been added to the -mm tree.  Its filename is
> >      mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> >
> > This patch should soon appear at
> >     http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> > and later at
> >     http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> >
> > ------------------------------------------------------
> > From: Muchun Song <songmuchun@bytedance.com>
> > Subject: mm/ksm: fix NULL pointer dereference when KSM zero page is enabled
> >
> > find_mergeable_vma can return NULL.  In this case, it leads to crash when
> > we access vma->vm_mm(its offset is 0x40) later in write_protect_page.  And
> > this case did happen on our server.  The following calltrace is captured
> > in kernel 4.19 with the following patch applied and KSM zero page enabled
> > on our server.
> >
> >   commit e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")
> >
> > So add a vma check to fix it.
> >
> > --------------------------------------------------------------------------
> >   BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> >   Oops: 0000 [#1] SMP NOPTI
> >   CPU: 9 PID: 510 Comm: ksmd Kdump: loaded Tainted: G OE 4.19.36.bsk.9-amd64 #4.19.36.bsk.9
> >   Hardware name: FOXCONN R-5111/GROOT, BIOS IC1B111F 08/17/2019
> >   RIP: 0010:try_to_merge_one_page+0xc7/0x760
> >   Code: 24 58 65 48 33 34 25 28 00 00 00 89 e8 0f 85 a3 06 00 00 48 83 c4
> >         60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 46 08 a8 01 75 b8 <49>
> >         8b 44 24 40 4c 8d 7c 24 20 b9 07 00 00 00 4c 89 e6 4c 89 ff 48
> >   RSP: 0018:ffffadbdd9fffdb0 EFLAGS: 00010246
> >   RAX: ffffda83ffd4be08 RBX: ffffda83ffd4be40 RCX: 0000002c6e800000
> >   RDX: 0000000000000000 RSI: ffffda83ffd4be40 RDI: 0000000000000000
> >   RBP: ffffa11939f02ec0 R08: 0000000094e1a447 R09: 00000000abe76577
> >   R10: 0000000000000962 R11: 0000000000004e6a R12: 0000000000000000
> >   R13: ffffda83b1e06380 R14: ffffa18f31f072c0 R15: ffffda83ffd4be40
> >   FS: 0000000000000000(0000) GS:ffffa0da43b80000(0000) knlGS:0000000000000000
> >   CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 0000000000000040 CR3: 0000002c77c0a003 CR4: 00000000007626e0
> >   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >   PKRU: 55555554
> >   Call Trace:
> >     ? follow_page_pte+0x36d/0x5e0
> >     ksm_scan_thread+0x115e/0x1960
> >     ? remove_wait_queue+0x60/0x60
> >     kthread+0xf5/0x130
> >     ? try_to_merge_with_ksm_page+0x90/0x90
> >     ? kthread_create_worker_on_cpu+0x70/0x70
> >     ret_from_fork+0x1f/0x30
> > --------------------------------------------------------------------------
> >
> > Link: http://lkml.kernel.org/r/20200414132905.83819-1-songmuchun@bytedance.com
> > Fixes: e86c59b1b12d ("mm/ksm: improve deduplication of zero pages with colouring")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Co-developed-by: Xiongchun Duan <duanxiongchun@bytedance.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
>
> Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Yang Shi <yang.shi@linux.alibaba.com>
> > Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
> > Cc: Markus Elfring <Markus.Elfring@web.de>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  mm/ksm.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > --- a/mm/ksm.c~mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled
> > +++ a/mm/ksm.c
> > @@ -2112,8 +2112,11 @@ static void cmp_and_merge_page(struct pa
> >
> >               down_read(&mm->mmap_sem);
> >               vma = find_mergeable_vma(mm, rmap_item->address);
> > -             err = try_to_merge_one_page(vma, page,
> > -                                         ZERO_PAGE(rmap_item->address));
> > +             if (vma)
> > +                     err = try_to_merge_one_page(vma, page,
> > +                                     ZERO_PAGE(rmap_item->address));
> > +             else
> > +                     err = -EFAULT;
> >               up_read(&mm->mmap_sem);
>
> In case of vma is out of date, we also may consider to exit this function without
> calling unstable_tree_search_insert().

Yeah, I agree with you. Should I send another patch to fix this patch
or an upgraded
version(v4) of this patch.

>
> >               /*
> >                * In case of failure, the page was not really empty, so we
> > _
> >
> > Patches currently in -mm which might be from songmuchun@bytedance.com are
> >
> > mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
> >
>


-- 
Yours,
Muchun
