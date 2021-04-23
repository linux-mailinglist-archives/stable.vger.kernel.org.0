Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7313695DD
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbhDWPNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243129AbhDWPNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81D7C6146B;
        Fri, 23 Apr 2021 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190790;
        bh=2qL86T+Km0KUpRXmE+1i1Ylz6ub/ilQbeW7d3V9BD/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BvSC28GDkyTgjcdVuTpmJg86+QLUIrOG8FCo5kFwjyczACgS+Vh0sgNfdMLLUVuy8
         RwQ+B9hoJP+5xenemrGcL8i/K1f7e9WgY2zSibgj7Vp/1uQHvYbsgQeQLQWNDj9Ljz
         SBvmleZjj8dxIjB6PENkMvIdNnnYt6/VGluZFFA4=
Date:   Fri, 23 Apr 2021 17:13:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YILkAwGEmAWWLro2@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <4599d4bc-937b-0624-5acb-9e7af0f2c9f8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4599d4bc-937b-0624-5acb-9e7af0f2c9f8@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 02:20:59PM +0800, Samuel Zou wrote:
> 
> 
> On 2021/4/19 21:05, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.32 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Tested on arm64 and x86 for 5.10.32-rc1,
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.10.y
> Version: 5.10.32-rc1
> Commit: bcedd92af6e5899132429d20a9322b12afec2188
> Compiler: gcc version 7.3.0 (GCC)
> 
> arm64:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total: 5764
> passed: 5764
> failed: 0
> timeout: 0
> --------------------------------------------------------------------
> 
> x86:
> --------------------------------------------------------------------
> Testcase Result Summary:
> total: 5764
> passed: 5764
> failed: 0
> timeout: 0
> --------------------------------------------------------------------
> 
> Tested-by: Hulk Robot <hulkrobot@huawei.com>
> 

Thanks for testing and letting me know.

greg k-h

