Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD731A78FB
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438804AbgDNK6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438799AbgDNK56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 06:57:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDEE6206D5;
        Tue, 14 Apr 2020 10:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586861878;
        bh=1WrB2l0FmNWsKcNwWuK1uCKo6/mJ1BOM4N7ZW/C64zc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jbgC1oMqt8PcwlQ0hf/ww976DFjpwMEMv0xnwgD8Q+MiXfcV4a61v4tmqivvVdyRR
         iKTKvHCGhr0r62CdleENMgGKd5IQhQb+X7t5pv6azVoO+R05L39ubjKl37INHHr1rQ
         hBWaBwG2Sg7nujknMO5AQrFWCMter3d8c2/zodV0=
Date:   Tue, 14 Apr 2020 12:57:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/29] 4.4.219-rc1 review
Message-ID: <20200414105756.GA284526@kroah.com>
References: <20200411115407.651296755@linuxfoundation.org>
 <63b31c56-b5c9-2ced-ee00-772fa9a1dcaf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63b31c56-b5c9-2ced-ee00-772fa9a1dcaf@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 11:35:53AM +0100, Jon Hunter wrote:
> 
> On 11/04/2020 13:08, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.219 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.219-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Sorry this is late, but all tests are passing for Tegra ...
> 
> Test results for stable-v4.4:
>     6 builds:	6 pass, 0 fail
>     12 boots:	12 pass, 0 fail
>     19 tests:	19 pass, 0 fail
> 
> Linux version:	4.4.219-rc1-g8cd74c57ff4a
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra30-cardhu-a04
> 

No problems, thanks for testing all of these and letting me know.

greg k-h
