Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11884E7F2F
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 06:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiCZFve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 01:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiCZFvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 01:51:33 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8DA207A34
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 22:49:57 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e203so8581263ybc.12
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 22:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m5y3dmyCTMeUhyJ/TUJk+2Wdo01Owyg3EMB2TMG5W38=;
        b=jsCGRS4GHxbFStvzfyR35DZR8Tk7le7FgAzWmsifTGmCjytiWtBh0VyiuJ6NBqSpTS
         hcRo+EARXYJ/4Swc43a+c1W6QyPIpXxzFg3hg9IqfavFN18d+snqmUgJkbfYYJDXbUN2
         YMsf9dczwLfmjVEX5BqKoM8UVnzLz2NaFoGplfZxxdJZN1USUFbyoexZkqDkOv6tPgGy
         UjADIdXY5wN7XQsByN0yvEVz5dpeEuOc4voWsskTWQdkJBxkK3KOdGfnPNA2VGqFsthN
         EXnzFGssJ6JJmjE5UpVWio/d3fBuCN4UaCetpiIjtoZf9+ifzJow7yIB+ASXk2RhV6Lx
         O6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m5y3dmyCTMeUhyJ/TUJk+2Wdo01Owyg3EMB2TMG5W38=;
        b=5chbUmuUG/BlMUaXBsdZhOxpJ5Dw9Rr+uicaz/OuIBzy8sNonP1RntoZhiKP3k499w
         AV0BsbEeECE27dFyCL6ZguI7I7+Nbp8GtUtHSKjTSfDX0INP4u+QDrQZ1F9c01CeAHLT
         gx+WyO56BISYEXGz1gu+slMohP+hxpHuhnrmt0HH+V0zrKr89xMafhM+CNP2C4IJnRoa
         lzN8xonp1SKmIOoaJEqL9okz5ktdwaPlpjRTXpgLqPSF2erzJj/A/yBe40n59mRsi+rN
         qDqhrVfQ5fy6YA6+KFJB5omJhXcjFcsDzN0H2sPkvWnkoIpmvDZ7DTo6zqki3ouawsWN
         oI+A==
X-Gm-Message-State: AOAM531UdMusQ3KO2ElgaEgy0lHPExoBQz5r8G5ZuRZtby7sVB8SGIZO
        +vBb2C7gzI97+js1jV5Fy0VS2S0/bjP4V0mQ9We03A==
X-Google-Smtp-Source: ABdhPJyT0L7N7Pgui08NCvn9g/BZXr/pN0RW4c9VcoTCj9GkBmwYh3ubWlz+jo9sPUsFey+qfN5Rl/3lDhG0oeSLYOM=
X-Received: by 2002:a25:2409:0:b0:634:15f4:2240 with SMTP id
 k9-20020a252409000000b0063415f42240mr13187835ybk.88.1648273796125; Fri, 25
 Mar 2022 22:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150420.046488912@linuxfoundation.org>
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 11:19:45 +0530
Message-ID: <CA+G9fYuNg3=ig3A5J0oOojC4ywtf_yUeyMoPwYrFBGvzeexWZA@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/37] 5.16.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 at 20:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.18 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.18-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: f6cd6b12e190ef5b92d82a341e76d8a9cd7cd284
* git describe: v5.16.17-38-gf6cd6b12e190
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.17-38-gf6cd6b12e190

## Test Regressions (compared to v5.16.17)
No test regressions found.

## Metric Regressions (compared to v5.16.17)
No metric regressions found.

## Test Fixes (compared to v5.16.17)
No test fixes found.

## Metric Fixes (compared to v5.16.17)
No metric fixes found.

## Test result summary
total: 104880, pass: 88707, fail: 1055, skip: 13919, xfail: 1199

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 293 total, 293 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 42 total, 42 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 43 total, 43 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
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
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* timesync-off
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
