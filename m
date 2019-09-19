Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEBC5B7340
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 08:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbfISGh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 02:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388106AbfISGh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 02:37:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A807218AF;
        Thu, 19 Sep 2019 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568875075;
        bh=OvlN3rsh1jBAYSR3aCxtqlncd1DTWCc3BeDgQLZN7Eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ka2HHjjXpe+eBXqGlWgPQesHGSzwzBWXYglKohILCqGbS4wdXbpBooYmpzCKPzspO
         Z3VhVoePWeNxBFYLqnnb5Y5JdFjZetcQHmjLXZftG3fYvU4sCV7MY5YTnQFDU1K4xf
         zqPoiMtsPiTjR8p4AIYrY+aSj594RwKRU+TgJEIY=
Date:   Thu, 19 Sep 2019 08:37:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
Message-ID: <20190919063753.GE2069346@kroah.com>
References: <20190918061234.107708857@linuxfoundation.org>
 <5492c75f-de7c-9fe7-d3f7-3af5f3b3b6ce@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5492c75f-de7c-9fe7-d3f7-3af5f3b3b6ce@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 05:28:49PM +0100, Jon Hunter wrote:
> 
> On 18/09/2019 07:18, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.16 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.16-rc1-g2f63f02ef506
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
