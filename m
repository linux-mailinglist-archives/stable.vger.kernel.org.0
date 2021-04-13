Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECBA35D755
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 07:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244688AbhDMFl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 01:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243886AbhDMFl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 01:41:57 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61473C061756
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 22:41:38 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r12so23949468ejr.5
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 22:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/kMw36zWxGP4H2lobjhMKMAuy6hEt2CpZcO99mt+F8o=;
        b=AN6wozYrxc2+Z63+sftHerBq0hRnhp0ClLvFmO7LGIZ0Q8TlHVBFqppXhqQm+irYO6
         wvarjikyVOD4S3YCilLEkAIVIfO75/VQwYoPoigslk0hq26K42RUGtMYT/MUbx+9b6d8
         dPupPfNZrGZVUCB50KRFW2guUfNASMEv1ujYT6BJ6X/DUbwpJQsgIQ3O68LWiANPNmye
         S8V3a4ZC6iizcvmDYfIxixpgX/CN4X02mN3EDNCTbNdV6Esl4VbEcAHNHaJZEXdMEUif
         28ElQNIB2Suj2t+8nt9EX3iLaGfoic96e3kDct0vEHCk7silCfsMa3B6e4y4TabA64KS
         KFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/kMw36zWxGP4H2lobjhMKMAuy6hEt2CpZcO99mt+F8o=;
        b=VsdxmT94QMru6haE1iUr8I7U2pwysP8uiVUW68VFuzJiTkwqrO02x2z+W/SXsoPyGs
         maq8yRd+TOSDVgN2AbkuOebsigS6O8FLa62dTIicwT3Le8U4JL5UeBVmDTK3SzH1US47
         8HYn8DRBgu8NbgbbMPq1OCnU3CS/h88CCdLPVuMYg3wP5Ub/bxGP0tcaW51XDKthumpM
         7Io/WsQCVPQ7UqdpOi37V86G+VopDd1UN9dBK8/hCXaDnboUEz6iVhraVxqcDelCxjfC
         1RjOd0mMZFr+fadTjViZ/A/goDyAEFsQvOb7UyPm4UdrprPWfEGLVBNXAvo6/HUPS4dq
         Cvyw==
X-Gm-Message-State: AOAM5329XC2mgd+kAf7JoxWYcug95WLt08UrENMDEAyh1zy8A1zP2S3H
        kHdZgBFvGFaDVfcdz/N6I7EPGidsKW9rInuVytMUFw==
X-Google-Smtp-Source: ABdhPJywywcH3eH6uMLv87dO08x+AXuJH9rMy6Rka+BEXPwvJAoDFlH7QVrVcFP+vUUfTozwZ2U88pdfnxfeiybg/QI=
X-Received: by 2002:a17:907:98ae:: with SMTP id ju14mr2965643ejc.287.1618292496904;
 Mon, 12 Apr 2021 22:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210412083958.129944265@linuxfoundation.org>
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Apr 2021 11:11:25 +0530
Message-ID: <CA+G9fYvTQSAs_UZx1=kbOz23HvNF3GtixH17UpEQFoH0K6Y7uA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/66] 4.19.187-rc1 review
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

On Mon, 12 Apr 2021 at 14:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.187 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.187-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.187-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 85bc28045cdbb9576907965c761445aaece4f5ad
* git describe: v4.19.186-67-g85bc28045cdb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.186-67-g85bc28045cdb

## No regressions (compared to v4.19.185-19-g6aba908ea95f)

## No fixes (compared to v4.19.185-19-g6aba908ea95f)

## Test result summary
 total: 65010, pass: 52744, fail: 1575, skip: 10433, xfail: 258,

## Build Summary
* arm: 97 total, 96 passed, 1 failed
* arm64: 25 total, 24 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 13 passed, 2 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 1 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 14 passed, 1 failed

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
