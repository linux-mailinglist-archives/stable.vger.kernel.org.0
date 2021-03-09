Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94FE332305
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhCIK17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:27:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhCIK1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:27:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A726526C;
        Tue,  9 Mar 2021 10:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615285662;
        bh=q8yBTLD7tAfoRrr7vcBht8JBFOLyR+2UW8xB7E06Zco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=griOfM+gE0XSfFHGnILWXQ+Gby4bSokBTP4VkCkTrGlSMtuUa8zqFbRDLwCOALjMt
         6VuGn3ihBu0ZQfuEGcX1cowkkTKbPWXRcQoJ9FTeY1ZneagVxW7DO+DnYMZwVjGvZE
         uCyEYeWuvGEt4Ym15ODqAQPStUw6b0Ngnwe0loOs=
Date:   Tue, 9 Mar 2021 11:27:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/42] 5.10.22-rc1 review
Message-ID: <YEdNnAkzIUq/Tpw9@kroah.com>
References: <20210308122718.120213856@linuxfoundation.org>
 <286bc1de-04cf-d60a-e928-8f94b2979b6d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <286bc1de-04cf-d60a-e928-8f94b2979b6d@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 09:08:20AM +0800, Samuel Zou wrote:
> 
> 
> On 2021/3/8 20:30, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.22 release.
> > There are 42 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.22-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Tested on arm64 and x86 for 5.10.22-rc1,
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.10.y
> Version: 5.10.22-rc1+
> Commit: 9226165b6cc7667b147e1de52090d1b6a17af336
> Compiler: gcc version 7.3.0 (GCC)
> 
> 
> arm64 (No kernel failures)
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4710
> succeed_num: 4709
> failed_num: 1
> timeout_num: 0
> 
> x86 (No kernel failures)
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4710
> succeed_num: 4709
> failed_num: 1
> timeout_num: 0
> 
> Tested-by: Hulk Robot <hulkci@huawei.com>

thanks for testing 2 of these and letting me know.

greg k-h
