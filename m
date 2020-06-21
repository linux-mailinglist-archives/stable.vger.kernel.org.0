Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD51202944
	for <lists+stable@lfdr.de>; Sun, 21 Jun 2020 09:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgFUHM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 03:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729388AbgFUHM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jun 2020 03:12:26 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58C3C061795
        for <stable@vger.kernel.org>; Sun, 21 Jun 2020 00:12:25 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z9so15850385ljh.13
        for <stable@vger.kernel.org>; Sun, 21 Jun 2020 00:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IayuXorUzdeGIXk8ft6rzJGAzRd7dFx1deomml1raLI=;
        b=qBSERCHV3gHKZbj+5MfDrrS3T52cTDeosdJ+4Zh89kzgRNHbG/SOOcj8ntSJ4i15wc
         ghnEeIiWnyvp1GDkkBX7lyzX8ck/9IEmJ7dp3KHnahojQoWIeUhwTepmOm8sAM3HkXVv
         bgW7VOb0eN9Z1Voi0Hlfp5I05Q1CqJq6sD/RR7AIp4w8U1b0Zg5Wj19XWvgepd9vVlfu
         bBT0lhbo13L2F9+Y2I/RWmGX6FHIZVTTeTigosifcSQD+rf6dqGtTbbNXKnkY4OML7h5
         cKgxXQC0h7KO6QAFHLh03aw9Rq9Ybx/yuwBdoDlltsGUVbd1S5uaH3HAm12pnFK/lHr1
         sCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IayuXorUzdeGIXk8ft6rzJGAzRd7dFx1deomml1raLI=;
        b=b8Z2cH3Ji+BAerzjJZX9UNbNqx6O6y0cR7EXm+BkhHjatwjifYHpoZYYuI8ITL9OZt
         hJAY5EcQeKZKBewn4CSKvo87mE2SyymLOfIcQEO/VN9hYgXJriK+KULMZE2lnwBuo0cT
         kG+WYQLumiBV7bFz69uqlSH29jWGMdLy6Gxi3e9cPxLBirDNPdTYO5Yv40+yCtXIppjC
         8D4h6dhBWhXaqYxplRpLgGnwpeHCctD53lJepOwN3XfvxrHCuR66Tf7bQkJXV9nQYNti
         plFTkBTRw4bslKqqAlO/oUAL1fcoUYcFtoLUqwxPIYZT39NpJRCa2k0K6ygFdS3kfUhj
         zwhQ==
X-Gm-Message-State: AOAM532XotS8LbVMQMEtlIVOaXJ80vWPqt/t2M4OaGMdd0eO6/tx1a1p
        cadtijauT0c9Uhcfbpc9FhXyy+ld/XppOteZspe/lps7vlLLJw==
X-Google-Smtp-Source: ABdhPJx395NIpjS9VlxOjLyKWZCHE05uXubnxnPVd+jDzy1qgk82jL4ixo6FTF4AtKBRjNZMMj58YFxBjQ8QUKIFrcA=
X-Received: by 2002:a2e:911:: with SMTP id 17mr5957682ljj.411.1592723544083;
 Sun, 21 Jun 2020 00:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200620082214.928028424@linuxfoundation.org>
In-Reply-To: <20200620082214.928028424@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 21 Jun 2020 12:42:12 +0530
Message-ID: <CA+G9fYvy_T8Ru2KdY42Kn6D=NLzPL+iP4ueDqV8_s+4k8mcG1Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/265] 4.19.129-rc2 review
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

On Sat, 20 Jun 2020 at 13:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.129 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 22 Jun 2020 08:21:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.129-rc2.gz
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

kernel: 4.19.129-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 7e6addf7237fd56f0e64fd045b1d9e999705b189
git describe: v4.19.128-266-g7e6addf7237f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.128-266-g7e6addf7237f

No regressions (compared to build v4.19.127-26-gf6c346f2d42d)


No fixes (compared to build v4.19.127-26-gf6c346f2d42d)

Ran 35260 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* kvm-unit-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org
