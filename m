Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A3A9A99A
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732819AbfHWIGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 04:06:53 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38558 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732323AbfHWIGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 04:06:53 -0400
Received: by mail-lj1-f195.google.com with SMTP id x3so8033633lji.5
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 01:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+ArWT4WMkl9MoDwdiTdKW+nRIiufhcAmFCR9Jk6ZDzw=;
        b=A2nTNPGNygd0MA9nBCCgyH7F/hjYYE8xBjs4KMxp0K16IYqYf4Az8ALleufCFuMHsd
         zzNDH6H5lFC8qUunVnTITtUcmceRGwWKnKNMHt3V4kFzikMbL7lLdXyTWWKCiyEKGPGS
         bUULd8WE3Udx7HxMaE3CuLlAVo3VJzWTKqu25N4Cf0qP0OYSAEsvR4F9qwON19dOqNdf
         MXpAPWBlSGbFdb7XHB+xcwk0jTKawx7YxiE58emCAXKSYCQHUL+WXxU8YYa0yl4QQj7+
         isnGVjYN09o6+bGLOcENZ3e1Q6FqoxUc5PiRAZIDB/n2Nys0RmnxEggHbxwysqIZKedb
         jUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+ArWT4WMkl9MoDwdiTdKW+nRIiufhcAmFCR9Jk6ZDzw=;
        b=Io8qtjduw03r4isDFgLy3ikvNujVZKPdz13aCb9tq3Z5oCOngE43CUeSKy1eCX76oo
         2DDkkRgKVihEXdex/6+a6EyNbKSaVXcxW1MQ1uqn6AV/nceTBeljE3lrQQrtg92Izonm
         B5xbxmUOwkSJIQlh1AFQ3BYsUAOIAyPwUC7NsumzihBnC5MlNRm5t2FOnqONZmJqdcWE
         6U2Bdjzw/nh3QX95u4b4c145kCArUWrKfDCbxZ2V7b0JnPVkndPHyT+okfWs3iB5GoU3
         Gz2k2aTTeIO+WL3Y+cjwtoGm4BIaVG3qXKWZHnr3/diY0J0Fafj414BdH0X8SbhTFykh
         cH0A==
X-Gm-Message-State: APjAAAWXdV9AjRSdQFqi6HFkBfPm9WW35op2D6iWRiQrxc5gOUXYeJeL
        9nXe7o3xuppkuQGZ12Pw/3AB6Nlt+bBnYtge1YoYsw==
X-Google-Smtp-Source: APXvYqxAaMCcHxRgbmSzz6e6F39TOLpgRipavHulpe3LTQLSMuep2kDTkYjZ7K/A8ANnk4J/1mpzG5cyT7MvFtR+o0o=
X-Received: by 2002:a2e:a0c3:: with SMTP id f3mr2094342ljm.123.1566547611404;
 Fri, 23 Aug 2019 01:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190822171731.012687054@linuxfoundation.org>
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Aug 2019 13:36:40 +0530
Message-ID: <CA+G9fYuKX2mgPZfqnqJBx-01tgVEaEbJk-T_5b4LdhkGpoXQLA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/85] 4.19.68-stable review
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

On Thu, 22 Aug 2019 at 22:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.68 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 24 Aug 2019 05:15:49 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.68-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.68-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 1ca4133a7b4ede95223d2f4e85900ad6565ca8f9
git describe: v4.19.67-86-g1ca4133a7b4e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.67-86-g1ca4133a7b4e


No regressions (compared to build v4.19.67)


No fixes (compared to build v4.19.67)

Ran 24105 total tests in the following environments and test suites.

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
* ltp-securebits-tests
* spectre-meltdown-checker-test
* ltp-fs-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
