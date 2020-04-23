Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7511B5959
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgDWKhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgDWKhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 06:37:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E813E2076C;
        Thu, 23 Apr 2020 10:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587638242;
        bh=xhJR5aH/f7qdTrdiw1br0HJ2h6Qmi1BvSbpvMrPn+qU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSOXLM8QtpEKj8IYaDyMnAVMToc+H98zE+8vcUFa2lD7z7ExuU+zjo0aoCJ9C2cdr
         0ZyzNcA97eSIG/DDe8ZJNKF6+vuF2txwjXQ+ePffT2yClS4i4LbbxZVvXGIYxmzBbO
         X2/1FjjC25msOc1NO47MAYDFZ+iXxO+lrHiFPXjY=
Date:   Thu, 23 Apr 2020 12:37:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 000/166] 5.6.7-rc1 review
Message-ID: <20200423103720.GB3730645@kroah.com>
References: <20200422095047.669225321@linuxfoundation.org>
 <c2447ca7-0a90-fa71-5611-8d3d7349eb2b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2447ca7-0a90-fa71-5611-8d3d7349eb2b@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 11:23:09AM +0100, Jon Hunter wrote:
> 
> On 22/04/2020 10:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.7 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h 
> 
> All tests are passing for Tegra
> 
> Test results for stable-v5.6:
>     13 builds:	13 pass, 0 fail
>     24 boots:	24 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.6.7-rc1-g8614562dd305
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Great, thanks for testing all of these and letting me know.

greg k-h
