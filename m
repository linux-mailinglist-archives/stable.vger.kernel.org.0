Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2998C2E22D4
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 00:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLWXk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 18:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgLWXk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 18:40:59 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80684C061794
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 15:40:12 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id s26so1135632lfc.8
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 15:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZJKV+DKmW9cukKBH1Gw4pXmY6HG23GwwQEMYiVw4sdI=;
        b=Q7GCA8ElDazk7r78Qa460iWOF7WAdDbE+wL5TTYsge2luCiMZOkmXR8dsc3u3H5opr
         taTbuaRgfi4x7GKjIMQ8nsKLMLcALaZ6srNL/WZYy/zn5PN/wdGzdlTr5l8Wc/1+kKGk
         yYn91v5QqoxP7Vz9O6m2pOiBKSU7Bmss5l5Ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZJKV+DKmW9cukKBH1Gw4pXmY6HG23GwwQEMYiVw4sdI=;
        b=r3MfekpAni0sGXhe/1OMXInl9Qt/gujQZ5bHBH83xzshL2SWFlXOcbHbBfdLtQOK3o
         sZ/r6k6r1QqtqDXPlziBP08tW/DUWmFcW40oA9R5M/01vIHxIda8EpMRtjY0mT9KZGGQ
         VegwGPN3+kXNjzSwRvxqz6h+6GqVfeIrLSQGcjEGHznYZCLaeOc97NRn76hQymqDgr7z
         Ryrh+7KXaAiRYvCz0tMuU6DWYrarVH2AiomSkH+u30rYsruNzAOCpmpNZBt383hRL7G1
         +Y8sFUoP2bxKakaPIb349tfefVn/U990aq+FTTf6CLBJo6ZMRz/3EaN2b4uOgYMM53la
         0ULQ==
X-Gm-Message-State: AOAM533ox3NHMNmH+CvqQH5D3IwEiv033+2XvGqOBMH8BlnVnTR8vxMP
        1vy/ABdg4s/MFDMz2RfFCzo4Nokg4wcomg==
X-Google-Smtp-Source: ABdhPJx/onRGShk3IYluO7X2ueXdBqmPlMyovXXrr/t9j0lXXxHIcrVEEB/bWer1nBZjR/hRCg2wHA==
X-Received: by 2002:a19:4856:: with SMTP id v83mr11385151lfa.583.1608766810962;
        Wed, 23 Dec 2020 15:40:10 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id l28sm3715636ljb.42.2020.12.23.15.40.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 15:40:10 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id 23so1110434lfg.10
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 15:40:10 -0800 (PST)
X-Received: by 2002:a2e:3211:: with SMTP id y17mr12310117ljy.61.1608766809995;
 Wed, 23 Dec 2020 15:40:09 -0800 (PST)
MIME-Version: 1.0
References: <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com> <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com> <X+KDwu1PRQ93E2LK@google.com>
 <X+Kxy3oBMSLz8Eaq@redhat.com> <X+K7JMrTEC9SpVIB@google.com> <X+O49HrcK1fBDk0Q@redhat.com>
In-Reply-To: <X+O49HrcK1fBDk0Q@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Dec 2020 15:39:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=whPCKbhw7+XGBgJ0bM-5QShV90T_yqy2DWp-uPPReTOrw@mail.gmail.com>
Message-ID: <CAHk-=whPCKbhw7+XGBgJ0bM-5QShV90T_yqy2DWp-uPPReTOrw@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 1:39 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> On Tue, Dec 22, 2020 at 08:36:04PM -0700, Yu Zhao wrote:
> > Thanks for the details.
>
> I hope we can find a way put the page_mapcount back where there's a
> page_count right now.

I really don't think that's ever going to happen - at least if you're
talking about do_wp_page().

I refuse to make the *simple* core operations VM have to jump through
hoops, and the old COW mapcount logic was that. I *much* prefer the
newer COW code, because the rules are more straightforward.

> page_count is far from optimal, but it is a feature it finally allowed
> us to notice that various code (clear_refs_write included apparently
> even after the fix) leaves stale too permissive TLB entries when it
> shouldn't.

I absolutely agree that page_count isn't exactly optimal, but
"mapcount" is just so much worse.

page_count() is at least _logical_, and has a very clear meaning:
"this page has other users". mapcount() means something else, and is
simply not sufficient or relevant wrt COW.

That doesn't mean that page_mapcount() is wrong - it's just that it's
wrong for COW. page_mapcount() is great for rmap, so that we can see
when we need to shoot down a memory mapping of a page that gets
released (truncate being the classic example).

I think that the mapcount games we used to have were horrible. I
absolutely much prefer where we are now wrt COW.

The modern rules for COW handling are:

 - if we got a COW fault there might be another user, we copy (and
this is where the page count makes so much logical sense).

 - if somebody needs to pin the page in the VM, we either make sure
that it is pre-COWed and we

   (a) either never turn it back into a COW page (ie the fork()-time
stuff we have for pinned pages)

   (b) or there is some explicit marker on the page or in the page
table (ie the userfaultfd_pte_wp thing).

those are _so_ much more straightforward than the very complex rules
we used to have that were actively buggy, in addition to requiring the
page lock. So they were buggy and slow.

And yes, I had forgotten about that userfaultfd_pte_wp() because I was
being myopic and only looking at wp_page_copy(). So using that as a
way to make sure that a page doesn't go through COW is a good way to
avoid the COW race, but I think that thing requires a bit in the page
table which might be a problem on some architectures?

          Linus
