Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B9B1B6042
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgDWQFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 12:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729318AbgDWQE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 12:04:59 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D92FC09B040
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 09:04:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id f11so2166898ljp.1
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 09:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hm2bR7NJE4YEd15tp6ZXOm1K8maVXsNNMYPSYBGCQdU=;
        b=DQdZSTern+IBZzJwVZXiyh/4VSSO/BdNVhzZMU+jA9jabJ1E7neFa3Gc0KHfg+qThG
         4mx7P9WXXTo9qMGYyWkglMEmm9zYCoiYWD+d3LF0gBHk8uEzihn91AtHvkEh4crkjE+M
         ijuVAcOYgB+PTNU+vXaL89vjCnu2N2jOnWUOpkccwzHr0qFpFXp3sQi1Fk5cRqY6cjT+
         zDk7i9QVa3qYuqx40sp/J4w7kVn068kpdJN/Ar5YeN2xgSXnI/VbTCfgcPZTtWbE6gRM
         tW94T6/i+mLhc+gfyqxyRXtE/WEfAnDRHRM+QFt5WUIwOjEBIYlbkSK3Ox788CjT4bvC
         fNUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hm2bR7NJE4YEd15tp6ZXOm1K8maVXsNNMYPSYBGCQdU=;
        b=ZA44o8oLrLDs/fqMjvQlk3ERIG9hlQnFM2HaBWmbuuHM8QGi0RKE9cL9HXy1OpMPCr
         eaR/KJlsTWEiQ/m/CKRPLZRp2jM/ix+gXWb++GRATw7qruy8klZl16jW7lsAHu5FRzOT
         o4juN+b3rXJP+Ym1t1jgq00iFV7zeXFj/iMjmGz01weAzokxxI49pXK+LC39vaB6UBd9
         rnAee29ngZoTph2EURokWPE+ScjkT6ZOVRkcNBy0SGF0u3R0sx0UD3VCNLWDqHN3OdhY
         z2ksS6KatbSTHHK3ZzGI5L0nbO0svEaiCuS1vXA0YVtort8FPEue9176TXTY4NKJg6k6
         cNjA==
X-Gm-Message-State: AGi0PuaxngMf3cKi9BZSHMEutxSlsxB8mAMId9Kop3rDAGNNEAqI3j+O
        Ne/kWH9Ml/bezHkTdddHXi81DEcOG3nRDIXsBJMkSg==
X-Google-Smtp-Source: APiQypIjBtFiqqA6Pm5Jvx80O9Av0E7JPyhm04I1pKSOhf27DjgRDj4v/wh/5hQ5sDhTJO7NzNhiZXmXtCuIpECz0nU=
X-Received: by 2002:a2e:9455:: with SMTP id o21mr2841437ljh.245.1587657897926;
 Thu, 23 Apr 2020 09:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200423103316.219054872@linuxfoundation.org>
In-Reply-To: <20200423103316.219054872@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 21:34:46 +0530
Message-ID: <CA+G9fYsX4-vcoVqp-vjD+LLkfDT18ngM=QXs07xrCuUBgYf7vw@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/124] 4.9.220-rc2 review
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

On Thu, 23 Apr 2020 at 16:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.220 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.220-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.9.220-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 01b8cf611034623c2ad49e23a48b0b99231b708f
git describe: v4.9.219-125-g01b8cf611034
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.219-125-g01b8cf611034

No regressions (compared to build v4.9.219)

No fixes (compared to build v4.9.219)

Ran 28201 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* kvm-unit-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest/net
* kselftest/networking

--=20
Linaro LKFT
https://lkft.linaro.org
