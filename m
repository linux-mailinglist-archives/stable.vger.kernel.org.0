Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8771A5D83
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 10:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgDLIia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 04:38:30 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32843 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgDLIia (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 04:38:30 -0400
Received: by mail-lj1-f194.google.com with SMTP id q22so5946552ljg.0
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 01:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R2le0evq9gz9HfqkaJ4JdCZcgFC4TsWNJcMqPXjUYfs=;
        b=Siu8yDwNbubWcGrVEJhG9J6GsFQiht3jv9w0TOIa4/Z6Q+C2xEK+tuLAFiWteRYxc/
         JuUQf4KNbogBKKHDbD9b9NPDai5qvhCquDNUs5vzn2/hUaLB8w+Z5vokPIQLDcCAGq9T
         +ZKjHwK4iNZT7zDrMjacSrTLdUwtETCMCDGcsdMLjCL9apd9Jui0S1+gpNpE3hfEhRBW
         kbt4fCPI5HcGoENmFO9n/Qz5YK9wezBqmb0ht9TsA5+1thQlqB2kJ5auBIGFcXRZamtg
         3F73ilMCsPhndtWwN/AkOuPYdLTa3CIqgXxtXQN1NfLsQtiXBNERJRNe5pD73qOf3kyq
         G56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R2le0evq9gz9HfqkaJ4JdCZcgFC4TsWNJcMqPXjUYfs=;
        b=JHsAAlc+LjjI1ALmMBE5OpLR1HMW4wyoRFvo8Ydgl3gup2yVJUpwCUow/xHKe4XxTG
         IOG30f2qOfv/+cxIKJn4vvIoUXacN4cxK5ONuligmLC7JJlBTB8aB0CfVThDQ2h3b64H
         r8GPoM2eVsjv0cTFrrWVPMYkukf6sR3f53kPcUOiHBGW0VHSjEiTCx7vdA6IByEX97qC
         Qzc/muCbHFmnWk5VOYLqZ9jEgvcJBylhHAG4UNSxxKpcg//Rd01K9QMfFy76mSvIpws1
         AjmrX44/aDqSwGijDf27CKBi69E140NWuRWY27IhYlZTQv+yKkFNFrCuaPAVwoRfj8Qq
         Efug==
X-Gm-Message-State: AGi0PuY5ap1KOpdFKHCecqJKUBt3CjGXeH7dNdpiE5SiLheK6YG1Zef2
        bSaK82ZfLtgt4bpfqq0wtF52HsXd4Xy4TGxbDBfphg==
X-Google-Smtp-Source: APiQypL4Bbi8BcupFNGHBvd5y8ZZ4Vqv40Zz/fqHI2Rmp56kIoH0egpqJZxPgCJBIMTulXrTEsiL28LXpGUtZvY1TkU=
X-Received: by 2002:a2e:97d6:: with SMTP id m22mr7779074ljj.245.1586680706756;
 Sun, 12 Apr 2020 01:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200411115508.284500414@linuxfoundation.org>
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Apr 2020 14:08:15 +0530
Message-ID: <CA+G9fYsv4coG14Ah=6ExiFZLn3mUhdxOyx9Hir-cb7HEP7w65g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/54] 4.19.115-rc1 review
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

On Sat, 11 Apr 2020 at 17:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.115 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.115-rc1.gz
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

kernel: 4.19.115-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 3b903e5affcf69ffcfc0ebb8c3f2c016b646682d
git describe: v4.19.114-55-g3b903e5affcf
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.114-55-g3b903e5affcf


No regressions (compared to build v4.19.114)


No fixes (compared to build v4.19.114)

Ran 22940 total tests in the following environments and test suites.

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
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* install-android-platform-tools-r2800
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-math-tests
* ltp-sched-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kselftest
* perf
* spectre-meltdown-checker-test
* build
* install-android-platform-tools-r2600

--=20
Linaro LKFT
https://lkft.linaro.org
