Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCD7BA171
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 10:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfIVINM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 04:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbfIVINM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 04:13:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DFC620830;
        Sun, 22 Sep 2019 08:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569139991;
        bh=H8zqxstwAat3eTzXeFAPwJXlvYmxlpeVZ56LVi4KkOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bV1GXl9HTUPFD/d4L8Tg3yOeXfE8yvEa3auUO2LMv0VVe4lll+R4tpaQzQ9GnEVpY
         EWzMtyFjzdYemfKAw68d7obYaGE+W+SzyHp2dW7vrPt5KF4bKbE/mghiiVZPNQgEJy
         DiYyvHnq6RtIP46oWYEnSTpyY6fx/PY2YUNdnDUw=
Date:   Sun, 22 Sep 2019 10:13:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 00/21] 5.3.1-stable review
Message-ID: <20190922081301.GA2524798@kroah.com>
References: <20190919214657.842130855@linuxfoundation.org>
 <572eca6e-47a9-c554-c6b2-bafd4c5df18b@nvidia.com>
 <20190920142432.GA601228@kroah.com>
 <773b556a-acc2-c3e0-14e6-956a6d0b3bed@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <773b556a-acc2-c3e0-14e6-956a6d0b3bed@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 05:01:35PM +0100, Jon Hunter wrote:
> 
> On 20/09/2019 15:24, Greg Kroah-Hartman wrote:
> > On Fri, Sep 20, 2019 at 02:54:26PM +0100, Jon Hunter wrote:
> >>
> >> On 19/09/2019 23:03, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 5.3.1 release.
> >>> There are 21 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1-rc1.gz
> >>> or in the git tree and branch at:
> >>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> >>> and the diffstat can be found below.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>
> >> No new regressions* for Tegra ...
> >>
> >> Test results for stable-v5.3:
> >>     12 builds:	12 pass, 0 fail
> >>     22 boots:	22 pass, 0 fail
> >>     38 tests:	37 pass, 1 fail
> >>
> >> Linux version:	5.3.1-rc1-g0aa7f3d6baae
> >> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >>                 tegra194-p2972-0000, tegra20-ventana,
> >>                 tegra210-p2371-2180, tegra30-cardhu-a04
> >>
> >> * Note we had one regression in v5.3 for a warnings test for Tegra194
> >>   causing the above test failure. This has since been fixed by the
> >>   following commits [0] but given it is just a warning, I have not
> >>   bothered CC'ing for stable.
> >>
> >> Cheers
> >> Jon
> >>
> >> [0] https://lkml.org/lkml/2019/8/21/602
> > 
> > I'll be glad to take this in stable for 5.3.y, what is the git commit
> > id?
> 
> OK, that would be great. The IDs are ...
> 
> commit 763719771e84b8c8c2f53af668cdc905faa608de
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Wed Aug 21 16:02:40 2019 +0100
> 
>     clocksource/drivers/timer-of: Do not warn on deferred probe
> 
> 
> commit 14e019df1e64c8b19ce8e0b3da25b6f40c8716be
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Wed Aug 21 16:02:41 2019 +0100
> 
>     clocksource/drivers: Do not warn on probe defer
> 
> 

Now queued up, thanks!

greg k-h
