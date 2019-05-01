Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF54F10565
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 08:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfEAGCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 02:02:00 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40544 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfEAGCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 02:02:00 -0400
Received: by mail-lj1-f195.google.com with SMTP id d15so2842422ljc.7
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 23:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7HdZpXE0HHdmJXfhsZA0aoR/+VevFbxfmo/ahj3IOT4=;
        b=nTGnvuPQZBuuK2YZH2d1t/h3t2VnAltLJ+dnY0zEQ6HOWiIGOu4E4YC6enDGsmbUQQ
         W2gYVWY2snnvVIRZQkd8mhsMxLhNX+Orr9aQe98jFYE06a/xxo/nJEp6AEAdhuvMvSx7
         4mArBDNWNomvguzR58kljAmLB6PlLiESqcLKHpw868Z47dalOHL2QXynuvf2vgcOL5mv
         TPpyy+xIvy4hPEUl9KV7kPC1npz0r9jPMusQbjOqa9XwsDASgtFmZF0P5le0lOFr/V0j
         DwkpDFy88vQ1uHF4SnMdi/dIIiSu6lEpp8V6gj02vIpa3bewtDU3nyDegHdn8jd+lz1i
         GDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7HdZpXE0HHdmJXfhsZA0aoR/+VevFbxfmo/ahj3IOT4=;
        b=U9uZtXpYKHCPqggi7rAgz053nvwTOXUKYS9b7mblMcOfa0az0gfF2gLYugetd00mhb
         0iaCndTgWyauNL40xq2vZDZr0VWjPKzhoAjzTH9q1RzTe9ZegrdDaer0tbUlolyvozbi
         BnHv6N7pxMzciEn/yE03wXMkkFbbnjucaNpZrqEbr7AgqCATW5m1Sca+H+ZqTLJ5DfVG
         dFrKu6vRRqP+vixfoouiDr2cZDXz5tApSg0LkWnceUYgzdGsjcs5iGCbvr24xC828SuQ
         utXVmINN1kJsuKF2wotWY4pMoMDgk8xRr0H0+/fia5z2tDm1x4uWHMjRuq15og/1UVhP
         bXLQ==
X-Gm-Message-State: APjAAAWpJ7KSe5d30Bq3OKhRuyGwCfEU2SdwhN3Ksw3sZ4QUnu07a8rW
        vY52/CbimBQrAnQ4HLXrJhfy7oTTzRMYRtp0UqyBDw==
X-Google-Smtp-Source: APXvYqzZp0AuA/8B2FJcPdMgqV4w1XXo8YcWfTrdW8pyrtLVdzqWgYzvHondsqM5BafFwXGs7zN+WHIX6/nWDKevRJg=
X-Received: by 2002:a2e:9dcb:: with SMTP id x11mr3762924ljj.123.1556690518792;
 Tue, 30 Apr 2019 23:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190430113524.451237916@linuxfoundation.org>
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 1 May 2019 11:31:47 +0530
Message-ID: <CA+G9fYsy5K19cBWtqwsJ6sNFOLSj_9DGEo1pz-0Ykb3Ez7Qsew@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/41] 4.9.172-stable review
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

On Tue, 30 Apr 2019 at 17:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.172 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 02 May 2019 11:34:41 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.172-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.172-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: a707069e56d0b0365daa528a05c6388b41cfe4fa
git describe: v4.9.171-42-ga707069e56d0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.171-42-ga707069e56d0


No regressions (compared to build v4.9.171)

No fixes (compared to build v4.9.171)

Ran 22955 total tests in the following environments and test suites.

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
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
