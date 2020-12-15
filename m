Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539142DA839
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 07:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgLOGwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 01:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgLOGv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 01:51:57 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500A5C06179C
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:51:17 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id g20so26114206ejb.1
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/2v55j6kPVQqG/6UhmUqPYd8SOtE4gPGKwChg0G6kpU=;
        b=jLQI7kqQm5oqDw44AuRFF6U7J7a9PQH/7MGmueuIkfA2A46XUR9451HVvu94E+Ayqo
         fPHOlrd3UBoq5SsfSuedaS4NM7uRPLK0MI13LeMxduG7xd03jF3RzShF2OLCaveM1ufK
         06FcnmbzVzJvn6bDsnlNMa0tajrfr9+u/VuchYn4qoqSapMXnp5WlIKpvKwHFzQp82tX
         aRvBAXGX/4m5s+MS6jKoJisjEJ3Zs0cRpkltsR23+LIMs2VAFTf5eRgXmIAHhCS5fpK0
         YUW4Gzi0naTLNpR4/1qTz0UKFHFr+V1ehhiiPU9U5YrCTjw4GZv/tgkJEcZI0d0ud0qu
         xTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/2v55j6kPVQqG/6UhmUqPYd8SOtE4gPGKwChg0G6kpU=;
        b=F2O3+qKMXWcG/DfalgsuFd9tFTkdsmFS7Ksi+WYMNBhw2tXFnIKFEeKbpWA28Z83fd
         zyDlUNLrYPVfQd6BpCpR2n57hTFfBgdAu5yC2MKba/yIUZxhovQdB7EtiLLhUd/VLMTj
         X6DbaF4a0xmXhQOjMg5sqdE8DmgtNQ3rLg8957+fRn1eDvh9Pi3XSEN0+Y42bgH0F2ZE
         z4FYcMcd7gW6o9q5mKosEx9MjjCA5kvYfwwz1vTqXQjXlw+uQWasH3XR+u/lMpD7dMd2
         Ln2bHWVqiS47K5/WvN9H7oJPj+MyLVFO7GpdGRLayYhiDRz/tnohu6XqXgpzqOMTpj+n
         wViQ==
X-Gm-Message-State: AOAM533w876is+9YXV+yrg7QkDOSHC5hIcMD/zGJk6OYiRR4jHdTOgWh
        hAaKOIT16YkSeNeok55n+c3BtLKak5m8BV6pCox7fA==
X-Google-Smtp-Source: ABdhPJwHlo1p1GxgJRCYAA100TLFoBub7yTU5JimOH0tld87eTPvkiDScX3TRmSz5ejXsS5p5aatIb44MuCht3Xqk3U=
X-Received: by 2002:a17:906:2ec3:: with SMTP id s3mr24787693eji.133.1608015075837;
 Mon, 14 Dec 2020 22:51:15 -0800 (PST)
MIME-Version: 1.0
References: <20201214172543.302523401@linuxfoundation.org>
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Dec 2020 12:21:03 +0530
Message-ID: <CA+G9fYu3GfiCL3VxJ3f0qfgoEAFnRdwxs2eKpb1uGx-D4Kr3MQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/36] 5.4.84-rc1 review
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

On Mon, 14 Dec 2020 at 22:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.84 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.84-rc1.gz
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

kernel: 5.4.84-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: fbaf54ae613a47a62193642683ab9f23997aaa50
git describe: v5.4.83-37-gfbaf54ae613a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.83-37-gfbaf54ae613a

No regressions (compared to build v5.4.83)

No fixes (compared to build v5.4.83)

Ran 53822 total tests in the following environments and test suites.

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
* kselftest
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* network-basic-tests
* ltp-containers-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* fwts
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
