Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CFF776A9
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 06:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbfG0EkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jul 2019 00:40:22 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46681 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfG0EkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jul 2019 00:40:22 -0400
Received: by mail-lf1-f68.google.com with SMTP id z15so34197528lfh.13
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 21:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bc4Kuv3ObKxZ1YCHjNmJYwEV0MSACxlEgVDhz8oZI2c=;
        b=sg7DhheYw5wwyLGoGKZX4Zor9qgw3b7mrNgiraxkcys41RAxhSCJm3vow+YLC3rkpg
         nWAZoImJBkjr+xZOlrksUIce+d2GM+iHU7h2qbPe3cBLD7m2jlqdkSQWI3S7b5/r0VUg
         cZhmSS8PoNjQLGk3qHnQFUm9RepNix19zu87VNjVjHiWNH1UusbR9fijb4wKrYF/estB
         GH5NKgpNF/wXW6zlNU1D0qtP2CsAhwT7UB71P1zegxOOGKIbrpyzjdZrTAPl2muxoW4z
         OqL87DAh+kvUUz354NztEzb1Qi/sauogD25SbIT4UVr3GTu3FTlqCL4xcE1bm2xOWhRZ
         BgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bc4Kuv3ObKxZ1YCHjNmJYwEV0MSACxlEgVDhz8oZI2c=;
        b=pzcPxHuVVJt6phjL/GxmOc5OmUVeRlw0wDFcVkwXH5flBMu7Zs+ZB1JuOHdqMauoYj
         fEDfs9xaEBcPPs3DaPV5hIcKyATw7MkAFSf6MwcZbv8q9PvbzmbviavdXsBh5XAgu97N
         h4VNAl/lS1SoYbSPeUEARjLjjt5n2pqtHWsey2zR5thEEAGaC7ozBBoCZPUCyrF6xgzo
         kxA+tpCidcGG+u6r9Go2F697e6sCe/nWGcodvPGE0lnjvaACTyNd72e69RV8WS96JzI8
         GIZPpxmMUCXAFN/3jv3pZDy4kX9tqsRFteap9WoAEIVm43/dyyQFtHJHxCirOEChE3Si
         8z8A==
X-Gm-Message-State: APjAAAWppx+nFkuZuSE4SuDZYFCUZfPjMYXGvsk1m/gcE468JrvI8lHZ
        ub74/v+HSvRJqmHFpmvA8klUe8nZSekftni/g4wpIA==
X-Google-Smtp-Source: APXvYqwFGF85Yf1JY3LahL7OO4PLKYG1Ua2l9Jchl/4Aa/VLMCvCCXhOe4jv/Yn6zbnNvNxxUC5xWIFIvmpFTjKAbxk=
X-Received: by 2002:a19:8c57:: with SMTP id i23mr45190136lfj.192.1564202420353;
 Fri, 26 Jul 2019 21:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190726152300.760439618@linuxfoundation.org>
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 27 Jul 2019 10:10:08 +0530
Message-ID: <CA+G9fYvtZ9A39toZDjjca48XoEp8cW3NAr7XYusfTmVMJH5vTQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/50] 4.19.62-stable review
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

On Fri, 26 Jul 2019 at 21:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.62 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.62-rc1.gz
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

kernel: 4.19.62-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 213a5f3ac1f5e2af0e25fd4b26497590ec290be0
git describe: v4.19.61-51-g213a5f3ac1f5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.61-51-g213a5f3ac1f5


No regressions (compared to build v4.19.61)

No fixes (compared to build v4.19.61)

Ran 23490 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* install-android-platform-tools-r2600
* kselftest
* libgpiod
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
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
