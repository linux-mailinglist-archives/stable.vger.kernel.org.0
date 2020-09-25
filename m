Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278AC279087
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 20:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgIYSc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 14:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729730AbgIYScz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 14:32:55 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FD6C0613D3
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 11:32:55 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id e2so1953105vsr.7
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 11:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zmBNMGTOcS06iWEHJdkuZQFymir5wMWMMXmjkjUADLA=;
        b=JNN3JzthaPVL6boitB+0Yldat63kEAepTq46wi1guU1AP06xoZJ5ZaNLioG7kBz0vF
         MLzPdkt4unWofVQ7hy3PQtLq/4UfB+X1lOB0+uaehnZNXWUtZgKEvsZDOqOnH3hJsTth
         uPNgh62Aeknmea8+8ZMN8ThLjxZmVdYuPIavdUgkHELO5q/iEZp7wqW3qKfvNsicrpdg
         2+RYDgIPueDhqI/Ti6T+0AROytQBP7wHg2wBFGl05dpc/fCwAGYoUT4WDSddJHSENcIr
         ggdOTQgEx8XITLtyX1SFR1PSQfftJiRHLkuqZ9E9jVcFHDWYl3zKeJNllksCU7ChdlIX
         aLJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zmBNMGTOcS06iWEHJdkuZQFymir5wMWMMXmjkjUADLA=;
        b=YuvPf+eUey/5twwfD0L7jB4b+6JVkT5UH5f9GK9XdDT3e+b6rdpJ+xlSnC8KOofy3I
         Dtnbho0oJ36ZhCfq6c9i5TSNyR5lGV+7kxBnRxtyA4K3940B0Oa0PzkLtAZJgwauYFQh
         mxQKdB13HZw5tMi4W5BQwrREO8ctYCUg/v+7RwDOkpwQVhVA0SLCoH3KQVkGOQu/vLul
         /ooTKgZLaW07gX58lJJ5/1nkd4ozLQzl1rxOhH/2vhxNIFMzWM5SlnXHxXjKlkqxsin8
         M8+ZVajdazUQmd1En82Qli2C29LwasQh51P4xOjWhK6PHpZi1gwkRvbfXDtSULbZ4JBM
         IFRQ==
X-Gm-Message-State: AOAM533Eml1O14nDpjRPDA/C/hOYD0lEMPuWP3n4xXrWd8caonRqDxSE
        PlqeZjDnGSRU/omn32XTOThawz9hSOocZURa8CDl7w==
X-Google-Smtp-Source: ABdhPJyAySprMs+K2C9uH+qRFhePGiGzJqNtXSaV18HrBMd+b4w16k9yanbkt9KoVWHxAxe/LTXFMEHs6RKE/NYtYyA=
X-Received: by 2002:a67:bd12:: with SMTP id y18mr606955vsq.45.1601058774269;
 Fri, 25 Sep 2020 11:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200925124727.878494124@linuxfoundation.org>
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Sep 2020 00:02:42 +0530
Message-ID: <CA+G9fYs2XFPxTApCcZz5x6cr3GM8uNYE77O=Md-W4QtQ7PRR_g@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/56] 5.8.12-rc1 review
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

On Fri, 25 Sep 2020 at 18:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.12 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
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

kernel: 5.8.12-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-5.8.y
git commit: cf9938637c5c627f01905a4b4e29c02c1c6187fa
git describe: v5.8.11-57-gcf9938637c5c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.=
y/build/v5.8.11-57-gcf9938637c5c


No regressions (compared to build v5.8.11)

No fixes (compared to build v5.8.11)

Ran 30889 total tests in the following environments and test suites.

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
* ltp-syscalls-tests
* libhugetlbfs
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* ltp-open-posix-tests
* ltp-sched-tests
* network-basic-tests

--=20
Linaro LKFT
https://lkft.linaro.org
