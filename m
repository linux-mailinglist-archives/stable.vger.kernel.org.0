Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2EF2ACC7E
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbgKJDzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733236AbgKJDzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 22:55:39 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E54C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 19:55:39 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o9so15491684ejg.1
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 19:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0cmgyD7yLyxELyK7/QZiaCzewHpViN7sDK2NIDCoPBs=;
        b=V6VUc7W8zmpj88hUEsZzWj9JmMWUMAWqOnB3nRmqzQrvSkxiJKmbG1hXeSMgUY6L4T
         bPrZdoJquhaEOEL8bPDYtipqzAX4ubzXKDBjE5Y8A2TAkfGsgiQPIXaITS/ocwEHbISI
         2AgvXCOfJYIe6PvbBZmf6GZv5T2nX/qGYfFQPeT08UXorMkPxvWSclGXFimAB3uM02Xf
         HTNCbUmG2c87Nta83t2Grh6i5sqTxhomRmH5OrY/wd6EPcCMSJnBCVG4yTsHk29E4Cxk
         R47aEKB7/lVu9sKtUZ+LtIbhztmrrmOFvsoj5vSEDylAu16sqt4BVyFX4athLZhokCOM
         UpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0cmgyD7yLyxELyK7/QZiaCzewHpViN7sDK2NIDCoPBs=;
        b=gL45jNihWmCfDmpzkXPZPh1t70yMVOudxVjkT4D9szNj84Sfo7kxgNG4r7KC1q8n7Q
         6O9LXa8V+NqoJTiVnAfYatQCwcvvyHpXrWIq4+fwB9jg9gsZHbrVadE2wNso+JIPoloY
         e8A/1ogk7aJ0hgIaEhR6+9ezRsOIKwnc1egrEhWlgAHx4jtiVniPQjsU5DQxzgu4a3tp
         WiACx6TAlnMp6/lObLJI3SwHBmGn9jO0mrkCbKZd1ebxcUfrCBYAemYqWzLf4+i4Fnv9
         oOaNKCty5bw8rUJPC0PL/kf8QCsrVI6tbmAaMLFsAYNJrP67374HvJP3MYk4A53VhGww
         6gOQ==
X-Gm-Message-State: AOAM5323zyjpU+ZBhGzoQwnZoOlgO0qKt0OvOu3AhqMlPSvPWkeigyj7
        8K4BtZO7qR4DIwffRYO13a5DBViRszUVQRbTK3YONA==
X-Google-Smtp-Source: ABdhPJwW9DOk5oFUKYHCxd2o+FG8fOyjASFBhLllPEKwraoTl1a8FkPT5EVy5x2wwSJyifYpbBpy+FYAqY4qiOuvyxg=
X-Received: by 2002:a17:906:6987:: with SMTP id i7mr18790948ejr.18.1604980538260;
 Mon, 09 Nov 2020 19:55:38 -0800 (PST)
MIME-Version: 1.0
References: <20201109125030.706496283@linuxfoundation.org>
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Nov 2020 09:25:26 +0530
Message-ID: <CA+G9fYvLpXRSHi5KyOvj4SwxBmehz+V66VMLr=phHz=9_j0GVg@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/133] 5.9.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Nov 2020 at 18:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.7 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.7-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.9.7-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 134494539ffcdb29080b4f34bad1079d2ec8e56a
git describe: v5.9.6-134-g134494539ffc
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.6-134-g134494539ffc

No regressions (compared to build v5.9.6)

No fixes (compared to build v5.9.6)

Ran 39215 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm64-kasan
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
* linux-log-parser
* perf
* network-basic-tests
* kselftest
* libhugetlbfs
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
* v4l2-compliance
* kvm-unit-tests
* kunit
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
