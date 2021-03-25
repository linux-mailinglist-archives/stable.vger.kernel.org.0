Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20510349199
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhCYMJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhCYMI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 08:08:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E34D7619F9;
        Thu, 25 Mar 2021 12:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616674137;
        bh=IeBJyubcM52sjXH3uZKCCQwxZjyeXEq89KLIzgTVJwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tOxD27nI53Bjls75VNi8oSOwY5/FjdUBoFkDVLA4nhCQG5aNnDXs3vAOk0xCp88D3
         Ru5Ktkr30XqbuA2logplXfIxu1eTscD5pF2N1OHdJBUf84qgfmNv2HwrtoqYvtJzw7
         LVT+URch6Xl2/EGyP1qGBWckroS7uxTJdu+Uj7P0=
Date:   Thu, 25 Mar 2021 13:08:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
Message-ID: <YFx9V9HNjg1XWSKJ@kroah.com>
References: <20210324093435.962321672@linuxfoundation.org>
 <7bbdabd2-6212-38e5-0e3d-ddd764ddb3ce@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bbdabd2-6212-38e5-0e3d-ddd764ddb3ce@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 08:42:03PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/24/2021 2:40 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

thanks for testing!
