Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DF223F67B
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 06:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbgHHElb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 00:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgHHElb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 00:41:31 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A7CC061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 21:41:30 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f24so4112049ejx.6
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 21:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4c2A3vRrijfjepyTUsYsz/g1xu4ckn8h3voqWBmATys=;
        b=dRVV0FqgTCJe9pp6Q6oXl7nMcd3bjCnGyOPITp5wKM0EJWmMJjovnFBJCHWkOLcV+w
         XVgeM/6dMv69ZS7jN9DSRGlr2pIwEAY6oHMyJjZhsMJkq9xDvdD+i6Fxt4IFfInOXZKx
         bcyOlkVn/YzPjQiARHhAdkHvtWIVdCQceorew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4c2A3vRrijfjepyTUsYsz/g1xu4ckn8h3voqWBmATys=;
        b=REaZAgsmxRqSKWz6CuXOjbKN9cywNRc1kOoOwSjtGuvEjFg/6Pa2MhlXQViE2Y63Pn
         aShLQCHT0bly7IuF/HpbDjUWEF+d9cPM+RwBE7+vuoip2FGCXqk5wbJLXmk28c5nDl39
         Y+upWc9i1jWeppO0giHj+LeuLAarHrqJJET+Wtg8FNsG0CXJlBQ2Nw8HQNcUH5n35LES
         oeKSg6wm6X/UC8w7lcdZ2IsQUm2CIonOEGV+b6VM426FX26Ri4E6vtXsypBqlz384tuF
         ENQfgmT43bgLnKj1hmzNM4irMtI/qIxyA0cgmX6AefIooHps691mMbDJ8Jpbun/T/FwA
         UtyQ==
X-Gm-Message-State: AOAM533Xz+NbCCSFGwBL/LJKW+nDvHUT+bIhzZ9mH0y+to2zLmuK5rZ+
        ZJKbI8dGLKeGQFbA+eWtBqCgtzw2BJkPwQ==
X-Google-Smtp-Source: ABdhPJxrziBOlyDq3vgWDyh9I/isapnf0ZhdYkcHSwjaEGxhoS8grxxN/zAXzLSGTv0Q3Z3+g7pAeQ==
X-Received: by 2002:a17:906:a3d5:: with SMTP id ca21mr12286080ejb.453.1596861688949;
        Fri, 07 Aug 2020 21:41:28 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id v22sm6611641edq.35.2020.08.07.21.41.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 21:41:28 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id c15so3359293wrs.11
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 21:41:28 -0700 (PDT)
X-Received: by 2002:a2e:2e04:: with SMTP id u4mr7220109lju.102.1596861246750;
 Fri, 07 Aug 2020 21:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
 <20200807061706.unk5_0KtC%akpm@linux-foundation.org> <CAHk-=wiK1oh8T_GNdnQk4UERuWmLQMnXuia8CpJ5QVzSAKuffQ@mail.gmail.com>
 <CAHbLzkrSQ8CT5jaT-8LFtnEg-63qdZNoHe6XBc3F4orxuHt-7A@mail.gmail.com>
In-Reply-To: <CAHbLzkrSQ8CT5jaT-8LFtnEg-63qdZNoHe6XBc3F4orxuHt-7A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 21:33:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjoOtcAvkYQThDQ5u+jFqbtwOsSJH1DtLDfokMOd4K93w@mail.gmail.com>
Message-ID: <CAHk-=wjoOtcAvkYQThDQ5u+jFqbtwOsSJH1DtLDfokMOd4K93w@mail.gmail.com>
Subject: Re: [patch 001/163] mm/memory.c: avoid access flag update TLB flush
 for retried page fault
To:     Yang Shi <shy828301@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <hdanton@sina.com>,
        Hugh Dickins <hughd@google.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Xu <xuyu@linux.alibaba.com>,
        Yang Shi <yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 1:53 PM Yang Shi <shy828301@gmail.com> wrote:
>
> I'm supposed Catalin would submit his proposal (flush local TLB for
> spurious TLB fault on ARM) for this specific regression per the
> discussion, right?

I think arm64 should do that regardless, yes.

But I would also be ok with a version that does the FAULT_FLAG_TRIED
testing, but does it only for that spurious TLB flushing.

This "let's not update the page tables at all" is wrong, when the only
problem was the TLB flushing.

So changing the current (but quesitonable)

                if (vmf->flags & FAULT_FLAG_WRITE)
                        flush_tlb_fix_spurious_fault(vmf->vma, vmf->address);

to be

                if (vmf->flags & (FAULT_FLAG_WRITE | FAULT_FLAG_TRIED))
                        flush_tlb_fix_spurious_fault(vmf->vma, vmf->address);

would be fine.

But this patch that changes any semantics outside just the flushin gis
a complete no-no.

                Linus
