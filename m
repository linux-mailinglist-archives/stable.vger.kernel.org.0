Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A060104ACA
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 07:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKUGmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 01:42:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUGmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 01:42:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB68E2089D;
        Thu, 21 Nov 2019 06:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574318534;
        bh=8Pw5nRlIL1sb3haxNnV1x+IT2Ah5XoqlQxWeR194cZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WK5CEQ+dFlkPIsBT1LxZ/xZ7rmeCxoPUzl9+t6XQL3vQM/v9B9K8HGizVyzCt5/np
         gkDvhjM11p1Rh0gH/wE/ZzrWKinqfpfxabxfJ5i1D/d/BQBQzglErmgZSxCqHZMwkU
         vu9eiClG8h2Um28r4pMAEUVt8LgYUzEv9fi+RiF8=
Date:   Thu, 21 Nov 2019 07:42:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 065/422] ice: Fix and update driver version string
Message-ID: <20191121064211.GB340116@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051403.893600135@linuxfoundation.org>
 <20191120215905.GB23361@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120215905.GB23361@duo.ucw.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 10:59:05PM +0100, Pavel Machek wrote:
> On Tue 2019-11-19 06:14:22, Greg Kroah-Hartman wrote:
> > From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> > 
> > [ Upstream commit 9ea47d81a7f17c6b77211ab75fbca2127719ad39 ]
> > 
> > Remove the "ice" prefix for the driver version string and bump version
> > to 0.7.1-k.
> 
> This sounds like a bad idea. 0.7.1 in mainline contains patches that
> were not backported to stable, so marking this as 0.7.1 version is
> wrong.
> 
> Best regards,
> 								Pavel
> 								
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -7,7 +7,7 @@
> >  
> >  #include "ice.h"
> >  
> > -#define DRV_VERSION	"ice-0.7.0-k"
> > +#define DRV_VERSION	"0.7.1-k"

Hah, this is why "versions" for drivers are totally meaningless and why
we removed them from most of the kernel tree already.  I recommend doing
that here as well.

thanks,

greg k-h
