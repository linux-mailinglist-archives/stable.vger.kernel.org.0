Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C333CFFF5
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 19:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhGTQch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 12:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhGTQaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 12:30:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F2EC0613E4
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:10:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id oz7so31580006ejc.2
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wxO/UYgYAY2uoBXq9Eg1mgpmsl7NnROa9Dwly16/RpA=;
        b=sQQehz247ibBRe5P9A1xruJWiLKHTob9qePqqxqU3L++YCrLlctFP3zCZcNlg/Nf1/
         Deq2xvcezaszK/r1wbAwvxYiTDywQyUb2DcDR5SWOCId6PXVeWoMYTdEdOEY524eaMJj
         vsPWFLmBdLfNgE9mj6bGM67Or8Pyiv3v6roQh23sG3uXZtJzllUKxXd2AqQSDfcZwBCn
         HuyimrV2o7KwliSu0yASj4bnuzUse6zd+/27jd4JEh4zRl52zJOMFkWunznO2C+nckmM
         Wgku1U7L2pzFEMpAbHmby4jFlR6QB/64XbEQf2WImdlCCcV9qQSJIcV4dSt/UG3fSeqp
         3M2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wxO/UYgYAY2uoBXq9Eg1mgpmsl7NnROa9Dwly16/RpA=;
        b=bOR+4qp1QcG8bKoGfwMcpLzHKRFpCjvIaa2DbUWn5Rp3TPP/AecJJmvK69CQzd/ObQ
         X2SfCL20WLWjkTX4Xu27AD8c3p1ba/DeZ6yCMWGHSCZL3r8bswU7Kio1UhVsFcQrczp/
         NufwoSi9ngjA7MCwhyo5XWL8Cj54yfQ5kgNgtiETrCa8mXnlg/a47gv/rbyvslCU244w
         TUtUlnC70cou11FwFZsizo0dhDVJhx0vii/kNhjT9/vrBoZ/3uHXur4KlzNKk4DYddj+
         0jUNMtI/G048+f67Kqu1/XvukXEGvdsEPEtMQRSX4B5JkBHSDmNuVXWnfdw6ci045LVs
         D4gg==
X-Gm-Message-State: AOAM531J7eYxrrIhqAhPrIR8Q0fX7OKRn4RPsZvE/A8WygLhknzh81jh
        SQM1pBYHOlR9Ctf5xrcy6QUslFUZCg+WdDAo5u3YZA==
X-Google-Smtp-Source: ABdhPJwPwNLAR8gWUPKBYB+LS3iR0aKjRhLvNcnKXW+SQB+kONnRHmChKQyU7q0FCk3usURBNglWa+SO39Mg/6DOTyg=
X-Received: by 2002:a17:906:844d:: with SMTP id e13mr33668051ejy.503.1626801050350;
 Tue, 20 Jul 2021 10:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210719184345.989046417@linuxfoundation.org>
In-Reply-To: <20210719184345.989046417@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Jul 2021 22:40:39 +0530
Message-ID: <CA+G9fYtFhfXk-NoG8K47QSMYdQL27qFSywNUKWOE9N6p0q03gQ@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/349] 5.13.4-rc2 review
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

On Tue, 20 Jul 2021 at 00:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.4 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 18:42:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.4-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: 1d9dba03aebe5171ad487d3ec69485c6cd17544a
* git describe: v5.13.3-349-g1d9dba03aebe
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.3-349-g1d9dba03aebe

## No regressions (compared to v5.13.3-352-gda668d1ed7a2)

## No fixes (compared to v5.13.3-352-gda668d1ed7a2)

## Test result summary
 total: 83469, pass: 68998, fail: 1471, skip: 11944, xfail: 1056,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
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
