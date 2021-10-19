Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55021432DE8
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhJSGN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhJSGN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E950860F25;
        Tue, 19 Oct 2021 06:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634623876;
        bh=VWOKxxLKrP0sUpT4jDwME3pyRSVTNfi3Nyuy/GcXwgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gWdzRQq17X2cuB1xOB+o/Rqff1PDyP9yePMhv/FIQxWNagUv106NvwxEmc68I7s1s
         vdV45oembbNWeU7+az6on1yDxaGwN2ppmROclBd0ubWxT1qBO9baxOXn5uYwMZnP+2
         PbO3gXdnda0GPEgx8rrtYlftCyGPoTPrQp8wpgoo=
Date:   Tue, 19 Oct 2021 08:11:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
Message-ID: <YW5hgeHTIyLUMMfY@kroah.com>
References: <20211018132340.682786018@linuxfoundation.org>
 <8289a310-d0f3-54ee-bcd1-50d172cffd27@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8289a310-d0f3-54ee-bcd1-50d172cffd27@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 04:40:03PM -0700, Guenter Roeck wrote:
> On 10/18/21 6:22 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.14 release.
> > There are 151 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> drivers/firmware/arm_ffa/bus.c:96:27: error: initialization of 'int (*)(struct device *)' from incompatible pointer type 'void (*)(struct device *)' [-Werror=incompatible-pointer-types]
>    96 |         .remove         = ffa_device_remove,
>       |                           ^~~~~~~~~~~~~~~~~
> drivers/firmware/arm_ffa/bus.c:96:27: note: (near initialization for 'ffa_bus_type.remove')

Ah, function type changes, I'll go fix this up now and push out a -rc2.

thanks,

greg k-h
