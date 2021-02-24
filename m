Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224993243E7
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbhBXSm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:42:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhBXSmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 13:42:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE1FF64F0C;
        Wed, 24 Feb 2021 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614192134;
        bh=tLJKjv3QWOJ+B1UpyXBCkzM9L1gc0x0rmDFvphmUsL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xZnORlF4Unbtwgsn5aeseXZtd+Fy4o2sJYep2Wq4wv6+fMxJk89199DrLWk9X9Wpq
         eIP3z41d2q7UoUx0pjJ9x9i6QykDJWxuweO6Nm/kgphj9ewz2xiY4pqA12Z05SF0ny
         KnKAufIBW+/X/0UQv+h5vWUuLVYl/x5FMmENhcss=
Date:   Wed, 24 Feb 2021 19:42:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
Message-ID: <YDaeA8nd6psWI82O@kroah.com>
References: <20210222121019.444399883@linuxfoundation.org>
 <4a0fc47a-1ecb-211a-3785-a1f5166c1837@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a0fc47a-1ecb-211a-3785-a1f5166c1837@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 09:17:44AM -0800, Florian Fainelli wrote:
> 
> 
> On 2/22/2021 4:12 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.18 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.18-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> 
> On ARCH_BRCMSTB using 32-bit ARM and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for testing!
