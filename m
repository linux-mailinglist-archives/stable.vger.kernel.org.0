Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1CD49EB3A
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 20:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245660AbiA0TnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 14:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245651AbiA0TnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 14:43:01 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B3BC061714;
        Thu, 27 Jan 2022 11:43:01 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id l5so5110444edv.3;
        Thu, 27 Jan 2022 11:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jp8xtQ7vm1lf3v4x4zlRNvwWieVtrtzxWdkBdSMdKBI=;
        b=RxZDvbu1Kusj7WLtXTZhCblHNO01QnNYl4Im+SUvXMrgEaEYyz6Nw85K2+EVtCzVF9
         O2E7npoGniIeW4LxnTlHGfJdxRRHRp+QkF8j+7eCkNNAMrb4hViFKypKDuM1erRfvGLi
         BCnSr5autHPdiepr8yLXu2w9MD+M2L2FS1nwoCdUoRtJ0CgYaxsr6YYD1VWIdSDnNBeU
         5krpS5EKJ/8+5fA3J073NF2u30cxDuAHszheIO8CdGUusgXIJqiDoV7fJG41KKJLGqt3
         OssmxhyWkGzxoWFgFvJ87Mn8Hxdfdd5te4/GYRXO7ZTGbBQBdCpGSxI42Ma43PcRmG5l
         9swQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jp8xtQ7vm1lf3v4x4zlRNvwWieVtrtzxWdkBdSMdKBI=;
        b=l3mOqQb4uO4GpEMbbpLmKQZJrtSap2ma6faBx799FqCZ2FlLNGTuUt2EitqW3TAiBx
         1M+wBCv17WrKH6XqJeW7JROtKx3XaBsjfN8GeYfiPZ6HBnu4mU7tToA9fOZQAKLNwJc2
         GTZ+EjGDBsgm8zo16wNTlSrI+CpktZNJ9V1CmqMekGRBKAS8GIV3Z8H/PHERpm3m32pR
         EuKvcp4Ro9/XopZljRnL5JuK/hWJ5vR5a1VpiSCX99VINmZeEznexfpPYp3cdX2C0OBD
         wdPfLv09qYdtLyDhF+c9bpua+ChPCv6QNYrF9aQM924sXQ7vnXI6WDGiFc31Yff1EfUx
         aiHA==
X-Gm-Message-State: AOAM533sbn6B92/MI5Z+vyOEKvE68+xKXWnyR04ZC6IG/PLwqU3Z15ni
        LcImnqSx90tJX8hXrwOmv5qlb8Qm+fvDNQoNwB0=
X-Google-Smtp-Source: ABdhPJxRDp56G1DTNc/iJVvUZZ1aic+K9B+k2A/2xw940jMK1KAsxC1cJr6gG791OdmD84afDgTNcTg+7RNRu0+3wLI=
X-Received: by 2002:a05:6402:12cf:: with SMTP id k15mr4971960edx.299.1643312579791;
 Thu, 27 Jan 2022 11:42:59 -0800 (PST)
MIME-Version: 1.0
References: <20220120202805.3369-1-shy828301@gmail.com> <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
 <f7f82234-7599-9e39-1108-f8fbe2c1efc9@redhat.com> <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
 <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com> <CAHbLzkqLTkVJk+z8wpa03ponf7k30=Sx6qULwsGsvr5cq5d1aw@mail.gmail.com>
 <5a565d5a-0540-4041-ce63-a8fd5d1bb340@redhat.com> <CAHbLzkqXy-W9sD5HFOK_rm_TR8uSP29b+RjKjA5zOZ+0dkqMbQ@mail.gmail.com>
 <2a1c5bd2-cb8c-b93b-68af-de620438d19a@redhat.com>
In-Reply-To: <2a1c5bd2-cb8c-b93b-68af-de620438d19a@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 27 Jan 2022 11:42:47 -0800
Message-ID: <CAHbLzkongysm41LbMc1FMT8Xeg33==1rn3nUu6MTAAwKSbfv_Q@mail.gmail.com>
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

On Wed, Jan 26, 2022 at 10:54 AM David Hildenbrand <david@redhat.com> wrote:
>
> >>> Just page lock or elevated page refcount could serialize against THP
> >>> split AFAIK.
> >>>
> >>>>
> >>>> But yeah, using the mapcount of a page that is not even mapped
> >>>> (migration entry) is clearly wrong.
> >>>>
> >>>> To summarize: reading the mapcount on an unlocked page will easily
> >>>> return a wrong result and the result should not be relied upon. reading
> >>>> the mapcount of a migration entry is dangerous and certainly wrong.
> >>>
> >>> Depends on your usecase. Some just want to get a snapshot, just like
> >>> smaps, they don't care.
> >>
> >> Right, but as discussed, even the snapshot might be slightly wrong. That
> >> might be just fine for smaps (and I would have enjoyed a comment in the
> >> code stating that :) ).
> >
> > I think that is documented already, see Documentation/filesystems/proc.rst:
> >
> > Note: reading /proc/PID/maps or /proc/PID/smaps is inherently racy (consistent
> > output can be achieved only in the single read call).
>
> Right, but I think there is a difference between
>
> * Atomic values that change immediately afterwards ("this value used to
>   be true at one point in time")
> * Values that are unstable because we cannot read them atomically ("this
>   value never used to be true")
>
> I'd assume with the documented race we actually talk about the first
> point, but I might be just wrong.

I think so too.

>
> >
> > Of course, if the extra note is preferred in the code, I could try to
> > add some in a separate patch.
>
> When staring at the (original) code I would have hoped to find something
> like:
>
> /*
>  * We use page_mapcount() to get a snapshot of the mapcount. Without
>  * holding the page lock this snapshot can be slightly wrong as we
>  * cannot always read the mapcount atomically. As long we hold the PT
>  * lock, the page cannot get unmapped and it's at safe to call
>  * page_mapcount().
>  */
>
> With the addition of
>
> "... For unmapped pages (e.g., migration entries) we cannot guarantee
> that, so treat the mapcount as being 1."
>
> But this is just my personal preference ... :) I do think the patch does
> the right thing in regard to migration entries.

I will prepare a patch.

>
> --
> Thanks,
>
> David / dhildenb
>
