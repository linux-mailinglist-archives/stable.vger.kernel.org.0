Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F83B1D96C2
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgESMyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgESMyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 08:54:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E202A2081A;
        Tue, 19 May 2020 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589892878;
        bh=y11pCBN/OhCyA6le7xtubNCV+K22LDiOpZqaPO+00Fs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r0ZH/3xru4qeEBfLVqtgWd5mp2+5dmbKhS+u76eFkGqoxu0ZjKZSnuVCPeJJyPFVB
         7wdgjmOwduOq/RiPum6ADFuXejMMNV09fZZHAR5icoP+hICJ8R4nGPEvddgf99EwED
         SidLIUcFKx06QrHWgO+ZVR8vmoMkYbGk/nUOUc70=
Date:   Tue, 19 May 2020 14:54:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 000/194] 5.6.14-rc1 review
Message-ID: <20200519125436.GB410029@kroah.com>
References: <20200518173531.455604187@linuxfoundation.org>
 <714571ae-b9be-8d11-0d47-08aab00ca23d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <714571ae-b9be-8d11-0d47-08aab00ca23d@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 09:52:13AM +0100, Jon Hunter wrote:
> 
> On 18/05/2020 18:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.14 release.
> > There are 194 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.6:
>     13 builds:	13 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     42 tests:	42 pass, 0 fail
> 
> Linux version:	5.6.14-rc2-g67346f550ad8
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
