Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1712765F
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 08:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfLTHQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 02:16:22 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36807 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfLTHQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 02:16:22 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so8926780ljg.3
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 23:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rU63DQoZ1O4aDPnpUtZw0pffZuCh8kRgyB9M3LIWb4E=;
        b=gtO6XXyDoTOM5n+mXwcKILSvoVqjlbvl5cD47Lyey1mnjdeMhU9VY2iCkr/u5Oxp2S
         RXPp9gZKSdfi4o2ufGkUSGO7NH/QUlc2V9m6vYYOW/bBKF5sml3zKpTTOwMtUUFzZUkC
         4QhdgfsRxSB+cF8mdnoQ9pkTmdD8eq+KSYWugc71NLv/J1+BqfWQn63EAquBotZbIoVE
         PUlOy7GevxBx2fVj4yzgorLXIE00gjZHCRWO9Naxt2RyL2jGT+KWu+k6OwujOWMLnTe2
         uOEZhnE03MhiEqoRKnrMgOZAOlRdY7lDvGLGR4LjDCC8hIdVEzIoaTWxppzlDBtnyOks
         Nkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rU63DQoZ1O4aDPnpUtZw0pffZuCh8kRgyB9M3LIWb4E=;
        b=lgVMhBlVYLlOBsBA+McEoaDmmBQ3bUzYioy+Iu36Ph8OTCMGJhszLo2ICKmGdRGw8h
         v7lN9VyScPjIOdLZwEt+UAKlfeqKt2ZBj1UMAHL4k92eM8TtNz985zaMQiO55no0Q/iN
         VlejauNXhsWrAKRUMO0lzYNJtF+E6Pd8OjSIaCZBS2icDjZR/Ij65Ey36wO+Xhg63Uuj
         3k2wbvaLvVEdAsBPWo7nNOWBiIBggnANk8XQWCg48lbEKRBI0ZF/crvbTInnEjIOf9GP
         6Zx+LWYfmHQTrvFBfV1F5DDIhU6ephqdb21ij0HqhXFPvlxKddreDnKllkxQUDYMqrCS
         84tw==
X-Gm-Message-State: APjAAAXYFMP+BEkc5qnWspk6vA6EBmeAGB6xCREnXpJaz63g/VRZ2TAj
        JBQIAGGvV64jX00DNz90b46chO+7R07ZEy/YNOS3Sw==
X-Google-Smtp-Source: APXvYqzR9QnQOEeLIgxF/fG1xNuYVLN/zbfx0Rv89IsGu9U0rr72BDLAKp0m7xxG114XhbS3FnLJYGAGj3Ik//uuM3U=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr8876682ljd.227.1576826179423;
 Thu, 19 Dec 2019 23:16:19 -0800 (PST)
MIME-Version: 1.0
References: <20191219182857.659088743@linuxfoundation.org>
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Dec 2019 12:46:06 +0530
Message-ID: <CA+G9fYsSD5eNC8aMH6=o4fKC+1hs085mW2ZAhJPPR-tSn3=n1g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/47] 4.19.91-stable review
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

On Fri, 20 Dec 2019 at 00:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.91 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.91-rc1.gz
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

kernel: 4.19.91-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 631e9861976dab68c01c22dcd7d1a07ea91d4462
git describe: v4.19.90-48-g631e9861976d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.90-48-g631e9861976d

No regressions (compared to build v4.19.90)

No fixes (compared to build v4.19.90)

Ran 21464 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* spectre-meltdown-checker-test
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
