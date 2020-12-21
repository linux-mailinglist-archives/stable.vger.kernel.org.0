Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213F62E0155
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 20:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgLUT4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 14:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgLUT4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 14:56:03 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E77C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:55:22 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id x20so26464161lfe.12
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCBFPsCpCA9jFChy+wbQC9wCUWkajD5jyJSjFoZ0ofo=;
        b=RoUfL1UQrju6L48+iQbnAuB+O5aGNFDdmcnK2mRc37NBlEcyy3oNTYfXpUHSUk0B35
         dyl68X414Hb7YAzAj1hsl3TCaId7C7UFi67zJ4SoucOav2U+/iSnEu4JiV4cxpWLeNcM
         8qVKyAtxm6Xi83AKNirlrvn4iBrF7Tec+b0I0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vCBFPsCpCA9jFChy+wbQC9wCUWkajD5jyJSjFoZ0ofo=;
        b=ggKn0jKNy5j4KtPlkc7/s4KwI6cotDs+WGg86OlFQYkOuE+LbDOgSpzdWXbNgU7+AV
         TRkvrxoiHuwMdhaPYXGKawDIvZGVqU5bnU+WG5HKAWjZePcZ8mrckVJRKvz/xJyfOYzt
         Sdtbtk5Phn2hbAP+8m690dRldhQylgTvsaYOJl1T+fryHMpGmZD1rBk2IWDNvADPm0fb
         OAg5sCvq2Dlvyk4Q28Ajthj+HMT4Qm5iRZotwRWzgCMaodY8yJ85oWt6bA63FGDy7Okw
         exZsmsGJ+W1TXoFKilsC6hjrrE53uXZgexU36syiLqyjmtw0upHhayQByncI/Qclfu8s
         EQaQ==
X-Gm-Message-State: AOAM532mlViWOJtNlIKqeAxcJJKonty+p2wNw46Y7lSRUzS9qAEA/MMF
        7rfHz6vYTdyr7QjxxZJLvW5E04o/ez33Qg==
X-Google-Smtp-Source: ABdhPJyu4jiiSbr/Z1Pg13PHauAQYa03yhomjBGeK0p4jTirbtcknfQvkJHjTCRj7JxWZxz11ODjwQ==
X-Received: by 2002:a19:44:: with SMTP id 65mr6915359lfa.151.1608580520872;
        Mon, 21 Dec 2020 11:55:20 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id s2sm2199941lfs.2.2020.12.21.11.55.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 11:55:19 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id y19so26414585lfa.13
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:55:19 -0800 (PST)
X-Received: by 2002:ac2:41d9:: with SMTP id d25mr6675489lfi.377.1608580519056;
 Mon, 21 Dec 2020 11:55:19 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com> <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com> <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com> <X+D0hTZCrWS3P5Pi@google.com>
In-Reply-To: <X+D0hTZCrWS3P5Pi@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 11:55:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
Message-ID: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
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

On Mon, Dec 21, 2020 at 11:16 AM Yu Zhao <yuzhao@google.com> wrote:
>
> Nadav Amit found memory corruptions when running userfaultfd test above.
> It seems to me the problem is related to commit 09854ba94c6a ("mm:
> do_wp_page() simplification"). Can you please take a look? Thanks.
>
> TL;DR: it may not safe to make copies of singly mapped (non-COW) pages
> when it's locked or has additional ref count because concurrent
> clear_soft_dirty or change_pte_range may have removed pte_write but yet
> to flush tlb.

Hmm. The TLB flush shouldn't actually matter, because anything that
changes the writable bit had better be serialized by the page table
lock.

Yes, we often load the page table value without holding the page table
lock (in order to know what we are going to do), but then before we
finalize the operation, we then re-check - undet the page table lock -
that the value we loaded still matches.

But I think I see what *MAY* be going on.  The userfaultfd
mwriteprotect_range() code takes the mm lock for _reading_. Which
means that you can have

Thread A     Thread B

 - fault starts. Sees write-protected pte, allocates memory, copies data

                   - userfaultfd makes the regions writable

                   - usefaultfd case writes to the region

                   - userfaultfd makes region non-writable

 - fault continues, gets the page table lock, sees that the pte is the
same, uses old copied data

But if this is what's happening, I think it's a userfaultfd bug. I
think the mmap_read_lock(dst_mm) in mwriteprotect_range() needs to be
a mmap_write_lock().

mprotect() does this right, it looks like userfaultfd does not. You
cannot just change the writability of a page willy-nilly without the
correct locking.

Maybe there are other causes, but this one stands out to me as one
possible cause.

Comments?

              Linus
