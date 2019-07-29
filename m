Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D0078ECF
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 17:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbfG2PM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 11:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387402AbfG2PM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 11:12:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7FB421655;
        Mon, 29 Jul 2019 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564413176;
        bh=EgtQdelxp1g4TpBBqKIIM/eEKG436mdnHUtsXOz0uLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8vOoLPTzebiHzQDIdPLmyTe01fnu7HRQXSkCyO0efG21d+5Dx94sGxrr+/G1QSKD
         +s2uUyeDH1eainxXJ88u/A8G7JJsnavoZfXwLKu+3N/v905DKWSsqblUwwfHaAHZQz
         s+DMptx280EEft4lLzcRSl5bH3T3oa8SPZbHJU4M=
Date:   Mon, 29 Jul 2019 17:12:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/66] 5.2.4-stable review
Message-ID: <20190729151251.GC21262@kroah.com>
References: <20190726152301.936055394@linuxfoundation.org>
 <df4d349b-03a1-58b1-cf82-4e76d5820614@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df4d349b-03a1-58b1-cf82-4e76d5820614@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 10:03:10AM +0100, Jon Hunter wrote:
> 
> On 26/07/2019 16:23, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.4 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 28 Jul 2019 03:21:13 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.4-rc1.gz
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
> Linux version:	5.2.4-gfc89179bfa10
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
>

Thanks for testing all of these and letting me know.

greg k-h
