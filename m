Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC43CAEBD
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhGOVwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 17:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhGOVwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 17:52:23 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAE7C06175F
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 14:49:29 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so7851642otl.0
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 14:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y1dOBgdQ3hrMd+YVDQYEcotLu5Ehk6yTJpr5uXkQiOs=;
        b=iQM8Bbsa6+s5E31gAFFr7UnEL02zPynbH+oJVKIfdE/w5PXSRGOY5IpTLQB36/Rue3
         CfnUUmeBKhb7NhQ3u62Etz6zwZdiHR0EW3+vFtPtH6tPeAUS/BVGSKStPXwfyriIoPc6
         dNg+UvgqHkp/Cbjsip5RQ0LdueHIubC+AActWEJN3EbJi0s6f1rhqseKLZ1E9zlZiqZK
         Qunf5j3kS6fHQ2oXf/arN2PbmT9vTAmJ0jrSL48OKe1EFXdVx39qh07e6ly3fjvFXFY5
         JYvR0v5Mmz4Z6oOXocxoY4mJ+SPgxrXLnpx2EXiSgZKPO8va5XWG3CogmbUUj9cLl9R/
         X8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y1dOBgdQ3hrMd+YVDQYEcotLu5Ehk6yTJpr5uXkQiOs=;
        b=thvF7T3j/kJh880/CpzNxuz1HlAVP6OiSX5b8ILy6PU8eNnInEU/Itrj67cFyyNw14
         DV+fA1R4DDfp1wt1SgLjixLy81ygiKeULED3iIPHQsXehovlrsbHWWYS3fBA7j9kF3cX
         hrtwwM/zPi/RiiTxEn26HGgGCtzu7CjMUaLfBkI7cFd7Uu0jcA8KSZl66Aax3G+4iwi1
         U3YFvPXo+prV9wJcfCNoOy3SGxcZ8f4v53yODl2mfdinNecEw1D8DyGOHQ3Jnl9O8+mZ
         04rPVueRNYgpoxUooVmXOcP7asHqFfLwbGKQkh9W0yn5deBpiKLRtq3OjTV1DDSwneDO
         GFuA==
X-Gm-Message-State: AOAM533+7dJyv385c09xJ93orQxANMeh6YR/24CDthXEDJbn2BP1zUbq
        DLkYMU4VX/SPNWoJvOX5akSKMX+dfTO2wr2O93iEAw==
X-Google-Smtp-Source: ABdhPJwrWuaKEX9nwRs+pv2yfk6eK+BGu8O2umTt+v/GV+qUh7yeiLdmOcKZ392NOumnyeV9/q+YC9bv7rYcQkx2hIo=
X-Received: by 2002:a9d:3e06:: with SMTP id a6mr5463289otd.50.1626385769016;
 Thu, 15 Jul 2021 14:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182551.731989182@linuxfoundation.org>
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Thu, 15 Jul 2021 16:49:16 -0500
Message-ID: <CAEUSe7_+8fQZ=1+jcxJVTRw0DYttGmR-aBdobZ0GWYQi3Vg97w@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        linux- stable <stable@vger.kernel.org>, svens@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Thu, 15 Jul 2021 at 13:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build regressions have been found on this release candidate (and on 5.13-rc=
).

## Regressions (compared to v5.12.17)
* s390, build
  - clang-10-allnoconfig
  - clang-10-defconfig
  - clang-10-tinyconfig
  - clang-11-allnoconfig
  - clang-11-defconfig
  - clang-11-tinyconfig
  - clang-12-allnoconfig
  - clang-12-defconfig
  - clang-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig
  - gcc-8-tinyconfig
  - gcc-9-allnoconfig
  - gcc-9-defconfig
  - gcc-9-tinyconfig
  - gcc-10-allnoconfig
  - gcc-10-defconfig
  - gcc-10-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[...]
> Sven Schnelle <svens@linux.ibm.com>
>     s390/signal: switch to using vdso for sigreturn and syscall restart
[...]

Our bisections pointed to this commit. Reverting it made the build pass aga=
in.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
