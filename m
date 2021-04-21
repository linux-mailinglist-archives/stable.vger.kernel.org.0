Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA33673EE
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 22:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245616AbhDUUCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 16:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245615AbhDUUCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 16:02:20 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790E6C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 13:01:46 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id z1so48577130ybf.6
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 13:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N25SjpwU7jt3YRnEr3GAIUXkZUK/W3lOm1cYE1CKpNY=;
        b=G7JYVKHjK6F2HUO6B+H/oniSDXpZCAbY6/ho8+v+7JRI1O7sVMjJG/E2nCFROq5VAP
         +Jt7jLWKKZBfOwWgvgqy8Ur/t5ajGyAgwyLpElgr4TjYopQl7dHBJE4da6V4HGshitmW
         gbP81GI1ewkJa3zZLvG6xegeMt/5R0rm+yybtswjGH2Kmsfha998wgHtXHHWtKneBBQT
         HETYMqY+rFcm5ZFosLVKAun4cMDUVO1HwTDvICbago+LXQm0SgV1xivHgbL505g3j0Zf
         XrtShRPqu6kbRzPysQJxwGhcnAvgtqcW8DwlTpcsxH7PcE/u9Gcx8WbVYudRisMwf7MM
         pk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N25SjpwU7jt3YRnEr3GAIUXkZUK/W3lOm1cYE1CKpNY=;
        b=qb2XzbP2s79uE/Nf9t75YMT2grrV7lXL0Gxkvus/K1CS2eTaV2TwuFV3H2YSR5CY+C
         eBjsqYlNI/Zcfm4lSiPteVAxiC7aAqNEMbhi0y3/A31F20HMGNI2ZrXwMBYZKG8O36hC
         9bAmMutunQUxXhj6K+v7R96fwTamXg6EGdN+qT2vgJPgREG6Thb75vvjWxjfeSQZnpF0
         A4eaUb5oYX3Kdz1cGdOhSrxu7gAGTVNUJZqaQ2j8QlXLqIzoJbDzf7iSlSOg2q1Av6q+
         lYbHVCulTIlmdCNycQOVeLTdHnQbJ88RkzW/hHcTQhU0WLh6LgToiB+GOoFI/NSuzqKa
         rdWg==
X-Gm-Message-State: AOAM5338gNAX7QYPfND9qroYHFoEXA+5vk1I2M2HMfaUxSBqpkHID4BK
        r4Iq944YxfHxz161IMPwKKmmRzdi4FgxrWFveJXzWA==
X-Google-Smtp-Source: ABdhPJxQawgMOAh8U7mORlWyVS1yUZDsWs9dCsjLPG9HijkOotn83qeRYhVGs7QfLaIKXNmHvhQBKIT8OxVw9st4uGc=
X-Received: by 2002:a5b:7c5:: with SMTP id t5mr34532781ybq.190.1619035305484;
 Wed, 21 Apr 2021 13:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
 <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
 <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com> <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
In-Reply-To: <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 21 Apr 2021 13:01:34 -0700
Message-ID: <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Peter Xu <peterx@redhat.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 7, 2021 at 2:53 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Wed, Apr 7, 2021 at 12:23 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Wed, Apr 7, 2021 at 11:47 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > >
> > > So, we fixed it, but we don't know why.
> > >
> > > Peter Xu's patchset that fixed it is here:
> > > https://lore.kernel.org/lkml/20200821234958.7896-1-peterx@redhat.com/
> >
> > Yeah, that's the part that ends up being really painful to backport
> > (with all the subsequent fixes too), so the 4.14 people would prefer
> > to avoid it.
> >
> > But I think that if it's a "requires dax pmem and ptrace on top", it
> > may simply be a non-issue for those users. Although who knows - maybe
> > that ends up being a real issue on Android..
>
> A lot to digest, so I need to do some reading now. Thanks everyone!

After a delay due to vacation I prepared backports of 17839856fd58
("gup: document and work around "COW can break either way" issue") for
4.14 and 4.19 kernels. As Linus pointed out, uffd-wp was introduced
later in 5.7, so is not an issue for 4.x kernels. The issue with THPs
is still unresolved, so with or without this patch it's still there
(Android is not affected by this since we do not use THPs with older
kernels).
Andrea pointed out that there are other issues and to properly fix
them his COR approach is needed. However it has not been accepted yet,
so I can't really backport it. I'll be happy to do that though if it
is accepted in the future.

Peter, you mentioned https://lkml.org/lkml/2020/8/10/439 patch to
distinguish real writes vs enforced COW read requests, however I also
see that you had a later version of this patch here:
https://lore.kernel.org/patchwork/patch/1286506/. Which one should I
backport? Or is it not needed in the absence of uffd-wp support in the
earlier kernels?
Thanks,
Suren.

>
> >
> >             Linus
