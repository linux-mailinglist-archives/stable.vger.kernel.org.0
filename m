Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7379D3674BA
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 23:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243963AbhDUVRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 17:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243828AbhDUVRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 17:17:49 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37FDC06138A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 14:17:15 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id c195so48816669ybf.9
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 14:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wlc9Tv/D2ysgWWhvGsMGrJsw0e3hrEy5mirf5jB9mBY=;
        b=V5pyH5ReSKB9rU4npbd87vXwXwWWTH7h8UU8TR/Suv2TxNRmTuGl/fqPL98NhNUkC/
         +ajkW8eNKaYWfImX0Gh5l4WOzc3luCRq2kyEqbW4+L1bDJhVN2t+K2UFKSFMK615+p1W
         fokRZFe+EWqx9mrTpXAe9g0IWKG4gjMP9EsJ/TfhEcWAEX5ocwJiL74Jv/D599AHIHzW
         Ep9qeWMGCEKoTlYw4pwVueK3m7PX67tGmd05/woT8t/ugFcCPEkyJvtL05lptwKIzgNs
         cpj8rlRK9v1YgCn2JqZIvOd4+pP31q5VTcAXlPsqsi8ibxSw0iD1AvNJIbT34j0cCo1S
         wBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wlc9Tv/D2ysgWWhvGsMGrJsw0e3hrEy5mirf5jB9mBY=;
        b=T4auju7rSrFN1rwOdca4s2ewSlr2bAtYTIm2cWyn4TbbuxkqMUjxyJ4n5FyHYPmCOi
         4IK3aSImBAgOVqW7BCxCPyZJFCDwNAH5PbL2pZ+i0S6/RsPFS0qKUL5CUnny5om7XAEx
         IWf2wM4qX4x86RkS+W3HAm0cx+X+cCuXnF2K9nMBrqxYTMn9s0cVswU4zMEbwP25Ecqp
         RBdCIDHgL+wGTQ/mc7bkHh8aA/t2ArbFa3sSNqYJw7/Sd+SPDRTuhfIyarUPheySmC9s
         9ReTi2XpGHlLZ+jIlu8UpHgQ8bBfPROxiMqwqZhaGiSJFAsk+5BIywg80sgHHuCqXsS6
         TFXQ==
X-Gm-Message-State: AOAM532H3P22KrWaCPCu27mRjs28V51YNyKrHAj5kvFIq23zw0EF7cxP
        vOjYlAD/H2porILR14gJLSx0UWDURg+4COUPgohfRwmJQrOhCw==
X-Google-Smtp-Source: ABdhPJx9NSSUybICVuqEWTq7PFGgymOWoKgffW9fXIc5e2mTk0rp20YW7U+2zmaBzMXbxSkf7njCL/TYePsPyEga0YE=
X-Received: by 2002:a25:c801:: with SMTP id y1mr24045ybf.250.1619039834767;
 Wed, 21 Apr 2021 14:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
 <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
 <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com>
 <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
 <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com> <20210421210517.GA6404@xz-x1>
In-Reply-To: <20210421210517.GA6404@xz-x1>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 21 Apr 2021 14:17:03 -0700
Message-ID: <CAJuCfpFfRq8TYs78BvXWriVNm4hf1+o_rX7OUGF=5Hdjcpg30g@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Peter Xu <peterx@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
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

On Wed, Apr 21, 2021 at 2:05 PM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, Suren,
>
> On Wed, Apr 21, 2021 at 01:01:34PM -0700, Suren Baghdasaryan wrote:
> > Peter, you mentioned https://lkml.org/lkml/2020/8/10/439 patch to
> > distinguish real writes vs enforced COW read requests, however I also
> > see that you had a later version of this patch here:
> > https://lore.kernel.org/patchwork/patch/1286506/. Which one should I
> > backport? Or is it not needed in the absence of uffd-wp support in the
> > earlier kernels?
>
> Sorry I have no ability to evaluate the rest... but according to Linus's
> previous reply, my understanding is that it is not needed, not to mention it's
> not upstreamed too.

Thanks! Then I'll send the backports for 17839856fd58 alone and if
more backports are needed I'll post followup patches.
Cheers,
Suren.

>
> Thanks,
>
> --
> Peter Xu
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
