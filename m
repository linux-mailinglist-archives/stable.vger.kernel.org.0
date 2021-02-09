Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11796314B93
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 10:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBIJ2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 04:28:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhBIJXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 04:23:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF67C64E4F;
        Tue,  9 Feb 2021 09:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612862595;
        bh=ZuzO8IlPH7OdvzOuM3hUuPGrV2BGw7BR18s5NWN+cQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2IZd9JV5qM4aI8JsCkjZZuIE+UcwO+cZ/8Tzp/xkBac6h1v5ahUFGgLchn6WAvHWP
         TTpbmG95sCUDlWRidU6dAfH5GDSinRQmdtdG5VZuur1DwcnrvtroT/g4T4IlgJjrY5
         7e9KljC+q9VAdsCIo/5dP1dy/Ykm0EgIhSJoAfSo=
Date:   Tue, 9 Feb 2021 10:23:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     obayashi.yoshimasa@socionext.com
Cc:     sumit.garg@linaro.org, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: Re: DMA direct mapping fix for 5.4 and earlier stable branches
Message-ID: <YCJUgKDNVjJ4dUqM@kroah.com>
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
 <YCIym62vHfbG+dWf@kroah.com>
 <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com>
 <YCJCDZGa1Dhqv6Ni@kroah.com>
 <27bbe35deacb4ca49f31307f4ed551b5@SOC-EX02V.e01.socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27bbe35deacb4ca49f31307f4ed551b5@SOC-EX02V.e01.socionext.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 09:05:40AM +0000, obayashi.yoshimasa@socionext.com wrote:
> > > As the drivers are currently under development and Socionext has
> > > chosen 5.4 stable kernel for their development. So I will let
> > > Obayashi-san answer this if it's possible for them to migrate to 5.10
> > > instead?
> 
>   We have started this development project from last August, 
> so we have selected 5.4 as most recent and longest lifetime LTS 
> version at that time.
> 
>   And we have already finished to develop other device drivers, 
> and Video converter and CODEC drivers are now in development.
> 
> > Why pick a kernel that doesn not support the features they require?
> > That seems very odd and unwise.
> 
>   From the view point of ZeroCopy using DMABUF, is 5.4 not 
> mature enough, and is 5.10 enough mature ?
>   This is the most important point for judging migration.

How do you judge "mature"?

And again, if a feature isn't present in a specific kernel version, why
would you think that it would be a viable solution for you to use?

good luck!

greg k-h
