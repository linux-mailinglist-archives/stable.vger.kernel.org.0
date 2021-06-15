Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90253A81F4
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhFOOMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhFOOMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:12:21 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BCFC061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 07:10:15 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dj8so51317048edb.6
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 07:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z7ERoyZlszjmyu3iV/Mmi1jHGzP+hRT7oKekWXQSxYI=;
        b=fSHp8+D+TzQvipTX3sw9SFjSToDoa/gXDp5DdIMHITuusSh+W54p/Bq03Azr5IK0kj
         gPLbtxkiYwD7WxHKSGZo7z9zRwaPWfX/3nDfs0vRH9iyNA1bJR/6dbrqFvKv2g74KE87
         R9In7ovBzKiDBWZY6u9nkqJ5OEzZTGJMXZVfX/sGf2LKfXG3CRbb+Lg2Vkam2+CIrQ8G
         LE898AX8+NBExSdsiQ4JPvY6Pex7Mb3YwvwzIGFTo7z6stXCFjqQfgIbFZxlVXcAz79h
         N2pYdp14UGs9eCagySzy5nUWQBKADpZGrhtUvxXqkdAgElmWMye9MxoFyuF7bxqevml7
         tX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z7ERoyZlszjmyu3iV/Mmi1jHGzP+hRT7oKekWXQSxYI=;
        b=HRBUCebfT9clBYP9LxnKmCuobkdJweYcRLu0aL+C8GPVaMdVk0uteZNiHGk9/Gjvo9
         YwNCo6lOxyaNfr57EcIAYVyyL4ony6zCt0M7LtHfYnciC/4oBxG4RwsRyT0zke3/WiZb
         g6wcxHc0tGuTojn9R4eUIFlckgSpzVqWyIDU2v2G0RjyJN4YrMz/HHoNdd2u3v5ogCHB
         AqQIQrU1lDV5b8Pmj2QcJhIcQNr8FZF+/1aab6bQIGQbJu04VOGsPvSlmqq5pP4XzjA+
         njXhEMgvOcIAV1WBpSQslKRFxs8KZmBcOO+RLuWO3xglrhiB3NJHDxi4NuYg2smUCTr6
         60xA==
X-Gm-Message-State: AOAM532o+C6zX6UTXM3qo+gapZI685MBV4fLMgiLRNA1DNAKV0+Memn+
        QwCysWrjQCcp9aQ1DusMZW6oRYPoTf2nG6T4f+g8yg==
X-Google-Smtp-Source: ABdhPJwzC/zxm0+VSm+Z5QkQpN2MCu+AWiPsD9juTr0IDIXspmLXX034Ws5YLgo6dOm8MAvA6IiAHdd5/HWeKBfGpf8=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr23209607edu.221.1623766213710;
 Tue, 15 Jun 2021 07:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210615060657.351134482@linuxfoundation.org>
In-Reply-To: <20210615060657.351134482@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Jun 2021 19:40:02 +0530
Message-ID: <CA+G9fYu=x-8OXBev2gKGXh1Ee+TvuKvZ+gkvm_N3cQg5d_Yf0Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/41] 4.9.273-rc2 review
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

On Tue, 15 Jun 2021 at 11:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.273 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jun 2021 06:06:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.273-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.273-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: c59bf94474162a1e1dfc71da00c35fc2eb3d6e81
* git describe: v4.9.272-42-gc59bf9447416
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
72-42-gc59bf9447416

## Regressions (compared to v4.9.272-43-g69603f537df7)

## Fixes (compared to v4.9.272-43-g69603f537df7)

## Test result summary
 total: 60444, pass: 47320, fail: 1141, skip: 10719, xfail: 1264,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
