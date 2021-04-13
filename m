Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D52735D6C5
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 07:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhDMFG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 01:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhDMFG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 01:06:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A376C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 22:06:09 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l4so23800937ejc.10
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 22:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nQT+e00uOMZa4Gp1d8idLpzpBnrOSGlMexLl2GT5YkQ=;
        b=mmZ6tWyUE6GtDP2wEklqerIuSTy0Eoh1rJURKUXAi9MAz+7zu46AE1flnrRDXM7guS
         hnBgi6KdJ928LnbuqjI3znrGRx4iVnnCTpDHdy2cNMY3EKZDl4+cyZGd9oEkH1uI0ekl
         vcWIupmIWLEH0c9E64S9GHAi0v9gBt04edusnRWi5QHc1uYigwKgbZCUCFsSrXqzdHv0
         kzDQiqIpj2quHejxMqLOY55RDcPmeP0TkYfGE4Xx2k5aIqC8GI1k1tXGlwz8W6M0Uojn
         r1QSRmCSmxHDgXVAyXTD+Liy1m/1CoHgMQ65cFu/YmP/0xDEnDG/+T08RX8McURTsIs7
         FT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nQT+e00uOMZa4Gp1d8idLpzpBnrOSGlMexLl2GT5YkQ=;
        b=HmC5TqaX8CicH/6Wk/+dFrgCs6MivKwBT4lmLayowXUhrbyv4PiYSxLltxH5G7Xld7
         EkTaMAhnImij6uy3I31TmuHsFUjKTSo+CHXxXb1e76vTChvMgzH6cQDFqnhgf+Q0u5Jk
         JywgMWao14QMcHjoGhdcfd93lKlQ1zqw1JoWGW+AYgatYLN7YG+vkW2AJ4nj5oA2Mn8f
         A6aOW1DxkYSiTnIBLcH6EjCK5FmndJsl1mHR8+3MNWTbBzE0QUNKHnu3PDv2sYKPJ5Cx
         Cjq/oYvh2bb8ZAfCrHiKHS1YFXlQhW5wtyQHKwRFqWQEA7fgU3QeZBhssxlnBLc9X5QZ
         OgnA==
X-Gm-Message-State: AOAM530r2M+ZTRlnIHowNpzgQ3ejs+VvIVWhf7cwzZ4ReuPg2dXpfs+P
        S5hXKE+NHETy6rENScWmOM2C+YXI7XxmjQ8CRHnlyw==
X-Google-Smtp-Source: ABdhPJzDxtEA0zeoBj1DZ5SyhPseKGEvXkIV4jXNuuxvtmDp463DiGwvMB/bdeQx/BU4LMMaqpi2ikJd5h9etsJOouo=
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr30340196ejb.18.1618290367507;
 Mon, 12 Apr 2021 22:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210412084013.643370347@linuxfoundation.org>
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Apr 2021 10:35:56 +0530
Message-ID: <CA+G9fYu1y0pmKdVoA+_0ECzHvLxPGLAmA-GSVxwJM35UkR9sWQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
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

On Mon, 12 Apr 2021 at 14:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.30 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.30-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h



Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.30-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.10.y
* git commit: 8ac4b1deedaa507b5d0f46316e7f32004dd99cd1
* git describe: v5.10.29-189-g8ac4b1deedaa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.29-189-g8ac4b1deedaa

## No regressions (compared to v5.10.28-42-g18f507c37f33)

## No fixes (compared to v5.10.28-42-g18f507c37f33)

## Test result summary
 total: 75890, pass: 63301, fail: 2174, skip: 10129, xfail: 286,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 25 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 1 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-kexec
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
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
