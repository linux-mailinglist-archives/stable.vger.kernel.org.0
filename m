Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3A7522B73
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 07:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbiEKFF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 01:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiEKFFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 01:05:55 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E2BE32
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:05:47 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2f7bb893309so7649197b3.12
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MhVaK2UMmz9aVyXD+hvkdzgYYQj9DazVB960P4H/k/M=;
        b=EK1SiBcFg0lrktvlSVACMwv+dzhRCqXcr1kKfIbjmAU6lYaxAHVFCszlBfMnJGpf6R
         IJ9j/UMXxhqPueTnnCT0d6ZxgtVBMKMf5QEzIc0ganzVf2dTVyd1MxV62OqcBNnQ5zgK
         aYBdcxBztPP9/7r67GfvgnfKgd9FPgPHXwLlTY82WBlubJT0CZbGar0e9ZPkIbk43DmE
         e+b17b+LKp2OqbzdVI1u6B0XooKoJ2vF3KI47Z3OtExasLHdyzZZ5cD/8d/Dz2MF2KbH
         1tlg/Mxd3jqO8tzr8bfpqKbDCsKGeBoOHD2HunSH3nfZzt7S+I9bM6m0bH4LIB5Z495n
         dngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MhVaK2UMmz9aVyXD+hvkdzgYYQj9DazVB960P4H/k/M=;
        b=cRxWZhe9MmWtpnLSc1/pWODAqKLBxPWBXzQRpzcyOWAWoIPv+sN0E6ljoPRcN8uqIO
         mfd2TGVzipJj5k9qoKdb94G8HZJ7pc1wD8d79P86bsCvkkXhAaOUY5ufq86sv02SLiSv
         5E8IVH7yV7VUrkM2MTi7u20/s6+qpyc5lVPpcI1gmDmSK5PNhViaF6Dzre3a3cRvxdYO
         Q1NvuDz28OlItARhxTP4rwzJ9Ydj5f2LVS4ur5fLzccZfR0t3Y/teNJJtGCn+54tA7Ek
         79NoAF3MtDPtzet8olR4OWtA6UIGN8hVdqt19RPfMYMzraJKEkVStXFl+YjKkZOi2bhC
         vaQw==
X-Gm-Message-State: AOAM531aglepLoDLA+h9avNvdYG1oxFsSii0rQD0p18X6VhfzMumeUVc
        9BXf64iexmdGtYBZ9ouAfgIgNEI3Z79E6Lv1CNQ/Zg==
X-Google-Smtp-Source: ABdhPJxL5ik9EhJBfFUa1gy8CFf8lhx9ZwjLe52HtqCUSsxxBlT/o+6hshHyZBIx9uOdJof5ZZGgAPYe9WWSJW5SqbE=
X-Received: by 2002:a81:3ac2:0:b0:2f7:f777:a43 with SMTP id
 h185-20020a813ac2000000b002f7f7770a43mr23498381ywa.60.1652245546597; Tue, 10
 May 2022 22:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130741.600270947@linuxfoundation.org>
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 May 2022 10:35:35 +0530
Message-ID: <CA+G9fYswcAEE=S45Pf6VpvX+riar9YYdaXz3in9sf1u7j+0AGA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 May 2022 at 19:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
I have reported kernel warning earlier [1],
[1] https://lore.kernel.org/all/CA+G9fYuBNB+iuVLFG4t-=3D5fsRsPdeXSSafkQECf3=
53VxikmW-w@mail.gmail.com/

## Build
* kernel: 5.17.7-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: 34d85184d6b8dbdd82e77eb732f79fb305520aed
* git describe: v5.17.5-366-g34d85184d6b8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.5-366-g34d85184d6b8

## Test Regressions (compared to v5.17.5-2-gb59a5f68feee)
No test regressions found.

## Metric Regressions (compared to v5.17.5-2-gb59a5f68feee)
No metric regressions found.

## Test Fixes (compared to v5.17.5-2-gb59a5f68feee)
No test fixes found.

## Metric Fixes (compared to v5.17.5-2-gb59a5f68feee)
No metric fixes found.

## Test result summary
total: 104884, pass: 88950, fail: 766, skip: 13958, xfail: 1210

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
