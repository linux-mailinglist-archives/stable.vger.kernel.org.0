Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C1A227D3C
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 12:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGUKju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 06:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgGUKjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 06:39:48 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A574FC061794
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 03:39:48 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id b77so10100356vsd.8
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 03:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ae35Tla40gXKHZjTtmHTfp8nZLfz9N4dIm/F0WXzT/w=;
        b=IYdxs+SPmNfXhZFEpEij367uN7D3kbB7UbHK+MWWom5Ik+GD7exLfkqZii16E3nTVQ
         VVtR55n1FrNqBWymuCHGxFT4S/wfhlEXrUKzGo5JIoWlsCfe6R4YhxHkaQXUGzf9pEph
         6LY0Btw8zPZV8Ho2tSPIlj1XzM8/ytip4f8ysR0xWhaaqVtZg9XS8T7MoeT0EIeCXRNc
         1DqdIaZkIKcMFVLgw57iLLhRb4kIHh/BTxZXPVDI3ldtFwXuYi0OjTed0/Xlpio3JSUV
         eszYL5QFVA0+o1tyccpuRGKfdKVWjKtIg/TIYUWbigmaeL9GtzCQ03dRrEOr+FLfqAW8
         1IKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ae35Tla40gXKHZjTtmHTfp8nZLfz9N4dIm/F0WXzT/w=;
        b=VNzYeg2X9NRLzGD3QogcyPhs7zRjcovOElvinV9VYaCUE0UMfDMnyGizNENxRvQZvs
         LNxYxKVZVbPpeGJq6lM/7uXf/nBXOxKcYz+dbtnsPSDV0JlRUEbsLsQXyXDcZ5qzECDX
         sxdXIxlwVYt/LyFFY67UKdrY/EBKbcg4qnuxeqTVRie9+LX6oSb/rV2a0BUjGVJcHi2E
         HmWj/p6Bx28np7/1FmvY/XELYXGQtrhEhCBk0fl0eG8WK88nm44qlJjunoBrFV9rNIar
         sTAammZXIP7HMrxgN26Cgs5qibK1BOIKbmPKioGoAHp93JJmOGX4Ii/FKv9F41F7DsMw
         dF4A==
X-Gm-Message-State: AOAM533rUAqfv7oSNKO8pQO5qRySYwFTx1Q98srIvj3MBc7idEKEqNWl
        cAj7xUc307GsJIfnMDnP25HD4A1uUhndK7qjyvBVLoZxhrrj0nk8
X-Google-Smtp-Source: ABdhPJwzajFOu6faBxm/CsPowOjhtM0yGbBDebrKk3YoiwfyHkzF+dmbuCnMJrYtxuE+PljJsHRf1xGBsSBZ18stYWA=
X-Received: by 2002:a67:fbcd:: with SMTP id o13mr19411078vsr.41.1595327987494;
 Tue, 21 Jul 2020 03:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200720152747.127988571@linuxfoundation.org>
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jul 2020 16:09:36 +0530
Message-ID: <CA+G9fYvFVdh1w0kkLDknyut8sk3Kx0=yQLtKqZK9mTKHNtF=GQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/58] 4.4.231-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jul 2020 at 21:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.231-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.231-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: ecea46f8864653c4a4fa6c4f0b690500ba217149
git describe: v4.4.230-59-gecea46f88646
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.230-59-gecea46f88646

No regressions (compared to build v4.4.230)


No fixes (compared to build v4.4.230)


Ran 17639 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
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
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2800

Summary
------------------------------------------------------------------------

kernel: 4.4.231-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.231-rc1-hikey-20200720-772
git commit: 89cea942179d0a31521a87d7de038e694b36a952
git describe: 4.4.231-rc1-hikey-20200720-772
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.231-rc1-hikey-20200720-772


No regressions (compared to build 4.4.231-rc1-hikey-20200717-769)


No fixes (compared to build 4.4.231-rc1-hikey-20200717-769)

Ran 1840 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
