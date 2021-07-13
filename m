Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DA43C6DAA
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhGMJoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhGMJoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:44:46 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF35C0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 02:41:56 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id c17so40261215ejk.13
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 02:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V760S+BFCa7ilL2lIBS6aIO+txiTgFlFb8r9AlTPRQY=;
        b=jhtusCWE2SEkNo1yRkYuumNI6O2Ed5mw+5jTcxQ8MAhUhbTwTGZvfeqdBsvrNDhSL0
         OCmIVq0Ic5fxcDu8ezD+Eybc5nIZRunKNUC2qD3/WGHOOI7cEp35Aucb2hSOrk/4oNeO
         q+JpQrN7eOliGy7aX9pLJl6//jN1CORFXXPBpziAX6LDXiduse0f82vLXU5Oug8nKf7O
         qITuZ4xcZtqFR2FEaAEKASLG1cmddjZkD8rdrlbbxlpeTptLqTLINWnqJvdT0HFkABju
         iUCPeT7ms9hZOdtveJElLqtKUSBPBqjeSFrxh1xWEfZ3pG5u442L+ZjNUGHCyBcgrOPf
         GPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V760S+BFCa7ilL2lIBS6aIO+txiTgFlFb8r9AlTPRQY=;
        b=o/oLd1LyOvpZmtrR7vbdLyvAXoJZlLlQ7wnX+6+BvNGepem+EJlBRmq+A6tiErBtWL
         BG2C2k/CfUbGv9ss/XQ+QV4HXNVc1srkKUNhxjjdX7+6RA+zz3C8A8NYWav8+XXTW7NX
         STDcQ2pxSlrxPa6dLx9ge3P8rj23ELHbOGebLFfc7P2g8lnH9qPyXhml9MeNRw35MXDs
         yACi/dYAjS+8Nw6mbU9Lal1Eog4RWvtT9Kc6YcdgGVVa/P0t6ASW4tv15Xnjf6QJz6wR
         ZplBLJ+ufnvAuwIiweLJZ60RkcI9ZpKa+eemVG/GAvLCLcpMeZBOnL/OirWBd+RjgFZ+
         G02Q==
X-Gm-Message-State: AOAM531FoNSxVIgUM13sorygEdoQsod8Rc7HK3X2iVrfHUxjrwjAvbP/
        U7fXSUcKn8pWRKkw2Dg3ijaLpMwfEFcBnm1ZXT8H4Q==
X-Google-Smtp-Source: ABdhPJx/oAfRbJdMWcFwpcFQb4Ae0Ghug5P3pAR+sFjawYKU5RXW7+BU9bELuL/kb0hWcwAB9ojlF+0RZoyTW+jeR1I=
X-Received: by 2002:a17:906:4b46:: with SMTP id j6mr4557214ejv.247.1626169314948;
 Tue, 13 Jul 2021 02:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210712184735.997723427@linuxfoundation.org>
In-Reply-To: <20210712184735.997723427@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Jul 2021 15:11:43 +0530
Message-ID: <CA+G9fYuy38DVR0rCedjPh9gDkpEsz3g46qz+c+Z+uERyGCd90w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/349] 5.4.132-rc2 review
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

On Tue, 13 Jul 2021 at 00:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jul 2021 18:45:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.132-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.132-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 22b22e7110f52e9b2458fcb1a31aafea2590025f
* git describe: v5.4.131-350-g22b22e7110f5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
31-350-g22b22e7110f5

## No regressions (compared to v5.4.131-348-g9ff994b4b538)


## No fixes (compared to v5.4.131-348-g9ff994b4b538)


## Test result summary
 total: 70182, pass: 56914, fail: 955, skip: 11205, xfail: 1108,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 191 passed, 1 failed
* arm64: 26 total, 25 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 14 passed, 1 failed
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
* x86_64: 26 total, 25 passed, 1 failed

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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
