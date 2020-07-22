Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43E1229872
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbgGVMrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVMrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:47:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F296E206C1;
        Wed, 22 Jul 2020 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422038;
        bh=vCRV2NIeHysw25U6xDZa7OCrW/gkmFW5IvMpqcV2ldk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z1dfcsNOjzBvGvswrRjzyAs9PDl7ZaLgZiakCkyjOHS2Qrii4X0N6udibZ1tVgdRz
         LXedQZtzBKpaHkZbesCwIN4s8xiIGEMoEoOPADX/AbyNfGMeVioiW7UDAonTDzt2MT
         WN0esSXI/HkIqwRtIWEb/nAhA6dzN0S6A2I+Fvsw=
Date:   Wed, 22 Jul 2020 14:47:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
Message-ID: <20200722124724.GA3155653@kroah.com>
References: <20200720191523.845282610@linuxfoundation.org>
 <20200721131708.GH44604@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721131708.GH44604@ulmo>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 03:17:08PM +0200, Thierry Reding wrote:
> On Mon, Jul 20, 2020 at 09:16:26PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.10 release.
> > There are 243 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.10-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:  11 pass, 0 fail
>     26 boots:   26 pass, 0 fail
>     56 tests:   56 pass, 0 fail
> 
> Linux version:  5.7.10-rc2-g7d2e5723ce4a
> Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
