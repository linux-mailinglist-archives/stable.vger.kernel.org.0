Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B20C33F436
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 16:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhCQPso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 11:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhCQPsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 11:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E664864F72;
        Wed, 17 Mar 2021 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615995372;
        bh=UrUtjxVyoeoRl31xBOd91McCs6UZrYNRl38mnzMyPQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d81ZIUTt6ozn3lmcR5e0LYTUh4Sw1f+KiWzN1YxzE5jKxtxhlsJVIg+TKiuFhl9WB
         jd9bqlkbCxnJNpaJSI6UgUBGl179bOa4KqblNSu3HjtDOOo2d8Fkqn50DbHBNRIbN1
         KhediFuNSy37B7xc2TnHWWKGwWWRJcUeHIdmvIxE=
Date:   Wed, 17 Mar 2021 16:36:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
Message-ID: <YFIh6ZyWb2JtCu6H@kroah.com>
References: <20210315135740.245494252@linuxfoundation.org>
 <c0902934-ea11-ba1e-fa2d-b05897aab4b3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0902934-ea11-ba1e-fa2d-b05897aab4b3@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 02:35:36PM +0800, Samuel Zou wrote:
> 
> 
> On 2021/3/15 21:56, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 4.14.226 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.226-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Tested on x86 for 4.14.226-rc1,
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-4.14.y
> Version: 4.14.226-rc1
> Commit: 57cc62fb2d2b8e81c02cb9197e303c7782dee4cd
> Compiler: gcc version 7.3.0 (GCC)
> 
> x86 (No kernel failures)
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4728
> succeed_num: 4727
> failed_num: 1

What does this "failed_num" mean?

thanks,

greg k-h
