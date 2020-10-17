Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F912910B1
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 10:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437619AbgJQIJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 04:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437606AbgJQIJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 04:09:37 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1176DC0613D3
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 01:09:34 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y20so6852632iod.5
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 01:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6g9nTd2Y370OKNvzm17ofLbNhuLNX2d/be6GNyGq9xw=;
        b=XHS+tN7j+HlE9IFI+xU+hy6uNkBa9TzsyrCg9QYj1nxf1vy+J0hF6saC6XpFK9KJc8
         g5kHJYJ1uxmaTop9VBji3BjcntLINfbtnRrKIOoZFltKf0sYEml/SRjyiHnGX79HJsUz
         s+EJnjXzaycZ5mEOaIrZya8qJ576XNsyX3Pbx2f9mGeuP/i4S2zHN/TdmrVjnViJx/6i
         48q0Nd56KLnvlJZB2A3Yrx0Yu1mnA1IEPAz7S6h4cjaIdKtdaWd9mOJ9M0k4TozP4tn+
         CJHOSHLSSWlG4LzK7zIl7PZp8fQ8Iw8+eFI2/7JbzCEURo4DKnUzko9ccdG2wzuxdbon
         DooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6g9nTd2Y370OKNvzm17ofLbNhuLNX2d/be6GNyGq9xw=;
        b=KwhjiPSAqsn2zLCUngZbnxgRyI+G2tr/fqOertFkprfxtkk7oHWUsiwIMQ1Cvj/Q4R
         yVuGJj3zxJAnQ085G0EpXxYz7Llge40gIz2n/4jxp5CrDBo5omoriQ7PRY4HDTg1oq7J
         VUDDX0/e+NJP9vKGi3/4tggs1dJiHIp15nqIZ/6iX3Q8lnmI7u5qE01c2GuswoU9Ope2
         Wlt0KMSYsO1QlbEb900SzNgOsFTpNt7akw7FaXRQfWgGpUfQcMZJxTU++IabV0JkGkfS
         0kPI3t4ZvjiSN14u6yXF0H1hssPZFUcl5anc9lMhIOf5aDCaf6Bnz8VvAlysyxJl5HP0
         z/Sg==
X-Gm-Message-State: AOAM533lDYaEKg4YyXype0Aq5wUHofnrwTlXqkjFNgKc6shzSbSUglbJ
        5viqH3aLwJmk9YBn8FVlyRCdcYYtjGsdBIpg4Y+22Q==
X-Google-Smtp-Source: ABdhPJwBjVJi6x+rJFABZWSF5xZmIU9dBsWp7pOPb34pdeiG1Z5ZnVPCUZ66uQVk6WFLtJ770ihqX+JT3LjV6gdpiXA=
X-Received: by 2002:a6b:5c06:: with SMTP id z6mr5192501ioh.49.1602922173251;
 Sat, 17 Oct 2020 01:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201016090435.423923738@linuxfoundation.org>
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Oct 2020 13:39:21 +0530
Message-ID: <CA+G9fYsK6NknJv+Wfouuxt0a2k7GKR11s+Ov_a6sJ=Gw3JiWFA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/16] 4.4.240-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 at 14:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.240-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
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

kernel: 4.4.240-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: a37fadd41628f67d277436bb904352b926a59cff
git describe: v4.4.239-17-ga37fadd41628
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.239-17-ga37fadd41628

No regressions (compared to build v4.4.239)

No fixes (compared to build v4.4.239)

Ran 11616 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.240-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.240-rc1-hikey-20201016-831
git commit: 9a6146f70d93713dc4685a840e490dec2d007af8
git describe: 4.4.240-rc1-hikey-20201016-831
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.240-rc1-hikey-20201016-831

No regressions (compared to build 4.4.239-rc1-hikey-20201012-828)

No fixes (compared to build 4.4.239-rc1-hikey-20201012-828)

Ran 1760 total tests in the following environments and test suites.

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
