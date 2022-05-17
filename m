Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69DD52A48D
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348609AbiEQOQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348573AbiEQOQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 10:16:39 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD63BBE3F
        for <stable@vger.kernel.org>; Tue, 17 May 2022 07:16:38 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r11so32654612ybg.6
        for <stable@vger.kernel.org>; Tue, 17 May 2022 07:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FbsLkTlBRK9V5w9TVhQDtQ29lIrXV8IwRzrUpg6BETk=;
        b=Q8YU9uym0taBo6AFiiFbXkUC56kTGpa96zoyy7ewEo9I6agoe1RwlqalbfZTjKrty4
         usWvX3vuQZ05D85FZk5w7Gddibx+ak8G5gEw6BXGWCd8gpq43nEyRmWmOOl2EptzO936
         giO5I1UGsod+aiPW1tx2DU6ombstkgqqtUo/zHbi8BKGxKs08B+2Tuayuqf/uFPHAUct
         YROjzHSnc2PiF/nxvc/QsuTalKjtYpXkPqVfrkQRPVUPBQGVWR2WAMFFFnAhYnITeR+F
         nhv1yEFl8nektaSHqNFCqaHy7R3emdb06Dpsuvoqok1J80cc8NjUsnuxJpmORlGrhG/K
         FlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FbsLkTlBRK9V5w9TVhQDtQ29lIrXV8IwRzrUpg6BETk=;
        b=Xb+RQ9KEo4YYTQZ4obbwgbWMY95xO1DuNsCpNG0gsH5CS1e69d8MSxQ0LUcrzRYTNo
         zVKzF6LvBplKJH8UHQXN9RHYVJwuTnOvXRHqktFbA3/OGZmZhZOrzW5nNP3bBHBHLnr/
         FD+9Y6bB+Nm4xMqeg31tzYMF8sWYN7ehUCCC3rioMbzoDBgAVPNlsAmm5UGS9ztUof1F
         FEbhhEeNpQ1pe+FDec5tHENBHXV1uu6Uft6AFbQFCnOOeTdeDUjSqJ7iEJAqGCk1H0st
         aZMe6/Yq64Nhh5/1q7ha+CL1JTjyrSPGJylHDbPtLd4pL/R1Qmj1NHH6eLj8z3Chz88K
         lO4g==
X-Gm-Message-State: AOAM532kRIM5q+5R/n3gWROohw5mtmTJ1UKXdNN87epw2emuRxk8yncW
        71wtosqs4d7ty8Zxzx3+LIAxV2hp2XEUEaISDIEVEA==
X-Google-Smtp-Source: ABdhPJwKz9LopBJlylFdCqxavwxIeFl5+xWOyu2HxR2KcPnTYHCLzeicopwrTp11gQ3GRKyz53yvPnXxwLI6c/NOOnI=
X-Received: by 2002:a25:804e:0:b0:64d:eafa:450e with SMTP id
 a14-20020a25804e000000b0064deafa450emr5554651ybn.128.1652796997742; Tue, 17
 May 2022 07:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220516193614.714657361@linuxfoundation.org>
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 May 2022 19:46:26 +0530
Message-ID: <CA+G9fYtUa+B+3r5o8H=0WKa4VZe4Nm3b_cEqHuUxPyMXZou9qQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/43] 5.4.195-rc1 review
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

On Tue, 17 May 2022 at 01:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.195 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.195-rc1.gz
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
* kernel: 5.4.195-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 25f2e99af01b5b7328f55bbadab563cb26478289
* git describe: v5.4.194-44-g25f2e99af01b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
94-44-g25f2e99af01b

## Test Regressions (compared to v5.4.193-19-g15301ad60009)
No test regressions found.

## Metric Regressions (compared to v5.4.193-19-g15301ad60009)
No metric regressions found.

## Test Fixes (compared to v5.4.193-19-g15301ad60009)
No test fixes found.

## Metric Fixes (compared to v5.4.193-19-g15301ad60009)
No metric fixes found.

## Test result summary
total: 84577, pass: 70335, fail: 911, skip: 12348, xfail: 983

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 34 passed, 6 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
