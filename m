Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A0941B177
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 16:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241068AbhI1OCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 10:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240898AbhI1OCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 10:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44B8A60F5B;
        Tue, 28 Sep 2021 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632837638;
        bh=5ce9ZVawoql2g8ZzUuUZzMTZ2C6WGYF2pEegE7ULnDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uD9BtqOk3MDTUafiiL+HMPag4/nmqUJ4jJJWiNYoFbsWhodPdlqKlsAOkOroAppVw
         fPW7Z0kdGTu6useIApzwtH0XF2fCqmytlyrTt4c3UwBLBOTq28t+t321vhLW2jNVgC
         0svi8gXL++kTjvkl90SQhEWzev+9JYR1kNC+G24U=
Date:   Tue, 28 Sep 2021 16:00:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rudi Heitbaum <rudi@heitbaum.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/161] 5.14.9-rc2 review
Message-ID: <YVMgBFkkVJsStK/O@kroah.com>
References: <20210928071739.782455217@linuxfoundation.org>
 <20210928124222.GA7@235a98196aae>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928124222.GA7@235a98196aae>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 28, 2021 at 10:42:27PM +1000, Rudi Heitbaum wrote:
> On Tue, Sep 28, 2021 at 09:19:04AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.9 release.
> > There are 161 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Sep 2021 07:17:13 +0000.
> > Anything received after that time might be too late.
> 
> Hi Greg,
> 
> the following patch causes IGC not to build as PTP_1588_CLOCK_OPTIONAL
> is not included in the 5.14.9-rc2 patch.
> 
> igc: fix build errors for PTP
> [ Upstream commit 87758511075ec961486fe78d7548dd709b524433 ]
> 
> the config is only found in 5.15rc on this commit:
> https://github.com/torvalds/linux/commit/e5f31552674e88bff3a4e3ca3e5357668b5f2973
> 
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index 82744a7501c7..c11d974a62d8 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -335,6 +335,7 @@ config IGC
>  	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
>  	default n
>  	depends on PCI
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	help
>  	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
>  	  family of adapters.

Ah, thanks, now deleted.  The "Fixes:" tags in this commit kind of lie :(

greg k-h
