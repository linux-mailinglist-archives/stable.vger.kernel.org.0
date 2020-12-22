Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A552E10A8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 00:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLVXvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 18:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgLVXvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 18:51:31 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D8CC0613D6
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 15:50:50 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id y19so35822115lfa.13
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 15:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wT+z8aeZsnOOzxK6hRvN9mbQoYBCIG22xW14cZwa86w=;
        b=MyXM9vqGI+WhI8Rv8h6RJuLl253A3dVDm7Wiw79euFHzsqdzhooZCUkLAygIrH6ipb
         kAS54/dbjFQk681nMzW1KllhvwGrPLMHaiwMbXVIdiWMzE+LAAShC4Wb9zlbpq+nM4kS
         fWHpqNltPGPg5x9GVJGujYfbWfRTyMdNA8src=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wT+z8aeZsnOOzxK6hRvN9mbQoYBCIG22xW14cZwa86w=;
        b=m9IjlSWKMHGosJOFOxg8RaHXs4FTVjuJPGzdsCqRjNLHN0wvYrB51CrPBNw2nKiLiT
         E4MisJCvMAyy4H+Vs+59PxYyhuXqWyEJnEJejl9bxOUhGyG2F28fhU80JIL8zexaTnTC
         QVPUKtXLYTkVHBzpKXbjPNpWy+vRBzHa0250i70OVglEE45VnK+Y7wkj5cEirBznt7+Z
         jDvaUQe7wp6ZNOZU0sTa5iWEY3CEaTqXV34q1TrUAjLoKxVtByFdP/Oz0R1MqWXDmOHJ
         cNxoTU0a4l1AX6PRyFW7xGjOdANPXfJi87ZU6hK2V9tQ2AH6ZFEJZ1k60quDAE6pi9uX
         1eHA==
X-Gm-Message-State: AOAM532luFeWDTv3bygjA0+Zimc8pRfz8uqGgqhhjsG4ao0K4SBiYZLC
        6CPTCHFLC0vCaif9FBKeUuFuTCNmeCg/Sg==
X-Google-Smtp-Source: ABdhPJzN7doMH52mSl73Z6nmwH0x6r7JHSWLjPka0w5zqQPXlunm+DRMu/l85t9kcvaA7QTfMTX3Cg==
X-Received: by 2002:a2e:88d2:: with SMTP id a18mr10165989ljk.42.1608681048585;
        Tue, 22 Dec 2020 15:50:48 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id l11sm2874892lfg.288.2020.12.22.15.50.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 15:50:46 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id o17so36003592lfg.4
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 15:50:46 -0800 (PST)
X-Received: by 2002:a2e:9ad7:: with SMTP id p23mr10303284ljj.465.1608681045870;
 Tue, 22 Dec 2020 15:50:45 -0800 (PST)
MIME-Version: 1.0
References: <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com> <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com> <X+KDwu1PRQ93E2LK@google.com>
In-Reply-To: <X+KDwu1PRQ93E2LK@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Dec 2020 15:50:29 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
Message-ID: <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
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

On Tue, Dec 22, 2020 at 3:39 PM Yu Zhao <yuzhao@google.com> wrote:
>
> 2) is the false positive because of what we do, and it's causing the
> memory corruption because do_wp_page() tries to make copies of pages
> that seem to be RO but may have stale RW tlb entries pending flush.

Yeah, that's definitely a different bug.

The rule is that the TLB flush has to be done before the page table
lock is released.

See zap_pte_range() for an example of doing it right, even in the
presence of complexities (ie that has an example of both flushing the
TLB, and doing the actual "free the pages after flush", and it does
the two cases separately).

           Linus
