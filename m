Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB51ECAC0
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 09:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgFCHoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 03:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFCHoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 03:44:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 929AC2077D;
        Wed,  3 Jun 2020 07:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591170241;
        bh=2lGJCN8NWYMBZyXsutEPTomSPKSzhCOLEfoHnsuMS+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U4IOqew7GuDCccsJap+uapKc3yEW+Pk+HQ4H0wvM1p3v6/ssMxyRClgfToPY9A2qC
         6Phb7D0byr5p1BUGs5iH/9VjRZsJOGHjvFH5E9pESjQGba0Ut0OY+ojGjqPu12xNok
         42iuAhGmBwWL9S/Vj6+ct3NHAAu6H6QXe/plH0KM=
Date:   Wed, 3 Jun 2020 09:43:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/76] 4.14.183-rc2 review
Message-ID: <20200603074359.GE612108@kroah.com>
References: <20200602101857.556161353@linuxfoundation.org>
 <7e459417-74fe-c76b-58b9-66dccf12ab2b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e459417-74fe-c76b-58b9-66dccf12ab2b@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 05:36:11PM +0100, Jon Hunter wrote:
> 
> On 02/06/2020 11:23, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.183 release.
> > There are 76 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.183-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v4.14:
>     8 builds:	8 pass, 0 fail
>     16 boots:	16 pass, 0 fail
>     24 tests:	24 pass, 0 fail
> 
> Linux version:	4.14.183-rc2-g3b54ad8f9c83
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Great, thanks for testing and letting me know.

greg k-h
