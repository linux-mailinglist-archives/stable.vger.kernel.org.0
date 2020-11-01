Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0996E2A1C8B
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 08:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgKAHT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 02:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgKAHT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 02:19:58 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80947C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 00:19:58 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t11so10853387edj.13
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 00:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7fLr8n4v++BYdQVjntzFedpbhGkp/PETEizIyiQCitY=;
        b=YDMoNsOHVDRP2g6AunP6ef+D8eMMTAQzsWrNoX2Y5gCLrETEMvKjhRMn7UostOMcW4
         +eW6PTfe5YU4L0my2oxkzzpoBB9UPSo1EGIbYfOHalVFBGYP5W/gE9Ef1wABkTMK3OFS
         l1RQ1wksKwsD59cLdQcX2ninBmVTdrWrNxlUtK8rSIELu4b204n/NC2PfibnSmqPQoy1
         wHZcM/lt+UF/VXLIgJDfulpWjwagsa1yYjjg8tRjZdmMznKLP9tZvFBKTQp9mzrl0vjb
         GLf6dnLnDwxareFB32DpXi0OAKMBVnIOnIxHzbbAxnMj/tlXPGf/aFqBYgT/65mfdnma
         mEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7fLr8n4v++BYdQVjntzFedpbhGkp/PETEizIyiQCitY=;
        b=sCLEkpq9HmRH71hG3RkxftCOkxynqClSayV33IX60dh4yImciN7tOZbPEf7y1pnQAq
         hK7wBaL9hTwPnJdSjARx/BhpgYcHb38JbIkVy4jYJKl7++oXABfi+WoI1JHRgvk+btZq
         8KFnecNS1tW4ECo6biEY72tCzp1cgaUHD27gH6gX3XV0QNcsjfjuxnXaI3FzEa6nS+Bz
         IwPoomSLTiLpLsBG6DXB058rMJGrCUhaxS+HS9fcwB/TvH4mHcXf70kctfe6kUnP4T5e
         kDFferkM15PfnHWPeLxu7KkbAc1O53rnnxW025D1H/cnrbOHi8+Ju0cCsOgHIbF12IWv
         R9rw==
X-Gm-Message-State: AOAM531ss7JYkMlp9Xt9QSAWNKryUjQEpxbQD71qxjqz8vAGrQ0smKCK
        YSE/n+754ddVA05VuOG8k6HuH/3vblQK1BWbUtmotg==
X-Google-Smtp-Source: ABdhPJwynBzAu84beiT1c5q4eSW8r5f/6Wr2ak1CWaS86EA5Fs2CbAcGblhcoFMBZUaMhIuupz41Uv3AbDrJ85ATVxQ=
X-Received: by 2002:aa7:df81:: with SMTP id b1mr3514459edy.365.1604215196916;
 Sun, 01 Nov 2020 00:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201031113459.481803250@linuxfoundation.org>
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 1 Nov 2020 12:49:45 +0530
Message-ID: <CA+G9fYu+iyL6d7NjsjU_4sBS82YJk90VTnuJv+w8KUj9fbdyTQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/70] 5.8.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 31 Oct 2020 at 17:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> -------------------------
> Note, this is going to be the LAST 5.8.y kernel release.  After this
> one, this branch is now end-of-life.  Please move to the 5.9.y branch at
> this point in time.
> -------------------------
>
> This is the start of the stable review cycle for the 5.8.18 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
LTP version upgrade to 20200930. Due to this change we have noticed few tes=
t
failures and fixes which are not related to kernel changes.

Summary
------------------------------------------------------------------------

kernel: 5.8.18-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 46e8244bb94fd0c961f1df918b14b2d3a3970398
git describe: v5.8.17-71-g46e8244bb94f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.=
y/build/v5.8.17-71-g46e8244bb94f

No regressions (compared to build v5.8.17)

No fixes (compared to build v5.8.17)

Fixes (compared to LTP 20200515)
These fixes are coming from LTP upgrade 20200930.

  ltp-commands-tests:
    * logrotate_sh

  ltp-containers-tests:
    * netns_netlink

  ltp-controllers-tests:
    * cpuset_hotplug

  ltp-crypto-tests:
    * af_alg02

  ltp-cve-tests:
    * cve-2017-17805
    * cve-2018-1000199

  ltp-syscalls-tests:
    * clock_gettime03
    * clone302
    * copy_file_range02
    * mknod07
    * ptrace08
    * syslog01
    * syslog02
    * syslog03
    * syslog04
    * syslog05
    * syslog07
    * syslog08
    * syslog09
    * syslog10

  ltp-open-posix-tests:
    * clocks_invaliddates

--=20
Linaro LKFT
https://lkft.linaro.org
