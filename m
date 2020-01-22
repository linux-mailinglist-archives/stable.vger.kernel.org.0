Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92D5144BE0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 07:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgAVGm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 01:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgAVGm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 01:42:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FBE124655;
        Wed, 22 Jan 2020 06:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579675345;
        bh=OlUikUxjN7Pp2B66t9mUuPE7/j9xO5sHotrCZhjZpzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QWxu2CkQIDK6ahgJ92/0+ElmJ/CAbfuU9DlQ/uplYV3uoeDwyMAiSG6OVrbU4xHqJ
         7NGKRfjJam/mzj99RY6wQVTzgprFRKkOEzbgipKZhzmXQO1sZ26eMLVMb9TR5q0Qxg
         v6YMe0QYNt+VlQnu96lpESt398llLiwKEMymnKnw=
Date:   Wed, 22 Jan 2020 07:42:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6q-icore-mipi: Use 1.5 version of
 i.Core MX6DL
Message-ID: <20200122064223.GA2048571@kroah.com>
References: <20191230120021.32630-1-jagan@amarulasolutions.com>
 <20200109074625.GE4456@T480>
 <CA+G9fYvKw7ijk-vxA58SR_d0_-3_in28uFG5H6pikypgDpAHPQ@mail.gmail.com>
 <CAEUSe79LAxmMf31bt3hoEfUH3k3tqg=41mxy4yVJkYRTpw4k_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe79LAxmMf31bt3hoEfUH3k3tqg=41mxy4yVJkYRTpw4k_Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 21, 2020 at 05:07:41PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Mon, 20 Jan 2020 at 23:22, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > The following dtbs build error noticed for arm build on stable rc 4.19 branch.
> >
> > # make -sk KBUILD_BUILD_USER=KernelCI -C/linux ARCH=arm
> > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc O=build dtbs
> >  #
> >  ../arch/arm/boot/dts/imx6dl-icore-mipi.dts:11:10: fatal error:
> > imx6qdl-icore-1.5.dtsi: No such file or directory
> >     11 | #include "imx6qdl-icore-1.5.dtsi"
> >        |          ^~~~~~~~~~~~~~~~~~~~~~~~
> >  compilation terminated.
> >  make[2]: *** [scripts/Makefile.lib:294:
> > arch/arm/boot/dts/imx6dl-icore-mipi.dtb] Error 1
> 
> This failed again on the latest 4.19.98-rc1 from
> linux-stable-rc/4.19.y. Looks like it's missing 37c045d25e900 ("ARM:
> dts: imx6qdl: Add Engicam i.Core 1.5 MX6") from mainline.

Now fixed up, thanks.

greg k-h
