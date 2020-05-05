Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDC71C597C
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 16:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgEEO2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 10:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729256AbgEEO2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 10:28:10 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE9CC061A10
        for <stable@vger.kernel.org>; Tue,  5 May 2020 07:28:09 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id x73so1532984lfa.2
        for <stable@vger.kernel.org>; Tue, 05 May 2020 07:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+uAwrnVW9vl6fCjTny0Qx0tOY7EJAzfPhuaRYgJwZTI=;
        b=u5hW8PHzJahWFyul2XkcmX+OO4CaXeWzoWY71xAAYmRT12aQyNIVWRm61Sg1OYvSf2
         SXDHU6P+/AZ6P+IrR77i8+e4ShQn5nCWn31kFTm22XQOkX3bir+LrMU5Dm+GzmR6znCb
         kFR3n96RxsBGnFs1v1TSrySHtsXKm9K39n9LPPcS8e5DJ1u7BcUJlCNrah3etkMMEjO1
         Ri4jVv7NoGM7XiJOvtIU3Wcoj5OClz5aWRUkcmxCJ86QqXZgqnGSpmRXT+NjoMGAt9wo
         Z4yM6y/P+HmRlZuo7/ePTArkmoi0e8NaaRyvMgHkIG8H3WKzopcgJrITlazuhtvK7rgh
         3img==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+uAwrnVW9vl6fCjTny0Qx0tOY7EJAzfPhuaRYgJwZTI=;
        b=mcRjXSaLNHUnxC8YNU8gefSPzS3J54EZvy+SkA2YpD83YWcV3dmyK+7A5Od21CcgPy
         voDeHG/3ipGS79fuUPKmwos8Xm97Yh1PCkwrCA/Sb/QBzxoV5+9OJK/eX34AkQpAsvYK
         nhJ/BYJSq9meWhKcl+kAjWgp0DeaYpHjA2ynWWCRVjf4SYEL3TlRG83pVeqhrJF2Pe5u
         1lim8kYG6pxr5s8Yjq2U5eJgvhtnIvsXsY+UE8sG5DY+s7ZcnjC4YqeLIIc/JdJT3sV0
         MyXelrMj6HqnHQppihkvPqyzJiCR3F1kuXLa1PvQd8M/bqRXlPpbLpPyVxlBJuTgiWy+
         HOvw==
X-Gm-Message-State: AGi0PuYkmUcpsHerwPEz6JFevisc9KDx+kaxfRFq3KWrk8xQcruwUPjN
        rjhROEeaBtOmWPW3mD2FI5e4wSo/8UQ5j/C8lJl+/A==
X-Google-Smtp-Source: APiQypKlYrUPwwfMUuA8+0KSmGw0C746f6/PsmNEXiY4KhylVTyFuq1tsKFUBFmRIwZhzKUqk3m2th9smiFVOhmyM4k=
X-Received: by 2002:a19:3817:: with SMTP id f23mr1863422lfa.6.1588688887748;
 Tue, 05 May 2020 07:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165501.781878940@linuxfoundation.org>
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 May 2020 19:57:55 +0530
Message-ID: <CA+G9fYtwpo01W30vF8PRNrDOxVgyVwyViC5RCmLvLu04t98u4Q@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/73] 5.6.11-rc1 review
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

On Mon, 4 May 2020 at 23:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.11 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.6.11-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 6cd4bcd666cd831acf192bd7350b94121469ebcb
git describe: v5.6.10-74-g6cd4bcd666cd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.10-74-g6cd4bcd666cd

No regressions (compared to build v5.6.10)

No fixes (compared to build v5.6.10)

Ran 29045 total tests in the following environments and test suites.

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
* kselftest/drivers
* kselftest/filesystems
* libgpiod
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* kvm-unit-tests
* libhugetlbfs
* ltp-containers-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* kselftest/net
* kselftest/networking
* ltp-commands-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org
