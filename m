Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF3C1D1C34
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 19:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389879AbgEMR0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389876AbgEMR0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 13:26:36 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A808FC061A0E
        for <stable@vger.kernel.org>; Wed, 13 May 2020 10:26:35 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c21so210846lfb.3
        for <stable@vger.kernel.org>; Wed, 13 May 2020 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JrvD+8j/uwSBmYwMcyxeX3ZIu+LCzAyC5RzQ6LSBn7c=;
        b=kbjMBxqjonqink1/71GmGuP7tnUvhCqcIK5erePGVlxWe27IWnum6DKco8MnqLJgvw
         fKfwmHJ6R0Q9J+mZ5zUYkLbXsJWtdodicm0awm5z3ctdYihV5Q9xJBHAZd4/4BX45fQH
         C8Iqc7maRH9Vrkx2KZj8ODn7pM/575gMNvnZFahN5vqQgbOTiiMdUS9esH2tMYc+Tmng
         r8zu0dXbuDq5jrIKiEwA+3fXicL2vl8WEA2r+OTjZAWNyMQ06d+o5++nfYZtx2GHHxQP
         vqfWQ9hIAA472gY7QEhp/THXnemAkgnLWHcvIhQOfKta7YR2qRP5b9/3WXg6R9/jT/RG
         WhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JrvD+8j/uwSBmYwMcyxeX3ZIu+LCzAyC5RzQ6LSBn7c=;
        b=Tw9Pucr5m+ZvsmCUW90yNj9bO6ONmAVYCFXj/gFbTWXzfiTgTmUligxwEqczj+QN8P
         KCY2PNgQ6ZcQ8W5hRM0GBQtiP9PqYeTfAC+V/8+qrHDmUJYRlzli2yva73oGWUrndl5k
         sEa6vmMYsC6gQsGiPIX94NpofkL67IUV6/TX8WO/Vn2xd28p9yFl1xQp3skjDINjPm/k
         vFu8IJgsCtI1wjzSZ+MD9c9SC6UDoEa1BAoj5kf1R/ehW71LhBx3g5lORplkJItiGZIT
         hiaOgE69bEiCDBeEHqCkGwcH1B92hamZ4lorDaVBvohObEy1w8UxKita4kvWgeEm0WRo
         DBcA==
X-Gm-Message-State: AOAM532ixaygQBOg9tN0NnrY28JMzVL9EabQ02hj1hYy3qg3nS2P8a46
        D16Ng4pvDuKtkQIdYndsJ6xpoSmouBnNLjQslAXkjQ==
X-Google-Smtp-Source: ABdhPJxhIMfik6aSCpK61qb4yefzvhrSwHwUeXQvdWLkvwIwnQYMKhHRI0L/jZkUY30VVGvBiZG9ckQR/Dah5rFSVHU=
X-Received: by 2002:a19:40d2:: with SMTP id n201mr391372lfa.82.1589390793882;
 Wed, 13 May 2020 10:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200513094417.618129545@linuxfoundation.org>
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 22:56:21 +0530
Message-ID: <CA+G9fYvjbFmT2xjp3cDL9p9q4oT9+7jn4nX-DP6HHe42WBifhQ@mail.gmail.com>
Subject: Re: [PATCH 5.6 000/118] 5.6.13-rc1 review
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

On Wed, 13 May 2020 at 15:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.6.13-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: f1d28d1c7608478dd10b7a36c40f2375bcc1648e
git describe: v5.6.12-119-gf1d28d1c7608
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.12-119-gf1d28d1c7608

No regressions (compared to build v5.6.12)

No fixes (compared to build v5.6.12)

Ran 35302 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libgpiod
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* ltp-commands-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* kselftest/net
* kselftest/networking
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* v4l2-compliance
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
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
