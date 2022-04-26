Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D1251064A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350062AbiDZSIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 14:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350054AbiDZSH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 14:07:59 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A9A5FF0A
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 11:04:51 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2f7ca2ce255so91838287b3.7
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 11:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BfYDoauVEWn0fECVG2gG8MYEwxdFkbZQ2aELu3G6Srg=;
        b=fT+UHhoZuUSOvFHTnniA9ZI/WWSNqcIjU6ID2JwNNo1iCfG//k2/qNSSFk32R/tsHW
         gdju/AhWnACqkRL7u04J4rGUNkLpGOcsBK4WFf8Os1mU98mihXvJcKcN92+xVwvCBcn3
         HMvDF1ldnznt+y3l9rk0Pyx/1wg6hn4nCdrE/GW1LKSKq8lGS7ayIchCoqJOcFmPu1L6
         Cc8OJkWV1t85BdGnY3R+0ldF+yq9VFXH1GpB/liCfIxw7IbahAMAG2xOCPUbC4Im7bNO
         Mg1QPytkti1L5y9tGwbRONhh/ZS+CNm3rLmvYdn6/5i+EcwrCEyGz393kELaIqr7TywP
         28Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BfYDoauVEWn0fECVG2gG8MYEwxdFkbZQ2aELu3G6Srg=;
        b=N7CYKGbm3OLF6b0mXYNfJcAsi+Eyhm56nOrdfNMiyb02wOjqsRnSGHKOKqjAUA+dCj
         UHpPbi7eVQfTlBgwPRFMjif5U2W7imWsnVvOVzSyLUjEoz6VR2F2Zha1pPp/AHg+iSDl
         UkTps8hydqhUmQXLoFfDzlYputRAU5pwIi5XTqSJs0N6yejqi2Mo3M5GtQ5JZ4kfDPMV
         aigx5bfJDAg3sOiavwq+8Mea/ivfXJ3Y8P7GcUkOn3FCw74UiqdBSQ0L1/G6u0oWptBs
         FaMwuYHLdJvoBtA6pNktlPdQ6Q7nJoFdr3ARoFsn2DtcaR2wUDu3ZfH82YzW4RyaYLtD
         G6GQ==
X-Gm-Message-State: AOAM532runHYy3AW7mb+6VL601MxYphGHbS7rW0xzMcjoFgCksygyW1P
        S5scTL5sLrfoxXKY9499FXi7zfrBLF/nLfbwLkx2xA==
X-Google-Smtp-Source: ABdhPJwVFNGHmwJDe1voT4lZ6GY92oZhCTE4l39iZ1IhenwMndOb6f11wA4MS4bH+3CzjmOwvdH6DjyzOju2Zkn46q0=
X-Received: by 2002:a81:1b55:0:b0:2f7:cefd:9b51 with SMTP id
 b82-20020a811b55000000b002f7cefd9b51mr14827489ywb.120.1650996290335; Tue, 26
 Apr 2022 11:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220426081750.051179617@linuxfoundation.org>
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Apr 2022 23:34:38 +0530
Message-ID: <CA+G9fYtUUoBPuaGYbmDV7O9_P=L4=F=jOnjEF7Rndop+prRD2g@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
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

On Tue, 26 Apr 2022 at 14:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.5-rc1.gz
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
* kernel: 5.17.5-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.17.y
* git commit: 97b61330851547d91d9ce739b38c277cd3502958
* git describe: v5.17.4-147-g97b613308515
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.4-147-g97b613308515

## Test Regressions (compared to v5.17.4)
No test regressions found.

## Metric Regressions (compared to v5.17.4)
No metric regressions found.

## Test Fixes (compared to v5.17.4)
No test fixes found.

## Metric Fixes (compared to v5.17.4)
No metric fixes found.

## Test result summary
total: 100554, pass: 85967, fail: 1061, skip: 12607, xfail: 919

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 41 total, 41 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 2 total, 2 passed, 0 failed
* x86: 2 total, 2 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
