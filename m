Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDDC2DA653
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 03:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgLOCfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 21:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgLOCeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 21:34:23 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF400C0617A6
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 18:27:21 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id lt17so25460595ejb.3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 18:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I4O3WHYBU27kv8r3Q3lI0IyLOdhvpxutXMzDol4vSCg=;
        b=KhWzVlWSyOs88yQhMHCDLSIVQ3xif/YPV7Jd7LbuTTykuExZgCpEqqVg8LfpoVDEsb
         ARoxpeUC78vu6dzhdCzbi7RFzieuM+Jxf3YuBSccQ+MMwKqhR2b3lN+0ZbcHmfq+aLZn
         eog0RaYKhhT74/Wy5RTeipeHaD66TfMyGk9n1rukP6Jk9Lna1zo5ter3zk0502G0d+OQ
         ITtl2CEdLO1FGl9wNT8c3TGwcruUG6USEk1xgw6RzZx4oiisvM8zWULc233pcG/w+ejk
         vQXVOsxoLxq+Kk8oe4ViqLENkvin7Y0x54o1IL21q0l94YAaD/lKLV2jvwNhZaT7RWfO
         0GbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I4O3WHYBU27kv8r3Q3lI0IyLOdhvpxutXMzDol4vSCg=;
        b=e3NQMg8ZW8+K+d6pFyDToeG1l4478CBNV9m6PrPN9N7hMkoo4O+1Qv/l8M7jisnUfX
         6yvqnZ9ShtlRKT2+OnrFKvg7EoVQndRyorpEY0R0jAzi8Ht4vlKy11U9JM+Tz2qm0MuQ
         6EKv0OOjIQGnaI2fO+bI1iC9NU6x5ViZQnNWIP1hPh7WUbdRyH7cS0qdew4tCVl9e2R5
         aZ7e9PROGVIdyCAZBHCwoUuLsaEANAI3FeIura13pWL6l/99x1ZNxxJQ2xoTt7Z4uO5z
         AId7T33Nr3Sl+205cAe3xWhCYtZCbhSvFYXIplLtx92kGXqI5MTDmQsU4gNParP68Ifg
         LhfQ==
X-Gm-Message-State: AOAM53329vKjtoMkP2bjCEVB8LG/0clR/XFa2HsIRWdfnODm/dkZZnTH
        gw+CCtlPAyTlEYU4a/Ta4Y/tTe176R3pDwEIaGlpyA==
X-Google-Smtp-Source: ABdhPJywOHSnUwWyG0v3cm6dkD0vz5G9XokMtjdBAUSQE+WYpEihqM+GVjVgVJ5EYhAcDwjEmN5zU6NB9/XwzM+4UeQ=
X-Received: by 2002:a17:906:3499:: with SMTP id g25mr1216306ejb.18.1607999240315;
 Mon, 14 Dec 2020 18:27:20 -0800 (PST)
MIME-Version: 1.0
References: <20201214172555.280929671@linuxfoundation.org>
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Dec 2020 07:57:08 +0530
Message-ID: <CA+G9fYvMqG_ai-_sfPGuxxjyZ=3QiabPZhFFY=m_=Qa1aKAL+Q@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Dec 2020 at 23:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.15 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following warning(s) reported on arm64 Juno-r2 device.
sched: core.c:7270 Illegal context switch in RCU-bh read-side critical sect=
ion!
https://lore.kernel.org/stable/CA+G9fYtu1zOz8ErUzftNG4Dc9=3Dcv1grsagBojJraG=
hm4arqXyw@mail.gmail.com/T/#u

Summary
------------------------------------------------------------------------

kernel: 5.9.15-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 609d95a959259ea4ab7ecdc39c3151321a6a7032
git describe: v5.9.14-106-g609d95a95925
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.14-106-g609d95a95925

No regressions (compared to build v5.9.14)

No fixes (compared to build v5.9.14)

Ran 53718 total tests in the following environments and test suites.

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
- nxp-ls2088
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
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

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-sched-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* ltp-controllers-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* fwts
* kunit
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
