Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA61432E5E
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhJSGgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbhJSGgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 02:36:38 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B01EC061745
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 23:34:26 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i20so8616420edj.10
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 23:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w4bfGhHFx5oPk/Ib96uMGgu3xvRiI0n8bCnV0Igoo8Y=;
        b=dJ4KSlVlIzZzpmKHaAHOv1JHGchBxymCPM8yOzkF+KNgnHgSZZIGhPWUlgrHdQiJhR
         sGoZbPuqNLSopHBCAupkNBB2ucfB3yzOv3kO2j853mXSXkMrTJ1id9sXdFu4H9zmhk8H
         w+IKFvuRIQTunzkQ41VW3YdWcNNZkhkllgVyTsSBYAG+xJH7Sm6mzgnI8BT0kulLi2Rp
         Ncma57/eDNMj2aa7meO+NKbyNkYQwyeUVirRUlGi3dJMej7xxTuWef4uDZKlk1TbMcvA
         Ho5hIxu7Cxw4i6YOQpbpM4GW7XENCnHJiYQi+6SHtNhB0MBDraZD6Ul8XwDCQb7uJamE
         slyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w4bfGhHFx5oPk/Ib96uMGgu3xvRiI0n8bCnV0Igoo8Y=;
        b=rvsEfDsZPz7i5IizDDeBb9Ju11bAWnLRNzD6zwqum7oxJQdKsQFr8hdnzA2DaxZpYK
         UCDP/f3esmMG6GvKj2dilAKWvKkKkEmqWWGKcDlglhi5AehB/tRDc0yWaICQA3oprDxQ
         Y4ETkICifILJT9x/PgrhQnqa0M0qDGSrMVwfJfKBgEAbXfNXJV2Hy1HeqSJxuXcIEPjJ
         U1GWl2G7rhCbUQp/SQ4D5J9KxUdtqrKqfnbLB+b22H//St6mOF7xFns+30NxsoASJ/mt
         mjK9CrLlTYnLJ45aXilLsaesGG4wt4H/t0fPT9p/vTXHQNASI6DkWkWD6HbpDVwL0aOT
         Hd0A==
X-Gm-Message-State: AOAM530cRrkUEFSv4YVZPwE9ycSXGWyV8fqaE1OJ3YTXflEYZODPziAb
        USC1MRB8pK7B0KM6xIWq2exIY4AcNKvK2ZzZx5CC1g==
X-Google-Smtp-Source: ABdhPJyum2jlPf2KUlHw1paQNmraw3uCjjctCPCZ/6VLAGY9eh63oLQFugg5gRwS4CAIp2LrvTLkgNVIyEB7OOLJBUI=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr36810937ejb.6.1634625264554;
 Mon, 18 Oct 2021 23:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211018132340.682786018@linuxfoundation.org> <CA+G9fYtLTmosatvO8VBe-RDjEHEvY01P=Fw5mvRvwbxL31ahOA@mail.gmail.com>
 <YW5iBGg4VKP6ZL+O@kroah.com>
In-Reply-To: <YW5iBGg4VKP6ZL+O@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Oct 2021 12:04:13 +0530
Message-ID: <CA+G9fYv3mpZMZjoarc6=WNNzrer+xFX_diqVKMy1VFV=xhKpTg@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jens Wiklander <jens.wiklander@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Oct 2021 at 11:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 19, 2021 at 09:08:08AM +0530, Naresh Kamboju wrote:
> > On Mon, 18 Oct 2021 at 19:08, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.14.14 release.
> > > There are 151 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Following build errors noticed while building Linux stable rc 5.14
> > with gcc-11 allmodconfig for arm64 architecture.
> >
> >   - 5.14.14 gcc-11 arm64 allmodconfig FAILED
> >
> > > Sudeep Holla <sudeep.holla@arm.com>
> > >     firmware: arm_ffa: Add missing remove callback to ffa_bus_type
> >
> > drivers/firmware/arm_ffa/bus.c:96:27: error: initialization of 'int
> > (*)(struct device *)' from incompatible pointer type 'void (*)(struct
> > device *)' [-Werror=incompatible-pointer-types]
> >    96 |         .remove         = ffa_device_remove,
> >       |                           ^~~~~~~~~~~~~~~~~
> > drivers/firmware/arm_ffa/bus.c:96:27: note: (near initialization for
> > 'ffa_bus_type.remove')
> > cc1: some warnings being treated as errors
> >
> > Build config:
> > https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/config
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Thanks, will go fix this up now.
>
> > steps to reproduce:
> > https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/tuxmake_reproducer.sh
>
> Hm, no, those steps fail for me:
>         $ tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11 --kconfig allmodconfig
>         E: Unsupported architecture/toolchain combination: arm64/gcc-11
>
> What did I do wrong?

May i request to force install and try,

$ pip install --force-reinstall tuxmake
$ tuxmake --version              # this should get tuxmake 0.29.0
$ tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig allmodconfig

- Naresh
