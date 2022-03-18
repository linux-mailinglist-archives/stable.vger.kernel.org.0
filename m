Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A924DD7B3
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 11:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiCRKLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 06:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbiCRKLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 06:11:06 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69621FC9F2
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 03:09:42 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id u3so15002668ybh.5
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 03:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NIpO0R5PRAeVuh1zzBEmKXUAPVQ5qDRVpdUzBhUkCTI=;
        b=w7BIya5WEDSwPeBOsjVGM/Csb3PjJzkR7pXIQjfw7UiO+O36XyvHRF6ZJ7GNN5/fzW
         6v9y23PVvpZDBwcyqFfpPX7xvsE5whVjPM2GUqyT4q80S06JHOGIeYZS5glGL834Uiox
         toS4CEpFLMNiIS8Y//k4BxfnP058ntw5ecgGhWq+307bBxB7KDhn+u8rEGCEn4v5yKoH
         ygNPs3oQ8C+pxGpIdf6RA9hS81zlt3pt5p1yuq5nB7XCFz2GA7e2eUz3oKbpRgHoI5xr
         8mbecvdqAs5JR/fTw1ru1Ysh4nNtnCYLLUwAuPTdYqr+LXhLwUPVYU6+K8cwzH7NBnZg
         KjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NIpO0R5PRAeVuh1zzBEmKXUAPVQ5qDRVpdUzBhUkCTI=;
        b=qX8F63I8leHnUJAjyBZvs+QsCyvPJ/7U8nN5IOy1XQvEiTIVb7FZ7i1Vwryc2rdCK+
         T/30cH8Fx45+MP4Dl4tper1WrxoM6J2t6hHavjk7sY7aIQ8lOtopCvLUOKNr97PDw3pT
         4kUVAm7PMDw4OcPQ3Xeas+SC6G9UGS+yhklPvbLvKk9W2EXnSGd6yOpSMAJSbwoj+EVu
         Wvu6EYhBqM3c4Ru9oJ5ijVgSs1jV9g2SnlOg1F0KFc64IV7zL1rH2w/9Is0iUv8h8m/8
         mWWnNF5+Hm4cZW2IQ33en9cvsF/c5RZNJTnQiodQxdWgo0HOWMxFnd5cchxJsSPCHkcW
         3zAA==
X-Gm-Message-State: AOAM531l7eJRVA15acaKQDpkd03MIQdou5+o7AI8pcqKP5QBl3TkYD2T
        fl2yiFAlBYeVtzHvhe1/cTDNQJJ2NzeDHkoV3bU8oA==
X-Google-Smtp-Source: ABdhPJwe8xwBh4lFScZsYlo9VjOLVO5x+Htrr1j/Qq6RSzVexvlxxA5o931S9YQ/hmcX31jmVGuEj9cSQF5lGDDT2IQ=
X-Received: by 2002:a25:9909:0:b0:624:57e:d919 with SMTP id
 z9-20020a259909000000b00624057ed919mr9685782ybn.494.1647598181985; Fri, 18
 Mar 2022 03:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220317124525.955110315@linuxfoundation.org>
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 18 Mar 2022 15:39:30 +0530
Message-ID: <CA+G9fYukO7H8pJShdNZvX=TDf9iAyP8no4kyCcNMz6AwjaX7sQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/23] 5.10.107-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Mar 2022 at 18:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.107 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.107-rc1.gz
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
* kernel: 5.10.107-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 0bacaadb448bb6e89b0d77369d3b7b7c09d8a776
* git describe: v5.10.106-24-g0bacaadb448b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.106-24-g0bacaadb448b

## Test Regressions (compared to v5.10.106)
No test regressions found.

## Metric Regressions (compared to v5.10.106)
No metric regressions found.

## Test Fixes (compared to v5.10.106)
No test fixes found.

## Metric Fixes (compared to v5.10.106)
No metric fixes found.

## Test result summary
total: 99319, pass: 84014, fail: 873, skip: 13372, xfail: 1060

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 46 passed, 14 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
