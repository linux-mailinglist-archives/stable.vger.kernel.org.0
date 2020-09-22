Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEF8274200
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 14:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIVMYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 08:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgIVMYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 08:24:32 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00005C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 05:24:31 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id e2so10151952vsr.7
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 05:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fiH5V+oCx2UHwAectwkT26jdydkLoaasF/MY0v5R+9c=;
        b=aXsOZtj4gVpdc+fcHFlPnX4y/1YK1mKLQhjR4+Ejc0iozqxi6MY1K+Pt1zdJ8jwoWC
         umk+cQgQ5jW0en/cTfYAHLFOX4EpU0lpfCXQXPvGQIwcZN1LgksgMRXfxDIJZKXq3qS0
         1c+p7oHQ2Oi1xCxYJsTgGIR/VkanS0pqZPo6BpJXT9Fn2z3jZO7EI/TlVfqHMQv8fXNr
         oPVP2AuKpbsg7Q2kRKH0bZSpyzA9+OV+Hi0oHwZ0Ied+WOu4yfrsjJgM5sOmoRgaXGui
         FCnNGbvR+eLZXrXAbLBI0Vj+0AryKeGKqEMdSRh23W6bGjVg4fJk2CCVk/yqm4/RZ3pY
         J5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fiH5V+oCx2UHwAectwkT26jdydkLoaasF/MY0v5R+9c=;
        b=NjxSFIBXAXtDpz9HVPIbeQm8bpHFQtSNLh954vdjOO978lfIPKuMm0oOcgud6XdBht
         9XbXZymZLp+EIA3hQ6zyT2RMStej57n5MHRW7LbbfRAVfNJeRsdmfurG6rXkrm+1nKkS
         zTME4bSIaPpT2zxnwvg97tdZOGpQbEkmugdyQj9g/fHFnB3eE0KDUgRIWLfILqOlM+Dy
         IyI73pz3e3CzFq7FhVPHeWH/uHZNr65Vg6iHuuwwSUL48OMq7og8FDsWR4ymvg/4F8eF
         rYCRiGaHUWG8zZCzlHvd+2cE48D14/UzZokIzNj6sJ/tkLT8gbMq2kra9BFoUZRgWTo7
         uZ+A==
X-Gm-Message-State: AOAM531+UgoNhUMbcLJMCUinliUQhdOPkbXIDYzCEHizPYr/oukXTWHw
        qYvSuORQg+XrALQSLxz/sx0s48WJd5UGa7UiRUxCdg==
X-Google-Smtp-Source: ABdhPJxraxqNDLyg42scpZ4bD4GD0v4u41aSAGimZD3UCZ2bSQ+6CwWc8ShXe970KrsirInOBSr8VqWzJG3D5Rxl61c=
X-Received: by 2002:a67:bd12:: with SMTP id y18mr2988088vsq.45.1600777471046;
 Tue, 22 Sep 2020 05:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200921162035.136047591@linuxfoundation.org>
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Sep 2020 17:54:19 +0530
Message-ID: <CA+G9fYsjAT_ZSXOR8qkqOROrzB0iiin4aqkVx2_-vczHFaOo-Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/70] 4.9.237-rc1 review
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 at 22:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.237 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.237-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.237-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: b7aa672795fd423afa4bd326c3abd59c991263ea
git describe: v4.9.236-71-gb7aa672795fd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.236-71-gb7aa672795fd


No regressions (compared to build v4.9.236-47-g9769e65dc140)

No Fixes (compared to build v4.9.236-47-g9769e65dc140)

Ran 14478 total tests in the following environments and test suites.

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
* kselftest/drivers
* kselftest/filesystems
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
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-syscalls-tests
* kselftest/net

--=20
Linaro LKFT
https://lkft.linaro.org
