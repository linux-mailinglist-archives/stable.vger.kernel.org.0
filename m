Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C4511340
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 10:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359334AbiD0ILv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 04:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359326AbiD0ILq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 04:11:46 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF206D4E5
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 01:08:34 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j2so2037460ybu.0
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 01:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ocOESGw7XVASTSwvCDpOuAgEDVf5NNf8AWJY82qKm8o=;
        b=v8WwPOOemO641H3Y7HLAacEFdl940XbrIoASvS4InWwLy9z+Sa+PFmpEzChvN2s7BX
         BdbatpcQ3CxNerO8rJE3AbIgcg7XMxQeJDCnBfH5SyojxGZCziVi/YmU7feF6tPF/Kkg
         4rImV+LTbm1Yk6wwS1cqMtv+8bviLyd5VM+fufpDJq4WKQSAyZkcOcs7HR4ubmzilvK3
         QpYZQjo+uCaNLTVsMWLTyuFXjncUPfXGMlDBwcITKCyaYsvJtHgL4jJfqa4xsz5S85gq
         K4L/VVU2dBSZSU5Q5sJXyig1Bdmj0LRR1mJ8CfHm/3IWNBa8OGRVBVmEBC2qmn2QL+tc
         gCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ocOESGw7XVASTSwvCDpOuAgEDVf5NNf8AWJY82qKm8o=;
        b=Pyxikcki3NBiZXJS5Q7cOc1P2u4TEUs252EjcntQG9kS6qa9+V6AJdQUWnrJnJG0Rg
         ZBpxJFUU4H/s40oFK3FeL6O+bb49hjy6yIWrzNWUUu3p3g0R1TcRrlilPp0HZOFNEVsu
         UUlgesFPtbEuwQhABg1rUESxHcdzBlV/jb7iuV45hVqZgnsJRkJL2Hulx1qInAnALthu
         tCOI2zi0DimvG4dtSy+UlkqgFlBsMnKPmDYF6oN2Ttwbdzbkt2OBLQJGGr4Pp8YbfnVR
         gC/zhnNi3ZjA+H2cLwmQvth7i1We2tTVQl0bbcVH6zhxEZV3hW/dBIFChZ/J7Gfp7Bnk
         c98Q==
X-Gm-Message-State: AOAM533LVZRhH5P0sNB2leCkDOvG+kYU5Uob6GOwLmuZ2LkytFrs4zik
        IJjxYeY0KFgwFt7e4JpX9hR9BJ/e9nShFjn90cW7TQ==
X-Google-Smtp-Source: ABdhPJxISh9cGWWhc1zMyKGqPyx3MjqK5qah/U6lO55iKVFy4GWRVkb+Zjqixq31S/zQ8f6I89fJCcNvPqF8wtxymHg=
X-Received: by 2002:a25:c012:0:b0:648:4912:7b9a with SMTP id
 c18-20020a25c012000000b0064849127b9amr16152605ybf.474.1651046913582; Wed, 27
 Apr 2022 01:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220426081741.202366502@linuxfoundation.org>
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 Apr 2022 13:38:21 +0530
Message-ID: <CA+G9fYsodOu4GKm8jFr=vbWECJ6a2iLKifsMCUjLg1i1027=wA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/86] 5.10.113-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Apr 2022 at 14:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.113 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.113-rc1.gz
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
* kernel: 5.10.113-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 889ce55360e75088d2b85d71e5119d5e3d45c90c
* git describe: v5.10.112-87-g889ce55360e7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.112-87-g889ce55360e7

## Test Regressions (compared to v5.10.111-106-gd5c581fe77b5)
No test regressions found.

## Metric Regressions (compared to v5.10.111-106-gd5c581fe77b5)
No metric regressions found.

## Test Fixes (compared to v5.10.111-106-gd5c581fe77b5)
No test fixes found.

## Metric Fixes (compared to v5.10.111-106-gd5c581fe77b5)
No metric fixes found.

## Test result summary
total: 99479, pass: 83784, fail: 947, skip: 13672, xfail: 1076

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 51 passed, 9 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
