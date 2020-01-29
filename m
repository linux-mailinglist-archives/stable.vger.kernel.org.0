Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F67614C55B
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 05:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgA2Eui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 23:50:38 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34624 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgA2Eui (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 23:50:38 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so10907334lfc.1
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 20:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wim94widKA03iNuJRk9so3EwVNvjN2LdiRVfz6nHdGg=;
        b=Ut1dDBrReZ+s/c2Hff6XjuKCaDzlAw9J91bOdU7BFhTfc/vBYOqLFZ86XVwda6x4vd
         JyPMXJ529/CgY17ePJ3MN+6xdlCCt9AIvQX8hxxOtby6rDb2vN3hmVfJ3chgOZ0B9qin
         SpAF5PzNOiwA+lAZVoPYAGXQLRwpe8wu2x5VPCUNhKXzfCVkw+6v0DV7/wywrcdYjfe+
         3gRwq7idDemW2u9T3ajMoDB4kAm9eR6mzfcGWbaDeN+8uXIKD8toohKy4i6l1v49NplP
         bQkXF5M9PPfeNuIptYshYiHPe6HPTIPkjqeEyk6lUMadXCUMdLknBvAKlPcRg0Tjfibd
         tJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wim94widKA03iNuJRk9so3EwVNvjN2LdiRVfz6nHdGg=;
        b=al3xYvMuNMcBqeAm6qGeI5xc2wyo0OG9GfWr3Qay96fGZOQcYdumpjV5hUay8/cwiL
         2YpT8bz3/xp2M79SilVDd/hPbhC/imbTjdFWW6PAf8USmIB65VzBOLnMjowcvBE2FJcl
         cmUT5pyQnpUQ54Hbg8ZT7yZnmsuREMN5OrjOLTitJhSRxgRBhaps+Y7dL3zswQcgcBMb
         XAc+W9JzCIOVMQfbQoWOpDc28NqWQ8an2a3oMJ23/DVUoyErBlRuYjFk4omatwku/Ro3
         rERAlMv5iwuVwNnmo1Zr0I7a95qjQxL0j3vSQ0+9wOTEV2sq200PpuWVr3bSH1Cju+bF
         OsvA==
X-Gm-Message-State: APjAAAWnGtsbGELp1BmN2ECFP0k6FYytX0CBo29dZ4dqUAM/E0ECcVcQ
        nZmzvAqWU0dYaak8Huo8ISzIFkF4gLDRWkeZvs6+lQ==
X-Google-Smtp-Source: APXvYqxFX4aCqNvA5hqlXrgKCF20fYm8bkSYUTXShZmJ31tdAOSiXRf+BHB0BP8xgJ9VKlTZDiZiI4qbyMOtbW5pBLo=
X-Received: by 2002:ac2:5e7a:: with SMTP id a26mr4469755lfr.167.1580273436449;
 Tue, 28 Jan 2020 20:50:36 -0800 (PST)
MIME-Version: 1.0
References: <20200128135852.449088278@linuxfoundation.org>
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Jan 2020 10:20:25 +0530
Message-ID: <CA+G9fYs=Fd27J7==VEYc_0=7=xH4sS003EwXMQHCRs0zL3iANw@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/271] 4.9.212-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>, rpalethorpe@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Jan 2020 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.212 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.212-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

This is 4.9.212-rc2 test report.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.


NOTE:
LTP fs test read_all_proc fails intermittently on 4.9 and 4.14 branches.

Summary
------------------------------------------------------------------------

kernel: 4.9.212-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 91ff8226a074449fcd2b96214d1927fd3e8d8114
git describe: v4.9.211-272-g91ff8226a074
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.211-272-g91ff8226a074

No regressions (compared to build v4.9.211)

No fixes (compared to build v4.9.211)

Ran 23560 total tests in the following environments and test suites.

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
* network-basic-tests
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
