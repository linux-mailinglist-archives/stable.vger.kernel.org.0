Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABA019866
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 08:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfEJGer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 02:34:47 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40824 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfEJGer (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 02:34:47 -0400
Received: by mail-lj1-f194.google.com with SMTP id d15so4099631ljc.7
        for <stable@vger.kernel.org>; Thu, 09 May 2019 23:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BAEbwR8QRpMgjcJjAAVA2B4jt0AWF7IWj+Gsp1Up3jA=;
        b=Wsf8MuELCRvBk4EVLunFK6oxmiTHv+0fZJHzT6xl7314UO2UmnFYBAkAwD3hwAMsxz
         ZltavBvKemX/EUKsoR5C5SDVYsvL7fBL7dK1ZCSNKgE09ewByoK1OV6z70piqM/MQr/U
         lyrX2hGJ2L/HLv8zZH3xYJ/pBvGgux9dHxVgCbSQ/GE/NhBokzVq0ciAdfUCImhbuDvy
         D32QesRuRowtkVkZGgahXPYBFRvofvEN1uCnz1YtmNzb+cJ5kBdRFH48dY2JyudGl8l/
         G6WtyPCF4HlUFlgTzL9V8F/zg242xGWA3agoqm+J7fI2vyN0UD/6RqVmvNgHOcIOnhMS
         pnKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BAEbwR8QRpMgjcJjAAVA2B4jt0AWF7IWj+Gsp1Up3jA=;
        b=JgETAdQxx7NUmvG+mvZuFaIH5kmVbU6tyS6Hrc3ahQfJdqJzCArnNsAK5XyRJaL82w
         t7S78Ph4XG7aNDoUhhGV+uErKx50dUDj/PbStZpBrj7OavsoL+h/uoqiApiqh05efgYB
         /qG4HBVP1cdxFjwwBGpSgIl/Srjtzl1BfUfw3W7xmChf1Ru00f/gw7rwV22qexm9ayYr
         NvK21uVYYbnLbzKyTyyw0JbHD0FaHVktAo7YYYQt9CI/0LrsS+7ldlUDGK0WfK7JVLEO
         xVcE7wHVZ0X2ejpOMnAxAKJp13Twd76GIprtakZ1Vg8WN9yysHPlZfsL0GR1Vd0UZzWq
         hw5A==
X-Gm-Message-State: APjAAAUzV3nI05478AHEq68x5LS9Ok+fHY8Ib8pgAva9HLabk/EJcWcW
        fvrQGQHhro53Lx4Bbb8Z+RfYFm81hroWbLi2lIKHF5dS3IY=
X-Google-Smtp-Source: APXvYqyqSG7veyoUigRuOnafdOxwB/aTbJK1YNxE3BCd2WT2SrMTyti3XYmHl5WYfP0Op6ThILiyoK/xNS1L9TPpMVA=
X-Received: by 2002:a2e:9193:: with SMTP id f19mr4600756ljg.111.1557470084980;
 Thu, 09 May 2019 23:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190509181301.719249738@linuxfoundation.org>
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 10 May 2019 12:04:33 +0530
Message-ID: <CA+G9fYsJQsTaeFGpHqO2EH=67TfXB5KaUTWcfuk=88Ma+bL07Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/66] 4.19.42-stable review
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

On Fri, 10 May 2019 at 00:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.42 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 11 May 2019 06:11:18 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.42-rc1.gz
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

kernel: 4.19.42-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 82fd2fd59cffa3045f205da555c0defe8bb35912
git describe: v4.19.41-67-g82fd2fd59cff
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.41-67-g82fd2fd59cff

No regressions (compared to build v4.19.41)

No fixes (compared to build v4.19.41)

Ran 24988 total tests in the following environments and test suites.

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
