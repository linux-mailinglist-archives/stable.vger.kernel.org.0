Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A126CBFD
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbfGRJhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbfGRJhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 05:37:06 -0400
Received: from localhost (unknown [113.157.217.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AD6B20693;
        Thu, 18 Jul 2019 09:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563442625;
        bh=zGM+s3xtBx2lFYIls5XjXhQk5pprIX0HYgAJe/Iy00w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CWfgxPU4vk3vjIn5u95Nsr2hyxlTKa70gTaxz5KxUaW/T0e94KTRAZgdFCRaEWeUg
         lsSG79x4AEGXwrH1R+aaIeCOM2A3Ysxinn5X2RFKJ0Cu/FStaNSfbUE9UMfhr9RDLH
         JE7xrdakhB72+zL2I3jNTvIACvWBhEjGIZpVkcQA=
Date:   Thu, 18 Jul 2019 18:37:02 +0900
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/21] 5.2.2-stable review
Message-ID: <20190718093702.GA9689@kroah.com>
References: <20190718030030.456918453@linuxfoundation.org>
 <b4fe5385-9e61-51ad-0dd1-2910c529e083@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4fe5385-9e61-51ad-0dd1-2910c529e083@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 10:21:40AM +0100, Jon Hunter wrote:
> 
> On 18/07/2019 04:01, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.2 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.2-rc1-gcc78552c7d92
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
