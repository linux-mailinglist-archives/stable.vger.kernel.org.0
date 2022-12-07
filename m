Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62F164591F
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 12:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLGLg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 06:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLGLg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 06:36:28 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4114A075
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 03:36:27 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id y15so15895711qtv.5
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 03:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACrrpZCC63dxQs3dwmnuOhX3jpkl+rhtIUueg16B60c=;
        b=R7DhKYXoMBmoXIE2USdSfijStsZn+SjRxz8nXj1QmUs0VVxxWTvfBuwyQRdquVeBq6
         xj0DVKefbm3hXLS/gJj6c39YeLQL2FaI1iIKtRzVJgGBpQ3WTcGEKXw+W9aS9mb515j3
         0byPM2iw1RrKLyy44NcK1vsgngqgzYFwDPVTNCmRxtE/DTwW3+JQz4tozszvUmuNJXbA
         udFT45Bxzf4v6AWRUBKGdWyiMZrxMERKyThNthoy50cHnE9tJg8Mz9BC1tqsP4BgzFUi
         PSiSH9pkmzEAVer9abuGfuhjQVo7bwe1O1gBCQ2U0zhbYlVoJVBjpPQ9MLo0A+EvRPLh
         nEXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ACrrpZCC63dxQs3dwmnuOhX3jpkl+rhtIUueg16B60c=;
        b=ZHWrSW01Q0jmU/d39y+FDPEs7eeQhqHzVedh/mmAysE3GJ3AqihNy6qeyi1AlXfnzz
         Rax1cOdEO6dxdQ3NYvrRXl/7mZFIWUQQV/PvNodCr3cMp8jeQ7J6t4WRlxLwIfGDY5Wo
         eNGkHUB3RbtpmMOLk0X6+NauaW+AevqTpDsAuzlh2wVtKBc39RfzD7m75UaIjxsgKraY
         YozlHG1UYF8C1ojO0kVE8g9K+7VjB4TL2Io3QhcdTTkPVrxZfXNJH3aGyUk2uZzxCrOM
         JOybrSH5ZtfOc5idaYKbpYJqisHwA1LgOURbQDBpw9uKYqQzvkgaaDsyePf6N2aPugBa
         sPAQ==
X-Gm-Message-State: ANoB5pk7gWoBXf4wejXib62MztyJ9HosEO1jdGMheTG9TCub1vmfg/re
        sIgj2E6H/EbWImX0Tiz2S/EbZl4aK7OgP0XJuVllQw==
X-Google-Smtp-Source: AA0mqf6umlUYAgAxSTXVHHj5Q/UJdxwYw5nZX0L03WMHtsdqo7ZewMO5+3T442xIDdrY5GCqcE/Ofy0SAskz9BE87+M=
X-Received: by 2002:ac8:148a:0:b0:399:a020:2aa with SMTP id
 l10-20020ac8148a000000b00399a02002aamr67293925qtj.247.1670412986460; Wed, 07
 Dec 2022 03:36:26 -0800 (PST)
MIME-Version: 1.0
References: <20221206124054.310184563@linuxfoundation.org>
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Dec 2022 17:06:15 +0530
Message-ID: <CA+G9fYswCWTCUXJsrK7DG7C94K9Nc=jMj2rAd3ciQTGwPY8DeQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Dec 2022 at 18:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.226-rc2.gz
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
* kernel: 5.4.226-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: b5f84e63b272111a94d1a192e10dc955ea27f0c2
* git describe: v5.4.225-158-gb5f84e63b272
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
25-158-gb5f84e63b272

## Test Regressions (compared to v5.4.225)

## Metric Regressions (compared to v5.4.225)

## Test Fixes (compared to v5.4.225)

## Metric Fixes (compared to v5.4.225)

## Test result summary
total: 54367, pass: 45525, fail: 979, skip: 7495, xfail: 368

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

## Test suites summary
* boot
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* kselftest-net-forwarding
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
