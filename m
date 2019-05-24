Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593522935D
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 10:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389478AbfEXIrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 04:47:05 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36677 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389341AbfEXIrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 04:47:05 -0400
Received: by mail-lj1-f194.google.com with SMTP id z1so2464534ljb.3
        for <stable@vger.kernel.org>; Fri, 24 May 2019 01:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D7L5GE5a+8YpiIQZjTFaI3qIhJeh34C6y/gAPOQsDVw=;
        b=bpah6AOpJ5DaQnuwi1bjZs1eRf+OAqNLqpmevOsl8AdHE+SHB1tMf/rKIpLj32YEgG
         B/8Ekd1IOGtkFsbMcFq+gbt1umKWaeaXtgbtxadYZRDLJYkDolmglQD3WFEuNTca/ZLQ
         eCTSY6kl/BAlqGwO8znI6+6hWod0JvrqTWvgTsx7JNwudiKfY8f1Eb553PnfaUI03DQW
         wypQA1YVU0v3SNxL71IrXImz8jREm7GTmGQm+w18dE6RKKUtqrIMHqxVEsXblv+SNAX8
         XJmqt4SgVHe1yvW8N7/Xflf4kB4nMLclPkAR2TAf/8FusS3fX0vRIlhj1Hqa2f7VZU80
         CkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D7L5GE5a+8YpiIQZjTFaI3qIhJeh34C6y/gAPOQsDVw=;
        b=HgZjTQEKapXKk+fZf7a7YX9duYVoi9GZsU7JZX3+BjvxHLOj7brcXXSYBBfcSIMgAO
         TlonLNFbpos0g3h7vt6LS9oA19qsezbjH6UpavMXKQXIgTaai+EQH4T+F1tgga7fUz7d
         0SEusHMWguM7+kcEnQsH2i8uDUoFVqhiCvccVojURHRj+F1fL69E7yTKGPdLIvtVmEgS
         s6mckJEX9R/gwCmZXwvU3EzaGtUtgnRP4FBJfSEIGiCWJFces04MlXaAF/8gaWPZzeYD
         Feck+g4RX0XJGQvTCKeZK4dnYUNGCAwN5L6/YbLWZooxwLg01hyvntH9KPXxmYZYM0BG
         WbbA==
X-Gm-Message-State: APjAAAWXDV0cVGLi9qi3+PC8Iy7QY97gWftcdd337V3GQuNE/38cRvaB
        xFhJ4jhMiRSx3ohp4Iq2YYhX+OhUt0SVQD/t3F7RJQ==
X-Google-Smtp-Source: APXvYqxJTu4eqPExGfqgzlOpDmXBZZBRyMXP3q8difU9D0dP/dTYA6UcCuNbG8rONv16NjbJ5kdj+F9NC/r3zfw61Fk=
X-Received: by 2002:a2e:b0fc:: with SMTP id h28mr33668999ljl.55.1558687623654;
 Fri, 24 May 2019 01:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190523181719.982121681@linuxfoundation.org>
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 May 2019 14:16:51 +0530
Message-ID: <CA+G9fYtXD1Pyfmgkp2qYOg1mXmAghcNQ0zT6VrSBZZR-t=GyCg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/77] 4.14.122-stable review
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

On Fri, 24 May 2019 at 00:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.122 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 25 May 2019 06:15:09 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.122-rc1.gz
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

kernel: 4.14.122-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 64cb9b0bb7de34fd893ee96ecf613039130de9a6
git describe: v4.14.121-78-g64cb9b0bb7de
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.121-78-g64cb9b0bb7de


No regressions (compared to build v4.14.121)

No fixes (compared to build v4.14.121)

Ran 21731 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
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
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kvm-unit-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
