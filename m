Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F5D2FC66
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 15:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfE3NcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 09:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbfE3NcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 09:32:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A85D0259B8;
        Thu, 30 May 2019 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559223140;
        bh=6bTBp+WOjfsPhCq3IwAUB9bCrZwGkgQM1ytUSu7ur/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E/UqNYGgr+xj7a2UDunARGNf4Sed7f9pJLs6OAIF+7fdUHxlf3jLiTIY6b8QS8khq
         Dw6r28XvpW0vlPZvRXV04amvDmExxn8L9z6MM6v6PLVPK3Mrnyo82aMcQu8qx8FWqr
         elz0tRMcPXYtLsBTsnyuCVQO95ODyHP4naLO+UGE=
Date:   Thu, 30 May 2019 06:32:20 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 000/405] 5.1.6-stable review
Message-ID: <20190530133220.GB21642@kroah.com>
References: <20190530030540.291644921@linuxfoundation.org>
 <0f0f1d03-64c9-7197-c82d-1ca27142be00@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f0f1d03-64c9-7197-c82d-1ca27142be00@nvidia.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 02:23:11PM +0100, Jon Hunter wrote:
> 
> On 30/05/2019 03:59, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.6 release.
> > There are 405 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 01 Jun 2019 03:01:59 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.1:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.1.6-rc1-g6df8e06
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Wonderful, thanks for testing all of these and letting me know.

greg k-h
