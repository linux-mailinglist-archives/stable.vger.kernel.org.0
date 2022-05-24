Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800825320A2
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 04:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiEXCDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 22:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiEXCDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 22:03:50 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21651814B3
        for <stable@vger.kernel.org>; Mon, 23 May 2022 19:03:49 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id o80so28571077ybg.1
        for <stable@vger.kernel.org>; Mon, 23 May 2022 19:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TaVPaezuXUUrJn/l8xmCpgZkWa6d5zHyRlmrXLhO/ck=;
        b=uIzHBbGmscqYkk5YohOM8OsjUsXU8fDOwAUtDVPHA75xpn1q6C3X2uZ488g+tzU7zw
         jVGPPboOxNeROw31pFhfbwxrc3Hw1JRhkvzrvpNBgRt6tOzuixn6zDxKmgKNUuv0wVKC
         N1LmkUIMPO04+Ji/RnvHBypLFs00fUferBOBIMmVHJAIedsN4WFvzaSV6A73nbU92fnZ
         KVx3egFCMlWJHy0PLiaMRRhz/zxq9NgD/Ic0G2Gu/vujlyOTcwJwlWaDeJP4jY/OmmeC
         vlctrc4fY60S78dMlfRUn61/Wjl84AQxoTGEBHs4lc9Z9/ZogxzhAF0Pwp7PoLBW+RDA
         mL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TaVPaezuXUUrJn/l8xmCpgZkWa6d5zHyRlmrXLhO/ck=;
        b=Vgw5PTgbfB6yMWz5VLJ31Gofiz7LE+PkINWd/+CVtbCNpn18eYVvgUs+QiElMRJNTw
         zo5b9swI0O+imTCYPhMSia/l7VeJ99HOIT58j70zWnTnJud3oWbiwxpDB99QW6m+Y76D
         YUezEi+DAa9XxsL6eO0quSMYxq8gytvgEngjBl2VzcKuhrSml6GI+r5sxT5Y3jJfkuxr
         t1w9BLYFw/tFRwmLUwNulijlvA1XbSZwG/L9wqxZ9N8saQJaoKNHjZ/Vt22sYE5Uagur
         5m/1YUkh9cfj1SDrd9mLQvtCroC13BGXKTrsDEgypO/jFBH4yEGdOKAGF2jNi0x8/+wv
         1ucw==
X-Gm-Message-State: AOAM532SsLstQf4HfKf44VrBdWV8kuKqgv1LJVFZXsJnoho14T5TuPgR
        poNHe/K06D//DeEpDlecjMLPU5wy62H73RHjLP2qbA==
X-Google-Smtp-Source: ABdhPJxvU6BMoSSQay1UgirokJ2A1InFgZ6SALJbt1MZYS+enKWNWgg8+Fs8vfal1/J9ful/7aNSZi7MHchdhXspUWY=
X-Received: by 2002:a25:814a:0:b0:64f:f06c:cf6d with SMTP id
 j10-20020a25814a000000b0064ff06ccf6dmr6315456ybm.88.1653357828191; Mon, 23
 May 2022 19:03:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165830.581652127@linuxfoundation.org>
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 May 2022 07:33:36 +0530
Message-ID: <CA+G9fYvc+fogFhRpy4r04A6ch4t58S3i8BnPdz5oCj_yuOf86A@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/158] 5.17.10-rc1 review
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

On Mon, 23 May 2022 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.10 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.10-rc1.gz
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

## Build
* kernel: 5.17.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: 389f9b0047fd0c936414cad5400875652b2711ef
* git describe: v5.17.9-159-g389f9b0047fd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.9-159-g389f9b0047fd

## Test Regressions (compared to v5.17.8-115-g3f3287e39741)
No test regressions found.

## Metric Regressions (compared to v5.17.8-115-g3f3287e39741)
No metric regressions found.

## Test Fixes (compared to v5.17.8-115-g3f3287e39741)
No test fixes found.

## Metric Fixes (compared to v5.17.8-115-g3f3287e39741)
No metric fixes found.

## Test result summary
total: 102240, pass: 86820, fail: 722, skip: 13738, xfail: 960

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
