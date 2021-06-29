Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD863B6F8F
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 10:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhF2ImL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 04:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbhF2ImL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 04:42:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F37AC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 01:39:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hz1so34941641ejc.1
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 01:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Ihh6r/yiOCC8FK7WVXakw7KuO/gas1k/LFq/CMxqIw=;
        b=W7ai1jx3PqJhHw6wkmJbdvIXvN29X6Sg/SU0vPMNlmWjo05iPBdMaE2yVk3DLVCHgE
         hS0HakC3wXcyIVecWOhcbKj8ta7wjc6z8XqPiL6nZ/6rwlGj+pUQ/ClNahC0OI2GyJqX
         uw57eeqxpBQ7/IfkVwx8iO9mPopuqw6zEIHFLdjLeIBbNhBEXAr/t7pEKeS0o/uPGWCB
         QZRMBrJyJYF/x0bJVgr/Zg443Hw7HFudhsTixSKD8sDv0PnYlNhbttTc1pLJIk30/uqH
         UgwD+vgumShL5yqByg/vJ7OVie7vJD3mQAYAz8QnTW/n4vR+9UVIgUbdQrBfql46Rjuw
         dX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Ihh6r/yiOCC8FK7WVXakw7KuO/gas1k/LFq/CMxqIw=;
        b=nUFMeUJQpcYprptlAQuYGKdqHyZTxYtCnRNEXKc9jknq5Od+IJW+ZlXEiNi2DDZ6Ei
         zuSbqhz4Adx2EXM/DtdkHY2WlqVstILsXDm6qoK0dKaNJAtmf18Cprez8pmLlDFVkbye
         2YX/oX6Uiq5glddz0g6vNJF/w4ovLMvim1DdI3v/DjTYwsmSeMLjoTSykgg8zrdQUhLn
         cBWY2Oh1+odA6wEIc/PcDf+I4WuL1+HNPS3PqpolQV5p2tn/BCXLBorcw3X5RRebIKFl
         bxdZmCKAQvKc7XTLbrc62Yi2cRW94AxL4qLbPG8B7j9xJ8UMCNsOUnbqbYTku/Af3zuV
         Nhhw==
X-Gm-Message-State: AOAM5315yM44F6CFHZnxqkMHXJIMJ/agnUJE0/KhnwOaGe7JerTaNTaJ
        b07BqJDRQ2EwJZNK59NznbbghwDCYa66TaBQw8WZzw==
X-Google-Smtp-Source: ABdhPJxTKzO48V3ea8B6W5ebQ4grMwaGmTD7bCRkySEidQTZbPogvLQ/qZHn3Yafb4i8kBCZHNoIQyJ0y3Rjlcrpd6E=
X-Received: by 2002:a17:906:bc83:: with SMTP id lv3mr4251512ejb.133.1624955981042;
 Tue, 29 Jun 2021 01:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210628143004.32596-1-sashal@kernel.org>
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Jun 2021 14:09:29 +0530
Message-ID: <CA+G9fYvFLhk4d5LoqcbTs-OoXEWfVzkGtmEyreYK2AKxoSz2tQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/71] 5.4.129-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 at 20:00, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 5.4.129 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-5.4.y&id2=3Dv5.4.128
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.129-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: aeef06043807450ba2a47bc9f5f06c23fc8d9ff9
* git describe: v5.4.128-71-gaeef06043807
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
28-71-gaeef06043807

## No regressions (compared to v5.4.128-11-g44abe5613656)


## No fixes (compared to v5.4.128-11-g44abe5613656)

## Test result summary
 total: 69899, pass: 56272, fail: 1308, skip: 11360, xfail: 959,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
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
