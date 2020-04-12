Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB1E1A5D25
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 09:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgDLHEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 03:04:47 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33336 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgDLHEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 03:04:47 -0400
Received: by mail-lf1-f66.google.com with SMTP id h6so4274697lfc.0
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 00:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ty7HX9xWVD22xMQ9pyGa/AQyEWHkjoVSYAk5PuB0nDM=;
        b=I+lFUvNhR0/2K+W8zwO3d7KXJBIhgnyKfG2fjHAny2YPyuUQ/oAJZzFDvfhRg93CuZ
         Ucfe3Lzz+GUSP4Y9bvUa5YQiQH0Vly2i3u8vR8YXtUqLRIKHflf7GdgsHJ8q6pKSEjy/
         /srqIEOXeAK/Tv8i4dfmheXHZiPxEdzt/TpFSkZ71iMchaXnbtNrwl8vufZzfyKJMm7n
         GRlbi0smHpGulqYxebMBQ0cXZ4gqLY14EfYsLPGLau56XWHTJ9dqrDeQe9YJWLKbiG8T
         6yu6mxZrod4JX1yF4qFBmcpfJsTBIKMn8UOMQMs93Jrp8WnyXfco4inUPnasMrgs/SkH
         CWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ty7HX9xWVD22xMQ9pyGa/AQyEWHkjoVSYAk5PuB0nDM=;
        b=HDo9pKgybnlsojlfrzCrCE3adWT0vYk7jXCxmW2rDPJzKSQx3lJ/XXWI9I2NOw2+wK
         7NYsUZiPi8lBeulAO+7HmTXfFgzKZZ6XCJ3jDRx/47+3far6o6h/0vkPMF8dfHgitNzG
         uqsLUfPtHXqZ90lO5GRJmWXzCsLpQ2cAlNFBTIWGgvYivxR5uZ3xMgMfnE8hUGgj24Ee
         yv4kDyMVXtp1yhviTGJUvsptW1utJ7kZ06HXxVrftf7x4yYrHpuIES9v06l3wnd1zd0L
         HNwJh7dA8qomyi6hxrsDy0gtrRcCo6STlfvCs60DNtUaINuP+/7vkCMlJzUAhe2sFCMd
         DNVw==
X-Gm-Message-State: AGi0PuacmCqrkr9cq5ZLyCAJQFi2E16RPKFiFafM283TMFVCM4B8I8mr
        hY/9dPKZOrl9ZYlzSfD4PfQYaEFpFiy1F0aU0VWqFw==
X-Google-Smtp-Source: APiQypLzE2HDiXao3n3T/vHu27Sv+aAcoL1DWhadULTotzjGG+kMgblu7QV2qFQbV6kFHXt+4JFTA/WXv7WF9R/bArA=
X-Received: by 2002:a19:c64b:: with SMTP id w72mr7080422lff.82.1586675083533;
 Sun, 12 Apr 2020 00:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200411115456.934174282@linuxfoundation.org>
In-Reply-To: <20200411115456.934174282@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Apr 2020 12:34:32 +0530
Message-ID: <CA+G9fYs0Ews9g6=_1zEn3vVejNh6Y+GrvRqHXiYDFid8qQJ3Fg@mail.gmail.com>
Subject: Re: [PATCH 5.5 00/44] 5.5.17-rc1 review
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

On Sat, 11 Apr 2020 at 17:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.5.17 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.17-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: 95e8add082c3df1f6ad7752c26843878f7d06844
git describe: v5.5.16-45-g95e8add082c3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.16-45-g95e8add082c3


No regressions (compared to build v5.5.15-65-g28dc3ce41f75)

No fixes (compared to build v5.5.15-65-g28dc3ce41f75)


Ran 33408 total tests in the following environments and test suites.

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
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-dio-tests
* ltp-io-tests
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
