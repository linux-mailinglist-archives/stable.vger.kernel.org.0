Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3262419BD50
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 10:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387574AbgDBIHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 04:07:31 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43935 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387476AbgDBIHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 04:07:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id n20so1901572lfl.10
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 01:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eooaPyyGEPHfmVsHpJUJuFilqkiRH1mDIj1guNanCkA=;
        b=OevCM+9jSn7Zc4bEY1F3FDRwJd1YexcIZ9Qo78p5FcW8GU50YAOU0ydnAGUVARwAsI
         oddvXXKpj5R1icye774vhlyTYIkUTxhY+r4e7l+uAl9Mm7vfd6aue9mFEyW3URuDAVKD
         EWT1gmzeXPWW8XMc4VOYiPE1BQCskg8EjsqMnIwabnMG6/K0dtkSpal7itKKaX81jcBU
         ZEAPVibGvw1e7tyfrDPK+TcHV50aX8yktCOdv3PuylK1VH5W39XePbZlHkhVX2ZSqEHd
         7fSwGNZ7o+9/3Kv0qJrIA88dLzCW35C0d+YcyrHL/N0V4H7qwbl4wvDhq2iUB/8e1SYl
         tWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eooaPyyGEPHfmVsHpJUJuFilqkiRH1mDIj1guNanCkA=;
        b=PHsh5Syvuqx5DDlmaFTRVvJ3cCQgLoMYlaR0ggJ1TsUuSTRaueAInf2xPegYg2ak6j
         WWKFEwwUtdwBP7SWRcNv2yb3IPmFFN3I+A6iEW0c1jQkjb1xwruA4Xmtxy8jCy9yo3O0
         PsPKWHrTKPYjikPa5apaAh0c2nmtDh+lBfeuzQsbb0+eUiPHf3eetRSaaCDByCnrvaXm
         gF5x+fYd5qdUNDreCbAQ8P4DhQeJQffEpIiEfNVrOP4uFsHqgBKgmdFmshJhIQKp38xN
         U5tW0SoV8o3p9CnajIarIi8GDa6tnihryL6lrDj2Hl2MSSkyOwIy+oRnAQlrYcK6yomv
         Yzxg==
X-Gm-Message-State: AGi0PubgRIE5YY4Yu4Gr4vkLox/TFwU5iYee2t84mZ7A1Vt4MtjKhWW2
        O5K6uWOA74lOnWQ5OF51H+pix65BFD/AdE+no966RzKerlc=
X-Google-Smtp-Source: APiQypKRQiZi7fSolJ5wqrlW+9kriH2NCRBRw6TY8ovFFr+o2+TxBRlzqa6N3CrK54+QepunOq4o0XN1Ra7pw8n2r50=
X-Received: by 2002:ac2:5183:: with SMTP id u3mr1414261lfi.26.1585814848630;
 Thu, 02 Apr 2020 01:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200401161542.669484650@linuxfoundation.org>
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Apr 2020 13:37:17 +0530
Message-ID: <CA+G9fYtSWuC-XGZ=a_9_5Hzj-yRSwFjgynfntF0u7_JDLUD18A@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/116] 4.19.114-rc1 review
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

On Wed, 1 Apr 2020 at 21:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.114 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.114-rc1.gz
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

kernel: 4.19.114-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 558d25f4fc651a7a3febb5018aa9135178a836db
git describe: v4.19.113-117-g558d25f4fc65
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.113-117-g558d25f4fc65

No regressions (compared to build v4.19.113)

No fixes (compared to build v4.19.113)

Ran 30648 total tests in the following environments and test suites.

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
* kselftest
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
