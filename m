Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA232BC33
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380904AbhCCNor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842995AbhCCKXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:23:31 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C269C08ECBB
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 02:06:49 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b13so19938870edx.1
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 02:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j6Z35wE+MtULjBnHD6+ImGDCWHNfojb4HqKmprrxy5Q=;
        b=gHkn2s4WYKafodlkDzVVCJEUlKiWzt99WW62l6Zjg6YwXQIE6X88bDLh2KjyDKbeWX
         8mEvwA8cJZiLTCRDGGFHvxMX7keDtjtAMwmueDVZV3aqHl306awX3wRVLSnoqb5v7rt0
         XS4XL+Ihz2CicgRJ+qql73C38ZF7WeSXnsFCl+AQhZBf6buTU+LZwLDYaqUCj8PqgylV
         6fsSGt/6EH6bhvgEZedJ00rnI8K4j/enPr1FEn57ZIpdKF8zUWSCfAl0QAAR3k9JxskO
         AhHpZ545Qb+k33hmnQbaV5F/rgWJiFKCZ8ZBGV9Ai/80NxnYbO5QfE54eue0yL4ilpP7
         8mIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j6Z35wE+MtULjBnHD6+ImGDCWHNfojb4HqKmprrxy5Q=;
        b=ZUy+5gLGQxnFOXpmIYOYkfPtJiVt3Iy7McB7oJF/T6xNbEdVhe2dlxMLPiE9GzNWSr
         AM3ZDbOrSfZQVr0ak1Rpzz/aqW/hEviLtk6fsFHlpRIed3Dfwz/2IkSN8CSGXGq+wwsN
         dKmOAo6TaszNYYSIYJFKtXMON3vRcWKnRhw9AmyOrSpWKuj1qLS1WOT+fY6d5hmEByqO
         c83slNWDW9F7qsZkvb5wwhnZpsLz0I4/0FIS+tBswrnkPcfCrgZxGns2bMwpiA3HIc6G
         Czx+IHFUsEB8+qnk38HFObZi4qiAQMs8KDDTmXNq3XT787EU4sZGqx03nnjLSzLPOR3k
         8TFg==
X-Gm-Message-State: AOAM530zK5iDflUVotF92eR8JEfGI4AZh3JHe9ugVOgs6vzbFGZmRM+s
        P1wEtv21S549zWpBjw3TUJZnGaTkvpY0jTOxvAHD4w==
X-Google-Smtp-Source: ABdhPJzFLDM6A6Jm5LfUDsEGiucIZUnp8kAfbfkJoUPepCOBrkYocWzW22ah04hphLEZNNPLgJA2dlYcd6dcEudFAUU=
X-Received: by 2002:aa7:d416:: with SMTP id z22mr24277955edq.239.1614766007878;
 Wed, 03 Mar 2021 02:06:47 -0800 (PST)
MIME-Version: 1.0
References: <20210302192606.592235492@linuxfoundation.org>
In-Reply-To: <20210302192606.592235492@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Mar 2021 15:36:36 +0530
Message-ID: <CA+G9fYur3FxTmQGdsnPbFUUh1YMTGK2UMFVdML4TgfMfvi8vcg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/337] 5.4.102-rc5 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Mar 2021 at 00:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.102-rc5.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.4.102-rc5
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 44433bdfc6fdb454620f64bf0148f3480a45afdd
git describe: v5.4.101-338-g44433bdfc6fd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.101-338-g44433bdfc6fd

No regressions (compared to build v5.4.101)

No fixes (compared to build v5.4.101)

Ran 44094 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-ptrace
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* v4l2-compliance
* fwts
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* ltp-cve-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* kselftest-kexec
* kselftest-lib
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
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* perf
* kvm-unit-tests
* rcutorture

--=20
Linaro LKFT
https://lkft.linaro.org
