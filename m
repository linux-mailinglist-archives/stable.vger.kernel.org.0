Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D3EE81E7
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 08:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfJ2HQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 03:16:07 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33671 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfJ2HQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 03:16:07 -0400
Received: by mail-lf1-f67.google.com with SMTP id y127so9722866lfc.0
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 00:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l276QuAtSp3Hos0lCYccY4XpvMkVxXX0RdmbHt48ywg=;
        b=srVTGJ8SX+LbAxa40BtUDs13Y5wPHPKaIL9iylymE51cWXq3w8/2T1JdaA+WZoY7i2
         Pcf9WoHywLTu90AwOhYIana1/x+/agZWTTETL3DSWkQwoqWpbMCsLDk0B6KJ+2shrqpU
         2yO3XZmlqhIaIB2gyJlBori2p8JioVw39lGr789iiNrvcu6aI1+r08vTrhXJFPNfPqJi
         L9meNqg/nQLi7KyHMGMCpuN5WCeUs56XDDPd9GFpOe7+BcXC/t6VicPVJ64qMM+hGoLp
         HBqPvrlpbl0Vy5QyccTP/N2TbDAeCm87f5DyE5j/7fr904BjAvJEX/C2+04J2Ahuukwb
         sCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l276QuAtSp3Hos0lCYccY4XpvMkVxXX0RdmbHt48ywg=;
        b=hVM/KjTyjn1uxHiqftCPEVzYXLrsOF9rE23ZUa3xX+Dy3FHyIO64eyfbzLb3gpPFJi
         NkqTIH6nb9YDRyikoL47VTVdhRVTN0PwfK/qxaqG4LdAzoTcGIZv1DGn4FU7RwinhZ1O
         wAukgRg3WwoT4WfljojuS/7Im6DI0nklfP1eyze8cwBm3jQOh4EFAslPXxWQlh6soVx/
         3gpKYSu4fFkZGwLFfMcfytVOr7SrPjrN/CkWK1zJjyNBxTAueoxbGyujRUFjPL0gzcEh
         8G2E8OYaqCupupislU47qAle3n2ltg2hxrBYtRrD17i7uYUAhAjT8RMoVrUoZ0mwqn1p
         IwnQ==
X-Gm-Message-State: APjAAAVUW27s6eeW2HD2LPpqoox17N7tvfrFHgY7EzuCM4QDiCT8wDVE
        qLyw+eQ0GyPx2+PNeDsKdEBybivxdCpnb5PiemzjQQ==
X-Google-Smtp-Source: APXvYqy2HqUmOhrSFK6XoAgiSK7lUkNA4wd7unmVEpk6hCNXL0NUfVT1uiGWkDmVmSXlEcoiiWS8xddMLzDzX+2okcI=
X-Received: by 2002:a19:3f0a:: with SMTP id m10mr1245555lfa.67.1572333365605;
 Tue, 29 Oct 2019 00:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191027203259.948006506@linuxfoundation.org>
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Oct 2019 12:45:53 +0530
Message-ID: <CA+G9fYvGEEjnf0paJLS7UDJt0hJg8G+MOD+7hPdyyORVnGkoDw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/119] 4.14.151-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Oct 2019 at 02:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.151 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.151-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Note:
The new test case  from LTP version upgrade syscalls sync_file_range02 is a=
n
intermittent failure. We are investigating this case.
The listed fixes in the below section are due to LTP upgrade to v20190930.

Summary
------------------------------------------------------------------------

kernel: 4.14.151-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 80117985de0635c8d7fa58fa198b7bbbd465542d
git describe: v4.14.150-118-g80117985de06
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.150-118-g80117985de06

No regressions (compared to build v4.14.149-66-g66f69184d722)


Fixes (compared to build v4.14.149-66-g66f69184d722)
------------------------------------------------------------------------

ltp-syscalls-tests:
    * ustat02
    * ioctl_ns05
    * ioctl_ns06

Ran 17364 total tests in the following environments and test suites.

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
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
