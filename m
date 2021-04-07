Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489E2357731
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 23:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhDGVy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 17:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhDGVyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 17:54:12 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AF4C061760
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 14:54:00 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id o10so331967ybb.10
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 14:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qSKZ/zEzpmbDXT0Q0jFUNPyUjYJ+F06qfcHUebPcLPY=;
        b=LmjHMIQwJFMfumw9LCG+ZM0u5IdFjEaJco7DCMayKiUmG5tE6ceosO9W1CHG+cXYPC
         mwFoHH+pZ9nSr1Jjww16GV6P+hw5+DT02OkdxzDfBSJJVAQhuya2udTjgZ0RKxvd0TPn
         iDvx5rwGQK/mzebVY2kAECagq97CRju8glqXg20+5a0LUxR6xP3OsM8tw1/Fx7tRR9Ry
         yz4iNgYFNGfgdmlm+WERc4Z7f72O7RKBw4fDWhYkprjwhF2cCVHYusSc2LR75MbitUXl
         Od8xPhOUlwT3D72ksGPr+NclNaQA8vqem7mGKyVCAaghEvWPRtoTJ6aIXJxcgT2Gt+Uq
         nKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qSKZ/zEzpmbDXT0Q0jFUNPyUjYJ+F06qfcHUebPcLPY=;
        b=fKXXltyjjgXStYVU8MxCDwXk+z+h20STqUjFDQCewSTJHZwTM1XkMEIQEu1h0xrv2/
         zHmgx3kiQ9MJyk9FY/rRGef+JOdg49f1t8rbA6Qa6AjsA4Z/BNliPxVs/JdhrvkTua5z
         1GUZzbKpS/0u8huFJE1tN58c4ZAZu4+zIVK/hf4mBKPvLXEk9lEIPMfX7D47LQNhvNWx
         UjYMWImR0vYkm2r2WGWhQ7LAzEiLLVyh5xOVO+kOvpf+HUkPkZI5sCuKDNMB9OwO33Ry
         VWD7/8RWpfN/pwgq4nRT27YTtorDUcwtdm5dQV1GkJy0fjT62ZoWawkv0qYrLFU0h7cz
         P40g==
X-Gm-Message-State: AOAM533PCrvS1+MhVv+lU9kVDLj+6ITJY5cUVGM04yDD+D743g2KQ8pQ
        Uyl6150JUsex/jaU/JSfTf0EOjmRXDhq5DemvcnerQ==
X-Google-Smtp-Source: ABdhPJxJa03Iqg07zj4umpmCWtd/JLxDcgePZJDBJADsvgkqM1NARMsXdow7rTp27HOMb2yv4Rp5BEyH3wIgSPdLc6c=
X-Received: by 2002:a25:7d81:: with SMTP id y123mr6818055ybc.294.1617832440056;
 Wed, 07 Apr 2021 14:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
 <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
 <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com>
In-Reply-To: <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 7 Apr 2021 14:53:49 -0700
Message-ID: <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
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

On Wed, Apr 7, 2021 at 12:23 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Apr 7, 2021 at 11:47 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > So, we fixed it, but we don't know why.
> >
> > Peter Xu's patchset that fixed it is here:
> > https://lore.kernel.org/lkml/20200821234958.7896-1-peterx@redhat.com/
>
> Yeah, that's the part that ends up being really painful to backport
> (with all the subsequent fixes too), so the 4.14 people would prefer
> to avoid it.
>
> But I think that if it's a "requires dax pmem and ptrace on top", it
> may simply be a non-issue for those users. Although who knows - maybe
> that ends up being a real issue on Android..

A lot to digest, so I need to do some reading now. Thanks everyone!

>
>             Linus
