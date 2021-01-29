Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1035308DBC
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 20:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhA2Tun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 14:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbhA2Tua (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 14:50:30 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E89C061574
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:49:50 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b21so11916987edy.6
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 11:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CZuF2K0ed9Hp47FYsKrunae+WDUkzw71fDVBmdmFxAA=;
        b=OKXzKEVX17EzWmhN0UlwlxeroWHQm6tWYcFcwi1g9yLaxqIR4f/wHa3qccnhr7YZjP
         1moV5+VsWVxijXXtJTQlXAASJVg6jLnnwXmnhD7GTdP3iFnRPfV0szy6lg9RYssSVHXm
         xpwx71FMWLHgzWSAW5kPWvYNcML1xRLe/NkNvl5YqaEshaqEpyi3qBE8hiQMvYI69QcP
         a2pq7WAHePv8rULzFrA4oN4P1ANkT2S5FrWa3oU264ASBtGZxK0ueBzDe1FGpjYR/aV7
         OCo+vsFNnLT060kUeH31yi8p/NokeKqy17imn+Y83qTTJiaAekkkevzhaIRKK0U0/sI0
         BZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CZuF2K0ed9Hp47FYsKrunae+WDUkzw71fDVBmdmFxAA=;
        b=QiXIYB/+YxanZOoGe7N6Slk6bjkvFwoYDDNjxMgo0HdgGunHkj/JT4zhOtQbvVIe31
         Rv0nRvbYRv++IqXu9cHZX9ZBboyjv/d5mdYoiuIf9TdSv6lqg9Dyxbb5PqKzPEEc1TVw
         +tGgNCX9YDgNwyJ+4RsnX34fQiQrqem8cDsRux0kExhR/kXUb1AUuUDyFbzlXQF0GhIz
         ZusjXi/92g88/PPjk0PTgOJ7p0B/XYiLj07lNjPMCockTtvwFKJbNiXgs/AqNLqCT0ig
         oBMGW9Q47D83eiodFtxUkLiGRF9p8gdPIQ1gKz788A/sxILH507lPRPFxYwUMud/yeBO
         i91A==
X-Gm-Message-State: AOAM533PmFkqG6hENfHFhsYANtynoUzR+pi6xWod7+ZsaR8jUj8TRL0S
        gTU9K7zgGYGEN+8f7c/0GeOlQgS4nRWCcDh5TMeDCg==
X-Google-Smtp-Source: ABdhPJySeHRpNIIhPu5UoEe4bBhL38QMz6JGRhhfHORER60wgCHa1jlyF0XQpdQ4v6nw/E4JnqWOEbxb7dKlyvGrsLA=
X-Received: by 2002:aa7:d905:: with SMTP id a5mr7277125edr.78.1611949788723;
 Fri, 29 Jan 2021 11:49:48 -0800 (PST)
MIME-Version: 1.0
References: <20210129105910.132680016@linuxfoundation.org>
In-Reply-To: <20210129105910.132680016@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 30 Jan 2021 01:19:37 +0530
Message-ID: <CA+G9fYvmCHVH1qSsHoG584eT2KJgjkawzgXUOi0ts2LZ9YnF2w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/18] 5.4.94-rc1 review
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

On Fri, 29 Jan 2021 at 16:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.94 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.94-rc1.gz
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

kernel: 5.4.94-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 5a6e0182cbe9eb6e7cefcb8761c5c9b4f15c02b1
git describe: v5.4.93-19-g5a6e0182cbe9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.93-19-g5a6e0182cbe9

No regressions (compared to build v5.4.93)

No fixes (compared to build v5.4.93)

Ran 52505 total tests in the following environments and test suites.

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
- nxp-ls2088-64k_page_size
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
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* ltp-commands-tests
* ltp-containers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* network-basic-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* v4l2-compliance
* kvm-unit-tests
* fwts
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
