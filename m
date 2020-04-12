Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC31A5DEC
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 11:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgDLJ6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 05:58:55 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41504 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgDLJ6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Apr 2020 05:58:54 -0400
Received: by mail-lf1-f68.google.com with SMTP id u10so3259811lfo.8
        for <stable@vger.kernel.org>; Sun, 12 Apr 2020 02:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a9yLePZ2G/VXWV0ASH8NZRvDgdmjba14EvCAxqN8+9E=;
        b=Ynif4CWaFk8IzWGB8BMa77huV8EffPE9bjLc+92O6jtdyNk1cKnuCFMjojSX/CaMf8
         c0hRrNbxNBPv3f6l05bkq3FCow05ptzmkctsU/IK4MOc6UwngTwNat8qX8rtaI4yi+I7
         ghDhKAW9tljn3pNWBRy09mtZJvxdxaTfjEd/PupuSTy3VMKmm99VYFnCela3eyQT6jak
         aiza/DrFa0bKGUNW9/0cUcrsDSy+qGbnyvK0fPnzmmvP6XflsOfapOnPE2GVW8kUC0UX
         qcwJByLneu5fdiHFAZUXBAGPnQZBZQfaJl+uphrCmLtcFG3vi8VFqizYj2rttZ95NR1M
         n75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a9yLePZ2G/VXWV0ASH8NZRvDgdmjba14EvCAxqN8+9E=;
        b=Vv8jy2ePA+xN0F1QlgiKWbQm7ERhyruSw50nGW10+WUntJ6rRB6qc2twHBSGVWzfzg
         6MIaJmVn1uYnFkFHA9A8uoz8vIX1jb6823e5Nzkd7LcrAvXL223Kj+ya/SL5h7WI0dOv
         3aMpPlvu7ptWdcZVNgbjGX0MPtuY/YIpcBLAAA90SSGUBHXkNqwxbvXuRiYA2ulHK0WL
         2Pj+6nm1jsC0oG2Hffkzy/evu3y0yV1gWczMVHq2xqhdXq/Zj2vREzNNyIoRKQCOj1sV
         XHX9KzYpqC3XfrCaANx6vaiAsI+cyoc9uPMGXnzi4D/13yNRg0HOODav+hUJGlCstPco
         txnQ==
X-Gm-Message-State: AGi0PubODwnMlqHD9KCsFR2HFmFXf6017P5+XhPoxdieeosTDgtFKrI7
        6YAECYcn2oMey/1F6ZIdpKoQPv+fSbkQksJd7fq7CUI8qOA=
X-Google-Smtp-Source: APiQypKYz1EEvMGZ273zPuZUPVUX270HcGDlT2cPH7NuRr5hXW3fI57L+95xL/tG6Ba4x24gxRl703n3MAxrM9u48TU=
X-Received: by 2002:ac2:5559:: with SMTP id l25mr7533583lfk.55.1586685533011;
 Sun, 12 Apr 2020 02:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200411115418.455500023@linuxfoundation.org>
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 12 Apr 2020 15:28:41 +0530
Message-ID: <CA+G9fYuOH2EPwNMi+gqz4fd_i57_hnL9ekvjGuRsCaA-a4n-Wg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/32] 4.9.219-rc1 review
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

On Sat, 11 Apr 2020 at 17:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.219 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.219-rc1.gz
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

kernel: 4.9.219-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: ed218652c6a621a6c9bc9655eefed3c460f93d83
git describe: v4.9.218-33-ged218652c6a6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.218-33-ged218652c6a6

No regressions (compared to build v4.9.218)

No fixes (compared to build v4.9.218)

Ran 28926 total tests in the following environments and test suites.

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
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-sched-tests
* network-basic-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
