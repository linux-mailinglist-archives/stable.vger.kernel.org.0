Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A369BF9112
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 14:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfKLNwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 08:52:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfKLNwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 08:52:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 023222196E;
        Tue, 12 Nov 2019 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573566744;
        bh=VMGpjZvEQtqkYVq1NjTOWX9O5iHiFxX2+SrZBMEoRPk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sq9EEKBKObcpBY8tzqKkLjd6dJCjSwT7SjsinjNaZN9uByMOQGiVBczMLQDmR+x2u
         9Tu7tNJfH743BUT1Y9n23Zo1mBA2s9eoA6EAZ6c0jE6hhS2qAwCuAQb3Hy27kiCG9t
         hxqtnpZhpH5eLH5+j5RR9LN9WrB53GHhrdjs5jzs=
Date:   Tue, 12 Nov 2019 14:52:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/105] 4.14.154-stable review
Message-ID: <20191112135222.GA1331422@kroah.com>
References: <20191111181421.390326245@linuxfoundation.org>
 <20191112052822.GC1208865@kroah.com>
 <3f16154f-018f-1472-1c91-008f1199af7f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f16154f-018f-1472-1c91-008f1199af7f@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 12:01:03PM +0000, Jon Hunter wrote:
> 
> On 12/11/2019 05:28, Greg Kroah-Hartman wrote:
> > On Mon, Nov 11, 2019 at 07:27:30PM +0100, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 4.14.154 release.
> >> There are 105 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.154-rc1.gz
> > 
> > There is now a -rc2 out:
> >  	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.154-rc2.gz
> > 
> 
> All tests for Tegra are passing ...
> 
> Test results for stable-v4.14:
>     8 builds:	8 pass, 0 fail
>     16 boots:	16 pass, 0 fail
>     24 tests:	24 pass, 0 fail
> 
> Linux version:	4.14.154-rc2-gfc7e45ae100f
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Oh good, thanks for testing all of these and letting me know.

greg k-h
