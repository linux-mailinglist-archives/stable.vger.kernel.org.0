Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7DB151862
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 11:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgBDKDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 05:03:44 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39763 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgBDKDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 05:03:44 -0500
Received: by mail-lj1-f196.google.com with SMTP id o15so12361923ljg.6
        for <stable@vger.kernel.org>; Tue, 04 Feb 2020 02:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t6sE22BFWJuaXXDsiO7FA/020NBFi893pLEQAP7dUBQ=;
        b=rM0NS6wcfQCIv9d7NHUEUWDnsO/NbJaMedoKi4BmxtRKzXggFWo2RDXWlUFJ0Gw/nf
         pvjo9jh4M1E6WYEwAvOrckOdO6lpid30b1JIvPydDQhHebQS0CQzwkVbixZmSmAOdyJE
         F+G+ZsXRz+ufVqscKYAgfYDvkBe11P+Z/UELqOg0Zw7APkWH/jQJQ2I5QlpKErXCWa4M
         fKS+o0bRipnEyZmRUCf0iVipYRKxteXuaXwL+is8uR/xEH8XJHMNYogRrt3lDMIuBnLD
         RvDtlyucrbHm5HJrHukFPeIZa2IPEyaed42Tjp2fov6XcEdBaXFb08VWXsMVhArC6u04
         9cJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t6sE22BFWJuaXXDsiO7FA/020NBFi893pLEQAP7dUBQ=;
        b=TZRU4J26n8ecxtsMjEf+vKoUJS2GpZF3vXQlzENV91dQnEShIWy34o73cpLdZD6BTQ
         PBIx4fkVBUgwwe2GzyjrGm+L435fcsp+sowLFsxjTFndV27VGIOGzR4ZL6D/skokppWF
         ztBACAOMKKjvXtqp2ub5TQazQaPM1UaHsfTE5Rkri7HtdVJ6c6YyiOmvJhOj1npD06ny
         sVNiYprpZPovwMvhAG+2hPPaGmjp42jVJfuvxgMMGCu9zcDttTW3ZTLAsCM0wn6IYu20
         WdIEBLayzC9MSBmKTFIAg4PZpRBXzdmN1GG4AJQxSL6kdXwS16TvaxKrXnAlB5kAuiax
         1vzw==
X-Gm-Message-State: APjAAAUFMrzZqXvYSO+xAFFvoZ4OwuuYz+wAQudRZMleNVoojn2j9pmk
        wNdiUxC5Z0VhUg8GC31/BnPwPtU33e9DdxDgFtk4oQ==
X-Google-Smtp-Source: APXvYqyT3bDa5o7tDMylerK04ztSbFIu2yy3T8bURthgyjN9+22iHX/GuiiBRJj05A/8CvByvh3ohjlBYYFVN32UjGc=
X-Received: by 2002:a2e:9008:: with SMTP id h8mr16772977ljg.217.1580810621713;
 Tue, 04 Feb 2020 02:03:41 -0800 (PST)
MIME-Version: 1.0
References: <20200203161916.847439465@linuxfoundation.org>
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Feb 2020 15:33:30 +0530
Message-ID: <CA+G9fYs83tD7zDfJ1J0v4Xt4vrMxr5pMnVycRGUpPMCmAS6D1Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/89] 4.14.170-stable review
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

On Mon, 3 Feb 2020 at 21:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.170 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.170-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.170-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: b4137330c582d6b6dac367230affdf2c484637c4
git describe: v4.14.169-92-gb4137330c582
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.169-92-gb4137330c582


No regressions (compared to build v4.14.169)

No fixes (compared to build v4.14.169)

Ran 13571 total tests in the following environments and test suites.

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
