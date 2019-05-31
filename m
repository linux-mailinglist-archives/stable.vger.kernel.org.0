Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1A33080A
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 07:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfEaFQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 01:16:45 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36924 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaFQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 01:16:45 -0400
Received: by mail-lj1-f194.google.com with SMTP id h19so8301356ljj.4
        for <stable@vger.kernel.org>; Thu, 30 May 2019 22:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HcRZV1e7O6QUh/fBGMV8+j9NxW4Zg9BBnZO33APYf8o=;
        b=KKQ0U9L18071MLZsb6TZBxWXaWJynKYo/j3qau11Wp2TH15k6uAUiwKD9Coh3ijO3E
         WkkxCF1x38QM50onuqB+uMZmnLY5HykfRztE3BHX7uH5N86Lg6kavxxthF2ONdLnhYMf
         ATBN/T/xkwwmb5emICHbMpJ9TjGHF+qvvm69yrKBiemSdpfs3NFKPSRpGtUenKY6T+FY
         6kU51Am4t+lUd5J5nA++ewIZ3FcpRcQd5AIb5EtU7jbGLrxdGluDrGOY4Uh3I7aqbCF8
         ntuT2I63XUcBM7/7Lrz8aX9dSGs7si3bqgJOjl9ZRcDMem5Pr/Uvbh3oXg4nb4x5mU3Q
         pl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HcRZV1e7O6QUh/fBGMV8+j9NxW4Zg9BBnZO33APYf8o=;
        b=OZXkvlnfkmRIp3HU/I09B+yAAZIqPRkh+Izs/rlGbmFPDuUDpQgfsEsu3OR7I8gwaI
         nU3ozIlWUOWC8VpzacDSh16NOc+xTcHMkSVuAzD1JC5iiFHcQ29FNBBDwvm5Tr6HuJQK
         rS+Pt1lxeK+0Q3H0+KAJvzkY2a5b3aD/L+WCKxUYMsYlq9+qyNeKOfJGNcVPyfIXWB+J
         0IhvjUG143esbx35ExXOV0QgXz/vzRao8XvCUbJwkF8QFkqgpOKOAiIyNj+KMGF5OUpN
         29c5hTa0OC7Dp2jdXRdCeqxfh43GIpr9KLsJPTm1H87YkM+V3Y1iPM2jm7VNz8MXmNMM
         U5Pg==
X-Gm-Message-State: APjAAAWL9zdLQoPr9EYGcCv8MAnqCE/eI7iDGKcZ0Aj/gfu7oO6G7iYd
        aFmLzpR4kYFvwDlMSZikNHJzAEBPLxkzIFWJdN3+pA==
X-Google-Smtp-Source: APXvYqyzERQENey5Tx0RCNIrTmwDq1eVkkq7X/mDPE6csApvwIpMDAEjwky99bNmwPoirFQ4VrjewIeeKIr0kPg2BRM=
X-Received: by 2002:a2e:90d1:: with SMTP id o17mr4506969ljg.187.1559279803130;
 Thu, 30 May 2019 22:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190530030446.953835040@linuxfoundation.org>
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 31 May 2019 10:46:30 +0530
Message-ID: <CA+G9fYtFwFFtbfeAFwUOSMzFLDiOxfjApD96-aWzytO6HUJ5Nw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/193] 4.14.123-stable review
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

On Thu, 30 May 2019 at 08:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.123 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 01 Jun 2019 03:02:04 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.123-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.123-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 0352fa2fdaa68f3e27866e6f6a5125aa9efcefe4
git describe: v4.14.122-194-g0352fa2fdaa6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.122-194-g0352fa2fdaa6


No regressions (compared to build v4.14.122)

No fixes (compared to build v4.14.122)


Ran 22398 total tests in the following environments and test suites.

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
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-timers-tests
* spectre-meltdown-checker-test
* kselftest
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
