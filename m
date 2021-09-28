Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D4A41B0A1
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 15:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241423AbhI1NfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 09:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbhI1Nep (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 09:34:45 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D762FC06177F
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 06:32:53 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 24so30048513oix.0
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 06:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jcc5M/hJ5TsSBGODGo+tSdpC3uu3e95alermn/eX+cE=;
        b=ttsUSvGiy+Sz+McjQcrSvBU/iW7H3OKy2+BNkAB/tmt1Ekc1bNH2So1j/W1mS1rFzZ
         Ys8UnyxU/mO5ZJdqqkZjY/mHqwVNv2V7CAUxQoybsuzIIrZyTAy6Lt9Kiy5lbytu1ddo
         1Jh0lAd2X5PlxVIrIpSMmE2HzR3IGtGeTfgF9y/PknHGU9DnDicEGwTDhViAPSyQL3Yc
         VYY5r18YRU19ej/SCJXUZgOuJXP7inE9yx8viX6P+Jyrl6eYpI1z/YJZ551OGPhhXSX5
         rpqiQdyBGlZKW6OI7BxE2Mm/92Aib/YoR7ePZCHXpvWpY/iQ6MJGuGbuXadGZrXii838
         gMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jcc5M/hJ5TsSBGODGo+tSdpC3uu3e95alermn/eX+cE=;
        b=6821cZkoutRks6P49BP1fyNZxTX7KFYt7Hjiax8gJ7cVNF1y3v6IkL/jt85JGDfqTP
         9IiqyMrY4wYwlpkCUT1SQ0Sm1HAKRzzG8Lz/S20lBc9iDEdAIuQ+C+uTRpoIIGyCfeOC
         rewmiAgotCEgNNP2whvz5onKjoyCc3JbaqFbJjP3K9XzL+cKRHB2ysvB2XpiV3sGbj7x
         siQRRZiV+tYepBZHioHXjqmvjh7fNUa85eO0W6LCngxyA4DBfubl5+XCCqyWgkQqJSh+
         wsiJ9LUfmf2GeKDPKqz7DvrT5qlzzd6otQCLuZwbVPsZDbxpn0rh3w1auXleoyiP2aCO
         VjXQ==
X-Gm-Message-State: AOAM530tgxY3xSGs/a6r9s0hl73ko9+znXmvIbwlRxeSsWMT39qRiPn1
        KMBASCrHSvJ9R+Cy/Nj4DaZAzFnF2ngWqmjQQ8bsSQ==
X-Google-Smtp-Source: ABdhPJxE36zmpkHYgPauHC2HF8joTXL0zFUeXQyKhBylKNEX5mr6Mc2H1hlyYS4rtjTRnQ9qVVBNgAYc2lcIX4uB1F4=
X-Received: by 2002:a05:6808:1a11:: with SMTP id bk17mr3724804oib.0.1632835972990;
 Tue, 28 Sep 2021 06:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210928071739.782455217@linuxfoundation.org>
In-Reply-To: <20210928071739.782455217@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Sep 2021 19:02:40 +0530
Message-ID: <CA+G9fYsqQgHuk4ymnDj6bFzPd7aHGHpw1FAKTOH38MhapKO_Bw@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/161] 5.14.9-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Sept 2021 at 12:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Sep 2021 07:17:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The stable-rc 5.14.9-rc2 report,

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.9-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 6ee566ecf2389b44c84362709162382d166f80c2
* git describe: v5.14.8-162-g6ee566ecf238
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.8-162-g6ee566ecf238

## No regressions (compared to v5.14.8-161-g60e33b5829b2)

## No fixes (compared to v5.14.8-161-g60e33b5829b2)

## Test result summary
total: 83664, pass: 69666, fail: 1071, skip: 12143, xfail: 784

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 277 passed, 12 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 23 passed, 1 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
