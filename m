Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FA345C772
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353646AbhKXOgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355790AbhKXOfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:35:55 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9CAC1A2ECC
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 05:22:53 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id t5so10600466edd.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 05:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=V+QUfd5DKJNhCRaZ+9Sy4asHCx0sUS71DgtMVIdw2vQ=;
        b=BQJXfCtcH1ooGfhsNrILUu7J6XnqZ8B6FIlafT9azVM1RTr4bLAKiIoJpMJoE0Zrnf
         DZhKJ4Mz5pISY/YMI/nAnuqFm6AAhiA06AyUUTFozTaECIvkip3GO4L3BcDts6QmwnHc
         Udh4Kjwu/njDu80SfvPAu5Q81K0O9AE/cyA63/ohqZPwee7ADjNwxyRlx+s13DFkYZIn
         JZK2Vu8PPACV2l7RPVM6yvuy7J8w6rfaKXo4qW/2IPbTCpi52Ybe8wHV53Q89YX6Bwmf
         BE7Vox6zCsuZU8VxfLgyBFOdaIBzLKfOq4iS9aM+qMa6BcHIJryNbnmjUlFmd3lTjiMg
         CuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=V+QUfd5DKJNhCRaZ+9Sy4asHCx0sUS71DgtMVIdw2vQ=;
        b=r4j5ACwnaZQDRYws/yrtAe7JBbIwJc37UUxDSWiCa5buM2nbGUDyjkJatsEZARXHty
         y0g1qUR+LZy67nztynjRig6+GBAHjJ4xdLTeKKE9dydwNBb7ODLJkSjAuIa8O0xLzD2g
         7ClMUPeBMJgJBD/D0kc7IXI1lMRLAU8EEgCR4zWoiMGYqeTc+5G13wWuxXWS71IvwimC
         zM8HsI6TwDEmfPtH753MFLBUHN6vqw/J9o3GBcfc6G0gC43WqgvsclumSK28Hvd1dVwv
         ejszwjGI4tNWdcSGAzVXOCqcdnQXVOKufmQXpz+wT9S9jbt/YTTS/caVs772+NH32oZn
         JDWw==
X-Gm-Message-State: AOAM532vs392Ek0CayWrTBt1Ot/IMxbbHcdIfYBgaZyFjAG9kBUJZCWK
        wKhI9WxdsNaKIlDmNHdZC/HiLb5/Oq5+gE+xt4fx8+A5JmFTcw==
X-Google-Smtp-Source: ABdhPJyd4VU+sUbnBOWEAaBsRROkqJCtH1eAH4EJfYOAnoEdbOp0SLSmA1ZYBX9LKFW/JzbsJ6fDN0bAeELfdNtxOj8=
X-Received: by 2002:a05:6402:2814:: with SMTP id h20mr25245889ede.288.1637760171344;
 Wed, 24 Nov 2021 05:22:51 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 18:52:40 +0530
Message-ID: <CA+G9fYv+SjDwfvP=Zgf-gr2RngkrzHO_w6OQzH7wqzU-dOW9+g@mail.gmail.com>
Subject: mm: hugetlb.c:3455:25: error: implicit declaration of function 'tlb_flush_pmd_range'
To:     linux-stable <stable@vger.kernel.org>
Cc:     Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Regression found on s390 gcc-11 builds with defconfig
Following build warnings / errors reported on stable-rc 4.19.

metadata:
    git_describe: v4.19.217-324-g451ddd7eb93b
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
    git_short_log: 451ddd7eb93b (\"Linux 4.19.218-rc1\")
    target_arch: s390
    toolchain: gcc-11 / gcc-10 / gcc-9 / gcc-8

build error :
--------------
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=s390
CROSS_COMPILE=s390x-linux-gnu- 'CC=sccache s390x-linux-gnu-gcc'
'HOSTCC=sccache gcc'
arch/s390/kernel/setup.c: In function 'setup_lowcore_dat_off':
arch/s390/kernel/setup.c:342:9: warning: 'memcpy' reading 128 bytes
from a region of size 0 [-Wstringop-overread]
  342 |         memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  343 |                sizeof(lc->stfle_fac_list));
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/s390/kernel/setup.c:344:9: warning: 'memcpy' reading 128 bytes
from a region of size 0 [-Wstringop-overread]
  344 |         memcpy(lc->alt_stfle_fac_list, S390_lowcore.alt_stfle_fac_list,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  345 |                sizeof(lc->alt_stfle_fac_list));
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/s390/kvm/kvm-s390.c: In function 'kvm_s390_get_machine':
arch/s390/kvm/kvm-s390.c:1302:9: warning: 'memcpy' reading 128 bytes
from a region of size 0 [-Wstringop-overread]
 1302 |         memcpy((unsigned long *)&mach->fac_list,
S390_lowcore.stfle_fac_list,
      |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 1303 |                sizeof(S390_lowcore.stfle_fac_list));
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/s390/kernel/lgr.c:13:
In function 'stfle',
    inlined from 'lgr_info_get' at arch/s390/kernel/lgr.c:122:2:
arch/s390/include/asm/facility.h:88:9: warning: 'memcpy' reading 4
bytes from a region of size 0 [-Wstringop-overread]
   88 |         memcpy(stfle_fac_list, &S390_lowcore.stfl_fac_list, 4);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'pcpu_prepare_secondary',
    inlined from '__cpu_up' at arch/s390/kernel/smp.c:878:2:
arch/s390/kernel/smp.c:271:9: warning: 'memcpy' reading 128 bytes from
a region of size 0 [-Wstringop-overread]
  271 |         memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  272 |                sizeof(lc->stfle_fac_list));
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/s390/kernel/smp.c:273:9: warning: 'memcpy' reading 128 bytes from
a region of size 0 [-Wstringop-overread]
  273 |         memcpy(lc->alt_stfle_fac_list, S390_lowcore.alt_stfle_fac_list,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  274 |                sizeof(lc->alt_stfle_fac_list));
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3455:25: error: implicit declaration of function
'tlb_flush_pmd_range'; did you mean 'tlb_flush_mmu_free'?
[-Werror=implicit-function-declaration]
 3455 |                         tlb_flush_pmd_range(tlb, address &
PUD_MASK, PUD_SIZE);
      |                         ^~~~~~~~~~~~~~~~~~~
      |                         tlb_flush_mmu_free
cc1: some warnings being treated as errors


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
-----------
https://builds.tuxbuild.com/21MfFQQKrxPYUW7b8amBJjt3Ki7/build.log

build config:
-------------
https://builds.tuxbuild.com/21MfFQQKrxPYUW7b8amBJjt3Ki7/config

# To install tuxmake on your system globally
# sudo pip3 install -U tuxmake
tuxmake --runtime podman --target-arch s390 --toolchain gcc-11
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
