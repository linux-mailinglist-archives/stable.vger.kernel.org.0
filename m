Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67948536C7C
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 13:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345439AbiE1LQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 07:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiE1LQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 07:16:48 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287706256
        for <stable@vger.kernel.org>; Sat, 28 May 2022 04:16:46 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id h75so5811798ybg.4
        for <stable@vger.kernel.org>; Sat, 28 May 2022 04:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aynPQhFd4QowP/synFgC+gJRCfVWqlJfAHAl/f5sodI=;
        b=RmvTGYmwT9R/iHk+HOhOiW+2kawtZE6T3ZcSq1jzJYlPlGT0V7QdVhvHvYXzuySdok
         aU039m620v6BnC4X7vxHaBmcAacbfWnqvPqaWRI0HfHqt7Tdg5HO6utrjOcY9txjlvNK
         h+3Gjut3EQU3Z9gLOsQnovevUVp0NaWMtc2DeSQIkKNN5uB7nk9ZqBwqLNqXB3LF0ikw
         VCBUPW/4dOwTT9l2654etavGqmuNptYg/fk0X/ERS5uDsJlw3HW0vxBEIbD3ZRCDBXTE
         ERCcAmF6tpJ/tO4uyeQvIt+tqAovtprHNQCFlnqO9CAAy8KYmofnjLa+GJ4y/j2jWWAp
         5GHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aynPQhFd4QowP/synFgC+gJRCfVWqlJfAHAl/f5sodI=;
        b=qQNtkQRO+6ctLMKp1T84R87POAJOyGXHqtWxSbuHoxQzp32vjaEtPaktHTFcl/29tw
         bc1qi66zSX/kNuG57r7azEg2+GUoiqr3HsfZx6DO1nMefliuYI5Ddetg8cWWc0kfogKh
         yB5o0cnmlqOJdWmEpyqm22dGbzvMFtyovKFUH5Xw3MdMQ3WRtSSIxLip+ER+LoE4q1+7
         dZDxEKRzLyei+x92VSiTLrUuCQU4JPPq1soPlNWAXYPGJ8VBAda7h+7kBaO10VC5UnEx
         rSItxWez213rHNO/eXmR/RvalIwnEqI4CJEOy4uusQeehyItAoNNER+CxXDAvSWEBHGs
         gaxQ==
X-Gm-Message-State: AOAM530CgOnXc61fb7TmB4jWNnSD5dxM6KabuGMyp/b1rJBc2/4efaFQ
        FiMQftAEvX73IQRMCh4ZOgTeSeKpH5lxOMvsvRRSKQ==
X-Google-Smtp-Source: ABdhPJyw4l9/bTxWtm1Wuv8umtQzikDlVVU4x7kzxAi/JfhnqiR9c0Ijml8+5GfV3R9b7Y5J26fTVQO1Y8K/xq1ZjeE=
X-Received: by 2002:a25:bb83:0:b0:653:ede9:90ae with SMTP id
 y3-20020a25bb83000000b00653ede990aemr20065902ybg.474.1653736605255; Sat, 28
 May 2022 04:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220527084801.223648383@linuxfoundation.org>
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 28 May 2022 16:46:34 +0530
Message-ID: <CA+G9fYuF15QF7dSkp8zdN=8AbBrhbj=skuSE5_k4uETtkBk6rA@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/47] 5.18.1-rc1 review
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

On Fri, 27 May 2022 at 14:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.1 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 May 2022 08:46:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.1-rc1.gz
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
* kernel: 5.18.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 10e6e3d47333297adf359541602af804d4a51482
* git describe: v5.18-48-g10e6e3d47333
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
-48-g10e6e3d47333/

## Test Regressions (compared to v5.18)
No test regressions found.

## Metric Regressions (compared to v5.18)
No metric regressions found.

## Test Fixes (compared to v5.18)
No test fixes found.

## Metric Fixes (compared to v5.18)
No metric fixes found.

## Test result summary
total: 100569, pass: 87698, fail: 1382, skip: 11489

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 44 total, 40 passed, 4 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 47 total, 46 passed, 1 failed

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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
