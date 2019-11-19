Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B0B10246E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfKSMcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:32:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfKSMcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 07:32:09 -0500
Received: from localhost (unknown [89.205.136.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65EE21850;
        Tue, 19 Nov 2019 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574166728;
        bh=E7MNg1cA7n12XK5jjW1+WEdcrpRd4dFCZhNv8lav+oE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KzFA+uLql0pj+PFsJxaYdsxMq8RZv3NzfYVzTBdCRK/ahREbcHIQ+YGTTt6Kx5vQ/
         c9nVoI0lhcvL8otNVjqy6ddgkvWU3fameFtfNSessGLy3fKAoz05SFhetWnn2jys6i
         Hn/p6L8SdTYs85A863a+hz9X8k6PZoNa+YBnE/7U=
Date:   Tue, 19 Nov 2019 13:32:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
Message-ID: <20191119123205.GA1963992@kroah.com>
References: <20191119050946.745015350@linuxfoundation.org>
 <a573d737-773b-1f94-d06f-b1d340b416ce@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a573d737-773b-1f94-d06f-b1d340b416ce@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 10:16:46AM +0000, Jon Hunter wrote:
> 
> On 19/11/2019 05:19, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.12 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.3:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.3.12-rc1-g9ebab9194d83
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Great, I got one right!  :)

thanks for testing,

greg k-h
