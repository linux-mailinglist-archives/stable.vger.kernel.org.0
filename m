Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2192745C712
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353196AbhKXOVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355506AbhKXOTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:19:19 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89833C0AE494
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:34:35 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so9548603eda.11
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=KBnybnsEanN9Lu3sQbrFmD0oN70pCjfGzA36GUyb964=;
        b=U02+kSBW0mykodIWpI3PudSOLk6ew7qconkGnGxuxv5XSAy9osg8OlfzT6MqfW0ZfV
         EBtUhp0+ezO7NqszJ0B5eIcKtVfXa1vN3E5KgL/Fn28RRx20UdwmDWZrPxfGYB2XhYT/
         c8w+S8kikhM2IgH8d90BMjbxOqQwcEzLi67yqgtGLIobEGyS9Q68qTK7f0gXclQK7Xu9
         lKdVchJDGh5TLzsqVwaqnyEg6j0usz1HXZRJWVvEU4GtlkUAeVVegiWEKNcawo1Hx10K
         2qiK0iRgZrq34UefnGp+VWjO2BgM0M9e9dPD/9UDPOdaBZMYWxg8A3uwN/0wVmkRscCp
         j5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KBnybnsEanN9Lu3sQbrFmD0oN70pCjfGzA36GUyb964=;
        b=c0lYv7L53/Kb7QhV7w5NWDpn9JhhRxh93i4gKHSPZoKC1qAy9gHPI2BIa5a3NNa7Px
         CM0rAcAoc0HyeBecsNz4PhQrqz4ajs5b5PQYkTS6l4x1fb+KWmPclptI6Jx4lTAD91x2
         MnoS2PRTIRUMP9hGmmha80rsDXzVyCshAKj0PDjiHCedcRsWro6FKuA3yc5AG+qTfIMa
         CIcJpbhmKgtSaRaHpjAHejAOVjc1oPEeBCgPjjqZgwCnG0Ph/Z7ZA3WsGdP94HZH+VEW
         ulU5YL8eiEuudtyZKqCRTKspk+yRWjk5+XJPyUox4rp2Rzo7xU4A3M2pxXmCnt5yNBuN
         jp4w==
X-Gm-Message-State: AOAM532BL4WveXIXpCu4qQnLGQ2gJxEnkXfpJhMZ99G5aaA7ebwSR9hI
        ZqUK5GEVDpvlLqKo0rbx03cLbygxj2Wy6yJHDX3/HiKC9IhBSA==
X-Google-Smtp-Source: ABdhPJzMGOoEMSsfXCwfq5Z0gxCvJyerC+i1jWtIysrdSFhT6HTc4+VM2vRCPx7GtXMkltuiFapNdo5wZkP2RJvglzY=
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr19515792ejz.499.1637757272468;
 Wed, 24 Nov 2021 04:34:32 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 18:04:20 +0530
Message-ID: <CA+G9fYvU4yoOx7BEBxJXRVZx4pO5fYPRELmkNz+iBu7kdN_9Ew@mail.gmail.com>
Subject: tlb.h:208:54: error: 'PMD_SIZE' undeclared
To:     linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Regression found on arm gcc-11 builds with tinyconfig and allnoconfig.
Following build warnings / errors reported on stable-rc 4.9.

metadata:
    git_describe: v4.9.290-208-gb2ae18f41670
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
    git_short_log: b2ae18f41670 (\"Linux 4.9.291-rc1\")
    target_arch: arm
    toolchain: gcc-11 / gcc-10 / gcc-9 / gcc-8

build error :
--------------
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
In file included from arch/arm/include/asm/tlb.h:28,
                 from arch/arm/mm/init.c:34:
include/asm-generic/tlb.h: In function 'tlb_flush_pmd_range':
include/asm-generic/tlb.h:208:54: error: 'PMD_SIZE' undeclared (first
use in this function); did you mean 'PUD_SIZE'?
  208 |         if (tlb->page_size != 0 && tlb->page_size != PMD_SIZE)
      |                                                      ^~~~~~~~
      |                                                      PUD_SIZE
include/asm-generic/tlb.h:208:54: note: each undeclared identifier is
reported only once for each function it appears in
make[2]: *** [scripts/Makefile.build:307: arch/arm/mm/init.o] Error 1
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1036: arch/arm/mm] Error 2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Patch pointing to,

hugetlbfs: flush TLBs correctly after huge_pmd_unshare
commit a4a118f2eead1d6c49e00765de89878288d4b890 upstream.

When __unmap_hugepage_range() calls to huge_pmd_unshare() succeed, a TLB
flush is missing.  This TLB flush must be performed before releasing the
i_mmap_rwsem, in order to prevent an unshared PMDs page from being
released and reused before the TLB flush took place.

Arguably, a comprehensive solution would use mmu_gather interface to
batch the TLB flushes and the PMDs page release, however it is not an
easy solution: (1) try_to_unmap_one() and try_to_migrate_one() also call
huge_pmd_unshare() and they cannot use the mmu_gather interface; and (2)
deferring the release of the page reference for the PMDs page until
after i_mmap_rwsem is dropeed can confuse huge_pmd_unshare() into
thinking PMDs are shared when they are not.

Fix __unmap_hugepage_range() by adding the missing TLB flush, and
forcing a flush when unshare is successful.

Fixes: 24669e58477e ("hugetlb: use mmu_gather instead of a temporary
linked list for accumulating pages)" # 3.6
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



build link:
-----------
https://builds.tuxbuild.com//21Mf9eMMjq4oO5ZflMwRCPssSc0/build.log

build config:
-------------
https://builds.tuxbuild.com//21Mf9eMMjq4oO5ZflMwRCPssSc0/config

# To install tuxmake on your system globally
# sudo pip3 install -U tuxmake
tuxmake --runtime podman --target-arch arm --toolchain gcc-11
--kconfig tinyconfig

--
Linaro LKFT
https://lkft.linaro.org
