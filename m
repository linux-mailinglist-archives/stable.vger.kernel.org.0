Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD64B2DAAC4
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 11:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgLOKVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 05:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgLOKVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 05:21:51 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E685C06179C
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 02:21:11 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id p22so20360923edu.11
        for <stable@vger.kernel.org>; Tue, 15 Dec 2020 02:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JXcGx2jenesWb6fqnrjEqG0cD9iirNhFOsWSUwW/YMc=;
        b=vnO11rY5FL0deE6TdZmSZmxbtEwvg8j4iclpRsIeXkayazWuDfOWLxNwKWnJ7jtrwk
         7MiO8Sb4bEmGuHd7hjejPIP0RW+lslw/wRkTeHzv/AkKvmBCDRpbIgm/VnQ8/D23dTCb
         SPQ30rYAUDxhKTVKqGKJ8Rx7UZaqLWN7+eMswxRZjKgPCCIuhyMzlCBDRdxSOG1BMV1a
         lZ0MbMrzTl5oBgQ7kqWeQ3UVVg6672IRzhpp5enFiNuMNhDLLyRM+ccNTkCUW7TDS0j7
         ikg/gRbv3kMo3mxuKK/5eI5ObiNzkJlm9vEPxcdzVBcMVDCPjOO/04RMup/N+qZtHj1H
         PNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JXcGx2jenesWb6fqnrjEqG0cD9iirNhFOsWSUwW/YMc=;
        b=eAKz3Y+E3up3+xpIXSiC7UFpaSXg8eQMk+fey3x3Z6RdS+Y87GowDDrPvCT1IU2dKo
         rtalEGgIYQ4rbqxeO8NCvPJC218yhmTrx1wYT1MMLhk+rVxYcT23EXQNbi0bfIW7PItZ
         qhwHiHG9H8cwBViVW+vs3tE1Zfi/AmSPrWsMEltQTqccNQAVx4nI8698XDZwC2p9chSb
         p9WZpNEMxYM1Gsx+XXYdBRIvIylVDWvQ9vZGpRFR+TiT1v4UdBmfIGRlelu3jzdMWyi9
         91SwDU+XbAvqaqAubywq21ZtNGeYr6rQdkys9cgENrUQCNdlKJ/er+bllilSJZHDfRRh
         5pdQ==
X-Gm-Message-State: AOAM531skZNSl7ICDVJF13GCjqQ4uylrw5cmZlZRBeceTsA3GlW6Ew18
        CKTNKB9CYLXZjU+xykgJU/FztHJirdgHqsaTNPDNg23zI3Xeo6fG
X-Google-Smtp-Source: ABdhPJyDd7k1lk95dnV9stAoTPcXWykRCnex3DxF9MOxP501c15/EAzgdmGVGOGBFWcrxXsRS+SsSu+WssFUr5n0EY4=
X-Received: by 2002:aa7:d74d:: with SMTP id a13mr1759578eds.78.1608027669805;
 Tue, 15 Dec 2020 02:21:09 -0800 (PST)
MIME-Version: 1.0
References: <20201214170452.563016590@linuxfoundation.org>
In-Reply-To: <20201214170452.563016590@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Dec 2020 15:50:57 +0530
Message-ID: <CA+G9fYvanzter2c+H8HH=_PCYgf6DHHKihD2SwzG2+P+yGpz_g@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
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

On Mon, 14 Dec 2020 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.1-rc1.gz
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

kernel: 5.10.1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 841fca5a32cccd7d0123c0271f4350161ada5507
git describe: v5.10.1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.1


No regressions (compared to build v5.10.1)

No fixes (compared to build v5.10.1)

Ran 56654 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* perf
* fwts
* kunit
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
