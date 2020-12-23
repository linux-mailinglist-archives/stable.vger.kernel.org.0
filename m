Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D6D2E10B4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 01:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgLWACq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 19:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgLWACq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 19:02:46 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CCEC061793
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:02:05 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id a12so36034826lfl.6
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEZEPrvvOyHEjES0SNYK0E3ccD3hjt+5yzUBPutdjco=;
        b=XzU1oLdvDedHOW+AbIAexhPNODLtb//sgOl8JGShEdZKfQiV03IeRK19CKNwhm1tSD
         3VuLtulBFA2VZCgH/YCk2yh0TP8reIQNg1xGazs2NSnNy9cYZCmo8JHBsKff32EuoxG3
         QAAlrPIFglAKCoTl34p/7RmEHx235cSzHlqY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEZEPrvvOyHEjES0SNYK0E3ccD3hjt+5yzUBPutdjco=;
        b=Se+7ctZN9Uf52N8BUGqx+4bAX2k/pALdAdhaHqyoijaQoBAEo1xlxIoWqmzpT2iTCb
         sgbP7FN/DZBfI6PBN/xbkKCR67B+p+kl+B7OrB5nD2w87fBLEPzfT+7r1BHLGXjL3yOX
         z43OFw8coHNJkzAy8wttzD7agW3xIL3u8eZkjJRYvHRfM1nE+/OQr7bHUddc1kajh3KU
         Gj4Q682Pla6uaBQrXpptwiJMjHAgbOXXx4AEtBuWQhL8HBQAdLuEy/0tSF6nihvlFmtN
         f7OL9UK4k5Dqmxj+vtP6p2BWsqGVWFftARALDNuCwM1WgxArsq9LchrHRCvpRvG/ZmOF
         g9DQ==
X-Gm-Message-State: AOAM533GBKWXAstbMNTPKfE6CoV/Ax2Utealkxl4dc/OKp8cwKQJW8Tj
        EZOQnEej7u2kcptRLev+eUvwW6tHkXlhRw==
X-Google-Smtp-Source: ABdhPJzxwKHp4GGoe2jGwGoXSsRqbS0wnDZshqgoXg8qS13BK2Y8RAUkJ8GoekcEqGlq7nvyYSAbwQ==
X-Received: by 2002:a2e:a594:: with SMTP id m20mr10331469ljp.214.1608681723773;
        Tue, 22 Dec 2020 16:02:03 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id 23sm2883204lft.122.2020.12.22.16.02.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 16:02:02 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id h205so36015287lfd.5
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 16:02:02 -0800 (PST)
X-Received: by 2002:a19:8557:: with SMTP id h84mr9361939lfd.201.1608681721989;
 Tue, 22 Dec 2020 16:02:01 -0800 (PST)
MIME-Version: 1.0
References: <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com> <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com> <X+KDwu1PRQ93E2LK@google.com> <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Dec 2020 16:01:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
Message-ID: <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
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

On Tue, Dec 22, 2020 at 3:50 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> See zap_pte_range() for an example of doing it right, even in the
> presence of complexities (ie that has an example of both flushing the
> TLB, and doing the actual "free the pages after flush", and it does
> the two cases separately).

The more I look at the mprotect code, the less I like it. We seem to
be much better about the TLB flushes in other places (looking at
mremap, for example). The mprotect code seems to be very laissez-faire
about the TLB flushing.

Does adding a TLB flush to before that

        pte_unmap_unlock(pte - 1, ptl);

fix things for you?

That's not the right fix - leaving a stale TLB entry around is fine if
the TLB entry is more strict wrt protections - but it might be worth
testing as a "does it at least close the problem" patch.

          Linus
