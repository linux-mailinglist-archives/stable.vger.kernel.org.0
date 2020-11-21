Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3A52BBEC8
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 12:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgKULsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 06:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgKULsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 06:48:31 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF1FC0613CF
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 03:48:30 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id lv15so10727265ejb.12
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 03:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=18UaNPkIjJ/pp60yzM/qQUZFt7oBaPc2e93fMhMJGqY=;
        b=KVSXj64VPr8wEWiWv0gy87rJ6/3cYDWznXwBYVMCmymQUfpkYIw/78sEPCJifXLnlW
         GyqMlwATKaf/cTM5I0j1CCEuAQ+jOcSnI+bjQohyZBXYp6Es7QDz1g6yF2FxQP2xIdBd
         xi11gSLRNmFYiKNfVZwWIEE9p53y5Qr6DTFJBT53zt1hdL+orVhIgc2mzzy3ia/V89yc
         2LqO8pMy34JJocnO1dnKRS8b2en/LqHvXiIVlT+4OSWSw8y62G54nNyu6oU8d3NMXP1+
         AG+Ofk3R9qZeQEStmdcZoW01C9mu5SfGEQgiiyxXJFLQAuzhUSS53WBthfF2aBWpLN2/
         NV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=18UaNPkIjJ/pp60yzM/qQUZFt7oBaPc2e93fMhMJGqY=;
        b=smzSPLeELqX94GfwFbcn7YwcHrxhvcucsxPUBBw2t+ZJ3M9zm2pwfiFdD0jpNhudfY
         ZDG23zxaQDWIUT9cbwbMdg+BZNk7GhHggILe0kPv0UV86Jcfy0SrsmuvDUcWxX7OZwUx
         QaFHVli2ajVddltfgyq1x2I/t7N2DMEh4sT12Ze0cqDuYMXTELNU+lv3SOQXS61FH553
         B2uVLEPJnTvP6ZtuukygKd6+Z1rASqigqN5hEiRwTxFRhSIg6KL+tc3jhITh3+88/7bs
         JGCSduxs42hVOjMqGDoCBgDyGhKZdeAfw4JxhLptH761hljohluKHAibIp5ZgJhRKVGc
         qi4Q==
X-Gm-Message-State: AOAM530C6Ar0eBJuzaVIZuebnuyKVwTLNn2v5Y/GLGZftU+PGECVn0Kz
        QEVTLyF4RnNIJxGs24UWcX4+qDel9wRm6najN7dXug==
X-Google-Smtp-Source: ABdhPJy1+Kh2hsNhp1IwjBYNgA+kP4IXi+l4kp4CHXk8b0AQg8tHzI2MfZw/qSOn4p2q9B5CS+rLv6DNgdjNI0A6qFM=
X-Received: by 2002:a17:906:3087:: with SMTP id 7mr35765020ejv.375.1605959309189;
 Sat, 21 Nov 2020 03:48:29 -0800 (PST)
MIME-Version: 1.0
References: <20201120104541.058449969@linuxfoundation.org>
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 21 Nov 2020 17:18:17 +0530
Message-ID: <CA+G9fYuqM=xjST0Db9410x0T3StrZgBthCvtZxftfgZG6kmPVg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/17] 5.4.79-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 at 16:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.79 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.79-rc1.gz
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

kernel: 5.4.79-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: ea92920d046bee86876dc51ba95a34d2056cb9a0
git describe: v5.4.78-18-gea92920d046b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.78-18-gea92920d046b

No regressions (compared to build v5.4.78)

No fixes (compared to build v5.4.78)


Ran 49619 total tests in the following environments and test suites.

Environments
--------------
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm-clang
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
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
