Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DC05B84E2
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiINJXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiINJXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:23:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DB77AC2A
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 02:13:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a41so9406786edf.4
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 02:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=RHEDsrlxShrh7zHYIRwxWCYxPujfLW+vY6ddPLI+O08=;
        b=ylZtMhybLAFnr9CLxoXAALJomzPRGWH6Tl5UH6zYmKkFM6vVE0dPz804ww4WAsXGM7
         2ESOED7xp7mVz3vcZgJEP/bUE3uH75NeuH0wpipvt7ZaMa+xmNouttnjROmvB6j1PNwU
         vwO5Ax5Vsugsirk6wcZbiIqxsLSLlajueFeUQCHMDXmjmNkb++sIzlkeDieSw4jj588g
         Ma17pnS/7hCfe4HK14VmBHnmd0fH3trhf0MCSFz/7H5xo1idrn7lnx9uftjOJcFeAXD6
         Atr72a41iJwAe1RP5y+zGt0eX4Z5X0NdRWS937QpjUln1ECe8+xt7EH0YjigRs3g4txN
         SBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=RHEDsrlxShrh7zHYIRwxWCYxPujfLW+vY6ddPLI+O08=;
        b=UBPbU7plzogAjkL2H5d1w8vC5WaVLZ4qzcTsez0KiJm9AIb618Cj7C5ipALcrg6tIW
         L37OSAl6Ea3y5Rli46kkHoJwU1uAMaV/H1a8/SnPvqH2K4ZppClryOo57hWuJfz/E+4D
         jqBzkv8QCwNyxe+tgmxVq8Knzg2MJg0R0qzVkuh5fyrHg8RaC07jeuSsPheHqSZImgJm
         bHsp+kS7EM05ZtSVja/F6u70hbRAtfLnawlH513r8rnAhMyR282fzmmZvAq/rjKJCxjF
         kJvJLih+MWGrup9UQSPBAAHOL6BVpbHWISRaFst8sCuCNiVggDhsGlyfqYN/4DSc0Zq6
         u6yQ==
X-Gm-Message-State: ACgBeo0oZu15RodCDPPvyr7IHTExexQvwQUKwV/4SmcHXGv/xt2T1Gms
        vXWAiKSoy4KqSYTcwSSvg+qyyrTUnMVL/N0GPcBqLw==
X-Google-Smtp-Source: AA6agR6bXyIwGGxz+ub3ZwwhgT5zuHZFKdGZZSM4YfTF7fyYM066w+a3wpDI5fJNpTsOdwYxR5FTi6afjxayNO16owU=
X-Received: by 2002:aa7:cb87:0:b0:43b:e650:6036 with SMTP id
 r7-20020aa7cb87000000b0043be6506036mr30230697edt.350.1663146737437; Wed, 14
 Sep 2022 02:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220913140410.043243217@linuxfoundation.org>
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Sep 2022 14:42:05 +0530
Message-ID: <CA+G9fYvWbO+x9rPjhgL5XPmQqk8z=5yqutg7qgwP-+iqLAccqQ@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Sept 2022 at 19:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.9 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following Warning noticed on bcm2711-rpi-4-b while running LTP fs iogen01 tests
and this kernel built with 64k Page size with NFS mounted file system.
   - CONFIG_ARM64_64K_PAGES=y

This warning is not always reproducible.

[ 1152.014544] ------------[ cut here ]------------
[ 1152.019249] WARNING: CPU: 3 PID: 56 at net/sunrpc/clnt.c:2521
call_decode+0x210/0x240
[ 1152.027211] Modules linked in: algif_hash aes_neon_bs aes_neon_blk
xhci_pci xhci_pci_renesas snd_soc_hdmi_codec raspberrypi_cpufreq
hci_uart brcmfmac btqca brcmutil btbcm bluetooth cfg80211 vc4
raspberrypi_hwmon rfkill cec reset_raspberrypi clk_raspberrypi
bcm2711_thermal iproc_rng200 rng_core drm_display_helper i2c_bcm2835
drm_cma_helper pwm_bcm2835 drm_kms_helper pcie_brcmstb crct10dif_ce
fuse drm
[ 1152.063204] CPU: 3 PID: 56 Comm: kworker/u8:3 Not tainted 5.19.9-rc1 #1
[ 1152.069920] Hardware name: Raspberry Pi 4 Model B (DT)
[ 1152.075131] Workqueue: rpciod rpc_async_schedule
[ 1152.079826] pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 1152.086894] pc : call_decode+0x210/0x240
[ 1152.090874] lr : call_decode+0xd8/0x240
[ 1152.094766] sp : ffff80000bcefca0
[ 1152.098123] x29: ffff80000bcefca0 x28: ffff800009285500 x27: ffff80000aa78a70
[ 1152.105378] x26: 0000000004248160 x25: ffff80000a110008 x24: 0000000000000001
[ 1152.112630] x23: ffff80000a110008 x22: ffff80000aa78000 x21: ffff00004ca1c050
[ 1152.119880] x20: ffff00004ca1c000 x19: ffff00004d270f90 x18: 0000000000000000
[ 1152.127129] x17: 00d0070000000000 x16: 0000000000000000 x15: ffff0000fba2b000
[ 1152.134378] x14: 0000000000000000 x13: 0000000000000002 x12: 0000000000000000
[ 1152.141626] x11: 0000000000000000 x10: 0000000000000be0 x9 : ffff8000092a15ec
[ 1152.148874] x8 : fefefefefefefeff x7 : 0000000000000018 x6 : ffff00004d271238
[ 1152.156123] x5 : 800aad4b0000ffff x4 : ffff00004d271238 x3 : 0000000000000000
[ 1152.163371] x2 : 0000000000000008 x1 : ffff00004ca1c160 x0 : 00000000ffffffff
[ 1152.170620] Call trace:
[ 1152.173098]  call_decode+0x210/0x240
[ 1152.176725]  __rpc_execute+0xac/0x6a4
[ 1152.180443]  rpc_async_schedule+0x34/0x5c
[ 1152.184512]  process_one_work+0x1dc/0x450
[ 1152.188583]  worker_thread+0x154/0x450
[ 1152.192385]  kthread+0xfc/0x110
[ 1152.195578]  ret_from_fork+0x10/0x20
[ 1152.199207] ---[ end trace 0000000000000000 ]---

https://lkft.validation.linaro.org/scheduler/job/5525031#L1343
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.8-193-g318d4f28213a/testrun/11883336/suite/log-parser-test/tests/

## Build
* kernel: 5.19.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 318d4f28213a0b7494405e08920cdd5e649199eb
* git describe: v5.19.8-193-g318d4f28213a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.8-193-g318d4f28213a

## No test Regressions (compared to v5.19.8)

## No metric Regressions (compared to v5.19.8)

## No test Fixes (compared to v5.19.8)

## No metric Fixes (compared to v5.19.8)


## Test result summary
total: 113663, pass: 100760, fail: 903, skip: 11686, xfail: 314

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* ltp-smoke
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
