Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA87A2D7054
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 07:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgLKGqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 01:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbgLKGqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 01:46:05 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C81C0613D3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 22:45:25 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id h16so8190031edt.7
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 22:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rkmUKD4zE8vnW3hndEyuS8Cvauahdnys8FMcfYlDkUs=;
        b=vRkk2IgEDLtwRg/ld1xXF64VQKvgD+5K/c6iB2zyQGrw2SWVrzruO58S1u/6BzJGz1
         xcJMvmHo36kMkUPBvgaavcWC2nedBC9lW+nY3FfLr7TQA2JHFOQkjkVprLIuSbWFi1I5
         aYgKJM8GBxOuMT0ThJ1lBltxIXsSRTVDQa8j1REqQ83MaOUW001d88u57qqUIIIf5Rog
         4Yerk6fmw5D5QHtbf9s+WefkGrFPX/pylH9bb8He87UTUVqpP8TgYrgwcT9Rs9+ehHsg
         kTjWqyP8MOP8L2wOZCSYC0JV7FDo4yb6HI2A7fDFQSgypMUsKJrNieqaojLD2wwyIj1D
         nBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rkmUKD4zE8vnW3hndEyuS8Cvauahdnys8FMcfYlDkUs=;
        b=PC8ikucF8hccuOkdYelulhohL97G+UbSQXVAr5LhItJEEPt3c3ft53bEWE3zFfTNug
         dQ6wz/Vab3nm11ZpKFLF8L1bh2+0MJAV++KG/GN5LS1rfEAU4Dx493lRlMsk9lB7drhx
         1nRy8ppZWY2w9KPchAJe905ASV9m38sJrlyPoSamV8gGUL8b6yx71LjA4YK5N/rRdGUj
         AZpn1jN6j/BBCQRn37We0144+uZhlhbXCDhSQmy0aHU5wtdSt77r3/JXR06LfXssXzpK
         i3j+TH+D113fU3NXxf1fxqZPIgfk4Mw7tZ4LjjGfuwT402LRGUiKyHKaGkf9b4fGTnyn
         Wg5A==
X-Gm-Message-State: AOAM531fnuqzyNoLdgT+Tg/wicaeSSPqgOXu6Ua+HiKP48Qub/nnnafI
        yxc4VjfHG9Bkuj8hVf7NOLlPIGAWaISYo/blcQ5O1A==
X-Google-Smtp-Source: ABdhPJwTuLIA6Fr7s8l9v02utbihTcJB+ua+9gNvK7iwvnd1KbHm63wG+y7gkF7uqbtc3kLmsON9pSiuEb6bNf+3vnM=
X-Received: by 2002:aa7:d74d:: with SMTP id a13mr10437750eds.78.1607669123531;
 Thu, 10 Dec 2020 22:45:23 -0800 (PST)
MIME-Version: 1.0
References: <20201210164728.074574869@linuxfoundation.org>
In-Reply-To: <20201210164728.074574869@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Dec 2020 12:15:12 +0530
Message-ID: <CA+G9fYsKfYeL9-ofbNgevndXWAi65OvwgvebXauFOURaUM=2RA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/54] 5.4.83-rc2 review
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

On Thu, 10 Dec 2020 at 22:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.83 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Dec 2020 16:47:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.83-rc2.gz
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

kernel: 5.4.83-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: fc1de0dc4276cf610646922e65df5ad81151ac1e
git describe: v5.4.82-55-gfc1de0dc4276
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.82-55-gfc1de0dc4276

No regressions (compared to build v5.4.82)

No fixes (compared to build v5.4.82)

Ran 53098 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* kselftest
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* fwts
* kselftest-vsyscall-mode-native
* timesync-off

--=20
Linaro LKFT
https://lkft.linaro.org
