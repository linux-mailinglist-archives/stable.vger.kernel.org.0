Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0C93AEDD
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 08:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387732AbfFJGD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 02:03:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38422 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387614AbfFJGD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 02:03:56 -0400
Received: by mail-lj1-f193.google.com with SMTP id o13so6761884lji.5
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 23:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0Dm0JUHmNbBa06Nkd0nXLcKO7Ns6LtQgelo6VtXT2CY=;
        b=s1WMdgKlsVp4rFa+3bC516UluZ4qt1B/E6S+JzOfuYhyUzmKvVX0Kpxclg4qYYQIs3
         s2lsFrInQEHMA93PgySiXHETr3IBHnpIpYVDysaie23Y6hPMzPOtqh8oU0JdUaEKdHwp
         +ZBel3bP46oLjZRmq+koulsSzqq1/Zq2NVGpukJSjjw7viMPVcgvGr8m6y388JO83XRC
         uqfHdACnLklIGoWes5dO8mSeKM60kD9dnKD0E7kcTtM2guk2mhIVysFYVdPz4HgTW3QH
         I+sXW6akKVe8x4oEY+C4Mgmlgq71aeaFZGpQrY1xH4dY0QMHad52C1Kp9PlXD3DjQIKN
         Mu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0Dm0JUHmNbBa06Nkd0nXLcKO7Ns6LtQgelo6VtXT2CY=;
        b=CTDwwl4c4Y0Qbp5YtdTQPpiGdpSji1GvQ+ai09Q6LGagvbBXzdaNRD8rgcCcetOySI
         QPp7lU4hXcGGt3K7ddRNOVSf4LegrCAtkhf9TJTI9O1uql54sjW27QcFhGR//wkvtMCk
         NDJg0TXqk6OPyTbG+62YdS1fHw++OPfy0cOfmbVBO3yQqgsnBdJRevHeXnqKRk/j5RCV
         FoHQK1D+EyLswwPCnKp+vDw4AQxKMUv6WeMe0Mo2Ts/A1LqQS+HxaZLmGvQ4Rs5t6iOx
         6i+RgtNDlJgevGz47AnyHIum7Gxe5PRZ/o9fZxdeU1vohj3sAPVUrrS4sz1txzrzrN8y
         aYaQ==
X-Gm-Message-State: APjAAAVkhIc+tr9J+Y4Ss8Y51uscnX5br5utPTMTKx9/1Uni2iTaTzGj
        Jz7dc7d1IKe25BqgeC/UEMyfokVKNngL1xd5fHTkVQ==
X-Google-Smtp-Source: APXvYqzozS3RG8xkvD+3vVuLQoV4yxg+CI1GakigpKK4AKmL+ZCUNxNT4TKM5eUEBkLh4kTil+mk89HCugrTQUWYYqQ=
X-Received: by 2002:a2e:2b11:: with SMTP id q17mr35483218lje.23.1560146634750;
 Sun, 09 Jun 2019 23:03:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190609164127.541128197@linuxfoundation.org>
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 Jun 2019 11:33:43 +0530
Message-ID: <CA+G9fYuxGDX0pX0BROB7mJqJuCPYRshzae+cTnb_xQXEtBpgXA@mail.gmail.com>
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
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

On Sun, 9 Jun 2019 at 22:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.9 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
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

kernel: 5.1.9-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: 5b3d375b3838a28e769a56fdcb67d5422579d53b
git describe: v5.1.7-157-g5b3d375b3838
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.7-157-g5b3d375b3838

No regressions (compared to build v5.1.7)

No fixes (compared to build v5.1.7)

Ran 24361 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

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
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
