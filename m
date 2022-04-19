Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51F650640C
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 07:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiDSF5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 01:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiDSF5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 01:57:06 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E9F2AE3F
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 22:54:24 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2edbd522c21so160628587b3.13
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 22:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QJZmsK4vKYnU0w6RHfAyLK/7+Llp4RiGehU2CWjNg24=;
        b=MhTzfQVye+t/qRemYQqmjYRJKDjUqBOQvpJ+vm+DynqeTzQtpiuwhW+P5dAAMDerwc
         yIrlDwUlW/nRDgvYzWIInMqPergHzVYZQdmKnFGJsKI3FAUDP01ZDyxDmzzg9wj9r1F/
         giJtLil6yYyApXeiobxAlpVxEMxxA39fx3JpvvfvtQwQ5kGu2IP384WS/qM6/jr8qrVT
         gqHGp2r63JgLmMmbYJJh1dz1wNwD/B5LWtSUMnFFAkUi1ZQUhgD6RlyLkxK5LjAxucMA
         Af4C3ovEhpBv2ZiAdlqV2IiNw3ABnxuANJ058Lfva9MdbTGXlKhNHKYpIuJQKvjqtLUS
         7iaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QJZmsK4vKYnU0w6RHfAyLK/7+Llp4RiGehU2CWjNg24=;
        b=SydHsRUrV09RfUjayG5zVjMx2TLjlonVQtLsyPlrxYhCYHny6pozaNBXL4+9d0j1x1
         rw++gE6D/PHNMRcbnrYsENrAhU2df6H+0ydKdm3/W38vl79+NC2hRfbtsdOsIB2CKXNy
         oirSIguSRTZLW5W5iT6cd06Q/S1l6w2euKkCmv7AgwmhaAztaAJ+snukAnOoXGm99o72
         4O9eL3mqm78tA/k0GSO7cHOQIrIHZ+KPzzN6GFD3rVZ7xXsI5z+IdPWXPTloLEPe02qH
         2IGVbX5usfNcpsBPmnPGD3EIDnxz4Neilwhz6dgeTgfIleff3ESGn/wNusQMaWiR7j4P
         Onew==
X-Gm-Message-State: AOAM533wr3eTYYjKLH8jSW84a9VvEDEC1lrmQDeYF3U7XPyuWzbEmwDE
        3jIJCvECuFYmq5pq/BhPdxgIbLroZipXn63pMnXFIA==
X-Google-Smtp-Source: ABdhPJy4PYoWE5mXWwVzU7jxjccKuw/CPG7c2pCjoZKungtIdrvFAnfLBLVdpY0XGt6ytjqagPbRK37uqQJhRkCjzYk=
X-Received: by 2002:a0d:ffc3:0:b0:2eb:2327:3361 with SMTP id
 p186-20020a0dffc3000000b002eb23273361mr13779938ywf.36.1650347663981; Mon, 18
 Apr 2022 22:54:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220418121145.140991388@linuxfoundation.org>
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Apr 2022 11:24:12 +0530
Message-ID: <CA+G9fYt2yK_jPhhWVqj74SrwaJ+DQeW3adeoUAkuBw9M+7TtgQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/105] 5.10.112-rc1 review
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

On Mon, 18 Apr 2022 at 18:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.112 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.112-rc1.gz
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
* kernel: 5.10.112-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: d5c581fe77b5122ed284c7739724414ca5059b0e
* git describe: v5.10.111-106-gd5c581fe77b5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.111-106-gd5c581fe77b5

## Test Regressions (compared to v5.10.110-171-g6c8e5cb264df)
No test regressions found.

## Metric Regressions (compared to v5.10.110-171-g6c8e5cb264df)
No metric regressions found.

## Test Fixes (compared to v5.10.110-171-g6c8e5cb264df)
No metric fixes found.

## Metric Fixes (compared to v5.10.110-171-g6c8e5cb264df)
No metric fixes found.

## Test result summary
total: 95928, pass: 81529, fail: 646, skip: 13045, xfail: 708

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 296 passed, 0 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 44 total, 41 passed, 3 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 53 passed, 12 failed
* riscv: 32 total, 29 passed, 3 failed
* s390: 26 total, 26 passed, 0 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

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
