Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06A5CE00E
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 13:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfJGLR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 07:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbfJGLR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 07:17:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B03521655;
        Mon,  7 Oct 2019 11:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570447074;
        bh=r+vLgFtRiNBdOslFnz2p04PFe5zb8gDhJ5YnivaVaUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UHyRWvhtEhmiGVo9uSRtjPrcdlBE95mlvJCePL9S79N6JNcY5f8eFGKBzFU5SOUll
         CkB1jBN3d6gQQzwY3Q7aMMMBImsQX8GQoUG85d2uDoF9R1A1/Iq0b0QtzctFH+6Fx6
         QC/9pP8DKzm1raC0FD/IoY6lMN9uvzUaCZJVGJ7M=
Date:   Mon, 7 Oct 2019 13:17:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 000/166] 5.3.5-stable review
Message-ID: <20191007111752.GA669414@kroah.com>
References: <20191006171212.850660298@linuxfoundation.org>
 <b71f3543-ba23-9e23-40aa-f958c0012182@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b71f3543-ba23-9e23-40aa-f958c0012182@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 11:09:04AM +0100, Jon Hunter wrote:
> 
> On 06/10/2019 18:19, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.5 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.3:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.3.5-rc1-ga2703e78c28a
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know

greg k-h
