Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D26C5113DE
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 10:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbiD0I4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 04:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbiD0I4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 04:56:21 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DE51B12F5
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 01:53:09 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2f7b815ac06so10987347b3.3
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 01:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9kpONJ60lFyzwttZOfPhud+fUawgsiXiLYKJfmKmmSQ=;
        b=dHn7N4VTH9EeRqwCJ6CO8Afiuya47AhpyLFd7zYglpPPq0QHt+k0oaIwBjd27+r9Rv
         gwVVcJSuygTMyCNL/DpfDmgRcuKIwoQYygj+UBYUSMUkmiFtsOW0b/Sy/k2pwRidXORl
         JpgyMGSws4gZUfj+mxrd/vN0FXd5lKyiH0j/KBPYo2IwyOcfGZ8jK5bxzAriS2NoeKap
         C66d9ajEkNRph59GWqVBOfmHqHIr8oPzcQ5scTPHdfv8VbeikKsrZ2uzRt0PzlnkTatN
         vRKosA5UqcNOMQ3SkoDdPGhpGiumfK2wCnOu4FQpLl8l5HhDFi4Keiiwc8LbWNrRgUt1
         voXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9kpONJ60lFyzwttZOfPhud+fUawgsiXiLYKJfmKmmSQ=;
        b=fP4m2cf0XqhhM5pul5uPN36QzIQQxRCyc3SzEco7r/21nfp1xJbId82btyJaQoy8a2
         e2oxfPLy0abxU3EkHLWs0AHaM7+++sfcSUzPIBqZM9beJ9kW+MT55BtTk2yWLYLK06FC
         pO52n6zhvqmpzgbRwKkJGdOe7DEZUiHzdfyKO7KqY1RSWoN17PIRcNjuNRw/pz131KoR
         gqaAwIQzL6RBK2TQRvPDPoda7TgcJ5EysnvE0pw49Xx/EwPyKHkO/NxG12/W+hHCiiZy
         J+si4l97DdlJ8zr0bW9PUxbhf+ZBOOqNamPpDRejqNdbEB5Gew2tquVOtZXiAwxq+cQO
         Ctwg==
X-Gm-Message-State: AOAM5304I9URsPbEEBLOzN7ouA2jmx7hIKzmhPep4QyK1Q8wtAB9jyWF
        EW+3T8A3f2zEyQYzwpQek8OpKW6qpv6TIt+qNUF3dA==
X-Google-Smtp-Source: ABdhPJyCcVWFnDByJpKfuEYYwe3XTMInjz482TE+AZk50r1lgwfc1XLyIqwuCDgCZKcV+K3cPkTlRK4GLIsNZL8vqo8=
X-Received: by 2002:a81:478b:0:b0:2ea:da8c:5c21 with SMTP id
 u133-20020a81478b000000b002eada8c5c21mr26812977ywa.189.1651049588081; Wed, 27
 Apr 2022 01:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220426081734.509314186@linuxfoundation.org>
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 Apr 2022 14:22:56 +0530
Message-ID: <CA+G9fYssoW_r81q0Z8W2WwcYO_2MYvQv1BSNpUqFKQG_V3zMNA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/43] 4.14.277-rc1 review
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

On Tue, 26 Apr 2022 at 13:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.277 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.277-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.277-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 29ecac2778fbc1ecdf9ac5ae9a564fd0a487eb5f
* git describe: v4.14.276-44-g29ecac2778fb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.276-44-g29ecac2778fb

## Test Regressions (compared to v4.14.276)
No test regressions found.

## Metric Regressions (compared to v4.14.276)
No metric regressions found.

## Test Fixes (compared to v4.14.276)
No test fixes found.

## Metric Fixes (compared to v4.14.276)
No metric fixes found.

## Test result summary
total: 83762, pass: 66336, fail: 1152, skip: 13814, xfail: 2460

## Build Summary
* arm: 280 total, 270 passed, 10 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 60 total, 16 passed, 44 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
