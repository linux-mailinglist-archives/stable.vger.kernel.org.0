Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF624C33
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 12:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfEUKF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 06:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfEUKF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 06:05:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD892173E;
        Tue, 21 May 2019 10:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558433125;
        bh=39Uw1k78fN2n18+7jTSZ1Y1MADqaJQ8CkRrnQCmPB24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/1pHWO/R8379whZ2GWPS6SZyIkfo7diF3SoUM9+fhhY600Yj1cakIqQIc2f6Qjxg
         uxBp8AWW5ABMXwCIIG48d7Hzp1nZMhUiuJODv8ubJdERAOZoTu/msXGKC1WeGGzho/
         J6gMn0qqL9U2R99y5YwIrfZaLImbNjRHMT1VB3dk=
Date:   Tue, 21 May 2019 12:05:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 000/128] 5.1.4-stable review
Message-ID: <20190521100522.GA20837@kroah.com>
References: <20190520115249.449077487@linuxfoundation.org>
 <4d98c3e4-42f0-5d70-a071-4ee455e09d2b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d98c3e4-42f0-5d70-a071-4ee455e09d2b@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 09:52:09AM +0100, Jon Hunter wrote:
> 
> On 20/05/2019 13:13, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.4 release.
> > There are 128 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 22 May 2019 11:50:41 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.1:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.1.4-rc1-gcce3bc9
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Many thanks for testing all of these and letting me know.

greg k-h
