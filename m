Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED1149B435
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 13:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384039AbiAYMnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:43:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45572 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451482AbiAYMk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:40:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C56DA612ED;
        Tue, 25 Jan 2022 12:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D710C340E0;
        Tue, 25 Jan 2022 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643114425;
        bh=mx0DvKjnIC23tbm60JZ4vLXJ/iDWJTXgRGeNJfsdvAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u/M/F7ubhrQBBuDUhuLKW7zh1WRd4gU+oIyFQYCVjdbqHSyryEXJBM6JEUJP/na2m
         tFK3q3v+HXxJgEUj+1vlMgazK30TCUVzaHItF/3GDzgUWYKhB7f6vJFWREHXVVRf6X
         fcTDe3dI9vB3TcIMAjhad1SAi7me8sfS+fmDHrro=
Date:   Tue, 25 Jan 2022 13:40:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/186] 4.14.263-rc1 review
Message-ID: <Ye/vtmYtku6yna4X@kroah.com>
References: <20220124183937.101330125@linuxfoundation.org>
 <CA+G9fYshfJ-WCB141=ha8uf0-FhE9Pim6hd5BWAVxDpvHhTR0w@mail.gmail.com>
 <CA+G9fYvPfpq+ptuzEW7S4S3o_vGxVGus4n0xAFxLoMzaH+Jnxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvPfpq+ptuzEW7S4S3o_vGxVGus4n0xAFxLoMzaH+Jnxw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:42:18PM +0530, Naresh Kamboju wrote:
> On Tue, 25 Jan 2022 at 16:58, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 25 Jan 2022 at 00:34, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.14.263 release.
> > > There are 186 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.263-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Following patch caused build failures on arm imx_v6_v7_defconfig
> >
> > > Lucas Stach <l.stach@pengutronix.de>
> > >     drm/etnaviv: limit submit sizes
> 
> The following patch might be missing,
> 
> commit 05916bed11b6d4c61b473a76220151a7d0547164
> Christian Gmeiner <christian.gmeiner@gmail.com>
>  drm/etnaviv: add uapi for perfmon feature
> 
> 

Thanks, I'll drop the limit commit from 4.14 and older as it doesn't
seem like this option is present on kernels older than 4.15.

thanks,

greg k-h
