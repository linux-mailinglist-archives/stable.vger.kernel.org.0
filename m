Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2CD49FE72
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 17:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350330AbiA1QxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 11:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350319AbiA1QxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 11:53:19 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C27C061714;
        Fri, 28 Jan 2022 08:53:19 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id d10so17895482eje.10;
        Fri, 28 Jan 2022 08:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BLJFT4AhBocD6kHHT+suS0eJkn3pPtgeNyCXLqLIpak=;
        b=eXWnQezlzjgM85qsZszg2oBXIDeFvSRt24xoZNoEeaT02DL98kW6vYQmfrS77uf+ck
         73j/FMVrXvBV0t9/NOXyQild2tI4WGX8LDLVemr0lyO49SRXaerhke2s3D69BJNjvCE6
         EkeqgY43aO97+R6xHwHtbrc9e11d3/+UMkt6snjEgmt0taXrCSuA2GuPd4pHy1hNB7I+
         JTGxPnrpmZS0GWmVAx+zeXJM22AXimC3Ot09+82+1KRP1Boz6rvwfZKcSeUJ3JefUBHG
         ODRGdKMPEWfT57hTNdkNbbhNDpIZ4q6j3j//lxvpy07jrisIO7uQj0TNdx6y12/EJM16
         S38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BLJFT4AhBocD6kHHT+suS0eJkn3pPtgeNyCXLqLIpak=;
        b=X8x8o6T+8UhkbXC5dW4xqqpLRkzPr0pYvoi2/CmWnuPUnMInFvmSm1wU/z2gkcr1SG
         4BE7+DIxeJs1U2CDuAHKqZl/Ax5cAae4lDCJIY07I4zMPptlhYz/SGa8vEre5ZvkcIAX
         xNhOCpRKyYHK3GWjp0EwT5GVseJ+5Vb3G/I91sD2hPWglNEmlRQknMp0WpX7xSEfI9NV
         n20Ov1y+vzNciDevtnk34lEoUQzNor4u8Sx3IyguNXdmSGjxuKiEcTSW5EpHHlFcnHyV
         OkhxnUns26X51gariCBBDlK98rMLC0RAM3iqachxXjpuFWuYXcFglIRYBzWqApz6NLrD
         4Ueg==
X-Gm-Message-State: AOAM5311qG/pzKWZURnCGfyzaxqwWQlHI86QCC8/rElsxcf7mNImnFH8
        rnnZ7LVVyeP0Osr+UjFTxMOp5EOJETiH5Lt/8p8=
X-Google-Smtp-Source: ABdhPJyQPlCRIBkgo1TAzlQctDBPEi8rIwNs5vVeYsSwaXGWzQ4dqp3N/HFI29N2DS1PrkdvwWQNnykEMmK1wRcsKK4=
X-Received: by 2002:a17:907:3d94:: with SMTP id he20mr7753163ejc.637.1643388797473;
 Fri, 28 Jan 2022 08:53:17 -0800 (PST)
MIME-Version: 1.0
References: <20220120202805.3369-1-shy828301@gmail.com> <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
 <f7f82234-7599-9e39-1108-f8fbe2c1efc9@redhat.com> <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
 <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com> <CAHbLzkqLTkVJk+z8wpa03ponf7k30=Sx6qULwsGsvr5cq5d1aw@mail.gmail.com>
 <5a565d5a-0540-4041-ce63-a8fd5d1bb340@redhat.com> <CAHbLzkqXy-W9sD5HFOK_rm_TR8uSP29b+RjKjA5zOZ+0dkqMbQ@mail.gmail.com>
 <2a1c5bd2-cb8c-b93b-68af-de620438d19a@redhat.com> <CAHbLzkrQiQyh=36fOtqcODU3RO92jBVxU0o7wU8PyHJ_83LjiQ@mail.gmail.com>
 <8c0430e5-fecb-3eda-3d40-e94caa8cbd78@redhat.com>
In-Reply-To: <8c0430e5-fecb-3eda-3d40-e94caa8cbd78@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Fri, 28 Jan 2022 08:53:05 -0800
Message-ID: <CAHbLzkpyShTYkSfUMsBPohm0eGvBhvmDmRNKUUWJk3wqh+nrkQ@mail.gmail.com>
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

On Fri, Jan 28, 2022 at 12:02 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 27.01.22 22:16, Yang Shi wrote:
> > On Wed, Jan 26, 2022 at 10:54 AM David Hildenbrand <david@redhat.com> wrote:
> >>
> >>>>> Just page lock or elevated page refcount could serialize against THP
> >>>>> split AFAIK.
> >>>>>
> >>>>>>
> >>>>>> But yeah, using the mapcount of a page that is not even mapped
> >>>>>> (migration entry) is clearly wrong.
> >>>>>>
> >>>>>> To summarize: reading the mapcount on an unlocked page will easily
> >>>>>> return a wrong result and the result should not be relied upon. reading
> >>>>>> the mapcount of a migration entry is dangerous and certainly wrong.
> >>>>>
> >>>>> Depends on your usecase. Some just want to get a snapshot, just like
> >>>>> smaps, they don't care.
> >>>>
> >>>> Right, but as discussed, even the snapshot might be slightly wrong. That
> >>>> might be just fine for smaps (and I would have enjoyed a comment in the
> >>>> code stating that :) ).
> >>>
> >>> I think that is documented already, see Documentation/filesystems/proc.rst:
> >>>
> >>> Note: reading /proc/PID/maps or /proc/PID/smaps is inherently racy (consistent
> >>> output can be achieved only in the single read call).
> >>
> >> Right, but I think there is a difference between
> >>
> >> * Atomic values that change immediately afterwards ("this value used to
> >>   be true at one point in time")
> >> * Values that are unstable because we cannot read them atomically ("this
> >>   value never used to be true")
> >>
> >> I'd assume with the documented race we actually talk about the first
> >> point, but I might be just wrong.
> >>
> >>>
> >>> Of course, if the extra note is preferred in the code, I could try to
> >>> add some in a separate patch.
> >>
> >> When staring at the (original) code I would have hoped to find something
> >> like:
> >>
> >> /*
> >>  * We use page_mapcount() to get a snapshot of the mapcount. Without
> >>  * holding the page lock this snapshot can be slightly wrong as we
> >>  * cannot always read the mapcount atomically. As long we hold the PT
> >>  * lock, the page cannot get unmapped and it's at safe to call
> >>  * page_mapcount().
> >>  */
> >>
> >> With the addition of
> >>
> >> "... For unmapped pages (e.g., migration entries) we cannot guarantee
> >> that, so treat the mapcount as being 1."
> >
> > It seems a little bit confusing to me, it is not safe to call with PTL
> > held either, right? I'd like to rephrase the note to:
>
> The implication that could have been spelled out is that only a mapped
> page can get unmapped. (I know, there are some weird migration entries
> nowadays ...)

Yes, I see your point. Just felt "only a mapped page can get unmapped"
sounds not that straightforward (just my personal feeling). How's
about "It is not safe to call page_mapcount() even with PTL held if
the page is not mapped, especially for migration entries".

>
> /*
>  * We use page_mapcount() to get a snapshot of the mapcount. Without
>  * holding the page lock this snapshot can be slightly wrong as we
>  * cannot always read the mapcount atomically. As long we hold the PT
>  * lock, a mapped page cannot get unmapped and it's at safe to call
>  * page_mapcount(). Especially for migration entries, it's not safe to
>  * call page_mapcount(), so we treat the mapcount as being 1.
>  */
>
>
>
> --
> Thanks,
>
> David / dhildenb
>
