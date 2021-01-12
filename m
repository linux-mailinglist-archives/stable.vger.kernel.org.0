Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A44F2F28F5
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 08:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392024AbhALHcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 02:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392023AbhALHco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 02:32:44 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B2EC061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 23:32:04 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id t16so2024269ejf.13
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 23:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4oLu2sfu7T6rmbtDucSQghvGdmQoaOx677hR+mIWqSY=;
        b=cE/hq3RNKR7NvZ1Y7OPmkA1ZpixGafxQaZkhxbSJmopqjCBpEGC7lIMl8R4Otyzf+W
         ncgHQvponhR57+93ve2JGEsNS0ZyAZVpaeWChTim5BWtzjLPkeTF7GM3XDoyWdrFS29r
         x18VOLYpGAR/KGDmGyGD4RE6RF0Apm6g3whOCY0UM4Kgwh4TTBKRtDt2YOM7MhRyW7os
         N6jbqVitk5ccZjE0ks8jmcZxrjn7aYa3sLAE8poBOlu+7Sjv4uNRs+kC+ZUYDSpFPzYX
         czkUDN/5EGcHBZVcK6hx2WJ3dD3RkBY7nw7LeOEnoVhgXNZT6KiNMgqehnz40hDIF0im
         +eOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4oLu2sfu7T6rmbtDucSQghvGdmQoaOx677hR+mIWqSY=;
        b=GFCle9RDWu2Eg+nlXsnprJJqWhQMO+fNZJt+C69RC0EizvZjULIwh7avXvtrL/un2g
         SxVJvnnAbE4GVjYbuaetEVSHJECxCDTGbOW1qlLvFBjk8l8UhRqISeP7nwiREJcLaBNo
         NhlcaoGEFsn+MiWjc9n2OriTKoaci6u+6znOlEAMTz5uhzdGvoVqo/ZVy1mRnlVHtygI
         VZ/0BnOWc4BzD880hSkb7Zmr5NcwxEwX6Hl+cSIWEGI2/0jirEI6bUAHOHFwdIwUbTZl
         MVHOUbp9yNHHZ7GyAwOwEjRULhMtS95bNJEHkh7BkCsfVIZ47mIzGmVhD4+ibw28Ypiz
         3Lgw==
X-Gm-Message-State: AOAM531LJ/csa+vv8VDdjMO++098heHBxRKBB1f8eDorWiCHDKqeS8Se
        djpzQgBk7oUI+OSYa21WwlJKG/HGzE8gE91aRKxQkxaru52kEnZ4
X-Google-Smtp-Source: ABdhPJxh338pyZzG1XIMYqb2eJIRGX5SCJaT+Z8XZC3dnltGpUongxJyxLupyLTI2+WbOKp7NFt3seQokN1sulTXf9c=
X-Received: by 2002:a17:906:1498:: with SMTP id x24mr2191163ejc.170.1610436722776;
 Mon, 11 Jan 2021 23:32:02 -0800 (PST)
MIME-Version: 1.0
References: <20210111130036.414620026@linuxfoundation.org>
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jan 2021 13:01:51 +0530
Message-ID: <CA+G9fYvt7Bo2nq1KGhnRw=wap1-L2G9rw4K8DkQV1V+yvqSLDg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/77] 4.19.167-rc1 review
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

On Mon, 11 Jan 2021 at 18:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.167 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.167-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.167-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 7f0a1a1d4ba925eedec5669d52d6ed7da84084da
git describe: v4.19.166-78-g7f0a1a1d4ba9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.166-78-g7f0a1a1d4ba9

No regressions (compared to build v4.19.166)

No fixes (compared to build v4.19.166)

Ran 46273 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* ltp-controllers-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-sched-tests
* fwts
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-native

--=20
Linaro LKFT
https://lkft.linaro.org
