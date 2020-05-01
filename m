Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6527F1C204D
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgEAWFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 18:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgEAWFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 18:05:48 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43FEC061A0E
        for <stable@vger.kernel.org>; Fri,  1 May 2020 15:05:47 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id z22so4759406lfd.0
        for <stable@vger.kernel.org>; Fri, 01 May 2020 15:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D35YkwDRODUfRvwvcmANGknLzjxX5QrKLRN7hFB2I40=;
        b=VhteV4py4J6ozpQ26bmquV/e1t8SpLSQnR2kAKgyHRkyz7ED/eMuv9cgNlzJzUT1rc
         2LoBxv7vOuyLw+UoBE8o/+apLIa2U8fppWwz2tLeXPkYJ6ppL6GQ/GCn28Jl8KkzUVru
         3Z3Rujoq7n3LdiwUMAgnq4xahfZGRzQ3IqH9bcziVhI2OzZAOTIwmbVWXoYL2yfnVxXU
         V9OcMeJJLRCTSHRx5lchX+Tld6mPbPzv9F6uCNnGLdNqMzJx87J07Heiu+2jLhcBRkSJ
         dgJaRy0S0PFixiFbBOLeR/NWgwhKFhkZBq2N3bMfSTCNGxf6XjnWt0D8B8zAO4HDchg/
         4veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D35YkwDRODUfRvwvcmANGknLzjxX5QrKLRN7hFB2I40=;
        b=uEGTjzetaV/lcoH0I6lIiYi9iREhTpn9Hbkkwk4KGIJYdDvrgh5WM1+0dBuJflc4kn
         xizmdAIw02ue/xgHcVZW8G6uJs75jTzrOIUI02Etqf+p+Qu2ddrtvNV2KiAzFD82YOx7
         SfPqrDlyC0KTz8TwELZgHIO+83PMEZNfV8SrRcJOUZ1mugVUMi5HuIudOBTXhzmW7bVz
         fFfrEfC4ulLS1ggCqcGudz+1KUC1lOxNfsxaSl4n5NfbmbzUV6oUrauwuYcInzNOuAOA
         IRFOMQrGCGwCoFkdDGfL6HLqiGwjuKUF2zTbN7en44JbwbBBtX7V3lh3vmgkv1h0ilUf
         XX4A==
X-Gm-Message-State: AGi0PuaN7R1VQpBuaceiUrF7p94Xrwnzp6XraJ/EdVcclsmujBqoooNN
        5gIaRz6Tz8fhJY+3VbyCehyVLNbQoKns/7TbXO+z8A==
X-Google-Smtp-Source: APiQypJBl+klkEZyt8zKneQcjFpdynoQUuSSB6s2Eje9g9EeRnBt72fDLDY0peXoWTJvdSgB9+iBbAfPvwE4Q2avzCw=
X-Received: by 2002:a19:d:: with SMTP id 13mr3820547lfa.167.1588370745914;
 Fri, 01 May 2020 15:05:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200501131457.023036302@linuxfoundation.org>
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 2 May 2020 03:35:34 +0530
Message-ID: <CA+G9fYv0uQ3rQXOoZ_SqrcdBFRqvhX9OEmx84EoQfGgztOFZJQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/46] 4.19.120-rc1 review
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

On Fri, 1 May 2020 at 19:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.120 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.120-rc1.gz
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

kernel: 4.19.120-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 81d4e31e141844fdb5678510f819e09de1c9f607
git describe: v4.19.119-47-g81d4e31e1418
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.119-47-g81d4e31e1418

No regressions (compared to build v5.6.8)

No fixes (compared to build v5.6.8)

Ran 28833 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* network-basic-tests
* perf
* libhugetlbfs
* ltp-fs-tests
* ltp-open-posix-tests
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
