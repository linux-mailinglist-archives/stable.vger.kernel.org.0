Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9972254056
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH0IJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 04:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0IJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 04:09:20 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB77C06121A
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 01:09:20 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id a1so2372660vsp.4
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 01:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5K7Yvr6ReIaINIuTCr6i6kdYpp399zLJQzmASJXNFNY=;
        b=oxzhrx3O8MBDCtrbSUVyChgzsFIsE6eOh33JEaLzeCv4J/hr8oyiXa/2bp0aota7xp
         j5hTlBaKfXW/JBNijuWaSHBB7gJkcCTswG4tQ2bP/ciGaQWKjwqyqDkSaW9bbz1oFPrp
         GMU/9i4jGMjKDUgVAPWjkaChWAeRgSZceXQoZr4VOgdZJtwOtUkfcgqshksgPlKEbJ1B
         2yiXNgQr4Iv0RgK7vydCEDwZCQFRA0tnLsYqc3bHCguENUIbs8J6zCVDb27oHi0SCkcv
         AamJDneUAYJSN30zw/2TJk38YXULi06t7BnUI3kQJbbR0vsdFxHjlkA5FqLV4zYbjfPE
         3B9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5K7Yvr6ReIaINIuTCr6i6kdYpp399zLJQzmASJXNFNY=;
        b=Jk9euvP2hfrxCA6ve1wWwqApExNXXyc+JgPJvf5f3qhsduzs4x9wZ65qjH+yyehdu3
         6gxVG4J5Gk5h4dVY8Jq30SDgsiI0PfiT0tjrQIDE+TsNPcbIG6+w2FwlM3jL0IAT1/o2
         8fLqbt4r496sqJmQV6vBXIFhRU4bqrlayX4S8Qi6oEYF9CjKGnqjU6KZ8WpKsuPFdrFo
         NXeQcxsB7AMT+7uoewCU6L2vlSPaJqKM9CYSHKXpsQj6YJg+8eXp5PNbnl0gsO+x3xVV
         t/4h7m540tBZd4Gd5FdCN6f9qvS6gMRgxXZ47tkSRCf/jx2L31ISsi0nrDbD5u/qMsNK
         FYdA==
X-Gm-Message-State: AOAM531c42XWRod9Nk8QWSHLC5M/TkVBbUEyJ7Thr6BfVxt0RHr4ATs/
        0v2+kYe0nGwdxMq4Bm/AUR9eK/LakOHKFg8p/TCPTg==
X-Google-Smtp-Source: ABdhPJwy4flU5OHo1H4F3QIB1bVludq49ZH/K5mG5XVsauk5tZ/JpTuGhfCrMgoC4/+8hfMIoYHWlUskIufVfg1sF5Q=
X-Received: by 2002:a67:eb53:: with SMTP id x19mr11395714vso.214.1598515758844;
 Thu, 27 Aug 2020 01:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200826114849.295321031@linuxfoundation.org>
In-Reply-To: <20200826114849.295321031@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 27 Aug 2020 13:39:07 +0530
Message-ID: <CA+G9fYtyA615sxRQ9Rveok=gC4gv_4UQEwFhp=AXpnmhRRKjnQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 00/15] 5.7.19-rc1 review
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

On Wed, 26 Aug 2020 at 17:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> -------------------
> Note, ok, this is really going to be the final 5.7.y kernel release.  I
> mean it this time....
> -------------------
>
> This is the start of the stable review cycle for the 5.7.19 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 28 Aug 2020 11:48:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
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

git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 6ae4171ed2cd47d945dbd8ce6a2918c00b498022
git describe: v5.7.18-16-g6ae4171ed2cd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.18-16-g6ae4171ed2cd


No regressions (compared to build v5.7.17-128-gf16d132bb2de)

No fixes (compared to build v5.7.17-128-gf16d132bb2de)

Ran 35766 total tests in the following environments and test suites.

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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* v4l2-compliance
* igt-gpu-tools
* ssuite
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
