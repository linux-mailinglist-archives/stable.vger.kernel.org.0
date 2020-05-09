Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260AA1CBE80
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 09:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgEIHqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 03:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgEIHqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 03:46:04 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDCAC05BD09
        for <stable@vger.kernel.org>; Sat,  9 May 2020 00:46:03 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id z22so3268891lfd.0
        for <stable@vger.kernel.org>; Sat, 09 May 2020 00:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4AtfOSkLqdRJzIOPh2+ApauL+nZtTPP0VHGdRGfP1Sw=;
        b=r2FXD0dJHpRiuIh15AM+qqyE3ZikLukkdLdVX8FpNQHu6uMG8YbnpRCFwRWubfYuRL
         C/ySoqMPjaNu0HHvLbmQJTncHeZqGdRLy2bU9BAfqVbjOjeyygN9nBn3WVbLL/YNeb7v
         4wtxth+9f1xOiwrCkm/+uRPKBoe3uIhUyslitK8OJNP3TWQicF4Mh7I3d4Ka8mjO+nKP
         2jWtSwP6P+7d6SvBoy28xqwXX1iPfRlEXgo5u8ckkr2qeLN/bqD+HIvr8HV4vp98yI2j
         0YZhpDDd5RHOFN+Pu8E2wvu7Mc/Z1bm4/CV516W6aTGG7RI0hBr/dJmL1oPhiP30b5LH
         ReMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4AtfOSkLqdRJzIOPh2+ApauL+nZtTPP0VHGdRGfP1Sw=;
        b=f7YzGHLxXTJV05zbJX5ZoX+5XFhIosN7ym3Oh6SHk4P2pBh/8Fy72gA22PHtiGy6hG
         aWNZF46ksK+2NzGoxcf+UzCVqCpYoRlKXg/L5jSVUx36XVinmIWLjCWacOS5P9H2S3Lt
         p9sEBB013au7jYKKODrr8GomQpPfrwiWNq12vHFFoHYqqA05fN/5wqUXTX8gWVeXo59P
         Gg6U5pYXlVXm5IkZN7JAZLSolpCL05lstTMou10W93lv57ggwoVdoArEPnyfcFhTSNLb
         9ME58DBHDKDFhIcU55RMYg3Xl/VcWmJ480GTJKlwWDyL90JVnLPI7B10to0ofiM8kdPR
         Sppg==
X-Gm-Message-State: AOAM530cIzxcOKvbw/y3LSS+DOiFVYgLVfW2qhcLuh1CoczY8lFktIal
        tl444cSBU+DOifA4DKxCEDb7YLAUZMnJECFPyDAg8g==
X-Google-Smtp-Source: ABdhPJxOCRbu8A8q4BkFcPDtJPezbkcVlY8FkJlcElqcgfvFVPM3kVP1zzBdRSXrDTKOSVBlnEE0cN1aLxGQ1Ra8yZQ=
X-Received: by 2002:a19:40d2:: with SMTP id n201mr4360470lfa.82.1589010361888;
 Sat, 09 May 2020 00:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200508123042.775047422@linuxfoundation.org>
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 May 2020 13:15:48 +0530
Message-ID: <CA+G9fYv6g1ArV5u1raGkFtFKRqVJreP8dRe8r+XtOASPhN+PzQ@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/49] 5.6.12-rc1 review
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

On Fri, 8 May 2020 at 18:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.12 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.12-rc1.gz
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

kernel: 5.6.12-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 27749cf494a88f40047cf4c13a13536a41b454ed
git describe: v5.6.11-50-g27749cf494a8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.11-50-g27749cf494a8

No regressions (compared to build v5.6.11)

No fixes (compared to build v5.6.11)

Ran 30848 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* kselftest/net
* kselftest/networking
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ltp-open-posix-tests
* ltp-sched-tests
* network-basic-tests
* kvm-unit-tests
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
