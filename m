Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCB3113D4E
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 09:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfLEIsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 03:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfLEIsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 03:48:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7175F205ED;
        Thu,  5 Dec 2019 08:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575535684;
        bh=YtB2fOqwzxp8zm7BFBVnMAxbxDUlajcsusZ6yuLGx7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XSTIUav6yzp2HJQrUeeGLlunNiBJmCuwx4kcWOnD5ql/EoPhgXb3rqqYH+PLLDd79
         o+qc6f0JOJ5fV0yyNxsZ/hNPcShiVqNNX5IOmzNtcwouul5oNDCFLl0vkfOCJnCFtz
         fy+hmfMo4yNKKnoHmbS7e6//Gx4XLKr0mWEk7NlU=
Date:   Thu, 5 Dec 2019 09:48:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
Message-ID: <20191205084802.GA302248@kroah.com>
References: <20191204175321.609072813@linuxfoundation.org>
 <675c0291-fb9b-10b5-fe50-d9b6b889a981@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675c0291-fb9b-10b5-fe50-d9b6b889a981@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 06:59:55AM +0000, Jon Hunter wrote:
> 
> On 04/12/2019 17:53, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.158 release.
> > There are 209 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v4.14:
>     8 builds:	8 pass, 0 fail
>     16 boots:	16 pass, 0 fail
>     24 tests:	24 pass, 0 fail
> 
> Linux version:	4.14.158-rc1-gce267d7b1d71
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
