Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F504B61CC
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 04:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiBODj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 22:39:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiBODj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 22:39:26 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE4AB65E5
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 19:39:16 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id v186so52255467ybg.1
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 19:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=65ev4aSOrbtFuLvkpx4wQjbsqqQphX6/FnioNlaoiX0=;
        b=qDRSUZN1/Iyn/I4TkfbdU89WeliG1tqjHT8h7ohpLthsgUq28qLEjCtV9rXjCu8ui0
         Mg5ptTQK/o71Z68wsPJV2eCN2MYtJO2g/nDqMVkU8eZkLggcl7+eh8ol4dtHakR+h1BL
         VyyTS2fQ7B4Q9zuB09Euw8l6yLwp0GuhHcNAovsPn0P8J+oobJAfsgVzyTLb9b7Ls1Od
         +06xKYAr6uc8ouvWxA45LjHTNoXyN/c4pZ+VzF3FLwZZTjvlPKkgVKGNFf9uHwYRhOUf
         yGH2SnQhOCfEmsAzz1E4LBJTK+PT31E/GYx46rLfKtECbNoOesLJzM8dJLf1xKvyZ8EG
         lzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=65ev4aSOrbtFuLvkpx4wQjbsqqQphX6/FnioNlaoiX0=;
        b=Ig0oidTCz5rOxOtK2BsaRLXdnpwbxePnIX2hHWkTLCuAr80rASCS93JwfsDqRoA7Lc
         T4K+7qW1Xx7+MY7/1bWi9/I00q8iztCiC6Qo5aZlSMWM68TbS6M1MJHn6iSlyT7fdCo+
         d+LW/1WrImEdXLxmlygKXl+bghy6FWc6CBkbYR7L8F0w0J79VmrqMx52BiIfBwHSHXoF
         k758BjVsDQcIMfU2gfLHcokVXhin/R5IN0MoLfq5bfD5xt05NjvT4zZGp5N8hcmEdZJj
         lcwCmiwAP5hkILiiZFNd9BIhOIL3IQa6g0Gv6k4IL03orz+xlooEk9EkUgpH0OEIs30D
         mkIw==
X-Gm-Message-State: AOAM531rQCorIpAOs2J/tN/UJnCaH/xG32fqep4PwSijdNXKNYAFxUjf
        Lt3ZdTJIOSmF7i6gMt5KQ3gepHSoxMnxCXosH6tkdw==
X-Google-Smtp-Source: ABdhPJyXhBV8FivHAynLNi3gzMN1/fbBCIHAYlo9R8xS4bYuHMl0TmaN4+LCg6T9pNpJQ+O03pcfwkgn7Gra6qIH1tw=
X-Received: by 2002:a0d:f601:: with SMTP id g1mr1823323ywf.441.1644896355001;
 Mon, 14 Feb 2022 19:39:15 -0800 (PST)
MIME-Version: 1.0
References: <20220214092506.354292783@linuxfoundation.org>
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Feb 2022 09:09:03 +0530
Message-ID: <CA+G9fYtiiJj6dzu3iPjQ2Aafx+UP4pmWV1taH7_2gZQqzYc7GQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
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

On Mon, 14 Feb 2022 at 15:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.24-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.24-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 2092ea8331071900a0b3ed6ce06daae663215b92
* git describe: v5.15.23-173-g2092ea833107
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.23-173-g2092ea833107

## Test Regressions (compared to v5.15.22-6-g722769939d60)
No test regressions found.

## Metric Regressions (compared to v5.15.22-6-g722769939d60)
No metric regressions found.

## Test Fixes (compared to v5.15.22-6-g722769939d60)
No test fixes found.

## Metric Fixes (compared to v5.15.22-6-g722769939d60)
No metric fixes found.

## Test result summary
total: 98687, pass: 84389, fail: 1195, skip: 12142, xfail: 961


## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 261 passed, 2 failed
* arm64: 42 total, 40 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 40 passed, 16 failed
* riscv: 28 total, 24 passed, 4 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* kselftest-lkdtm
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
