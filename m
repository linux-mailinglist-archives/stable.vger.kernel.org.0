Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54B4F7D5F
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 12:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244614AbiDGK7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 06:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244612AbiDGK7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 06:59:48 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC149EBAF6
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 03:57:47 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2eafabbc80aso56700907b3.11
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 03:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YAih2VV1b6Dcv2ql7IplEJePRdAhH/c4e8CUvFmbIkM=;
        b=RhiOo3F/DFP9jE1JwzXHVjf6v7lROXvN4/jHBAoAoVYeVj6yvERnzQ+dTjcMSEDyx/
         bHNxajnQZ5tu6+C5jDCGAWVMDB64ZHj8b4t0XnLFj11z6c7pQWhuJ7Duhe/JWFMlGYgt
         xQ7uJC8PDzHuVzKeSd02a/jBRIG6c1wIdUQh8oNcstgALIue74Ja+FWB2YtdMJVR8ejs
         zWHmwU0Cx+jhv3DZtz2xhgqAbY4G2YXVooDXdxYYGoJCWIJUl7YVlIKO4E7MGin26Cni
         NtXaw00B267uxAu3y7+X1QUNXin0j3TlEomeovWVHNjb0ocXNuwVB0x4qGCJ5f3gr7b8
         m6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YAih2VV1b6Dcv2ql7IplEJePRdAhH/c4e8CUvFmbIkM=;
        b=XnpGElen/cKkFoZHra6oYIAwKHAVmSZ3JVzyUA7KZ3n0CbFLVrEihLO30eq4fviiGi
         wSuVVmC+YXM0OM0pjCBkAFluOAI4y9aX0ZXYXPz34K5p92mybVE+q85xi45wOMz4tyWz
         4t60ymhYXEVfXfMnNLoIONhoUYWYcSItykKRBwdPA2DQfGUXQM7cygTKWB0k/KOb1xWf
         Z+rlcSSq+r5Km3xZnoxxBHgLa0ywmB2EHCnE0xEr+mTbWkUBNVklMb0gVFyLysXAa7Sb
         1Q9sHQ/dWsR7E8/bPIPbnFFMzBztbzj50slCvLvqhYfIULqQy90S+Dceb9ORjkz6WmYd
         bxCg==
X-Gm-Message-State: AOAM532JVQ3VijK7PYbbQpGTdYa38XjuejGG5A0ua1mm6bVXP/PxMFNC
        aV35+J1Bb1jWnRhh8RUjc+cZfUmw4IbWvYpYcpoc1A==
X-Google-Smtp-Source: ABdhPJwp2W5YUJOYwcWLmJlNNa7zvEs/sKpsR8lqYUbzifXd3DYC/LjeMUVIM06c4fR1fXOc/JXDbb4dywQrUKtMpUA=
X-Received: by 2002:a05:690c:826:b0:2eb:753b:169d with SMTP id
 by6-20020a05690c082600b002eb753b169dmr10646711ywb.265.1649329067023; Thu, 07
 Apr 2022 03:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220406133122.897434068@linuxfoundation.org>
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 Apr 2022 16:27:34 +0530
Message-ID: <CA+G9fYvROA9D0g3n74Qx7GsZP-Lu7-U7_XcryzoeEo=ZD2QX9g@mail.gmail.com>
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Apr 2022 at 19:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.2-rc2.gz
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
* kernel: 5.17.2-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.17.y
* git commit: 8137844a8b59104952c8c826fb8e300aa7ef97ad
* git describe: v5.17.1-1124-g8137844a8b59
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y-sanity/buil=
d/v5.17.1-1124-g8137844a8b59

## Test Regressions (compared to v5.17.1-1123-g290ba5383d2c)
No test regressions found.

## Metric Regressions (compared to v5.17.1-1123-g290ba5383d2c)
No metric regressions found.

## Test Fixes (compared to v5.17.1-1123-g290ba5383d2c)
No test fixes found.

## Metric Fixes (compared to v5.17.1-1123-g290ba5383d2c)
No metric fixes found.

## Test result summary
total: 97365, pass: 81969, fail: 2175, skip: 13221, xfail: 0

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* ltp-cve-test[
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
