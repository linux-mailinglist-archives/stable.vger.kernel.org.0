Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74004367582
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 01:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343640AbhDUXGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 19:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhDUXGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 19:06:09 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB82C06138A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 16:05:34 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 65so49132523ybc.4
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 16:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NEm8gM/fSFaOWMqgyzI8qdXody5lDepUX4v4tPFO86g=;
        b=KoOKl0PZnkPYe4SbhkaZQMToH15XqcFEE8rWO4Qhmv2eaa+W9fr2mthitUxLXVJ2DH
         OV+v9u4Klp87pG+hFBzsX2EViQ79xaZEtq0X31P409NbL5DeB8lKDdl762/BhZ0oMOub
         UTHQkikHjwVWJOPjMjYHJ6VtrL2unlmZbRE6aCwioGmcRE6QhS1CpUBaON7HMRT7kB95
         KC3GSmnkPxMKYy7gosgBEmszbBxF4iI56jcyJoJUliH67juEnHThej112XIOlbp1YyB2
         TzMZRIPXo6xc5DQTEy1kE/fR3ys98BxZSWKHDzRs+RE+3Lr7fDJ7J/d+nJdqEXVAff0W
         cZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NEm8gM/fSFaOWMqgyzI8qdXody5lDepUX4v4tPFO86g=;
        b=UwnqFE3EpEgzn1mnCxt65AnvTJ1Rlo7HmpRc/P87fJbEfRlDB8uoiwpkEol/7nkP/Z
         4q/EALcEZzoC4mr+AVqmSyhCW/x4qQAe2wiIgCcxMVw2OK6UjWh6Bsz6XSGVNfR6mIQG
         3ZyZ3fBGfthQejJ2QaBv6XMDmJoN+WJYsA5EqD2m3Oyp51EInZvOtOx3KK2PCBsbARy5
         Gl9WhhFMU2ZLaXmFprHmzb4SCeedTl19xSdfLI8Rczz+pOruwjk1iia3Xp4ZJfVl9hh7
         K6ykKmXYyTGoKijnmtrNJZWXHTOI8RM9Uyh8oeVE5X+9XbsGej2oF3GzrmNztvImOY8R
         O8Ug==
X-Gm-Message-State: AOAM532+p9Dbmd2R3+dnDld5gZmeWGdNOeo4Zn+V/sAJ4y6yQvr7+Ryr
        Wk2MRSMOqm1oR1DXC4VZmpXubZYwSOnJlVvXCF16sw==
X-Google-Smtp-Source: ABdhPJyKbZa8U1MlpCzEY3rcgzVqE0BZYxwai22fqQrt69eElmxl+gpvB70oKTySO29O1LJPigy4RIGEBwDeFrfQz6c=
X-Received: by 2002:a25:dc02:: with SMTP id y2mr523853ybe.23.1619046334091;
 Wed, 21 Apr 2021 16:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
 <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
 <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com>
 <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
 <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com> <01f47bcc-ed9d-85c0-2dd1-a7f604d1ad28@suse.cz>
In-Reply-To: <01f47bcc-ed9d-85c0-2dd1-a7f604d1ad28@suse.cz>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 21 Apr 2021 16:05:23 -0700
Message-ID: <CAJuCfpHSXUc9+xVSeRWoiWKZKFxnBJGtd_CNicTdAEVs_ZyHKA@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Xu <peterx@redhat.com>, stable <stable@vger.kernel.org>,
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

On Wed, Apr 21, 2021 at 3:59 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 4/21/21 10:01 PM, Suren Baghdasaryan wrote:
> > On Wed, Apr 7, 2021 at 2:53 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >>
> >> On Wed, Apr 7, 2021 at 12:23 PM Linus Torvalds
> >> <torvalds@linux-foundation.org> wrote:
> >> >
> >> > On Wed, Apr 7, 2021 at 11:47 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> > >
> >> > > So, we fixed it, but we don't know why.
> >> > >
> >> > > Peter Xu's patchset that fixed it is here:
> >> > > https://lore.kernel.org/lkml/20200821234958.7896-1-peterx@redhat.com/
> >> >
> >> > Yeah, that's the part that ends up being really painful to backport
> >> > (with all the subsequent fixes too), so the 4.14 people would prefer
> >> > to avoid it.
> >> >
> >> > But I think that if it's a "requires dax pmem and ptrace on top", it
> >> > may simply be a non-issue for those users. Although who knows - maybe
> >> > that ends up being a real issue on Android..
> >>
> >> A lot to digest, so I need to do some reading now. Thanks everyone!
> >
> > After a delay due to vacation I prepared backports of 17839856fd58
> > ("gup: document and work around "COW can break either way" issue") for
> > 4.14 and 4.19 kernels. As Linus pointed out, uffd-wp was introduced
> > later in 5.7, so is not an issue for 4.x kernels. The issue with THPs
> > is still unresolved, so with or without this patch it's still there
> > (Android is not affected by this since we do not use THPs with older
> > kernels).
>
> Which THP issue do you mean here? The race that was part of the same Project
> zero report and was solved by a different patch adding some locking? Or the
> vmsplice info leak but applied to THP's? Because if it's the latter then I
> believe 17839856fd58 did solve that too. It was the later switch of approach to
> rely just on page_count() that left THP side unfixed.

I meant the "vmsplice info leak applied to THP's" but now I realize
that 17839856fd58 does not use elevated reference count, so indeed
that should not be a problem. Thanks for the note!

>
> > Andrea pointed out that there are other issues and to properly fix
> > them his COR approach is needed. However it has not been accepted yet,
> > so I can't really backport it. I'll be happy to do that though if it
> > is accepted in the future.
> >
> > Peter, you mentioned https://lkml.org/lkml/2020/8/10/439 patch to
> > distinguish real writes vs enforced COW read requests, however I also
> > see that you had a later version of this patch here:
> > https://lore.kernel.org/patchwork/patch/1286506/. Which one should I
> > backport? Or is it not needed in the absence of uffd-wp support in the
> > earlier kernels?
> > Thanks,
> > Suren.
> >
> >>
> >> >
> >> >             Linus
> >
>
