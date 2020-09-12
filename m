Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767D526788D
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 09:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgILHc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 03:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgILHc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 03:32:27 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D629DC061757
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 00:32:25 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id a16so6637536vsp.12
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 00:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nfFkqnWEErNxFtWv/YO3PFi1cE+9jARKcj78ildkfXw=;
        b=x6ZvlpK4bqoK5Naewn83FqTmxPX5/4/XfaZWtvdJZooo0Pa58j6a5agCmUjMaiGRg0
         tuBGC5sKDLBvP3TrYE6IqwDUH14zFqoyRC8V9nxhuGLr0Q7zNMkc86wYGlJP23mqwbmt
         mWhg1df020BaMzArFTNdyOjtiB1WXPb8b9poDKWAVfCVDlZOx1yINO2jS8t6OrgW45Sf
         WFoIKAy1HCXdwFO1BkVeaKkdnJITF+J7vKacoPG5TtfcJT381DQVd7hmeXEZ2bXR4iIr
         XZ+t4zpRzxOA0GImcbQCxkzwxBZNJrmmdfo6mdzdhdu/Ik8ksgzQGjN+VWJO6bpqbs30
         RjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nfFkqnWEErNxFtWv/YO3PFi1cE+9jARKcj78ildkfXw=;
        b=kyipD6FyBl8qZe3ovMBhOYhHkjVwD8NqAlPYcvnF4cSYWmDwXw94ARUzRKwxcDuB+r
         YQJAJ93oQqMQglvcTeFVQiuho2fkMblk8lyopQ9+CaNj6Rn3wTY7LdoRgpGLQL3iAhxA
         FsaYEmuNjQsLZH06wzSGOWfgcmjkYDNVEXX59WTjfTUitarwUQn/PCLj9xgP7Sf4QkdM
         uVhhzAgfFR2l21nRMU32zMaQ89o9k1LKF8pOftHtQsM57uyzhJrHFhLon4WZ532Bh+ya
         3uydro/CN5f29/rpAs9INaxlGMkULC4Ct3cbcMidZRICsazVdKZEY14XbQIXMb21rRNL
         gg8g==
X-Gm-Message-State: AOAM530+/Pagu4obVnFofpHUxD/CV5TxR1pax+wqFc0YM2X1dRYXEvLU
        mahTjvgl9aDr300BhRpttv0ZermExFkYgGPupFEAaw==
X-Google-Smtp-Source: ABdhPJymmSWRVMaBiaEb51EEzKXZicnyVgNWqPdBP9jxO/FyT2ZsKBQ2uIbNkq37k8J1eXBxQ2lpEyFHUgoN9qQf4qY=
X-Received: by 2002:a05:6102:10c2:: with SMTP id t2mr3145887vsr.10.1599895943346;
 Sat, 12 Sep 2020 00:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200911125420.580564179@linuxfoundation.org>
In-Reply-To: <20200911125420.580564179@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 12 Sep 2020 13:02:12 +0530
Message-ID: <CA+G9fYtmb-V2QRWA7is1fGRKjBh6FgYcDjTjrydWOPWq7wNk5w@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/8] 5.4.65-rc1 review
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

On Fri, 11 Sep 2020 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.65 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 13 Sep 2020 12:54:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.65-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.65-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.4.y
git commit: cdcf7cd54ebd34795a39be0bf517dd1017873640
git describe: v5.4.64-9-gcdcf7cd54ebd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.64-9-gcdcf7cd54ebd


No regressions (compared to build v5.4.64)


No fixes (compared to build v5.4.64)

Ran 19759 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* linux-log-parser
* perf
* network-basic-tests
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
* ltp-syscalls-tests
* ltp-tracing-tests
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
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
