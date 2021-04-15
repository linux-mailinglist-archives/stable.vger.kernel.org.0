Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46A6360B8F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhDOONp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:13:45 -0400
Received: from 8bytes.org ([81.169.241.247]:35078 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhDOONo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:13:44 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C1A0F386; Thu, 15 Apr 2021 16:13:20 +0200 (CEST)
Date:   Thu, 15 Apr 2021 16:13:19 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Gonglei <arei.gonglei@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] iommu/vt-d: Force to flush iotlb before creating
 superpage
Message-ID: <YHhJ/0b5i55zGib7@8bytes.org>
References: <20210415004628.1779-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415004628.1779-1-longpeng2@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 08:46:28AM +0800, Longpeng(Mike) wrote:
> Fixes: 6491d4d02893 ("intel-iommu: Free old page tables before creating superpage")
> Cc: <stable@vger.kernel.org> # v3.0+
> Link: https://lore.kernel.org/linux-iommu/670baaf8-4ff8-4e84-4be3-030b95ab5a5e@huawei.com/
> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> ---
> v1 -> v2:
>   - add Joerg
>   - reconstruct the solution base on the Baolu's suggestion
> ---
>  drivers/iommu/intel/iommu.c | 52 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 14 deletions(-)

Applied, thanks.

