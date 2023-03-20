Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76F86C22A0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCTU2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 16:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCTU1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:27:42 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D888734C2C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:27:02 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id i22so8830735uat.8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679344020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LWGBmbI+BHVMpZTT7NZK3JJiXscQ4Zf2gDCS67Vpmg=;
        b=tG0NnPVr7BAoJQ8VKQsAhltY7gVfeoqcExoTzle/sKmvrwXZQjo98cYUV5a0UZAKEF
         XLi0fHpo/EMm2VJTMBGUKCh32Jz3qqnaC6aO8+nhGfhjwnjKqwpb+9FcLGHBYwpsNEae
         cSPZ43a7/U8BxqR+NoC5rLcCOiES2jIlHBQ2uliNjbR0PtdZzwozvFiCmypt0U7Esvhp
         Ynr8HMrpe6/Dx7NXi459qIZ0es7btFgC7paw6nUuIQm9UbrQXjRz1ba61Y7cljjPE0vM
         AurkBm9DcKB64AaB/gGM3Do2OgHFOaJZbzccZiGJQa6BG6Tjd9QmDPHEtlu76brQGEDu
         pHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679344020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9LWGBmbI+BHVMpZTT7NZK3JJiXscQ4Zf2gDCS67Vpmg=;
        b=P3dgkItmx++MeFDZYA2gMMKnuQoT6avxl189Gt6W4sAVD/x1W7BK6zc7q3/i57YD0D
         +jaxFbGsFWt+o6GLipG3DRSDGogjsjLomirwPE2p+MYIswl0UZxy13l9523h8oea+E3E
         rummV5NMZLBG5rEjOoR9hFl+i2bhdJE9VpAkVstK7frYHeBqBj+oR1VfYW9KFVKxrQMZ
         ZHj6WTiWvxLzpmHqpuDTU/GlFPnxmLeDNdjivGDGug0yIEBuEbfi+c4iPPGGpIuWssAw
         m6mXCjy8JDObWNMJzGllwdQ3RP25LtoDvah4DQM7MNtGKJBPE8D7fNnEgbRYv3a1Rvq5
         2YKg==
X-Gm-Message-State: AO0yUKV25I3eQKeo+laTetuBmvBCBAdVDWd1CAdl8hmMKjxC2y42M++w
        t3MhtU2PP3OOvl4OlMgd+rZPgmQaL55KDbWF1ogOPw==
X-Google-Smtp-Source: AK7set/G2LWlacpC62mIi6CtmgFB5SvfHW6t5SNA2V1JpFtqUhpkErL/EMVXwT5bd9gNjRlGaav9nMiiuRVDT4YB18M=
X-Received: by 2002:a1f:2e8a:0:b0:435:bf4b:848b with SMTP id
 u132-20020a1f2e8a000000b00435bf4b848bmr8302vku.0.1679344020500; Mon, 20 Mar
 2023 13:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230320145449.336983711@linuxfoundation.org>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Mar 2023 01:56:48 +0530
Message-ID: <CA+G9fYtW+gzkLJ3LR_-Gkcc11V2Ln5r8NEzi3VX6uO1yhU02dw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.104-rc1.gz
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
* kernel: 5.15.104-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 433daa4de6819b2f97fc17c5a71d1fa5b1f8b14c
* git describe: v5.15.103-116-g433daa4de681
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.103-116-g433daa4de681

## Test Regressions (compared to v5.15.103)

## Metric Regressions (compared to v5.15.103)

## Test Fixes (compared to v5.15.103)

## Metric Fixes (compared to v5.15.103)

## Test result summary
total: 94469, pass: 77630, fail: 2510, skip: 14101, xfail: 228

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 112 total, 111 passed, 1 failed
* arm64: 39 total, 39 passed, 0 failed
* i386: 30 total, 29 passed, 1 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* fwts
* kselftest-android
* kselftest-arm64
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
* kselftest-ftrace
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
* kselftest-net-forwarding
* kselftest-net-mptcp
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
