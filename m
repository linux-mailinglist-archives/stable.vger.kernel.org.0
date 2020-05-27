Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57E11E3BCB
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbgE0IRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387705AbgE0IRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:17:55 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1A6C03E97A
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:17:54 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id l15so27466915lje.9
        for <stable@vger.kernel.org>; Wed, 27 May 2020 01:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ansn8GEOG8puOy4spTYf8Y5HTDgRcZKk82joxsuYhzg=;
        b=y2F7kCk83loIuR9iQ9jfjKEChgmHWg6wgsSk5zHEQcJL0SXlc6sMmAd5i7Uz4eT8mA
         7gFMx9H+uNIvQjtkS5iH42LO3JIT6sTa3dRNDQVQ4z4eSz7hICpzLSevJu5Kjf5OYPAx
         NOOCDjMkWPsl/Gzm6vp0G2vOTs52xu6UTz3XUX8DvqjqPjki7au4DPykUzLH731RgqX0
         wQO+G+XGcNYVW0JFrPBoWrVmFjCzYv98arne9P8DQZisHP2i8HuLbFxsN36dWxwP+0Nl
         z0mF7nYoaf9iVfFWfY87rl9G8n2y75bpEbIIVu5X58VRwc8kuG2SVsJm0/eneukKdz8B
         VbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ansn8GEOG8puOy4spTYf8Y5HTDgRcZKk82joxsuYhzg=;
        b=YPTT3M8aqvRX71Isvr5HTJyjJ/wBW3sd5AF8+veAXULc6ijjxUMygWB3Vldv0lqKC7
         cefX2EyOgJcLmq9e6K9pcDV/ENQTpEJeSYAXw2xbqVW1TlroywopyVrGFS9UYn11Imia
         w4/0pqUnVuowtdWKB38bvrfU7Vs9v7kFEK9v3BUUWM5+jq7I57MYsDSW2l6BftgAF2DL
         2oocCTzcPCwzONEEjuLVB2aFzaUUjrKjn3V4QNhr1t7KWdbiFoBW8uiAq2CXBzrV79j7
         OEZKqoUU00J4BDmzwIOcztcQgDKlDStb9/LHfxcuUeFeUhos4W8db1h/ZPnyjUsIPmLs
         MbQw==
X-Gm-Message-State: AOAM5305emakVUSaRB3zD6LUJLTqXjjOpq3EOJIg7OltqtBJiYe0LudV
        QyfltUY4uHgKnh/Fd4dRNbVPislPTTuA/XtSra4e4A==
X-Google-Smtp-Source: ABdhPJz3cphxLhaIGy7Afp/ix//jxjtXMqBGUNYDN5oAq5zOp+PWKLu6KUhfoHXW2LmOLUes6/vPEuQYMsHK/oP2f+4=
X-Received: by 2002:a2e:9b4f:: with SMTP id o15mr2325240ljj.358.1590567473032;
 Wed, 27 May 2020 01:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200526183937.471379031@linuxfoundation.org>
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 May 2020 13:47:41 +0530
Message-ID: <CA+G9fYtbi+qgdu9ZeHPxKZyqON18WUdK1i=f9YpFQ2t58JCO-g@mail.gmail.com>
Subject: Re: [PATCH 5.6 000/126] 5.6.15-rc1 review
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

On Wed, 27 May 2020 at 00:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.15 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.15-rc1.gz
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

kernel: 5.6.15-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: f60f4a436b9c3ef788935570112493266ec1f860
git describe: v5.6.14-127-gf60f4a436b9c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.14-127-gf60f4a436b9c

No regressions (compared to build v5.6.14)

No fixes (compared to build v5.6.14)

Ran 31138 total tests in the following environments and test suites.

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
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* v4l2-compliance
* kselftest/net
* kselftest/networking
* libhugetlbfs
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
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
