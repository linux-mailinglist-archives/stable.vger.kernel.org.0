Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23DA2BBEC0
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 12:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgKULlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 06:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbgKULl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 06:41:28 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549A4C0613CF
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 03:41:26 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id v22so12187768edt.9
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 03:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n6maI52ojE6yJGXdjCJAlZ//7OuY9jKG+qgEqxsfnH4=;
        b=tvfimv+TjozKEmB88rp6JT9bj3JgoeLdKn/zP5i9KGCBMGVNwl9VVR/a/coCkVIaUh
         o82ZPALt8b8vN7HpHucA/+lJmZpTtqEdAfkSBO98Up/x/d8jtt+w8gb+VxWkxS3En75p
         vsp+ER+y0vDMZkyps8qrrI5BX6LSfJezKL+3sG6v+WFKc3ZSTO6erNrxc8lerfhrarAX
         yLSQS0AfcJ+RnRl5k8ULTohBKRsICef2Og1IHGIJTgRJ+xYRRqUGN59ZLFtZWFk0zlH8
         BGDKeFjolmwnvFoHor/u08dRAVCvhI++iSpOKr/ijDpjmTXegNlfiaBxertjvmN8sZ6W
         tjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n6maI52ojE6yJGXdjCJAlZ//7OuY9jKG+qgEqxsfnH4=;
        b=YAfTJYeaUj7yzSpbY/wYjR6RihUc5DxkWrMG8t3xQ550Km9pqlQ64pLEj7NUO5HiXm
         DxEeGLNeeC5VKI/lSKqBatWUaZG93vb+vBqx062BnMY4vG91bTVhYCqstM43vDwikfK1
         cufty3SCV9JBibK7DjZTgmW+UioDHv3Ngbkvt7CgMsm02w1YIOs21yHSIe/t0YznkzRd
         dZOh4VGuoPRJl5yNB943W8xBk0rh/t2nRjVWeCGpF85NDqfVXVpIJgtefV/WVNs0tjGh
         I4eLtFpIEsy2it7tvEK5cXW9dKwN8c91NJDZjjzFYwhuJ1T7N5Ujuh3mA25UKz7pzFVQ
         Tmhw==
X-Gm-Message-State: AOAM530hoZknYAUcTx+rn+LiNWEa/uz0ChqcwkoMmUIXbYqgiLtIIoX7
        Py++nhHWiWO+DyG5TcZqedQskDv2QJwaqXEMCQJWKg==
X-Google-Smtp-Source: ABdhPJy+mOMwZMYdETgNS5ikT77YDHit2Hf2xPGZDiTz+FbwN1zfG2wNEAWEmH1va+b1GtqYBQBGI3amLNdB/qyB058=
X-Received: by 2002:a05:6402:1644:: with SMTP id s4mr21985603edx.221.1605958884763;
 Sat, 21 Nov 2020 03:41:24 -0800 (PST)
MIME-Version: 1.0
References: <20201120104539.806156260@linuxfoundation.org>
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 21 Nov 2020 17:11:13 +0530
Message-ID: <CA+G9fYvjXhDdNi+OBBMgjdQxD2O6YtTD1nJ-Qd2HKnUDRYibhQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/14] 4.19.159-rc1 review
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

On Fri, 20 Nov 2020 at 16:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.159 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.159-rc1.gz
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

kernel: 4.19.159-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 5ab11a539ca71c870174aca46b388b09581e06c0
git describe: v4.19.158-15-g5ab11a539ca7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.158-15-g5ab11a539ca7

No regressions (compared to build v4.19.158)

No fixes (compared to build v4.19.158)


Ran 47170 total tests in the following environments and test suites.

Environments
--------------
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-sched-tests
* network-basic-tests
* v4l2-compliance
* kselftest
* ltp-fs_bind-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
