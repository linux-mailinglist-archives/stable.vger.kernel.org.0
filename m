Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805AF2A1C92
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 08:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgKAH1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 02:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgKAH1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 02:27:39 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790C6C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 00:27:39 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g25so10095891edm.6
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 00:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mn2UMvfHzFagu9gNZNtWC7eB1lBP5Y4hhVyWNZxCCLE=;
        b=HKgI8hjH9Q0HeWKUU7Xx4qwaROVk2ns6aGz8QhhrOUQ/pB63l9h9J3Ee20nOFJ5csB
         i//9IDQRFX6QDMrRVka0dR7H0cwGd2SvDNkz6RRJOt6xjfwbUwyfrtrpUvHuHmEcF67t
         2t5afkEr9hOh+LV4DmVhaomLfq3PX27rTiZOu5XCuGW2zq6DPyHVKP/EJdF0hNnFGtOp
         xnWmlCBumCFa+vNPRxCQPplQXRFy71JMlN73AfnHcFFIcEirmofOnXiX4tZZ8rJp9sx7
         kCuaw5ELBIIzKY2UEs02JvkciE57KVyYNQyHclw1hdSFLl5+MdQWQb3AuCbaKFTjtfF0
         Uv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mn2UMvfHzFagu9gNZNtWC7eB1lBP5Y4hhVyWNZxCCLE=;
        b=HEoWAbfORg9cp2PaRJI7zszDTw2ygi3GPD05XhK6MuvUsrWQoJzyrM6Vq5gZAMlPL/
         q51MEz6yZyjd9aUHB+GuHLxQCLXnZ7BxQm1R70zTfO9BdqWR83xNyEmW14IxeFNSdvSx
         MmG62vmarFsI4hHNBKzbTuZyn2jVrNqoP7G0QCwwDvD1IFQ0BeVmc351k2kY590h3qc5
         HFN9X8aUTKvGcq1jBFR1qkrU3fveFHD0TZv+ZyI2WmGhC5kL+J0c+/yP19JumBTp/138
         X1soVMptnRSgm68gJjqf8sYtNsk7l+L2LWBEAiLksyp5KNnoQkjs/1DlSm1gZaPIqM/h
         bzvQ==
X-Gm-Message-State: AOAM533lIq0WKR+UspqGWubaKUXxM6nL8JymIus8/Ye5hoLIsq+gTsUR
        lMJN9toKM0dYCsSLXZb8KzM7aNUFL+heaPMPjGb1zQ==
X-Google-Smtp-Source: ABdhPJw7i2pbnIEhfCKBkf0lVwl4vWsyDN8VGqLtKqEbCaR4C1S98nSUMxE1ED6FmGK2nQWI8WAnvZNxTZWnVzOnYHk=
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr11281755edb.52.1604215656920;
 Sun, 01 Nov 2020 00:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201031114242.348422479@linuxfoundation.org>
In-Reply-To: <20201031114242.348422479@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 1 Nov 2020 12:57:25 +0530
Message-ID: <CA+G9fYtw23F_PuCjiyVXz4464PsjcTSsL1jgvPP6D9xoZWZU7A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/48] 5.4.74-rc2 review
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

On Sat, 31 Oct 2020 at 17:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.74 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 02 Nov 2020 11:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.74-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.74-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: bf5ca41e70cb8c44990cf2b4c49b3b22e88537c6
git describe: v5.4.73-49-gbf5ca41e70cb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.73-49-gbf5ca41e70cb

No regressions (compared to build v5.4.73)

No fixes (compared to build v5.4.73)

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
