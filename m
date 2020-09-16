Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553BF26C528
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 18:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgIPQ3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 12:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgIPQTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 12:19:55 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083AFC06178C
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 03:50:08 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id s127so1618860vkg.3
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 03:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZX0iZioFwmgw1elGFiPjrIpPpg5vfn7asVW4qGAjRZM=;
        b=VYMlWMvQNXApXDDzFlw6YZ/KMvktYCDwQv7McLUL8p8z7AbeYJ6BOZlT6oq2rCfNiw
         7CyGVjcYIR7Ors1KPPnCo3xjokfvG0A1m1PBvVp/pHZW1RjZPUlgQ4sui6ZqZSyXq6jv
         RU/w8MzpU9U+gQT84A2+Giaze8drDKsPSxpGgWdI3NIuR22Jzm9exnTARrKDM3oSqpL8
         ZAoDl+xPRpMdN7H3afIqXnulGlQjJg54/8UPzCx3P4vkpwLZmu20PTGes8cpn8GtVmqI
         XDdRxiRa3753N1mfiudowIrJ3hfWXhBgz7KtMilf5p5C75jd9pMix4gu9kQOpInuFVjl
         r5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZX0iZioFwmgw1elGFiPjrIpPpg5vfn7asVW4qGAjRZM=;
        b=DZdTgrrb4R0jhXAkWJ5EV7t1a0vJl6UiBHPjXNDm/KAHLv0ewYfQcbLY89yfh11uJD
         +x3jm/9balAyubBuaSHe+hscgrVy6+sKPFcZPtoEO0hL7n1RSKEEmbrG5v2w1SK2K5xI
         2sLAAU1IGOr7baX4+WpxSCTjjfph0HjWWYfQkRkEWtO/ZQwhNAlsnV2o1r4y7c+b0qz1
         OavcgDD/dvicE4i2mAixcoFcQGSsOHAPN7/oz2wGtv8l9oOWFweJobC3rNwwDPQ16yHX
         0eqVTVvxUq+bbnrS52i6BHcfD1pIOnLO1AbqaUVfA0HoiwLp9nGejLpgwVdu6ILL+H7n
         wxeA==
X-Gm-Message-State: AOAM532irsvY9QjA7Rqb+0ikNMvzkfiy+raV2Y9WzXuoC21dwvc1k6Bk
        meTG552moCBIixWmjm8uqtdyeHfMOaZpZypzSegbWA==
X-Google-Smtp-Source: ABdhPJw6IrKNN3hqUMY3drGXUH+oAFQTfNgyQXdDa2TrY/YBK97UL7roPb7Yof8380iu1kcW3PFb0Dg4qScTbOC0DTc=
X-Received: by 2002:ac5:ccd3:: with SMTP id j19mr13225775vkn.8.1600253407167;
 Wed, 16 Sep 2020 03:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200915140633.552502750@linuxfoundation.org>
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 16 Sep 2020 16:19:55 +0530
Message-ID: <CA+G9fYvyDCk1oK=2qstXWOM-eaw1x-r4N5YF45XFDi8GskSmvQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/78] 4.19.146-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Sep 2020 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.146 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.146-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.146-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: e92f22c53d42d29bd65909f4e01be1c0e0853765
git describe: v4.19.145-79-ge92f22c53d42
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.145-79-ge92f22c53d42


No regressions (compared to build v4.19.145)

No fixes (compared to build v4.19.145)


Ran 33849 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-ipc-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-containers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
