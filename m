Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF833572DB
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 19:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354684AbhDGRNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 13:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbhDGRNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 13:13:00 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C535C06175F
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 10:12:50 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d12so29707284lfv.11
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 10:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+88jxDCU+SNdWXTN3z3TZI8sQwpTFP6rVmjQ1IvMUp0=;
        b=NEqJedWWmmdhqwXjNwjktue2V23wNTRtBfoImIIAzQVurOySj5Javl6oNqSxLuGk/6
         H5db28mPuPm8ZICBA974Hz2HSIUZgFYCpQjj7wNrm2YortKw0r9rkQz6xqx2G3ohOwJL
         KBqlJrRjasxTbcKYfFCNzd5whuFSFbHBux824=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+88jxDCU+SNdWXTN3z3TZI8sQwpTFP6rVmjQ1IvMUp0=;
        b=r0+dq9hD2fl3lpM6ewuXII6iYp9/v7xOe81P0kUB8HuOxAkJ1620HoUVI2CLoDyL0x
         ki253A/BkzgpGpzxqjKUWcjNpOXfNr49SMgQO6X5yE9LAQEcRJJXAzkgtnmKvgR1RN5k
         hC/a16oHFRKmjiqqVsJWPMEJVOhXfVwjqwpyUfOxwdMQPkrIHN+K8rJ0NUsfosRjfVL7
         AogGPmZZ4ZXrl5/VNbF0kcYAQPB2vnIXi7sTD3oYdQiwYmygN+7wIXR071nBshntvqOq
         sQjJJbZsMchGKdPcs7Kh9gha45uxbEyIk5uZstuQJAEDFD51+x07V+p4lyE6sr3cI69z
         8iLQ==
X-Gm-Message-State: AOAM532uxKzwe7cH4mR1tfQfJGxwdTuF9ncqT0wRIINVYrkijmP6/mYh
        IvftKbAE74FpnnEm42vWzKuYzL5tZSs75vo+
X-Google-Smtp-Source: ABdhPJwHNTHCKIf8BdzwTNd87pcny9/V7IWj5FP5rjYdP/EebYYrPoELKXWBlz31FHniITdgPAZ9Hw==
X-Received: by 2002:a05:6512:218d:: with SMTP id b13mr1095081lft.228.1617815568660;
        Wed, 07 Apr 2021 10:12:48 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id t198sm652690lff.121.2021.04.07.10.12.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 10:12:48 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id y1so21576187ljm.10
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 10:12:48 -0700 (PDT)
X-Received: by 2002:a2e:9acf:: with SMTP id p15mr2701576ljj.61.1617815105311;
 Wed, 07 Apr 2021 10:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
In-Reply-To: <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Apr 2021 10:04:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
Message-ID: <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Suren Baghdasaryan <surenb@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Peter Xu <peterx@redhat.com>,
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

On Wed, Apr 7, 2021 at 9:33 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> Trying my hand at backporting the patchsets Peter mentioned proved
> this to be far from easy with many dependencies. Let me look into
> Vlastimil's suggestion to backport only 17839856fd58 and it sounds
> like 5.4 already followed that path.

Well, in many ways 17839856fd58 was the "simple and obvious" fix, and
I do think it's easily backportable.

But it *did* cause problems too. Those problems may not be issues on
those old kernels, though.

In particular, commit 17839856fd58 caused uffd-wp to stop working
right, and it caused some issues with debugging (I forget the exact
details, but I think it was strace accessing PROT_NONE or write-only
pages or something like that, and COW failed).

But yes, in many ways that commit is a much simpler and more
straightforward one (which is why I tried it once - we ended up with
the much more subtle and far-reaching fixes after the UFFD issues
crept up).

The issues that 17839856fd58 caused may be entire non-events in old
kernels. In fact, the uffd writeprotect API was added fairly recently
(see commit 63b2d4174c4a that made it into v5.7), so the uffd-wp issue
that was triggered probably cannot happen in the old kernels.

The strace issue might not be relevant either, but I forget what the
details were. Mikilas should know.

See

  https://lore.kernel.org/lkml/alpine.LRH.2.02.2009031328040.6929@file01.intranet.prod.int.rdu2.redhat.com/

for Mikulas report. I never looked into it in detail, because by then
the uffd-wp issue had already come up, so it was juat another nail in
the coffin for that simpler approach.

Mikulas, do you remember?

            Linus
