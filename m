Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F5A52A035
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 13:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345063AbiEQLPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 07:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344978AbiEQLP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 07:15:27 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8554C35840
        for <stable@vger.kernel.org>; Tue, 17 May 2022 04:15:25 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p139so10912420ybc.11
        for <stable@vger.kernel.org>; Tue, 17 May 2022 04:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kB5d6nG1IOqdEbMihF1vU/5xvhjB0T9I3Lr4Icspy1w=;
        b=Cvyez+H2N2A5IbkuwdNSlG8B/C0MWk8rFU5xTXVFAU42LTMVmcS+5+IuE2wFuYdgsH
         p0TxuYoOb4UKg8bTxLOzTHp96icemNsx9eCIlXaT0vxTZGgq+ukG2zz8nkXGSQuz/TYA
         KlZDbhVWuuPrMwBitlP+l3UyHlV6N6KyeM6aGMmtWQ2Gz/VW8xDhy/40J7zckQPtM8Bx
         jB9x+JJn7oeqF4ZJTbsZWTAhWNvtOFw4mNjsgPjALAMQ5iEIxK5Z81oZR5G/n8qiVaGz
         BDGKyiM1ifmknc0WIzZzKrgrjw1dbv+UwCV3kTy5vmSnBh17OyvKP+v+7nzlyaVYetWq
         0S9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kB5d6nG1IOqdEbMihF1vU/5xvhjB0T9I3Lr4Icspy1w=;
        b=LCfDXaAWTwrIYD+blBnwnv0AdF+SG0c5Wog6YGmawLlp3t6otYd9vyuiSnH60XLu9K
         cPl3r++Yvf+oIMv44umOz6X0FRt90VQ421RVH81ABWkMS4EtSM6uTt0+olmBplLodvTs
         wkao0sOVVJd4LVunhDq9kchlsEoh9AJ0RvDrLCLnMtjDvU22wCAFvdb8tMB1kL5kqkUb
         5F4XjZMBPKwgf4ZDdpOZt41rgg9a9E+KuGsbc3EulWqTt4suA7jfpiAc2Ct82+QnA8I9
         GWaJWnnX+Ocg5OggiReouIvl9ynJ005FDhkH2DK2TwErMAoLsSNrYiofg6GsOHy3jxqQ
         H/yg==
X-Gm-Message-State: AOAM5323uxalW+jC6vneA8yKdai4jcncMCXMeY5xnWbMhBFONq62nL4d
        b537cbGXeFheOJ/3mZ4m6tFKUWrDJzXGC76HJsx9iw==
X-Google-Smtp-Source: ABdhPJzItig4NRa91d3C8CdwU1uEDDQt1blygdhT0kG3bsQR3n7t3Rigv5A5aQoQvgEqdufegdbdXfZBzC/uxDRlnzw=
X-Received: by 2002:a25:aa30:0:b0:64d:ebad:538d with SMTP id
 s45-20020a25aa30000000b0064debad538dmr4781311ybi.603.1652786124572; Tue, 17
 May 2022 04:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193623.989270214@linuxfoundation.org>
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 May 2022 16:45:13 +0530
Message-ID: <CA+G9fYsZr-K7vXk9ORsf_1=BprFLejzKicZZtsS0PnmVa49YHw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/102] 5.15.41-rc1 review
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

On Tue, 17 May 2022 at 01:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.41 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.41-rc1.gz
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
* kernel: 5.15.41-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 4aa8770e7dfca33d694a86ec8fc85900ada99c26
* git describe: v5.15.40-103-g4aa8770e7dfc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.40-103-g4aa8770e7dfc

## Test Regressions (compared to v5.15.39-22-g13b089c28632)
No test regressions found.

## Metric Regressions (compared to v5.15.39-22-g13b089c28632)
No metric regressions found.

## Test Fixes (compared to v5.15.39-22-g13b089c28632)
No test fixes found.

## Metric Fixes (compared to v5.15.39-22-g13b089c28632)
No metric fixes found.

## Test result summary
total: 105033, pass: 88286, fail: 1128, skip: 14403, xfail: 1216

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

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
* network-basic
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
