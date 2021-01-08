Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EDE2EEB4B
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 03:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAHCaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 21:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbhAHCaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 21:30:17 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D00C0612F5
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 18:28:47 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id cw27so9724951edb.5
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 18:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=45e1Re56/VmUzXO7u9IUJ6xNalrmrR+2veigdW6RPf4=;
        b=rJ40C4z3L8Pu6SnRuOGN2x7HgDn32SLsnclqEsjUCD2a/KiV2DL+ZTIkDGobwcZQjz
         5E/V0PWOeh1ZLQyQCmKeNNxVNvMvuE3p14HZr6xG4NBadXvbZeIeczPMyEjlSs6mpkM5
         xHpC1uae17cBMk0N13hnUF8uNxpubD8RC+S/hF/p5ck2hhHC5T0eyKUdABBWT5yJpPi8
         lXu9p+fRdraOIAcweP8mhLXuUh1O+4p2iLCYpLitcLvLutj+qCgNuU9PoMmPxVJp3UBK
         DkVrOp8RWJrdAUwrPpPviGC61H+9iux6Qgf6v4rgDYQgIwiuRQ7tRNjN28o2kzmUavU5
         5NxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=45e1Re56/VmUzXO7u9IUJ6xNalrmrR+2veigdW6RPf4=;
        b=YFkK29tS9WmgDP122SuAxexf1Vpi+tRVr51rPF01oNN5PrGQYGqThnYS+tQQga9guX
         HEQDTlkLPzCoHS0HHgoQ73OAWjah8EzlnZghJ5eDMU3DXr7bvkrIW1ro8UMjORTlS/5B
         194+nawYM6os+F7n18BC1dLjuiaboVCwhi0oizqAjwvaoRdUAl/CPj/gK55HzwPmFSwC
         czOLHdJBggb71kgy9rUowzUT/PkkyDUnJhbuJ/nRBMmK0f5ujdC4CMGqnWzqDtmDTo2B
         epR2iyJlI/D2P/UEfX7iycmlpHyxwTd64e6TCQW4QPpLD3EekStmqcvELEt7yzlcrCf9
         xTfQ==
X-Gm-Message-State: AOAM530uDVnXry3HUz8WWhdDy/6U60grfWkDF7jtoJiD8iX1BxgaPvd2
        GqXfPG/A+I7Y5enm9dlBtE7OjnnQa3CGRUaZLJo4qg==
X-Google-Smtp-Source: ABdhPJx3cSu4x4O1YLTXSH0V/JAx5AWUU06Ss9nJB8Fa1eK7RweYDyrwSjqQdd8xTCgbHQjwdYuNx8/45yzB+bPZeiI=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr3702556edb.365.1610072926320;
 Thu, 07 Jan 2021 18:28:46 -0800 (PST)
MIME-Version: 1.0
References: <20210107143049.929352526@linuxfoundation.org>
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 Jan 2021 07:58:35 +0530
Message-ID: <CA+G9fYtp-9dfcg8nU_2b92Sum-hqpw=YJ-o0bovwWg-XO6dpXg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/13] 5.4.88-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Jan 2021 at 20:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.88 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.88-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.88-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: f52a40401ee9825556cc803c110c67bfec5f6b94
git describe: v5.4.87-14-gf52a40401ee9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.87-14-gf52a40401ee9

No regressions (compared to build v5.4.87)

No fixes (compared to build v5.4.87)


Ran 47652 total tests in the following environments and test suites.

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
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* perf
* fwts
* kselftest
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
