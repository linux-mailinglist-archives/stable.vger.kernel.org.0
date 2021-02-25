Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F2E324BEE
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhBYIVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235637AbhBYIVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 03:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746F464E20;
        Thu, 25 Feb 2021 08:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614241257;
        bh=iMeoBjzeFfpbu7+tl/5FrzCPg2irHTLYGC43/ajtGFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K3SNhUAIzyEjLv2Tg11FSv3fzaLqsKphLp9zZ+OqKd21eie6RKsWoSlwNDzuEPA9V
         RpGSkZ3ILF2jg3H9VflfMtE5LscQ3i93CJrtSwBCvuE6KkZtWCDdmRCvfDuETyc/oc
         bEVOSuK8YJ2cWfliIlbc5S8ihVfmd36rYRhhIaSI=
Date:   Thu, 25 Feb 2021 09:20:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.4 00/13] 5.4.100-rc1 review
Message-ID: <YDdd5lMwU3O1t1Nb@kroah.com>
References: <20210222121013.583922436@linuxfoundation.org>
 <8bf31a259854471a8c448905f47ebcb1@HQMAIL105.nvidia.com>
 <81009a52-c35c-ccd2-a430-171b9828216d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81009a52-c35c-ccd2-a430-171b9828216d@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 03:06:31PM +0000, Jon Hunter wrote:
> 
> On 23/02/2021 14:47, Jon Hunter wrote:
> > On Mon, 22 Feb 2021 13:13:17 +0100, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.4.100 release.
> >> There are 13 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.100-rc1.gz
> >> or in the git tree and branch at:
> >> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v5.4:
> >     12 builds:	12 pass, 0 fail
> >     26 boots:	26 pass, 0 fail
> >     57 tests:	56 pass, 1 fail
> > 
> > Linux version:	5.4.100-rc1-gb467dd44a81c
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                 tegra194-p2972-0000, tegra20-ventana,
> >                 tegra210-p2371-2180, tegra210-p3450-0000,
> >                 tegra30-cardhu-a04
> > 
> > Test failures:	tegra210-p2371-2180: tegra-audio-hda-playback.sh
> 
> 
> You can ignore the above failure. This is an intermittent failure we
> have been observing on this board and is not new to this -rc. This has
> been fixed by the following mainline and has been tagged for stable.
> 
> commit 1e0ca5467445bc1f41a9e403d6161a22f313dae7
> Author: Sameer Pujar <spujar@nvidia.com>
> Date:   Thu Jan 7 10:36:10 2021 +0530
> 
>     arm64: tegra: Add power-domain for Tegra210 HDA
> 
> Usually, I try to filter out these known issues, but missed this one.
> Anyway, for Tegra ...

Now queued that patch up, thanks.

greg k-h
