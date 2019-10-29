Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA64DE8300
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 09:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfJ2IL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 04:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbfJ2IL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 04:11:56 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FDAD20663;
        Tue, 29 Oct 2019 08:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572336715;
        bh=xMQy0ECOBqAsX4RmgHCvcArYbt/NqSQud23/yGL1Koc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ePup3Pmt8KMwGeLRIe4wrsR07Sl4mdPMGyGcSzBYHApUPH15BVoRHZNzEzSd7W4wJ
         JZv0fE/Lqa4J8gRF+eDyY1YOINdYQcpLihx45ydcNkcrxyLGCUWQ9Hnjvm94Ml8chK
         1ULFPLg6UcDBceg4zBhpZ/aXu9X5DgHslI5hg2Uk=
Date:   Tue, 29 Oct 2019 09:11:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 000/197] 5.3.8-stable review
Message-ID: <20191029081152.GA520765@kroah.com>
References: <20191027203351.684916567@linuxfoundation.org>
 <ec238058-1eaf-a33f-cbbf-fd49e1ddaa82@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec238058-1eaf-a33f-cbbf-fd49e1ddaa82@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 09:48:04PM +0000, Jon Hunter wrote:
> 
> On 27/10/2019 20:58, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.8 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.8-rc1.gz
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
> Linux version:	5.3.8-rc1-g740177dc0d52
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

THanks for testing all of these and letting me know.

greg k-h
