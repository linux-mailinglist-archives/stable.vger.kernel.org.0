Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7754644F355
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhKMNWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhKMNWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 08:22:16 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C6C061766;
        Sat, 13 Nov 2021 05:19:24 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b11so10608766pld.12;
        Sat, 13 Nov 2021 05:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=iYxTHzgFyt0ZuShY4vGF5rgZNqLRvd0KSnvHMGpLSc4=;
        b=I+oSiVpeSbpRSOMmFE7J/WXBP0HM/hMvmMKzle1Q6VGLbNtnj4YAUfcQDU9X0WAJLo
         AIQ6wdGhIYCgQrpY9UhSKE0SXolvwVXx/15R2fmYYvHV0mbSoF/LxcnPqzEez9V8ee3S
         0WkTu2QhiijZV5wnoMWs7dO6egNmvOv2UCps15eFLFYIEVCOrpNM7x6IKDZo6RD2jtul
         gQy4p2Hz1k5lSP2uMcPOGFbBUZwoYJLqjls2akpiBbNqT8qnGiwPfFNtPMB5g40VXcnB
         ANh0nj48LG64NpDEUABJF6O9SYfPi+T6apOdRJvLJ63cqOTBCjoHj4FbF3b6IHaulCUo
         Cj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=iYxTHzgFyt0ZuShY4vGF5rgZNqLRvd0KSnvHMGpLSc4=;
        b=25s8Z7i16j0c0q3jDHiQ/u+PyyjBZE25xWWs7zhTt8VAWC1jHZrqw6zMJnlqNX9J1M
         DZT9UVHv6nlKOpwsfZM70ir/clZSn8PzYzYbOIv6gIdcxTNmQl9tDp+TEgJQjFOJzRA1
         AEsArgBVs4Z8yjKh3Dh7Vb/PtxsZiAxy7BwuG66Wr2vBMKWoPd4zjdMmnQMw0GobKsmq
         SOrk+xjTDDpTk5MFBd2Nblo4btl8FYMHZbPyiIlbj4rPq/WjAVsq4r8IWCpNOXM22JGH
         vZ3un7AsPoxTGvkkML2z6XA0OhiP7ydw/EZPy0XiyaCAjw/XKGXQF8bpHqTwM6NGuIXH
         AYcQ==
X-Gm-Message-State: AOAM533iI7ZDudIy+TJdMkhnvEw4W0Mf8BHkmV41ypyiMR8GQ0rl2Ikg
        OIBNSoBRUHrvGbFkhWGKm5WaxjTvHq8PmRg5Ixk=
X-Google-Smtp-Source: ABdhPJw37vbGaXK9MXZY7/Es86pDqjPlrIjQUU6BDC6G/+Szuja/Ry3sY6+caPpceDytIcKzOgFnDtjj3NYneh5X4Hw=
X-Received: by 2002:a17:90b:4c44:: with SMTP id np4mr27114173pjb.195.1636809563747;
 Sat, 13 Nov 2021 05:19:23 -0800 (PST)
MIME-Version: 1.0
From:   Tim Lewis <elatllat@gmail.com>
Date:   Sat, 13 Nov 2021 08:19:12 -0500
Message-ID: <CA+3zgmuJ5a_==NkV+x_JFr=zGN+FyUADot4mwNjJO=P4Q+VjZA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
To:     Yang Shi <shy828301@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        f.fainelli@gmail.com, torvalds@linux-foundation.org,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        jonathanh@nvidia.com, shuah@kernel.org, linux@roeck-us.net,
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

> commit 8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed
> Author: Yang Shi <shy828301@gmail.com>
> Date:   Thu Oct 28 14:36:11 2021 -0700
>
>     mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
>
>     commit eac96c3efdb593df1a57bb5b95dbe037bfa9a522 upstream.

For the sake of testing,
other than this breaking systemd-journal,
postgresql is another service that would hang forever with 100% CPU,
on arm64 (odroid-c4) using Ubuntu 20.04.
