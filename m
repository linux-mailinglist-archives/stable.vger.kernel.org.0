Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388D12678C2
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 10:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgILIIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 04:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgILIIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 04:08:45 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06E9C061757
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 01:08:44 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id j185so6693497vsc.3
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 01:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fM+lglj6XXTSMK2cirmL5bgozEzDMARHxLPd/FCcatM=;
        b=uTtrF9/6YXrT/4+oICxd7QnrCskq5cRttZHgEwdXZnAjqNULoIPl3qIdoev+7f6oOl
         jHEVy90/m6Te2+9BH/19IVvVKh+f1lE8t1NkrSTGUQBfgmJOASRQnxYiDWZ2xrPjn6/0
         PaSQ9uFfTWbm7FYM+EgYrLmAxA3ycsM/FCsaNeA6bOakr3lHMe5bTjJLsxpryLzNcPKF
         N2rCfNsV9RWMiJarilXHK2G+5hDoTewxuqP2qgFiREDPINfi0FzUnEc9211dEXEZ+dEY
         UG6zp55QKdyr+rr2bYlZrx3yQhIdJJ/k2F1K1v5BKapv6yz+jtFql8T1wmtI/0SCwubW
         WLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fM+lglj6XXTSMK2cirmL5bgozEzDMARHxLPd/FCcatM=;
        b=HHE3QlZ/pkRWDiuxghrqDxo/KkB9dc/dq9uDmuENWlmhsZiRyuiy2g9xoZu07FJdYc
         1gYe5gW8Z9UtVVzAC3V05Mw7X6guXeErly4l0cigSdFKq9E6tPTsCu4sbNFPlT/CVNGW
         ordTafNl9ZdEowp5cjkOkhLY5UdKu/fb9j6yb2gMcSgLjv2bQ29iGWzFsXmxUbOfzG/M
         K/GP+ngJZrmk0esNcf4nO+CxFgNP6C/Gw1/NidLaFWR9LlNKmgrQs/3FoxDoIIFzMry1
         DLoVxysfAACHpYkj7JYxUp9ZN8UDEJxXh03AseBWAzGRUpgQuy0TYmDutj2kmaP4qzOk
         mvIA==
X-Gm-Message-State: AOAM532Wy7A9EsCBHRbhY1Tq9ujN5IKjLO6OGAmPnrT5PsjYA38Qm+Ce
        vf7Sx0XjFXe9CzgHzOvv+xikV6ucYtr966WqOvXUQw==
X-Google-Smtp-Source: ABdhPJwjRKaoM5Z4Vp8HwlehzblQG2NMbXWRa/882b9IBdx/DyIcfi1XkBhanroDctuVVxuiGjLITcLNWUzRifugmto=
X-Received: by 2002:a05:6102:10c2:: with SMTP id t2mr3174661vsr.10.1599898124021;
 Sat, 12 Sep 2020 01:08:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200911122502.395450276@linuxfoundation.org>
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 12 Sep 2020 13:38:32 +0530
Message-ID: <CA+G9fYumc0VCAqeGCA6mGtgCZeQDJL-nA84rn8oDjAm-xxDEXQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/62] 4.4.236-rc1 review
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

On Fri, 11 Sep 2020 at 18:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.236 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.236-rc1.gz
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

kernel: 4.4.236-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 5a444641713b4fca895f5b30cf4b0d53dba5a383
git describe: v4.4.235-63-g5a444641713b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.235-63-g5a444641713b


No regressions (compared to build v4.4.235)


No fixes (compared to build v4.4.235)

Ran 8284 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* linux-log-parser
* network-basic-tests
* perf
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* v4l2-compliance
* ltp-syscalls-tests
* ltp-tracing-tests
* install-android-platform-tools-r2600
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.236-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.236-rc1-hikey-20200911-811
git commit: 9a083a8e28ba57575b8d73c5d5cf3529336e4240
git describe: 4.4.236-rc1-hikey-20200911-811
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.236-rc1-hikey-20200911-811


No regressions (compared to build 4.4.236-rc1-hikey-20200908-809)

No fixes (compared to build 4.4.236-rc1-hikey-20200908-809)


Ran 1803 total tests in the following environments and test suites.

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
