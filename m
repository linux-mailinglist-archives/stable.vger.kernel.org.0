Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4795A4E3C9E
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiCVKm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiCVKmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:42:25 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4111580236
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:40:58 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v35so32802402ybi.10
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BfLZfuNtHWSHfLJgUzXihlygGTtjO/2p9TMnJyQ6tCM=;
        b=hWcOt8AhGMyvua19JFIDB9WfPadCHKN0/sHwH2vXPlgRkpt4R2stFDEHzffM4XSlvt
         84+jbaZYMvUW4Inf5dJTTF4Yq39N7XQfa2Br8p0PuZHyhOJncwTtO5q0sR5KWMMQahKF
         9TOEAVJzzKLnRooSj7ERbSkzpCd1v1QoudtNbRrgxCLrgQ1MmE9YAGvxC7s8piwF86HY
         n1HepRFmn/QhLeItLRL0wpOV2mPfJ+fsAVTkdLzJEXFVhk6Gbcr+peRAKbs3eerCZEAD
         HUQVaaiEgTKihH/Ap7giAakhYZ4qLzCHb90Z33Y2uQknw1B8TtV3CGamnyt0DNH4az58
         t5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BfLZfuNtHWSHfLJgUzXihlygGTtjO/2p9TMnJyQ6tCM=;
        b=Sba1Yioa2gYzLx3F6PuwFQm0O//IxBdNkP1HOlOAwPHKJk+Uf/5k759yWMojs1Y5wA
         sqrpriGl6C7TEFfKGBTg8e+AvTfDrSDRNiSr9JYCxo1UbmEXsJ1fXXT4Ibqa/q8p78BA
         rrYMQGsPbe/s+Nl3ywZHs/xG7L4M6gCNdkxSkfxY509Svqavb28JcBLOxnybtKt754KY
         K3LU7JTf5g7E36ke+0ll7XItkR8zINnxZcGUBUIR7bb/1SfoBpWzmm00smZJOEa6Mthb
         JM15iMWZF2fr4o4uqTTQV7x+XSV/70q7fYwzsx3TI+IzEQABeWwvYxf2e//Fl8HLjrV2
         oZ+Q==
X-Gm-Message-State: AOAM533ZXCMDS0o3bny1PHyzedLR+t/3PQ0ZGTIgN3ZVmqiiVvJtl3Qo
        TXkUYYhJSMTAFfkirD+0ZcukmsiQczGidQq/9bREwQ==
X-Google-Smtp-Source: ABdhPJyjO8ekN2nhTEy+oPGf1waYGacEgnYxt8muuywguXzT/ZhhgfccPboEwOn9eMY5WxbjqNn9GDOa3ROQbJdH2Hg=
X-Received: by 2002:a25:9909:0:b0:624:57e:d919 with SMTP id
 z9-20020a259909000000b00624057ed919mr26913929ybn.494.1647945657111; Tue, 22
 Mar 2022 03:40:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220321133217.148831184@linuxfoundation.org>
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Mar 2022 16:10:45 +0530
Message-ID: <CA+G9fYt-D-A_hfy8vd6WwX+9F4jETO+5Cmcn72eoupbUJQe23w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/17] 5.4.187-rc1 review
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

On Mon, 21 Mar 2022 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.187 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.187-rc1.gz
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
* kernel: 5.4.187-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 7f44fdc1563d6bca95ee9fb4414e4b8286bccb0c
* git describe: v5.4.186-18-g7f44fdc1563d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
86-18-g7f44fdc1563d

## Test Regressions (compared to v5.4.185-44-ge52a2b0f299b)
No test regressions found.

## Metric Regressions (compared to v5.4.185-44-ge52a2b0f299b)
No metric regressions found.

## Test Fixes (compared to v5.4.185-44-ge52a2b0f299b)
No test fixes found.

## Metric Fixes (compared to v5.4.185-44-ge52a2b0f299b)
No metric fixes found.

## Test result summary
total: 91651, pass: 76371, fail: 1036, skip: 12975, xfail: 1269

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 295 total, 295 passed, 0 failed
* arm64: 31 total, 29 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
