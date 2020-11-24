Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDA2C31F0
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbgKXU2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:28:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgKXU2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 15:28:10 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABABD20678;
        Tue, 24 Nov 2020 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606249690;
        bh=Kj/IPRPktsNYu5sjpOOcmpSxHEnE8scBVvgnfBDQQNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sEqogzRxO0Ifb/E+j94gXdHp0L/uxqLrmRkMnF9qhEdHf6lT0zH9xd+BexOdkQYOG
         9sd/YqMeuA0QHAbJ4BtKnVOcm0/mk4EJk5nTQq3WF0w1YYp+6QPIZu10IxLgIm83fY
         L795/Clyh7cC6LFn6RtfcmsH8bK1A1lKfzXOYAIQ=
Date:   Tue, 24 Nov 2020 21:28:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.9 000/252] 5.9.11-rc1 review
Message-ID: <X71s2N3fm6DtZZd6@kroah.com>
References: <20201123121835.580259631@linuxfoundation.org>
 <56818ae9943246a7bacdb263f3bf28ab@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56818ae9943246a7bacdb263f3bf28ab@HQMAIL101.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 08:54:19PM +0000, Jon Hunter wrote:
> On Mon, 23 Nov 2020 13:19:10 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.11 release.
> > There are 252 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.11-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.9:
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     64 tests:	64 pass, 0 fail
> 
> Linux version:	5.9.11-rc1-g7939279fca79
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
Thanks for testing these and letting me know.

gre gk-h
