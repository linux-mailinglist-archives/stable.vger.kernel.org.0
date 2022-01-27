Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D35049ED4C
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 22:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiA0VRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 16:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiA0VRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 16:17:05 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4D7C061714;
        Thu, 27 Jan 2022 13:17:04 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p15so8834191ejc.7;
        Thu, 27 Jan 2022 13:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vK3O5xU/kDvpC1TY8wAbZnvb+Z1YDXs3E7FOpCSGFrE=;
        b=e58gnAgOojyV60UkneFpVxVMsLU4Zov6g4GoK0ybOHVmrN9t/jNQcmtnU7ssHc5I+s
         vLxK0zG1wbIW7FadS4WnMA5s3bb0Ucu+Ra7WozizPzxJuNdSc8WY4Vxq0aTBGMioxHWq
         mrMsEtTC56V5TJrFEnzaXtVrVpbLtRY4GO7xn2ygSmlyuA/14102+3guY3/vK/o7man3
         wzBaTMsDJbKdtgWo/OcqEYtzebzEBmk5AK3JCl38JGBhIjJI4u8L00Cew/qVaMjbWDj3
         i4O3InHDsHUeEOLkqX8hxRJWC0cdxKn7I1sb1dDOO2en5NEAmZXwiUyra1prtabpF1wx
         ye+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vK3O5xU/kDvpC1TY8wAbZnvb+Z1YDXs3E7FOpCSGFrE=;
        b=7mcYP4k2IvdaQ2XZgHLJ6Qq1yqM8h8vtRRE6NgEtUiNaT1ygaJz1saaAwx+vGFVwt5
         Iulp4YSgNUbkbmp55EQzjfT4IZqCIknV0vzgm30pvlKQqZVQpKaYjVqMKliofewuc/4M
         +AM2IGHbkoFeMdvI4wsqnXtOovIHEiNhbvo883lriqd+TLa0avJ3u+XOw7myUpAYGQcs
         L5JVPUYaoO/iaXUEihzxCT0zJ7azXFbMjRnM97Y/prgGzSq2SKSF5rlNd361nsRx1to6
         DursVg2NdlQwNg5oWmWgRZDYxI98zfjj1jCzF04qVP9Ni7VJO4bO29pvE5/c0ktiLAl+
         A5pA==
X-Gm-Message-State: AOAM530IiF7fc6CtTcxx0gdj5mjQycVBsS2CbeojVYICVgyHeBg3h/AR
        tDCEyRirbb2Bpk0dT7vxTx+CyIOs2lDhYdf27ic=
X-Google-Smtp-Source: ABdhPJwNpo25p3cIrN5oTAXtkNb4Mi5A68K7YEBZvzb3Dl9MLwx/5LT7nXeEIdTd+aUkUYX7hbk+cIjmisD46+wZ15o=
X-Received: by 2002:a17:906:4fcd:: with SMTP id i13mr4231891ejw.644.1643318223500;
 Thu, 27 Jan 2022 13:17:03 -0800 (PST)
MIME-Version: 1.0
References: <20220120202805.3369-1-shy828301@gmail.com> <af603cbe-4a38-9947-5e6d-9a9328b473fb@redhat.com>
 <CAG48ez1xuZdELb=5ed1i0ruoFu5kAaWsf0LgRXEGhrDAcHz8fw@mail.gmail.com>
 <f7f82234-7599-9e39-1108-f8fbe2c1efc9@redhat.com> <CAG48ez17d3p53tSfuDTNCaANyes8RNNU-2i+eFMqkMwuAbRT4Q@mail.gmail.com>
 <5b4e2c29-8f1a-5a68-d243-a30467cc02d4@redhat.com> <CAHbLzkqLTkVJk+z8wpa03ponf7k30=Sx6qULwsGsvr5cq5d1aw@mail.gmail.com>
 <5a565d5a-0540-4041-ce63-a8fd5d1bb340@redhat.com> <CAHbLzkqXy-W9sD5HFOK_rm_TR8uSP29b+RjKjA5zOZ+0dkqMbQ@mail.gmail.com>
 <2a1c5bd2-cb8c-b93b-68af-de620438d19a@redhat.com>
In-Reply-To: <2a1c5bd2-cb8c-b93b-68af-de620438d19a@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 27 Jan 2022 13:16:51 -0800
Message-ID: <CAHbLzkrQiQyh=36fOtqcODU3RO92jBVxU0o7wU8PyHJ_83LjiQ@mail.gmail.com>
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

It seems a little bit confusing to me, it is not safe to call with PTL
held either, right? I'd like to rephrase the note to:

/*
         * The page_mapcount() is called to get a snapshot of the mapcount.
         * Without holding the page lock this snapshot can be slightly wrong as
         * we cannot always read the mapcount atomically.  Holding PTL doesn't
         * guarantee calling page_mapcount() is safe for all cases either, for
         * example, migration entries.
         */

>
> But this is just my personal preference ... :) I do think the patch does
> the right thing in regard to migration entries.
>
> --
> Thanks,
>
> David / dhildenb
>
