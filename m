Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA2B34189C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCSJlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhCSJlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 05:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06F3264F6A;
        Fri, 19 Mar 2021 09:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616146885;
        bh=lpiTyb1P3AoxjUtw0zqNWvaLX1n0suQASsWSWsGwxB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZMqSEa7gDdZn7ztGQ3on8tkuG6c4Ngg9IwoQQmEdhN0BzJ9UExPzhOvBEQXh+rJg0
         vH0ZT/cWhL/7wh3hCF6Jt7Ztsnvzh/yPpUuNcNsqGjAq7VlJO/juhaqGpO8NXwexiH
         jslzi0Paxmr6xCm8cBLTEcOJEI8POcivPi/ORsLc=
Date:   Fri, 19 Mar 2021 10:41:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
Message-ID: <YFRxwj+hTX+pYTm4@kroah.com>
References: <20210315135720.002213995@linuxfoundation.org>
 <872e57d3-0651-1350-7e66-3f9f4c89964e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <872e57d3-0651-1350-7e66-3f9f4c89964e@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 07:59:59PM +0800, Samuel Zou wrote:
> 
> 
> On 2021/3/15 21:55, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 4.19.181 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Mar 2021 13:57:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.181-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Tested on arm64 for 4.19.181,
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-4.19.y
> Version: 4.19.181
> Commit: ac3af4beac439ebccd17746c9f2fd227e88107aa
> Compiler: gcc version 7.3.0 (GCC)
> 
> arm64:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total: 4726
> passed: 4721
> failed: 5
> --------------------------------------------------------------------
> Failed cases:
> ltp test_robind24
> ltp test_robind25
> ltp test_robind26
> ltp test_robind27
> ltp test_robind28
> 
> The 5 failed cases are caused by insufficient disk space in the test
> environment, no kernel failures
> --------------------------------------------------------------------
> 
> Tested-by: Hulk Robot <hulkrobot@huawei.com>
> 

Thanks for the testing and letting me know.

greg k-h
