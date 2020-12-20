Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394212DF37E
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 05:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgLTD7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgLTD7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 22:59:42 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D58C0617B0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 19:59:02 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id h16so6389624edt.7
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 19:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CpVG5+20fZuuKagS75ftPUVVQHYk7FTwghfVPwE69Rk=;
        b=iqLCHTe8dsoR4Br8dJPTdUMwqhQuGfeQ00KTAae6kgLeU+QQ+ftEZxTWx6shQ+76wQ
         RcssaUjRZdn7yUFfeD0BmJ8f2hIK7fKYl8mE3I8THpspJbonFMxTUSC19jLV3rZgy4VV
         ia0sNASgslmNoOaKvBz6FMtan5/LemVhhjBi5UCBDEBv+3drhaOd1KDTmO0aBZvUCY55
         duQXZPn99pxAPHU020eqJVeltb5/6B5a4aaWBytMKSdJvoWGxdF70yC7xzzm5e1nTpXy
         3ZaDcM4Xhguop+OWzeiPBBvjlrOnwjcdGYW1jqFkQcSAsWHgtYZjiiXKCeKMVBV9friJ
         +IDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CpVG5+20fZuuKagS75ftPUVVQHYk7FTwghfVPwE69Rk=;
        b=jwYScw4XUHA2x2TpP07SK7UfZ8dha9sz4VevvT6jO2Dx+Oes3vOvh7xwQTeZYeByl9
         5az/nzxpgxNWIqBucIQpGpzFbNwVREzF8DUaBbg4NU+xDcE+Y8yMR50tfG8/0LbluMSg
         ZnaL0sHl8jBU4OEIibqgjJBIcYNXLoVnyqP0PDrR8GZyuvfKLYHENc4cedzkWfR/ndpy
         7QUg28DnMHTwd+t+Vbvo895oLDNbstQzsnl/3oxgk4QIl30V4NzuVhL4sPnoTrP4oTS1
         FYm4LSL7KznGtYWA2sGagE2TlVgiL8u7ICJObzroBW6VVtfJfkRWnyBcuBrbidyWg8wl
         O1Xw==
X-Gm-Message-State: AOAM5337pGlye2qvRkOvFK2lDCycwM6XszcoPs5/emCSod+ouVjjn526
        hriJu1rbOWx0ZbSJH0/az40m6rvr3YM5lB8c3Zn3tA==
X-Google-Smtp-Source: ABdhPJxfdM0tqyOlmoBkQHv6Y1wnQXSVD+wdrjhwZvEh0WHqxNtjxIW4qrByHs5f/U4gq9K394wFaqeR1zar6yaqOms=
X-Received: by 2002:aa7:d75a:: with SMTP id a26mr10759019eds.230.1608436740594;
 Sat, 19 Dec 2020 19:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20201219125341.384025953@linuxfoundation.org>
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 20 Dec 2020 09:28:49 +0530
Message-ID: <CA+G9fYsHWVvU9XG2vWhuUaKt2wgsrCP9=ohHv=DOnok4NmiDfA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/34] 5.4.85-rc1 review
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

On Sat, 19 Dec 2020 at 18:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.85 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.85-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.85-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: bcf35e05a52636bd982a253c1ed928d3b128a332
git describe: v5.4.84-35-gbcf35e05a526
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.83-72-gbcf35e05a526
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.84-35-gbcf35e05a526

No regressions (compared to build v5.4.83-37-gfbaf54ae613a)

No fixes (compared to build v5.4.83-37-gfbaf54ae613a)

Ran 45558 total tests in the following environments and test suites.

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
- qemu_arm
- qemu_arm64
- qemu-arm64-clang
- qemu_arm64-compat
- qemu-arm64-kasan
- qemu-arm-clang
- qemu_i386
- qemu_x86_64
- qemu-x86_64-clang
- qemu_x86_64-compat
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- riscv
- s390
- sh
- sparc
- x15
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* fwts
* install-android-platform-tools-r2600
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fs-tests
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
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
