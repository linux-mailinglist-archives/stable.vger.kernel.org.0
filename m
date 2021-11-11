Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA1944D8A9
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 15:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhKKO5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 09:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhKKO5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 09:57:45 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6DAC061767
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 06:54:55 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f8so25430259edy.4
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 06:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ql50oYZam8nRgTlii9W+zHR5ggQMofgyrRkyjXsb+4=;
        b=g43zqm1IG0DUJDgX5IEt1eNNjc1wWkUZmlMYWGyjr0wQN0WbOgdCZ0dtI+X7lY9si0
         Yvb32DVhCw7zzZrHT0V0kcFhyKiNjbFT8baaxAbPWvHuLf4tNRumfK9CUZHbUI5hsS3K
         doOZc6r1hqgNzLdCxEWe0jc4CaHYH1uDPTL5EflUrJmKt4GNtsJRQMcTzg90cAw9XBGg
         DBxQCGEcWR3Mh0XyG9sK9VZ2er5JqdnUizs6vMSZQDiLRb84emPWTpaKu/r0+uktyphi
         oFPFZ/9jmVz7N83+KYRP7IgCtP4ObIRXEmUUYaGR5gwN4TzYXpU0UdPnRqd0SVb45XoW
         7drQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ql50oYZam8nRgTlii9W+zHR5ggQMofgyrRkyjXsb+4=;
        b=65JSrIvaClis64AOtSZ5Lgpd0eavtIOSQnHbpoRZ2xJbsgos1shcvJCGgxCN0Y8Hca
         Ga+lYbcnUiU8t7T2Akr/OJc12WbZQWhyU7JDU2H4ijW31EawTMRse3bOxsZr6WacEqv/
         LrDJkCXwlXiAjgwcCnbrzGZ7K2WIPtiS2pfo7Q0Zxq01AMTX7hUsMtf/zr+NE5iasaX2
         BJGUGANw+It1c9E4sp4K47xWLiFmk0i9+gX3yKJKKaOh+vDrZ3XuIr7zZDW+2QONcUpa
         2gXLASFpSeWEIk/jYzOMpqb9wEsMdP/5g0E1e6Pbmxi91o/kZbu7wa3l2IkKL5+lx8sH
         uq2Q==
X-Gm-Message-State: AOAM533f2mx/yvDx1AyHyZP5CKaj+eS6oVASijK/ywlmIirX+KdLkQlW
        JAtohxGdf/9+YD5yFTgslTaGLaDjXbWwqBcNycESCQ==
X-Google-Smtp-Source: ABdhPJx5p+j85XYeBZcKsv3Ca/CEMzLdz1mG5k9qaSMa2wd9b562ZENHOeC2Zz1dfD/ZkbQGylMu6AF6bqfQGeP0QEA=
X-Received: by 2002:a17:906:4791:: with SMTP id cw17mr10160961ejc.493.1636642494002;
 Thu, 11 Nov 2021 06:54:54 -0800 (PST)
MIME-Version: 1.0
References: <20211110182002.964190708@linuxfoundation.org> <YY0UQAQ54Vq4vC3z@debian>
In-Reply-To: <YY0UQAQ54Vq4vC3z@debian>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Nov 2021 20:24:42 +0530
Message-ID: <CA+G9fYvu9VQY=_NgR6-UCFOZ+57pSy1xsPkCgJuQsAS-P62Umg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        f.fainelli@gmail.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, lkft-triage@lists.linaro.org,
        patches@kernelci.org, stable@vger.kernel.org, pavel@denx.de,
        akpm@linux-foundation.org, jonathanh@nvidia.com, shuah@kernel.org,
        linux@roeck-us.net, Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Nov 2021 at 18:32, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.79 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> > Anything received after that time might be too late.
>
> systemd-journal-flush.service failed due to a timeout resulting in a very very
> slow boot on my test laptop. qemu test on openqa failed due to the same problem.
>
> https://openqa.qa.codethink.co.uk/tests/365
>
> A bisect showed the problem to be 8615ff6dd1ac ("mm: filemap: check if THP has
> hwpoisoned subpage for PMD page fault"). Reverting it on top of 5.10.79-rc1
> fixed the problem.
> Incidentally, I was having similar problem with Linus's tree
> for last few days and was failing since 20211106 (did not get the time to check).
> I will test mainline again with this commit reverted.

I have also noticed this problem and Anders bisected and found this
first bad commit.

Failed test log link,
A start job is running for Journal Service (5s / 1min 27s)
https://lkft.validation.linaro.org/scheduler/job/3901980#L2234

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Bisect log:

# bad: [b85617a6291f710807d0cd078c230626dee60b16] Linux 5.10.79-rc1
# good: [5040520482a594e92d4f69141229a6dd26173511] Linux 5.10.78
git bisect start 'b85617a6291f710807d0cd078c230626dee60b16'
'5040520482a594e92d4f69141229a6dd26173511'
# bad: [7ceeda856035991a6c9804916987a03759745fb0] staging: rtl8712:
fix use-after-free in rtl8712_dl_fw
git bisect bad 7ceeda856035991a6c9804916987a03759745fb0
# bad: [8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed] mm: filemap: check
if THP has hwpoisoned subpage for PMD page fault
git bisect bad 8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed
# good: [e9cb6ce4690749d42013f1d56874c624d7241740] Revert "x86/kvm:
fix vcpu-id indexed array sizes"
git bisect good e9cb6ce4690749d42013f1d56874c624d7241740
# good: [dc385dfc126d51d7a93db694f8e151afe60eb06a] mm: hwpoison:
remove the unnecessary THP check
git bisect good dc385dfc126d51d7a93db694f8e151afe60eb06a
# first bad commit: [8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed] mm:
filemap: check if THP has hwpoisoned subpage for PMD page fault
commit 8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed
Author: Yang Shi <shy828301@gmail.com>
Date:   Thu Oct 28 14:36:11 2021 -0700

    mm: filemap: check if THP has hwpoisoned subpage for PMD page fault

    commit eac96c3efdb593df1a57bb5b95dbe037bfa9a522 upstream.

    When handling shmem page fault the THP with corrupted subpage could be
    PMD mapped if certain conditions are satisfied.  But kernel is supposed
    to send SIGBUS when trying to map hwpoisoned page.

    There are two paths which may do PMD map: fault around and regular
    fault.

    Before commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
    codepaths") the thing was even worse in fault around path.  The THP
    could be PMD mapped as long as the VMA fits regardless what subpage is
    accessed and corrupted.  After this commit as long as head page is not
    corrupted the THP could be PMD mapped.

    In the regular fault path the THP could be PMD mapped as long as the
    corrupted page is not accessed and the VMA fits.

    This loophole could be fixed by iterating every subpage to check if any
    of them is hwpoisoned or not, but it is somewhat costly in page fault
    path.

    So introduce a new page flag called HasHWPoisoned on the first tail
    page.  It indicates the THP has hwpoisoned subpage(s).  It is set if any
    subpage of THP is found hwpoisoned by memory failure and after the
    refcount is bumped successfully, then cleared when the THP is freed or
    split.

    The soft offline path doesn't need this since soft offline handler just
    marks a subpage hwpoisoned when the subpage is migrated successfully.
    But shmem THP didn't get split then migrated at all.

    Link: https://lkml.kernel.org/r/20211020210755.23964-3-shy828301@gmail.com
    Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
    Signed-off-by: Yang Shi <shy828301@gmail.com>
    Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
    Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Matthew Wilcox <willy@infradead.org>
    Cc: Oscar Salvador <osalvador@suse.de>
    Cc: Peter Xu <peterx@redhat.com>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 include/linux/page-flags.h | 23 +++++++++++++++++++++++
 mm/huge_memory.c           |  2 ++
 mm/memory-failure.c        | 14 ++++++++++++++
 mm/memory.c                |  9 +++++++++
 mm/page_alloc.c            |  4 +++-
 5 files changed, 51 insertions(+), 1 deletion(-)


--
Linaro LKFT
https://lkft.linaro.org
