Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D07D337B1D
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCKRkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCKRkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 12:40:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC1E964F97;
        Thu, 11 Mar 2021 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615484401;
        bh=vntxNnegcJrWfmKpBd/RRfJoNhdvG016ezr6Z0NSOkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1QsK3d7tBHkYM2mWOvCl5CqTP+g1pmVH8j+im3AIS97dTwMA7glfcIoN51tTpEPXb
         py71g4Hyh2JEX/JnhKBi4y7GLlY7peYsbOAgTp8NCx1fk23A4834ye6OWy45ebxQ1/
         GctDYcAI9p1928qq9GCKzBdTza6fCzKyOVgSJTgw=
Date:   Thu, 11 Mar 2021 18:39:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
Message-ID: <YEpV7t2BJVYSBO78@kroah.com>
References: <20210310182834.696191666@linuxfoundation.org>
 <70e77e00-15c0-74d8-052e-deeb61c67538@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70e77e00-15c0-74d8-052e-deeb61c67538@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 08:34:07PM -0800, Florian Fainelli wrote:
> 
> 
> On 3/10/2021 10:29 AM, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.10.23 release.
> > There are 47 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 12 Mar 2021 18:28:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.23-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for testing and letting me know.

greg k-h
