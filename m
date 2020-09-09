Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B4262A0A
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgIIITh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 04:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIITe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 04:19:34 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E91C061573
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 01:19:32 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id j185so867622vsc.3
        for <stable@vger.kernel.org>; Wed, 09 Sep 2020 01:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kxsSOAH08Cb/1H/bCrBQPy36KVRAJlGoYW7Z2pWiU/Y=;
        b=cOMX0UY4FYViplh6wKAtEd2R02thFI01xq7M4Hwgzxr6DPjpx42kGVOuNX4FehUxDq
         jtAGZKKTc6CogSuICHLSl5SVGpHJkzvjjT7/R78wtczR//U3KOad5nXbPLZYPd4qgbCI
         6AxM0h99CzEZm/aoWs1a1guDPj1fzCO1LCRnLXGj3P8OFgLfJYndgpu075HF8j/XPbRD
         URtJTARScj6SDwUPxmmK9zlDqJjEbFzV60qjEY38Wub9w2YKtT4SfavjVepnbQsjPM6k
         83pCPUfZpfEz7OxT059ibeEv7jn1z7AZmPjRKol+duvekZVImqc5Z7Dfcc6fIHOHAYw0
         q5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kxsSOAH08Cb/1H/bCrBQPy36KVRAJlGoYW7Z2pWiU/Y=;
        b=Fr9vNTqXmHgRAncgTJbNu4f95RZ3AOKHLVuDosXq/v6gIu6i09tBIyv6t3keoYLU0H
         C72pmq6DxGw80gK+t4PlVPz8utCe9fM8EnyzTgUrdPkhgX4yHe63zJbIRo/LnwboATFe
         rj9PTrDSYiK78Q5Qy50aSWdQt09YrVnbWPShW3nUXpwsqUG1yzV7AQ+u/usz/H7izXMZ
         v8DSrVNo9QJzffYFRPw28XI9CUAz62KT5kWhIOkVNU3LS6NAU8LZwtV5akci0pOLdsIJ
         uvugs/KvL+W1bKGfbde0bet+RdcJgbFy11PrR9J3959yJ7gcneDiB91Dw5YY7Fg/pax2
         T/GQ==
X-Gm-Message-State: AOAM533d816sORl/66FFkJ0WcmAgbSWU7t6FkaMHPdkm2TGTX3Ps62+7
        Sno1vgufNu/aIK7DkYOb/L8X+x1zyWMzuY8HrBqPbQ==
X-Google-Smtp-Source: ABdhPJzGs/uInKpVTHQiAOSJVnUQ3v1i+kKqOuY/ow1h7pWk17jvJw6jTMYM/5DIOGoGbnIx822Dej3ONmk1xHi0lMk=
X-Received: by 2002:a05:6102:204b:: with SMTP id q11mr1845302vsr.40.1599639571640;
 Wed, 09 Sep 2020 01:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200908152217.022816723@linuxfoundation.org>
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Sep 2020 13:49:20 +0530
Message-ID: <CA+G9fYt2CNnV+-7jbvwff=0q=UvMp4baCPy61evpXtVT-f-xVw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/65] 4.14.197-rc1 review
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

On Tue, 8 Sep 2020 at 21:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.197 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.197-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.197-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: d520aac0cd79e557dd7d2ae06370d104a9f48645
git describe: v4.14.196-66-gd520aac0cd79
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.196-66-gd520aac0cd79

No regressions (compared to build v4.14.196)

No fixes (compared to build v4.14.196)

Ran 33476 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
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
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-syscalls-tests
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* igt-gpu-tools
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
