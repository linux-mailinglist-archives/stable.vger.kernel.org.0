Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3076309502
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 12:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhA3Lxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 06:53:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhA3Lxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 06:53:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8635564DF5;
        Sat, 30 Jan 2021 11:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612007575;
        bh=J4GSi+lxn1Bicmic+21Spp567TfdK1I5sS3lcQLiErg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n3dy/7gRlKibaAFW51UxTSsCw5Ae7lx5KLqCFEYWA3ja/l1nGBgQJBL4Gn3H7gfqC
         xOyq5cHeToxnBUoOoTYK5rho915b06Cn16wZTDti/2XZiByV+IXVphESCL7FP27iqW
         3egXcr42RHb+o6fGiXUaUbsrpw8OYZKTHMUyT8ko=
Date:   Sat, 30 Jan 2021 12:52:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.9 00/30] 4.9.254-rc1 review
Message-ID: <YBVIlENhvmBEndsU@kroah.com>
References: <20210129105910.583037839@linuxfoundation.org>
 <7002f2eaccbe4822ace69408bdf67448@HQMAIL105.nvidia.com>
 <f39129e5-6d38-6c33-f31e-cf15e4c0399d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f39129e5-6d38-6c33-f31e-cf15e4c0399d@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 30, 2021 at 11:12:43AM +0000, Jon Hunter wrote:
> 
> On 29/01/2021 19:08, Jon Hunter wrote:
> > On Fri, 29 Jan 2021 12:06:36 +0100, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 4.9.254 release.
> >> There are 30 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.254-rc1.gz
> >> or in the git tree and branch at:
> >> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> > 
> > All tests passing for Tegra ...
> > 
> > Test results for stable-v4.9:
> >     8 builds:	8 pass, 0 fail
> >     16 boots:	16 pass, 0 fail
> >     30 tests:	30 pass, 0 fail
> > 
> > Linux version:	4.9.254-rc1-g1aa322729224
> > Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
> >                 tegra210-p2371-2180, tegra30-cardhu-a04
> > 
> > Tested-by: Jon Hunter <jonathanh@nvidia.com>
> > 
> > Jon
> 
> 
> For some reason I don't appear to be receiving the 'review' request
> emails. We have a script that checks for them on lore.kernel.org/lkml
> but I don't seem to find them there either ...
> 
> https://lore.kernel.org/lkml/?q=%5BPATCH+4.14+00%2F50%5D+4.14.218-rc1+review
> 
> https://lore.kernel.org/lkml/?q=%5BPATCH+4.19+00%2F26%5D+4.19.172-rc1+review
> 
> I thought it was our mail server but then I would have thought I would
> see them on lore. I often see a delay but they usually arrive within a day.

vger.kernel.org has been having some problems for the past few days in
sending messages out, which is why they wouldn't show up in lore as well
if they never get sent from the server.

I can add you as a direct cc: to the -rc announcements if you want me
to, to prevent this type of thing.  Just let me know if you, or anyone
else, wants on them.

thanks,

greg k-h
