Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0C110D443
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 11:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfK2Kgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 05:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfK2Kgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 05:36:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 076B7217AB;
        Fri, 29 Nov 2019 10:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575023800;
        bh=wKFiPKYLyGNGPcYAElj1KHbSv2fZfqw/jJw3rwwHb7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vSoMF0Ie/Mn5LqUWya8MPd+aexvCPMri1wYl+fSyXJpIP5ihQxzy2bTujNsar+btP
         897M8n0waBTVF/ibemp0uVQe+BEwmwXnbKXwD41bL4lwLeNswRfEH3C+B0wdfDJSOR
         DGor4a2gs3DOaXN+cN4aP9CsNnoYiA4rGTB42bwM=
Date:   Fri, 29 Nov 2019 11:36:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
Message-ID: <20191129103637.GA3692623@kroah.com>
References: <20191127203049.431810767@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 09:28:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.157 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.157-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.

I have released a -rc3 version now:
 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.157-rc1.gz

that should have the i386 issues fixed, as well as all other reported
issues.

thanks,

greg k-h
