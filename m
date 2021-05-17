Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508DD38250F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 09:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhEQHJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 03:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234049AbhEQHJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 03:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9659D60E09;
        Mon, 17 May 2021 07:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621235278;
        bh=Rhy5AZY3AtAnv8EyIybDPUwYFHgR5lYLD0wSfwMo8c8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=phv1uxO5JaSxKYmjx7afwME0PIixAQQHYBEOQobeACRe6+bf12M/rIvyPVThVAu31
         IG86EAHXAE0wjwplc//mai8yA/XfVJdDNBimXQktFWoBXmDrso9jGZviJgfJ8TID7J
         Q5a1ExCbUH/PsYMCW90e6YMZ9Q6yXY3bIrP8UVhU=
Date:   Mon, 17 May 2021 09:07:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     sashal@kernel.org, ashok.raj@intel.com, jroedel@suse.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [REWORKED PATCH 1/1] iommu/vt-d: Preset Access/Dirty bits for
 IOVA over FL
Message-ID: <YKIWS0lFKTcZ9094@kroah.com>
References: <20210517034913.3432-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517034913.3432-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 11:49:13AM +0800, Lu Baolu wrote:
> [ Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 ]
> 
> The Access/Dirty bits in the first level page table entry will be set
> whenever a page table entry was used for address translation or write
> permission was successfully translated. This is always true when using
> the first-level page table for kernel IOVA. Instead of wasting hardware
> cycles to update the certain bits, it's better to set them up at the
> beginning.
> 
> Suggested-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Link: https://lore.kernel.org/r/20210115004202.953965-1-baolu.lu@linux.intel.com
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/iommu/intel/iommu.c | 14 ++++++++++++--
>  include/linux/intel-iommu.h |  2 ++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> [Note:
> - This is a reworked patch of
>   https://lore.kernel.org/stable/20210512144819.664462530@linuxfoundation.org/T/#m65267f0a0091c2fcbde097cea91089775908faad.
> - It aims to fix a reported issue of
>   https://bugzilla.kernel.org/show_bug.cgi?id=213077.
> - Please help to review and test.]

What stable tree(s) is this supposed to be for?

thanks,

greg k-h
