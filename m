Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78A62FA86F
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407338AbhARSNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406462AbhARSNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 13:13:52 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24248C061575
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 10:13:12 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f1so4502338edr.12
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 10:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5/GffFuFlw745aos0mMDInR5/+1OnFdmMtYO+uUhg2M=;
        b=hTBOE8IXg/WJQ66zFYSGvoGHUPozmXKncCOT8pMSlyRWR3asl6sIr+i04xA0dnIUHW
         lDtKJ2YZk3ilWZuI6W0u4ENLb1IS7/WkylllRqeUq6PrSeVL4u+mvorhY/qpZwDKsV0p
         Y3FfbzSgYt2xOjgFtn/Iamfk9kIT+eamju/PqffYfXK0VMnYP8x0/mQd/dCz+YZ3n5iI
         i1ppUWdKHJowTuNTxR8zIfFI6FpK7y8a3DOkhVzS/ky9vFerw6Kd8zQ3hEYyunRPhf8R
         /2UqS2KFtSF1IH6pvdEaqmpBaZ0Nz8mYhxSqFkHgq+3r70hU10wNtoiq0PPs9TyqjmcI
         srAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5/GffFuFlw745aos0mMDInR5/+1OnFdmMtYO+uUhg2M=;
        b=canMV4rTGSf7k5pLuQxD2yo3TLrqddviFUkBgfBziXpgdgpp5CaeGQ6+y1FASUdvkk
         yEp+cECwwfPrNP4SidIxpHevgerI1ZswtXQkcBCnhMS70PgmmXcS8GdyGZtzynKJi20Y
         GXrkImXtnHUNwmK1bcCaEu3fItKIGmGqV+Ro79FxzEfWP6s+hEiotc9HXVewP6PGKd2/
         ZVFtxlT50+bCWFSgesZxVa0HRRV0jd5ECL+W2DDrBpp+zYokFg6ahMGXQpn6gCnul7Qs
         VIcvYRPKd69OWbgKrFC8oGVKGn4hrjaBAYYYqQs4r2mzeP9pIwTnuQx9bHiEnIXsTf2C
         XRfA==
X-Gm-Message-State: AOAM531huElI6FfzM2nYyls6fJIJMgFbKbqCQ3DdoaG/9ABCYwmUB8dG
        5ZkadTyoKYo/r0HBjTQlW9TrB8HjesOsJ9d4Q1/73w==
X-Google-Smtp-Source: ABdhPJzdNQQBYyQ0gl4tv1fQABCn+G+BKTLfUUbSb6c4hkGpkDFcC3Nue3bavrH7lklU+DAABx0KIFLa01lixsftE2g=
X-Received: by 2002:a05:6402:60a:: with SMTP id n10mr539898edv.230.1610993590685;
 Mon, 18 Jan 2021 10:13:10 -0800 (PST)
MIME-Version: 1.0
References: <20210118113352.764293297@linuxfoundation.org>
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Jan 2021 23:42:59 +0530
Message-ID: <CA+G9fYuvDpuK7Nt=eGeyBtOgwLZJOSBniONfc3YqqknC3FFp1A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/152] 5.10.9-rc1 review
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

On Mon, 18 Jan 2021 at 17:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.9 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.9-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.10.9-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.10.y
git commit: 293595df2bc42c77b0150d51073b49e09bb0d213
git describe: v5.10.8-153-g293595df2bc4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.8-153-g293595df2bc4

No regressions (compared to build v5.10.7-104-gc6e710bf849b)


fixes (compared to build v5.10.7-104-gc6e710bf849b)
------------------------------------------------------------------------

mips:
  build:
    * clang-10-allnoconfig
    * clang-10-tinyconfig
    * clang-11-allnoconfig
    * clang-11-tinyconfig


Ran 57479 total tests in the following environments and test suites.

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
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
* libhugetlbfs
* ltp-commands-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* perf
* kvm-unit-tests
* kunit
* rcutorture
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
