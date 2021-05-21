Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7E638BDBB
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 07:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhEUFJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 01:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239384AbhEUFJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 01:09:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDA9C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:08:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lz27so28605227ejb.11
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wcL2zERN8tGWMzDUDJGSV7xck7rOdmcSxv4uw0QgULY=;
        b=oB6zwNfe3OE3SJcJ4TBVcb34PoQGBTFt0sd98nCU+uVHRmcEpF//Pm5xnGI0tXSfCS
         /80qS2/mYmUVB6kXxygWMJVx4T/p2EgGSARC6Vhkr3pXOZhaeGW1AY0VQd5rHniItve5
         nD4I9Ysz+iFWACyJh2L6b5jahM6/rOEz/P7k8VETY97ul+n3mm1HArgpGTdU+xX0ACtC
         ZR8FnDZHmhzhAS3fAQXNth2MsgnSrOqyx1vrWZjI3u7F4G+6CKWQlF9KHuR9bV0/WVj+
         YADwq6rtB1Xucfh/MBe+Ynu5wgFJFuHNz0ZcVdCsz9Wmt3yGaAD9Yfn85iZemSI/5jib
         Gekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wcL2zERN8tGWMzDUDJGSV7xck7rOdmcSxv4uw0QgULY=;
        b=C/2Ry27X8pG66xyYwpJAP2gYEyv6f0bbsCuWHsCQ0ob8h4YEbwE9PQ5+e0FNw6eUFm
         LxtM8F2zSXyLrT/sdmrgszDmJGn0R9U0R82fAagKbj4UUz6IPLz+sOv1gGlyvKNGfkAh
         9n+fQO/gtFwnT/y7I8VqMm5fW3j/CLgz7DLkLasXGUkNnZYYz4carJ9pRcxUwhknomjY
         Wc9Ug1TvOuHBztPPL448jyzmJnzG0ExT+sea2USrqxL/Svh6ZYkcZnWFKCQgMqvzd9+Z
         yI7groHcg2a252TBnLBFcrJKOQD9I21oxoZHXE2t9tsXnLz80E1NcA5ZT4T5mb6HoI+Q
         jNEA==
X-Gm-Message-State: AOAM531BNPPS0nKt9Nu8Eb2zGH5+l32igSfEHl9j3/yt60ySm3MlAtfN
        tREp1VUcit0aEbx8Ba8g0UFbCX3P6h45/GqciHoM+A==
X-Google-Smtp-Source: ABdhPJxCC9P62cbJBI32to41/EZ3fyxk1WOsfbAC/srj+y+t5/HfQWHxPidlHSTsk6fia8EWpkQM5Tywo4ejGJ0hUEw=
X-Received: by 2002:a17:907:37b:: with SMTP id rs27mr8669826ejb.287.1621573713465;
 Thu, 20 May 2021 22:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210520152240.517446848@linuxfoundation.org>
In-Reply-To: <20210520152240.517446848@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 May 2021 10:38:22 +0530
Message-ID: <CA+G9fYvg7MLGLX2koUv4uemL4WCoomQKixBVj45st7841ToeNw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/45] 5.10.39-rc2 review
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

On Thu, 20 May 2021 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 May 2021 15:22:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.39-rc2.gz
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
* kernel: 5.10.39-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 4313768a0a3ef0847c2ca31ca95acbe4727fba10
* git describe: v5.10.38-46-g4313768a0a3e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.38-46-g4313768a0a3e

## No regressions (compared to v5.10.38-48-ge244ebb2de00)

## No fixes (compared to v5.10.38-48-ge244ebb2de00)

## Test result summary
 total: 78427, pass: 64145, fail: 2569, skip: 11054, xfail: 659,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
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
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
