Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629F62A2ACF
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 13:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgKBMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 07:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgKBMha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 07:37:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68147223B0;
        Mon,  2 Nov 2020 12:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604320650;
        bh=1igenCLWym4AnoSYMY198x2kDAPbJWttXtHAz+KaFZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=foP9xlYMjZwjS5ODAihURoJjhIU1w4IFe2+kPHPXr2A9/+n3QuBaovrL3cJRqxXdW
         OMK1czLHLh3qt4E0qpS0vJ6yAgqczhi/Y6ybaeUthJdyxPegW/LTqN1lelrz6QE7LQ
         TftuxRRn4Z25jqtiVleCOcdiPwvfpJF9m68LRujA=
Date:   Mon, 2 Nov 2020 13:38:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.4 00/48] 5.4.74-rc2 review
Message-ID: <20201102123824.GA754567@kroah.com>
References: <20201031114242.348422479@linuxfoundation.org>
 <d51554c67f17476198038de0eda9bc7c@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d51554c67f17476198038de0eda9bc7c@HQMAIL105.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 09:53:53AM +0000, Jon Hunter wrote:
> On Sat, 31 Oct 2020 12:51:00 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.74 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 02 Nov 2020 11:42:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.74-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.4:
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.4.74-rc2-gbf5ca41e70cb
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
