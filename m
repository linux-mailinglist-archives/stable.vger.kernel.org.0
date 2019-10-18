Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B98DC238
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 12:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633260AbfJRKMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 06:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633218AbfJRKMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 06:12:42 -0400
Received: from localhost (unknown [209.136.236.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B23D222C3;
        Fri, 18 Oct 2019 10:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571393561;
        bh=15Uz10pfRzT/PuTPEJ8kDH4R9b5B2WikPZM+ia3KwdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6+yn5QsqVxDNfFgac3MNethqiWP89iNgNPkhVxfQ+5ok/MlF1Cha3r/hRYtWpmXk
         7WtlBQdwcE+Jl1qK9GuMT0KdcsbbFveywGocYUlILBa5MVYWDyYbocZKywuZUcZ4rD
         RrW75om6ip+1wg0Df2KK9Cok1bA3sL3RixQGtzbA=
Date:   Fri, 18 Oct 2019 03:12:39 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
Message-ID: <20191018101239.GA1172118@kroah.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <ef7c7e93-909c-890f-868b-44c93f6f7616@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef7c7e93-909c-890f-868b-44c93f6f7616@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 09:01:50AM +0100, Jon Hunter wrote:
> 
> On 16/10/2019 22:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.7 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.3:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.3.7-rc1-gcbb18cd3e478
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Wonderful, thanks for testing all of these and letting me know.

greg k-h
