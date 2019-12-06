Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B31C115108
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfLFNdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfLFNdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 08:33:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D54820659;
        Fri,  6 Dec 2019 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575639234;
        bh=62/Dz9Csmb625T/U9P3Z1SOj/It+aVp4rBDIvvTjDk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IaEQqhUF4SjWqp1KNDzYquIq0cpbzZ3HmWQV9boeAekZl84HEUIaWllsQd3e9IWBB
         UHScWty+WI8qAVrPRa4s7ctyUlhjUVn/SZ1Jqwo46Tif+lyijcOEK1eVbN3Yi+3qrk
         eWrl6Orj11HKDhCEDIhpaYeix3JJW21JP+9PIAx4=
Date:   Fri, 6 Dec 2019 14:33:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: stable request: 5.4.y: arm64: tegra: Fix 'active-low' warning
 for Jetson
Message-ID: <20191206133351.GA2466@kroah.com>
References: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
 <20191206125334.GA1361962@kroah.com>
 <ee190492-5af8-7ef1-5524-4f260d64094d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee190492-5af8-7ef1-5524-4f260d64094d@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 01:16:15PM +0000, Jon Hunter wrote:
> 
> On 06/12/2019 12:53, Greg Kroah-Hartman wrote:
> > On Fri, Dec 06, 2019 at 10:55:17AM +0000, Jon Hunter wrote:
> >> Hi Greg,
> >>
> >> Please can you include the following device-tree fixes for 5.4.y that
> >> are triggering some warnings on a couple of our Jetson platforms. This
> >> is currently causing one of our kernel warnings tests to fail. Both of
> >> these have now been merged into the mainline for v5.5-rc1.
> >>
> >> commit d440538e5f219900a9fc9d96fd10727b4d2b3c48
> >> Author: Jon Hunter <jonathanh@nvidia.com>
> >> Date:   Wed Sep 25 15:12:28 2019 +0100
> >>
> >>     arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator
> >>
> >> commit 1e5e929c009559bd7e898ac8e17a5d01037cb057
> >> Author: Jon Hunter <jonathanh@nvidia.com>
> >> Date:   Wed Sep 25 15:12:29 2019 +0100
> >>
> >>     arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator
> >>
> >> Thanks
> >> Jon
> > 
> > Now queued up, thanks.
> 
> Thanks. BTW were you also able to queue the following? This is another
> one that is needed for 5.4.y.
> 
> commit c745da8d4320c49e54662c0a8f7cb6b8204f44c4
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Fri Oct 11 09:34:59 2019 +0100
> 
>     mailbox: tegra: Fix superfluous IRQ error message

Now queued up, for some reason I thought I had done this already, sorry
about that.

greg k-h
