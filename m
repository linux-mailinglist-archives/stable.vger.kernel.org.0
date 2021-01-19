Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649DE2FAF64
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 05:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbhASESO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 23:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730698AbhASEQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 23:16:31 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80734C061575
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 20:15:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id gx5so7343586ejb.7
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 20:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+xqI7pmkHfZPIhl4qdKv0aWEiEZ/J5h4XgL/BitVI6c=;
        b=hEGBPEjGcyL6mIsnGDVY9wM7RDlpidp99ih5yoWyiZkPYdmPWFKF77Zg2LnVCBmRq9
         Bcv/CAEsd/d55t/YEhMtHSIlAhJrfmBnJ3hhkorihLW6THLmW16AG22bsovpR42e2m4B
         D2rX/z6xaYdJyPbqgCwoelAkz9OhkHFGg/BLckMidpWBlDYGzZm8lAnE5YUHbtyMetxM
         OK9m54v9Rv4x37ET/foq2ayyayceQLCHoh4DQUzp/bSL/8Aj0kZaoEsfZILGzgcYD9TT
         9rbjmgrfgvFmeZqQM4KxFZnBHwz1LhqcKkIhF90HZdYzzKHHYh+EHdIswzYYDbm/j+4d
         t37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+xqI7pmkHfZPIhl4qdKv0aWEiEZ/J5h4XgL/BitVI6c=;
        b=sorMg2fk0iYfqAjWivoAkfNN9aRHcYy8ozAC/w+VKVS78710q/pYm4uu5+pUt4nxtK
         TDmfGfWxnoYXOQPeVYYSj7rS3FqX7YV8JP6swNiwSJOF5v5R9EnfP3ACPsCMolvWPRB2
         y478mvJ57bqSOKtqI4Y9FrBaY+uNOnySZhZROjfGXwLXD2uI6DcJkZI0h7Fcvhvo4kNV
         Tku04M6UvWxgjlGm9WVMrGWc1bnHw+vw1vrgc5DMnr6aV0Uq0hdRrlQCp+/EnZFlL/Zv
         K0EAwGug4bgzv0Gx15r2oJ9P7g/doa2Z8q7dZcbAoKDDxicSzPx0Vc7GY5JD0o2OsOMe
         PhWg==
X-Gm-Message-State: AOAM53105iCHJBWqperTV7M+PPArCb3pV1Tw2UXJHQ3Hhd68WXNGEJzD
        VclFhMKdlDUQTa2TWNJwVP08FBFxPHZN1HBlMXMjjA==
X-Google-Smtp-Source: ABdhPJyS6ZzUAo3PsBLY0BK3N55Bulmn9xgRhHuVFf/v1AnbpSH19/ZPES6d4kjjo+lxnqgzaD+CiHs0hy450DImZ3w=
X-Received: by 2002:a17:906:796:: with SMTP id l22mr1765820ejc.247.1611029749137;
 Mon, 18 Jan 2021 20:15:49 -0800 (PST)
MIME-Version: 1.0
References: <20210118152502.441191888@linuxfoundation.org>
In-Reply-To: <20210118152502.441191888@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Jan 2021 09:45:37 +0530
Message-ID: <CA+G9fYtoyxCUazARe2hatMLc-SkiAgM5+NjczeWF24reyojFYQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/42] 4.19.169-rc2 review
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

On Mon, 18 Jan 2021 at 20:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.169 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Jan 2021 15:24:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.169-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.169-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 121b496fc97087651e58900fa366f6ca009f1df8
git describe: v4.19.168-43-g121b496fc970
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.168-43-g121b496fc970

No regressions (compared to build v4.19.167-44-g710affe26b43)

No fixes (compared to build v4.19.167-44-g710affe26b43)

Ran 48462 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* network-basic-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* kvm-unit-tests
* rcutorture
* fwts
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
