Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429332D0B06
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 08:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgLGHSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 02:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgLGHSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 02:18:32 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83E5C0613D1
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 23:17:51 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id p22so517028edu.11
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 23:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JgwRIiaUygwGWbpN/1XxowsK3KkWc0GU8Jcuwuwex9Q=;
        b=yqqJ1zUaju72aAvmz+xalsR9L4KRtbTWXyaZIqtdCDX52xg6Y4XIij6MAP7ZE7kMrB
         sx4OpzN0CoRnRbFReuBrO4JHdi7tTda/jPR1AMrSwB/XOFKHbuJgP5qzb0w/r78Nbj6L
         klQvLf7l9RZZChR+ylyxMfaMhnWKkY3C0EN27Hsy3tVfFmI1ntVcA5IKbu/M1tSCCwsG
         eleTwUg7IU9tmct/t/8hm8IPZL+JJnAMEDjJt+C3pYwRaCwTzo5tWDncpYXqB9RWOyVa
         bF+fOz55wBSan08lSFIXtV1V4RjEOPZICguU0YXFbi8nfnm7ppwCHk1+eTPvIwzXWLIo
         Ej6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JgwRIiaUygwGWbpN/1XxowsK3KkWc0GU8Jcuwuwex9Q=;
        b=rleE6ZPeUw2rwjnmCQ9kD5J3Tcmu8FxQxNfox6uEyZFOXPRETwNjpXkR2nYOoMOYx7
         4hXySaJVJXXFyQMJZo4iphwzopHeJXFn4bpf2M5IaIeiXDSkdiAPTGI1BwDKiP+cOmBR
         AG4VZIN0n0Thmp/mCZINtRL/B3GTVeUb5Cyw9HS3svhPAUKF5/2Lb+0HOJb7NpbF6vCe
         yro6oRmxz7OIeWV2G/8EJJrJZkM+WUerP12GHapZVu4VfSc4Jy/tm3UFG7xRPWyq2oxk
         k33KbgW6zh4CQt+OD/61X+SI/e9js+Zuy3HZmeQOBU0lz13WqxIOH+Z7hvE/QlupElJn
         Jbkg==
X-Gm-Message-State: AOAM5301HF6ak5Z0EjARzCN9fUkb9fi+inBEBCxsvDvevUAQxLtVXnB6
        GmfbvwRwjH7TGKwBunHNoisoptfNFSJ2HamLs4EA4w==
X-Google-Smtp-Source: ABdhPJxBrstOl+aMSOywt4M2qffrIxOwutaDopR6SAJfWTvrDFzyE8FID3j/qX5VwXpF986FiCk1c7Zb4nROdt8YbHk=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr12246012edw.52.1607325470371;
 Sun, 06 Dec 2020 23:17:50 -0800 (PST)
MIME-Version: 1.0
References: <20201206111556.455533723@linuxfoundation.org>
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Dec 2020 12:47:38 +0530
Message-ID: <CA+G9fYt6AO+iz42u=9PKW2UwXcU_FLr35YfsKEEMsbf2gdaqqA@mail.gmail.com>
Subject: Re: [PATCH 5.9 00/46] 5.9.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 6 Dec 2020 at 17:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.13 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following two warnings noticed.
WARNING: bad unlock balance detected! - mkfs.ext4/426 is trying to
release lock (rcu_read_lock)
https://lore.kernel.org/stable/CA+G9fYs=3DnR-d0n8kV4=3DOWD+v=3DGR2ufOEWU9S4=
oG1_fZRxhGouQ@mail.gmail.com/

sched: core.c:7270 Illegal context switch in RCU-bh read-side critical
section! __alloc_pages_nodemask
https://lore.kernel.org/stable/CA+G9fYvhJTwQkGyH7HQzSsDBHT7pm5ziA9VTkRhE_bD=
SQp3JYg@mail.gmail.com/

Summary
------------------------------------------------------------------------

kernel: 5.9.13-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 1372e1af58d410676db7917cc3484ca22d471623
git describe: v5.9.12-47-g1372e1af58d4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.12-47-g1372e1af58d4

No regressions (compared to build v5.9.12)

No fixes (compared to build v5.9.12)


Ran 53360 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* network-basic-tests
* kselftest
* ltp-controllers-tests
* ltp-open-posix-tests
* kunit
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
