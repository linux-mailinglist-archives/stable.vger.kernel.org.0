Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE44D365295
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 08:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDTGvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 02:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhDTGvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 02:51:40 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD828C061763
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 23:51:08 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l4so56552774ejc.10
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 23:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rf8NoCNyQhxA+jFGuotZJTkTTnHted05N8zdOxD/kz8=;
        b=vn1SMO+fIUUiYE9x6F+/tj8Jdktm2COOztnoUaK3LvCHgirzXzI067bXhullRL8KWm
         gPRFeUV2Uq9vQAKQuXbbgWlVWmvDzC50expAYGxVVNTQhElr1DcLg/lp3hSMA0/iZwWx
         ZbI5ue1msLQRUDmfvTBg2+Pf4sB+9fKPgUeJszn/dEhKAt8Uc9/cttkL+pslERz8ed/p
         CQfmLRdZKG0XHsycHBzlB+kVa0LnVVxZHN598j4KlACEQ7PFAVt9a660ymvUgJVaT1JT
         +n9FKCMQ5sT9AwrfSY14XAaSWLS0HiT77dG9lxtxtRDMaTFTmXbHQoIbZ1qWMWg0/jbh
         9G5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rf8NoCNyQhxA+jFGuotZJTkTTnHted05N8zdOxD/kz8=;
        b=MtzAHUVLlU6W4eW47ZM8N0QGYdimEWd4Z0rMEk4mpocjgSTV9ocWYNg+8FkzGxvF24
         Ej8IimjKLZKGFfsPbfEcxLDOanieqpsp2Fd8iCmePemIYab07+5xZpBbbxXokTznXI+Y
         HBzpsaedqBuUMlmjwENl8h+UQ4fS/PvY/ZqWNxUGwaVdhd2YzhQ+CDEtGr/RfX3tgSk7
         /UiFI6Fz4O76BFfVfjJPWNLM5VBDgpQD+nXtYcpHu8fgHc+Euo/hSsbiaGkQhYAqtRdw
         SoY8B7EnMYEVGioPUx5G6V7D3U5aHyEIp83EyRCynWHsBmC21svY9Dvldz+QkaMKTV7w
         6Q7A==
X-Gm-Message-State: AOAM532LGBekZoBBvfWFAPO+nkzxQHwk0HjFTfg6IYLPJa2EPXi25RkV
        djJYWvoutgAHvSL4uVCsWGEQqe6Ga2JICoItHCfI7Q==
X-Google-Smtp-Source: ABdhPJwfkX4BqvCpzLc+FdcmccaFof2cotp8scQwu8bfHuohWlN0qBQpAMq+Hqb4WnUKMytybqHYZJcFUAN2vxZ43H0=
X-Received: by 2002:a17:906:f155:: with SMTP id gw21mr25376736ejb.170.1618901467370;
 Mon, 19 Apr 2021 23:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210419130527.791982064@linuxfoundation.org>
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Apr 2021 12:20:56 +0530
Message-ID: <CA+G9fYsxkGznoT_kqkzWe0fW7_zzWbpY6CFuwwFatGWpexVpwA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Apr 2021 at 18:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.32 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.32-rc1.gz
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
* kernel: 5.10.32-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: bcedd92af6e5899132429d20a9322b12afec2188
* git describe: v5.10.31-104-gbcedd92af6e5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.31-104-gbcedd92af6e5

## No regressions (compared to v5.10.31-56-g86a799ba8d60)

## No fixes (compared to v5.10.31-56-g86a799ba8d60)

## Test result summary
 total: 69955, pass: 58611, fail: 1787, skip: 9326, xfail: 231,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* kselftest-lkdtm
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
