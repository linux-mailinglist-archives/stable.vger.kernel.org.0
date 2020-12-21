Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF09B2E0184
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 21:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgLUU0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 15:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUU0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 15:26:08 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406CAC0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:25:27 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o17so26769097lfg.4
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5zaXo4wHvh1dW+KqsesRxK7xiAm0BCunbjnJYxvhz8=;
        b=Ms5Xy1U+4jhVMIkNDhKzne/rZJlQEFuV7hucbckZy+YFqWk5mcJQ96C3W1K+G8i09y
         8J9WxZMu8pqcOCErRRebf2lG7lky5KbqBcvfLLdaBfCIvva4S386rnAsqChHlbUnSFYf
         pJY2/7Xoxilz9bukgW9iDxfnFQILnhL6fjU2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5zaXo4wHvh1dW+KqsesRxK7xiAm0BCunbjnJYxvhz8=;
        b=mROGHEQfsNGFDUOXYjdPKjwWIow63ZOpdn9IEqRnMZlZ0zhTcgkHLgEc7KeAbD/sKT
         j3ZOXLfu9AigQZYzjfINlup7w9Bk6Kg+4PACFvezLGstBO5cjCKnmHg2bxKJrbD+k86W
         pkJkl42KnFepjRU5KKB1KWzARZgXr3GMkS9iZKHGwHyIib+G+49r6jCIxkaLl2+vUGha
         4IBVa22nPDcXNIDl425NDuXzIcoXUvQ2v+DXK+nSVkkQBQLvvypX89hKVRcW87IWc5pJ
         7u0ruai0p3y88QX9PxBpZxK980GzfBTqHuI76Qit4kxmL2A6UtV6sSGkELBhgDsgTH5J
         GCFA==
X-Gm-Message-State: AOAM5327E17jVaOVokFqMXCms1dHX5jKfQEh4xnBoAMLngFtUKVXPCIt
        0Ot+AZdz6l8R4MnzeA+GFzPYN+ujaAjuTQ==
X-Google-Smtp-Source: ABdhPJzctGUWeUG7ZM/0ZUNUfORSxpf58tURBGHYtGTb32zqit37m7+NEOLJfcnKAWz0vv0b71I/eA==
X-Received: by 2002:a19:c14c:: with SMTP id r73mr7036297lff.131.1608582325487;
        Mon, 21 Dec 2020 12:25:25 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id 187sm1860198lfo.20.2020.12.21.12.25.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 12:25:24 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id x20so26651526lfe.12
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 12:25:24 -0800 (PST)
X-Received: by 2002:a2e:8995:: with SMTP id c21mr7868338lji.251.1608582323808;
 Mon, 21 Dec 2020 12:25:23 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com> <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com> <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com> <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com> <X+EDslLVp9yRRru6@google.com>
In-Reply-To: <X+EDslLVp9yRRru6@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 12:25:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjUST1qd9Q668rwSzwOLQxTaAC1oUd7pPQBSj2s6PkqAw@mail.gmail.com>
Message-ID: <CAHk-=wjUST1qd9Q668rwSzwOLQxTaAC1oUd7pPQBSj2s6PkqAw@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Yu Zhao <yuzhao@google.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 12:21 PM Yu Zhao <yuzhao@google.com> wrote:
>
> Well, unfortunately we have places that use optimizations like
>
>   inc_tlb_flush_pending()
>     lock page table
>       pte_wrprotect
>   flush_tlb_range()
>   dec_tlb_flush_pending()
>
> which complicate things.

My point is, none of that  matters.

Because the software side that does the actual page table
modifications do not depend on the TLB at all.

They depend on the page table lock, and the pte in memory.

So the "pending flush" simply shoudln't be an issue. It's about the
actual hardware usage.

But what DOES matter for the software accesses is that you can't
modify protections without holding the proper lock.

And userfaultfd seems to do exactly that, breaking the whole "load pte
early, then check that it didn't change".

(Which we do in other places too, not just COW - it's basically _the_
pattern for page table updates).

               Linus
