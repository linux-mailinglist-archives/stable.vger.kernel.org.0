Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28E5122929
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfLQKsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:48:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:33108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfLQKsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 05:48:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BEEF4ADA1;
        Tue, 17 Dec 2019 10:48:39 +0000 (UTC)
Date:   Tue, 17 Dec 2019 11:48:38 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: Allocate reserved region for ISA with
 correct permission
Message-ID: <20191217104838.GC28651@suse.de>
References: <20191213053642.5696-1-jsnitsel@redhat.com>
 <3a9bcdc5-9e78-945d-f6e4-5af6829bf4f0@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a9bcdc5-9e78-945d-f6e4-5af6829bf4f0@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 01:39:31PM +0800, Lu Baolu wrote:
> Hi,
> 
> On 12/13/19 1:36 PM, Jerry Snitselaar wrote:
> > Currently the reserved region for ISA is allocated with no
> > permissions. If a dma domain is being used, mapping this region will
> > fail. Set the permissions to DMA_PTE_READ|DMA_PTE_WRITE.
> > 
> > Cc: Joerg Roedel <jroedel@suse.de>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Cc: iommu@lists.linux-foundation.org
> > Cc: stable@vger.kernel.org # v5.3+
> > Fixes: d850c2ee5fe2 ("iommu/vt-d: Expose ISA direct mapping region via iommu_get_resv_regions")
> > Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> 
> This fix looks reasonable to me.
> 
> Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

Applied for v5.5, thanks.

