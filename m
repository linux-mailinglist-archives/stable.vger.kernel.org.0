Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0546E15157A
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 06:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgBDFej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 00:34:39 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44029 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgBDFei (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 00:34:38 -0500
Received: by mail-lf1-f66.google.com with SMTP id 9so11303772lfq.10
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 21:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0KHT9BhfgYaqDdW1CHcbpVPcZ9QsrnR6avg+5+waSTw=;
        b=BMVwg8aHsjGccry3A+S0CiSUUP/XULw3LG/W1EJR/js6Qkacit7jys9CFw9lm78wXw
         JUge7PysVYyGE0Enjc41ZGjwXaJTeUCQONfp72AQO9Iljaf3dJnEbbB1lbDX1RCYM0vQ
         FTDgo90bntWOaf1+xbP/XmxkVu9dhbNPV/s8gNmjd6PWnJtn5C2VQFS2wPCJ56JXPpEk
         OJL5pwfhUsHPI3isDiTMrit007ng0/t4EHRwNyib16no427IGIkOwpwqy28GnWDj7Dse
         ESE+ACxER3vDGT7yRgvOXqh43NVMEwqBX8iWw3ce5Bq/eGPPLDcZ06tA4RI50GL0Y7p5
         uZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0KHT9BhfgYaqDdW1CHcbpVPcZ9QsrnR6avg+5+waSTw=;
        b=JiUPG8OsMfCG/XGRMNPQo1qrrtU1/fF6LiOzmi3GvZv3U2lTbNUTHUtc88S9bJmwj4
         R4XlTg7cc/7fIuEHsB6VDQRtnOUU/D7OSJHrCHv464/DxLGJmja9S8RsjoRjJZIFEsOT
         rOULsy3xaCBvOrk3Ofo8pg3QEdaYDMHSJQ97ZK+Fyusbp8oeawHQbQ5gNgLym6bR5J2e
         GEW7NcKzsUZkp/5GFEK7eg+TQq5tfJXsqpUtm0nO8oopzPFXh6ybpteAgLnx0A4v2Qd/
         IKbr+u9aorQE2SXi7EII9tzbqAdpvmNaE7oGYL02I51e5pjANUVxlxtAO4RO1mevTewY
         ziZw==
X-Gm-Message-State: APjAAAVJuO1zFpX4utwpwPqxjsxbuEtowkJEvJRyA2kikZKArAOShdbB
        7Q6+XeWZE2sKoKZoUDtxx3C7SSivPtta5k54FrblOw==
X-Google-Smtp-Source: APXvYqyh8ZtBIBNXC59ZOsX6YIz0B4nqBc5/8pd/XZs54VWPZaZL1d6OWZzI1+lD/ShiTe9kCo3277c4ajlkeA7VpuA=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr13484357lfc.6.1580794476891;
 Mon, 03 Feb 2020 21:34:36 -0800 (PST)
MIME-Version: 1.0
References: <20200203161904.705434837@linuxfoundation.org>
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Feb 2020 11:04:25 +0530
Message-ID: <CA+G9fYu00d=x9DrhdoTva9b+SGK3fOwmAF2QvVa+qH0rCPx2mw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/68] 4.9.213-stable review
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

On Mon, 3 Feb 2020 at 21:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.213 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.213-rc1.gz
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

kernel: 4.9.213-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 1fec4502bd05d2ac63a18e776d588d9fac65a35c
git describe: v4.9.212-70-g1fec4502bd05
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.212-70-g1fec4502bd05

No regressions (compared to build v4.9.212)

No fixes (compared to build v4.9.212)

Ran 15083 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
