Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219253CE708
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243710AbhGSQUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352490AbhGSQOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 12:14:04 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C70C0225AC
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 09:04:29 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id s23so5613267oiw.12
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 09:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2J/IJN7jTSaz10874klSZQm1VrNWG/qhaIIis0kLtYQ=;
        b=sypUeMmx597p9nhCkl1CQmvT/Mma6iF6Jv0fGO4xYcRqJiCUNDymJQFsWCtuhcu0bj
         rS1cBOsO5IxY91lSAwmgLaaMp4MkVRui5fvmEfGLOa/PQcijhrz/35vIJQXyrXII964G
         nuaZ01IKuR5AX/5YbsHdOlHCqPNX2v4GKAD/IY9UhZJKd3UgJ+7Ymb0/aBDQqq/kXEmp
         EFlnD0kfgpIIOusfU5YYtuQJD/zPf4u9Hqmlr6cix1IqGXsYPjs889WfTnmGAM6flcNr
         iMlUb2AGpRqH0cT/wfGn2zoT9xLoW7xOFcL3XlJuyHhxb31FN6J1ZS+bZBBGSfiDo1Fr
         aeng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2J/IJN7jTSaz10874klSZQm1VrNWG/qhaIIis0kLtYQ=;
        b=HG24zdgzL9Ki/JAWyjK9rydzjoON1JpunUfSrd/3Q6nXQMsV6defX9YVyT03L92W0E
         VPsYWY8rwvP2N1MRxaayB/NsZQ044omtZGG72RjL4FdzXLtpbhSSJEfRbzBq+SXRi1/2
         jJ2jZ6t51hffBgnhhBgJWjRmWhu016jD8Vl/YhxTtNLP0N18Rvw7faF/QqxQPLsCZ4OE
         NLcqKnyqKJ6viuFLex2N9PdrVCnvgUd65Re9W61qPDMBRqZhmkz2E+LeNUp4Lge9V9VB
         4an1T7WNwRPR4bwnNW4i3+Sj8wYoQUCDyY7Ytj5G7cKHwGjABJWKMTXUKC0urkbYTJM/
         upUQ==
X-Gm-Message-State: AOAM5303hmSJTYGJKtycNxoe6JwOz1Q0WBxfSR7MGspIuZ5W7WcD1q1o
        x+wU1zJW81MWVx+kgTnLiDxBQpPlp422e9eX4rjGhdekm4KAIkn+
X-Google-Smtp-Source: ABdhPJwXQgv+MnffwSXc9BXeRSV936RyyhNC8lxdnCS1gRFAcNCTLoF5HqVpY3wu1982brXNeIv2TfVyzM/1NbmGA90=
X-Received: by 2002:aca:eb53:: with SMTP id j80mr12866322oih.13.1626712092215;
 Mon, 19 Jul 2021 09:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144940.904087935@linuxfoundation.org>
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 21:58:00 +0530
Message-ID: <CA+G9fYv6TQOKp1O7JnN9zfEL_A5XP=VXRc3h-=n33jjXxP3OyA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/243] 5.10.52-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 at 21:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.52-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following build errors noticed on arm64 architecture on 5.10 branch.


> Kishon Vijay Abraham I <kishon@ti.com>
>     arm64: dts: ti: k3-j721e-common-proc-board: Use external clock for SERDES

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
/builds/linux/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:12:10:
fatal error: dt-bindings/phy/phy-cadence.h: No such file or directory
   12 | #include <dt-bindings/phy/phy-cadence.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[3]: *** [scripts/Makefile.lib:326:
arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:497:
arch/arm64/boot/dts/ti] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1358: dtbs] Error 2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
