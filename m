Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D0C24BFD8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgHTNy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgHTNys (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 09:54:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7EE2067C;
        Thu, 20 Aug 2020 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597931688;
        bh=oKVOpcpSkfKIDtPvFVC3qWq7TGN/eeC3NiBoOqdIuXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GW7Q0a/t6ZEitG4lIQjt3ocAEXr8dS17hrh7PzO502zg3U2z76zgCb0W9XL70pPKe
         jb+kzRn8mtUZuZ47B3TP4JtnqtcgtRSBjvbqziK84cPLYsAIFpjKPelhrpWNdyg1aK
         mRKu6PwcHXab3PaonOvw627QW7eLW+NC6+Ze9i5Y=
Date:   Thu, 20 Aug 2020 15:55:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 000/232] 5.8.3-rc1 review
Message-ID: <20200820135508.GA1550003@kroah.com>
References: <20200820091612.692383444@linuxfoundation.org>
 <6c4e3ea709b14481b274c8d883d5ac65@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4e3ea709b14481b274c8d883d5ac65@HQMAIL105.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 12:49:48PM +0000, Jon Hunter wrote:
> On Thu, 20 Aug 2020 11:17:31 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.3 release.
> > There are 232 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.8:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.3-rc1-g201fff807310
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
