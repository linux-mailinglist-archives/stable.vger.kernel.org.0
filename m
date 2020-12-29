Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586C92E6F8C
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 10:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgL2JsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 04:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgL2JsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 04:48:06 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3E9C0613D6
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 01:47:25 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c7so12063827edv.6
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 01:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s7j4Pe6eJg0HCC4/qm6ul3siTUoFrSailmjqNjQmSwU=;
        b=vodT7B5xfjYHY1fr0hktexOhJSa5M0UaW8XANhd6Y0Um3/oo20wJYLT+PhXy+zyEor
         7fOEh8k6h3U32cSb3sueBewG7JVWyjcfkVxYUEhARuwZtZD/L1Du74Wv8sxRCYwJYSoM
         TSFFnBti3c5i5flOS/fAt0kJ4SdVEw1ReADnvS/B/v9jfk9eM6EiXHgJ++dmb0aWmUOq
         Wlz8keidhFceuqT3qPobhdbxoJ1qfzEqhIZf0ZF8JlYsG6gxhVbHYLmmGcxXhhr2xgKl
         088Pcs7wFIy8/cypeypS9SPrVy6a+HLlLL5XD3LUU7h7ga5hBIOxttniRoYgNh6R7kwH
         i5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s7j4Pe6eJg0HCC4/qm6ul3siTUoFrSailmjqNjQmSwU=;
        b=tE7vBG0hSWiReq/JRf69oib89xpBjslwLtkpjWe+EZB40vXwQeIg2pyc6ZSIsuqZFc
         3SEOSx8slO/sTjygEtwkzYbJ38N74EDFni6Or6W8SJoj0yTx/XfSqc4CyekXUSNr8X6/
         nUdE4sYl8xhBEHE2bGiLZDkNS6RdK4eEo3vgXUGqP6C829qZjt5kPqfGUgDrhzi8ODE8
         /rqer/eChHLQc5gzoka912C3I6EKz76Isg46Jgf0xPMN0Ue93AK+nQZt63HMGvLLZtPC
         kz4mb1bFQEAgeTMt7NUnr6+Rfce1mDRqt5kt6q2k47Cg8ophM1tAvK35aQeQ4U5KG1/0
         N/wQ==
X-Gm-Message-State: AOAM532ubWllnxRFx4Arn5cEOmU/sCmz1icONsUVC9aaykKsP5hLdL1X
        EbTK2dBHYQ+OJ2YK9xqnQv6JYi89pe7ogwUpiBxGLQ==
X-Google-Smtp-Source: ABdhPJzppc+LsnwptpBTJ08tJt1B0mmUqQMkSUCqCh6BfXTl1NUzZB3TrrvJRTMcCjBHaNBr0/yvdzwseecHn4mzUTY=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr45261063edb.365.1609235244527;
 Tue, 29 Dec 2020 01:47:24 -0800 (PST)
MIME-Version: 1.0
References: <20201228124846.409999325@linuxfoundation.org>
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Dec 2020 15:17:11 +0530
Message-ID: <CA+G9fYvyJ+tZ25WGagDgM=8Y1a-OaAB+8AeP7_3wPrp32o84Qw@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/132] 4.4.249-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 at 18:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.249 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.249-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.249-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 45f5fd21658c73f302ca6e7a05952b9354835354
git describe: v4.4.248-133-g45f5fd21658c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.248-133-g45f5fd21658c

No regressions (compared to build v4.4.248)

No fixes (compared to build v4.4.248)

Ran 22873 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* fwts

Summary
------------------------------------------------------------------------

kernel: 4.4.249-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.249-rc1-hikey-20201228-883
git commit: 8260d75b2737884615cf923d8a1708725a92738e
git describe: 4.4.249-rc1-hikey-20201228-883
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.249-rc1-hikey-20201228-883

No regressions (compared to build 4.4.249-rc1-hikey-20201223-880)

No fixes (compared to build 4.4.249-rc1-hikey-20201223-880)

Ran 1698 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
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
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
