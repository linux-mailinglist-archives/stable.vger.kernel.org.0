Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC8D30D681
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 10:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhBCJnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 04:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhBCJnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 04:43:47 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94C1C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 01:43:06 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id df22so10085850edb.1
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 01:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5K1Jql4Qu8ghC4/Nv8cwnJc9qqC4VK9QqHHvwmFPkl8=;
        b=aqJEu/oq0/MQbzpT3jw9MX6uLrVbkC8QZndasPG7U2dOxS7k34lGiitgvDtwdbfKSy
         htMw/YeUjTifKQ3HLgocLo0Ta0/ZFClVgZcJyvD0pxZjuqPK8o62jtFm9jVp6YbtNg2j
         pI93MnVzGt641m/tk6zzozv4Da+ehoasxtgBMzkW8SKjanbq8Mf+ZfELU//2UxEsQOge
         afSmgJEcqdzeM+jH8/u5uU8aSR1XY2090OS0IZ+HHdLRiQhKTat1N243oAo+hmfSaEdQ
         +EYQ1Kgmz2qn8kQRm1x3S+Fhntxcx6qPXFqm7Ve2Z/+0aLV6QUn/MDhx3+0rhn9m2cKK
         z5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5K1Jql4Qu8ghC4/Nv8cwnJc9qqC4VK9QqHHvwmFPkl8=;
        b=WBerj/ViQ5Fn3byu5f48OwPMFt/nvArqzU8bBO/SxQs6YXSoLvZQkjOKvfwwIsh0ap
         1bCDcH0XmpMfT2mK14HT5yzmL1V2kSZceQLii9oXiLZPOBfOJNwj7bDRh8vicF8dTtpI
         hi7oMDA2JrMjHFcaeXsA+FhroWGO6HOXS6MWs8RMvgoACG2iKjL8C0ocH1c0/OOLwYfX
         MBvfb2ntHcmtmzwzpb7IHqMtHziyQONwoZtgFoEuazVF2junOhzMnnufNSexUw/242FD
         dMbeVQgNkDFCNu/f1Bm4rUJ075CSsOyn7cGQXN22xcrz4GVGNZO67PY/1Act3QWaK64Q
         EfkQ==
X-Gm-Message-State: AOAM532JISudpQHcOCLqvwrBIw5cJ4jf0F/K9TOqItf6NVE09sdOpX4u
        xGbOvHI0dTO7gu5HTWDaUZOtn5sNdtAxgW/FLLA47Q==
X-Google-Smtp-Source: ABdhPJwlkXGdxZAkwVp2jiFsru39QGYjWX7OHGO+SAoFK+mS5LeR+lumA1gD45j5LoR9FnwSRRjaz4MHFrtpiksJnQg=
X-Received: by 2002:aa7:d3c7:: with SMTP id o7mr2043768edr.23.1612345385379;
 Wed, 03 Feb 2021 01:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20210202132942.138623851@linuxfoundation.org>
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Feb 2021 15:12:53 +0530
Message-ID: <CA+G9fYs6k9W2rd-WUJD2ba9a8GgnriHBzdBBO0XJq5U3yXya=A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/30] 4.14.219-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
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

On Tue, 2 Feb 2021 at 19:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.219 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.219-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.219-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 17dd434cff6bcaf79221b1a890a9df7ea23a3bd7
git describe: v4.14.218-31-g17dd434cff6b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.218-31-g17dd434cff6b

No regressions (compared to build v4.14.218)

No fixes (compared to build v4.14.218)

Ran 43689 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
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
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-ptrace
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* fwts
* libhugetlbfs
* ltp-commands-tests
* ltp-math-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* kselftest-kvm
* kselftest-vm
* kselftest-x86
* ltp-fs-tests
* ltp-open-posix-tests
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kvm-unit-tests
* rcutorture
* ssuite
* kselftest-kexec

--=20
Linaro LKFT
https://lkft.linaro.org
