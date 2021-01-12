Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670B22F3391
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 16:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbhALPHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 10:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhALPHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 10:07:13 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BF6C061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 07:06:32 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s15so1529778plr.9
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 07:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lO4Anqp0yO5boP1OoXosqJ6kbnGa8KHmQ/06aGjVmlM=;
        b=qMvcGQxOGkrAwkonqvVmwpr3suy6jYXi3szVuW3o/UYvBAJv/yL1w2HzCmyZz5JxF5
         FqnQOyiFVr//0VKwQ+0A7jOv9Ts8G/Y6yPCivxr3byMV8kZmt0ORit0Okq76LfViINp3
         aYDpvaO09YxGIk7uymD9R+M+IpgyYykXYlCPqxq6MVqODvZrBtBTS3ai7Ot/zKjTOzuO
         RGT12fsxanbun9E+Qt8fwo9ksObLc3s1Ptq7LfmEoO9Ku+oIv3M2C9PSVhQXG39x5XA+
         sOrXsRtvmBy3Q6Iz//gSBSgtV9k7kYjPZTcda1HGngDFG4bJtxX9/wqI8SOyiz4ZIaIH
         2WSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lO4Anqp0yO5boP1OoXosqJ6kbnGa8KHmQ/06aGjVmlM=;
        b=g+33EL3ve67/fmbR9b9p2s9Q7LtjPusyEjQn3a4DzpS5MbRSwY/kA0BsEsVvZbauha
         tT1Ys7kodj/YzsBmeOZwctT2fp9+dVcfDxx3mxl8uEOGF6LjLeqd9u9e8ddy1auAklBP
         LPav15H0Izzay6q7zlr2KrpLngjlZBwbdFRGG6Dyeye7gLb8LflXoYM5sO2iKjOTVTn2
         walJr1RbQus8mQFVvoy2PJZNNPJc95cTCIeq3pb9WK50NSsoQGEmw7NO1BWjV/f/zZin
         cL2RXeBtj8tAvHRh1bTM6L/QaKnzPop2g0Ya8pyLSlP1hNo3rjifw65j4GSvYIThhWVH
         sGMA==
X-Gm-Message-State: AOAM530r40uujDsgV9Ljq5nTtWQO3X32faLBoShkyqKHpZHCPxPXy96Q
        cGvwQzTw2RMQvwQZUcscPDt8dGG8TdVOYEcuNW7SG8vAc8uFL5SVK8E=
X-Google-Smtp-Source: ABdhPJzOWoiSLHOSdhVWD1LgGI5laVjW58Nny6nHyBuLLSjOnoMW3JkaIUSXdHu5HjHDqQTBWv+gUItBeOl7iL7t3/E=
X-Received: by 2002:a17:90a:c588:: with SMTP id l8mr5083968pjt.147.1610463991728;
 Tue, 12 Jan 2021 07:06:31 -0800 (PST)
MIME-Version: 1.0
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-4-songmuchun@bytedance.com> <20210112100213.GK22493@dhcp22.suse.cz>
 <CAMZfGtVJVsuL39owkT+Sp8A7ywXJLhbiQ6zYgL9FKhqSeAvy=w@mail.gmail.com>
 <20210112111712.GN22493@dhcp22.suse.cz> <CAMZfGtWt5+03Pne9QjLn53kqUbZWSmi0f-iEOisHO6LjohdXFA@mail.gmail.com>
 <20210112123738.GQ22493@dhcp22.suse.cz>
In-Reply-To: <20210112123738.GQ22493@dhcp22.suse.cz>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 12 Jan 2021 23:05:50 +0800
Message-ID: <CAMZfGtU1Eh91mcMMz=Z7S_3boreu9r=Xzw0=reRZ=FEdyJ_MXQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3 3/6] mm: hugetlb: fix a race between
 freeing and dissolving the page
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 8:37 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Tue 12-01-21 19:43:21, Muchun Song wrote:
> > On Tue, Jan 12, 2021 at 7:17 PM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Tue 12-01-21 18:13:02, Muchun Song wrote:
> > > > On Tue, Jan 12, 2021 at 6:02 PM Michal Hocko <mhocko@suse.com> wrote:
> > > > >
> > > > > On Sun 10-01-21 20:40:14, Muchun Song wrote:
> > > > > [...]
> > > > > > @@ -1770,6 +1788,14 @@ int dissolve_free_huge_page(struct page *page)
> > > > > >               int nid = page_to_nid(head);
> > > > > >               if (h->free_huge_pages - h->resv_huge_pages == 0)
> > > > > >                       goto out;
> > > > > > +
> > > > > > +             /*
> > > > > > +              * We should make sure that the page is already on the free list
> > > > > > +              * when it is dissolved.
> > > > > > +              */
> > > > > > +             if (unlikely(!PageHugeFreed(head)))
> > > > > > +                     goto out;
> > > > > > +
> > > > >
> > > > > Do you really want to report EBUSY in this case? This doesn't make much
> > > > > sense to me TBH. I believe you want to return 0 same as when you race
> > > > > and the page is no longer PageHuge.
> > > >
> > > > Return 0 is wrong. Because the page is not freed to the buddy allocator.
> > > > IIUC, dissolve_free_huge_page returns 0 when the page is already freed
> > > > to the buddy allocator. Right?
> > >
> > > 0 is return when the page is either dissolved or it doesn't need
> > > dissolving. If there is a race with somebody else freeing the page then
> > > there is nothing to dissolve. Under which condition it makes sense to
> > > report the failure and/or retry dissolving?
> >
> > If there is a race with somebody else freeing the page, the page
> > can be freed to the hugepage pool not the buddy allocator. Do
> > you think that this page is dissolved?
>
> OK, I see what you mean. Effectively the page would be in a limbo, not
> yet in the pool nor in the allocator but it can find its way to the
> either of the two. But I still dislike returning a failure because that
> would mean e.g. memory hotplug to fail. Can you simply retry inside this
> code path (drop the lock, cond_resched and retry)?

Yeah. This is what I want to do (making the memory hotplug as
successful as possible). So I send the patch:

  [PATCH v3 4/6] mm: hugetlb: add return -EAGAIN for dissolve_free_huge_page

Adding a simple retry inside this function when hitting this race is
also fine to me. I can do that.




> --
> Michal Hocko
> SUSE Labs
