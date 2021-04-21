Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49690367575
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 01:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbhDUXCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 19:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDUXCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 19:02:35 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC0DC06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 16:02:01 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 130so5316150ybd.10
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 16:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aoJo1QotiA58rE0SFr32dy7Ybplj8AJq2l6VJ7dQkEQ=;
        b=QHehOCMjmNqOFXdNBHkvdxCY4NwD0Lx3eOoa85xgiJTHGZddr0M8yfA9CH3CnKMq4N
         zg/qPwsWiIRBK8WAn5qwoKo5kXyuRcBYvI4V5rX7mTPb9tqSSYktmu9AuBLJFCJ9ZEbC
         6GPU09FCfcvAIJeh32pywKrWM/WedhiTxZMnA53Fkx9bArWw2Z8LNtJ36fg8kU+0EFLm
         pN8IA+pNoBFOJyzrlL1/f7MENhxAzW4jxdma5/ldNJ59013RmbRC/f+xZE2SLS3rM0LE
         312EC1+Q+GvX9E5/S6W1azTFovdrWOtg66SqyYYtsMWCf7i2OELu3zbFoRgkZAKWdCS+
         HIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aoJo1QotiA58rE0SFr32dy7Ybplj8AJq2l6VJ7dQkEQ=;
        b=V2ac915CK9XUqhI1i+fr/6gaLtiPgaKiP83Eiirt3zjgwlIhi72/u+vxu/RxfqqDu0
         L3jnskV6YNRGp7fnMNXM1uNrVjSWx4hIReEL3u3EP4b85SK9WXYMNvvx4F9egz8IABkj
         bP6ZqPRiFD9nnv/KfEohCutpQUrDMi17d8BLndv9mR3gxJJq90VgX/qVYSLFAIBtrlBr
         6xpTA/losSLMAxv7eHLCXlDe8VCYyDM3UBi6q1yRmRqZ+w9FtcX19V294dNaV6DPIXz2
         Fe5qE6OJSvIXqIXfy7DgvxjlVXgJCUyoxNDiK/3YZya6/ZPASRmV5T8yYDxquW0Hut+F
         siAw==
X-Gm-Message-State: AOAM531pBatiu+kS9W53wOSvbmTrya8y9PeTPP8I416Izq2scvLzBZVc
        Bxg/jgmb+guBQA5ir3Hkf0T26E0/oxMkoamvOmSECw==
X-Google-Smtp-Source: ABdhPJzh9vlYwPkMEKULJjYTcBpMiSl1hOKnJL1fZfY4HVew/pwAufmrAtY5C3gIjYxDqhImuTzFk1dOWHImUGrfqFE=
X-Received: by 2002:a25:c801:: with SMTP id y1mr582786ybf.250.1619046119937;
 Wed, 21 Apr 2021 16:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
 <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
 <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com>
 <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
 <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com>
 <20210421210517.GA6404@xz-x1> <CAJuCfpFfRq8TYs78BvXWriVNm4hf1+o_rX7OUGF=5Hdjcpg30g@mail.gmail.com>
In-Reply-To: <CAJuCfpFfRq8TYs78BvXWriVNm4hf1+o_rX7OUGF=5Hdjcpg30g@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 21 Apr 2021 16:01:48 -0700
Message-ID: <CAJuCfpGa4esN0ovL1=h3h2pyt2D1YzYF4Q9Ew6Q8q08mkdn8vA@mail.gmail.com>
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

On Wed, Apr 21, 2021 at 2:17 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Wed, Apr 21, 2021 at 2:05 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > Hi, Suren,
> >
> > On Wed, Apr 21, 2021 at 01:01:34PM -0700, Suren Baghdasaryan wrote:
> > > Peter, you mentioned https://lkml.org/lkml/2020/8/10/439 patch to
> > > distinguish real writes vs enforced COW read requests, however I also
> > > see that you had a later version of this patch here:
> > > https://lore.kernel.org/patchwork/patch/1286506/. Which one should I
> > > backport? Or is it not needed in the absence of uffd-wp support in the
> > > earlier kernels?
> >
> > Sorry I have no ability to evaluate the rest... but according to Linus's
> > previous reply, my understanding is that it is not needed, not to mention it's
> > not upstreamed too.
>
> Thanks! Then I'll send the backports for 17839856fd58 alone and if
> more backports are needed I'll post followup patches.

Posted 4.19 backport: https://lore.kernel.org/patchwork/patch/1416747
and 4.14 backport: https://lore.kernel.org/patchwork/patch/1416748.
They are identical but Greg asked me to submit separate patches due to
an additional minor merge conflict in 4.14.

> Cheers,
> Suren.
>
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >
> > --
> > To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> >
