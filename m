Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA83FE0DC
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 16:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfKOPHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 10:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfKOPHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 10:07:51 -0500
Received: from localhost (unknown [122.147.212.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA5B20733;
        Fri, 15 Nov 2019 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573830470;
        bh=dhRhLDp9apleuZIXJcFzFMzceLE0xCrAf72x4cu0ydw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iWDnWDOz3fjMlWruHlQfjdC3mulEkmevVQmShncwUNsYiYKW9eBeSzuYNPHeizZ25
         bnRAtkIhfBhmHqiyiozIDSEe7ANd/tCmnTAsDKNzu7dem2o+UYZ+cgQQHOV2t+0aoK
         D+2i3biFeZCG7RcCOAZ0SbeVq5yNhzY5yBRk2NPc=
Date:   Fri, 15 Nov 2019 23:07:47 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/31] 4.9.202-stable review
Message-ID: <20191115150747.GA375474@kroah.com>
References: <20191115062009.813108457@linuxfoundation.org>
 <be8b3704-c780-ceaf-7775-3d1f21db6224@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be8b3704-c780-ceaf-7775-3d1f21db6224@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 01:50:56PM +0000, Jon Hunter wrote:
> 
> On 15/11/2019 06:20, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.202 release.
> > There are 31 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 17 Nov 2019 06:18:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.202-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v4.9:
>     8 builds:	8 pass, 0 fail
>     16 boots:	16 pass, 0 fail
>     24 tests:	24 pass, 0 fail
> 
> Linux version:	4.9.202-rc1-gd7f83e4f45e8
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing both of these and letting me know.

greg k-h
