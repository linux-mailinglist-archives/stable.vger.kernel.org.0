Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4FE587BB
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 18:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0Qym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 12:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfF0Qym (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jun 2019 12:54:42 -0400
Received: from localhost (unknown [89.205.136.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 014B920659;
        Thu, 27 Jun 2019 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561654481;
        bh=eOCvuSsg8vkTcA/VnvHXMe5Kq6abpSfsP8OULmvRAZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gw++Ehdarhu/KbbQqV/AOh1ffduzBpez1WuMh8SeazD2C5TfUGUtmmWMFU8SdVYQ7
         NdXeONuS8Ke0tRaWrNa7QcOWxt9+2pkYorCebahW4r356uGu4St9Ue4mRWFr+UqgCG
         H4Y66wlwSW+ezD0vldsS34/XLU+KENdgNO6BM8Tc=
Date:   Fri, 28 Jun 2019 00:54:33 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 0/1] 4.4.184-stable review
Message-ID: <20190627165433.GC9855@kroah.com>
References: <20190626083604.894288021@linuxfoundation.org>
 <217e73e4-7777-558c-186f-c94658447ae0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <217e73e4-7777-558c-186f-c94658447ae0@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 09:36:55AM +0100, Jon Hunter wrote:
> 
> On 26/06/2019 09:45, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.184 release.
> > There are 1 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.184-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v4.4:
>     6 builds:	6 pass, 0 fail
>     12 boots:	12 pass, 0 fail
>     19 tests:	19 pass, 0 fail
> 
> Linux version:	4.4.184-rc1-g5f1824292521
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
