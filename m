Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A93CC7D2
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 07:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhGRFHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 01:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhGRFHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 01:07:22 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D93AC061762
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 22:04:22 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id dj21so18778310edb.0
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 22:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rFzhNJVn4/5g5TKed2W4Y0YBOzk/E7hhExRuMVxU4to=;
        b=i6g+PNm93uOYqgOLEGX2IJmUH0R++GL4LByjdOtJMsvp8w9W2+PmfGi4xPVX49pWZ+
         ejt4CjCfHUBWIcEhCaJDpcGHnJhK9XiQK3HEWGtOMpkzqwBrAJkcrejnj2vrZXqJl2Wd
         lBVc9MQa7eYCLwm2/YKotqiHQbjT3i6xX3nWg8mhq8oHzZR/NtmxJRdOsMQmX/+qZ4Ju
         xL59qdpnyTvZKVN0yeH8x+2tlg1aPQeqgkvzaHHnS/cpybri+b5Jqsq3wCKNPiaCT887
         WyQbCqJ6MaZoDY+YFUu9mU+JkLxbWQqkKnXSdOYVMZ5Owrn52s69WqEH8heUL15478xh
         84ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rFzhNJVn4/5g5TKed2W4Y0YBOzk/E7hhExRuMVxU4to=;
        b=toMUo57E7imm4uNTOSh3KO4YkUadpdE9WtV3uWXcTXgmv0s2p/+PH7pOZqItkbLmYe
         4onMOupGujfpP9UCFEClyhkPxxfCbbJvC19MNv2mf7X7GE2akh4o/6HWNSsgSibSjflj
         2PXaIqPSII6FbozVKfhiNByWysoZsulruLK1P/LVluLsp66O3tn0XF1WtlMqOJalL7Lj
         Yb7m3Vt1fLYbt0bnqDYdugziSnsqFCh0elatpgGYPrvphfCGraCRc61mR7UMZVGtfpM/
         znL800Z4zCfbj9ta/JgGeXZEX9fTNlrXNVPsWt6SYFl0H9QxkvNypkrJNoS4gK2mKhOO
         wQow==
X-Gm-Message-State: AOAM5322X04THVTTK2z7WtF4QZohuijdDebuLjFcK9oKZL5J0DflgXzy
        ArpZJx1uYEuhT/MmLM4czlB9GN0brykANsjr3EfgYA==
X-Google-Smtp-Source: ABdhPJw/PzMrALeG+qVdi4CglhD8RI0K8iqm2g3d9DWiniJydnau1MqcLtH4bFdDoOktEmDaNe6IGHDFpyWXYl5YXOM=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr25964701edu.221.1626584660056;
 Sat, 17 Jul 2021 22:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210716182126.028243738@linuxfoundation.org>
In-Reply-To: <20210716182126.028243738@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 18 Jul 2021 10:34:08 +0530
Message-ID: <CA+G9fYt8cckacXPO=XDb54ZBMcgPaoVCxOrBQAzoX0KVpXeZDg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/212] 5.10.51-rc2 review
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

On Fri, 16 Jul 2021 at 23:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.51-rc2.gz
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
* kernel: 5.10.51-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 852cfb3da450e5b3ef2833eaf2060dc52cdc6286
* git describe: v5.10.50-213-g852cfb3da450
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.50-213-g852cfb3da450

## No regressions (compared to v5.10.50-216-g36558b9a3bb7)


## No fixes (compared to v5.10.50-216-g36558b9a3bb7)

## Test result summary
 total: 78777, pass: 64930, fail: 1848, skip: 10804, xfail: 1195,

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
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
