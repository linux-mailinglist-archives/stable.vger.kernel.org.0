Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E8C33006D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhCGLjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:39:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:32948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230289AbhCGLjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:39:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 219DB64FF2;
        Sun,  7 Mar 2021 11:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615117142;
        bh=VvGkrVRTqkfvpHKlz+wEiVaOi1yeTYSEfyQF6j+NvXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J5oCsSDFPJl44SsZxRu9N2pDJD1G9JBR1nKLGResUPNJJc0PTv82SeyIIW3CWMuRu
         8mx1PHRX8+ET9kzr933LnWSvRbJFNl7PuK2vWC4DcScNqw/htEmozoasNkVm1xyj7N
         XpoE2b2JG/GvcFDhmmp1Ivgp6QdqNOb3Hnb4Rm90=
Date:   Sun, 7 Mar 2021 12:39:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <YES7VPMzgCLxDHod@kroah.com>
References: <20210305120903.276489876@linuxfoundation.org>
 <cc21ec83-b6a1-d11d-280f-fd88120cea09@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc21ec83-b6a1-d11d-280f-fd88120cea09@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 09:31:52PM -0800, Florian Fainelli wrote:
> 
> 
> On 3/5/2021 4:20 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.21 release.
> > There are 102 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.21-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> 
> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for testing and letting me know.

greg k-h
