Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD88C3D79
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfJARAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbfJAQ74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:59:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73CD02168B;
        Tue,  1 Oct 2019 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569949196;
        bh=Hx7m5OdIpys0QsugrbkIJbTrZ0dFqGn5jXjlF+SX1Js=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SWBN/pBbD2o1S6NIjHpADoADN7TLftfv+C5JX1CA4UavizlY0xTJMEeZtYfn0sNgq
         kUd6Fk3aZ7RbwatKOVoAG0eESlfWxzYCIoIc07WnA4pYz7PxhalVURhcI13PBdfwgv
         3+O/ZOZ0+MQlQ3IiLCp09DT8Nu4AR1ih+n2lpYOY=
Date:   Tue, 1 Oct 2019 18:59:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/25] 5.3.2-stable review
Message-ID: <20191001165953.GA3542610@kroah.com>
References: <20190929135006.127269625@linuxfoundation.org>
 <97a5107b-9b90-53be-47d3-dc5167013fd6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a5107b-9b90-53be-47d3-dc5167013fd6@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 03:59:06PM +0100, Jon Hunter wrote:
> 
> On 29/09/2019 14:56, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.2 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.2-rc1.gz
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
> Linux version:	5.3.2-rc1-g5910f7ae1729
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing these and letting me know.

greg k-h
