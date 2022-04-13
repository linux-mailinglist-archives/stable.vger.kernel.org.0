Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3B14FEEFD
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 08:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiDMGCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 02:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiDMGCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 02:02:20 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1174C6411
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 23:00:00 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z33so1884680ybh.5
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 23:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rfca7IeMtlOW/R4a/dqCyA7+xRxAXALkRhVZh903ofg=;
        b=uwUMpFpqsouJU66yPo5YmfA9AqZKzGQtVU3PH0o8NMTWynsyBUbboxSJtIjKaDV4Ld
         qzDcxBmjBWE9A4hbjKO0i0n8lI8OTdEbGGZ72LXwhQGg6hs1UYGU6UDN0thGSAYM6aRj
         +BFcwqAIsluipnVLUz90yeKpUjyP0YzIPsQ8OjmnSgI1IbY3f1t69yb2lbcokw7MWuKP
         7Uym6C8YgpZFyBCA6rdRiX9CO4ikwQinNz9yowPOZjw0Dk6qvqqLkZ/mqyztHDVue+Ah
         pXo0lwhreQ8/bukoSl0z2s5zwPqmbS3/9prZ3DKOgutgcuLp50VEZDogaa8Nf1FbOxZM
         UtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rfca7IeMtlOW/R4a/dqCyA7+xRxAXALkRhVZh903ofg=;
        b=6J9BdSizJ7qYlxe8L+LVhCNXPllmJidmcVVnfpfxc4w2JtmBeGjfVGAq6YfLnNlaxq
         QenPkvbWu2qhAF4dfX6m+8XO9ld+LPKD336YaPLtwtI0y19v/eoMO+JEQ+qAirKVHUm9
         rc8WiPw7OVaM8A5+/RGptlTg2gxRB+iSvpaw/fU3u4BqfK1y7OpzpVtOUiFDM+wRZfMx
         YyzqIogYhMabzQQ2sZ98CHd95BpAbA2rvKnq8FavTyPW39eyPJxeaWgpf/Zf+uz9NDq/
         AkWjwNSCtEbflX8IWCqgSr6GlpGfx+DEo/WX2pEVYquQVzU5kByPmAU6kqaMbIryHTJq
         CabQ==
X-Gm-Message-State: AOAM531MG/jShyV+vswYOXowMsZShxyDgFCL1FVoZhlZdP7FS0N4EGuV
        0nz2cGyClanDxQVkoktWCJVwm62eQhAbE2rpuNSo7w==
X-Google-Smtp-Source: ABdhPJyzh8NIIPwogKkE8jbMEvrPXhaQNKMuvbYIlQ9BTRA0DNxf7+vMyyY57F3hQXO6gyoVPOXQv1qAU5Tvcws/j5E=
X-Received: by 2002:a25:9909:0:b0:624:57e:d919 with SMTP id
 z9-20020a259909000000b00624057ed919mr30378831ybn.494.1649829599080; Tue, 12
 Apr 2022 22:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220412062943.670770901@linuxfoundation.org>
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Apr 2022 11:29:47 +0530
Message-ID: <CA+G9fYtOpNELDwKQwG5GRpN_MVCqRi_FJOdxvD4hGYftvVsiDA@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/285] 5.16.20-rc1 review
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

On Tue, 12 Apr 2022 at 12:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> ----------------------
> Note, this will be the LAST 5.16.y kernel to be released.  Please move
> to the 5.17.y tree at this time.
> ----------------------
>
> This is the start of the stable review cycle for the 5.16.20 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.20-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.20-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: 4a83e2cd9b7444a50219f4be214a3d4d143e1945
* git describe: v5.16.19-286-g4a83e2cd9b74
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.19-286-g4a83e2cd9b74

## Test Regressions (compared to v5.16.19-286-g99cc9cff3df4)
No test regressions found.

## Metric Regressions (compared to v5.16.19-286-g99cc9cff3df4)
No metric regressions found.

## Test Fixes (compared to v5.16.19-286-g99cc9cff3df4)
No test fixes found.

## Metric Fixes (compared to v5.16.19-286-g99cc9cff3df4)
No metric fixes found.

## Test result summary
total: 108903, pass: 91586, fail: 1117, skip: 14997, xfail: 1203

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 46 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 26 passed, 6 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 46 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* ltp-io-test[
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
