Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299961D91E4
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgESIQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgESIQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:16:10 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CE2C061A0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 01:16:09 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id g4so12727403ljl.2
        for <stable@vger.kernel.org>; Tue, 19 May 2020 01:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BjTBKYbgfQA5s94+kOx4r3jcG29cEry1R5hVu5dFmbw=;
        b=RYFFe8PinN5tjtTTYBG0NuoUy1gw1/GZRXCJOkkwHtjI+i8x8W4qFwIcVTVhqRUytx
         qzrv2QqUpfl5b8wL7NH4mfC9GpMaaoabCYNyAxiO0mOqwDmbsK+x//q2YRrxx6xhu18f
         8JXlZaKNClxp0zXkdmru/zrOzd9jfearAW0S3uSKga7WW73/jn2du7LxlVl6cTOKljIb
         DfHVvGrwVZc6LXBdj42B5XthQq8bQzMU/AI/eo8LppM7FsFqDABHDzC1DzdyvOTmhByZ
         uguAxF7n3dbQVI7lIgAsA05fGRHPdmi3e6v6oNXUdgzvdPYZfgOSfttlD+bYtDaDVULx
         Rwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BjTBKYbgfQA5s94+kOx4r3jcG29cEry1R5hVu5dFmbw=;
        b=E2BfwRMUdOFNX4te/s1D/QRQvSxO7Y111cbQCgqzen1Qu8RAJnTznqIqJctqfz7U/l
         FaBHQO3D5NvmMlyVcqVruKM9FDHYvwwaHCM+byPNg0m/RA6CYTImuExgVU77gSDrj8RX
         AMoWkrScFaoLAFjDVejEVVk+kZSLaLnvx7azw08fut4t4n0TtRvAQycjbLi0CLGkJbv6
         Qg4rOvfVl17QBV5gKVfY4GRclMKyMWlVqYB1UKQCCDVUURxpVRhTHQ4cP3bIaDPTccSF
         9qDTmDiYjWtkoWxuYgdt2JbFO/CZP3V2nrZ7ZTbbdZy4BvaUsFL1+kX3fjLe0dkEtKU/
         MKBg==
X-Gm-Message-State: AOAM532JUKJtk7sF37iG/yDwkhHZq3Py0ITktGUhowi8wI3FIzvDD+5W
        3AHQNbBW5T3JHxCkxg7O1fpSDtOF+U/NVXVdAD0Q/Q==
X-Google-Smtp-Source: ABdhPJzsA7H4sHipfjd7HaEjwKIUo79QFhef3eecrJK/YFKOd5AFF2gHq0QiAftKiUs9wvNLt6a4drLoUrcdEJ7+ys4=
X-Received: by 2002:a2e:9455:: with SMTP id o21mr13203272ljh.245.1589876168311;
 Tue, 19 May 2020 01:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200518173503.033975649@linuxfoundation.org>
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 May 2020 13:45:56 +0530
Message-ID: <CA+G9fYuPzr_BEU_ytPSDW0B+khsUFMJt=t_W6BO=iLrxd_7Q4A@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/114] 4.14.181-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 May 2020 at 23:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.181 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.181-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.14.181-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 53d55a576a17377e7713aa3aaeee0f35b06a1f73
git describe: v4.14.180-115-g53d55a576a17
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.180-115-g53d55a576a17

No regressions (compared to build v4.14.180)

No fixes (compared to build v4.14.180)

Ran 32429 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
