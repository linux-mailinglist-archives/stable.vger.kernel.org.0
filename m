Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C66218026
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 09:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgGHHAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 03:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgGHHAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 03:00:41 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD11CC061755
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 00:00:40 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d21so26224004lfb.6
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 00:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dN7kD7Q1Rq4KZPUzBGzJoKUeTvUT8h427/XLCP0siXE=;
        b=zXDRP/bICz7BJrvShRWcIw26GN2IeV4EJhuSvEnjTAy8fGHDJV8KtACwYmk6uwEe4r
         BuCbZShWgCurUdUrAVg0yBebe49q5YgB0ZYlfIEibkTOqyc+fkkU1XdYvhO+j6p4/YDR
         0O6Pc9OXUo7jXq6D/ezE6ViR0X6dnhWxIwVEqGaApFkYmqiqQIvgzhPF/e2HH1NvUMGq
         bOL+ZDXnu5M3oMq5CgS2iy4YhR8H+x7cPW0GeObiUWz/5KP2Di4voisye95EOPRWGk5g
         az5CF/AEiyRTz10mf5WlWOSAj5GNZVpR78xmEaqEQolsfJzEl6QW3uznM2Q1UUGvCXXH
         SxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dN7kD7Q1Rq4KZPUzBGzJoKUeTvUT8h427/XLCP0siXE=;
        b=qw1LlFDrM7j9bfR5k0dF/LmKw4n0zemoMFr7TbJ6MfOtY0H+QnCYIONTf6TjAicGPD
         nVuVp1JFgXTFTwqnQoLhtzCAYLUvV0y+etmTjh1yqnS8PJD480zHsY91DFYEXdCNZDmn
         u0Zt2xMzcLEQwRVthFGihpWDebW4xuq/1cZ0qk2ltM/u6m4iU6s1SfBt2FpkeqkG2Is+
         NkwD0IPfg0iPPXL3CXKvIw8sbGKBJ0lC1ejxzW9U2o6ojy3VA4OmqS0mXWt9btyKDkOS
         zUAhpSrjtmcifDSeyLx6MpCp82aHUs5LSWBqcoWNADk1aGV2Je3GdFE2RFYfKzwv5G5i
         qn5Q==
X-Gm-Message-State: AOAM5318JT25ctauX1gl8AhmlC68Hm3ZOj84vC58qkJ/6KSwX4fvKtFH
        Id+/3AYcJuUAkpHhWEHc0qZZ78JfgsLCy749Qj7dIw==
X-Google-Smtp-Source: ABdhPJxuzf3IPe0k9fpHN75463rwiENlmj8qvoP+ZRpXWAU/gSJBP7lw6ZSMGOHpzAYVc8u9zL18+uCcbANt1lK8rCI=
X-Received: by 2002:a19:c78d:: with SMTP id x135mr35232317lff.82.1594191639066;
 Wed, 08 Jul 2020 00:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200707145747.493710555@linuxfoundation.org>
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 8 Jul 2020 12:30:27 +0530
Message-ID: <CA+G9fYsewvEeJF60ANjuz5VqMgR1-PQLn44HVSHjkAh2NL9xxA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/19] 4.4.230-rc1 review
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

On Tue, 7 Jul 2020 at 20:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.230 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.230-rc1.gz
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

kernel: 4.4.230-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: c19eba6b34341e17e0a49be45b010f483dd95de7
git describe: v4.4.229-20-gc19eba6b3434
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.229-20-gc19eba6b3434


No regressions (compared to build v4.4.228-155-gc19eba6b3434)

No fixes (compared to build v4.4.228-155-gc19eba6b3434)

Ran 17904 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems


Summary
------------------------------------------------------------------------

kernel: 4.4.230-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.230-rc1-hikey-20200707-761
git commit: 1e4ecd8e5eab1c328ff83cd29d52021eb6035bc8
git describe: 4.4.230-rc1-hikey-20200707-761
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.230-rc1-hikey-20200707-761


No regressions (compared to build 4.4.229-rc1-hikey-20200629-759)


No fixes (compared to build 4.4.229-rc1-hikey-20200629-759)

Ran 1861 total tests in the following environments and test suites.

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
