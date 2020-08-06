Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA21823D869
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 11:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgHFJRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 05:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbgHFJQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 05:16:29 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACE5C061757
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 02:16:28 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id t15so39925489iob.3
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 02:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AzEHWOi3xIMl9Jy+/KlKWcDEquQYLPv874A/EyE4ZHI=;
        b=PZPcVjrc/xHooM7c3HriRaCxncN6sKojP1capBrxYWQE9YtLmSqoBhpyxQeWMZ1aGp
         9XceRxbsGG5YsKO1WumACBcwe0h3mELGAo7TkestVhfXXpdUeJmRW62vxEnrB9IfLJbc
         mWDEhjm1vTCfUoxfFoG6BDIca+xEnM6YlURvE+H2ZtCR9eBHgAsA38t9T11BzqeBCcu/
         /B168zINbMzuQXM21xoln5ZhvhIWgZX9qhG3u67tCuTleB7PNvubBq2PAkBqzFrp8tv9
         eGr32xvOJu/lCot4WYZxVXG6k/CXHmk5+QTCmhiRN7Z7ToZFQgMBNRWcPjGiXyFkcdQY
         eNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AzEHWOi3xIMl9Jy+/KlKWcDEquQYLPv874A/EyE4ZHI=;
        b=Lx4l04OhD3KDuZvwHs8GbLFjUG+gefLbDUxU5d00hUuWpAsAIsmTH6JgcjhA+O/mKs
         OIoQ1klEvGFswnOzFjecJjKHHunfdVbad6BBD0zMC8QxEvRBg4mVDta7Kw/Uu0RskSLl
         inuWYTtm6yO+2ML+9hWMbGPEEAoU6/lZCZsJCSHs1LnDqftwrcogmRDZs8MA+B9b5xVG
         gvysBQea7mbzXQWVnDDXptA++iZCxVxtYgZcXnGwCYYSLb6w6Ue2VQeeY/AHVXYO45M7
         V07zqSnF4SlCiMCAebbZgUt2U0QgWySTc2hfGHH5wPh0TBPNHc+7RSeH76A4kTz/wU5e
         zrNg==
X-Gm-Message-State: AOAM531CYUM2WRxAqlqHETzdYA1BFD9c+9f3RPTmGddMsZ9fkBsTdYzA
        EN7BtdXSH+1zBH//IM6GeEc6yrwlAOhY5RHM+UyfzwZ/dT+CQw==
X-Google-Smtp-Source: ABdhPJy7yM5CtQD2+dEoxYCRskCx/AdhBQbVnbMScLypVppsjaBip5ECbDaThMGjtJm5tiag+RbMJQe2mauCQhGCRl8=
X-Received: by 2002:a05:6638:1129:: with SMTP id f9mr8508246jar.35.1596705387910;
 Thu, 06 Aug 2020 02:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153505.472594546@linuxfoundation.org>
In-Reply-To: <20200805153505.472594546@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 Aug 2020 14:46:16 +0530
Message-ID: <CA+G9fYtaug+jnS1ctsnU0GJRX3yovqXYTMG04OSVMix4yqDrXA@mail.gmail.com>
Subject: Re: [PATCH 4.19 0/6] 4.19.138-rc1 review
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

On Wed, 5 Aug 2020 at 21:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.138 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.138-rc1.gz
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

kernel: 4.19.138-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 2f4ec68a8dc81295799b14aaebf6dd12aec9a2fa
git describe: v4.19.137-7-g2f4ec68a8dc8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.137-7-g2f4ec68a8dc8


No regressions (compared to build v4.19.136-53-ga820898d10fd)


No fixes (compared to build v4.19.136-53-ga820898d10fd)

Ran 34829 total tests in the following environments and test suites.


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
* igt-gpu-tools
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* network-basic-tests
* ltp-commands-tests
* ltp-math-tests
* ltp-open-posix-tests
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
