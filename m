Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F0E5328D5
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 13:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbiEXLXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 07:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbiEXLXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 07:23:31 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935A77A44A
        for <stable@vger.kernel.org>; Tue, 24 May 2022 04:23:29 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id w18so1286175ybi.12
        for <stable@vger.kernel.org>; Tue, 24 May 2022 04:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u4jkgddlBr3J9ubsDMtzmtFV4psU8nzYoRhT/4FQDVo=;
        b=CxMAVJZhM5HFyDKuKe8HrCXnG/Oml/x91Z9qYGQBXxIQ1VG3Xf0RAVCdgBGTIWohQq
         TYZcx0EyTcu+DPz9gO74MalLDMP1mN0e9OilfwnhRQP9lvvSNK21QnCcEeQTqKoJuiQ0
         Br5BUiihNSVM0fVJ3Acjk6yTHKXFdCL12nRl99X8SOqZd88TAchqxI6d7F2o7JbUnm4U
         4vjchNAEpjGh1DweQNIy4O0x065rL5pUYPHM4YwAZRYBfhnsR/p1MwwiW91ajj7/uik4
         ssr6KBz/jEq3RepWcK1NwW83MsGpREPxcxr0b7dZDMrdTcptmsKCEH3/hlnJoZrkVT+2
         knlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u4jkgddlBr3J9ubsDMtzmtFV4psU8nzYoRhT/4FQDVo=;
        b=EUbCV5SGNaEsmcBMegMdmOPuoc7WrXeAMVN/10et05nJeIYyMdMVtQ0cqXK+w3BpFI
         WDEIdOWme4e/DYXL7dMmdFWLqx8+DpP4D/tKoi9ZfnzW3gllKq63s5owdZz2CqPirQQ0
         QuAlg7gYV0JkiMAdDZOu/DXd2ie3accT8ND99OX8BpofhTGvvAGvDkEw0Z3zHS5gvt+C
         RBDnnKBL/pBfG4MgvvIMbK8vXgB29YM9FqCWs0R935hE1I2UvswCU5cko+PKgoLG+v9y
         PQqVEElStHyVgQUNWYax4zZfUOj+Vu1JFJCukbtb/kjD6ahe3aXfdxsurbTvyaSDgaZp
         M0Yw==
X-Gm-Message-State: AOAM533++td/7q2aFKD7haW9u8Mzknoi1cdnwcxbkn5x9cY9+Ax1z1ec
        vIJIvnqhwjPxkLmwPhIkWf+0+d17FnXlhL3ceYYByw==
X-Google-Smtp-Source: ABdhPJwU2wZ7cSYyDNwd5odPJUiqg9Us5uBOjH9/ZHsHvhL41SzoLGbf8RdvF4O9x9vy/Oc/p6M9vsRxDBiiy3XXBI4=
X-Received: by 2002:a25:814a:0:b0:64f:f06c:cf6d with SMTP id
 j10-20020a25814a000000b0064ff06ccf6dmr7522343ybm.88.1653391408633; Tue, 24
 May 2022 04:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165802.500642349@linuxfoundation.org>
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 May 2022 16:53:17 +0530
Message-ID: <CA+G9fYvkWXyc=b3vgN-SEBkMuWd2pj7u45CqW1tfNzvfeMj-4g@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/68] 5.4.196-rc1 review
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

On Mon, 23 May 2022 at 22:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.196 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.196-rc1.gz
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
* kernel: 5.4.196-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: e9366e2c155ad1cd8fb6e1368bec57174ce80027
* git describe: v5.4.195-69-ge9366e2c155a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
95-69-ge9366e2c155a

## Test Regressions (compared to v5.4.194-43-g71ab15716d94)
No test regressions found.

## Metric Regressions (compared to v5.4.194-43-g71ab15716d94)
No metric regressions found.

## Test Fixes (compared to v5.4.194-43-g71ab15716d94)
No test fixes found.

## Metric Fixes (compared to v5.4.194-43-g71ab15716d94)
No metric fixes found.

## Test result summary
total: 86725, pass: 72314, fail: 836, skip: 12392, xfail: 1183

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* log-parser-boot
* log-parser-test
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
