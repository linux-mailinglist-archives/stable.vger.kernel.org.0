Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEED2E034E
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 01:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgLVAMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 19:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgLVAMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 19:12:01 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12D9C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 16:11:20 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id s26so27822769lfc.8
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 16:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hTuaw61/vu6Ch8LghemKyv8ZjkRGc9Bd4nL0SHS84i8=;
        b=XRqPvAjqNYfYvdTAPbyVeX/6O742pr4s6sQMYn9OH27FKmpUFDXDQcK9Tl2txOM6YO
         vqCZR/1DVmPxmcBQfj8ygABjF6pmB8V6dG3OaZcI7+9pJSjvqpbcqzrEpWL97R7G4EDm
         qS6LzBxmqQ8dWZpVnIRQLX6xY4Ofvg3UtYHJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hTuaw61/vu6Ch8LghemKyv8ZjkRGc9Bd4nL0SHS84i8=;
        b=kHzh5eiJU2grm5XKo80DejuE0XgiJ9WQNNToiG4GbMM/Fx1b35YT+Bm1AqN0d2dD4y
         lxa6L4WrwbqTUsA1Xoby5jOvOuiFT3c+BEV9XQ/Ra/aq3dUNg2+ttv2r4Y7WFnPuqj/B
         qyHRBKWainfZswUxK1/W/bpKRJV5jJzbRiV6Cb1gxjWnYMhWzW4pQSGuHjuMCoeuYh7z
         PU3xWepuzV5+PgEdsPy314VMsHyz2kqP62FNWamrn140C4bBGq6kMA4oLGa4TertqwpP
         78ZE8pu3rPHeEPbypann+X34+lc4GE2Xsk1y0ygV3yCifYygaomfxEz9wLm1p8by1d61
         amcQ==
X-Gm-Message-State: AOAM530dNzX61ud8oqyNYNURpJS8bBA5vgopCLSH8zJNTaTgWpH6cBMD
        6R3TVLNs68wenuFF93l7YFSky6D3A7TCPA==
X-Google-Smtp-Source: ABdhPJzloYiw8IEQW4OKpl6ibFetk7B1V+ivOmLrWNExzQ+bwjjbxZqLJSM9O3V7hQDdO5eJUgyp8Q==
X-Received: by 2002:a2e:a40b:: with SMTP id p11mr8312438ljn.315.1608595879287;
        Mon, 21 Dec 2020 16:11:19 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id p17sm2298145lfc.273.2020.12.21.16.11.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 16:11:18 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id o19so27945892lfo.1
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 16:11:18 -0800 (PST)
X-Received: by 2002:ac2:41d9:: with SMTP id d25mr7001569lfi.377.1608595877900;
 Mon, 21 Dec 2020 16:11:17 -0800 (PST)
MIME-Version: 1.0
References: <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com> <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com> <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com> <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1> <X+Er1Rjv1W7rzcw7@google.com>
 <CAHk-=wiEp-D36h972CBHqJ-c8tR9fytg9tesZ1j_9B0ax9Ad_Q@mail.gmail.com> <X+E3FmxrEVfc0B/X@google.com>
In-Reply-To: <X+E3FmxrEVfc0B/X@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 16:11:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiWkZGSsPXAbonBoNLYj3vETkoB+9eKOxoFZutPgqkYzA@mail.gmail.com>
Message-ID: <CAHk-=wiWkZGSsPXAbonBoNLYj3vETkoB+9eKOxoFZutPgqkYzA@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Yu Zhao <yuzhao@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
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
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 4:00 PM Yu Zhao <yuzhao@google.com> wrote:
>
> My first instinct is to be conservative and revert 09854ba94c6a ("mm:
> do_wp_page() simplification") so people are less likely to come back
> and complain about performance issues from holding mmap lock for
> write when clearing pte_write.

Well, the thing is, that simplificaiton was actually part of fixing a
real regression wrt GUP.

Reverting that would break a308c71bf1e6 ("mm/gup: Remove enfornced COW
mechanism").

And that one was the (better) fix for commit 17839856fd58 that fixed a
real security issue, but did it with a big hammer that then caused
problems for uffd-wp (and some other loads). There's a bit more
context in the merge message in commit b25d1dc9474e Merge branch
'simplify-do_wp_page'.

So while that commit 09854ba94c6a on its own is "just" a
simplification, it's actually part of a bigger series that fixes
serious problems.

                Linus
