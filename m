Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612054E3C7F
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiCVKfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiCVKfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:35:15 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205682E9C8
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:33:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y142so32748736ybe.11
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bNY2UQZod2nnxVhfUvO5tJXoNrHZT74omp5G4ES+KU0=;
        b=j4Gh4jgkyTa4NvMUlU2SUGJJiLlsnBgk4ahuE03kgGCe+UCvC1bXj8R+M2KgyU+b1Y
         xq9MxgD3guYxGnH6jHh5gPqIJrrb0ADOvor17+CoLiE+7cH9X9/x4S3xYb1VlWGQlChE
         QMDW0/J1EK/QKrztmWhSMBylmO9I1TlWkOrDu46y2Aa3YS0tAN+BriV3tm8qdEniFi6h
         YsQCbCXrnL/Mpmsrkgy9LKTFsbn2aGpwNFKJDCV3TQkLoIC6uXfxCh+m0Lhcx8MUSdPh
         vBmI5QjtY0NYj0q1u8n/ulOnQi4bOfqYKbBWvwrFUwm71lC7hTg/onlf1hl4azGIoYzg
         ywDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bNY2UQZod2nnxVhfUvO5tJXoNrHZT74omp5G4ES+KU0=;
        b=7htkN/hXE1X6JYZtAtV3uMLXm5MKKOelvHjCAUtNq/m2XkYLQv8ILMFk2DtzHccTBQ
         ThYzW3OpF6nooXvnEJhkF1C3yKbD922NEi2zyqiHTLzKUBOwNlrm55M9zSzR9IyrDFWy
         gXoAQQReYKAFslyoTYW8C3lWN7HbhZW5hoaCoXJ4TcsUySUu74jbIMVp/W3vXzGTO7Q+
         OvMrzOjwNZ3j7RPTXmuTadrlgTLU9uuOl2Aq4LXp4mO+4XnbOxHJ6eoDUFjPJAu2QGou
         7gyuL+3WLvvM9XQaoGzZ+oHHSUa3OAuJtHdriRBLVOJtgckU5wSN+Jlezrj623f8yveE
         JAiw==
X-Gm-Message-State: AOAM530TUiy3DaJeo1GOFRz7joSK8fLSbrucVNsmVXYUnlpIQg6Vs1p+
        8kALUQxg8AuodnoY+E7W3Z5dIuTSr0UbuvSfEao4gw==
X-Google-Smtp-Source: ABdhPJzHiIqG62kfHI4tbunA7kcIVgoi6jXymVz0Khq50ZzJk0GOEzlFAfQ5auhRc/Ln9FnxcrrIeop9dpkz1VskgrI=
X-Received: by 2002:a25:a0c5:0:b0:633:63da:5ead with SMTP id
 i5-20020a25a0c5000000b0063363da5eadmr26903869ybm.412.1647945227227; Tue, 22
 Mar 2022 03:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220321133219.643490199@linuxfoundation.org>
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Mar 2022 16:03:35 +0530
Message-ID: <CA+G9fYt6ur-zw0=bWMoFE==T-N6+iLXs9XUV4GkW519Cxwp4Qg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/30] 5.10.108-rc1 review
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

On Mon, 21 Mar 2022 at 19:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.108 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.108-rc1.gz
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
* kernel: 5.10.108-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 9d7b0ced5647e0df1b200ee29119cb58ff958339
* git describe: v5.10.107-31-g9d7b0ced5647
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.107-31-g9d7b0ced5647

## Test Regressions (compared to v5.10.105)
No test regressions found.

## Metric Regressions (compared to v5.10.105)
No metric regressions found.

## Test Fixes (compared to v5.10.105)
No test fixes found.

## Metric Fixes (compared to v5.10.105)
No metric fixes found.

## Test result summary
total: 99479, pass: 84962, fail: 805, skip: 12837, xfail: 875

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 296 passed, 0 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 42 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 47 passed, 18 failed
* riscv: 32 total, 29 passed, 3 failed
* s390: 26 total, 26 passed, 0 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-time[
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
