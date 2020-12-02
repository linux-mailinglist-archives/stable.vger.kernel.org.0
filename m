Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A312D2CB415
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 05:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgLBEvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 23:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgLBEvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 23:51:54 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5784DC0613D4
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 20:51:02 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id f11so329559oij.6
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 20:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O8OlWUcn7I2y85PlZGoSs1/3GiW9RLGsL8QEgM5BfWE=;
        b=FXUUlYedBtzyDH/d8h7WkSI6z5K7ONVtUmD50lnitII7od9wmCKWDBDDmBA4B0F+Oz
         oK28SXXD3fWXb20EGgvYx4h/ICtB/0l9uMvWV4G3MYfSsgtwS408Tb/x2vS+DuoSz9VJ
         KR507+R/820UCCnxopotLc0df90dq9x9IwuaNdjsJLKzD40HsI9qs2h7nbVeN9EtYYW/
         ojTP9qmSmLo7fzO8xehOqtJOz4Pflj0tcJXRtp6VnpCOLGrHtR/be5MLpmW+8ilfLKUn
         hEVoeySrvb227JZMd8Pq6STMkcBKw9MNbWZXUKSPOsx36TVLBenrUmzaNUrE9ZpX6cm4
         m+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O8OlWUcn7I2y85PlZGoSs1/3GiW9RLGsL8QEgM5BfWE=;
        b=lsJzF3Mzy3k2v0tUCzBiy7Fn4zSFM/O+Mxg+Rv3Isl8YQnU5nqbClHAOk9CvHc0IZz
         TWlFcs3WrIXv5mXs07axhxumIPn1Tu1X9ikG2yoNcIY4XC8IX59OhO/utRC5arvLWLwL
         ur4q/soBvWTJgz5iaQZTbPi3hfNIK9bWRZfK2QhBlyrZEhcWnUFbwtEUBRA4A6qbzPt7
         /W2lwGIWxv6rM1820AeiONIh9abv4Kgpk+YyVQD15GJOouMcfqERKK1X9LiGZDssf5Jx
         ZYExSdH20yntiTAavhfJoWZxVUUmBp2qrbKVE3554atVTuRcmpIghJ9VAK87zPDc4CLs
         ugLg==
X-Gm-Message-State: AOAM533LedxrU8AHLhYZGAS3zmohNPrfcCuXs8y46cjOYgfuZo7cHePJ
        tBFf3uh+rpl/InOhdQDCHWmLULXVuDFXGhdUCp5B9t7jfeXFbsqY
X-Google-Smtp-Source: ABdhPJwCAstSm0B5FLMvJw8Ny2PlCdnlSfjUssiJQvc4+IR8JjAHAoTcwUOB4BarcTls2i+qyc0JrNadbJXIX3ACKN8=
X-Received: by 2002:aca:809:: with SMTP id 9mr462435oii.13.1606884661546; Tue,
 01 Dec 2020 20:51:01 -0800 (PST)
MIME-Version: 1.0
References: <20201201084711.707195422@linuxfoundation.org>
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Dec 2020 10:20:50 +0530
Message-ID: <CA+G9fYsjnhqak8Bf+YXqqdZchVC+Rc3S=WiD2cBKu7qX_95scw@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/152] 5.9.12-rc1 review
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

On Tue, 1 Dec 2020 at 14:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.12 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.12-rc1.gz
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
BUG: Invalid wait context on arm64 db410c device.
This is an intermittent issue seen while booting and while running kselftes=
ts.
https://lore.kernel.org/stable/CA+G9fYupbQK02Yor=3DU-80JEdkwacZ7bi3RKt3+D=
=3De+qZ-o0uCA@mail.gmail.com/
https://lore.kernel.org/stable/CA+G9fYsk54r9Re4E9BWpqsoxLjpCvxRKFWRgdiKVcPo=
YE5z0Hw@mail.gmail.com/

Summary
------------------------------------------------------------------------

kernel: 5.9.12-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: fb49ad2107f4b740257c84ec2991fc6afb447f53
git describe: v5.9.11-153-gfb49ad2107f4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.11-153-gfb49ad2107f4

No regressions (compared to build v5.9.11)

No fixes (compared to build v5.9.11)

Ran 53637 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-containers-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-sched-tests
* network-basic-tests
* kselftest
* ltp-controllers-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
