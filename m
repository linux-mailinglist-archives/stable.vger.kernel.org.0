Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEF936BF67
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 08:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhD0Gp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 02:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhD0Gp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 02:45:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1190C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 23:44:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id t4so4679132ejo.0
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 23:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=beVnvv3fpjAijDUKHOzdEO5d+t6max0lfbKi6YhHc3o=;
        b=Sh+1mNElMZpfxlD8S1nbdxxWcStFZaiUudpF4XOCnrzj9rdHZa0nc+DSeAsct0NyO1
         mMYnhSiLw+JQB7DXpX2pNdp289WQrow0VxiMYfHYHtUtqi9vAjcNYSSRGwryOcHnf5Px
         WfU47lmiEZzVKzaV6Ff01tL8bQMSIDR/bsdm+uAlSZNy+t1QXkhDFPwNUtzIrnl/b79y
         yuQM0L8g3b8MweyqMM39OuJFVjbLdBD42i7KsQQjgstypWEDwP7ttNcabDJom2f8A7GW
         +AkPyOP7NpFOuTUgX4A9NNOJuWpCCIh+gqubLv24ee8qcXyzgjD0OwwRLqmi3Jf7n1K/
         PwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=beVnvv3fpjAijDUKHOzdEO5d+t6max0lfbKi6YhHc3o=;
        b=eu0dbSZkMuuQGwx8FGiBR2iXLx02oS2Smh/DZDrVAQMW4I7F6bamQ1KM+m4bAyAVaR
         gs7CsS/Wnod3sa7ShRvmenr1tcgFxJp8zpM8DUb3rIxGnRd+e8GuaVcSFcw7oLeKBPrN
         I36WUMjbWYGzV1Ee5I+3FWFttOMDTBjDDldVhgLinw9ZCfWuxc5rA62zYNX8whFcny/z
         DJA4QIZ9m7QVTURK7EJMIlyBe8KNBlJ4f+nZXhDxewlVHlLa//wv0vSmaEBfcYhL3nJK
         Pc2//buVIi/+KENtwFgz+CHW2kKbkEIALIVDqbOO1Tlb88LLJP3HaGCVqjF8Qp8aWZF2
         WeFg==
X-Gm-Message-State: AOAM531ZYqKCPFQWENGzfmckQcTNydinjdKbTsX6q+GZFnaw+sD7TVJf
        mHheIw+bHWuQ1X5URfjA+q8qkz5G8r9N8wUsvaYVcA==
X-Google-Smtp-Source: ABdhPJw/Z8qx5TGdrUnWuHNwEi+0Idt1kGmFEmjXmNbt2JnYYcztr3o9pMisPRVTq8NsqwbcNDbn/9y+ROCSa0XE+t0=
X-Received: by 2002:a17:906:4f91:: with SMTP id o17mr21790698eju.503.1619505883483;
 Mon, 26 Apr 2021 23:44:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210426072820.568997499@linuxfoundation.org>
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Apr 2021 12:14:32 +0530
Message-ID: <CA+G9fYvVNMyZmDM0ocdiWYvf_3sySqSumGUtHM-Mj-3J=1ZQng@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/57] 4.19.189-rc1 review
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

On Mon, 26 Apr 2021 at 13:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.189 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.189-rc1.gz
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
* kernel: 4.19.189-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 6eafc8cc1bd738ad08d0ea63ff9ea73c492b295f
* git describe: v4.19.188-58-g6eafc8cc1bd7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.188-58-g6eafc8cc1bd7

## No regressions (compared to v4.19.188-45-gb0e11de9a516)

## No fixes (compared to v4.19.188-45-gb0e11de9a516)

## Test result summary
 total: 68591, pass: 54673, fail: 2708, skip: 10962, xfail: 248,

## Build Summary
* arm: 97 total, 96 passed, 1 failed
* arm64: 25 total, 24 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 13 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
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
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
