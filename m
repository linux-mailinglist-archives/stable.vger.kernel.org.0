Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4A929E92A
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 11:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgJ2KnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 06:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgJ2KnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 06:43:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61929206FA;
        Thu, 29 Oct 2020 10:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603968153;
        bh=cx0F/Xe6TVfImUYlAuAeX/M0U/YRMbjTYwymxfmVnqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R1yuWgmDmlqp34MGPyEBABNOzMkrwW2fPNV3ERxVnS2hvIGR7Pcr2Eu+UxwGi9ZLw
         bnqs3c50Kk3huTq4fpvWSLE13RoZLcnfb2QaNsAa0mzsi6cO9NpbnPTI/Mw0UlhLPQ
         qmX/797URra3D/D9aZToriwcHpz47kcP8JnaN9q0=
Date:   Thu, 29 Oct 2020 11:43:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
Message-ID: <20201029104322.GA3792404@kroah.com>
References: <20201027135450.497324313@linuxfoundation.org>
 <412e3347-96bc-a0c4-06d2-27735bc5a992@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e3347-96bc-a0c4-06d2-27735bc5a992@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 09:13:01AM +0000, Jon Hunter wrote:
> 
> On 27/10/2020 13:44, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.2 release.
> > There are 757 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Oct 2020 13:52:54 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> One known/expected failure, but all other tests passing for Tegra ...
> 
> Test results for stable-v5.9:
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     61 tests:	60 pass, 1 fail
> 
> Linux version:	5.9.2-rc1-ge0fc09529493
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> 
> The above failure is fixed in the mainline by the following commit ...
> 
> commit 97148d0ae5303bcc18fcd1c9b968a9485292f32a
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Tue Oct 13 10:42:47 2020 +0530
> 
>     cpufreq: Improve code around unlisted freq check
> 
> 
> Let me know if we can pull into linux-5.9.y.

Thanks, I'll go queue that up now.

And thanks for testing all of these, much appreciated.

greg k-h
