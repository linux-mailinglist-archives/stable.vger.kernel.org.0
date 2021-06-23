Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2193B146C
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWHOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWHOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 03:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B44606A5;
        Wed, 23 Jun 2021 07:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624432355;
        bh=wTQ4yQeLItrU+CB8fbH2vW1xMC/biCznED7PFNvizNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eUtlpZKDTJcCTPbKMbpXV5K2NrBVMRj4O6X/mtHeYfIIC4DEADv78K+PQWeADQjqd
         MlbW5uQrfx6LJa7+QZEDyDEqtMugXCz8pyAuFXEY8HPMezezvtgHHawy0znevN5hIV
         VtsHDLVsRF8Z9xGwvjuw2RHgH+qUVid5zjfo9J2o=
Date:   Wed, 23 Jun 2021 09:12:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        catalin.marinas@arm.com, will@kernel.org,
        akpm@linux-foundation.org, guohanjun@huawei.com,
        sudeep.holla@arm.com, song.bao.hua@hisilicon.com, ardb@kernel.org,
        anshuman.khandual@arm.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Li Huafei <lihuafei1@huawei.com>
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
Message-ID: <YNLe4CGtOgVvTOMN@kroah.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
 <YEDkmj6cchMPAq2h@kroah.com>
 <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
 <YEDr/lYZHew88/Ip@kroah.com>
 <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com>
 <604597E3.5000605@huawei.com>
 <YEX1OcbVNSqwwusF@kroah.com>
 <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
 <8b0a4f25-0803-9341-f3a4-277d16802295@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b0a4f25-0803-9341-f3a4-277d16802295@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 02:59:59PM +0800, Kefeng Wang wrote:
> Hi Greg,
> 
> There are two more patches about the ZONE_DMA[32] changes,

What ZONE_DMA changes?

> especially the
> second one, both them need be backported, thanks.

Backported to where?

> 791ab8b2e3db - arm64: Ignore any DMA offsets in the max_zone_phys()
> calculation
> 2687275a5843 - arm64: Force NO_BLOCK_MAPPINGS if crashkernel reservation is
> required

Have you tried these patches?  Where do they need to be applied to?

confused,

greg k-h
