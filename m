Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E66E34E233
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 09:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhC3H3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 03:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhC3H25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 03:28:57 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CA9C061764
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 00:28:57 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a7so23288666ejs.3
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 00:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cl6L2IBQ3wgEzOG94OkV8F+rjBjAhv9soo/p9TB1rpg=;
        b=LuO0WMj9epMk1yY5qnZlYVbpSsSuWXlIoCIakVSURZSACuZCoqWZjAihTR23NpQ4l4
         tOIdxVg5AlSyfeg0GNuLEGgA0uGqKAsKcX+REBqQ/00YO5jWOaF/776YwFMlv4JY4/Uo
         hlje/p7y6sjkaW1AneqQjcaD1rmU8VmGza+e4ukrhdPonMEjsfmF+//9/SBPNvrNAwUo
         IjKYgYjoNdtPjBhZ1KjzxGxatdA12ebrUpXnQWV1DpNepu5O59y+ZfGNzhNFEHyplf8m
         yYt1o8DVY6iYLGB89QqaecOzJGtZncsVCPtoqxyT0JTBOeVJiruk9rhYmZS6hDWPozqw
         r0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cl6L2IBQ3wgEzOG94OkV8F+rjBjAhv9soo/p9TB1rpg=;
        b=tlXtLd0kTlx1p7ytyhyr63gda0OVeW4Gg4Rj/j9ZqtO5zyoKeY2Y8LGRk+CjfSPz8h
         FDr8AdUA4uNNcUKTAndSRM5xqDF8JKVb9z1YNqXVkGkrVhoFbAD1kHkctpWckHQmItqu
         imvfClwNgFTN+ecG+oBdilHlT9yC9LG7aNmy0dIl9xNzTvp/dS38WhulnQbQazcHPym4
         4z/ce6kJJkaMHNEhxKFKG73cPbX39l7d2V5RTd57/F45S1uCYdlgOSlMdpw61IqUmIPV
         +iMEPl5OkpNUTTcL3B9eOvzQdm2wgw1NNdQPBwGF1mtYcwTP+s42h6cu6z6SNtzZaql6
         2fxw==
X-Gm-Message-State: AOAM531mE1qTfqu7plOdMgOvBGWUsEjaoektpmOOeG9xwlQTkaCOfAQ1
        EK6Ml5wAJxD9cVIGrGIt5/ArVWp0ekf9yOvhBcW41g==
X-Google-Smtp-Source: ABdhPJxNO4z6HM8JuRrJJg/yspxvpVbZd14LofFRTMNsYCxVeA8pJNuj0xV0AC6sVFTiJ0PxX3KvGA3JZv0JG7sSrm0=
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr31193079ejb.170.1617089335880;
 Tue, 30 Mar 2021 00:28:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075605.290845195@linuxfoundation.org>
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Mar 2021 12:58:44 +0530
Message-ID: <CA+G9fYs7rAQYhj1mq59C=qn_6dX6JkG1pZ0LqCKmazdW4NHk2Q@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/33] 4.4.264-rc1 review
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

On Mon, 29 Mar 2021 at 13:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.264 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.264-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.264-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 5fccbcb46b8844500db24690cef618c294ac0ca5
git describe: v4.4.263-34-g5fccbcb46b88
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.263-34-g5fccbcb46b88

No regressions (compared to build v4.4.263)

No fixes (compared to build v4.4.263)


Ran 34815 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm-debug
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-debug
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
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
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-tracing-tests
* install-android-platform-tools-r2600
* kselftest-sync
* fwts
* kselftest-lib
* kselftest-membarrier
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.264-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.264-rc1-hikey-20210329-975
git commit: 094469e4d2aa566c4760fef99d768edd36eeac85
git describe: 4.4.264-rc1-hikey-20210329-975
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.264-rc1-hikey-20210329-975


No regressions (compared to build 4.4.264-rc1-hikey-20210327-972)

No fixes (compared to build 4.4.264-rc1-hikey-20210327-972)


Ran 810 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
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
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
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
* kselftest-zram
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
