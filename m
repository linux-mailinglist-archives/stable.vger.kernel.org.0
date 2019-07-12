Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7597967263
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 17:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfGLPbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 11:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfGLPbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 11:31:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB1F208E4;
        Fri, 12 Jul 2019 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562945471;
        bh=3t+6wjpJFOQt0JVl6oztKApAO9yZH1Bl74JWDDgu/kk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OY22DrZk1GEUN/LX3LkHcHgRDlZdhb565nA0K6nQyluWxpdrUnF1G6g25c1GP/MN2
         mtuXWyd0UJMXvuBrt6XGtRpIE+Rjzg5LfpxBiv7/QVawXu+RYmnmwCXgiVJgaz0dJN
         G7+ZtPLT4QjwEWRUtU1sR7pVqFCVoopac3030Fys=
Date:   Fri, 12 Jul 2019 17:31:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190712153108.GD13940@kroah.com>
References: <20190712121620.632595223@linuxfoundation.org>
 <a1ae16a7-e8f7-b6fc-df4e-46079bebf9b3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1ae16a7-e8f7-b6fc-df4e-46079bebf9b3@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:36:29PM +0100, Jon Hunter wrote:
> 
> On 12/07/2019 13:19, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.1 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
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
> Linux version:	5.2.1-rc1-g61731e8fe278
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

That was fast, thanks for testing all of these.

greg k-h
