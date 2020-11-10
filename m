Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6C32AD3E3
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 11:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgKJKgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 05:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgKJKgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 05:36:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A8DC0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 02:36:35 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id me8so7370738ejb.10
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 02:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sbxfgzzXuiRpzcGeF8SAVWsA3CAzjBC4xj5Dhtl1Vvc=;
        b=tiq6v8Jk7US9vLIAEidWuQdFMOZSJbMw7tx8wM+8u1MuBLX7n2o7JYXJOSFY1hzOJf
         wQ7i4ofAExgL/badc/vFxNenkHXxvlT+bunzkPQESzX2brf6LfIf/xFZeL06jm1jups2
         2mL7dhNS4msoYWRuk1ST43Ewf9Mekuog4MhEejnTSQ/U4yUaOcFC660OYyLPCyoaFTn/
         uxk6w7laVqgI7vkSVJ8Y7xRN/8/1CybywxwOa4hX8MUpiYp48cAC+VP6XeYOjk3w3/Fz
         PZ7PdaweL2FTHFyCfDxmx2NjpsPFC/cIAGF47Tgkzkmhjm+geKNr2LWnZ29NUQi3YXFW
         Yljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sbxfgzzXuiRpzcGeF8SAVWsA3CAzjBC4xj5Dhtl1Vvc=;
        b=lI9N5VXHL6vbonlkrU3Qp76uFat5ZpmRNcPMmp8h90rMm/QINpgN8vH4jDVOCBUGrQ
         Huxc2VxJHnco99eLjBra8uq6LT381OA7V12Qy18qhn9h/1MQoGYaoFyeDrP02c4i+3Ml
         xafrtNjzmGAsjMF8kqKYrAJfPWGaNXsmRUiEGxTWM38ycETrM4eQPDIcxMDOk/VQIkno
         wvELp+IFywHjFjY352SU/oq32jDi1LsWOBOtWHlH0/bJ6ZkB7tHmZPMPpwPIOghlB/aw
         p3l7E3EH8AXDcweDsA++Qb2pi86MQbThG+5krPUPeHhv3w+dICYrYkE648qZM4aBJn6W
         XbFw==
X-Gm-Message-State: AOAM533KuFGnjGn8yCfwyTQed3Q5tGy4i8vsf0+iGYYW4YgVz8u8StIG
        fojkGbnFbBevkX3xbr3IjNJQykc0KJBhbgusELV3Aw==
X-Google-Smtp-Source: ABdhPJxUQ7HakIDmAd2rfajBjQSW62ejWiTtNn+xuVVCm9+46WsWr/TQYvOpt9MhVcVKPOaC6HYFS3GL+oi5p4j8d1E=
X-Received: by 2002:a17:906:3087:: with SMTP id 7mr19065634ejv.375.1605004594232;
 Tue, 10 Nov 2020 02:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20201109125020.852643676@linuxfoundation.org>
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Nov 2020 16:06:22 +0530
Message-ID: <CA+G9fYtnkJUqxTzCBjx+nqGecbX2QHLxha853XhV+qmHZnzhgA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/86] 4.4.242-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Nov 2020 at 18:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.242 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.242-rc1.gz
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

kernel: 4.4.242-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: cbe5dd8b360451802fb7f6b2491f6a67688e50c8
git describe: v4.4.241-87-gcbe5dd8b3604
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.241-87-gcbe5dd8b3604

No regressions (compared to build v4.4.241)

No fixes (compared to build v4.4.241)

Ran 18073 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-kasan
- qemu-arm64-kasan
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* kvm-unit-tests

Summary
------------------------------------------------------------------------

kernel: 4.4.242-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.242-rc1-hikey-20201109-853
git commit: d32ad0aa87e9a15f22c90c3ea1ea1355264954ef
git describe: 4.4.242-rc1-hikey-20201109-853
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.242-rc1-hikey-20201109-853


No regressions (compared to build 4.4.242-rc1-hikey-20201108-851)


No fixes (compared to build 4.4.242-rc1-hikey-20201108-851)

Ran 1730 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
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
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
