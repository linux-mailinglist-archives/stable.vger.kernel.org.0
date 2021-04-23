Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0E3695CA
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhDWPNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhDWPNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:13:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5987611C2;
        Fri, 23 Apr 2021 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190766;
        bh=Usj/JnbL870erBHaJi42EflQIeo53zDXeIGrAQDO65E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GkkKf1DWYKrfZCBhzQ+eTcMeRhzABshVtNQFfPDuasze5SsNG/4zkud9G9fWZSztE
         sFG16CxfQQ+YwTZgskTFqfC1M1qIXTIeHeh8D4wkElpaBGE1IdfypsioM1HZNFTUL9
         wJpuSYDWh6nCltHlywEO6sT190hVURrtecfdrP6c=
Date:   Fri, 23 Apr 2021 17:12:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YILj7PfX+IOrF1zE@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <YH6bvUWCkchQhHrT@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH6bvUWCkchQhHrT@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 20, 2021 at 10:15:41AM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Apr 19, 2021 at 03:05:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.32 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> 
> Build test:
> mips (gcc version 10.3.1 20210419): 63 configs -> no new failure
> arm (gcc version 10.3.1 20210419): 105 configs -> no new failure
> x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure
> 
> Boot test:
> x86_64: Booted on my test laptop. No regression.
> x86_64: Booted on qemu. No regression.
> arm: Booted on rpi3b. No regression.
> 
> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> 
> 
> --
> Regards
> Sudip

Thanks for testing and letting me know.

greg k-h

