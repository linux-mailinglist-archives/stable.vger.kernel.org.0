Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094C62F8BCA
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 07:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbhAPGD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 01:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 01:03:57 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5998BC061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 22:03:17 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id p5so11990006oif.7
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 22:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4HUoXXGWdnIfA5TSFSTmFQJO3DvBZdlRBUOFJ/REQOs=;
        b=yLXy5fNE/PkZCTIdfY5nikiSc2QWszUyPs6vcEVfAYOxS7XOmRs1DIHVBpup117IUJ
         5ilbY9fbV83hHrbpdYpR9d/QHGFtHeCJvjK7DAnfIbxO09NxcDLIh6bq500WzLDA6NmA
         qPfaWk2fWsaw2fQNIbBmFK9Dz92BCAeEOUaxBWPjRt8/x30lMXMGkYMpT69W9ZbMiD6L
         NbuMnSX87ajCdLOYRSUEX8tjQo4B84ZLFQkseWcXeKbwDRzg3MK17iqJTeLx7nRC6Bq4
         1fvQNlNf7YO3KSxz5fAaWK7b3bgUMcmwKe21JVLBFy4b75Y1V8Q2nlU9EpdNLA5Ob/6j
         Arrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4HUoXXGWdnIfA5TSFSTmFQJO3DvBZdlRBUOFJ/REQOs=;
        b=G1iO+ND1kszXt7HSp84fO3APu2rSjCYWCwEmg7vc9fkleNOImZVfTm1FAHlgDL0UMv
         qQOcKVF6lZSHkMfyBm7TQjg98gDLhKj0XyXPtpRTFd6mdzcIY+KFimobhDGWL7Cw2kU5
         dC+k4Wk0EpoQJ/sxkYRJaQseZzxWU3k1vxBWiQXbe8sZZ8R7VcNFeOUgfiGe97ju8vZt
         ujpEshNe95n5KP4Hbnyhhg7bcWM6+87efHGsFJfxwcDax4fbScEFal6Wknek3uXKkrX8
         GknDtjbayrKEHO2PWcic0Kxtphs3zsVJuRFL+jhWgGoNm3Yz2nrbucXaKtPfvJhkQhnF
         p3QQ==
X-Gm-Message-State: AOAM533f6PMrZCmzdo2CU37L0sxMB7CjYHgcOG5BjpM/GVDNOJD4oil8
        G+FNTcSk0cf/b1bXQ1cqlot3XGxuBundCpzub9pDwQ==
X-Google-Smtp-Source: ABdhPJwS0jGP5RXCa2d9VBATjjaxTKR7qLeyll8F3zr78Bk9rIF52GkMWW+gEkwGDulKBvAEe8ZFxMho82AGrkgN7/Q=
X-Received: by 2002:aca:e187:: with SMTP id y129mr299048oig.0.1610776996628;
 Fri, 15 Jan 2021 22:03:16 -0800 (PST)
MIME-Version: 1.0
References: <20210115121957.037407908@linuxfoundation.org>
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 16 Jan 2021 11:33:05 +0530
Message-ID: <CA+G9fYs94h-VmyKENX0CS9MGsbLv3173ecCjjTUv=VUP+pO5aQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/43] 4.19.168-rc1 review
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

On Fri, 15 Jan 2021 at 18:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.168 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.168-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.168-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 710affe26b4363782b54ed8cc7bf77d6fdfbe151
git describe: v4.19.167-44-g710affe26b43
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.167-44-g710affe26b43

No regressions (compared to build v4.19.167)

No fixes (compared to build v4.19.167)

Ran 48282 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* fwts
* libhugetlbfs
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* network-basic-tests
* v4l2-compliance
* ltp-dio-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
