Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5E057D9BE
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 07:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiGVFWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 01:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiGVFWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 01:22:13 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E812C88CFF
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 22:22:11 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c72so1675522edf.8
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 22:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JTMDB+mEQATx/HSl/jPAnHKl6ofJIkqX64RJuM+D1Vc=;
        b=uoGpPfkiOx/k+P49AGeEScryn5STqDBT3gi7Wq86bhq155vFM6X27YSywGC1dIalJR
         rDJ/Jq3Pt/Vjzv4KzGi9EbcF3hMyx3y5glkkrW/UYGzy39VxeIO8oF+GPagQHD6FZeMd
         mFvBa7B1kG8KQc/6kdstsHAJ37qngS53dXzyIACrrm4TE9sj1OoeS+bjHfqw5Jo8W59H
         /k0b69wWNl7IGdTna7GZMdGvVQ+X30/SewuxOJhod23V3q3T4Y1nkaSDZrZ6/Tral/8c
         fIVaKGwj4dYdeeBnr0TQAHyUIQJ1VP4n/G/JywPTroPjWldmhEyIGXXXistKgXTKpRgF
         lcFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JTMDB+mEQATx/HSl/jPAnHKl6ofJIkqX64RJuM+D1Vc=;
        b=HAn54i7KCQ+U/MAIhsi/30G44i/0C1+nm1bccWvI2h3i6dynKcTckIuz/NjzSNbNiW
         1ODXLuTAf66ATHwHZb0icJ0bmwlY243T3oKzaPFx+bb9XSVAhBhXhvw17A71nbhzl6iw
         gzkFli7xpnB9Zghp+DoKodUJHT8r/ObNbPScKDBzGPYRf2Hb+bpf8+hToxEWjw0IVOZm
         kdLYm61WjEsaRRJDYIEIANlqAt8CNGtRZM/ue0daRKLxGBdsCxwkvb0bchykRVRmhyuW
         qd87vrQzRxu1+X5kH6ba6ElQy4lmHS6qz776oDL5xsZ4rXa9XbtQnCgkr7VN97NxxMMz
         7YhA==
X-Gm-Message-State: AJIora8XtpcImUGjBzNR2dnziEUl7ntrVVVha92ZVXTDpdXzQa2ZWI5T
        bKwoKWEyqh/yETjNFyj8lNITDWSf2DB9ip09xLDvsQ==
X-Google-Smtp-Source: AGRyM1uz+eUUNkg8uUBzDhBXPliKjva14riP1fsNfgnv60wV4ZxX5RscwvWimE/W5SfF2Vyaj/2tg2igIdD59QCrPTE=
X-Received: by 2002:aa7:c6d5:0:b0:43b:a52b:2e9d with SMTP id
 b21-20020aa7c6d5000000b0043ba52b2e9dmr1732590eds.55.1658467330143; Thu, 21
 Jul 2022 22:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220721182818.743726259@linuxfoundation.org>
In-Reply-To: <20220721182818.743726259@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 22 Jul 2022 10:51:58 +0530
Message-ID: <CA+G9fYuq5jk6avKjTcFEbXm-UmYD56=fZ8L8i_rArkSmNK9d2Q@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/227] 5.18.13-rc3 review
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

On Fri, 22 Jul 2022 at 00:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 23 Jul 2022 18:26:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.13-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.13-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: ec4d1360df1afd7b884f6c3a923f97307e898d12
* git describe: v5.18.12-228-gec4d1360df1a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.12-228-gec4d1360df1a

## Test Regressions (compared to v5.18.12)
No test regressions found.

## Metric Regressions (compared to v5.18.12)
No metric regressions found.

## Test Fixes (compared to v5.18.12)
No test fixes found.

## Metric Fixes (compared to v5.18.12)
No metric fixes found.

## Test result summary
total: 133194, pass: 121198, fail: 896, skip: 10299, xfail: 801

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 308 total, 308 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
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
