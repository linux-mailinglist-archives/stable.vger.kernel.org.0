Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB08A1CB0B5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgEHNpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgEHNpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 09:45:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A29B20708;
        Fri,  8 May 2020 13:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588945499;
        bh=N3mwTZU+1PKKy//dq7y0GjSG59F61XSZ+WRkYkyboXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hRAp0ejembiNIZMB9fLVYP7vbflLBw8XgRJreK+9X3WY4mDGlXSJYjDaTZs0GAu/l
         pmxd3BdAJEUvjVXa4jGSyHQg9Dnzj7KNIdVQ45gUJia9vCwwgynaE2xy9I92OtqLyX
         4u/NH+BrdD4UP6fZYvynl4JefYuvT8hoNf32rUO4=
Date:   Fri, 8 May 2020 15:44:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.4 000/312] 4.4.223-rc1 review
Message-ID: <20200508134457.GB196344@kroah.com>
References: <20200508123124.574959822@linuxfoundation.org>
 <CA+G9fYu5XMh+gkA9MBkg+yKAvHUEZBvRww-PbeiTnJYaYsN5ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu5XMh+gkA9MBkg+yKAvHUEZBvRww-PbeiTnJYaYsN5ag@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 07:08:35PM +0530, Naresh Kamboju wrote:
> On Fri, 8 May 2020 at 18:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.4.223 release.
> > There are 312 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.223-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> <trim>
> > Addy Ke <addy.ke@rock-chips.com>
> >     spi: rockchip: modify DMA max burst to 1
> 
> While building kernel Image for arm architecture the following error noticed
> on stable-rc 4.4 kernel branch
> 
>  # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build zImage
>  #
>  #
>  # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build modules
>  #
>  ../drivers/spi/spi-rockchip.c: In function ‘rockchip_spi_prepare_dma’:
>  ../drivers/spi/spi-rockchip.c:461:19: error: ‘struct dma_slave_caps’
> has no member named ‘max_burst’
>    461 |   if (rs->dma_caps.max_burst > 4)
>        |                   ^
>  ../drivers/spi/spi-rockchip.c:481:19: error: ‘struct dma_slave_caps’
> has no member named ‘max_burst’
>    481 |   if (rs->dma_caps.max_burst > 4)
>        |                   ^

I just dropped the offending patch, Guenter beat you to it :)

greg k-h
