Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8A010D2B7
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 09:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfK2Iws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 03:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfK2Iws (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 03:52:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70E42176D;
        Fri, 29 Nov 2019 08:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575017567;
        bh=PX5BOsY1t2LE1GKS1BFa2C+qSO4HIf/3oOnA3u9RllU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dEXP+TGPjnmV0zfirNbscTw9yQOVQ556jBOAwx9UF/fm32e85yYW6BSh25kKex65F
         RKHQaG2rIjB656odNy6c1entOldgDatI1o7Xs5TUxfYFaNPn4izo0WJPtobP34SzOy
         HE3/Rq95TBTu0nq+8YBAZ6ZKDIWWrrvDiS2BhHM0=
Date:   Fri, 29 Nov 2019 09:52:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/66] 5.4.1-stable review
Message-ID: <20191129085245.GC3584430@kroah.com>
References: <20191127202632.536277063@linuxfoundation.org>
 <772b6606-f65c-371f-ec74-e78aba55f798@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <772b6606-f65c-371f-ec74-e78aba55f798@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 10:42:00AM +0000, Jon Hunter wrote:
> 
> On 27/11/2019 20:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.1 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Here are the test results for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	37 pass, 1 fail
> 
> Linux version:	5.4.1-rc1-gd6453d6b0c57
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 
> We are seeing 1 failure for Tegra194, but this is not a new failure this
> is present in v5.4 and it is a kernel warnings failure that has been
> fixed for v5.5 by the following commits.
> 
> This one has been merged for v5.5 ...
> 
> commit c745da8d4320c49e54662c0a8f7cb6b8204f44c4
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Fri Oct 11 09:34:59 2019 +0100
> 
>     mailbox: tegra: Fix superfluous IRQ error message
> 
> This one has not been merged for v5.5 yet ...

I'll queue that up next.

> commit d440538e5f219900a9fc9d96fd10727b4d2b3c48
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Wed Sep 25 15:12:28 2019 +0100
> 
>     arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator
> 
> If you like I can let you know once the above is merged so we can merge
> for linux-5.4.y.

Please do, that would be great.

thanks for testing all of these and letting me know.

greg k-h
