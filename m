Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E11BDA2D
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 12:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgD2K6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 06:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726617AbgD2K6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 06:58:14 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30540C03C1AE
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 03:58:14 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a21so2091227ljb.9
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 03:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3MQTEzz/bgUGqn27HLWx05JdvUwv0M9LPIujeg8+b5w=;
        b=XG2QdsAYz9E7hY9503tkL1sFJprfMBUwQSKtdzpkylC0jxzM5jc9xUMTYi/hg5KaZy
         OPAzpsVJBv8yjM3g4WpbE51LEkOZUyqIrJtpzljk/JdmUHqvqzyfpCsRoc0i+AO58I20
         o9Knw7Qtp7UOQyohP0flDwSX/KSOABYKd72SarHzD6qsog9kcRs4VrC+0lKm7SnV/aKL
         +kHxwsQEQNocOT4nwctpZ0QMxRdSlymVBWTJxR9fcAG3nVbB0ZMQEu1mJgy3lC63lMGi
         Yk+igqB/9+AzAAOen8USV+9PpBnG6vEY+D5eExz0gM+uVpB6YksAPvAaNs6Cah7aCeMU
         y2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3MQTEzz/bgUGqn27HLWx05JdvUwv0M9LPIujeg8+b5w=;
        b=bQ2bejGtcZhL1uRRiq1fveKVIZKgBgjrS10/+GfBcZBShslPjJt8Pabr3ejx9k8Hqe
         F1cDbb5vSzCnxNBNiui/te9DcjXTrtVQzjO1AkgHEMkmbHh0XQyR7hUN5UwvojLoZFlV
         UjY6UR71LZ8LJki4zXqPHUf59A4FCZUONEE+Nuwb6SAG56C7ZaW2EO6KSWloSLhb+ZhL
         tcgvXBx3kZn2QJp82St8NpVpIdmhXACFh62zKwdQiqMjPlJd9XQxib1eZcUhXp7ED9U+
         Wb0mKYoUbSplkW05h/tAJQBn5hP19x4KttpBq2FhOQrmt+QmfQzH/TNGfuilhlj25JI9
         hNZA==
X-Gm-Message-State: AGi0PuYXafeCJRsRYN8B16mL/QPDqaHJlhSZi4hxEz3lLgHNjO7foRcG
        7jctRRe9HhJ8D9Zirhuj/JZzcU5uOAF3HGzAauB0DQ==
X-Google-Smtp-Source: APiQypKC6shf0ejaOe03ju3dzacATI5s1zrN2YicbE63hD7OHdvvDXDh0Ho7o0zRZ/SYFeK0XdzXPcUw8Zh9/qtrCH8=
X-Received: by 2002:a2e:a0cf:: with SMTP id f15mr12036777ljm.165.1588157892313;
 Wed, 29 Apr 2020 03:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200428182224.822179290@linuxfoundation.org>
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Apr 2020 16:28:00 +0530
Message-ID: <CA+G9fYscqG8jKYYPTH86hgHBB0nkTe21gzpzJfj+pWp1NhPV-A@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/131] 4.19.119-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Apr 2020 at 00:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.119 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Apr 2020 18:20:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.119-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.119-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 3fc812d65db6b5ad19f0ef548492a25ba2a276bc
git describe: v4.19.118-132-g3fc812d65db6b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.118-132-g3fc812d65db6b


No regressions (compared to build v4.19.118)

No fixes (compared to build v4.19.118)

Ran 32114 total tests in the following environments and test suites.

Environmnts
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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libgpiod
* linux-log-parser
* perf
* network-basic-tests
* kselftest/net
* kselftest/networking
* libhugetlbfs
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
* spectre-meltdown-checker-test
* v4l2-compliance
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
