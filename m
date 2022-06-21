Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8215536E9
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353208AbiFUP4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 11:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353247AbiFUP4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 11:56:39 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DBB2FE51
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:54:34 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-317741c86fdso133605707b3.2
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 08:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g7DzGnPqhJYhmGX1M4tOZss3trUT8bJb1NJPEsm7I1c=;
        b=RVEZbC0Sl753wSBYDrWsS5Of6x5OKyXZHILZ5cD4whXkc5Hue6OwknrLNuMFxr9yjB
         cS2K5wPf7C5eklorQdt2O+DMCrRoVSWUESng4Ih/mAKlLIo2DTT18y/pd4KvDJePu77o
         iyEESwuqCh3td5jlRBnFDjrrgSdHbD5JhZFiHnC0WsaskX9tu4JVZbaLqXibiki5KDWX
         +ZB0RH3/b9HaqxJxhlbrIycxD2v4XuK8xci1uUMDZXEzMT/SeKPyrmaoUl6RfmD0Fl2H
         rkuYqA0uaGNUtal5r3GeMjSf9yuDftp3vJRTG5W/9jJDDnEed4fI2qlyAKlFVVYHIZ0y
         /hdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g7DzGnPqhJYhmGX1M4tOZss3trUT8bJb1NJPEsm7I1c=;
        b=1xVPw8LEYoLzSCDZFpHXdXLBBuK51vPI82PmdDkIYB8AxFbCX+K2plpt/asTqva1C+
         hiJJDi1WCPcltdJA85eUFXr3w/3L0vYU7pGjaqtyDtoHFq3DMExKjmdEEAB8qALBSIfJ
         3a9cKRoNHmZ6I321t0ofjwVv960ZnPjUixeg88sCaTLOy1UnG3d9wo+IsQ9N/jo9NHak
         kmhKdh+ohn/XlzGneh3xNFayOxyx4NjKQg4w5BKpsxaaKpKL6bdRmpn+eP8/5cOLhxVa
         oJquSZDYCXt87euATyrPNq4ub26K107UgVEQR5VnvdGoItMzJUvfMbElC5eJXlj66ZwH
         3MNw==
X-Gm-Message-State: AJIora+j4t7gwS9pJguFQD9aeieiLX/RUsicR27pPRp8HsHzFJAgKcpD
        dYiu3wgzbimh63lsonqnMphqPi5q7oZr+agb7fdpQw==
X-Google-Smtp-Source: AGRyM1vA9lQAbhS/dLGCcClr8Q4Iou7B67Euo0I/l3wmSat0GaH4PfDeAmvH+hYuiqo9od7R4apuK2bqiVaTyrLAuus=
X-Received: by 2002:a0d:f242:0:b0:317:be2a:83df with SMTP id
 b63-20020a0df242000000b00317be2a83dfmr14415190ywf.376.1655826873550; Tue, 21
 Jun 2022 08:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220620124729.509745706@linuxfoundation.org>
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jun 2022 21:24:22 +0530
Message-ID: <CA+G9fYu3qaDOOShLx3gvWuRi0z4i31UvNNQXYjSnhhZ8RT3-GA@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
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

On Mon, 20 Jun 2022 at 18:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.6-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 1cf3647a86ad5204a01c7495a62a13d07f02d51c
* git describe: v5.18.5-142-g1cf3647a86ad
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.5-142-g1cf3647a86ad

## Test Regressions (compared to v5.18-48-g10e6e3d47333)
No test regressions found.

## Metric Regressions (compared to v5.18-48-g10e6e3d47333)
No metric regressions found.

## Test Fixes (compared to v5.18-48-g10e6e3d47333)
No test fixes found.

## Metric Fixes (compared to v5.18-48-g10e6e3d47333)
No metric fixes found.

## Test result summary
total: 123299, pass: 111561, fail: 547, skip: 10306, xfail: 885

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 319 total, 316 passed, 3 failed
* arm64: 64 total, 62 passed, 2 failed
* i386: 57 total, 50 passed, 7 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 23 total, 20 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 62 total, 58 passed, 4 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-zram
* kunit
* kunit/15
* kunit/261
* kunit/3
* kunit/427
* kunit/90
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
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
