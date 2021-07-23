Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA243D3AAA
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhGWMNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 08:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbhGWMNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 08:13:39 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995D1C061757
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 05:54:12 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id a19so1694660oiw.6
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vQVC7Jc8Kgn31TrRkrJGP5tkGusHcyIDihMXoOn9Mu4=;
        b=Ui5rt3XoWydvgfhOnGdtzS8HA5EfM77uc1aizfDu1vkEVRPlFVHP/4va2lPuS5Skov
         wIQ6NIPSSRSe24aJJw5C6vz9ep5cp+FC+mhora0NpgteXo6G7JkALJeVhxWF07NGD2hU
         /qU0cUY3mwRFkHoMgdJRy4OgFTM5b+ZXD/Rowh+wryaHyRb4wyiTwUXzz3VXeoS/z3L/
         rUZY2MDa/Ap5ALn6g4m6HHG+jFvYphtDzxG+Hq+4fr3pOGVPcQ0XMWj2iWd9JYVYLa48
         2HAM748x+EzvRQ45bkJ8F/plRswTN2LU+VVBwKnnZN0RPvGApVTDQxaHPLgO3S4gBpm0
         Ghxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vQVC7Jc8Kgn31TrRkrJGP5tkGusHcyIDihMXoOn9Mu4=;
        b=CwTVwraSgLborq1WS4SvaEQdt1SLCtF78CKXJsxYkqHuhr9uUEMWcSuNlJA8eVseQI
         M3EJyvA0aR8eSjhaV53QfRWNHfmM9HgWCKq/O6Pk05DswNW6rQ2J+Eu45Kda6KAACReZ
         B/TYMeI9WYAB3z0+WQO9t4zJNUpUhNvP7LTcPV2B13+rchT1wsgoxTbvz34WA5XydSX/
         RttMT3ZI0ucUYFvR/A9H+pJxDBy6N3RstnsoALBwi3VolbyTHWvFoF9edVJ7C6X+W4YN
         p06mEheEGSJD4V/p4CRyK9KPfJokegVTRq0aVDv7IXcQMl/K0sWKD319KjZrxiuZPyE3
         VAMg==
X-Gm-Message-State: AOAM531x/MsTwo0GfQsXts8MtXOOdegtaBhPrIdhuWK2fR9JO6d4eDAz
        40jvijTqQs0zEfxcR2q0dC/GN/pKLyK1iYJDVW8JNw==
X-Google-Smtp-Source: ABdhPJy5G64MSkCXL6pd+oFXu0Tvai4ZPNlLJTPNCb5wG+3S3XTXSidfpywJphOOFpwt6xI61anAo33sG48ESQgmfFY=
X-Received: by 2002:aca:abd4:: with SMTP id u203mr2984289oie.13.1627044851764;
 Fri, 23 Jul 2021 05:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210722155617.865866034@linuxfoundation.org>
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Jul 2021 18:24:00 +0530
Message-ID: <CA+G9fYtN0ReCw4RWzDVbS0rRMADXMO4xFdX1uLiiSEiQUM6odQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/71] 5.4.135-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Jul 2021 at 22:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.135 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.135-rc1.gz
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

## Build
* kernel: 5.4.135-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: dcc7e2dee7e982554072d1e726ada8872dd7a27e
* git describe: v5.4.133-221-gdcc7e2dee7e9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
33-221-gdcc7e2dee7e9

## No regressions (compared to v5.4.133-149-g0274752daa49)

## No fixes (compared to v5.4.133-149-g0274752daa49)

## Test result summary
 total: 73381, pass: 60421, fail: 446, skip: 10938, xfail: 1576,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
