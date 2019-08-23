Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E43E9B59E
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 19:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389882AbfHWRi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 13:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbfHWRi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 13:38:26 -0400
Received: from localhost (unknown [104.129.198.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61333206B7;
        Fri, 23 Aug 2019 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566581905;
        bh=BvlcKb2iuEFeIVz2EmKDKkglvLx+LDxESaVfhrFRT9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IppX7fEUCIsfvhhXizMkUUWtCQgSbnqWOi6B7LLsE9o7EG55OCtA6j7UEmQ6SZtJW
         laeEXHpHX5USi9maoTzMLy2TC+yGWqUIEOhtblzwOzsktfPb5D+SxOfGwhIvsoDc3B
         rfpGLIvdh5Cx5Rl4KxxVntGAINnGUQJou1/CuZ5M=
Date:   Fri, 23 Aug 2019 10:38:24 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
Message-ID: <20190823173824.GB1040@kroah.com>
References: <20190822171832.012773482@linuxfoundation.org>
 <ea35d533-4ffb-8fe0-8639-6fc5a780748e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea35d533-4ffb-8fe0-8639-6fc5a780748e@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 03:05:38AM +0100, Jon Hunter wrote:
> 
> On 22/08/2019 18:18, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.190 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 24 Aug 2019 05:18:13 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.190-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests for Tegra are passing ...
> 
> Test results for stable-v4.4:
>     6 builds:	6 pass, 0 fail
>     12 boots:	12 pass, 0 fail
>     19 tests:	19 pass, 0 fail
> 
> Linux version:	4.4.190-rc1-gf607b8c5ce70
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
